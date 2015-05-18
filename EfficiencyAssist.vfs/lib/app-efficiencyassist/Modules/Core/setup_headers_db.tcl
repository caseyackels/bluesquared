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
    }
    
    set region [eAssist_db::dbSelectQuery -columnNames $colName -table HeadersConfig]

    if {$region != 0} {
        $widTable delete 0 end

        foreach value $region {
            # the quoting works for the tablelist widget; unknown for listboxes
            $widTable insert end "{} $value"
            ${log}::debug insert end "{} $value"  
        }
    }
    
} ;# ea::db::updateHeaderWidTbl


proc ea::db::writeHeaderToDB {action win widTable widSubHeaders} {
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
    #   ea::db::writeHeaderToDB action dbaction win widTable widSubHeaders
    #
    # FUNCTION
    #	Write/Update header configuration to the DB
    #	action = single or multiple (single will close the dialog after editing, multiple will insert the data into the db; then clear all variables keeping the window open for more entries)
    #   win = main dialog path
    #	widTable = Path to the widget
    #	widSubHeaders = Path to the listbox holding the sub headers
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
    set diff_add ""
    set diff_del ""

    ${log}::debug win: $widTable
    ${log}::debug Database Table: $dbTable
    # Setup the Index column
    set hdr_list HeaderConfig_ID

    if {$setupHeadersConfig(HeaderConfig_ID) == ""} {
        set setupHeadersConfig(HeaderConfig_ID) [ea::tools::getGUID]
        set data_list $setupHeadersConfig(HeaderConfig_ID)
    } else {
        set data_list $setupHeadersConfig(HeaderConfig_ID)
    }
    
        
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
    
    
    # Get subheader list from db; and compare it to what exists in the listbox. If it doesn't exist in the listbox but does in the DB. Delete it from the DB.
    set dbSubHeadersList [db eval "SELECT SubHeaderName FROM SubHeaders"]
    set widSubHeadersList [$widSubHeaders get 0 end]
    
    set diff_add [struct::set difference $widSubHeadersList $dbSubHeadersList]
    set diff_del [struct::set difference $dbSubHeadersList $widSubHeadersList]
    
    if {$diff_del != ""} {
        # Check to see if the DB contains more entries
        ${log}::notice Deleted SubHeader: $diff_del from $setupHeadersConfig(dbColName)
        foreach delValue $diff_del {
            db eval "DELETE FROM SubHeaders WHERE HeaderConfigID = '$setupHeadersConfig(HeaderConfig_ID)' AND SubHeaderName = '$delValue'"
        }
    }
    
    if {$diff_add != ""} {
        # Check to see if the listbox contains more entries than the db
        ${log}::notice Added SubHeader: $diff_add into $setupHeadersConfig(dbColName)
        foreach addValue $diff_add {
            db eval "INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('$addValue','$setupHeadersConfig(HeaderConfig_ID)')"
        }
    }
    
    ${log}::debug SubHeaders: [$widSubHeaders get 0 end]
    
    eAssist_db::dbInsert -columnNames $hdr_list -table $dbTable -data $data_list
    
    ## Read from DB to populate the tablelist widget
    ea::db::updateHeaderWidTbl $widTable
    
    switch -- $action {
        single      {destroy $win}
        multiple    {
                        eAssistSetup::initsetupHeadersConfigArray
                        # Clear out the sub header listbox
                        $widSubHeaders delete 0 end
                        # UX - Help the user by going back to the first entry widget
                        focus -force $::eAssistSetup::helperRootWin_f1.entry00
        }
    }

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
                #${log}::debug key: $key, value: $value
                set returnValue [join [db eval "SELECT SubHeaderName from SubHeaders
                                                    INNER JOIN HeadersConfig on SubHeaders.HeaderConfigID = HeadersConfig.HeaderConfig_ID
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