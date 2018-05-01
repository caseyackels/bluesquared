# Creator: Casey Ackels (C) 2017

proc ea::code::lb::getOpenFile {wid} {
    global log
    
    # filePathName should really be set in Setup/Labels
    set filePathName [tk_getOpenFile -initialdir {//fileprint/Labels/Templates} -filetypes {{Bartender {.btw}}}]
    
    if {$filePathName eq ""} {return}
    
    ${log}::debug filePathName: $filePathName
    
    #set myDrive [string trim [lindex [file split $filePathName] 0] {// :}]
    #set newMyDrive [registry get HKEY_CURRENT_USER\\NETWORK\\$myDrive RemotePath]
    #
    #set newFilePathName [file join $newMyDrive {*}[lrange [file split $filePathName] 1 end]]

    #${log}::debug Returned file path: $newFilePathName
    
    $wid delete 0 end ;# make sure we're inserting into an empty widget
    $wid insert end $filePathName
}

proc ea::code::lb::resetWidgets {args} {
    global log tplLabel job
    ${log}::debug Resetting arrays: Job (partial) and tplLabel
    
    # reset standard
    set job(CSRName) ""
    set job(NewCustomer) ""
    set job(Title) ""
    set tplLabel(ID) ""
    set tplLabel(FixedBoxQty) ""
    set tplLabel(FixedLabelInfo) ""
    set tplLabel(LabelPath) ""
    set tplLabel(Size) ""
    set tplLabel(LabelSize) ""
    set tplLabel(LabelSizeID) ""
    set tplLabel(SerializeLabel) ""
    set tplLabel(Name) ""
    set tplLabel(NotePriv) ""
    set tplLabel(NotePub) ""
    set tplLabel(NumRows) ""
    set tplLabel(tmpValues) ""
    set tplLabel(LabelVersionID) ""
    set tplLabel(LabelVersionID,current) ""
    set tplLabel(LabelVersionDesc) ""
    set tplLabel(LabelVersionDesc,current) ""
    set tplLabel(LabelProfileID) ""
    set tplLabel(LabelProfileDesc) ""

    .container.frame0.tplNameCbox configure -values ""
    .container.frame1.versionNameCbox configure -values ""
    
    # Destroy entry widgets if they exist (created from selecting a Profile)
    if {[winfo exists .container.frame2]} {destroy .container.frame2}
            
    if {$args eq "all"} {
        # reset all widgets / variables
        set job(CustID) ""
        set job(CustName) ""
    }

}

proc ea::code::lb::saveLabel {} {
    global log job tplLabel
    
    set gate 0
    
    ## WARNINGS - If these are triggered, nothing is written to the database
    ## Error Checks - Job Info
    # Check for CustID/CustName
    if {$job(CustID) eq ""} { ${log}::critical [mc "Customer ID is empty. Please insert ID."] ; set gate 1}
    if {$job(CustName) eq ""} { ${log}::critical [mc "Customer Name is empty. Please insert name."] ; set gate 1}
    
    # Check for CSR
    if {$job(CSRName) eq ""} { ${log}::critical [mc "CSR name must not be empty."] ; set gate 1}
    
    # Check for title
    if {$job(Title) eq ""} {${log}::critical [mc "Title name must not be empty. Please insert title name."]; set gate 1}
    
    ## Error Checks - Label Properties
    # Label Name
    if {$tplLabel(Name) eq ""} {${log}::critical [mc "Template Name is empty."] ; set gate 1}
    
    # Label File Path
    if {$tplLabel(LabelPath) eq ""} {${log}::critical [mc "Label File is missing."] ; set gate 1}

    # Check folder permissions
    if {[eAssist_Global::folderAccessibility $tplLabel(LabelPath)] != 3} {${log}::critical [mc "Cannot write to"] $tplLabel(LabelPath). ; set gate 1}
    
    
    # Check Label Size
    if {$tplLabel(Size) eq ""} {${log}::critical [mc "Label Size is missing."] ; set gate 1}
    
    # NOTICES - Data is saved to the database, but notices are issued if fields are empty
    #if {$tplLabel(LabelSize) eq ""} {${log}::alert [mc "Label size hasn't been selected"]} ;# Not using LabelSize
    if {$tplLabel(LabelProfileDesc) eq ""} {${log}::alert [mc "Profile is missing. Setting the ID to 0 (Default)"]; set tplLabel(LabelProfileID) 0}
    if {$tplLabel(FixedBoxQty) eq ""} {${log}::alert [mc "Fixed Box Qty is empty"]}
    if {$tplLabel(FixedLabelInfo) eq ""} {${log}::alert [mc "Fixed Label Info is empty"]}
    if {$tplLabel(SerializeLabel) eq ""} {${log}::alert [mc "Serialize Label is empty"]}
    
    if {$gate == 1} {
        ${log}::critical Critical errors exist, not writing to the database.
        return
    } else {
        # Write to the database
        ea::code::lb::writeToDb
    }
} ;# ea::code::lb::saveLabel

# ea::code::lb::getRowData 1 .container.frame2
proc ea::code::lb::getRowData {LabelVersionID widPath} {
    global tplLabel
   
    for {set x 1} {$tplLabel(LabelProfileRowNum) >= $x} {incr x} {
        set rowData ""
        set rowData [list '[$widPath.labelData$x get]']
        
        if {[$widPath.userEditable$x state] eq "selected"} {
            lappend rowData 1
        } else {
            lappend rowData 0
        }
        
        if {[$widPath.isVersion$x state] eq "selected"} {
            lappend rowData 1
        } else {
            lappend rowData 0
        }
        
        if {[join $rowData] ne "\"\""} {
            set rowInfo $LabelVersionID,$x
            lappend rowInfo [join $rowData ,]

            lappend finalRowInfo ([join $rowInfo ,])
        }
    }
    
    return [join $finalRowInfo ,]
} ;# ea::code::lb::getRowData

proc ea::code::lb::writeToDb {} {
    # Parent: ea::code::lb::saveLabel
    global log job tplLabel
    
    if {$job(NewCustomer) eq 1} {
        # New customer, INSERT into DB
        # DB Table - Customer
        ${log}::debug Customer ($job(CustName) is new, inserting into database.
        db eval "INSERT INTO Customer (Cust_ID, CustName) VALUES ('$job(CustID)', '$job(CustName)')"
        
        set job(NewCustomer) ""
    }
        
    # DB Table - PubTitle
    set csr_fname [lindex $job(CSRName) 0]
    set csr_lname [lindex $job(CSRName) 1]
    set csr_id [db eval "SELECT CSR_ID FROM CSRs WHERE FirstName = '$csr_fname' AND LastName = '$csr_lname'"]
    
   
    # Does TitleName exist?
    set title_id [db eval "SELECT Title_ID FROM PubTitle WHERE TitleName = '$job(Title)' AND CustID = '$job(CustID)'"]
    if {$title_id eq ""} {
        ${log}::notice Title ($job(Title)) is new, inserting into database.
        db eval "INSERT INTO PubTitle (TitleName, CustID, CSRID, Status) VALUES ('$job(Title)', '$job(CustID)', '$csr_id', 1)"
        set pubtitle_id [db eval "SELECT MAX(Title_ID) FROM PubTitle"]
    } else {
        ${log}::notice Title already exists in database...
        set pubtitle_id $title_id
        set csr_id_db [db eval "SELECT CSRID FROM PubTitle WHERE Title_ID = $pubtitle_id"]
        
        ${log}::notice Checking to see if database has different CSR ($csr_id) name than user selected. If so, update database. 
        ${log}::debug CSR ID in Interface: $csr_id
        ${log}::debug CSR ID in DB: $csr_id_db
        
        if {$csr_id eq $csr_id_db} {
            ${log}::notice CSR is the same, no changes needed
            } else {
                ${log}::notice CSR ($csr_id_db) isn't the same, updating database to $csr_id
                db eval "UPDATE PubTitle SET CSRID = '$csr_id' WHERE Title_ID = $pubtitle_id"
            }
    }
        
    # DB Table - LabelTPL
    if {$pubtitle_id eq ""} {
        ${log}::debug Title doesn't exist, so the template shouldn't either. Inserting data...
        set tplLabel(LabelSizeID) [db eval "SELECT labelSizeID FROM LabelSizes WHERE labelSizeDesc = '$tplLabel(Size)'"]
        set tplLabel(LabelProfileID) [db eval "SELECT LabelProfileID FROM LabelProfiles WHERE LabelProfileDesc = '$tplLabel(LabelProfileDesc)'"]
            if {$tplLabel(LabelProfileID) eq ""} {set tplLabel(LabelProfileID) 0}
        
        # Title doesn't exist. Template shouldn't exist either.
         db eval "INSERT INTO LabelTPL (PubTitleID, LabelProfileID, labelSizeID, tplLabelName, tplLabelPath, tplNotePriv, tplNotePub, tplFixedBoxQty, tplFixedLabelInfo, tplSerialize)
                VALUES ($pubtitle_id, $tplLabel(LabelProfileID), $tplLabel(LabelSizeID), '$tplLabel(Name)', '$tplLabel(LabelPath)', '$tplLabel(NotePriv)', '$tplLabel(NotePub)', $tplLabel(FixedBoxQty), $tplLabel(FixedLabelInfo), $tplLabel(SerializeLabel), $tplLabel(SerializeLabel))"
                        
        set tpl_id [db eval "SELECT MAX(tplID) FROM LabelTPL"]
    } else {
        # Insert or Update Existing Template
        ${log}::debug Title exists (ID: $pubtitle_id), checking to see if template exists.
        set tplLabel(LabelSizeID) [db eval "SELECT labelSizeID FROM LabelSizes WHERE labelSizeDesc = '$tplLabel(Size)'"]
        set tplLabel(LabelProfileID) [db eval "SElECT LabelProfileID FROM LabelProfiles WHERE LabelProfileDesc = '$tplLabel(LabelProfileDesc)'"]
            if {$tplLabel(LabelProfileID) eq ""} {set tplLabel(LabelProfileID) 0}
        
        set tpl_id [db eval "SELECT tplID FROM LabelTPL WHERE tplLabelName = '$tplLabel(Name)' AND PubTitleID = $pubtitle_id"]
        
        if {$tpl_id eq ""} {
            ${log}::debug Template does not exist, adding to database...
            ${log}::debug db eval "INSERT INTO LabelTPL (PubTitleID, LabelProfileID, labelSizeID, tplLabelName, tplLabelPath, tplNotePriv, tplNotePub, tplFixedBoxQty, tplFixedLabelInfo, tplSerialize)
                VALUES ($pubtitle_id, $tplLabel(LabelProfileID), $tplLabel(LabelSizeID), '$tplLabel(Name)', '$tplLabel(LabelPath)', '$tplLabel(NotePriv)', '$tplLabel(NotePub)', '$tplLabel(FixedBoxQty)', '$tplLabel(FixedLabelInfo)', '$tplLabel(SerializeLabel)')"

            db eval "INSERT INTO LabelTPL (PubTitleID, LabelProfileID, labelSizeID, tplLabelName, tplLabelPath, tplNotePriv, tplNotePub, tplFixedBoxQty, tplFixedLabelInfo, tplSerialize)
                VALUES ($pubtitle_id, $tplLabel(LabelProfileID), $tplLabel(LabelSizeID), '$tplLabel(Name)', '$tplLabel(LabelPath)', '$tplLabel(NotePriv)', '$tplLabel(NotePub)', '$tplLabel(FixedBoxQty)', '$tplLabel(FixedLabelInfo)', '$tplLabel(SerializeLabel)')"
                
            set tpl_id [db eval "SELECT MAX(tplID) FROM LabelTPL"]
            set tplLabel(ID) $tpl_id
        } else {
            ${log}::debug Template exists, updating...
            db eval "UPDATE LabelTPL
                        SET LabelProfileID = $tplLabel(LabelProfileID),
                            labelSizeID = $tplLabel(LabelSizeID),
                            tplLabelName = '$tplLabel(Name)',
                            tplLabelPath = '$tplLabel(LabelPath)',
                            tplNotePriv = '$tplLabel(NotePriv)',
                            tplNotePub = '$tplLabel(NotePub)',
                            tplFixedBoxQty = '$tplLabel(FixedBoxQty)',
                            tplFixedLabelInfo = '$tplLabel(FixedLabelInfo)',
                            tplSerialize = '$tplLabel(SerializeLabel)'
                        WHERE tplID = $tpl_id"
        }
    }
    
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
        if {$tplLabel(LabelVersionID,current) eq "" && $tplLabel(LabelVersionDesc,current) eq ""} {
            # This is a new version, insert only. (Table: LabelVersions)
            ${log}::notice LabelVersion ID doesn't exist, but Description does. Retrieving...
            ${log}::notice LabelVersion Row: $tplLabel(tmpValues,rbtn) [.container.frame2.frame2a.labelData$tplLabel(tmpValues,rbtn) get]
            ${log}::debug db eval "INSERT INTO LabelVersions (tplID, LabelVersionDesc) VALUES ($tpl_id, '[.container.frame2.frame2a.labelData$tplLabel(tmpValues,rbtn) get]')"
            
            db eval "INSERT INTO LabelVersions (tplID, LabelVersionDesc) VALUES ($tpl_id, '[.container.frame2.frame2a.labelData$tplLabel(tmpValues,rbtn) get]')"
            
            # Get version id
            set tplLabel(LabelVersionID,current) [db eval "SELECT max(labelVersionID) FROM LabelVersions WHERE tplID = $tpl_id"]
            ${log}::notice Retrieving new version ID: $tplLabel(LabelVersionID,current)
    
            # Insert label date (Table: LabelData)
            set data [join [ea::code::lb::getRowData $tplLabel(LabelVersionID,current) .container.frame2.frame2a]]
            ${log}::notice Inserting Row Data: $data
            ${log}::debug db eval "INSERT INTO LabelData (labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES $data"
            db eval "INSERT INTO LabelData (labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES $data"
        }
    }

} ;# ea::code::lb::writeToDb

proc ea::code::lb::createDummyFile {} {
    # Create a 'dummy' file that contains a sample database of the selected profile.
    # Parent ea::gui::lb::
    # Writes to: Directory where label file is located with name of <Profile Desc>
    global log tplLabel
    
    # Actions ...
    set f_name "$tplLabel(Name) - $tplLabel(LabelProfileDesc)"
    ${log}::debug File Name: $f_name
    ${log}::debug writing to path:  [file dirname $tplLabel(LabelPath)]
    
    set hdr_data [::csv::join [db eval "SELECT LabelHeaders.LabelHeaderDesc FROM LabelHeaderGrp
                                            INNER JOIN LabelHeaders ON LabelHeaders.LabelHeaderID = LabelHeaderGrp.LabelHeaderID
                                            WHERE LabelHeaderGrp.LabelProfileID = $tplLabel(LabelProfileID)"]]
                    
    ${log}::debug Opening File: file join  [file dirname $tplLabel(LabelPath)] $f_name.csv
    ${log}::debug writing headers to file: $hdr_data
    
    set runlist_file [open "[file join  [file dirname $tplLabel(LabelPath)] $f_name.csv]" w]
    
    # Insert Header row
    chan puts $runlist_file $hdr_data
    
    chan close $runlist_file
}

proc ea::code::lb::populateProfileCbox {wid} {
    # See: ea::db::lb::getLabelHeaders
    global log
    
    # delete all entries first
    $wid delete 0 end
    set items [join [ea::db::lb::getLabelHeaders]]
    
    foreach item $items {
        $wid insert end $item
    }
}

proc ea::code::lb::getAllHeaders {profile_id lbox1 lbox2} {
    # Retrieve both available headers and assigned headers, then populate the listbox widgets with the data.
    global log
    
    set avail [ea::db::lb::getLabelHeaders]
    set current [ea::db::lb::getProfileHeaders $profile_id]
    
    set c_avail [ea::tools::listDiff $avail $current]
    #${log}::debug c_avail: $c_avail
    #${log}::debug current: $current
    
    # Delete data from both list boxes before populating
    $lbox1 delete 0 end
    $lbox2 delete 0 end
    
    foreach item $c_avail {
        $lbox1 insert end $item
    }
    
    foreach item $current {
        $lbox2 insert end $item
    }
    
}

proc ea::code::lb::assignProfileHeaders {modify lbox1 lbox2} {
    # Add selected header(s) to 'Assigned' listbox.
    # We save everything in the DB when the user hits the 'save' button. Until then the changes are only within the widget
    # Modify should equal add or del
    global log
    
    switch -- $modify {
        "add"   {set wid1 $lbox1; set wid2 $lbox2}
        "del"   {set wid1 $lbox2; set wid2 $lbox1}
        default {${log}::debug assignProfileHeaders: arg for modify ($modify) is not valid. Must be add or del.; return}
    }
    #${log}::debug modify: $modify
    #${log}::debug wid1: $wid1
    #${log}::debug wid2: $wid2
        
    # Current selection
    set headers_id [$wid1 curselection]
    ${log}::debug selected item id: $headers_id
    
    foreach hdr $headers_id {
        lappend headers [$wid1 get $hdr]
    }
    ${log}::debug selected item desc: $headers

    # Remove selected from Available listbox (lbox1)
    # We sort it (10 8 7), since if we don't we change the positions of what we want to delete, after deleting the first one.
    foreach item [lsort -decreasing $headers_id] {
        $wid1 delete $item
    }
    
    # Add selected to Assigned listbox (lbox2)
    foreach item $headers {
        $wid2 insert end $item
    }
    
    # unset vars
    unset headers
}

proc ea::code::lb::editProfile {mode addPro_btn edit_btn add_btn del_btn cbox lbox2} {
    # This button has two modes: (1) Enable add/del btns; (2) Saves Data
    # Mode: edit or save
    global log profile_id
    ${log}::debug editProfile mode: $mode
    
    if {$mode eq "edit"} {
        ${log}::debug Enable - add/del, Enable cbox, change btn text
        $add_btn configure -state normal
        $del_btn configure -state normal
        $cbox configure -state normal
        $addPro_btn configure -state disable
        $edit_btn configure -text [mc "Save"] -command "ea::code::lb::editProfile save $addPro_btn $edit_btn $add_btn $del_btn $cbox $lbox2"
    } else {
        # Saving
        ${log}::debug Disable - add/del, readonly cbox, change btn text
        ${log}::debug Reset Widgets (assigned lbox2), cbox, profile_id
        
        $add_btn configure -state disable
        $del_btn configure -state disable
        $addPro_btn configure -state normal

        $edit_btn configure -text [mc "Edit"] -state disable -command "ea::code::lb::editProfile edit $addPro_btn $edit_btn $add_btn $del_btn $cbox $lbox2"

            ${log}::debug Profile: [$cbox get]
            ${log}::debug Entries to save to DB: [$lbox2 get 0 end]
            ea::db::lb::writeProfile $cbox $lbox2

        
        # Final Cleanup
        $lbox2 delete 0 end
        $cbox delete 0 end
        $cbox configure -state readonly
        
        # Clear profile_id, and description
        set profile_id ""
        set tplLabel(tmp,profile) ""
    }
}

proc ea::code::lb::addProfile {mode addPro_btn edit_btn add_btn del_btn cbox lbox1 lbox2} {
    # Add a new profile
    global log tplLabel profile_id
    
    # Clear profile_id
    set profile_id ""
    
    # Enable the cbox for editing
    $cbox configure -state normal
    
    # Clear out cbox, put focus
    $cbox delete 0 end
    focus $cbox
    
    # Clear out lbox2
    $lbox2 delete 0 end
    
    # Re-populate lbox1 (available headers)
    ea::code::lb::populateProfileCbox $lbox1
    
    # Disable Add button
    $addPro_btn configure -state disable
    
    # Enable Add/Del buttons (To/From headers)
    $add_btn configure -state normal
    $del_btn configure -state normal
    
    # Change edit button to 'Save'
    $edit_btn configure -text [mc "Save"] -state normal -command "ea::code::lb::editProfile save $addPro_btn $edit_btn $add_btn $del_btn $cbox $lbox2"

}