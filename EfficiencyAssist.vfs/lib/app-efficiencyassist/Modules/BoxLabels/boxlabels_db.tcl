# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 09 10,2014
# Last revised: 2/27/18

proc ea::db::bl::getTplData {tpl} {
    global log GS_textVar tplLabel job
    
    if {$tpl eq $tplLabel(ID)} {
        # We already have the template loaded, if the user hits this button again with the same ID, lets assume that they want to clear out the widgets.
        set tpl ""
        set tplLabel(ID) ""
        set GS_textVar(Template) ""
        .container.frame0.entry configure -state normal
    } else {
        .container.frame0.entry configure -state disable
    }
    
    # reset vars just in case we've already ran this once before
    ea::code::lb::resetWidgets
    
    ${log}::debug Enabling widgets (none should be 'disabled')
    # Make sure widgets are enabled
    foreach item [winfo children .container.frame1] {
        if {[string match *entry* $item] == 1} {
            ${log}::debug Enable Widget: $item
            $item configure -state normal
        }
    }
    
    foreach item [winfo children .container.frame2.frame2a] {
        ${log}::debug Enable Widget: $item
        $item configure -state normal
    }
    
    # Clear out the widgets
    ${log}::debug Clearing out GS_textVar Row variables
    foreach item [array names GS_textVar Row*] {
        set GS_textVar($item) ""
    }
    
    # Clear out the box qty
    ${log}::debug Clear out GS_textVar(maxBoxQty)
    set GS_textVar(maxBoxQty) ""
    
    # Remove qty data
    ${log}::debug Clearing the quantity/shipment information
    Shipping_Code::clearList
    
    # clear out the version dropdown
    ${log}::debug Clearing out the version dropdown
    .container.frame0.cbox configure -values ""
    .container.frame0.cbox set ""
    
    ${log}::debug Reset some Job array variables
    set job(CustID) ""
    set job(CustName) ""
    set job(Title) ""
    set job(Title,id) ""
    set job(CSRName) ""
    
    # Set button text to 'Clear Data'
    .container.frame0.btn configure -text [mc "Clear Data"] 

    
    set tpl [string trim $tpl]
    ${log}::debug template id: $tpl

    # Retrieve the data and populate the tplLabel array
    if {$tpl != ""} {
        # Make sure that the number entered, matches the database.
        set idExist [db eval "SELECT tplID from LabelTPL WHERE tplID = $tpl"]
        if {$idExist == ""} {
            ${log}::debug $tpl doesn't match anything in the database. Clearing variables, and widgets...
            Error_Message::errorMsg BL001
            set GS_textVar(Template) ""
            # Set button text to 'Get Data'
            .container.frame0.btn configure -text [mc "Get Data"]
            .container.frame0.entry configure -state normal
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
            ${log}::debug File was last updated: [clock format [file mtime config.txt] -format %m-%d-%y]
        }
        
        # We entered a correct template number, but a title was never assigned.
        if {$job(Title,id) eq ""} {
            ${log}::critical Template $tpl exists, but a Title was never assigned
            set tplLabel(LabelPath) "" ;# Clear this out so the end-user doesn't keep going
            return
        }
        # Setup job vars
        db eval "SELECT TitleName, CustID, CSRID FROM PubTitle WHERE Title_ID = $job(Title,id) AND Status = 1" {
            set job(Title) $TitleName
            set job(CustID) $CustID
            set job(CustName) [join [db eval "SELECT CustName FROM Customer WHERE CUST_ID = '$job(CustID)' AND Status = 1"]]
            set job(CSRName) [db eval "SELECT FirstName, LastName FROM CSRs WHERE CSR_ID = '$CSRID' AND Status = 1"]
        }
    } else {
        ## id doesn't exist
        #Error_Message::errorMsg BL001
        ${log}::debug Id doesn't exist, resetting vars and button text
        # Set button text to 'Get Data'
        .container.frame0.btn configure -text [mc "Get Data"]
        return
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
    
    # Check runlist file for last modified date, if longer than 3 weeks ago issue an alert
}


proc ea::db::bl::getLabelText {} {
    global log tplLabel GS_textVar
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
            
            #set the active version, and disable the widget
            .container.frame0.cbox configure -values $tplLabel(LabelVersionDesc)
            .container.frame0.cbox set $tplLabel(LabelVersionDesc,current)
            .container.frame0.cbox state readonly
        }
    }
    ea::db::bl::populateWidget
}

