# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 07 31,2014
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision$
# $LastChangedBy$
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
    global log G_setupFrame emailSetup system
    set currentModule ""
    
    eAssist_Global::resetSetupFrames ;# Reset all frames so we start clean
	
    set frame0 [ttk::label $G_setupFrame.frame0 -padding 10]
    pack $frame0 -expand yes -fill both ;#-fill both ;#-pady 5p -padx 5p
    
    ##
    ## Notebook
    ##
    
    set nbk [ttk::notebook $frame0.nbk]
    pack $nbk -expand yes -fill both -anchor s -pady 3p

    ttk::notebook::enableTraversal $nbk
    
    # Setup the notebook tabs
    $nbk add [ttk::frame $nbk.server] -text [mc "Server Information"]
    $nbk add [ttk::frame $nbk.events] -text [mc "Events"]

    $nbk select $nbk.server
    
    
    ##
    ## Frame 1
    ##
    set svrF1 [ttk::labelframe $nbk.server.f1 -text [mc "Server Information"] -padding 10]
    pack $svrF1 -fill both -anchor n -pady 5p -padx 5p
    
    ttk::label $svrF1.txt1 -text [mc "Name"]
    ttk::entry $svrF1.entry1 -textvariable emailSetup(email,serverName) -width 40
    
    ttk::label $svrF1.txt2 -text [mc "Port"]
    ttk::entry $svrF1.entry2 -textvariable emailSetup(email,port)
    
    ttk::label $svrF1.txt3 -text [mc "User Name"]
    ttk::entry $svrF1.entry3 -textvariable emailSetup(email,userName)
    
    ttk::label $svrF1.txt4 -text [mc "Password"]
    ttk::entry $svrF1.entry4 -show * -textvariable emailSetup(email,password)
    
    ttk::checkbutton $svrF1.cbtn1 -text [mc "TLS"] -variable emailSetup(TLS) -state disabled
    ttk::checkbutton $svrF1.cbtn2 -text [mc "Global Notifications"] -variable emailSetup(globalNotifications) -state disabled
    
    
    grid $svrF1.txt1 -column 0 -row 0 -padx 2p -pady 2p -sticky nse
    grid $svrF1.entry1 -column 1 -row 0 -padx 2p -pady 2p -sticky news
    grid $svrF1.txt2 -column 0 -row 1 -padx 2p -pady 2p -sticky nse
    grid $svrF1.entry2 -column 1 -row 1 -padx 2p -pady 2p -sticky news
    grid $svrF1.txt3 -column 0 -row 2 -padx 2p -pady 2p -sticky nse
    grid $svrF1.entry3 -column 1 -row 2 -padx 2p -pady 2p -sticky news
    grid $svrF1.txt4 -column 0 -row 3 -padx 2p -pady 2p -sticky nse
    grid $svrF1.entry4 -column 1 -row 3 -padx 2p -pady 2p -sticky news
    
    grid $svrF1.cbtn1 -column 1 -row 4 -padx 2p -pady 2p -sticky nsw
    grid $svrF1.cbtn2 -column 1 -row 5 -padx 2p -pady 2p -sticky nsw
    

    
    ##
    ## Notebook Tab 2 (Events)
    ##
    
    
    # Frame 1 - Select Module and Event trigger
    set eF1 [ttk::labelframe $nbk.events.f1 -text [mc "Module/Event Trigger"] -padding 10]
    pack $eF1 -side top -fill both -padx 5p -pady 5p
    
    #Module
    ttk::label $eF1.txt1 -text [mc "Module"]
	# The system modules should be listed in their respective *ModInitVariables proc within their '*initVars*' file.
    ttk::combobox $eF1.cbx1 -state readonly \
			    -postcommand [list eAssistSetup::getModules $eF1.cbx1]
    
    #Event
    ttk::label $eF1.txt2 -text [mc "Event"]
    ttk::combobox $eF1.cbx2 -state readonly \
                -postcommand [list eAssistSetup::getEmailEvents $eF1]
			    #-postcommand [list eAssistSetup::getEmailEvents $eF1]
    
    # Turn on/off the notifications
    ttk::checkbutton $eF1.ckbtn1 -variable emailSetup(mod,Notification)
    ttk::label $eF1.txt3 -text [mc "Module Notifications"]
    
    ttk::checkbutton $eF1.ckbtn2 -variable emailSetup(event,Notification)
    ttk::label $eF1.txt4 -text [mc "Event Notifications"]
    
    grid $eF1.txt1 -column 0 -row 0 -pady 2p -sticky nse 
    grid $eF1.cbx1 -column 1 -row 0 -pady 2p -padx 5p -sticky news 
    
    grid $eF1.ckbtn1 -column 2 -row 0 -pady 2p -sticky nse 
    grid $eF1.txt3 -column 3 -row 0 -pady 2p -sticky nsw
    
    grid $eF1.txt2 -column 0 -row 1 -pady 2p -sticky nse 
    grid $eF1.cbx2 -column 1 -row 1 -pady 2p -padx 5p -sticky news 
    
    grid $eF1.ckbtn2 -column 2 -row 1 -pady 2p -sticky nse
    grid $eF1.txt4 -column 3 -row 1 -pady 2p -sticky nsw
    

    ##
    ## Frame 2 - From/To, Subject and Body of the email
    ##
    
    set eF2 [ttk::labelframe $nbk.events.f2 -text [mc "Email"] -padding 10]
    pack $eF2 -fill both -padx 5p -pady 5p
    
    ttk::label $eF2.txt2 -text [mc "From"]
    ttk::entry $eF2.entry2 -width 40 -textvariable emailSetup(From)
        tooltip::tooltip $eF2.entry2 [mc "One valid email address only"]
    
    ttk::label $eF2.txt3 -text [mc "To"]
    ttk::entry $eF2.entry3 -textvariable emailSetup(To)
        tooltip::tooltip $eF2.entry3 [mc "One valid email address only"]
    
    ttk::label $eF2.subs -text [mc "Substitutions\n %1-%5: Each line of the box labels\n %b: Breakdown information"]
    
    ttk::label $eF2.txt4 -text [mc "Subject Prefix"]
    ttk::entry $eF2.entry4 -textvariable emailSetup(Subject)
        tooltip::tooltip $eF2.entry4 [mc "This will prefix what was typed into the first line of the label"]
	
    text $eF2.text -height 5 \
		    -wrap word \
		    -yscrollcommand [list $eF2.scrolly set] \
		    -xscrollcommand [list $eF2.scrollx set]
    
    ttk::scrollbar $eF2.scrolly -orient v -command [list $eF2.text yview]
    ttk::scrollbar $eF2.scrollx -orient v -command [list $eF2.text xview]

    
    grid $eF2.txt2 -column 0 -row 1 -pady 2p -padx 2p -sticky nse
    grid $eF2.entry2 -column 1 -row 1 -pady 2p -padx 2p -sticky news
    grid $eF2.txt3 -column 0 -row 2 -pady 2p -padx 2p -sticky nse
    grid $eF2.entry3 -column 1 -row 2 -pady 2p -padx 2p -sticky news
    
    grid $eF2.subs -column 1 -row 3 -pady 2p -padx 2p -sticky w
    
    grid $eF2.txt4 -column 0 -row 4 -pady 2p -padx 2p -sticky nse
    grid $eF2.entry4 -column 1 -row 4 -pady 2p -padx 2p -sticky news
    
    grid $eF2.text -column 1 -row 5 -pady 2p -padx 2p ;#-sticky news
    grid $eF2.scrolly -column 1 -row 5 -sticky nse
    grid $eF2.scrollx -column 0 -row 5 -sticky sew

    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $eF2.scrolly
    ::autoscroll::autoscroll $eF2.scrollx
    
    grid columnconfigure $eF2 $eF2.text -weight 1
    
    
    ##
    ## Bindings
    ##
    
    # Reset the current entry in the Events combobox, since we are changing what Events are available in the -postcommand
    bind $eF1.cbx1 <<ComboboxSelected>> "$eF1.cbx2 set {}"
    # Populate the textVars if we have the data
    bind $eF1.cbx2 <<ComboboxSelected>> "
        ${log}::debug Event Dropdown was selected: {*}$eF1.cbx1
        eAssistSetup::setEmailVars {*}$eF1.cbx1 {*}$eF1.cbx2"
    
} ;# emailSetup_GUI