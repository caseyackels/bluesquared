# Creator: Casey Ackels (C) 2017

# Retrieve Data
# NOT UPDATED
proc ea::db::ld::getLabelProfile {} {
    # Called by:
    ## ea::gui::ld::genLines
    ## Binding for Label Profile combobox
    global log tplLabel ldWid

    ea::db::ld::getNumRows

    ${log}::debug getLabelProfile started
    set col 0
    set rw 2
    set f2a $ldWid(addTpl,f2).f2a

    if {[winfo exists $f2a]} {destroy $f2a}

    if {$tplLabel(LabelProfileRowNum) != 0} {
        grid [ttk::frame $f2a] -column 0 -columnspan 4 -row 1

        grid [ttk::label $f2a.headerDesc -text [mc "Line Description"]] -column 1 -row 1 -pady 3p ;#-sticky e
        grid [ttk::label $f2a.headerUserEdit -text [mc "User Editable?"]] -column 2 -row 1 -pady 3p -ipadx 15 ;#-sticky e
        grid [ttk::label $f2a.headerVersionToggle -text [mc "Version?"]] -column 3 -row 1 -pady 3p -ipadx 15 ;#-sticky e
    }

    if {$tplLabel(ID) eq ""} {
        ${log}::debug tplLabel(ID) is empty, generating lines based off of selected profile $tplLabel(LabelProfileDesc)
        for {set x 1} {$x <= $tplLabel(LabelProfileRowNum)} {incr x} {
            grid [ttk::label $f2a.description$x -text [mc "Row $x"]] -column $col -row $rw -pady 2p -padx 2p -sticky e

            incr col
            grid [ttk::entry $f2a.labelData$x -width 35] -column $col -row $rw -pady 2p -padx 2p -sticky ew
            $f2a.labelData$x delete 0 end

            # Label Option / Editable?
            incr col
            set tplLabel(tmpValues,ckbtn,$x) 0
            grid [ttk::checkbutton $f2a.userEditable$x -variable tplLabel(tmpValues,ckbtn,$x)] -column $col -row $rw -pady 2p -padx 2p -ipadx 15 ;#-sticky ew

            # Label Option / Version?
            incr col
            #set tplLabel(tmpValues,rbtn) 0
            ${log}::debug ttk::radiobutton $f2a.isVersion$x -value $x -variable tplLabel(tmpValues,rbtn)
            grid [ttk::radiobutton $f2a.isVersion$x -value $x -variable tplLabel(tmpValues,rbtn)] -column $col -row $rw -pady 2p -padx 2p -ipadx 15 ;#-sticky ew

            # reset counters
            incr rw
            set col 0
        }
    } elseif {$tplLabel(ID) ne "" && $tplLabel(LabelVersionID,current) ne ""} {
        ${log}::debug labelTpl(ID) and LabelVersionID,current exists ...
        set x 1
        db eval "SELECT labelRowNum, labelRowText, userEditable, isVersion FROM LabelData WHERE labelVersionID = $tplLabel(LabelVersionID,current)" {
                ${log}::debug Row: $labelRowNum, $labelRowText, $userEditable, $isVersion
                # Row Labels
                grid [ttk::label $f2a.description$x -text [mc "Row $labelRowNum"]] -column $col -row $rw -pady 2p -padx 2p -sticky e

                # Label Data
                incr col
                grid [ttk::entry $f2a.labelData$x -width 35] -column $col -row $rw -pady 2p -padx 2p -sticky ew
                $f2a.labelData$x delete 0 end
                $f2a.labelData$x insert end $labelRowText

                # Label Option / Editable?
                incr col
                set tplLabel(tmpValues,ckbtn,$x) $userEditable
                grid [ttk::checkbutton $f2a.userEditable$x -variable tplLabel(tmpValues,ckbtn,$x)] -column $col -row $rw -pady 2p -padx 2p -ipadx 15 ;#-sticky ew

                # Label Option / Version?
                incr col
                grid [ttk::radiobutton $f2a.isVersion$x -value $x -variable tplLabel(tmpValues,rbtn)] -column $col -row $rw -pady 2p -padx 2p -ipadx 15 ;#-sticky ew
                if {$isVersion == 1} {$f2a.isVersion$x invoke}

                # reset counters
                incr rw
                incr x
                set col 0
            }
    } else {
        ${log}::debug getLabelProfile - ran out of conditions
        ${log}::debug Vars already set: $tplLabel(ID) and $tplLabel(LabelVersionID,current)
    }
} ;# ea::db::ld::getLabelProfile

