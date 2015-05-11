# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 10 21,2014
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
# Database procs for the setup_headers functionality

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

proc ea::db::initHeaderVariables {} {
    #****f* initHeaderVariables/ea::db
    # CREATION DATE
    #   05/04/2015 (Monday May 04)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::db::initHeaderVariables  
    #
    # FUNCTION
    #	Initilizes the variables dealing with the Header configuration section
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
    global log setup

    set setup(hdr,valuesList) [db eval "SELECT Description from UserDefinedValues"]

    
} ;# ea::db::initHeaderVariables

proc ea::db::updateHeaderWidTbl {widTable} {
    #****f* updateHeaderWidTbl/ea::db
    # CREATION DATE
    #   10/22/2014 (Wednesday Oct 22)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::db::updateHeaderWidTbl widTable dbTable cols 
    #
    # FUNCTION
    #	Updates the tablelist widget with the header data from the database
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

    if {[info exists colName]} {unset colName}
    
    set ColumnCount [$widTable columncount]
    for {set x 1} {$x < $ColumnCount} {incr x} {
            lappend colName [$widTable columncget $x -name]
            #lappend colValues '$[widTable columncget $x -name]'
    }
    
    set region [eAssist_db::dbSelectQuery -columnNames $colName -table HeadersConfig]
    #set region [eAssist_db::dbSelectQuery -columnNames Package -table HeadersConfig]
    #set region [db eval "SELECT [join $colName ,] from HeadersConfig"]

    if {$region != 0} {
        $widTable delete 0 end
        
        #db eval "SELECT [join $colName ,] from HeadersConfig" {
        #    $widTable insert end "{} [join $colValues ,]
        #}
        foreach value $region {
            # the quoting works for the tablelist widget; unknown for listboxes
            $widTable insert end "{} $value"
            ${log}::debug insert end "{} $value"  
        }
    }
    
} ;# ea::db::updateHeaderWidTbl


proc ea::db::writeHeaderToDB {widTable widSubHeaders} {
    #****f* writeHeaderToDB/ea::db
    # CREATION DATE
    #   10/21/2014 (Tuesday Oct 21)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::db::writeHeaderToDB widPath widTable dbTable 
    #
    # FUNCTION
    #	Write/Update header configuration to the DB
    #	widTable = Path to the widget
    #   -save ok|new / Ok closes the widget; New clears the widget values
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
    global log setupHeadersConfig
    set dbTable HeadersConfig

    ${log}::debug win: $widTable
    ${log}::debug Database Table: $dbTable
    # Setup the Index column
    set hdr_list HeaderConfig_ID
    set data_list [twapi::new_guid]
        
    foreach header [array names setupHeadersConfig] {
        set data $setupHeadersConfig($header)
        #${log}::debug Column: $header __ Data: $data      
        
        if {$data != ""} {
            lappend hdr_list $header
            lappend data_list $data
        }
    }
            
    ${log}::debug Inserting into $dbTable
    ${log}::debug HEADERS: $hdr_list
    ${log}::debug DATA: $data_list
    ${log}::debug SubHeaders: [$widSubHeaders get 0 end]
    
    # Get subheader list from db; and compare it to what exists in the listbox. If it doesn't exist in the listbox but does in the DB. Delete it from the DB.
    set dbSubHeaders [db eval "SELECT "]
    
    return
    
    eAssist_db::dbInsert -columnNames $hdr_list -table $dbTable -data $data_list
    
    ## Read from DB to populate the widgets
    ea::db::updateHeaderWidTbl $widTable

} ;# ea::db::writeHeaderToDB


proc ea::db::populateHeaderEditWindow {widTable widSubHeader dbTable pk} {
    #****f* populateHeaderEditWindow/ea::db
    # CREATION DATE
    #   10/22/2014 (Wednesday Oct 22)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::db::populateHeaderEditWindow args 
    #
    # FUNCTION
    #	Populates the widgets with the selected data from the table widget
    #	widTbl = Path to the tablelist widget
    #   dbTbl = Table in the database that we want to query
    #   pk = Primary Key value
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   eAssistSetup::Headers
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log setupHeadersConfig 

    #${log}::debug DATA: [db eval "SELECT * FROM HeadersConfig WHERE HeaderConfig_ID = '$pk'"]
    
    # Populate the array
    db eval "SELECT * FROM HeadersConfig WHERE HeaderConfig_ID = '$pk'" {
							set setupHeadersConfig(HeaderConfig_ID) "$HeaderConfig_ID"
							set setupHeadersConfig(dbColName) "$dbColName"
							set setupHeadersConfig(dbDataType) "$dbDataType"
                            set setupHeadersConfig(dbActive) "$dbActive"
							set setupHeadersConfig(widLabelName) "$widLabelName"
							set setupHeadersConfig(widLabelAlignment) "$widLabelAlignment"
							set setupHeadersConfig(widWidget) "$widWidget"
							set setupHeadersConfig(widValues) "$widValues"
							set setupHeadersConfig(widDataType) "$widDataType"
							set setupHeadersConfig(widFormat) "$widFormat"
							set setupHeadersConfig(widColAlignment) "$widColAlignment"
							set setupHeadersConfig(widStartColWidth) "$widStartColWidth"
							set setupHeadersConfig(widMaxWidth) "$widMaxWidth"
							set setupHeadersConfig(widResizeToLongestEntry) "$widResizeToLongestEntry"
							set setupHeadersConfig(widMaxStringLength) "$widMaxStringLength"
							set setupHeadersConfig(widHighlightColor) "$widHighlightColor"
							set setupHeadersConfig(widUIGroup) "$widUIGroup"
							set setupHeadersConfig(widUIPositionWeight) "$widUIPositionWeight"
							set setupHeadersConfig(widExportable) "$widExportable"
							set setupHeadersConfig(widRequired) "$widRequired"
							set setupHeadersConfig(widDisplayType) "$widDisplayType"
    }
    
    # Populate the sub-header listbox
    foreach item [ea::db::getSubHeaders -fillListBox $setupHeadersConfig(HeaderConfig_ID)] {
        $widSubHeader insert end $item
    }
    

    
} ;# ea::db::populateHeaderEditWindow


