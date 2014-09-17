# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 07 31,2014
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
# Overview

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

proc eAssistSetup::getModules {win} {
    #****f* getModules/eAssistSetup
    # CREATION DATE
    #   09/12/2014 (Friday Sep 12)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::getModules win
    #
    # FUNCTION
    #	A wrapper function around getModules, since we need to pass 
	#	cbx1 - Combobox 1 (Modules)
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
	
    $win configure -values [eAssist_db::getDBModules]
    
} ;# eAssistSetup::getModules


proc eAssistSetup::getEmailEvents {win} {
    #****f* getEmailEvents/eAssistSetup
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
    #   eAssistSetup::getEmailEvents win 
    #
    # FUNCTION
    #	Checks what module is selected, and loads the corresponding email events
    #	win = widget path to the combobox holding the selected Module
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
	
	${log}::debug Populating combobox with email events - [$win.cbx1 get]
	
	set eventValues [eAssist_db::getJoinedEvents [$win.cbx1 get]]
	${log}::debug eventValues: $eventValues
	
    $win.cbx2 configure -values $eventValues

} ;# eAssistSetup::getEmailEvents


proc eAssistSetup::setEmailVars {moduleName eventName txt} {
    #****f* setEmailVars/eAssistSetup
    # CREATION DATE
    #   09/12/2014 (Friday Sep 12)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::setEmailVars moduleName eventName 
    #
    # FUNCTION
    #	Queries the DB to see if we already have data setup; if we do, set the global emailSetup variables
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
    global log email
	set moduleName [$moduleName get]
	set eventName [$eventName get]
	
	# Make sure the text widget is cleared out.
	$txt delete 1.0 end
	
	${log}::debug Mod: $moduleName Event: $eventName
	
	set emailEntry [db eval	{SELECT *
						FROM EmailNotifications
							WHERE ModuleName = $moduleName
						AND
							EventName = $eventName
	}]
	
	${log}::debug emailEntry: $emailEntry
	
	if {$emailEntry eq ""} {
		${log}::notice An Email notification has not been set for Mod: $moduleName and Event: $eventName
		unset email
		
	} else {
		${log}::notice An Email notificaton has been set up for Mod: $moduleName and Event: $eventName
		
		set email(From) [eAssistSetup::queryDBemailVars EmailFrom $moduleName $eventName]
		set email(To) [eAssistSetup::queryDBemailVars EmailTo $moduleName $eventName]
		set email(Subject) [eAssistSetup::queryDBemailVars EmailSubject $moduleName $eventName]
		#set email(Body) [eAssistSetup::queryDBemailVars EmailBody $moduleName $eventName]
		$txt insert end [eAssistSetup::queryDBemailVars EmailBody $moduleName $eventName]
	}

    
} ;# eAssistSetup::setEmailVars


proc eAssistSetup::queryDBemailVars {column moduleName eventName} {
    #****f* queryDBemailVars/eAssistSetup
    # CREATION DATE
    #   09/12/2014 (Friday Sep 12)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::queryDBemailVars column 
    #
    # FUNCTION
    #	Queries the EmailNotification DB Table to retrieve specific settings based on Module and Event names
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

	if {[llength $column] >= 2} {
		${log}::critical -[info level 1]- $column contains 2 or more words, exiting!
		return
	}
	
	# If a column has a space in it, this will fail.
	join [db eval "SELECT $column
					FROM EmailNotifications
						WHERE ModuleName = moduleName
							AND
						EventName = eventName"]


} ;# eAssistSetup::queryDBemailVars


proc eAssistSetup::getModSetup {w} {
    #****f* getModSetup/eAssistSetup
    # CREATION DATE
    #   09/16/2014 (Tuesday Sep 16)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::getModSetup w 
    #
    # FUNCTION
    #	Retrieves the setup information for the selected module
	#
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

	${log}::debug getModSetup: $w [$w get]
	
	set modName [$w get]
	
	# We look at the master "Module setup" table, because this option is for ALL events associated with this module. Before sending out an email we will have to query
	# the Modules table to see what status it has (enabled/disabled)
	# The DB default is 1 (Enabled)
	set emailSetup(mod,Notification) [db eval {SELECT EnableModNotification FROM Modules WHERE ModuleName = $modName}]
    
} ;# eAssistSetup::getModSetup


proc eAssist_db::getEventSetup {w} {
    #****f* getEventSetup/eAssist_db
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
    #   eAssist_db::getSubText w Event
    #
    # FUNCTION
    #	Queries the EventNotifications table, and retrieves the setup information for that particular event. Macro/Subst text, and EnableEvents.
	#	w = Widget path to retrieve event name
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
    global log email emailSetup
	
	${log}::debug getEventSetup: $w [$w get]
	
	set eventName [$w get]
    set email(SubTxt) [join [db eval {SELECT EventSubstitutions FROM EventNotifications WHERE EventName = $eventName}]]
	
	set emailSetup(Event,Notification) [db eval {SELECT EventNotification FROM EmailNotifications WHERE EventName = $eventName}]
	
	# Set the default to 1(enabled), if we don't have existing data
	if {$emailSetup(Event,Notification) == ""} {
		${log}::debug An entry for this notice has not been setup yet, defaulting to EnableNotifications
		set emailSetup(Event,Notification) 1
	}


    
} ;# eAssist_db::getEventSetup

###
### **************** SAVE PROCS BELOW
###

proc eAssist_db::saveEmailTpl {mod event body} {
    #****f* saveEmailTpl/eAssist_db
    # CREATION DATE
    #   09/16/2014 (Tuesday Sep 16)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssist_db::saveEmailTpl  <mod> <event> <body>
    #
    # FUNCTION
    #	Saves the email template
	#	* What module; is it enabled?
	#	* What event; is it enabled?
	#	* From and To
	#	* Subject and Body
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
    global log emailSetup email
	
	#emailSetup(event,Notification)
	#email(From)
	#email(To)
	#email(Subject)
	#email(Body)
	set moduleName [$mod get]
	set eventName [$event get]
	set email(Body) [$body get 1.0 end]
	
	set dbTplExists [db eval {SELECT EN_ID, ModuleName, EventName
								FROM EmailNotifications
									WHERE ModuleName = $moduleName 
								AND
									EventName = $eventName}]
	
	if {$dbTplExists == ""} {
		#Nothing exists in the db, so lets insert
		${log}::debug dbTplExists = $dbTplExists - Inserting data ....
		db eval {INSERT or ABORT into EmailNotifications (ModuleName, EventName, EventNotification, EmailFrom, EmailTo, EmailSubject, EmailBody)
					VALUES ($moduleName $eventName $emailSetup(Event,Notification) $email(From) $email(To) $email(Subject) $email(Body)}
	} else {
		${log}::debug dbTplExists = $dbTplExists - Updating data ....
		set id [lrange $dbTplExists 0 0]
		db eval {UPDATE EmailNotifications
					SET ModuleName = $moduleName,
					EventName = $eventName,
					EventNotification = $emailSetup(Event,Notification),
					EmailFrom = $email(From),
					EmailTo = $email(To),
					EmailSubject = $email(Subject),
					EmailBody = $email(Body)
						WHERE EN_ID = $id
					}
		${log}::debug Inserting body: $email(Body)
	}
	
    
} ;# eAssist_db::saveEmailTpl
