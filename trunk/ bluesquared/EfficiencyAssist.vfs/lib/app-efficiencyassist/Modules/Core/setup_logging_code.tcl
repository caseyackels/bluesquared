# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 09 10,2013
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 338 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate$
#
########################################################################################

##
## - Overview
# Holds the code for the Logging

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


proc eAssistSetup::changeLogLevel {args} { 
    #****f* changeLogLevel/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2013 Casey Ackels
    #
    # FUNCTION
    #	Change the logging level on the fly
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	eAssistSetup::setup_GUI
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global log logSettings
        
        logger::setlevel [string tolower [lindex $logSettings(levels) $args]]
        ${log}::notice [mc "Logging level has been set to: ${log}::currentloglevel"]
    

} ;#eAssistSetup::changeLogLevel


proc eAssistSetup::toggleConsole {args} {
    #****f* toggleConsole/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Toggle the console on the fly, instead of hard coding it in.
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
    
    if {$args == 1} {
        catch {console show}
    } else {
        catch {console hide}
    }
	
} ;# eAssistSetup::toggleConsole