proc ea::db::ld::getTemplateData {} {
    global ldWid log
    # This populates the main table listing the template id, template name, customer, title and status
    set monarch_db [tdbc::odbc::connection create db2 "Driver={SQL Server};Server=monarch-main;Database=ea;UID=labels;PWD=sh1pp1ng"]
    $ldWid(f1b).listbox delete 0 end

    db eval "SELECT DISTINCT(PubTitleID), Status FROM LabelTPL ORDER BY PubTitleID AND STATUS = 1" {
        if {$Status == 1} {
            set newStatus [mc Active]
        } else {
            set newStatus [mc Inactive]
        }
        # Retrieve Monarch Data
        ${log}::debug Retrieving data: $PubTitleID

        set company ""
        set stmt [$monarch_db prepare "SELECT TOP 1 COMPANYNAME, TITLENAME FROM EA.dbo.Customer_Jobs_Issues_CSR WHERE JOBID = '$PubTitleID'"]
        set res [$stmt execute]

        while {[$res nextlist val]} {
            set company [lindex $val 0]
            set title [lindex $val 1]
        }
        $stmt close
        if {$company ne ""} {
            #${log}::debug $ldWid(f1b).listbox insert end [list "" "$tplID" "$company" "$title" "$Status"]
            $ldWid(f1b).listbox insert end [list "" "$company" "$title" "$newStatus"]
        }
    }
    db2 close
} ;# ea::db::ld::getTemplateData

# Write Data
proc ea::db::ld::writeTemplate {} {
    # Updated 7/20
    # Invoked from ea::code::ld::saveTemplateHeader
    #
    # Save data to EA DB
    global log tplLabel job
    # Sanitize the label path since we are using data that could contain single quotes (i.e. Oakland's Best)
    # '[string map {' ''} $tplLabel(LabelPath)]'

    # Write Title ID
    ${log}::debug Title ID: $job(TitleID)

    # Template Name
    ${log}::debug Template Name: $tplLabel(Name)

    if {$tplLabel(ID) eq ""} {
        ${log}::notice Creating New Template for: $job(CustName)
        db eval "INSERT INTO LabelTPL (PubTitleID, tplLabelName, tplNotePriv, tplNotePub, Status)
                VALUES ($job(TitleID), '$tplLabel(Name)', '$tplLabel(NotePriv)', '$tplLabel(NotePub)', '$tplLabel(Status)')"

        # Get Template ID - First time
        set tplLabel(ID) [db eval "SELECT MAX(tplID) FROM LabelTPL WHERE PubTitleID = '$job(TitleID)'"]

    } else {
        # Update values
        ${log}::notice Updating existing template ($job(TitleID) / $job(CustName))
        db eval "UPDATE LabelTPL
                    SET tplLabelName = '$tplLabel(Name)',
                        tplNotePriv = '$tplLabel(NotePriv)',
                        tplNotePub = '$tplLabel(NotePub)',
                        Status = '$tplLabel(Status)'
                    WHERE tplID = $tplLabel(ID)"
    }
} ;# ea::db::ld::writeTemplate

