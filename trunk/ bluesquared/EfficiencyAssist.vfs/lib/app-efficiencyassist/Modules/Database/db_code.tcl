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
    eAssist_db::getEmailSetup
    
	
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
    #	eAssist_db::loadDB
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global log packagingSetup
    ${log}::debug --START-- [info level 1]
    
    db eval {SELECT Container from Containers} {
        #${log}::debug Container: $Container
        lappend packagingSetup(Containers) $Container
    }

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


###----------
## Insert data in tables if needed
##

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
    global log emailSetup

    ${log}::debug Looking for $moduleName in the database ...
    if {[info exists ModNames]} {unset ModNames}
        
    db eval {SELECT ModuleName from Modules} {
        # Note this var ModuleName <-- upper case 'M'; and is a table in the DB
        lappend ModNames $ModuleName
    }

    if {[lsearch -nocase $ModNames $moduleName] == -1} {
            ${log}::debug Couldn't find $moduleName, inserting ...
                db eval {INSERT or ABORT INTO Modules (ModuleName EnableModNotification)
                    VALUES ($moduleName $emailSetup(mod,Notification))
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
    #   eAssist_db::initValues -module ?moduleName? -eventName ?event substitution? ?event substitution? ...
    #
    # FUNCTION
    #   moduleName = The module name that we want to associate our events with
    #   args = Events and Substitutions key-value.
    #
    #	The DB should already be loaded before this is performed.
    #   Example Usage:
    #     eAssist_db::checkEvents "Box Labels" \
    #                        -eventName onPrint "Substitutions\n %1-%5: Each line of the box labels\n %b: Breakdown information" \
    #                        onPrintBreakDown "None at this time"
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
    global log desc emailSetup

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
    
       
    # Setup args to only contain the event and notification text, and remove '-eventName'
    set eventArgs [lrange $args 1 end]
    
    switch -- [lrange $args 0 0] {
        -eventName {
            foreach {tmpEmailEvent tmpSubstitution} $eventArgs {
                ${log}::debug Looking for $tmpEmailEvent in the database ...
                
                if {[lsearch -nocase $tmpEvents $tmpEmailEvent] == -1} {
                    ${log}::debug Couldn't find $tmpEmailEvent, inserting ...
                    
                    db eval {INSERT or ABORT INTO EventNotifications (ModID, EventName, EventSubstitutions EnableEventNotification)
                        VALUES ($modID, $tmpEmailEvent, $tmpSubstitution, $emailSetup(Event,Notification))
                    }
                
                } else {
                    # An event already exists, now we check for the substitutions.
                    ${log}::debug Found $tmpEmailEvent, checking for the Substitutions!
                    
                    set dbMod [db eval {SELECT ModID
                                                From EventNotifications
                                                    LEFT OUTER JOIN Modules 
                                                        ON EventNotifications.ModID = Modules.Mod_ID
                                                    WHERE EventName = $tmpEmailEvent}]
                    
                    set dbSubstitution [join [db eval {SELECT EventSubstitutions
                                                    FROM EventNotifications
                                                        WHERE ModID = $dbMod
                                                    AND
                                                        EventName = $tmpEmailEvent}]]
                    
                        # Nothing found in the column, lets insert what we have.
                        if {$dbSubstitution eq ""} {
                            ${log}::debug Nothing found in the column, lets insert.
                            ${log}::debug Mod: $moduleName $tmpSubstitution
                            
                            db eval {INSERT or ABORT INTO EventNotifications} (EventSubstitutions)
                               VALUES ($tmpSubstitution)
                        
                        # We found an existing substitution, but it doesn't match. Lets update what we were passed.
                        } elseif {![string match $tmpSubstitution $dbSubstitution]} {
                            ${log}::notice Data exists in the DB, but it doesn't match what was passed to this proc, lets update to:
                            ${log}::debug Mod: $moduleName, Event: $tmpEmailEvent
                            ${log}::notice Old: $dbSubstitution
                            ${log}::notice New: $tmpSubstitution
                            
                            db eval {UPDATE EventNotifications
                                                    SET EventSubstitutions = $tmpSubstitution
                                                        WHERE ModID = $dbMod
                                                    AND
                                                        EventName = $tmpEmailEvent}
                            
                        }
                }                
            }
        }
        default {
                return -code 1 [mc "wrong # args: should be eAssist_db::checkEvents <moduleName> ?args?"]
        }
    }

    #${log}::debug Events passed to: [info level 1]
    #${log}::debug All Event Notifications: [db eval {SELECT EventName,  FROM EventNotifications}]
    
} ;# eAssist_db::checkEvents





###-----------------
### QUERIES
##
##

proc eAssist_db::getEmailSetup {} {
    #****f* getEmailSetup/eAssist_db
    # CREATION DATE
    #   09/15/2014 (Monday Sep 15)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssist_db::getEmailSetup  
    #
    # FUNCTION
    #	Retrieves the email setup data and initilizes the emailSetup array
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   eAssist_db::loadDB
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log emailSetup
    
    db eval {SELECT EmailServer, EmailPort, EmailLogin, EmailPassword, TLS, GlobalEmailNotification FROM EmailSetup} {
        set emailSetup(email,serverName) $EmailServer
        set emailSetup(email,port) $EmailPort
        set emailSetup(email,userName) $EmailLogin
        set emailSetup(email,password) $EmailPassword
        
        set emailSetup(TLS) $TLS
        set emailSetup(globalNotifications) $GlobalEmailNotification
    }
    
} ;# eAssist_db::getEmailSetup


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
    #	Retrieves all module names that are loaded in the DB
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
    #	Retrieve the Email Events associated with moduleName to populate the dropdown widget
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

proc eAssist_db::dbWhereQuery {args} {
    #****f* dbWhereQuery/eAssist_db
    # CREATION DATE
    #   09/24/2014 (Wednesday Sep 24)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   dbCSR::dbWhereQuery -columnNames ?value(s)? -table <tableName> -where <where clause>
    #   Example: dbCSR::dbWhereQuery -columnNames {FirstName LastName} -table CSRS -where Status=1
    #   
    #
    # FUNCTION
    #	Issues a query to specified table, with a WHERE clause
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
            -columnNames {set colNames $value; puts "ColumnNames: $colNames"}
            -table {set tbl $value; if {[llength $value] != 1} {return -code 1 [mc "wrong # args: Should be -table value]}}
            -where {set where $value; if {[llength $value] != 1} {return -code 1 [mc "wrong # args: Should be -where value]}}
            default {return -code 1 [mc "Unknown $key $value"]}
        }
    }
    
    foreach val {colNames tbl where} {
        puts "val1: $val"
        puts "val2: [subst $$val]"
        if {![info exists $val]} {
            return -code 1 [mc "wrong # args: Should be -columnNames value ... valueN -table value -where value ... valueN\nCommand Issued: [info level 0] "]
        }
    }
    
    if {[info exists returnQuery]} {unset returnQuery}
    if {[info exists myNewCommand]} {unset myNewCommand}
            
    if {[llength $colNames] == 1} {
        set returnQuery [db eval "SELECT $colNames FROM $tbl WHERE $where"]
    } else {
        foreach val $colNames {
            set pos [lsearch $colNames $val]; puts "Pos: $pos"
            set myCommand {[subst $[lrange $colNames %b %b]]}
            lappend myNewCommand [string map "%b $pos" $myCommand]
        }
            db eval "SELECT [join $colNames ,] FROM $tbl WHERE $where" {
                lappend returnQuery "[join [subst $myNewCommand]]"
            }
    }
    return $returnQuery

} ;# eAssist_db::dbWhereQuery