proc ea::db::getSubHeaders {args} {
    #****f* getSubHeaders/ea::db
    # CREATION DATE
    #   10/22/2014 (Wednesday Oct 22)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::db::getSubHeaders ?widListBox? -header <Header PK>
    #
    # FUNCTION
    #	Retrieves all subheaders in the database; or retrieves select headers associated with the parent header (key)
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
    

    foreach {key value} $args {
        switch -- $key {
            -all    {set returnValue [eAssist_db::dbSelectQuery -columnNames SubHeaderName -table SubHeaders]}
            -parent {
                ${log}::debug key: $key, value: $value
                set returnValue [join [db eval "SELECT HeadersConfig.HeaderConfigID, SubHeaderName from SubHeaders
                                                    INNER JOIN Headers on SubHeaders.HeaderConfigID = HeadersConfig.HeaderConfig_ID
                                                WHERE SubHeaderName = '$value'"]]
            }
            -fillListBox    {
                set returnValue [db eval "SELECT SubHeaderName FROM SubHeaders
                                            LEFT OUTER JOIN HeadersConfig
                                        WHERE HeaderConfig_ID = HeaderConfigID
                                        AND HeaderConfigID = '$value'"]
            }
        }
    }

    return $returnValue
#SELECT SubHeaderName FROM SubHeaders
#LEFT OUTER JOIN HeadersConfig
# WHERE HeaderConfig_ID = HeaderConfigID
#AND HeaderConfigID = '175454CA-5944-47AA-AD99-A8753B67BAA7'
    
    #${log}::debug MasterHeader: $masterHeader / wid: $widListBox
    ## Clear the widget
    #$widListBox delete 0 end
    #
    ## Get the id of the header
    #set header_ID [eAssist_db::dbWhereQuery -columnNames Header_ID -table Headers -where InternalHeaderName='$masterHeader']
    #
    #set subHeaders [db eval "SELECT SubHeaderName FROM SubHeaders
    #                                LEFT OUTER JOIN Headers
    #                            WHERE Header_ID = HeaderID
    #                        AND HeaderID = '$header_ID'"]
    #
    #foreach subHeader [lsort $subHeaders] {
    #    $widListBox insert end $subHeader
    #}
    
} ;# ea::db::getSubHeaders


proc ea::db::addSubHeaders {widListbox widEntry widCombobox} {
    #****f* addSubHeaders/ea::db
    # CREATION DATE
    #   10/23/2014 (Thursday Oct 23)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::db::addSubHeaders args 
    #
    # FUNCTION
    #	Add sub headers to the master header
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

    #${log}::debug GET MasterHeader: [$widCombobox get]
    #${log}::debug GET ChildHeader: [$widEntry get]
    #${log}::debug INSERT INTO $widListbox
    
    set masterHeader [$widCombobox get]
    set childHeader [$widEntry get]
    
    set header_ID [eAssist_db::dbWhereQuery -columnNames Header_ID -table Headers -where InternalHeaderName='$masterHeader']
    
    #eAssist_db::dbInsert -columnNames "SubHeaderName HeaderID" -table SubHeaders -data "$childHeader $header_ID"
    
    # KNOWN BUG - If the user inserts a name that is not unique, we will end up with an ugly system error.
    db eval "INSERT into SubHeaders (SubHeaderName, HeaderID) VALUES ('$childHeader', $header_ID)"
    
    # Clear the entry widget
    $widEntry delete 0 end
    
    # Update the listbox widget
    ea::db::getSubHeaders $masterHeader $widListbox
    
} ;# ea::db::addSubHeaders


proc ea::db::delSubHeaders {widListbox widCombobox} {
    #****f* delSubHeaders/ea::db
    # CREATION DATE
    #   10/23/2014 (Thursday Oct 23)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::db::delSubHeaders widListbox widCombobox 
    #
    # FUNCTION
    #	Delete the selected subheaders
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

    #${log}::debug SELECTION [$widListbox get [$widListbox curselection]]
    #${log}::debug HEADER [$widCombobox get]
    set masterHeader [$widCombobox get]
    set childHeader [$widListbox get [$widListbox curselection]]
    
    eAssist_db::delete SubHeaders SubHeaderName $childHeader

    # Update the listbox widget
    ea::db::getSubHeaders $masterHeader $widListbox
    
} ;# ea::db::delSubHeaders


proc ea::db::delMasterHeader {widTable} {
    #****f* delMasterHeader/ea::db
    # CREATION DATE
    #   10/24/2014 (Friday Oct 24)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::db::delMasterHeader widTable 
    #
    # FUNCTION
    #	Deletes the selected headers; this will delete all child headers also
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

    
    set data [$widTable get [$widTable curselection]]
    #${log}::debug data: $data
    
    set curSelection [$widTable curselection]
    set headerID [lrange $data 1 1]
    
    # Delete from the widget
    $widTable delete $curSelection $curSelection
    
    # Delete from the DB
    eAssist_db::delete Headers Header_ID $headerID
    
} ;# ea::db::delMasterHeader
