# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 09 10,2014
# Last revised: 2/27/18

proc ea::db::bl::getTplData {tpl} {
    global log GS_textVar tplLabel job
    
    # reset vars just in case we've already ran this once before
    ea::code::lb::resetWidgets
    foreach item [winfo children .container.frame1] {
        if {[string match *entry* $item] == 1} {
            $item configure -state normal
        }
    }
    
    # Clear out the widgets
    foreach item [array names GS_textVar Row*] {
        set GS_textVar($item) ""
    }
    
    # clear out the version dropdown
    .container.frame0.cbox configure -values ""
    .container.frame0.cbox set ""
    
    set job(CustID) ""
    set job(CustName) ""
    set job(Title) ""
    set job(Title,id) ""
    set job(CSRName) ""
    
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
        #${log}::debug Id doesn't exist, try again.
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
        # disable all of the widgets if we are serializing
        ${log}::debug Disabling widgets in .container.frame1 (all row widgets)
        foreach child [winfo children .container.frame1] {
                if {[string match *entry* $child] == 1} {
                    $child configure -state disable
                }
        }
    }
}

