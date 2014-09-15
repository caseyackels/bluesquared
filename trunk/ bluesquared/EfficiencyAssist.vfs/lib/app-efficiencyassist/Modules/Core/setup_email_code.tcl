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


proc eAssistSetup::setEmailVars {moduleName eventName} {
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
    global log emailSetup
	set moduleName [$moduleName get]
	set eventName [$eventName get]
	
	${log}::debug Mod: $moduleName Event: $eventName
	
	set emailEntry [db eval	{SELECT *
						FROM EmailNotifications
							WHERE ModuleName = moduleName
						AND
							EventName = eventName
	}]
	
	if {$emailEntry eq ""} {
		{$log}::notice An Email notification has not been set for Mod: $moduleName and Event: $eventName
		
	} else {
		${log}::notice An Email notificaton has been set up for Mod: $moduleName and Event: $eventName

		set emailSetup(From) [eAssistSetup::queryDBemailVars EmailFrom $moduleName $eventName]
		set emailSetup(To) [eAssistSetup::queryDBemailVars EmailTo $moduleName $eventName]
		set emailSetup(Subject) [eAssistSetup::queryDBemailVars EmailSubject $moduleName $eventName]
		set emailSetup(Body) [eAssistSetup::queryDBemailVars EmailBody $moduleName $eventName]
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
	db eval	"SELECT $column
				FROM EmailNotifications
					WHERE ModuleName = moduleName
						AND
					EventName = eventName"


} ;# eAssistSetup::queryDBemailVars
