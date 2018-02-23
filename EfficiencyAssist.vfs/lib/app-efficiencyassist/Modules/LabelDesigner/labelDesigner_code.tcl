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

proc ea::code::lb::resetWidgets {} {
    global lob tplLabel job
    
    set job(CSRName) ""
    set job(NewCustomer) ""
    set job(CustID) ""
    set job(CustName) ""
    set job(Title) ""
    set tplLabel(FixedBoxQty) ""
    set tplLabel(FixedLabelInfo) ""
    set tplLabel(Height) ""
    set tplLabel(Width) ""
    set tplLabel(LabelPath) ""
    set tplLabel(Name) ""
    set tplLabel(NotePriv) ""
    set tplLabel(NotePub) ""
    set tplLabel(NumRows) ""
    set tplLabel(tmpValues) ""
    
    
}

proc ea::code::lb::saveLabel {} {
    global log job tplLabel
    
    ## Error Checks - Job
    # Check for CustID/CustName
    if {$job(CustID) eq ""} { ${log}::notice Customer ID is empty. Please insert ID. ; return}
    if {$job(CustName) eq ""} { ${log}::notice Customer Name is empty. Please insert name. ; return}
    
    # Check for CSR
    if {$job(CSRName) eq ""} { ${log}::notice CSR name must not be empty. ; return}
    
    # Check for title
    if {$job(Title) eq ""} {${log}::notice Title name must not be empty. Please insert title name.; return}
    
    ## Error Checks - Label
    # Label Name
    if {$tplLabel(Name) eq ""} {${log}::notice Label Name is empty. ; return}
    
    # Label File Path
    if {$tplLabel(LabelPath) eq ""} {${log}::notice Label File is missing. ; return}

    # Check folder permissions
    if {[eAssist_Global::folderAccessibility $tplLabel(LabelPath)] != 3} {${log}::notice Cannot write to $tplLabel(LabelPath). ; return}
    
    # Write to the database
    ea::code::lb::writeToDb
}

# ea::code::lb::getRowData 1 .container.frame2
proc ea::code::lb::getRowData {tplID widPath} {
    global tplLabel
    
    for {set x 1} {$tplLabel(NumRows) >= $x} {incr x} {
        set rowData ""
        set rowData [list '[$widPath.labelData$x get]']
        
        if {[$widPath.userEditable$x state] eq "selected"} {
            lappend rowData 1
        } else {
            lappend rowData 0
        }
        
        if {[join $rowData] ne "\"\""} {
            set rowInfo $tplID,$x
            lappend rowInfo [join $rowData ,]
            
            #puts ([join $rowInfo ,])
            lappend finalRowInfo ([join $rowInfo ,])
        }
    }
    #puts "[join $finalRowInfo ,];"
    return [join $finalRowInfo ,]
    #unset finalRowInfo
}

