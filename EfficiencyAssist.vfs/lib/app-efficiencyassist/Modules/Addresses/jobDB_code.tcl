# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 02 08,2015
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 169 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2011-10-17 16:11:20 -0700 (Mon, 17 Oct 2011) $
#
########################################################################################

##
## - Overview
# Create the per job databases

namespace eval job::db {}

    #-tName
    #-tcsr
    #-tsavelocation
    #-tcustcode
    #-thistnote
    #
    #-jnumber
    #-jname
    #-jsavelocation
    #-jshipstart
    #-jshipbal
    #-jhistnote

proc job::db::createDB {args} {
    #****f* createDB/job::db
    # CREATION DATE
    #   02/08/2015 (Sunday Feb 08)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   job::db::createDB -tName <value> -tCSR <value> -tSaveLocation <value> -tCustCode <value> -tHistNote <value> -jNumber <value> -jName <value> -jSaveLocation <value> -jShipStart <value> -jShipBal <value> -jHistNote <value>
    #   All paramters are required.
    #
    # FUNCTION
    #	Initialize a new Title database
    #   job::db::createDB -tName {Portland Monthly} -tCSR {Meredith Hunter} -tSaveLocation {C:/tmp} -tCustCode TEMCUS -tHistNote {Init db} -jNumber 503455 -jName {June 2015} -jSaveLocation {C:/tmp/temp} -jShipStart 6-25-15 -jShipBal 6-28-15 -jHistNote {init job}
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   Create the database, populate it with the tables. Then immediately insert Title and Job information.
    #   This proc should only be used to create the database initially. All other additions happen with [job::db::insertTitleInfo], and [job::db::insertJobInfo]
    #
    #   Versions: Holds all versions, after being created a default entry should be inserted 'Version 1'; which is the default in EFI Monarch Planner
    #   NoteTypes: Allows the user to identify 'note types' and if they should be included on reports or not.
    #       This only controlled within the code; after the first creation a list of 'note types' should be inserted into the table. The user can then set some paramaters
    #       i.e,. inactive, or doesn't show on any reports.
    #   Notes: Holds all notes, including the identification on what note type it is. These notes can be set to 'inactive' also.
    #   History: Nearly all tables are linked to a history table. This will help with figuring out who did what.
    #   ExportType: (I'm questioning if we really need this) Allows the user to specify that the shipping order is a specific entry: Planner (Import file), Process Shipper (Import File), DoNotExport (Report Only)
    #   SysInfo: Holds the schema information
    #   TitleInformation: Contains all title info - Description, CSR, Customer, etc
    #   JobInformation: All related information, including save locations
    #   Published: Allows the distribution person to mark their work as 'published'. If anything changes after this is marked, revisions will be listed
    #   Shipping Orders: This is our junction table to figure out what addresses match to specific jobs.
    #   Addresses: This table has a few system columns, but outside of that it is controlled by the user.
    #   
    # SEE ALSO
    #   job::db::insertTitleInfo, job::db::insertJobInfo
    #   
    #***
    global log job user
    set currentProcName [lindex [info level 0] 0]
    
    foreach {key value} $args {
        switch -nocase $key {
            -tName          {#${log}::debug -tName $value
                                set tName $value
            }
            -tCSR           {#${log}::debug -tCSR $value
                                set tCSR $value
            }
            -tSaveLocation  {#${log}::debug -tsaveLocation $value
                                set tSaveLocation $value
            }
            -tCustCode      {#${log}::debug -tCustCode $value
                                set tCustCode $value
            }
            -tHistNote      {#${log}::debug -tHistNote $value
                                set tHistNote $value
            }
            -jNumber        {#${log}::debug -jNumber $value
                                set jNumber $value
            }
            -jName          {#${log}::debug -jName $value
                                set jName $value
            }
            -jSaveLocation  {#${log}::debug -jSaveLocation $value
                                set jSaveLocation $value
            }
            -jShipStart     {#${log}::debug -jShipStart $value
                                set jShipStart $value
            }
            -jShipBal       {#${log}::debug -jShipBal $value
                                set jShipBal $value
            }
            -jHistNote      {#${log}::debug -jHistNote $value
                                set jHistNote $value
            }
            default         {${log}::critical $currentProcName [info level 0] Passed invalid args $args; return}
        }
    }
    
    # ensure we have the correct number of args
    if {[llength $args] != 22} {
        ${log}::critical $currentProcName [info level 0] \nDid not pass sufficient number of args: [llength $args] should be 22
        return
    }


    ${log}::notice Creating a new database for: $tCustCode $tName
    #${log}::debug Formatted file name: $tCustCode, $tName, [join "$tCustCode [join [split $tName " "] ""]" _]
    
    set job(db,Name) [join "$tCustCode [join [split $tName " "] ""]" _]
    
    # Create the database
    #sqlite3 $job(db,Name) [file join $tSaveLocation $job(db,Name).db] -create 1
    # For Testing
    sqlite3 $job(db,Name) $job(db,Name).db -create 1
    
    $job(db,Name) eval {
        CREATE TABLE Versions (
            Version_ID    INTEGER PRIMARY KEY AUTOINCREMENT,
            VersionName   TEXT    NOT NULL ON CONFLICT ROLLBACK,
            VersionActive BOOLEAN NOT NULL ON CONFLICT ROLLBACK
                                  DEFAULT (1)
        );
        
        -- # This table should be pre-populated, the only thing the user shoud be able to change is the "IncludeOnReports" column.
        CREATE TABLE NoteTypes (
            NoteType_ID      INTEGER PRIMARY KEY AUTOINCREMENT,
            NoteType         TEXT    NOT NULL ON CONFLICT ROLLBACK,
            IncludeOnReports BOOLEAN NOT NULL
                                     DEFAULT (1),
            Active           BOOLEAN DEFAULT (1) 
                                     NOT NULL
        );
        

        CREATE TABLE Notes (
            Notes_ID   TEXT    PRIMARY KEY,
            HistoryID  INTEGER NOT NULL ON CONFLICT ROLLBACK
                               REFERENCES History (History_ID) ON UPDATE CASCADE,
            NoteTypeID INTEGER REFERENCES NoteTypes (NoteType_ID) ON UPDATE CASCADE
                               NOT NULL ON CONFLICT ROLLBACK,
            NotesText  TEXT    NOT NULL ON CONFLICT ROLLBACK,
            Active     BOOLEAN DEFAULT (1) 
                               NOT NULL ON CONFLICT ROLLBACK
        );

        CREATE TABLE History (
            History_ID TEXT PRIMARY KEY,
            HistUser   TEXT NOT NULL ON CONFLICT ROLLBACK,
            HistDate   DATE NOT NULL ON CONFLICT ROLLBACK,
            HistTime   TIME NOT NULL ON CONFLICT ROLLBACK,
            HistSysLog TEXT
        );

        CREATE TABLE ExportTypes (
            ExportType_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            ExportType   TEXT    NOT NULL ON CONFLICT ROLLBACK,
            Active        BOOLEAN DEFAULT (1) 
        );
        
        CREATE TABLE SysInfo (
            SysInfo_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            SysSchema  INTEGER UNIQUE
                               NOT NULL,
            HistoryID  TEXT    REFERENCES History (History_ID) ON UPDATE CASCADE
        );
        
        CREATE TABLE TitleInformation (
            TitleInformation_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            NotesID             TEXT    REFERENCES Notes (Notes_ID) ON UPDATE CASCADE,
            HistoryID           TEXT    REFERENCES History (History_ID) ON UPDATE CASCADE
                                        NOT NULL ON CONFLICT ROLLBACK,
            CustCode            TEXT    NOT NULL ON CONFLICT ROLLBACK,
            CSRName             TEXT    NOT NULL ON CONFLICT ROLLBACK,
            TitleName           TEXT    NOT NULL ON CONFLICT ROLLBACK,
            TitleSaveLocation   TEXT
        );
        
        CREATE TABLE JobInformation (
            --# JobInformation_ID = Job Number
            JobInformation_ID  TEXT    UNIQUE ON CONFLICT ROLLBACK
                                       NOT NULL ON CONFLICT ROLLBACK
                                       PRIMARY KEY ASC ON CONFLICT ROLLBACK,
            JobName            TEXT    NOT NULL ON CONFLICT ROLLBACK,
            JobSaveLocation    TEXT    NOT NULL ON CONFLICT ROLLBACK,
            JobFirstShipDate   DATE,
            JobBalanceShipDate DATE,
            TitleInformationID INTEGER REFERENCES TitleInformation (TitleInformation_ID) ON UPDATE CASCADE,
            HistoryID          TEXT    REFERENCES History (History_ID) ON UPDATE CASCADE
                                        NOT NULL ON CONFLICT ROLLBACK
        );
        
        CREATE TABLE Published (
            Published_ID     INTEGER PRIMARY KEY AUTOINCREMENT,
            NotesID          TEXT    REFERENCES Notes (Notes_ID) ON UPDATE CASCADE,
            JobInformationID TEXT    REFERENCES JobInformation (JobInformation_ID) ON UPDATE CASCADE
                                     NOT NULL ON CONFLICT ROLLBACK,
            PublishedRev     INTEGER NOT NULL ON CONFLICT ROLLBACK,
            PublishedBy      TEXT    NOT NULL ON CONFLICT ROLLBACK,
            PublishedDate    DATE    NOT NULL ON CONFLICT ROLLBACK,
            PublishedTime    TIME    NOT NULL ON CONFLICT ROLLBACK
        );
        
        CREATE TABLE ShippingOrders (
            JobInformationID TEXT NOT NULL ON CONFLICT ROLLBACK
                                    REFERENCES JobInformation (JobInformation_ID) ON UPDATE CASCADE,
            AddressID        TEXT NOT NULL ON CONFLICT ROLLBACK
                                  REFERENCES Addresses (Addresses_ID) ON UPDATE CASCADE
        );
    }
    

    # Dynamically build the Addresses table using data from the main db (Headers Config)
    # AddressParentID - This is the ID of the first entry in that family
    # AddressChildID - Incremented field: 0 (Duplicate), 1 (Original Entry) 2+ (revisions to the original record)
    set cTable [list \
        {Addresses_ID    TEXT    UNIQUE ON CONFLICT ROLLBACK} \
        {NotesID         TEXT    REFERENCES Notes (Notes_ID) ON UPDATE CASCADE} \
        {AddressParentID TEXT} \
        {AddressChildID  INTEGER} \
        {Active          BOOLEAN DEFAULT (1) NOT NULL ON CONFLICT ROLLBACK} \
        {VersionID       INTEGER REFERENCES Versions (Version_ID) ON UPDATE CASCADE} \
        {ExportTypeID    INTEGER REFERENCES ExportType (ExportType_ID) ON UPDATE CASCADE}]
    
    
    db eval {SELECT dbColName, dbDataType FROM HeadersConfig} {
        # Bypass the possiblity that the user entered 'versions'.
        if {[string tolower $dbColName] eq "versions"} {continue}
        lappend cTable "usr_$dbColName $dbDataType"
    }

    $job(db,Name) eval "CREATE TABLE Addresses ( [join $cTable ,] )"
    
    
    job::db::insertDefaultData
    ${log}::notice Inserted default data...
    
    #INSERT TITLE AND GET ID
    set titleID [job::db::insertTitleInfo -title $tName -csr $tCSR -saveLocation $tSaveLocation -custcode $tCustCode -histnote $tHistNote]
    
    #INSERT JOB
    job::db::insertJobInfo -jNumber $jNumber -jName $jName -jSaveLocation $jSaveLocation -jDateShipStart $jShipStart -jDateShipBalance $jShipBal -titleid $titleID -histnote $jHistNote
       
} ;# job::db::createDB

