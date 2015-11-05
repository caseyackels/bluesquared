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
# Create the per title databases

namespace eval job::db {}
namespace eval title::db {}


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
    global log job user w
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
            -jForestCert    {
                                set jForestCert $value
            }
            default         {${log}::critical $currentProcName [info level 0] Passed invalid args $args; return}
        }
    }
    
    # ensure we have the correct number of args
    if {[llength $args] != 24} {
        ${log}::critical $currentProcName [info level 0] \nDid not pass sufficient number of args: [llength $args] should be 24
        return
    }
    
    set job(db,Name) [join "$tCustCode [join [split $tName " "] ""]" _]
    
    # Update tab title, see [job::db::insertJobInfo]
    #ea::helper::updateTabText "$jNumber: $tName $jName"
    
    # Check to see if the db already exists; if it does launch the updateTitleDb proc
    #set dbExists [file exists [file join $tSaveLocation $job(db,Name).db]]
    
    #if {$dbExists} {${log}::debug Database Exists, Updating existing data; job::db::UpdateJobData; return}


    ${log}::notice Creating a new database for: $tCustCode $tName

    # Create the database
    sqlite3 $job(db,Name) [file join $tSaveLocation $job(db,Name).db] -create 1

    ${log}::notice Title DB: Creating static tables...
    $job(db,Name) eval {
        
        CREATE TABLE IF NOT EXISTS Versions (
            Version_ID    INTEGER PRIMARY KEY AUTOINCREMENT,
            VersionName   TEXT    UNIQUE ON CONFLICT ROLLBACK
                                  NOT NULL ON CONFLICT ROLLBACK,
            VersionActive BOOLEAN NOT NULL ON CONFLICT ROLLBACK
                                  DEFAULT (1)
        );
        
        -- # This table is pre-populated by [job::db::insertDefaultData], the only thing the user shoud be able to change is the "IncludeOnReports" column.
        CREATE TABLE IF NOT EXISTS NoteTypes (
            NoteType_ID      INTEGER PRIMARY KEY AUTOINCREMENT,
            NoteType         TEXT    NOT NULL ON CONFLICT ROLLBACK,
            IncludeOnReports BOOLEAN NOT NULL
                                     DEFAULT (1),
            Active           BOOLEAN DEFAULT (1) 
                                     NOT NULL
        );
        

        CREATE TABLE IF NOT EXISTS Notes (       
            Notes_ID   INTEGER PRIMARY KEY AUTOINCREMENT,
            HistoryID  INTEGER NOT NULL ON CONFLICT ROLLBACK
                               REFERENCES History (History_ID) ON UPDATE CASCADE,
            NoteTypeID INTEGER REFERENCES NoteTypes (NoteType_ID) ON UPDATE CASCADE
                               NOT NULL ON CONFLICT ROLLBACK,
            NotesText  TEXT    NOT NULL ON CONFLICT ROLLBACK,
            Active     BOOLEAN DEFAULT (1) 
                               NOT NULL ON CONFLICT ROLLBACK
        );

        CREATE TABLE IF NOT EXISTS History (
            History_ID TEXT PRIMARY KEY
                            NOT NULL ON CONFLICT ROLLBACK
                            UNIQUE ON CONFLICT ROLLBACK,
            HistUser   TEXT NOT NULL ON CONFLICT ROLLBACK,
            HistDate   DATE NOT NULL ON CONFLICT ROLLBACK,
            HistTime   TIME NOT NULL ON CONFLICT ROLLBACK,
            HistSysLog TEXT
            

        );
       
        CREATE TABLE IF NOT EXISTS SysInfo (
            SysInfo_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            SysSchema  INTEGER UNIQUE
                               NOT NULL,
            HistoryID  TEXT    REFERENCES History (History_ID) ON UPDATE CASCADE
                                                                ON DELETE CASCADE
        );
        
        CREATE TABLE IF NOT EXISTS TitleInformation (
            TitleInformation_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            NotesID             INTEGER REFERENCES Notes (Notes_ID) ON UPDATE CASCADE,
            HistoryID           TEXT    REFERENCES History (History_ID) ON UPDATE CASCADE
                                        NOT NULL ON CONFLICT ROLLBACK,
            CustCode            TEXT    NOT NULL ON CONFLICT ROLLBACK,
            CSRName             TEXT    NOT NULL ON CONFLICT ROLLBACK,
            TitleName           TEXT    NOT NULL ON CONFLICT ROLLBACK,
            TitleSaveLocation   TEXT    NOT NULL ON CONFLICT ROLLBACK
        );
        
        --# JobInformation_ID = Job Number
        CREATE TABLE JobInformation (
            JobInformation_ID  TEXT    UNIQUE ON CONFLICT ROLLBACK
                                       NOT NULL ON CONFLICT ROLLBACK
                                       PRIMARY KEY ASC ON CONFLICT ROLLBACK,
            JobName            TEXT    NOT NULL ON CONFLICT ROLLBACK,
            JobSaveLocation    TEXT    NOT NULL ON CONFLICT ROLLBACK,
            JobFirstShipDate   DATE,
            JobBalanceShipDate DATE,
            JobForestCert      TEXT,
            TitleInformationID INTEGER REFERENCES TitleInformation (TitleInformation_ID) ON UPDATE CASCADE
                                       NOT NULL ON CONFLICT ROLLBACK,
            HistoryID          TEXT    REFERENCES History (History_ID) ON UPDATE CASCADE
                                                                       ON DELETE CASCADE
                                       NOT NULL ON CONFLICT ROLLBACK
        );
        
        CREATE TABLE IF NOT EXISTS Published (
            Published_ID     INTEGER PRIMARY KEY AUTOINCREMENT,
            NotesID          TEXT    REFERENCES Notes (Notes_ID) ON UPDATE CASCADE,
            JobInformationID TEXT    REFERENCES JobInformation (JobInformation_ID) ON UPDATE CASCADE
                                     NOT NULL ON CONFLICT ROLLBACK,
            PublishedRev     INTEGER NOT NULL ON CONFLICT ROLLBACK
        );
        
        CREATE TABLE InternalSamples (
            InternalSamples_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            ShippingOrderID    INTEGER REFERENCES ShippingOrders (ShippingOrder_ID) ON DELETE CASCADE
                                                                                    ON UPDATE CASCADE,
            Location           TEXT,
            Quantity           INTEGER,
            Notes              TEXT
        );
        
        PRAGMA foreign_keys = on
    }
    
    # This table should be auto-generated, depending on what header is assigned to what group.
    # Shipping Orders should contain groups: Shipping Order, Packaging
    # Basic setup
    # *** Table: ShippingOrders ***
    set sTable [list \
        {ShippingOrder_ID   INTEGER PRIMARY KEY AUTOINCREMENT} \
        {JobInformationID   TEXT  NOT NULL ON CONFLICT ROLLBACK
                                    REFERENCES JobInformation (JobInformation_ID) ON DELETE NO ACTION
                                                                                    ON UPDATE CASCADE} \
        {AddressID          TEXT  NOT NULL ON CONFLICT ROLLBACK
                                    REFERENCES Addresses (SysAddresses_ID) ON DELETE CASCADE
                                                                            ON UPDATE CASCADE} \
        {Hidden             BOOLEAN DEFAULT (0) NOT NULL ON CONFLICT ROLLBACK}  \
        {Versions          INTEGER REFERENCES Versions (Version_ID) ON UPDATE CASCADE
                                                                    ON DELETE NO ACTION}]

    # Create the ShippingOrder table (Consignee group)
    db eval {SELECT dbColName, dbDataType FROM HeadersConfig
                WHERE widUIGroup <> 'Consignee'
                ORDER BY widUIPositionWeight ASC, DBColName ASC} {
                    # Bypass the possiblity that the user created a 'versions' column.
                    if {[string tolower $dbColName] eq "versions"} {
                            continue
                    } else {
                        lappend sTable "$dbColName $dbDataType"
                    }
    }

    ${log}::notice Title DB: Creating Table:ShippingOrders (Group:Shipping Order, Packaging)
    $job(db,Name) eval "CREATE TABLE IF NOT EXISTS ShippingOrders ( [join $sTable ,] )"
    
    
    # Dynamically build the Addresses table using data from the main db (Headers Config)
    # AddressParentID - This is the ID of the first entry in that family
    # AddressChildID - Incremented field: 0 (Duplicate), 1 (Original Entry) 2+ (revisions to the original record)
    #   Duplicate: After importing, and user verification, if any duplicates exist (AddressChildID = 0), then we will delete those records.
    # *** Table: Addresses ***
    set cTable [list \
        {SysAddresses_ID    TEXT    PRIMARY KEY ON CONFLICT ROLLBACK
                                    UNIQUE ON CONFLICT ROLLBACK
                                    NOT NULL ON CONFLICT ROLLBACK} \
        {SysNotesID         TEXT    REFERENCES Notes (Notes_ID) ON UPDATE CASCADE
                                                                ON DELETE CASCADE} \
        {SysAddressParentID TEXT} \
        {SysAddressChild    INTEGER} \
        {SysActive          BOOLEAN DEFAULT (1) NOT NULL ON CONFLICT ROLLBACK} \
        {HistoryID          TEXT    REFERENCES History (History_ID) ON UPDATE CASCADE
                                                                    ON DELETE CASCADE
                                    NOT NULL ON CONFLICT ROLLBACK}]
    
    # Create the Addresses table (Consignee group)
    db eval {SELECT dbColName, dbDataType FROM HeadersConfig
                WHERE widUIGroup = 'Consignee'
                ORDER BY widUIPositionWeight ASC, DBColName ASC} {
            lappend cTable "$dbColName $dbDataType"
    }

    ${log}::notice Title DB: Creating Table:Addresses (Group:Consignee)
    $job(db,Name) eval "CREATE TABLE IF NOT EXISTS Addresses ( [join $cTable ,] )"
    
    
    job::db::insertDefaultData
    ${log}::notice Title DB: Inserted default data...
    
    #INSERT TITLE AND GET ID
    set titleID [job::db::insertTitleInfo -title $tName -csr $tCSR -saveLocation $tSaveLocation -custcode $tCustCode -histnote $tHistNote]
    ${log}::notice Title DB: Inserted title data...
    
    #INSERT JOB
    ${log}::notice Title DB: Inserted job data...
    job::db::insertJobInfo -jNumber $jNumber -jName $jName -jSaveLocation $jSaveLocation -jDateShipStart $jShipStart -jDateShipBalance $jShipBal -titleid $titleID -histnote $jHistNote -jForestCert $jForestCert
       
} ;# job::db::createDB

