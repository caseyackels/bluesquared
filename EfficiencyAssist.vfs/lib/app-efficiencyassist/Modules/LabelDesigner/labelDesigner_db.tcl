# Creator: Casey Ackels (C) 2017

# Retrieve Data
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
            $ldWid(f1b).listbox insert end [list "" "$company" "$title" "$Status"]
        }
    }
    db2 close
} ;# ea::db::ld::getTemplateData

# Write Data
proc ea::db::ld::writeTemplate {} {
    # Invoked from ea::code::ld::saveTemplateHeader
    #
    # Save data to EA DB
    global log tplLabel job

    # Write Title ID
    ${log}::debug Title ID: $job(TitleID)

    # Profile ID
    ${log}::debug Profile: [ea::db::ld::getLabelProfileID $tplLabel(LabelProfileDesc)]

    # Template Name
    ${log}::debug Template Name: $tplLabel(Name)

    # Template Label Path (Document)
    ${log}::debug Label Document: $tplLabel(LabelPath)

    # Fixed Box Qty (Boolean)
    ${log}::debug Fixed Box Qty: $tplLabel(FixedBoxQty)

    # Fixed Label Info (boolean)
    ${log}::debug Fixed Label Info: $tplLabel(FixedLabelInfo)

    # Serialize (boolean)
    ${log}::debug Serialize: $tplLabel(SerializeLabel)


    if {$tplLabel(ID) eq ""} {
        ${log}::notice Creating New Template for: $job(CustName)
        #set tplLabel(LabelPath) [string map {'' '} $tplLabel(LabelPath)]
        db eval "INSERT INTO LabelTPL (PubTitleID, LabelProfileID, tplLabelName, tplLabelPath, tplNotePriv, tplNotePub, tplFixedBoxQty, tplFixedLabelInfo, tplSerialize, Status)
                VALUES ($job(TitleID), $tplLabel(LabelProfileID), '$tplLabel(Name)', '[string map {' ''} $tplLabel(LabelPath)]', '$tplLabel(NotePriv)', '$tplLabel(NotePub)', '$tplLabel(FixedBoxQty)', '$tplLabel(FixedLabelInfo)', '$tplLabel(SerializeLabel)', '$tplLabel(Status)')"

        # Get Template ID - First time
        set tplLabel(ID) [db eval "SELECT MAX(tplID) FROM LabelTPL WHERE PubTitleID = '$job(TitleID)'"]

    } else {
        # Update values
        # NOT TESTED
        ${log}::notice Updating existing template ($job(TitleID) / $job(CustName))
        db eval "UPDATE LabelTPL
                    SET LabelProfileID = $tplLabel(LabelProfileID),
                        tplLabelName = '$tplLabel(Name)',
                        tplLabelPath = '[string map {' ''} $tplLabel(LabelPath)]',
                        tplNotePriv = '$tplLabel(NotePriv)',
                        tplNotePub = '$tplLabel(NotePub)',
                        tplFixedBoxQty = '$tplLabel(FixedBoxQty)',
                        tplFixedLabelInfo = '$tplLabel(FixedLabelInfo)',
                        tplSerialize = '$tplLabel(SerializeLabel)',
                        Status = '$tplLabel(Status)'
                    WHERE tplID = $tplLabel(ID)"

    }
} ;# ea::db::ld::writeTemplate