## TEST
## CREATE DB
#job::db::createDB SAGMED {Meredith Hunter} TEST001 Febraury 303603 {c:/tmp}
## INSERT TITLE AND GET ID
# set titleID [job::db::insertTitleInfo -title {Test Title} -csr {Lyn Lovell} -saveLocation {c:/tmp} -custcode {TEMCUS} -histnote {Initialize the Title DB}]
## INSERT JOB
#job::db::insertJobInfo -jNumber 304503 -jName {March 2015} -jSaveLocation {C:/tmp/job} -jDateShipStart 2015-05-20 -jDateShipBalance 2015-05-29 -titleid $titleID -histnote {Inserting a new Job}

proc job::db::open {} {
    #****f* open/job::db
    # CREATION DATE
    #   02/08/2015 (Sunday Feb 08)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   job::db::load 
    #
    # FUNCTION
    #	Launches the browse dialog; loads the selected database based on the file that we've opened.
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log job mySettings files headerParent process

    if {[info exists job(db,Name)] == 1} {
        ${log}::debug Previous job is open. Closing current job: $job(Title) $job(Name)
        $job(db,Name) close
        }
        
    set job(db,Name) [eAssist_Global::OpenFile [mc "Open Project"] $mySettings(sourceFiles) file -ext .db -filetype {{Efficiency Assist Project} {.db}}]
    
    # Just in case the user cancels out of the open dialog.
    if {$job(db,Name) eq ""} {
        unset job(db,Name)
        return
    }
    
    # Reset the inteface ...
    eAssistHelper::resetImportInterface

    # Open the db
    sqlite3 $job(db,Name) $job(db,Name)
    
    set job(SaveFileLocation) [file dirname $job(db,Name)]
    set job(CustID) [join [$job(db,Name) eval {SELECT CustID FROM JobInformation}]]
    set job(CSRName) [join [$job(db,Name) eval {SELECT CSRName FROM JobInformation}]]
    set job(Number) [join [$job(db,Name) eval {SELECT JobNumber FROM JobInformation}]]
    set job(Title) [join [$job(db,Name) eval {SELECT JobTitle FROM JobInformation}]]
    set job(Name) [join [$job(db,Name) eval {SELECT JobName FROM JobInformation}]]
    
    set job(CustName) [join [db eval "SELECT CustName From Customer where Cust_ID='$job(CustID)'"]]

    #set newHdr {$OrderNumber}
    foreach header [job::db::retrieveHeaderNames $job(db,Name) Addresses] {
        if {$header eq "Status"} {continue}
        lappend newHdrList $header
        lappend newHdr $$header
    }
    
    set headerParent(dbHeaderList) $newHdr
    set headerParent(tblHeaderList) $newHdrList
    
    ## Check db schema to see if it needs to be updated ...
    job::db::updateDB
    
    ## Insert columns that we should always see, and make sure that we don't create it multiple times if it already exists
    if {[$files(tab3f2).tbl findcolumnname OrderNumber] == -1} {
        $files(tab3f2).tbl insertcolumns 0 0 "..."
        $files(tab3f2).tbl columnconfigure 0 -name "OrderNumber" -labelalign center
    }
    
    # Insert the data into the tablelist
    $job(db,Name) eval "SELECT [join $newHdrList ,] from Addresses WHERE Status=1" {
        #${log}::debug [$files(tab3f2).tbl insert end $newHdr]
        catch {$files(tab3f2).tbl insert end [subst $newHdr]} err
    }
    
    if {[info exists err]} {${log}::debug ERROR: $err}
    
    set headerWhiteList "$headerParent(whiteList) OrderNumber"
    
    for {set x 0} {$headerParent(ColumnCount) > $x} {incr x} {
        set ColumnName [$files(tab3f2).tbl columncget $x -name]
        if {[lsearch -nocase $headerWhiteList $ColumnName] == -1} {
            $files(tab3f2).tbl columnconfigure $x -hide yes
        }
    }

    # Apply the highlights
    importFiles::highlightAllRecords $files(tab3f2).tbl
    
    # Get total copies
    #set job(TotalCopies) [ea::db::countQuantity $job(db,Name) Addresses]
    job::db::getTotalCopies
    
    # Init variables
    
    set process(versionList) [ea::db::getUniqueValues $job(db,Name) Version Addresses]
    ## Initialize popup menus
    #IFMenus::tblPopup $files(tab3f2).tbl browse .tblMenu
    IFMenus::createToggleMenu $files(tab3f2).tbl
} ;# job::db::open