## TEST
## CREATE DB
#job::db::createDB SAGMED {Meredith Hunter} TEST001 Febraury 303603 {c:/tmp}
## INSERT TITLE AND GET ID
# set titleID [job::db::insertTitleInfo -title {Test Title} -csr {Lyn Lovell} -saveLocation {c:/tmp} -custcode {TEMCUS} -histnote {Initialize the Title DB}]
## INSERT JOB
#job::db::insertJobInfo -jNumber 304503 -jName {March 2015} -jSaveLocation {C:/tmp/job} -jDateShipStart 2015-05-20 -jDateShipBalance 2015-05-29 -titleid $titleID -histnote {Inserting a new Job}

proc job::db::open {args} {
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
    #   job::db::open ?args?
    #
    # FUNCTION
    #	Launches the browse dialog; loads the selected database based on the file that we've opened.
    #	args = path to menu item to set to normal from disabled
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
    
    ${log}::notice Opening an existing database file...

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
    
    $job(db,Name) eval "PRAGMA foreign_keys = on"
    $job(db,Name) eval "SELECT max(TitleInformation_ID), CustCode, CSRName, TitleSaveLocation, TitleName
                            FROM TitleInformation" {
                                set job(CustID) $CustCode
                                set job(CSRName) $CSRName
                                set job(TitleSaveFileLocation) $TitleSaveLocation
                                set job(Title) $TitleName
                            }
    
    set job(CustName) [join [db eval "SELECT CustName From Customer where Cust_ID='$job(CustID)'"]]
    
    # Set last job number, so we have a place to start
    $job(db,Name) eval "SELECT JobInformation_ID, JobName, JobSaveLocation, JobFirstShipDate, JobBalanceShipDate, max(History.HistDate), max(History.HistTime) FROM JobInformation
                                                INNER JOIN History
                                            ON JobInformation.HistoryID = History.History_ID" {
                                                set job(Number) $JobInformation_ID
                                                set job(Name) $JobName
                                                set job(JobBalanceShipDate) $JobBalanceShipDate
                                                set job(JobFirstShipDate) $JobFirstShipDate
                                                set job(JobSaveFileLocation) $JobSaveLocation
                                            }
                                            
    ea::helper::updateTabText "$job(Number): $job(Title) $job(Name)"

    ## Check db schema to see if it needs to be updated ...
    #job::db::updateDB

    
    # Insert the data into the tablelist
    importFiles::insertIntoGUI $files(tab3f2).tbl
    
    # Apply the highlights
    importFiles::highlightAllRecords $files(tab3f2).tbl
    
    # Get total copies
    job::db::getTotalCopies
    
    ## Initialize popup menus
    IFMenus::createToggleMenu $files(tab3f2).tbl
    
    # Allow the user to select the job menu
    $args entryconfigure 1 -state normal
} ;# job::db::open


