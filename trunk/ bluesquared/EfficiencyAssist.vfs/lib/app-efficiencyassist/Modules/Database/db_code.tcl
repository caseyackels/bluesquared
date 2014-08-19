# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 07 16,2014
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
# Holds all DB related Procs

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample
package provide eAssist_db 1.0

namespace eval eAssist_db {}


proc eAssist_db::loadDB {} {
    #****f* openDB/eAssist_db
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Loads the DB
    #
    # SYNOPSIS
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
    # SEE ALSO
    #
    #***
    global log program
    ${log}::debug --START-- [info level 1]
    
    set myDB [file join $program(Home) EA_setup.edb]
    #set myList "$Header_ID $HeaderName $HeaderParams"
    
    sqlite3 db $myDB
    
    db eval {SELECT * from Headers} {
        ${log}::debug $myList
    }
    
	
    ${log}::debug --END-- [info level 1]
} ;# eAssist_db::loadDB


proc eAssist_db::tblHeader {} {
    #****f* tblHeader/eAssist_db
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	List of columns in Header Table
    #
    # SYNOPSIS
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
    # SEE ALSO
    #
    #***
    global log
    ${log}::debug --START-- [info level 1]
    
    array set db.tblHeader {
        Header_ID ""
        HeaderName ""
        HeaderMaxLength ""
        OutputHeaderName ""
        Widget ""
        Highlight ""
        AlwaysDisplay ""
        Required ""
        DefaultWidth ""
    }
    
    ${log}::debug --END-- [info level 1]
} ;# eAssist_db::tblHeader