proc job::db::write {db dbTbl dbTxt wid widCells {dbCol ""}} {
    #****f* write/job::db
    # CREATION DATE
    #   02/13/2015 (Friday Feb 13)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   job::db::write db dbTbl dbTxt wid widCells ?dbCol?
    #   job::db::write <dbName> <dbTable> <text> <widTbl> <row,col> ?Col Name?
    #
    # FUNCTION
    #	Writes data to the widget cell and database.
    #	If the column name isn't already known, use two quotes; and this proc will figure it out, since we are receiving the row,cell value.
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log job

    if {$dbCol eq ""} {
        # retrieves the column name if we didn't pass it to the proc.
        set dbCol [$wid columncget [lindex [split $widCells ,] end] -name]
    }
    
    #${log}::debug Updating COLUMN: $dbCol
    #${log}::debug Updating Cells (should only ever have one): $widCells
    #${log}::debug Updating VALUES to: $dbTxt
    
    # Update the tabelist widget
    $wid cellconfigure $widCells -text $dbTxt
    
    # Update the DB
    set dbPK [$wid getcell [lindex [split $widCells ,] 0],0]
    $db eval "UPDATE $dbTbl SET $dbCol='$dbTxt' WHERE OrderNumber='$dbPK'"
    
    # Get total copies
    #set job(TotalCopies) [ea::db::countQuantity $job(db,Name) Addresses]
    job::db::getTotalCopies
    
} ;# job::db::write

