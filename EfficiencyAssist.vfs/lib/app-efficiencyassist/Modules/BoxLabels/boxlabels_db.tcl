# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 09 10,2014
# Last revised: 2/27/18

proc ea::db::bl::getTplData {tpl btn1 shipToWid shipListWid} {
    global log GS_textVar tplLabel job blWid labelText

    set tpl [string trim $tpl]
    ${log}::debug template id: $tpl

    # Retrieve the data and populate the tplLabel array
    if {$tpl != ""} {
        # Make sure that the number entered, matches the database.
        set idExist [db eval "SELECT tplID from LabelTPL WHERE tplID = $tpl"]
        if {$idExist == ""} {
            ${log}::notice Template: $tpl, doesn't match anything in the database. Clearing variables, and widgets...
            Error_Message::errorMsg BL001

            ea::code::bl::resetBoxLabels $btn1 $shipToWid $shipListWid

            return
        }

        set tplLabel(ID) $tpl
        # id exists, retrieving data
        db eval "SELECT PubTitleID, LabelProfileID, labelSizeID, tplLabelName, tplLabelPath, tplNotePub, tplFixedBoxQty, tplFixedLabelInfo, tplSerialize FROM LabelTPL WHERE tplID = $tplLabel(ID)" {
            set job(Title,id) $PubTitleID
            set tplLabel(LabelProfileID) $LabelProfileID
            set tplLabel(LabelSizeID) $labelSizeID
            set tplLabel(Name) $tplLabelName
            set tplLabel(LabelPath) $tplLabelPath
            set tplLabel(NotePub) $tplNotePub
            set tplLabel(FixedBoxQty) $tplFixedBoxQty
            set tplLabel(FixedLabelInfo) $tplFixedLabelInfo
            set tplLabel(SerializeLabel) $tplSerialize
        }

        if {$tplLabel(LabelProfileID) == 0} {
            ${log}::debug We're using a label that uses a run-list. Check modification date/time on runlist to see if it has been updated (less than a month)

            # Disable all widgets
            foreach item [winfo children $blWid(f0BL)] {
                if {[string match *entry* $item] || [string match *cbox* $item] == 1} {
                    ${log}::debug Disable Widget: $item
                    $item configure -state disabled
                }
            }

            foreach item [winfo children $blWid(f1BL)] {
                if {[string match *txt* $item] != 1} {
                    ${log}::debug Disable Widget: $item
                    $item configure -state disabled
                }
            }

        }

        # We entered a correct template number, but a title was never assigned.
        if {$job(Title,id) eq ""} {
            ${log}::critical Template $tpl exists, but a Title was never assigned
            set tplLabel(LabelPath) "" ;# Clear this out so the end-user doesn't keep going
            return
        }
    }

    # Get Profile Info
    if {$tplLabel(LabelProfileID) != 0} {
        # If the value is 0, that means we do not have a set profile. The label file contains all data, we are just printing the labels.
        set tplLabel(LabelProfileDesc) [db eval "SELECT LabelProfileDesc FROM LabelProfiles WHERE LabelProfileID = $tplLabel(LabelProfileID)"]

    } else {
        set tplLabel(LabelProfileDesc) default
    }

    # Get Label size info
    set tplLabel(Size) [db eval "SELECT labelSizeDesc FROM LabelSizes WHERE labelSizeID = $tplLabel(LabelSizeID)"]

    if {$tplLabel(FixedBoxQty) != ""} {
        set GS_textVar(maxBoxQty) $tplLabel(FixedBoxQty)
    }

    # Populate the widgets with the label data
    ea::db::bl::getLabelText
} ;# ea::db::bl::getTplData


proc ea::db::bl::getLabelText {} {
    global log tplLabel GS_textVar blWid
    # Find out if we have label text, and if we do populate the text widgets with the data.

    if {$tplLabel(LabelProfileID) != 0} {
        # No need to issue this query if the LabelProfileID is 0, since that is reserved for a no-user interaction label
        # Retrieve the versions
            db eval "SELECT labelVersionID, LabelVersionDesc FROM LabelVersions WHERE tplID = $tplLabel(ID)" {
                lappend tplLabel(LabelVersionID) $labelVersionID
                lappend tplLabel(LabelVersionDesc) $LabelVersionDesc
            }

        # Do we need to retrieve label text?
        if {$tplLabel(FixedLabelInfo) != 0 && $tplLabel(LabelVersionID) != 0} {

            # Get first version
            db eval "SELECT min(ROWID), labelVersionID, LabelVersionDesc FROM LabelVersions WHERE tplID = $tplLabel(ID)" {
                set tplLabel(LabelVersionID,current) $labelVersionID
                set tplLabel(LabelVersionDesc,current) $LabelVersionDesc
            }

            # Set the active version, and disable the widget
            $blWid(f0BL).cbox1 configure -values $tplLabel(LabelVersionDesc)
            $blWid(f0BL).cbox1 set $tplLabel(LabelVersionDesc,current)
            #$blWid(f0BL).cbox1 state readonly
        }
        ea::db::bl::populateWidget
    } else {
        # if the profile is empty, we want to issue a notice to the user that no data will populate the screen
        Error_Message::errorMsg BL007
    }
} ;# ea::db::bl::getLabelText

