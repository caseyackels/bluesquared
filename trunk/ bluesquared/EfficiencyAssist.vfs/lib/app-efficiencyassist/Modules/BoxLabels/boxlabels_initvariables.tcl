# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 03 10,2014
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

proc Shipping_Gui::initDBTables {} {
    #****f* initDBTables/Shipping_Gui
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Initialize, and set variables for Module information
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
    #   eAssist_db::initValues
    #   
    #***
    global log
    
    # The array 'ModBoxLabels', must be part of the description as seen below. If not, this will break the auto-population in the email setup.
    #set desc(ModBoxLabels) [mc "Box Labels"]
    #set emailEvent(ModBoxLabels) [list Print "Print BreakDown"] 
    eAssist_db::checkModuleName "Box Labels"
    eAssist_db::checkEvents "Box Labels" \
                            -eventName onPrint "Substitutions\n %1-%5: Each line of the box labels\n %b: Breakdown information" \
                            onPrintBreakDown "None at this time"

    
} ;# Shipping_Gui::initDBTables

Shipping_Gui::initDBTables


proc Shipping_Gui::initVariables {} {
    #****f* initVariables/Shipping_Gui
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Initialize, and set defaults for variables within the Box Label/Shipping module
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
    global log mySettings
    ${log}::debug --START-- [info level 1]
    set throwError 0
    
    #set desc(ModBoxLabels) [mc "Box Labels"]
    #set emailEvent(ModBoxLabels) [list Print "Print BreakDown"] 
    
    set myVars [list bartender labelDir wordpad printer labelDBfile]
	foreach item $myVars {
        if {![info exists mySettings(path,$item)]} {
           #eAssist_Global::checkVars pref
           set throwError 1
           ${log}::critical Option not set: mySettings(name,labelDBfile)
        }
    }
    
    
    if {![info exists mySettings(name,labelDBfile)]} {
		#eAssist_Global::checkVars pref
        set throwError 1
        ${log}::critical Option not set: mySettings(name,labelDBfile)
	}
   
   
   # launch the error window if any variables need attention
    if {$throwError == 1} {
        eAssist_Global::checkVars pref
   }
    
    
	
    ${log}::debug --END-- [info level 1]
} ;# Shipping_Gui::initVariables