proc job::db::multiWrite {db dbTbl dbCol dbSearchColVal dbSearchCol dbIdxValues} {
    #****f* multiWrite/job::db
    # CREATION DATE
    #   03/12/2015 (Thursday Mar 12)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   job::db::multiWrite db dbCol dbSearchCol dbIdxValues
    #   db = Database Name
    #   dbTbl = The DB Table that we are using
    #   dbCol = The Database column where the change occurs
    #   dbSearchCol = The column where the the dbSearchColVal exist
    #   dbSearchColVal = The value that we are searching for in dbSearchCol
    #   dbIdxValues = The records which we are changing
    #   
    #
    # FUNCTION
    #	Writes data to the DB then populates that tablelist widget. This is to be used if we have multiple cells to update.
    #	This uses the WHERE clause and IN expression.
    #   If multiple values are passed through dbIdxValues; they must be passed in, through a comma delimited list.
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log files

    # Update the DB first, then update the tabelist widget.
    #${log}::debug $db eval "UPDATE $dbTbl SET $dbCol='$dbSearchColVal' WHERE $dbSearchCol IN ($dbIdxValues)"
    $db eval "UPDATE $dbTbl SET $dbCol='$dbSearchColVal' WHERE $dbSearchCol IN ($dbIdxValues)"
    
    # Get the total rows of the table
    set dbVal [$db eval "SELECT $dbCol from $dbTbl WHERE Status=1"]
    set dbValCount [llength $dbVal]
    
    for {set x 0; set dbRow 1} {$x < $dbValCount} {incr x; incr dbRow} {
        #${log}::debug $x - Widget Row
        #${log}::debug $dbRow - DB Row
        # We can't use -fillcolumn, because the values could vary.
        $files(tab3f2).tbl cellconfigure $x,$dbCol -text [lindex $dbVal $x]
    }
    
} ;# job::db::multiWrite


