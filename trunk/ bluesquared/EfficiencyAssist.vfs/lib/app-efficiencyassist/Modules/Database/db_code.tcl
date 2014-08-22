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
    
    #db eval {SELECT * from Headers} {
    #    ${log}::debug $myList
    #}
    
    eAssist_db::initContainers
    
	
    ${log}::debug --END-- [info level 1]
} ;# eAssist_db::loadDB


proc eAssist_db::initContainers {} {
    #****f* initContainers/eAssist_db
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Initialize variables for the Containers table
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
    global log packagingSetup
    ${log}::debug --START-- [info level 1]
    
    # Needed since we are migrating from a flat file
    #if {[info exists packagingSetup(Containers)]} {unset packagingSetup(Containers)}
    # Setup the variables holding the Containers and Packages
    db eval {SELECT Container from Containers} {
        #${log}::debug Container: $Container
        lappend packagingSetup(Containers) $Container
    }

    # Needed since we are migrating from a flat file
    #if {[info exists packagingSetup(Packages)]} {unset packagingSetup(Packages)}
    db eval {SELECT Package from Packages} {
        #${log}::debug Container: $Package
        lappend packagingSetup(Packages) $Package
    }
    
    ${log}::debug --END-- [info level 1]
} ;# eAssist_db::initContainers


proc eAssist_db::delete {table col args} {
    #****f* delete/eAssist_db
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	eAssist_db::delete <table> <col> <args>
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
    
    #set args [join $args]
    #db eval {DELETE from Containers WHERE Container='test pallet'}
    # Need to use quotes so we the variables have proper substitution
    db eval "DELETE from $table WHERE $col='$args'"
    ${log}::debug Deleting: DELETE from $table WHERE $col='$args'
    ${log}::debug --END-- [info level 1]
} ;# eAssist_db::delete
