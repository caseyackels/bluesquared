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
    
    set CSR(status) 0
    set CSR(inactive) 1
	
    set frame0 [ttk::label $G_setupFrame.frame0]
    pack $frame0 -expand yes -fill both -pady 5p -padx 5p
    
    set f1 [ttk::labelframe $frame0.f1 -text [mc "Customer Service"] -padding 10]
    grid $f1 -column 0 -row 0 -sticky news
    
    ttk::label $f1.txt1 -text [mc "ID"]
    ttk::combobox $f1.cbx1 -width 10 -postcommand "dbCSR::getCSRID $f1.cbx1 CSR_ID"
        tooltip::tooltip $f1.cbx1 [mc "6 Chars only"]
    

    ttk::label $f1.txt2 -text [mc "First Name"]
    ttk::entry $f1.entry1 -width 35
    
    ttk::label $f1.txt3 -text [mc "Last Name"]
    ttk::entry $f1.entry2 -width 35
    
    ttk::label $f1.txt4 -text [mc "Email"]
    ttk::entry $f1.entry3 -width 35
    
    ttk::checkbutton $f1.chkbtn2 -text [mc "Record Active"] -variable CSR(status)
    
    grid $f1.txt1 -column 0 -row 0 -pady 2p -padx 3p -sticky nes
    grid $f1.cbx1 -column 1 -row 0 -pady 2p -padx 3p -sticky nws
    #grid $f1.chkbtn1 -column 2 -row 0 -pady 2p -padx 3p -sticky nws
    
    grid $f1.txt2 -column 0 -row 1 -pady 2p -padx 3p -sticky nes
    grid $f1.entry1 -column 1 -row 1 -pady 2p -padx 3p -sticky news
   

    grid $f1.txt3 -column 0 -row 2 -pady 2p -padx 3p -sticky nes
    grid $f1.entry2 -column 1 -row 2 -pady 2p -padx 3p -sticky news
    
    grid $f1.txt4 -column 0 -row 3 -pady 2p -padx 3p -sticky nes
    grid $f1.entry3 -column 1 -row 3 -pady 2p -padx 3p -sticky news
    
    grid $f1.chkbtn2 -column 1 -row 4 -pady 2p -padx 3p -sticky nsw
    
    set f1a [ttk::frame $f1.f1a]
    grid $f1a -column 2 -row 0 -sticky nw
    
    ttk::checkbutton $f1a.chkbtn1 -text [mc "Hide inactive records"] -variable CSR(inactive)
    grid $f1a.chkbtn1 -column 0 -row 0
    
    set f2 [ttk::frame $frame0.f2]
    grid $f2 -column 0 -row 1 -pady 5p -sticky e
    
    ttk::button $f2.clr -text [mc "Clear"] -command "eAssistSetup::clearCSR $f1 $f2"
    ttk::button $f2.save -text [mc "Save"] -command "eAssistSetup::saveCSR $f1 $f2"
    
    # Initializing the widgets here, but not gridding. that will come within add/change procs
    ttk::button $f2.cncl -text [mc "Cancel"] -command "eAssistSetup::cancelCSR $f1 $f2"
    
    grid $f2.clr -column 0 -row 0 -padx 1p 
    grid $f2.save -column 1 -row 0 -padx 1p 
    #grid $f2.del -column 2 -row 0 -padx 1p
    
    ## Bindings
    
    bind $f1.cbx1 <<ComboboxSelected>> "dbCSR::populateCSR $f1.cbx1 -fname $f1.entry1 -lname $f1.entry2 -email $f1.entry3 -status $f1.chkbtn2"
    
    ${log}::debug --END-- [info level 1]
} ;# eAssistSetup::customerService_GUI