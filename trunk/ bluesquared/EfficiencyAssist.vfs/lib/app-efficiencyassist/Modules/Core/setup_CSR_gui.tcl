# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 02 02,2014
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


proc eAssistSetup::customerService_GUI {} {
    #****f* customerService_GUI/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Add/Delete/Edit Customer Service Reps
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
    global log G_setupFrame setupCSR CSR
    ${log}::debug --START-- [info level 1]
    
    eAssist_Global::resetSetupFrames ;# Reset all frames so we start clean
	
    set frame0 [ttk::label $G_setupFrame.frame0]
    pack $frame0 -expand yes -fill both -pady 5p -padx 5p
    
    set f1 [ttk::labelframe $frame0.f1 -text [mc "Customer Service"]]
    grid $f1 -column 0 -row 0 -sticky news
    
    ttk::label $f1.txt1 -text [mc "CSR Name"]
    ttk::entry $f1.entry1 -textvariable setupCSR(entryName)
    ttk::button $f1.add -text [mc "Add"] -command "eAssistSetup::addCSR $f1.lbox $f1.entry1"
    listbox $f1.lbox
    ttk::button $f1.del -text [mc "Delete"] -command "eAssistSetup::deleteCSR $f1.lbox"
    
    grid $f1.txt1 -column 0 -row 0
    grid $f1.entry1 -column 1 -row 0
    grid $f1.add -column 2 -row 0
    grid $f1.lbox -column 1 -row 1
    grid $f1.del -column 2 -row 1 -sticky new
    
    if {[info exists CSR(Names)] == 1} {
        foreach item $CSR(Names) {
            $f1.lbox insert end $item
        }
    }
    
    ${log}::debug --END-- [info level 1]
} ;# eAssistSetup::customerService_GUI