proc ea::code::lb::writeToDb {} {
    global log job tplLabel
    
    if {$job(NewCustomer) eq 1} {
        # New customer, INSERT into DB
        # DB Table - Customer
        db eval "INSERT INTO Customer (Cust_ID, CustName) VALUES ('$job(CustID)', '$job(CustName)')"
    }
        
    # DB Table - PubTitle
    set csr_fname [lindex $job(CSRName) 0]
    set csr_lname [lindex $job(CSRName) 1]
    set csr_id [db eval "SELECT CSR_ID FROM CSRs WHERE FirstName = '$csr_fname' AND LastName = '$csr_lname'"]
    
    # Does TitleName exist?
    #set title_id [db eval "SELECT TitleName FROM PubTitle WHERE TitleName = '$job(Title)'"]
    set title_id [db eval "SELECT Title_ID FROM PubTitle WHERE TitleName = '$job(Title)' AND CustID = '$job(CustID)'"]
    if {$title_id eq ""} {
        db eval "INSERT INTO PubTitle (TitleName, CustID, CSRID, Status) VALUES ('$job(Title)', '$job(CustID)', '$csr_id', 1)"
        set pubtitle_id [db eval "SELECT MAX(Title_ID) FROM PubTitle"]
    } else {
        ${log}::notice Title already exists in database... skipping.
        set pubtitle_id $title_id
    }
        
    # DB Table - LabelTPL
    if {$pubtitle_id eq ""} {
        ${log}::debug Title doesn't exist, so the template shouldn't either. Inserting data...
        # Title doesn't exist. Template shouldn't exist either.
        db eval "INSERT INTO LabelTPL (PubTitleID, tplLabelName, tplLabelPath, tplLabelWidth, tplLabelHeight, tplNotePriv, tplNotePub, tplRows, tplFixedBoxQty, tplFixedLabelInfo)
                VALUES ($pubtitle_id, '$tplLabel(Name)', '$tplLabel(LabelPath)', '$tplLabel(Width)', '$tplLabel(Height)', '$tplLabel(NotePriv)', '$tplLabel(NotePub)', $tplLabel(NumRows), $tplLabel(FixedBoxQty), $tplLabel(FixedLabelInfo)"
                
        set tpl_id [db eval "SELECT MAX(tplID) FROM LabelTPL"]
    } else {
        # Update Existing Template
        ${log}::debug Title exists (ID: $pubtitle_id), checking to see if template exists.
        set tpl_id [db eval "SELECT tplID FROM LabelTPL WHERE tplLabelName = '$tplLabel(Name)' AND PubTitleID = $pubtitle_id"]
        
        if {$tpl_id eq ""} {
            ${log}::debug Template does not exist, adding to database...
            db eval "INSERT INTO LabelTPL (PubTitleID, tplLabelName, tplLabelPath, tplLabelWidth, tplLabelHeight, tplNotePriv, tplNotePub, tplRows, tplFixedBoxQty, tplFixedLabelInfo)
                VALUES ($pubtitle_id, '$tplLabel(Name)', '$tplLabel(LabelPath)', '$tplLabel(Width)', '$tplLabel(Height)', '$tplLabel(NotePriv)', '$tplLabel(NotePub)', '$tplLabel(NumRows)', '$tplLabel(FixedBoxQty)', '$tplLabel(FixedLabelInfo)')"
                
            set tpl_id [db eval "SELECT MAX(tplID) FROM LabelTPL"]
        
        } else {
            ${log}::debug Template exists, updating...
            db eval "UPDATE LabelTPL
                        SET tplLabelName = '$tplLabel(Name)',
                            tplLabelPath = '$tplLabel(LabelPath)',
                            tplLabelWidth = '$tplLabel(Width)',
                            tplLabelHeight = '$tplLabel(Height)',
                            tplNotePriv = '$tplLabel(NotePriv)',
                            tplNotePub = '$tplLabel(NotePub)',
                            tplFixedBoxQty = '$tplLabel(FixedBoxQty)',
                            tplFixedLabelInfo = '$tplLabel(FixedLabelInfo)'
                        WHERE tplID = $tpl_id"
        }
    }
    

    # DB Table - LabelData
    # Does label data exist?
    
    if {$tplLabel(NumRows) ne ""} {
        set labelData_id [db eval "SELECT labelData_ID FROM LabelData WHERE tplID = $tpl_id"]
        
        if {$labelData_id eq ""} {
            ${log}::debug Data doesn't exist, inserting ...
            # Get Row Data
            set data [join [ea::code::lb::getRowData $tpl_id .container.frame2]]
            ${log}::debug Inserting: $data
            db eval "INSERT INTO LabelData (tplID, labelRowNum, labelRowData, userEditable) VALUES $data"
        } else {
            # Deleting existing records!
            ${log}::notice Deleting existing records in Table: LabelData,ID $tpl_id
            
            db eval "DELETE FROM LabelData WHERE tplID = $tpl_id"
            
            # Inserting new data
            set data [join [ea::code::lb::getRowData $tpl_id .container.frame2]]
            ${log}::debug Inserting: $data
            db eval "INSERT INTO LabelData (tplID, labelRowNum, labelRowData, userEditable) VALUES $data"
        }
    } else {
        ${log}::notice Label data is not required/dynamic! Will not try to save data to db...
    }
}