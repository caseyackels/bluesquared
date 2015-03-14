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

proc ea::db::updateHeaderWidTbl {widTable dbTable cols} {
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

    set region [eAssist_db::dbSelectQuery -columnNames $cols -table $dbTable]
    if {[info exists region]} {
        $widTable delete 0 end
        
        foreach value $region {
            # the quoting works for the tablelist widget; unknown for listboxes
            $widTable insert end "{} $value"
            ${log}::debug insert end "{} $value"
            
        }
    }
    
} ;# ea::db::updateHeaderWidTbl


proc ea::db::writeHeaderToDB {widPath widTable dbTable} {
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
    #	widPath = Path to the widgets
    #	dbTable = Table in the database that we are going to write to.
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
    global log tmp_headerOpts

    ${log}::debug win: $widPath
    
    set children [lsort [winfo children $widPath]]
    if {[winfo exists valuesToInsert]} {unset valuesToInsert}
    
    # Retrieves data from each entry widget, and puts them into a list.
    # Clear out all entry widgets
    foreach item $children {
        if {[string match -nocase *txt* $item] != 1} {
            if {[string match -nocase *ckbtn* $item] == 1} {
                foreach checkbtn [array names tmp_headerOpts] {
                    if {[string match *$checkbtn $item]} {
                        lappend valuesToInsert $tmp_headerOpts($checkbtn)
                    }
                }
                
            } else {
                ${log}::debug $item - [join [$item get]]
                lappend valuesToInsert [join [$item get]]
            }
            #$item delete 0 end
        }
    }


    ${log}::debug Final valuesToInsert: $valuesToInsert
    eAssist_db::dbInsert -columnNames "InternalHeaderName OutputHeaderName HeaderMaxLength DefaultWidth Highlight Widget DisplayOrder Required AlwaysDisplay ResizeColumn" -table $dbTable -data $valuesToInsert
    

    # Read from DB to populate the widgets
    ea::db::updateHeaderWidTbl $widTable Headers "Header_ID InternalHeaderName OutputHeaderName HeaderMaxLength DefaultWidth Highlight Widget DisplayOrder Required AlwaysDisplay ResizeColumn"
    
} ;# ea::db::writeHeaderToDB


proc ea::db::populateHeaderEditWindow {widTable widPath dbTable} {
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
    global log tmp tmp_headerOpts

    #${log}::debug tbl: $widTbl
    
    set data [$widTable get [$widTable curselection]]
    set dataEdited [lrange $data 2 end] ;# We don't want the count or index column
    set tmp(db,ID) [lrange $data 1 1]
    
    #${log}::debug db_ID: $tmp(db,ID)
    #${log}::debug data: $data
    #${log}::debug data: $dataEdited
    
    set tmp(db,rowID) [eAssist_db::dbWhereQuery -columnNames rowid -table $dbTable -where Header_ID='$tmp(db,ID)']
    
    ${log}::debug DB DATA: [eAssist_db::dbWhereQuery -columnNames "InternalHeaderName Widget" -table $dbTable -where Header_ID='$tmp(db,ID)']
    
    set children [lsort [winfo children $widPath]]
    foreach child $children {
        if {[string match -nocase *txt* $child] != 1} {
            lappend childlist $child
        }
    }
    ${log}::debug Avail Widgets: $childlist
    
    set checkbtnArray [lsort [array names tmp_headerOpts]]

    set x 0
    foreach item $childlist {
        ${log}::debug Current Data: [lrange $dataEdited $x $x]
        
        if {[string match -nocase *ckbtn* $item] == 1} {
            foreach checkbtn $checkbtnArray {
                if {[string match *$checkbtn $item]} {
                        #${log}::debug $item / $tmp_headerOpts($checkbtn) - [lrange $dataEdited $x $x]
                        set tmp_headerOpts($checkbtn) [lrange $dataEdited $x $x]
                }
            }
            
        } elseif {[string match -nocase *cbox* $item] == 1} {
                if {[join [lrange $dataEdited $x $x]] != ""} {
                    #${log}::debug ISSUE_CBOX: [lrange $dataEdited $x $x]
                    $item set [lrange $dataEdited $x $x]
                }
            } else {
                    if {[join [lrange $dataEdited $x $x]] != ""} {
                        #${log}::debug ISSUE: [lrange $dataEdited $x $x]
                        #${log}::debug ISSUE: [string compare -nocase [lrange $dataEdited $x $x] {}] - DATA: [lrange $dataEdited $x $x]
                        $item insert end [lrange $dataEdited $x $x]
                    }
                }
        incr x
    }
    
} ;# ea::db::populateHeaderEditWindow

proc ea::db::getInternalHeader {wid} {
    #****f* getInternalHeader/ea::db
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
    #   ea::db::populateMasterHeaderList wid
    #
    # FUNCTION
    #	Retreives the list of Internal Headers
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

        
    $wid configure -values [eAssist_db::dbSelectQuery -columnNames InternalHeaderName -table Headers]
    
} ;# ea::db::getInternalHeader

proc ea::db::getSubHeaders {masterHeader widListBox args} {
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
    #   ea::db::getSubHeaders args 
    #
    # FUNCTION
    #	Retrieves the subheader for the selected internal master header
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

    
    ${log}::debug MasterHeader: $masterHeader / wid: $widListBox
    # Clear the widget
    $widListBox delete 0 end
    
    # Get the id of the header
    set header_ID [eAssist_db::dbWhereQuery -columnNames Header_ID -table Headers -where InternalHeaderName='$masterHeader']
    
    set subHeaders [db eval "SELECT SubHeaderName FROM SubHeaders
                                    LEFT OUTER JOIN Headers
                                WHERE Header_ID = HeaderID
                            AND HeaderID = '$header_ID'"]
    
    foreach subHeader [lsort $subHeaders] {
        $widListBox insert end $subHeader
    }
    
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
