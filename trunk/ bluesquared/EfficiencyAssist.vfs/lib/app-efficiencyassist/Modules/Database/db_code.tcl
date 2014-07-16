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
    
    sqlite3 db $myDB
    
    ${log}::debug [db eval {SELECT * from Headers}]
	
    ${log}::debug --END-- [info level 1]
} ;# eAssist_db::loadDB