proc ea::db::ld::writeLabelVersions {} {
    # Invoked from ea::code::ld::saveTemplateHeader
    #
    # Write the label data to the database (EA)
    # We never 'update' the data, we just delete and re-add.
    global log tplLabel job
    # ${log}::debug TABLE: LabelVersions
    # ${log}::debug Template id: $tplLabel(ID)
    # ${log}::debug Label Version Desc: $tplLabel(LabelVersionDesc,current)
    # ${log}::debug Serialize?: $tplLabel(SerializeLabel)
    # ${log}::debug Bartender Document: $tplLabel(LabelPath)
    # ${log}::debug Label Size: $tplLabel(LabelSize)
    # ${log}::debug Label Size ID: $tplLabel(LabelSizeID)
    # ${log}::debug Max Box Qty: $tplLabel(MaxBoxQty)

    if {$tplLabel(LabelVersionDesc,current) ne ""} {
        # Check to see if we've already added this version to the db, then remove if we have.
        set verExists ""
        set verExists [db eval "SELECT labelVersionID FROM LabelVersions WHERE tplID = $tplLabel(ID) AND LOWER(LabelVersionDesc) = LOWER('$tplLabel(LabelVersionDesc,current)')"]
        if {$verExists ne ""} {
            ${log}::debug Version ($tplLabel(LabelVersionDesc,current)) already exists... delete and re-insert?

            ${log}::debug REMOVE LabelShipQty
            ${log}::debug db eval "DELETE FROM LabelShipQty WHERE labelVersionID = $verExists"
            db eval "DELETE FROM LabelShipQty WHERE labelVersionID = $verExists"

            ${log}::debug REMOVE LabelData
            ${log}::debug db eval "DELETE FROM LabelData WHERE labelVersionID = $verExists"
            db eval "DELETE FROM LabelData WHERE labelVersionID = $verExists"

            ${log}::debug REMOVE LabelVersions
            ${log}::debug db eval "DELETE FROM LabelVersions WHERE labelVersionID = $verExists"
            db eval "DELETE FROM LabelVersions WHERE labelVersionID = $verExists"
        }

        # Add to the DB
        if {$tplLabel(MaxBoxQty) eq ""} {
            set maxboxQty NULL
        } else {
            set maxboxQty $tplLabel(MaxBoxQty)
        }


        ${log}::debug db eval "INSERT INTO LabelVersions (tplID, LabelSizeID, LabelBartenderDoc, LabelVersionDesc, LabelVersionSerialize, LabelVersionMaxBoxQty) VALUES ($tplLabel(ID), $tplLabel(LabelSizeID), '$tplLabel(LabelPath)', '$tplLabel(LabelVersionDesc,current)', $tplLabel(SerializeLabel), $maxboxQty)"
        db eval "INSERT INTO LabelVersions (tplID, LabelSizeID, LabelBartenderDoc, LabelVersionDesc, LabelVersionSerialize, LabelVersionMaxBoxQty) VALUES ($tplLabel(ID), $tplLabel(LabelSizeID), '$tplLabel(LabelPath)', '$tplLabel(LabelVersionDesc,current)', $tplLabel(SerializeLabel), $maxboxQty)"

        set tplLabel(LabelVersionID,current) [db eval "SELECT MAX(labelVersionID) FROM LabelVersions"]
        ${log}::debug set tplLabel(LabelVersionID,current)
        ea::db::ld::writeLabelData
        ea::db::ld::writeLabelShipQty

    } else {
        ${log}::notice Label Version is required, but is missing. Exiting.
    }
} ;# ea::db::ld::writeLabelVersions

