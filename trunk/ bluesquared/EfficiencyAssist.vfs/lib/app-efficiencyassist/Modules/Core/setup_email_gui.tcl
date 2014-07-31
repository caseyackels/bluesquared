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


proc eAssistSetup::emailSetup_GUI {} {
    #****f* emailSetup_GUI/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Allow the user to setup email functionality
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
    global log G_setupFrame
    
    eAssist_Global::resetSetupFrames ;# Reset all frames so we start clean
	
    set frame0 [ttk::label $G_setupFrame.frame0]
    pack $frame0 -expand yes -fill both ;#-pady 5p -padx 5p
    
    
    ##
    ## Frame 1
    ##
    set f1 [ttk::labelframe $frame0.f1 -text [mc "Server"] -padding 10]
    grid $f1 -column 0 -row 0 -sticky news -padx 5p






} ;# emailSetup_GUI