proc job::db::updateDB {} {
    #****f* updateDB/job::db
    # CREATION DATE
    #   02/24/2015 (Tuesday Feb 24)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   job::db::updateDB
    #
    # FUNCTION
    #	Verify's the db schema is the latest; if it isn't update the schema
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log job program

    
    set job(db,oldSchema) [$job(db,Name) eval "SELECT max(SchemaVers) FROM SysInfo WHERE ProgramVers = '$program(Version).$program(PatchLevel)'"]
    
    if {$job(db,currentSchemaVers) > $job(db,oldSchema)} {
        ${log}::debug Current Schema: $job(db,currentSchemaVers)
        ${log}::debug DB Schema: $job(db,oldSchema)
        ${log}::debug Job Schema needs to be updated!
        ${log}::debug Updates to apply: [expr {$job(db,currentSchemaVers) - $job(db,oldSchema)}]
        
        set updates [expr {$job(db,oldSchema) + 1}] ;# Add a number, because we will start applying updates before the number can be increased.
        for {set x $updates} {$x <= $job(db,currentSchemaVers)} {incr x} {
            ${log}::info "Updating to schema $x"
            
            set updateProcs [info procs update_*]
            ${log}::info Available update procs: $updateProcs
            if {[lsearch $updateProcs _$x] != -1} {
                ${log}::info "Applying updates to schema $x"
                job::db::update_$x
            } else {
                ${log}::info "No updates to apply, must be adding a table ..."
                # Insert data into Sysinfo table
                $job(db,Name) eval "INSERT INTO SysInfo (ProgramVers, SchemaVers) VALUES ('$program(Version).$program(PatchLevel)', '$job(db,currentSchemaVers)')"
                ${log}::info Job DB Schema is now: [$job(db,Name) eval "SELECT max(SchemaVers) FROM SysInfo WHERE ProgramVers = '$program(Version).$program(PatchLevel)'"]
            }
        }
    }
} ;# job::db::updateDB