proc ea::db::bl::populateWidget {} {
    global log tplLabel GS_textVar labelText blWid

    # Clear out the widgets
    foreach item [array names labelText] {
        set labelText($item) ""
    }

    # Populate the widgets with the first version
    db eval "SELECT labelRowNum, labelRowText, userEditable, LabelVersions.LabelVersionDesc FROM LabelData
                INNER JOIN LabelVersions ON LabelVersions.labelVersionID = LabelData.labelVersionID
                WHERE LabelVersions.LabelVersionDesc = '$tplLabel(LabelVersionDesc,current)' ORDER BY labelRowNum ASC" {
                    # Add a zero if needed (all digits under 9 will need it)
                    if {[string length $labelRowNum] == 1} {
                      set labelRowNum 0$labelRowNum
                    }

                    set labelText(Row$labelRowNum) $labelRowText

                    set labelRowNum_trimmed [string trim $labelRowNum 0]
                    if {$userEditable != 1} {
                        # Do not let the end user edit this field.
                        $blWid(f0BL).entry$labelRowNum_trimmed configure -state disable
                    } else {
                        # set the widget to edit
                        $blWid(f0BL).entry$labelRowNum_trimmed configure -state normal
                    }
                }
} ;# ea::db::bl::populateWidget

###
### Ship to labels
###

