# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 01 19,2014
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
# Setup Carrier Methods

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


proc eAssistSetup::carrierMethod_GUI {} {
    #****f* carrierMethod_GUI/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Add/Remove and Configure Carrier Methods
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
    global G_setupFrame log
    
    eAssist_Global::resetSetupFrames ;# Reset all frames so we start clean
    
    #-------- Frame1
    set frame1 [ttk::labelframe $G_setupFrame.frame1 -text [mc "Unit of Measure"]]
    grid $frame1 -column 0 -row 0 -sticky news





} ;# eAssistSetup::carrierMethod_GUI