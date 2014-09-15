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
# $LastChangedDate$
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
    #	'eAssist_bootStrap
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


proc eAssist_db::checkModuleName {moduleName} {
    #****f* checkModuleName/eAssist_db
    # CREATION DATE
    #   09/10/2014 (Wednesday Sep 10)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssist_db::checkModuleName moduleName 
    #
    # FUNCTION
    #	Check to see if the module name is inserted into the DB, if it doesn't insert it.
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

    ${log}::debug Looking for $moduleName in the database ...
    if {[info exists ModNames]} {unset ModNames}
        
    db eval {SELECT ModuleName from Modules} {
        # Note this var ModuleName <-- upper case 'M'; and is a table in the DB
        lappend ModNames $ModuleName
    }

    if {[lsearch -nocase $ModNames $moduleName] == -1} {
            ${log}::debug Couldn't find $moduleName, inserting ...
                db eval {INSERT or ABORT INTO Modules (ModuleName)
                    VALUES ($moduleName)
                }
    } else {
            ${log}::debug Found $moduleName!
    }
    ${log}::debug $moduleName Event Notifications: [db eval {SELECT ModuleName FROM Modules WHERE ModuleName = $moduleName}]
    #unset ModNames
} ;# eAssist_db::checkModuleName


proc eAssist_db::checkEvents {moduleName args} {
    #****f* checkEvents/eAssist_db
    # CREATION DATE
    #   09/10/2014 (Wednesday Sep 10)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssist_db::initValues moduleName args
    #
    # FUNCTION
    #   moduleName = The module name that we want to associate our events with
    #   args = Events that can be used to send email notices
    #
    #	Initializes DB values for the specific package (Box Labels)
    #	The DB should already be loaded before this is performed.
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
    global log desc emailEvent
  
    ## Check to see if the Event Notifications exists in the DB, if it doesn't lets insert.
    #
    set modID [db eval {SELECT Mod_ID FROM Modules WHERE ModuleName = $moduleName}]
    ${log}::debug Looking for Module: $moduleName / ID: $modID
    
    set tmpEvents [db eval { SELECT EventName
                                FROM EventNotifications
                                    LEFT OUTER JOIN Modules
                                            ON EventNotifications.ModID = Modules.Mod_ID
                                WHERE ModuleName = $moduleName
                    }]
    ${log}::debug Found events for $moduleName: $tmpEvents
    
    foreach tmpEmailEvent $args {
        ${log}::debug Looking for $tmpEmailEvent in the database ...
        
        if {[lsearch -nocase $tmpEvents $tmpEmailEvent] == -1} {
            ${log}::debug Couldn't find $tmpEmailEvent, inserting ...
            db eval {INSERT or ABORT INTO EventNotifications (ModID, EventName)
                VALUES ($modID, $tmpEmailEvent)
            }
        
        } else {
            ${log}::debug Found $tmpEmailEvent!
        }
    }
    ${log}::debug Events passed to: [info level 1]
    ${log}::debug All Event Notifications: [db eval {SELECT EventName FROM EventNotifications}]
    
} ;# eAssist_db::checkEvents


proc eAssist_db::getDBModules {} {
    #****f* getDBModules/eAssist_db
    # CREATION DATE
    #   09/11/2014 (Thursday Sep 11)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssist_db::getDBModules  
    #
    # FUNCTION
    #	Retrieves the modules that are loaded in the DB
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   eAssistSetup::getModules
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log

    db eval {SELECT ModuleName FROM Modules}
    
} ;# eAssist_db::getDBModules


proc eAssist_db::getJoinedEvents {moduleName} {
    #****f* getJoinedEvents/eAssist_db
    # CREATION DATE
    #   09/11/2014 (Thursday Sep 11)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssist_db::getJoinedEvents args 
    #
    # FUNCTION
    #	Retrieve the Email Events, associated with moduleName
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

    set eventValues [db eval { SELECT EventName
                        FROM EventNotifications
                            LEFT OUTER JOIN Modules
                                    ON EventNotifications.ModID = Modules.Mod_ID
                        WHERE ModuleName = $moduleName }]
    
    ${log}::debug Event Values: $eventValues
    
    return $eventValues

} ;# eAssist_db::getJoinedEvents