proc job::db::update_2 {} {
# Updates the schema
    global log job program

    $job(db,Name) eval "ALTER TABLE Addresses RENAME TO ea_temp_table"
    
    ## Grab the table fields from our main db.
    set hdr [db eval {SELECT InternalHeaderName FROM Headers ORDER BY DisplayOrder}]
    set cTable [list {OrderNumber INTEGER PRIMARY KEY AUTOINCREMENT}]
    
    # Dynamically build the Addresses table
    foreach header $hdr {
        switch -- $header {
            Quantity    {set dataType INTEGER}
            default     {set dataType TEXT}
        }
        lappend cTable "'$header' $dataType"
    }
    set cTable [join $cTable ,]
    
    $job(db,Name) eval "CREATE TABLE IF NOT EXISTS Addresses ( $cTable )"

    set tmpHdr [job::db::retrieveHeaderNames $job(db,Name) Addresses]
    
    set tmpHdr [join $tmpHdr ,]
    $job(db,Name) eval "INSERT INTO Addresses ($tmpHdr) SELECT $tmpHdr FROM ea_temp_table"
    
    $job(db,Name) eval "DROP TABLE ea_temp_table"
    
    # Insert data into Sysinfo table
    $job(db,Name) eval "INSERT INTO SysInfo (ProgramVers, SchemaVers) VALUES ('$program(Version).$program(PatchLevel)', '$job(db,currentSchemaVers)')"
    
    ${log}::info Job DB Schema is now: [$job(db,Name) eval "SELECT max(SchemaVers) FROM SysInfo WHERE ProgramVers = '$program(Version).$program(PatchLevel)'"]
} ;# job::db::update_2


proc job::db::retrieveHeaderNames {db dbTbl} {
    #****f* retrieveHeaderNames/job::db
    # CREATION DATE
    #   02/24/2015 (Tuesday Feb 24)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   job::db::retrieveHeaderNames db dbTbl
    #
    # FUNCTION
    #	Retrieves the header names from the db that we're opening
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log
    
    if {[info exists tmpHdr]} {unset tmpHdr}
    set pragma [$db eval "PRAGMA table_info($dbTbl)"]
    foreach item $pragma {
        if {$item != "" && ![string is digit $item] && ![string is upper $item]} {
            lappend tmpHdr $item
        }
        
    }
    
return $tmpHdr
    
} ;# job::db::retrieveHeaderNames


proc job::db::tableExists {dbTbl} {
    #****f* tableExists/job::db
    # CREATION DATE
    #   03/04/2015 (Wednesday Mar 04)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   job::db::tableExists dbTbl
    #
    # FUNCTION
    #	Returns table name if found, otherwise returns nothing
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log job

    $job(db,Name) eval "SELECT name FROM sqlite_master WHERE type='table' AND name='$dbTbl'"
    
} ;# job::db::tableExists