proc job::db::write {db dbTbl dbTxt wid widCells widRows idList {dbCol ""}} {
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
    #   job::db::write db dbTbl dbTxt wid widCells widRows idList ?dbCol?
    #   job::db::write <dbName> <dbTable> <text> <widTbl> <row,col> ?Db Col Name?
    #
    # FUNCTION
    #	Writes data to the widget cell and database.
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
    global log job headerParent

    if {$dbCol eq ""} {
        # retrieves the column name if we didn't pass it to the proc.
        set dbCol [$wid columncget [lindex [split $widCells ,] end] -name]
    }
    
    if {[lsearch $headerParent(headerList,consignee) $dbCol] != -1} {
        set dbTbl Addresses
        set addressID SysAddresses_ID
    } elseif {[lsearch $headerParent(headerList,shippingorder) $dbCol] != -1} {
        set dbTbl ShippingOrders
        set addressID AddressID
    }
    
    # Need to encapsulate in single quotes; Note: if inserting a Version we overwrite this var.
    set dbTxt '$dbTxt'
    
    #set addressesID SysAddresses_ID
    # Versions
    if {[string match -nocase *vers* $dbCol]} {
        # table:Addresses contain a Versions column for the VersionID from table:Version.
        # We must first look at the version table to see if there is an existing version; if there isn't we must add it.
        #${log}::debug $job(db,Name) eval "SELECT VersionName from Versions WHERE VersionName='$dbTxt'"
        set versionName [$job(db,Name) eval "SELECT VersionName from Versions WHERE VersionName='$dbTxt'"]

        if {$versionName eq ""} {
                    # Value doesn't exist in db, lets add it.
                    $job(db,Name) eval "INSERT INTO Versions (VersionName) VALUES ('$dbTxt')"
                    ${log}::debug Value doesn't exist in db, adding $dbTxt
                    
                    set dbTxt [$job(db,Name) eval "SELECT max(Version_ID) FROM Versions"]
                    ${log}::debug Versions ID: $dbTxt
            } else {
                # We matched a version name, so we aren't adding a new one. get the id of the new version
                set versID [$job(db,Name) eval "SELECT Version_ID FROM Versions WHERE VersionName='$dbTxt'"]
                ${log}::debug $dbTxt exists in db - ID: $versID
                
                set dbTxt $versID
            }

        set dbTbl Addresses
        #set addressesID AddressID
    }
  
    
    ${log}::debug sql: update $dbTbl SET $dbCol=$dbTxt WHERE $addressID IN ([join $idList ,])
    $job(db,Name) eval "UPDATE $dbTbl SET $dbCol=$dbTxt WHERE $addressID IN ([join $idList ,])"

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

proc job::db::insertNotes {job_wid log_wid args} {
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
    #	Inserts the job notes
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   This proc is specific to the Notes on the Job (Deprecated)
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log job user
	
    set historyGUID [ea::tools::getGUID]
    #set notesGUID [ea::tools::getGUID]
    
    # Clean up notes first
    set jobNotes [join [string trim [string map {' ''} [$job_wid get 0.0 end]]]]
    #set jobNotes [join [string trim [string map {' ''} [.notes.f1.txt get 0.0 end]]]]
    ${log}::debug jobNotes: $job_wid $jobNotes
    
    
    set logNotes [string map {' ''} [$log_wid get 0.0 end]]
    
    # Get Note Type (Levels): Title, Job, Version, DistributionType, ShippingOrder(?)
    switch -- $args {
        -title      {set noteTypeID Title}
        -job        {set noteTypeID Job}
        -version    {set noteTypeID Version}
        -distributiontype   {set noteTypeID DistributionType}
        -shippingorder  {set noteTypeID ShippingOrder}
    }
    
    set noteType [$job(db,Name) eval "SELECT NoteType_ID FROM NoteTypes WHERE NoteType='$noteTypeID' AND Active=1"]
    #${log}::debug noteType: $noteType
    #${log}::debug noteType-sql: SELECT NoteType_ID FROM NoteTypes WHERE NoteType='$noteTypeID' AND Active=1
    
	# Insert into History table, then into Notes table
    $job(db,Name) eval "INSERT INTO History (History_ID, HistUser, HistDate, HistTime, HistSyslog) VALUES ('$historyGUID', '$user(id)', '[ea::date::getTodaysDate -db]', '[ea::date::currentTime]', '$logNotes')"
	
	$job(db,Name) eval "INSERT INTO Notes (HistoryID, NoteTypeID, NotesText) VALUES ('$historyGUID', $noteType,'$jobNotes')"

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
    if {$id eq ""} {return}
    if {[info exists hist]} {unset hist}

    # Read the Job notes ...
    set jobNotes [join [$job(db,Name) eval "SELECT NotesText FROM Notes WHERE Notes_ID = $id"]]
    
    # Read the log notes ...
    set historyItems [join [$job(db,Name) eval "SELECT HistUser, HistDate, HistTime, HistSysLog FROM History
                                                    INNER JOIN Notes ON Notes.HistoryID = History.History_ID
                                                WHERE Notes.Notes_ID = $id"]]
    set hist(log,User) [lindex $historyItems 0]
    set hist(log,Date) [ea::date::formatDate -db -std [lindex $historyItems 1]]
    set hist(log,Time) [lindex $historyItems 2]
    set hist(log,Log) [lrange $historyItems 3 end]
    
    
    # Clear out the widgets
    $job_wid delete 0.0 end
    $job_wid insert end $jobNotes
    
    $log_wid delete 0.0 end
    $log_wid insert end $hist(log,Log)

} ;# job::db::readNotes

proc job::db::getTotalCopies {args} {
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
    #	ea::db::countQuantity
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
    
    if {![info exists job(Number)]} {${log}::notice [info level 0] - [mc "Job Number isn't set; count label will not be updated."]; return}
    if {$args ne ""} {
        foreach {key value} $args {
            switch -- $key {
                -version    {set vers $value}
                default     {return}
            }
        }
    }
    #if {[info exists vers]} {set and "AND Hidden != 1 AND V"}
    
    set job(TotalCopies) [ea::db::countQuantity -db $job(db,Name) -job $job(Number) -and "AND Hidden != 1"]
    
} ;# job::db::getTotalCopies

proc job::db::getVersionCount {args} {
    #****f* getVersionCount/job::db
    # CREATION DATE
    #   10/02/2015 (Friday Oct 02)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   Valid args are
    #       -type (one of: countqty, numofversions, names, id) Returns the value for the type given
    #       -version <version name> ; defaults to all versions
    #       -job <job Number> ; defaults to current active job $job(Number)
    #       -versActive 1|0 ; defaults to 1
    #       -addrActive 1|0 ; defaults to 1
    #       -hidden 1|0 ; defaults to 0 
    #   
    #***
    global log job

    if {$args eq ""} {return}
    
    foreach {key value} $args {
        switch -- $key {
            -type       {set type $value}
            -version    {lappend and "VersionName = '$value'"}
            -job        {set jobNumber $value; lappend and "JobInformationID = '$value'"}
            -versActive {set versActive $value; lappend and "Versions.VersionActive = $value"}
            -addrActive {set addrActive $value; lappend and "Addresses.SysActive = $value"}
            -hidden     {set hidden $value; lappend and "ShippingOrders.Hidden = $value"}
            default     {${log}::debug [info level 0] switch parameter $key isn't valid}
        }
    }
    
    if {![info exists type]} {${log}::debug Type doesn't exist, must be one of: countqty, numofversions, name; return}
    if {![info exists jobNumber]} {lappend and "JobInformationID = $job(Number)"}
    if {![info exists versActive]} {lappend and "Versions.VersionActive = 1"}
    if {![info exists addrActive]} {lappend and "Addresses.SysActive = 1"}
    if {![info exists hidden]} {lappend and "ShippingOrders.Hidden = 0"}
    
    
    if {[string tolower $type] eq "countqty"} {
        set colvalue sum(Quantity)
    
    } elseif {[string tolower $type] eq "numofversions"} {
        set colvalue count(Quantity)
        
    } elseif {[string tolower $type] eq "names"} {
        set colvalue "DISTINCT(Versions.VersionName) as Versions"
    
    } elseif {[string tolower $type] eq "id"} {
        set colvalue "DISTINCT(Versions.Version_ID) as id"
    }

    set and [join $and " AND "]
    set sql "SELECT $colvalue FROM ShippingOrders
                            INNER JOIN Addresses ON Addresses.SysAddresses_ID = ShippingOrders.AddressID
                            INNER JOIN Versions ON ShippingOrders.Versions = Versions.Version_ID
                            WHERE $and"
                            
    $job(db,Name) eval $sql

} ;# job::db::getVersionCount -type id -job $job(Number) -version <> -versActive 1 -addrActive 1

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
    #	Inserts default data upon Title db creation
    #	Tables: Versions and NoteTypes
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
    
    $job(db,Name) eval "INSERT INTO NoteTypes (NoteType)
                            VALUES ('Title'),('Job'),('Version'),('Distribution Type'),('Shipping Order'),('Publish')"
    
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
            -title          {lappend hdrs TitleName; lappend values '$value'; set tName '$value'}
            -csr            {lappend hdrs CSRName; lappend values '$value'; set tCSRName '$value'}
            -saveLocation   {lappend hdrs TitleSaveLocation; lappend values '$value'; set tSaveLocation '$value'}
            -custcode       {lappend hdrs CustCode; lappend values '$value'; set tCustCode '$value'}
            -histnote       {set histnote $value}
        }
    }
    lappend hdrs HistoryID
    lappend values '[job::db::insertHistory $histnote]'
    
    # Check to see if it the title has already been entered into the DB. if it has, we'll issue an update statement
    
    ${log}::notice Inserted Title Information into table: TitleInformation
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
    #	This proc will automatically figure out if we need to INSERT or UPDATE into the Database, then issue the correct command and syntax. If we are adding a new
    #   job, we will reset the tablelist widget.
    #   DB Table: JobInformation, History
    #   DB Columns: JobName, JobInformation_ID, JobSaveLocation, JobFirstShipDate, JobBalanceShipDate, TitleInformationID, HistoryID
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
    global log job files

    if {[info exists hdrs]} {unset hdrs}
    if {[info exists values]} {unset values}

    foreach {key value} $args {
        switch -- $key {
            -jNumber            {lappend hdrs JobInformation_ID; lappend values '$value'; set jNumber '$value'}
            -jName              {lappend hdrs JobName; lappend values '$value'; set jName '$value'}
            -jSaveLocation      {lappend hdrs JobSaveLocation; lappend values '$value'; set jSaveLocation '$value'}
            -jDateShipStart     {lappend hdrs JobFirstShipDate; lappend values '$value'; set jDateShipState '$value'}
            -jDateShipBalance   {lappend hdrs JobBalanceShipDate; lappend values '$value'; set jDateShipBalance '$value'}
            -titleid            {lappend hdrs TitleInformationID; lappend values $value; set titleid $value; # No single quotes, this is an integer}
            -histnote           {set histnote '[job::db::insertHistory $value]'; lappend hdrs HistoryID; lappend values $histnote}
            -jForestCert        {lappend hdrs JobForestCert; lappend values '$value'; set jForestCert '$value'}
        }
    }
    
    # Update tab title
    ea::helper::updateTabText "$job(Number): $job(Title) $job(Name)"

    # Check to see if we need to INSERT or UPDATE
    set jobExists [$job(db,Name) eval "SELECT JobInformation_ID from JobInformation where JobInformation_ID = $jNumber"]
    
    ${log}::notice TitleDB: Inserting into JobInformation, job exists? $jobExists

    if {$jobExists != ""} {
        ${log}::notice TitleDB: updating existing job info: $jNumber, $jName
        ${log}::debug sql: SET JobInformation_ID = $jNumber, JobName = $jName, JobSaveLocation = $jSaveLocation, TitleInformationID = $titleid, HistoryID = $histnote
        $job(db,Name) eval "UPDATE JobInformation
                                SET JobInformation_ID = $jNumber,
                                    JobName = $jName,
                                    JobSaveLocation = $jSaveLocation,
                                    TitleInformationID = $titleid,
                                    HistoryID = $histnote,
                                    JobForestCert = $jForestCert
                                WHERE JobInformation_ID = $jNumber"
    } else {
        ${log}::notice TitleDB: Inserting new job info into db, clearing out the tablelist widget
        ${log}::debug hdrs: [join $hdrs ,]
        ${log}::debug values: [join $values ,]
        $job(db,Name) eval "INSERT INTO JobInformation ([join $hdrs ,]) VALUES ([join $values ,])"
        
        # make sure we are starting new, remove rows and columns
        if {[$files(tab3f2).tbl size] != 0} {$files(tab3f2).tbl delete 0 end}
        if {[$files(tab3f2).tbl columncount] != 0} {$files(tab3f2).tbl deletecolumns 0 end}
        #importFiles::insertIntoGUI $files(tab3f2).tbl
    }

} ;# job::db::insertJobInfo -jNumber 304503 -jName {March 2015} -jSaveLocation {C:/tmp/job} -jDateShipStart 2015-05-20 -jDateShipBalance 2015-05-29 -titleid <value> -histnote {Inserting a new Job}


proc job::db::showJob {jobNumber} {
    #****if* showJob/job::db
    # CREATION DATE
    #   08/13/2015 (Thursday Aug 13)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   This will reset the tablelist widget, and bring in the job numbers that are passed through to the proc.
    #   
    #***
    global log files
    
    $files(tab3f2).tbl delete 0 end
    
    db eval "SELECT"

    

    
} ;# job::db::showJob

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
    #   args = note for history transaction. e.g. "Removed address assignment from job #?????"
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
} ;# job::db::insertHistory ?note?

proc job::db::getVersion {args} {
    #****if* getVersion/job::db
    # CREATION DATE
    #   09/28/2015 (Monday Sep 28)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   Returns {id VersionName}
    #   Only one of -name OR -id can be issued, if both are passed last match wins
    #***
    global log job

    set active ""

    foreach {key value} $args {
        switch -- $key {
            -name   {set where "VersionName='${value}'"}
            -id     {set where "Version_ID=$value"}
            -active {set active $value}
            default {}
        }
    }
    
    if {$active == ""} {${log}::debug Must pass the -active parameter, aborting.; return} 

    return [$job(db,Name) eval "SELECT Version_ID, VersionName FROM Versions WHERE VersionActive=$active AND $where"]
} ;# job::db::getVersion

proc job::db::getUsedVersions {args} {
    #****if* getUsedVersions/job::db
    # CREATION DATE
    #   10/02/2015 (Friday Oct 02)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   With no paramters, all used (active and inactive) versions are returned
    #   -job = Job Number that you want to query on
    #   -active = 1|0 
    #   
    #***
    global log job

    if {$args ne ""} {
        foreach {key value} $args {
            switch -- $key {
                -job    {set jobNumber $value}
                -active {set active $value}
                default {}
           }
        }
    }
    
    # Set the basic sql statement
    set sql "SELECT distinct(VersionName) FROM Addresses
                        INNER JOIN Versions ON Versions.Version_ID = ShippingOrders.Versions
                        INNER JOIN ShippingOrders on ShippingOrders.AddressID = Addresses.SysAddresses_ID"
    
    if {[info exists active]} {
        set where "WHERE Addresses.SysActive = $active"
    } else {
        # if nothing is supplied, return all used versions
        set where "WHERE Addresses.SysActive = 1 OR 0"
    }
    
    if {[info exists jobNumber]} {
        # If a job number isn't supplied, return all jobs
        set where "$where AND ShippingOrders.JobInformationID = '$jobNumber'"
    }
    
    
    return [$job(db,Name) eval "$sql $where ORDER BY VersionName ASC"]

} ;# job::db::getUsedVersions -active 1 -job $job(Number)

proc job::db::getNotes {args} {
    #****if* getNotes/job::db
    # CREATION DATE
    #   10/01/2015 (Thursday Oct 01)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   Retuns the notes that match the given paramters.
    #   -noteType <Title, Job, Version>
    #   -includeOnReports 1|0
    #   -noteTypeActive 1|0
    #   -notesActive 1|0
    #   
    #***
    global log job
    
    foreach {key value} $args {
        switch -- $key {
            -noteType           {set noteType $value}
            -includeOnReports   {if {[string is integer $value]} {set includeOnReports $value} else {${log}::debug [info level 0] Paramter for $key must be an integer; return}}
            -noteTypeActive     {if {[string is integer $value]} {set noteTypeActive $value} else {${log}::debug [info level 0] Paramter for $key must be an integer; return}}
            -notesActive        {if {[string is integer $value]} {set notesActive $value} else {${log}::debug [info level 0] Paramter for $key must be an integer; return}}
            default             {${log}::debug [info level 0] Invalid parameter - $value, must be on or all of: -noteType, -includeOnReports, -noteTypeActive, -notesActive; return}
        }
    }

    set values [$job(db,Name) eval "SELECT max(Notes_ID), NotesText FROM Notes
                                                INNER JOIN NoteTypes on Notes.NoteTypeID = NoteTypes.NoteType_ID
                                                WHERE NoteType = '$noteType'
                                                    AND NoteTypes.IncludeOnReports = $includeOnReports
                                                    AND NoteTypes.Active = $noteTypeActive
                                                    AND Notes.Active = $notesActive"]
    return [lindex $values 1]
    
} ;# job::db::getNotes -noteType Job -includeOnReports 1 -noteTypeActive 1 -notesActive 1

proc job::db::getUsedDistributionTypes {args} {
    #****if* getUsedDistributionTypes/job::db
    # CREATION DATE
    #   10/02/2015 (Friday Oct 02)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   
    #   
    #***
    global log job

    foreach {key value} $args {
        switch -- $key {
            -version    {set version $value}
            -unique     { if {$value eq "yes"} {
                            set colvalue distinct(DistributionType)
                            } elseif {$value eq "no"} {
                                set colvalue DistributionType
                            }
                        }
            -order      {set order $value}
        }
    }
    
    if {![info exists version]} {return}
    if {![info exists colvalue]} {return}
    if {![info exists order]} {set order ASC}

    return [$job(db,Name) eval "SELECT $colvalue FROM ShippingOrders
                                    INNER JOIN Addresses on ShippingOrders.AddressID = Addresses.SysAddresses_ID
                                    INNER JOIN Versions on Versions.Version_ID = ShippingOrders.Versions
                                    WHERE Versions.VersionName = '$version'
                                AND Versions.VersionActive = 1
                                    ORDER BY Addresses.DistributionType $order"]
} ;# job::db::getUsedDistributionTypes -version $vers -unique yes

proc job::db::getDistTypeCounts {args} {
    #****if* getDistTypeCounts/job::db
    # CREATION DATE
    #   10/02/2015 (Friday Oct 02)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   
    #   
    #***
    global log job
    
    if {$args eq ""} {return}
    
    foreach {key value} $args {
        switch -- $key {
            -type       {set type $value}
            -dist       {set dist $value}
            -job        {set jobNumber $value}
            -addrActive {set addrActive $value}
            default     {}
        }
    }
    if {![info exists type]} {return}
    if {![info exists addrActive]} {set addrActive 1}
    
    if {[string tolower $type] eq "numofshipments"} {
        set colvalue count(Quantity)
    
    } elseif {[string tolower $type] eq "qtyindisttype"} {
        set colvalue sum(Quantity)
    }

    $job(db,Name) eval "SELECT $colvalue FROM ShippingOrders
                            INNER JOIN Addresses ON Addresses.SysAddresses_ID = ShippingOrders.AddressID
                            INNER JOIN Versions ON ShippingOrders.Versions = Versions.Version_ID
                                WHERE ShippingOrders.JobInformationID = '$jobNumber'
                                    AND ShippingOrders.Hidden = 0
                                    AND Addresses.SysActive = $addrActive
                                    AND DistributionType = '$dist'"

} ;# job::db::getDistTypeCounts -type countqty -dist $dist -job $job(Number)

proc job::db::getShipDate {args} {
    #****if* getShipDate/job::db
    # CREATION DATE
    #   10/05/2015 (Monday Oct 05)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   
    #   
    #***
    global log job

    foreach {key value} $args {
        switch -- $key {
            -max    {set exp max($value); set col $value}
            -min    {set exp min($value); set col $value}
            -all    {set exp distinct($value); set col $value}
            default {${log}::debug [info level 0] Invalid parameter: $key, please use one of: -max, -min, -all}
        }
    }

    $job(db,Name) eval "SELECT $exp FROM ShippingOrders
                            WHERE JobInformationID = $job(Number)
                            AND $col != ''
                            AND Hidden = 0"
    
} ;# job::db::getShipDate

proc job::db::SetNotes {args} {
    #****f* SetNotes/job::db
    # CREATION DATE
    #   11/04/2015 (Wednesday Nov 04)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # USAGE
    #   job::db::SetNotes histNote NoteType Note
    #
    # FUNCTION
    #	Inserts into the Notes table
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # EXAMPLE
    #   job::db::SetNotes -HistNote val, -NoteType val, -Note val
    #
    # NOTES
    #   Inserts passed Note into the Note Table, after making an entry in the History Table
    #   Returns the Notes_ID
    #  
    # SEE ALSO
    #   
    #   
    #***
    global log job
    
    foreach {key value} $args {
        switch -- $key {
            -HistNote   {set histNote $value}
            -NoteType   {set noteType $value}
            -Note       {set note $value}
            default     {${log}::debug [info level 0] Invalid parameter $key, must be: -HistNote, -NoteType, -Note}
        }
    }
    
    foreach {var value} {histNote -HistNote noteType -NoteType note -Note} {
        if {![info exists $var]} {${log}::debug [info level 0] Parameter Required: $value}
    }

    set histID [job::db::insertHistory $histNote]
    
    # Get NoteTypeID
    set noteTypeID [$job(db,Name) eval "SELECT NoteType_ID FROM NoteTypes WHERE NoteType = '$noteType'"]

    $job(db,Name) eval "INSERT INTO Notes (HistoryID, NoteTypeID, NotesText) VALUES ('$histID', $noteTypeID,'$note')"
    
    return [$job(db,Name) eval "SELECT MAX(Notes_ID) FROM Notes"]
    
} ;# job::db::SetNotes