proc ea::db::bl::getShipToData {btn wid_text} {
    global log job

    if {$job(Number) eq ""} {${log}::debug getShipToData: Exiting, $job(Number) (Job Number) is empty; return}
    if {$job(ShipOrderID) eq ""} {${log}::debug getShipToData: Exiting, $job(ShipOrderID) (Ship Order ID) is empty ; return}

    ${log}::debug $job(Number) - $job(ShipOrderID)

    set monarch_db [tdbc::odbc::connection create db2 "Driver={SQL Server};Server=monarch-main;Database=ea;UID=labels;PWD=sh1pp1ng"]
    #### BOX LABELS
    #set stmt [$monarch_db prepare {SELECT TITLENAME
    #                                ,ISSUENAME
    #                                ,ALIASNAME
    #                                ,SHIPCOUNT
    #                                ,DISTRIBNAME
    #                                ,PACKAGENAME
    #                            FROM EA.dbo.Planner_Shipping_View
    #                            WHERE JOBNAME='315778'
    #                            AND PACKAGENAME LIKE '%Ctn%'}]
    #
    #### Ship To
    set stmt [$monarch_db prepare "SELECT DISTINCT DESTINNAME, ADDRESS1, ADDRESS2, ADDRESS3, CITY, STATE, ZIP, COUNTRY, NUMCONTAINERS
                                FROM EA.dbo.Planner_Shipping_View
                                WHERE JOBNAME = '$job(Number)'
                                AND ORDERID = '$job(ShipOrderID)'"]

    set res [$stmt execute]
    # Clear the widget
    $wid_text delete 0.0 end

    ##Print the results
    while {[$res nextlist val]} {
        # Insert data into the widget
        set job(ShipToDestination) ""

        # set address to all upper case
        set val [string toupper $val]

        ${log}::debug length [llength $val]
        ${log}::debug Ship to: $val
        set val_length [llength $val]

        $wid_text insert end [lindex $val 0]\n
        lappend job(ShipToDestination) [lindex $val 0]

        $wid_text insert end [lindex $val 1]\n
        lappend job(ShipToDestination) [lindex $val 1]

        if {[lindex $val 2] ne ""} {
            $wid_text insert end [lindex $val 2]\n
            lappend job(ShipToDestination) [lindex $val 2]
        }

        if {[lindex $val 3] ne ""} {
            $wid_text insert end [lindex $val 3]\n
            lappend job(ShipToDestination) [lindex $val 3]
        }
        $wid_text insert end "[lindex $val 4] [lindex $val 5] [lindex $val 6] \n"
        lappend job(ShipToDestination) "[lindex $val 4] [lindex $val 5] [lindex $val 6]"

        $wid_text insert end [lindex $val 7]
        lappend job(ShipToDestination) [lindex $val 7]

        #set job(ShipOrderNumPallets) [lindex $val 8]
    }
    set job(ShipOrderNumPallets) [lindex $val 8]
    set job(ShipToDestination) [join $job(ShipToDestination) " _n_ "]
    set job(ShipToDestination) [list $job(ShipToDestination)]
    $stmt close
    db2 close

    #$btn configure -text [mc "Reset"] -command "Shipping_Code::resetShipTo $btn $wid_text"
} ;# ea::db::bl::getShipToData

proc ea::db::bl::getJobData {btn1 wid shipToWid shipListWid} {
    global log job labelText blWid
    # First version
    # Populate customer info, label info, ship counts and Ship Order IDs.
    if {$job(Number) eq "" && $job(Template) eq ""} {return}
    if {$job(Number) eq "" && $job(Template) ne ""} {
        ${log}::notice We are looking for template: $job(Template) but a job number does not exist.
        Error_Message::errorMsg BL005
        return
    }

    if {[string length $job(Number)] < 6} {
        ${log}::notice The job number is less than 5 numbers. Aborting.
        Error_Message::errorMesg BL006
        return
    }

    ${log}::debug btn1: $btn1 - shipToWid: $shipToWid - shipListWid: $shipListWid

    $btn1 configure -text [mc "Reset"] -command "ea::code::bl::resetBoxLabels $btn1 $shipToWid $shipListWid"

    # Disable entry widgets
    $blWid(f).entry1 state disabled
    $blWid(f).entry2 state disabled

    set monarch_db [tdbc::odbc::connection create db2 "Driver={SQL Server};Server=monarch-main;Database=ea;UID=labels;PWD=sh1pp1ng"]


    # Job Data
    set stmt [$monarch_db prepare "SELECT TOP 1 CUSTOMERNAME, TITLENAME, ISSUENAME
                                        FROM EA.dbo.Planner_Shipping_View
                                        WHERE JOBNAME='$job(Number)'"]

    set res [$stmt execute]

    while {[$res nextlist val]} {
        set job(CustName) [lindex $val 0]
        set job(Title) [lindex $val 1]
        set job(Name) [lindex $val 2]
    }

    $stmt close


    # Retrieve ship order id's
    # Reset ShipToOrderIDs so we aren't just adding to the list
    set job(ShipToOrderIDs) ""
    set stmt [$monarch_db prepare "SELECT DISTINCT ORDERID
                                        FROM EA.dbo.Planner_Shipping_View
                                        WHERE JOBNAME='$job(Number)'
                                        AND CONTAINERNAME IS NOT NULL
                                        AND DESTINNAME NOT LIKE 'JG%'
                                        AND (DISTRIBNAME NOT LIKE '06%' OR DISTRIBNAME NOT LIKE '%mail%')
                                        ORDER BY ORDERID"]
    set res [$stmt execute]
    while {[$res nextlist val]} {
        lappend job(ShipToOrderIDs) $val
    }
    $blWid(tab2f1).cbox1 configure -values $job(ShipToOrderIDs)

    set job(ShipOrderID) [lindex $job(ShipToOrderIDs) 0]
    $blWid(tab2f1).cbox1 set $job(ShipOrderID)

    $stmt close
    db2 close

    ea::db::bl::getShipToData {} $blWid(tab2f2).txt

    # Check for Templates
    set job(Description) "$job(Title) | $job(Name)"
    if {$job(Template) ne "" } {
        ${log}::debug We have a template: $job(Template)
        ea::db::bl::getTplData $job(Template) $btn1 $shipToWid $shipListWid

    } else {
        ea::db::bl::getAllVersions $wid 1
        ea::db::bl::getShipCounts

        set labelText(Row01) [string toupper $job(Title)]
        set labelText(Row02) [string toupper $job(Name)]
    }
} ;# ea::db::bl::getJobData

proc ea::db::bl::getAllVersions {wid args} {
    global log job labelText
    # Get list of versions

    # Exit out if no job number
    if {$job(Number) eq ""} {return}

    # Handle versions differently if we're using a template
    if {$job(Template) ne "" || $job(Template) != 0} {
      ${log}::debug getAllVersions: We are using a template, not displaying Versions from Monarch
      ea::db::bl::getTplVersions
      return
    }

    # Ensure var is empty
    set job(Versions) ""


    set monarch_db [tdbc::odbc::connection create db2 "Driver={SQL Server};Server=monarch-main;Database=ea;UID=labels;PWD=sh1pp1ng"]
    set stmt [$monarch_db prepare "SELECT DISTINCT ALIASNAME
                                        FROM EA.dbo.Planner_Shipping_View
                                        WHERE JOBNAME='$job(Number)'
                                        AND (DISTRIBNAME LIKE '%customer%' OR DISTRIBNAME LIKE '%freight%' OR DISTRIBNAME LIKE '%package%')
                                        AND PACKAGENAME LIKE '%ctn%'
                                        ORDER BY ALIASNAME"]
    set res [$stmt execute]

    while {[$res nextlist val]} {
        ${log}::debug Versions with boxes: $val
        lappend job(Versions) [join [string toupper $val]]
    }

    $stmt close

    # See if we have one or multiple versions on the job. IF we only have one version, do not populate Row03
    set stmt [$monarch_db prepare "SELECT DISTINCT ALIASNAME
                                        FROM EA.dbo.Planner_Shipping_View
                                        WHERE JOBNAME='$job(Number)'"]

    set res [$stmt execute]

    set job(TotalVersions) ""
    while {[$res nextlist val]} {
        ${log}::debug Total Versions: $val
        lappend job(TotalVersions) [join $val]
    }

    db2 close

    ${log}::debug List of versions: $job(TotalVersions)

    # Populating the dropdown with the versions, and setting the selection to the first result.
    set job(Version) [lindex $job(TotalVersions) 0]
    $wid configure -values $job(TotalVersions)
    $wid set $job(Version)

    # If we only have one version, don't populate the label text
    if {[llength $job(TotalVersions)] > 1} {
        set labelText(Row03) $job(Version)
    }

    #if {$args eq 1} {
    #    # First time running for this job
    #    set job(Version) [lindex $job(Versions) 0]
    #    $wid configure -values $job(Versions)
    #    $wid set $job(Version)
    #
    #    # If we only have one version, don't populate the label text
    #    if {[llength $job(TotalVersions)] > 1} {
    #        set labelText(Row03) $job(Version)
    #    }
    #}


    #if {$wid ne ""} {
    #    $wid configure -values [join $job(Versions)]
    #    $wid set $labelText(Row3)
    #}
} ;# ea::db::bl::getAllVersions

proc ea::db::bl::getTplVersions {} {
  global log job tplLabel blWid labelText

  ${log}::debug getTplVersions: Current Version: [$blWid(f0BL).cbox1 get]

  db eval "SELECT labelRowNum, labelRowText FROM LabelData
            JOIN LabelVersions ON LabelData.labelVersionID = LabelVersions.labelVersionID
            WHERE tplID = '$tplLabel(ID)'
            AND LabelVersionDesc = '[$blWid(f0BL).cbox1 get]'" {
              ${log}::debug $labelRowNum, $labelRowText
              set labelText(Row$labelRowNum) $labelRowText
            }

} ;# ea::db::bl::getTplVersions

proc ea::db::bl::getShipCounts {} {
    global log job blWid

    # Make sure we start with an empty widget
    $blWid(f2BL).listbox delete 0 end
    ${log}::debug getShipCounts: Deleting data from the tablelist
    ${log}::debug getShipCounts: Retrieving data for version: $job(Version)

    # Ensure var is empty
    set job(ShipCount) ""
    set monarch_db [tdbc::odbc::connection create db2 "Driver={SQL Server};Server=monarch-main;Database=ea;UID=labels;PWD=sh1pp1ng"]
    set stmt [$monarch_db prepare "SELECT ORDERID, SHIPCOUNT, DISTRIBNAME
                                        FROM EA.dbo.Planner_Shipping_View
                                        WHERE JOBNAME = '$job(Number)'
                                        AND ALIASNAME = '$job(Version)'
                                        AND (DISTRIBNAME LIKE '%customer%' OR DISTRIBNAME LIKE '%freight%' OR DISTRIBNAME LIKE '%package%')
                                        AND PACKAGENAME LIKE '%ctn%'
                                        ORDER BY ORDERID"]
    set res [$stmt execute]

    while {[$res nextlist val]} {
        #lappend job(ShipCount) [lindex $val 0]
        ${log}::debug Insert into Table: $val
        $blWid(f2BL).listbox insert end "{} $val"
    }

    $stmt close
    db2 close

    ea::code::bl::trackTotalQuantities
} ;# ea::db::bl::getShipCounts