proc job::db::insertNotes {job_wid log_wid} {
    #****f* insertNotes/job::db
    # CREATION DATE
    #   03/11/2015 (Wednesday Mar 11)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   job::db::insertNotes args 
    #
    # FUNCTION
    #	Inserts or updates the job notes
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log job user
	
    set currentGUID [ea::tools::getGUID]
    
    # Clean up notes first
    set jobNotes [string map {' ''} [$job_wid get 0.0 end]]
    set logNotes [string map {' ''} [$log_wid get 0.0 end]]
    
	# Insert into History table, then into Notes table
    $job(db,Name) eval "INSERT INTO History (Hist_ID, Hist_User, Hist_Date, Hist_Time, Hist_Syslog) VALUES ('$currentGUID', '$user(id)', '[ea::date::getTodaysDate -db]', '[ea::date::currentTime]', '$logNotes')"
	
	$job(db,Name) eval "INSERT INTO Notes (HistID, Notes_Notes) VALUES ('$currentGUID', '$jobNotes')"

} ;# job::db::insertNotes

proc job::db::readNotes {cbox_wid job_wid log_wid} {
    #****f* readNotes/job::db
    # CREATION DATE
    #   03/11/2015 (Wednesday Mar 11)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   job::db::readNotes id jobNotes logNotes 
    #
    # FUNCTION
    #	Reads the database depending on the id passed
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log job hist
    
    set id [$cbox_wid get]
    if {[info exists hist]} {unset hist}
    
    # Re-enable the widget
    #$job_wid configure -state normal

    # Read the Job notes ...
    set jobNotes [join [$job(db,Name) eval "SELECT Notes_Notes FROM Notes WHERE Notes_ID = $id"]]
    
    # Read the log notes ...
    set historyItems [join [$job(db,Name) eval "SELECT Hist_User, Hist_Date, Hist_Time, Hist_SysLog FROM History
                                                INNER JOIN Notes ON Notes.HistID = History.Hist_ID
                                            WHERE Notes.Notes_ID = $id"]]
    set hist(log,User) [lindex $historyItems 0]
    set hist(log,Date) [ea::date::formatDate -db -std [lindex $historyItems 1]]
    set hist(log,Time) [lindex $historyItems 2]
    set hist(log,Log) [lrange $historyItems 3 end]
    
    
    # Clear out the widgets
    $job_wid delete 0.0 end
    $job_wid insert end $jobNotes
    #$job_wid configure -state disabled
    
    $log_wid delete 0.0 end
    $log_wid insert end $hist(log,Log)

} ;# job::db::readNotes

proc job::db::getTotalCopies {} {
    #****f* getTotalCopies/job::db
    # CREATION DATE
    #   03/17/2015 (Tuesday Mar 17)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   job::db::getTotalCopies  
    #
    # FUNCTION
    #	Wrapper around ea::db::countQuantity, to allow us to change neccessary sql in one place only
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log job

    set job(TotalCopies) [ea::db::countQuantity $job(db,Name) Addresses Quantity -statusName Status -status 1]
    
} ;# job::db::getTotalCopies


proc job::db::insertDefaultData {} {
    #****f* insertDefaultData/job::db
    # CREATION DATE
    #   05/19/2015 (Tuesday May 19)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   job::db::insertDefaultData  
    #
    # FUNCTION
    #	Inserts default data into these tables: Versions, NoteTypes and ExportType
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log job

    $job(db,Name) eval "INSERT INTO Versions (VersionName) VALUES ('Version 1')"
    
    foreach noteType [list Title Job Version {Distribution Type} {Shipping Order}] {
        $job(db,Name) eval "INSERT INTO NoteTypes (NoteType) VALUES ('$noteType')"
    }
    
    foreach exportType [list Planner {Process Shipper} Report] {
        $job(db,Name) eval "INSERT INTO ExportTypes (ExportType) VALUES ('$exportType')"
    }

    
} ;# job::db::insertDefaultData

proc job::db::insertTitleInfo {args} {
    #****f* insertTitleInfo/job::db
    # CREATION DATE
    #   05/19/2015 (Tuesday May 19)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   job::db::insertTitleInfo -title <value> -csr <value> -saveLocation <value> -custcode <value> -histnote 
    #
    # FUNCTION
    #	Inserts title information into the TitleInformation table; returns the TitleInformation_ID value.
    #   
    #   
    # CHILDREN
    #	job::db::insertHistory
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log job
    
    if {[info exists hdrs]} {unset hdrs}
    if {[info exists values]} {unset values}

    foreach {key value} $args {
        switch -- $key {
            -title          {lappend hdrs TitleName; lappend values '$value'}
            -csr            {lappend hdrs CSRName; lappend values '$value'}
            -saveLocation   {lappend hdrs TitleSaveLocation; lappend values '$value'}
            -custcode       {lappend hdrs CustCode; lappend values '$value'}
            -histnote       {set histnote $value}
        }
    }
    lappend hdrs HistoryID
    lappend values '[job::db::insertHistory $histnote]'
    
    ${log}::debug Inserted Title Information into table: TitleInformation
    $job(db,Name) eval "INSERT INTO TitleInformation([join $hdrs ,]) VALUES([join $values ,])"

    return [$job(db,Name) eval "SELECT seq FROM sqlite_sequence WHERE name='TitleInformation'"]
    
} ;# job::db::insertTitleInfo -title {Test Title} -csr {Lyn Lovell} -saveLocation {c:/tmp} -custcode {TEMCUS} -histnote {Initialize the Title DB}

proc job::db::insertJobInfo {args} {
    #****f* insertJobInfo/job::db
    # CREATION DATE
    #   05/20/2015 (Wednesday May 20)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   job::db::insertJobInfo -jNumber <value> -jName <value> -jSaveLocation <value> -jDateShipStart <value> -jDateShipBalance <value> -titleid <value> -histnote <value>
    #
    # FUNCTION
    #	Inserts the Job information
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   DB Table: JobInformation, History
    #   DB Columns: JobName, JobInformation_ID, JobSaveLocation, JobFirstShipDate, JobBalanceShipDate, TitleInformationID
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log job

    if {[info exists hdrs]} {unset hdrs}
    if {[info exists values]} {unset values}

    foreach {key value} $args {
        switch -- $key {
            -jNumber            {lappend hdrs JobInformation_ID; lappend values '$value'}
            -jName              {lappend hdrs JobName; lappend values '$value'}
            -jSaveLocation      {lappend hdrs JobSaveLocation; lappend values '$value'}
            -jDateShipStart     {lappend hdrs JobFirstShipDate; lappend values '$value'}
            -jDateShipBalance   {lappend hdrs JobBalanceShipDate; lappend values '$value'}
            -titleid            {lappend hdrs TitleInformationID; lappend values $value; #No single quotes, this is an integer}
            -histnote           {set histnote $value}
        }
    }
    lappend hdrs HistoryID
    lappend values '[job::db::insertHistory $histnote]'

    ${log}::debug Inserted Job Information into table: JobInformation
    ${log}::debug hdrs: $hdrs
    ${log}::debug VALUES([join $values ,])
    $job(db,Name) eval "INSERT INTO JobInformation([join $hdrs ,]) VALUES([join $values ,])"
    
} ;# job::db::insertJobInfo -jNumber 304503 -jName {March 2015} -jSaveLocation {C:/tmp/job} -jDateShipStart 2015-05-20 -jDateShipBalance 2015-05-29 -titleid <value> -histnote {Inserting a new Job}


proc job::db::insertHistory {args} {
    #****f* insertHistory/job::db
    # CREATION DATE
    #   05/19/2015 (Tuesday May 19)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   job::db::insertHistory args 
    #
    # FUNCTION
    #	Inserts data into the history table, returns the HistoryID (GUID)
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log job user

    set currentDate [ea::date::getTodaysDate -db]
    set histGUID [ea::tools::getGUID]
    set currentTime [ea::date::currentTime]

    $job(db,Name) eval "INSERT INTO History (History_ID, HistUser, HistDate, HistTime, HistSysLog) VALUES ('$histGUID', '$user(id)', '$currentDate', '$currentTime', '[join $args]')"
    
    return $histGUID
} ;# job::db::insertHistory