proc ea::db::ld::writeLabelData {} {
    # Write out the actual text
    # Invoked from ea::db::ld::writeLabelVersions
    # tplLabel(LabelVersionID,current) is set in ea::db::ld::writeLabelVersions
    global log tplLabel ldWid
    ${log}::debug TABLE: LabelData

    if {$tplLabel(LabelVersionID,current) eq ""} {
        ${log}::debug LabelVersionID,current has no value. Exiting.
        return
    }
    # Delete any existing data before adding to the database
    #db eval "DELETE FROM LabelData WHERE labelVersionID = $tplLabel(LabelVersionID,current)"

    for {set x 0} {[$ldWid(f2b).listbox size] > $x} {incr x} {
        if {[$ldWid(f2b).listbox getcells $x,1] ne ""} {
            #${log}::debug [$ldWid(f2b).listbox get $x]
            foreach item [lrange [$ldWid(f2b).listbox get $x] 1 end] {
                lappend insItem '$item'
            }

            set insItem [join $insItem ,]
            ${log}::debug db eval "INSERT INTO LabelData (labelVersionID, labelRowNum, labelRowText, userEditable) VALUES ($tplLabel(LabelVersionID,current), $insItem)"
            db eval "INSERT INTO LabelData (labelVersionID, labelRowNum, labelRowText, userEditable) VALUES ($tplLabel(LabelVersionID,current), $insItem)"
        }

        if {[info exists insItem]} {unset insItem}
    }
} ;# ea::db::ld::writeLabelData

proc ea::db::ld::writeLabelShipQty {} {
    # Label version and label data has been written, now write the ship qty's.
    global log tplLabel ldWid

    ${log}::debug TABLE: LabelShipQty
    ${log}::debug Ship Qtys: [$ldWid(addTpl,f2b).lbox get 0 end]
    set qtyList [$ldWid(addTpl,f2b).lbox get 0 end]

    if {$qtyList eq ""} {
        ${log}::debug No quantities were entered, not writing to database.
        return
    }

    if {$tplLabel(LabelVersionID,current) eq ""} {
        ${log}::debug LabelVersionID,current has no value. Exiting.
        return
    }

    # Prepare for entering multiple entries
    foreach item $qtyList {
        lappend newQtyList ($tplLabel(LabelVersionID,current),$item)
        ${log}::debug $newQtyList
    }
    set newQtyList [join $newQtyList ,]

    ${log}::debug db eval "INSERT INTO LabelShipQty (labelVersionID, shipQty) VALUES $newQtyList"
    db eval "INSERT INTO LabelShipQty (labelVersionID, shipQty) VALUES $newQtyList"
} ;# ea::db::ld::writeLabelShipQty



##
## Helpers
##

proc ea::db::ld::getLabelVersionList {wid} {
    # Retrieve list of label versions
    global log tplLabel
    if {$tplLabel(ID) eq ""} {
        ${log}::debug (ea::db::ld::getLabelVersionList) Cannot continue tplLabel(ID) is empty
        return
    }

    ${log}::debug db eval "SELECT LabelVersionDesc FROM LabelVersions WHERE tplID = $tplLabel(ID) ORDER BY LOWER(LabelVersionDesc)"
    $wid configure -values [db eval "SELECT LabelVersionDesc FROM LabelVersions WHERE tplID = $tplLabel(ID) ORDER BY LOWER(LabelVersionDesc)"]
    #set tplLabel(LabelVersionDesc,current)
} ;# ea::db::ld::getLabelVersionList $wid

proc ea::db::ld::getLabelVersionID {} {
    # Retreive the ID of the current Label Version
    # Called from ea::db::ld::setLabelVersionVars
    global log tplLabel
    if {$tplLabel(ID) eq ""} {
        ${log}::debug (ea::db::ld::getLabelVersionID) Cannot continue tplLabel(ID) is empty
        set tplLabel(LabelVersionID,current) 0
        return
    }

    set tplLabel(LabelVersionID,current) [db eval "SELECT labelVersionID FROM LabelVersions WHERE tplID = $tplLabel(ID) AND LOWER(LabelVersionDesc) = LOWER('$tplLabel(LabelVersionDesc,current)]')"]
    # If blank, the user is probably entering a new version
    if {$tplLabel(LabelVersionID,current) == ""} {set tplLabel(LabelVersionID,current) 0}
} ;# ea::db::ld::getLabelVersionID

