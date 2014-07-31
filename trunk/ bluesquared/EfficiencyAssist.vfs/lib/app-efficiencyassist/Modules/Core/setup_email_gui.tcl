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
    set f1 [ttk::labelframe $frame0.f1 -text [mc "Server Information"] -padding 10]
    grid $f1 -column 0 -row 0 -sticky news -padx 5p
    
    ttk::label $f1.txt1 -text [mc "Name"]
    ttk::entry $f1.entry1
    
    ttk::label $f1.txt2 -text [mc "Port"]
    ttk::entry $f1.entry2
    
    ttk::label $f1.txt3 -text [mc "User Name"]
    ttk::entry $f1.entry3
    
    ttk::label $f1.txt4 -text [mc "Password"]
    ttk::entry $f1.entry4 -show *
    
    
    
    grid $f1.txt1 -column 0 -row 0 -padx 5p
    grid $f1.entry1 -column 1 -row 0 -padx 5p
    grid $f1.txt2 -column 0 -row 1 -padx 5p
    grid $f1.entry2 -column 1 -row 1 -padx 5p
    grid $f1.txt3 -column 0 -row 2 -padx 5p
    grid $f1.entry3 -column 1 -row 2 -padx 5p
    grid $f1.txt4 -column 0 -row 3 -padx 5p
    grid $f1.entry4 -column 1 -row 3 -padx 5p
    
    ##
    ## Frame 2
    ##
    set f2 [ttk::labelframe $frame0.f2 -text [mc "From/To"] -padding 10]
    grid $f2 -column 1 -row 0 -sticky news -padx 5p
    
    ttk::label $f2.txt1 -text [mc "From"]
    ttk::entry $f2.entry1
    
    ttk::label $f2.txt2 -text [mc "To"]
    ttk::entry $f2.entry2
    
    grid $f2.txt1 -column 0 -row 0 -padx 5p
    grid $f2.entry1 -column 1 -row 0 -padx 5p
    grid $f2.txt2 -column 0 -row 1 -padx 5p
    grid $f2.entry2 -column 1 -row 1 -padx 5p
    
    
    ##
    ## Frame 2
    ##
    set f3 [ttk::labelframe $frame0.f3 -text [mc "Composing"] -padding 10]
    grid $f3 -column 0 -row 2 -sticky news -padx 5p
    
    ttk::label $f3.txt1 -text [mc "Subject"]
    ttk::entry $f3.entry1
    
    ttk::label $f3.txt2 -text [mc "Header"]
    ttk::entry $f3.entry2
    
    ttk::label $f3.txt3 -text [mc "Footer"]
    ttk::entry $f3.entry3
    
    grid $f3.txt1 -column 0 -row 0 -padx 5p
    grid $f3.entry1 -column 1 -row 0 -padx 5p
    grid $f3.txt2 -column 0 -row 1 -padx 5p
    grid $f3.entry2 -column 1 -row 1 -padx 5p
    grid $f3.txt3 -column 0 -row 2 -padx 5p
    grid $f3.entry3 -column 1 -row 2 -padx 5p
    



} ;# emailSetup_GUI