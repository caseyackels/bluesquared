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
    global log G_setupFrame emailSetup
    
    eAssist_Global::resetSetupFrames ;# Reset all frames so we start clean
	
    set frame0 [ttk::label $G_setupFrame.frame0 -padding 10]
    pack $frame0 -fill x ;#-fill both ;#-pady 5p -padx 5p
    
    
    ##
    ## Frame 1
    ##
    set f1 [ttk::labelframe $frame0.f1 -text [mc "Server Information"] -padding 10]
    #grid $f1 -column 0 -row 0 -sticky news -padx 5p
    pack $f1 -fill x -anchor n ;#-pady 5p
    
    ttk::label $f1.txt1 -text [mc "Name"]
    ttk::entry $f1.entry1 -textvariable emailSetup(email,serverName) -width 40
    
    ttk::label $f1.txt2 -text [mc "Port"]
    ttk::entry $f1.entry2 -textvariable emailSetup(email,port)
    
    ttk::label $f1.txt3 -text [mc "User Name"]
    ttk::entry $f1.entry3 -textvariable emailSetup(email,userName)
    
    ttk::label $f1.txt4 -text [mc "Password"]
    ttk::entry $f1.entry4 -show * -textvariable emailSetup(email,password)
    
    
    grid $f1.txt1 -column 0 -row 0 -padx 2p -pady 2p -sticky nse
    grid $f1.entry1 -column 1 -row 0 -padx 2p -pady 2p -sticky news
    grid $f1.txt2 -column 0 -row 1 -padx 2p -pady 2p -sticky nse
    grid $f1.entry2 -column 1 -row 1 -padx 2p -pady 2p -sticky news
    grid $f1.txt3 -column 0 -row 2 -padx 2p -pady 2p -sticky nse
    grid $f1.entry3 -column 1 -row 2 -padx 2p -pady 2p -sticky news
    grid $f1.txt4 -column 0 -row 3 -padx 2p -pady 2p -sticky nse
    grid $f1.entry4 -column 1 -row 3 -padx 2p -pady 2p -sticky news
    
    ##
    ## Notebook
    ##
    set f2(nbk) [ttk::notebook $G_setupFrame.nbk]
    pack $f2(nbk) -expand yes -fill both -anchor s -pady 3p

    ttk::notebook::enableTraversal $f2(nbk)
    
    # Setup the notebook tabs
    $f2(nbk) add [ttk::frame $f2(nbk).f1] -text [mc "Box Labels"]
    $f2(nbk) add [ttk::frame $f2(nbk).f2] -text [mc "Batch Maker"]

    $f2(nbk) select $f2(nbk).f1
    
    ##
    ## Notebook Tab 1 (Box Labels)
    ##
    
    set nbkF1 [ttk::labelframe $f2(nbk).f1.top -text [mc "Configure Email"]]
    pack $nbkF1 -side top -fill both -padx 5p -pady 5p
    
    ttk::checkbutton $nbkF1.ckbtn1 -variable emailSetup(boxlabels,Notification)
    ttk::label $nbkF1.txt1 -text [mc "Enable Notifications?"]
    
    ttk::label $nbkF1.txt2 -text [mc "From"]
    ttk::entry $nbkF1.entry2 -width 40 -textvariable emailSetup(boxlabels,From)
        tooltip::tooltip $nbkF1.entry2 [mc "One valid email address only"]
    
    ttk::label $nbkF1.txt3 -text [mc "To"]
    ttk::entry $nbkF1.entry3 -textvariable emailSetup(boxlabels,To)
        tooltip::tooltip $nbkF1.entry3 [mc "One valid email address only"]
    
    ttk::label $nbkF1.txt4 -text [mc "Subject"]
    ttk::entry $nbkF1.entry4 -textvariable emailSetup(boxlabels,Subject)
        tooltip::tooltip $nbkF1.entry4 [mc "This will prefix what was typed into the first line of the label"]
    
    
    grid $nbkF1.ckbtn1 -column 0 -row 0 -pady 2p -sticky nse
    grid $nbkF1.txt1 -column 1 -row 0 -pady 2p -sticky nsw
    
    grid $nbkF1.txt2 -column 0 -row 1 -pady 2p -padx 2p -sticky nse
    grid $nbkF1.entry2 -column 1 -row 1 -pady 2p -padx 2p -sticky news
    grid $nbkF1.txt3 -column 0 -row 2 -pady 2p -padx 2p -sticky nse
    grid $nbkF1.entry3 -column 1 -row 2 -pady 2p -padx 2p -sticky news
    grid $nbkF1.txt4 -column 0 -row 3 -pady 2p -padx 2p -sticky nse
    grid $nbkF1.entry4 -column 1 -row 3 -pady 2p -padx 2p -sticky news   
    
    
    
} ;# emailSetup_GUI