proc ea::db::ld::setLabelVersionVars {} {
    global log tplLabel
    # Set all variables, and populate widgets
    # ${log}::debug TABLE: LabelVersions
    # ${log}::debug Serialize?: $tplLabel(SerializeLabel)
    # ${log}::debug Bartender Document: $tplLabel(LabelPath)
    # ${log}::debug Label Size: $tplLabel(LabelSize)
    # ${log}::debug Label Size ID: $tplLabel(LabelSizeID)
    # ${log}::debug Max Box Qty: $tplLabel(MaxBoxQty)
    ea::db::ld::getLabelVersionID

    ${log}::debug Table: LabelVersions
    if {$tplLabel(LabelVersionID,current) == 0 || $tplLabel(LabelVersionID,current) == ""} {
        set tplLabel(LabelSizeID) ""
        set tplLabel(LabelPath) ""
        set tplLabel(SerializeLabel) 0
        set tplLabel(MaxBoxQty) ""
        set tplLabel(LabelSize) ""
    } else {
        db eval "SELECT LabelSizeID, LabelBartenderDoc, LabelVersionSerialize, LabelVersionMaxBoxQty FROM LabelVersions
                    WHERE labelVersionID = $tplLabel(LabelVersionID,current)" {
                        set tplLabel(LabelSizeID) $LabelSizeID
                        set tplLabel(LabelPath) $LabelBartenderDoc
                        set tplLabel(SerializeLabel) $LabelVersionSerialize
                        set tplLabel(MaxBoxQty) $LabelVersionMaxBoxQty
                    }

        set tplLabel(LabelSize) [join [db eval "SELECT labelSizeDesc FROM LabelSizes WHERE labelSizeID = $tplLabel(LabelSizeID)"]]
    }

    ea::db::ld::populateLabelVersionWids
} ;# ea::db::ld::setLabelVersionVars

proc ea::db::ld::populateLabelVersionWids {} {
    global log tplLabel ldWid

    # $ldWid(f2b).listbox - label data
    # $ldWid(addTpl,f2b).lbox - shipment qtys
    $ldWid(f2b).listbox delete 0 end
    db eval "SELECT labelRowNum, labelRowText, userEditable FROM LabelData WHERE labelVersionID = $tplLabel(LabelVersionID,current)" {
        $ldWid(f2b).listbox insert end [list {} $labelRowNum "$labelRowText" $userEditable]
        ${log}::debug [list {} $labelRowNum "$labelRowText" $userEditable]
        # Update values for the dropdown
    }

    # Populate the rest of the lines up to 10.
    for {set x [$ldWid(f2b).listbox size]} {10 > $x} {incr x} {$ldWid(f2b).listbox insert end ""}

    # Get ship quantities
    # Remove any data that may exist first
    $ldWid(addTpl,f2b).lbox delete 0 end

    ${log}::debug db eval "SELECT ShipQty FROM LabelShipQty WHERE labelVersionID = $tplLabel(LabelVersionID,current)"
    db eval "SELECT shipQty FROM LabelShipQty WHERE labelVersionID = $tplLabel(LabelVersionID,current)" {
        $ldWid(addTpl,f2b).lbox insert end $shipQty
    }
} ;# ea::db::ld::populateLabelVersionWids

proc ea::db::ld::isVersionUnique {tpl_id versionDesc} {
    # check to see if user-entered version is unique for the current template.
    # returns nothing if version is unique
    global log

    db eval "SELECT LabelVersionDesc FROM LabelVersions WHERE LabelVersionDesc = '$versionDesc' AND tplID = $tpl_id"
} ;# ea::db::ld::isVersionUnique

