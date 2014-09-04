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
# $LastChangedDate: 2011-10-17 16:11:20 -0700 (Mon, 17 Oct 2011) $
#
########################################################################################

##
## - Overview
# Overview

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

proc eAssistSetup::getEmailEvents {win} {
    #****f* getEmailEvents/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	eAssistSetup::getEmailEvents <win>
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
    global log emailEvent
    
    set currentMod [$win.cbx1 get]
    
    foreach var $currentMod {
	append currentMod1 $var
    }    
    
    $win.cbx2 configure -values $emailEvent(Mod$currentMod1)
    
} ;# getEmailEvents/eAssistSetup