proc ea::db::bl::populateWidget {} {
    global log tplLabel GS_textVar
    
    # Clear out the widgets
    foreach item [array names GS_textVar line*] {
        set GS_textVar($item) ""
    }
       
    # Populate the widgets with the first version
    db eval "SELECT labelRowNum, labelRowText, userEditable, LabelVersions.LabelVersionDesc FROM LabelData
                INNER JOIN LabelVersions ON LabelVersions.labelVersionID = LabelData.labelVersionID
                WHERE LabelVersions.LabelVersionDesc = '$tplLabel(LabelVersionDesc,current)' ORDER BY labelRowNum ASC" {
        # Add a zero if needed (all digits under 9 will need it)
        if {$labelRowNum <= 9} {
            set labelRowNum 0$labelRowNum
        }
        
        set GS_textVar(Row$labelRowNum) $labelRowText
        
        set labelRowNum_trimmed [string trim $labelRowNum 0]
        if {$userEditable != 1} {
            # Do not let the end user edit this field.
            .container.frame1.entry$labelRowNum_trimmed configure -state disable
        } else {
            # set the widget to edit
            .container.frame1.entry$labelRowNum_trimmed configure -state normal
        }
    }
    
    if {$tplLabel(SerializeLabel) == 1} {
        # disable all of the widgets if we are serializing or working off of a runlist with no user interaction
        ${log}::debug Disabling widgets in .container.frame2.frame2a (all row widgets)
        foreach child [winfo children .container.frame2.frame2a] {
                if {[string match *entry1 $child] == 1 || [string match *cbox* $child] == 1} {
                    $child configure -state disable
                }
        }
    }
    
    if {$tplLabel(LabelProfileID) == 0} {
        # Disable all of the row widgets, plus the shipment info widgets
        ${log}::debug Disabling widgets in .container.frame1 and .container.frame2.frame2a
        foreach child [winfo children .container.frame1] {
                if {[string match *entry* $child] == 1} {
                    $child configure -state disable
                }
        }
        
        foreach child [winfo children .container.frame2.frame2a] {
                if {[string match *entry* $child] == 1 || [string match *cbox* $child] == 1 || [string match *add* $child] == 1} {
                    $child configure -state disable
                }
        }
    }
}

###
### Ship to labels
###

proc ea::db::bl::getShipToData {wid_text} {
    global log job 
    
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
    set stmt [$monarch_db prepare "SELECT DISTINCT DESTINNAME, ADDRESS1, ADDRESS2, ADDRESS3, CITY, STATE, ZIP, COUNTRY, NUMCONTAINERS FROM EA.dbo.Planner_Shipping_View
                                WHERE JOBNAME = '$job(Number)'
                                AND ORDERID = '$job(ShipOrderID)'"]
    
    set res [$stmt execute]   
    # Clear the widget
    $wid_text delete 0.0 end
    
    ##Print the results
    while {[$res nextlist val]} {
        # Insert data into the widget
        set job(ShipToDestination) ""
        
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
        
        set job(ShipOrderNumPallets) [lindex $val 8]
    }
    set job(ShipOrderNumPallets) [lindex $val 8]
    set job(ShipToDestination) [join $job(ShipToDestination) " _n_ "]
    set job(ShipToDestination) [list $job(ShipToDestination)]
    $stmt close
    db2 close
}