proc ea::db::ld::getTemplates {} {
    # Check the LabelTPL table in DB: EA
    global log tplLabel job ldWid
    ${log}::debug TitleID: $job(TitleID) / TitleName: $job(Title)
    set templatesExists [db eval "SELECT tplLabelName FROM LabelTPL WHERE PubTitleID = '$job(TitleID)'"]

    if {$templatesExists == ""} {
        ${log}::notice No templates found for Title: $job(TitleID)
        #$ldWid(addTpl,f1).cbox0a configure -values [db eval "SELECT tplLabelName FROM LabelTPL WHERE PubTitleID = 11"]

    } else {
        $ldWid(addTpl,f1).cbox0a configure -values $templatesExists
        $ldWid(addTpl,f1).cbox0a set [lindex $templatesExists 0]

        set tplLabel(ID) [db eval "SELECT tplID FROM LabelTPL WHERE PubTitleID = '$job(TitleID)' AND tplLabelName = '[$ldWid(addTpl,f1).cbox0a get]'"]
        ${log}::notice Templates found for Title: $job(TitleID), setting tplLabel(ID) to $tplLabel(ID)
    }
} ;# ea::db::ld::getTemplates

proc ea::db::ld::getTemplateID {title_id} {
    global log tplLabel job
    db eval "SELECT tplID FROM LabelTPL WHERE PubTitleID = $title_id"
} ;# ea::db::ld::getTemplateID

proc ea::db::ld::getCustomerList {} {
    global log tplLabel job

    set job(CustomerList) ""
    set monarch_db [tdbc::odbc::connection create db2 "Driver={SQL Server};Server=monarch-main;Database=ea;UID=labels;PWD=sh1pp1ng"]
    set stmt [$monarch_db prepare "SELECT DISTINCT COMPANYNAME FROM EA.dbo.Customer_Jobs_Issues_CSR"]

    set res [$stmt execute]

    while {[$res nextlist val]} {
        lappend job(CustomerList) $val
    }

    $stmt close
    db2 close

    ${log}::debug CustomerList retrieved
    set job(CustomerList) [join $job(CustomerList)]
} ;# ea::db::ld::getCustomerList