proc ea::db::ld::writeLabelData {} {
    # Invoked from ea::code::ld::saveTemplateHeader
    #
    # Write the label data to the database (EA)
    # We never 'update' the data, we just delete and re-add.
    global log tplLabel job ldWid


    # Check if the label profile allows text/etc
    set haveData [db eval "SELECT LabelHeaders.LabelHeaderID FROM LabelHeaderGrp
                            INNER JOIN LabelHeaders ON LabelHeaders.LabelHeaderID = LabelHeaderGrp.LabelHeaderID
                            INNER JOIN LabelProfiles ON LabelProfiles.LabelProfileID = LabelHeaderGrp.LabelProfileID
                                WHERE LabelHeaderGrp.LabelProfileID = $tplLabel(LabelProfileID)
                                AND LabelHeaders.LabelHeaderSystemOnly = 0"]
    if {$haveData ne ""} {
        # Check if labelVersionID exists
        #  - Doesn't Exist; Insert labelVersionID, Insert Row Data
        # - Exists; Delete Row Data, then Insert

        # Check to see if a new 'version' has been entered (typically happens on multi-version jobs)
        #set newVersion [$ldWid(addTpl,f2).f2a.labelData$tplLabel(tmpValues,rbtn) get]
        set newVersion [$ldWid(addTpl,f2).versionDescCbox get]
        if {[ea::db::ld::isVersionUnique $tplLabel(ID) $newVersion] ne ""} {${log}::debug Version isn't unique, exiting. ; return}

        if {$tplLabel(LabelVersionID,current) eq "" && $tplLabel(LabelVersionDesc,current) eq ""} {
            # This is a new version, insert only. (Table: LabelVersions)
            ${log}::notice LabelVersion ID doesn't exist, but Description ($newVersion) does. Retrieving...
            #${log}::notice LabelVersion Row: $tplLabel(tmpValues,rbtn) [$ldWid(addTpl,f2).f2a.labelData$tplLabel(tmpValues,rbtn) get]
            ${log}::debug db eval "INSERT INTO LabelVersions (tplID, LabelVersionDesc) VALUES ($tplLabel(ID), '$newVersion')"

            db eval "INSERT INTO LabelVersions (tplID, LabelVersionDesc) VALUES ($tplLabel(ID), '$newVersion')"

            # Get version id
            set tplLabel(LabelVersionID,current) [db eval "SELECT max(labelVersionID) FROM LabelVersions WHERE tplID = $tplLabel(ID)"]
            set tplLabel(LabelVersionDesc,current) $newVersion
            ${log}::notice Retrieving new version ID: $tplLabel(LabelVersionID,current)

            # Insert label date (Table: LabelData)
            set data [join [ea::code::ld::getRowData $tplLabel(LabelVersionID,current) $ldWid(addTpl,f2).f2a]]
            ${log}::notice Inserting Row Data: $data
            ${log}::debug db eval "INSERT INTO LabelData (labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES $data"
            db eval "INSERT INTO LabelData (labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES $data"

            # Populate the dropdown
            set c_list [$ldWid(addTpl,f2).versionDescCbox cget -values]
            lappend c_list $newVersion
            $ldWid(addTpl,f2).versionDescCbox configure -values $c_list

        } elseif {[string equal $tplLabel(LabelVersionDesc,current) $newVersion] == 0} {
            # Check to see if a new 'version' has been entered (typically happens on multi-version jobs)
            ${log}::notice New Label Version detected

            # Inserting Version info
            db eval "INSERT INTO LabelVersions (tplID, LabelVersionDesc) VALUES ($tplLabel(ID), '$newVersion')"
            set tplLabel(LabelVersionID,current) [db eval "SELECT max(labelVersionID) FROM LabelVersions WHERE tplID = $tplLabel(ID)"]
            ${log}::notice Retrieving new version ID: $tplLabel(LabelVersionID,current)

            set data [join [ea::code::ld::getRowData $tplLabel(LabelVersionID,current) $ldWid(addTpl,f2).f2a]]
            ${log}::notice Inserting Row Data: $data

            ${log}::debug db eval "INSERT INTO LabelData (labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES $data"
            db eval "INSERT INTO LabelData (labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES $data"

        } else {
            # Remove existing data, and repopulate using existing LabelVersionID,current
            ${log}::debug LabelVersionID,current: $tplLabel(LabelVersionID,current)
            ${log}::notice Delete existing data for $tplLabel(LabelVersionDesc,current)
            ${log}::debug db eval "DELETE FROM LabelData WHERE labelVersionID = $tplLabel(LabelVersionID,current)"
            db eval "DELETE FROM LabelData WHERE labelVersionID = $tplLabel(LabelVersionID,current)"

            ${log}::notice Entering new data for $tplLabel(LabelVersionDesc,current)
            set data [join [ea::code::ld::getRowData $tplLabel(LabelVersionID,current) $ldWid(addTpl,f2).f2a]]
            ${log}::debug db eval "INSERT INTO LabelData (labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES $data"
            db eval "INSERT INTO LabelData (labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES $data"
        }


        # Update drop down values
        $ldWid(addTpl,f2).versionDescCbox configure -values [db eval "SELECT LabelVersionDesc FROM LabelVersions WHERE tplID = $tplLabel(ID)"]
    }
} ;# ea::db::ld::writeLabelData

##
## Helpers
##

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
        ${log}::notice Templates found for Title: $job(TitleID)
        $ldWid(addTpl,f1).cbox0a configure -values $templatesExists

        $ldWid(addTpl,f1).cbox0a set [lindex $templatesExists 0]
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

proc ea::db::ld::getLabelVersions {tpl_id} {
    # Retrieve the label versions associated with the templates
    global log tplLabel

    # Make sure the vars are cleared out
    set tplLabel(LabelVersionID) ""
    set tplLabel(LabelVersionDesc) ""

    db eval "SELECT LabelVersionID, LabelVersionDesc FROM LabelVersions WHERE PubTitleID = $tpl_id" {
        lappend tplLabel(LabelVersionID) $LabelVersionID
        lappend tplLabel(LabelVersionDesc) $LabelVersionDesc
    }

    ${log}::debug Retreived LabelVersionDesc and LabelVersionID

    set tplLabel(LabelVersionID,current) [lindex $tplLabel(LabelVersionID) 0]
    set tplLabel(LabelVersionDesc,current) [lindex $tplLabel(LabelVersionDesc) 0]

    ${log}::debug Selected Versions: $tplLabel(LabelVersionID,current) $tplLabel(LabelVersionDesc,current)
} ;# ea::db::ld::getLabelVersions

### Original
proc ea::db::ld::getLabelNames {cbox} {
    global log tplLabel job

    if {$job(Title) eq ""} {return}
    if {$job(CustID) eq ""} {return}

    set tmpPubTitleID [db eval "SELECT Title_ID FROM PubTitle WHERE TitleName = '$job(Title)' AND CustID = '$job(CustID)'"]
    ${log}::debug TemplateID exists? ($tmpPubTitleID)

    if {$tmpPubTitleID ne ""} {
        set labelNames [db eval "SELECT tplLabelName FROM LabelTPL WHERE PubTitleID = $tmpPubTitleID AND Status = 1"]

        if {$labelNames ne ""} {
            $cbox configure -values $labelNames

            ${log}::debug Label info exists, populate all widgets: Label Path, Width, Height, NumRows, FixedBoxQty, FixedRowInfo
        } else {
            ${log}::debug No labels exist
        }
    } else {
        ${log}::debug TemplateID doesn't exist, no value set
        $cbox configure -values ""
    }
} ;# ea::db::ld::getLabelNames

proc ea::db::ld::getLabelSpecs {cbox} {
    global log tplLabel job

    ${log}::debug cbox: $cbox

    set tmpLabelName [$cbox get]
    set tmpPubTitleID [db eval "SELECT Title_ID FROM PubTitle WHERE TitleName = '$job(Title)' AND CustID = '$job(CustID)'"]

    if {$tmpPubTitleID eq ""} {$cbox configure -values ""; ${log}::debug Title_ID is empty, exiting...; return}

    ${log}::debug tmpLabelName: $tmpLabelName
    ${log}::debug tmpPubTitleID: $tmpPubTitleID

    db eval "SELECT tplID, LabelTPL.LabelProfileID, LabelProfiles.LabelProfileDesc as LabelProfileDesc, tplLabelPath, LabelSizes.labelSizeDesc as Sizes, tplFixedBoxQty, tplFixedLabelInfo, tplSerialize
                FROM LabelTPL
                INNER JOIN LabelSizes ON LabelTPL.labelSizeID = LabelSizes.labelSizeID
                INNER JOIN LabelProfiles ON LabelTPL.LabelProfileID = LabelProfiles.LabelProfileID
            WHERE PubTitleID = $tmpPubTitleID AND tplLabelName = '$tmpLabelName'" {
                set tplLabel(ID) $tplID
                set tplLabel(LabelProfileID) $LabelProfileID
                set tplLabel(LabelProfileDesc) $LabelProfileDesc
                set tplLabel(LabelPath) $tplLabelPath
                set tplLabel(Size) $Sizes
                set tplLabel(FixedBoxQty) $tplFixedBoxQty
                set tplLabel(FixedLabelInfo) $tplFixedLabelInfo
                set tplLabel(SerializeLabel) $tplSerialize
    }

    # Do we have label versions?
    # clear the variables before creating widgets just in case we dont' have versions/label data
    set tplLabel(LabelVersionDesc) ""
    set tplLabel(LabelVersionDesc,current) ""
    set tplLabel(LabelVersionID) ""
    set tplLabel(LabelVersionID,current) ""

    db eval "SELECT labelVersionID, LabelVersionDesc FROM LabelVersions WHERE tplID = $tplLabel(ID)" {
        lappend tplLabel(LabelVersionID) $labelVersionID
        lappend tplLabel(LabelVersionDesc) $LabelVersionDesc
    }

    if {$tplLabel(LabelVersionID) eq ""} {${log}::debug No Versions detected.}

    # Do we need to retrieve label text?
    if {$tplLabel(FixedLabelInfo) != 0 && $tplLabel(LabelVersionID) != 0} {

        # Get first version
        db eval "SELECT min(ROWID), labelVersionID, LabelVersionDesc FROM LabelVersions WHERE tplID = $tplLabel(ID)" {
            set tplLabel(LabelVersionID,current) $labelVersionID
            set tplLabel(LabelVersionDesc,current) $LabelVersionDesc
        }

        ea::db::ld::setProfileVars
    }
} ;# ea::db::ld::getLabelSpecs

proc ea::db::ld::getVersionLabel {} {
    global log tplLabel ldWid

    ${log}::debug getVersionLabel started
    set col 0
    set rw 2
    set f2a $ldWid(addTpl,f2).f2a

    if {[winfo exists $f2a]} {destroy $f2a}

    grid [ttk::frame $f2a] -column 0 -columnspan 2 -row 1

    grid [ttk::label $f2a.headerDesc -text [mc "Line Description"]] -column 1 -row 1 -pady 3p ;#-sticky e
    grid [ttk::label $f2a.headerUserEdit -text [mc "User Editable?"]] -column 2 -row 1 -pady 3p -ipadx 15 ;#-sticky e
    grid [ttk::label $f2a.headerVersionToggle -text [mc "Version?"]] -column 3 -row 1 -pady 3p -ipadx 15 ;#-sticky e

    if {$tplLabel(ID) eq ""} {
        ${log}::debug tplLabel(ID) is empty, generating lines based off of selected profile $tplLabel(ProfileDesc)
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

    } elseif {$tplLabel(LabelVersionID,current) eq ""} {
        ${log}::debug LabelVersionID,current is empty. Creating widgets without data.
        # This will occur if the user selects a Profile that contains label data, but exits EA before creating atleast one version

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
            set tplLabel(tmpValues,rbtn) 0
            grid [ttk::radiobutton $f2a.isVersion$x -value $x -variable tplLabel(tmpValues,rbtn)] -column $col -row $rw -pady 2p -padx 2p -ipadx 15 ;#-sticky ew

            # reset counters
            incr rw
            set col 0
        }
    } else {
        ${log}::debug tpl(id) and labelVersionID,current exists ...
        set x 1
        db eval "SELECT labelRowNum, labelRowText, userEditable, isVersion FROM LabelData WHERE labelVersionID = '$tplLabel(LabelVersionID,current)'" {
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
    }
} ;# ea::db::ld::getVersionLabel

proc ea::db::ld::getProfileID {args} {
    # Retrieves the profile id assocatiated to 'args' value, which should be the profile description.
    global log

    return [db eval "SELECT LabelProfileID FROM LabelProfiles WHERE LabelProfileDesc = '[join $args]'"]
} ;# ea::db::ld::getProfileID

proc ea::db::ld::getLabelHeaders {} {
    global log

    return [db eval "SELECT LabelHeaderDesc FROM LabelHeaders"]
} ;# ea::db::ld::getLabelHeaders

proc ea::db::ld::getProfileHeaders {profile_id} {
    # return the headers associated with profile_id

    return [db eval "SELECT LabelHeaderDesc FROM LabelHeaders
                         INNER JOIN LabelHeaderGrp ON LabelHeaders.LabelHeaderID = LabelHeaderGrp.LabelHeaderID
                         WHERE LabelHeaderGrp.LabelProfileID = $profile_id"]
} ;# ea::db::ld::getProfileHeaders

proc ea::db::ld::getSizes {cbox} {
    global log tplLabel

    $cbox configure -values [db eval "SELECT labelSizeDesc FROM LabelSizes"]
} ;# ea::db::ld::getSizes

proc ea::db::ld::setProfileVars {} {
    global log tplLabel

    ${log}::debug Setting Profile Vars
        # Template hasn't been saved, this is a new entry.
        db eval "SELECT LabelProfileID FROM LabelProfiles WHERE LabelProfileDesc = '$tplLabel(LabelProfileDesc)'" {
            set tplLabel(LabelProfileID) $LabelProfileID
        }


    ${log}::debug LabelProfileID: $tplLabel(LabelProfileID)
    # Get number of rows so we can create widgets
    ea::db::ld::getNumRows

    if {[winfo exists .container.frame2]} {
        # Destroy any widgets that have been created.
        ${log}::debug Label Lines frame already exists, destroying...
        destroy .container.frame2
    }

    if {$tplLabel(LabelProfileRowNum) ne 0} {
        # Create the widgets
        ea::code::ld::genLines
    }
} ;# ea::db::ld::setProfileVars

proc ea::db::ld::writeProfile {cbox lbox2} {
    # Write profile to DB. Can be new or existing.
    global log tplLabel profile_id

    # Check to see if Profile name already exists, if it does warn user. Otherwise insert.
    if {$profile_id eq ""} {
        set profile_name [$cbox get]
        db eval "INSERT OR ABORT INTO LabelProfiles (LabelProfileDesc) VALUES ('$profile_name')"

        set profile_id [db eval "SELECT MAX(LabelProfileID) FROM LabelProfiles"]

    } else {
        # We are updating existing values
        # Update the ProfileDesc just in case we modified it.
        db eval "UPDATE LabelProfiles SET LabelProfileDesc = '$tplLabel(tmp,profile)' WHERE LabelProfileID = $profile_id"

        # Delete any existing assigned headers before adding
        db eval "DELETE FROM LabelHeaderGrp WHERE LabelProfileID = $profile_id"
    }

    set getHeaderDesc [$lbox2 get 0 end]
    if {$getHeaderDesc ne ""} {
        foreach item $getHeaderDesc {
            lappend myHdrDesc '$item'
        }

        set getHeaderDesc [join $myHdrDesc ,]

        #${log}::debug hdr-id: db eval "SELECT LabelHeaderID FROM LabelHeaders WHERE LabelHeaderDesc IN ($getHeaderDesc)"
        db eval "SELECT LabelHeaderID FROM LabelHeaders WHERE LabelHeaderDesc IN ($getHeaderDesc)" {
            #${log}::debug INSERT INTO VALUES ($profile_id, $LabelHeaderID)
            db eval "INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES ($profile_id, $LabelHeaderID)"
        }

        unset myHdrDesc
    } else {
        ${log}::notice No headers were selected. Nothing saved to the database.
    }
} ;# ea::db::ld::writeProfile