proc ea::db::ld::getCustomerTitles {} {
    global log job

    set job(CustomerTitles) ""
    set monarch_db [tdbc::odbc::connection create db2 "Driver={SQL Server};Server=monarch-main;Database=ea;UID=labels;PWD=sh1pp1ng"]
    set stmt [$monarch_db prepare "SELECT DISTINCT TITLENAME FROM EA.dbo.Customer_Jobs_Issues_CSR
                                    WHERE COMPANYNAME = '$job(CustName)'"]

    set res [$stmt execute]

    while {[$res nextlist val]} {
        lappend job(CustomerTitles) $val
        #puts $val
    }

    $stmt close
    db2 close

    ${log}::debug CustomerTitles retrieved
    set job(CustomerTitles) [join $job(CustomerTitles)]
} ;# ea::db::ld::getCustomerTitles

proc ea::db::ld::getCustomerTitleID {} {
    # Retrieve the ID of the selected Title, and the CSR
    # This will be used internally (ea db) and to prefix folders
    global log job

    set job(TitleID) ""
    set job_title [string map {' ''} $job(Title)]
    set monarch_db [tdbc::odbc::connection create db2 "Driver={SQL Server};Server=monarch-main;Database=ea;UID=labels;PWD=sh1pp1ng"]
    set stmt [$monarch_db prepare "SELECT TOP 1 JOBID, ACCOUNTMGR FROM EA.dbo.Customer_Jobs_Issues_CSR
                                    WHERE TITLENAME = '$job_title'"]

    set res [$stmt execute]

    while {[$res nextlist val]} {
        set job(TitleID) [lindex $val 0]
        set job(CSRID) [lindex $val 1]
        #puts $val
    }

    $stmt close
    db2 close

    set job(TitleID) [join $job(TitleID)]
    set job(CSRID) [join $job(CSRID)]
    ${log}::debug Monarch Title ID $job(TitleID) and CSR $job(CSRID) retrieved
} ;# ea::db::ld::getCustomerTitleID

proc ea::db::ld::getCustomerTitleName {title_id} {
    global log job

    set job(Title) ""
    set monarch_db [tdbc::odbc::connection create db2 "Driver={SQL Server};Server=monarch-main;Database=ea;UID=labels;PWD=sh1pp1ng"]
    set stmt [$monarch_db prepare "SELECT DISTINCT TITLENAME FROM EA.dbo.Customer_Jobs_Issues_CSR
                                    WHERE JOBID = '$title_id'"]

    set res [$stmt execute]

    while {[$res nextlist val]} {
        set job(Title) [join $val]
        #puts $val
    }

    $stmt close
    db2 close
} ;# ea::db::ld::getCustomerTitleName

proc ea::db::ld::getCustomerCode {} {
    global log job
    set job(CustID) ""
    set monarch_db [tdbc::odbc::connection create db2 "Driver={SQL Server};Server=monarch-main;Database=ea;UID=labels;PWD=sh1pp1ng"]
    set stmt [$monarch_db prepare "SELECT DISTINCT HAGEN_ID FROM EA.dbo.Customer_Jobs_Issues_CSR
                                    WHERE COMPANYNAME = '$job(CustName)'"]

    set res [$stmt execute]

    while {[$res nextlist val]} {
        lappend job(CustID) $val
        #puts $val
    }

    $stmt close
    db2 close

    ${log}::debug Customer Code retrieved
    set job(CustID) [join $job(CustID)]
} ;# ea::db::ld::getCustomerCode

proc ea::db::ld::getCustomerName {title_id} {
    global log job

    set job(CustName) ""
    set monarch_db [tdbc::odbc::connection create db2 "Driver={SQL Server};Server=monarch-main;Database=ea;UID=labels;PWD=sh1pp1ng"]
    set stmt [$monarch_db prepare "SELECT DISTINCT COMPANYNAME FROM EA.dbo.Customer_Jobs_Issues_CSR
                                    WHERE JOBID = '$title_id'"]

    set res [$stmt execute]

    while {[$res nextlist val]} {
        set job(CustName) [join $val]
        #puts $val
    }

    $stmt close
    db2 close
} ;# ea::db::ld::getCustomerName

proc ea::db::ld::getProfile {cbox} {
    global log

    $cbox configure -values [db eval "SELECT LabelProfileDesc FROM LabelProfiles ORDER BY LabelProfileID"]
} ;# ea::db::ld::getProfile

proc ea::db::ld::getLabelProfileID {profile} {
    global log tplLabel

    set tplLabel(LabelProfileID) [db eval "SELECT LabelProfileID FROM LabelProfiles WHERE LabelProfileDesc = '$profile'"]
} ;# ea::db::ld::getLabelProfileID

proc ea::db::ld::getNumRows {} {
    global log tplLabel

    db eval "SELECT COUNT(LabelHeadergrp.LabelHeaderID) FROM LabelHeaderGrp
            INNER JOIN LabelProfiles ON LabelHeaderGrp.LabelProfileID = LabelProfiles.LabelProfileID
            INNER JOIN LabelHeaders ON LabelHeaders.LabelHeaderID = LabelHeaderGrp.LabelHeaderID
        WHERE LabelProfiles.LabelProfileID = $tplLabel(LabelProfileID)
            AND LabelHeaders.LabelHeaderSystemOnly = 0" {
                set tplLabel(LabelProfileRowNum) $COUNT(LabelHeadergrp.LabelHeaderID)
            }

        ${log}::debug LabelProfileRowNum: $tplLabel(LabelProfileRowNum)
} ;# ea::db::ld::getNumRows

proc ea::db::ld::getSizes {cbox} {
    global log tplLabel

    $cbox configure -values [db eval "SELECT labelSizeDesc FROM LabelSizes"]
} ;# ea::db::ld::getSizes

proc ea::db::ld::getLabelSizeID {cbox} {
    global log tplLabel

    ${log}::debug Label Size Desc: [$cbox get]
    set tplLabel(LabelSizeID) [db eval "SELECT labelSizeID from LabelSizes where labelSizeDesc = '[$cbox get]'"]
}
