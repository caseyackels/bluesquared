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
# $LastChangedDate: 2014-09-14 21:48:00 -0700 (Sun, 14 Sep 2014) $
#
########################################################################################

##
## - Overview
# Holds the GUI for the configuration of the International section

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


proc eAssistSetup::international_GUI {} {
    #****f* eAssistSetup/international_GUI
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2013 Casey Ackels
    #
    # FUNCTION
    #	Setup core program information
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	eAssistSetup::addToIntlListbox
    #   ea::db::reset_intlSetup
    #   eAssistSetup::removeFromIntlListbox
    #
    # PARENTS
    #	
    #
    # NOTES
    #
    # SEE ALSO
    # db_initvars.tcl (ea::db::reset_intlSetup): This initilizes the array with settings from the DB.
    # The array is populated at startup, and updated each time an item is added or removed. See: eAssistSetup::addToIntlListbox, 
    #
    #***
    global G_setupFrame log intlSetup
    
    eAssist_Global::resetSetupFrames ;# Reset all frames so we start clean
    
    #-------- Frame1
    set frame1 [ttk::labelframe $G_setupFrame.frame1 -text [mc "Unit of Measure"]]
    grid $frame1 -column 0 -row 0 -sticky news

    #ensure that the temp variable is cleared out
    set intlSetup(enterUOM) ""
    ttk::entry $frame1.entry1 -textvariable intlSetup(enterUOM)
    ttk::button $frame1.button1 -text [mc "Add"] -command {eAssistSetup::addToIntlListbox UOM .container.setup.frame1.listbox .container.setup.frame1.entry1}
    ttk::button $frame1.button2 -text [mc "Delete"] -command {eAssistSetup::removeFromIntlListbox UOMList .container.setup.frame1.listbox}
    
    listbox $frame1.listbox -selectmode single -height 3
    
    ${log}::debug UOMList info exists = [info exists intlSetup(UOMList)]
    
    if {[info exists intlSetup(UOMList)] == 1} {
        foreach item $intlSetup(UOMList) {
            $frame1.listbox insert end $item
        }
    }
    
    
    #----------- Grid
    grid $frame1.entry1 -column 0 -row 0 -padx 5p -pady 5p
    grid $frame1.listbox -column 0 -row 1 -rowspan 4 -padx 5p -pady 5p
    
    grid $frame1.button1 -column 1 -row 0 -sticky news -padx 5p -pady 5p
    grid $frame1.button2 -column 1 -row 1 -sticky ewn -padx 5p -pady 5p

    
    #---------- Bindings
    
    bind $frame1.listbox <Double-1> {
        ${log}::notice Removing item from Listbox from binding
        eAssistSetup::removeFromIntlListbox UOMList .container.setup.frame1.listbox
    }
    
    bind $frame1.entry1 <Return> {
        eAssistSetup::addToIntlListbox UOM .container.setup.frame1.listbox .container.setup.frame1.entry1
    }
    
    #
    #---------- Frame2
    #
    set frame2 [ttk::labelframe $G_setupFrame.frame2 -text [mc "Terms of Shipment"]]

    grid $frame2 -column 0 -row 1 -sticky news

    #ensure that the temp variable is cleared out
    set intlSetup(enterTerms) ""
    ttk::entry $frame2.entry1 -textvariable intlSetup(enterTerms)
    ttk::button $frame2.button1 -text [mc "Add"] -command {eAssistSetup::addToIntlListbox TERMS .container.setup.frame2.listbox .container.setup.frame2.entry1}
    ttk::button $frame2.button2 -text [mc "Delete"] -command {eAssistSetup::removeFromIntlListbox TERMSList .container.setup.frame2.listbox}
    
    listbox $frame2.listbox -selectmode single -height 3
    
    ${log}::debug  info exists = [info exists intlSetup(TERMSList)]
    
    if {[info exists intlSetup(TERMSList)] == 1} {
        foreach item $intlSetup(TERMSList) {
            $frame2.listbox insert end $item
        }
    }
    
    
    #----------- Grid
    grid $frame2.entry1 -column 0 -row 0 -padx 5p -pady 5p
    grid $frame2.listbox -column 0 -row 1 -rowspan 4 -padx 5p -pady 5p
    
    grid $frame2.button1 -column 1 -row 0 -sticky news -padx 5p -pady 5p
    grid $frame2.button2 -column 1 -row 1 -sticky ewn -padx 5p -pady 5p

    
    #---------- Bindings
    
    bind $frame2.listbox <Double-1> {
        ${log}::notice Removing item from Listbox from binding
        eAssistSetup::removeFromIntlListbox TERMSList .container.setup.frame2.listbox
    }
    
    bind $frame2.entry1 <Return> {
        eAssistSetup::addToIntlListbox TERMS .container.setup.frame2.listbox .container.setup.frame2.entry1
    }
    
    #
    #---------- Frame3
    #
    set frame3 [ttk::labelframe $G_setupFrame.frame3 -text [mc "Duties Payer"]]
    grid $frame3 -column 1 -row 0 -sticky news

    #ensure that the temp variable is cleared out
    set intlSetup(enterPayer) ""
    ttk::entry $frame3.entry1 -textvariable intlSetup(enterPayer)
    ttk::button $frame3.button1 -text [mc "Add"] -command {eAssistSetup::addToIntlListbox PAYER .container.setup.frame3.listbox .container.setup.frame3.entry1}
    ttk::button $frame3.button2 -text [mc "Delete"] -command {eAssistSetup::removeFromIntlListbox PAYERList .container.setup.frame3.listbox}
    
    listbox $frame3.listbox -selectmode single -height 3
    
    ${log}::debug  info exists = [info exists intlSetup(PAYERList)]
    
    if {[info exists intlSetup(PAYERList)] == 1} {
        foreach item $intlSetup(PAYERList) {
            $frame3.listbox insert end $item
        }
    }
    
    
    #----------- Grid
    grid $frame3.entry1 -column 0 -row 0 -padx 5p -pady 5p
    grid $frame3.listbox -column 0 -row 1 -rowspan 4 -padx 5p -pady 5p
    
    grid $frame3.button1 -column 1 -row 0 -sticky news -padx 5p -pady 5p
    grid $frame3.button2 -column 1 -row 1 -sticky ewn -padx 5p -pady 5p

    
    #---------- Bindings
    
    bind $frame3.listbox <Double-1> {
        ${log}::notice Removing item from Listbox from binding
        eAssistSetup::removeFromIntlListbox PAYERList .container.setup.frame3.listbox
    }
    
    bind $frame3.entry1 <Return> {
        eAssistSetup::addToIntlListbox PAYER .container.setup.frame3.listbox .container.setup.frame3.entry1
    }
    
    #
    #---------- Frame4
    #
    set frame4 [ttk::labelframe $G_setupFrame.frame4 -text [mc "License"]]
    grid $frame4 -column 1 -row 1 -sticky news

    #ensure that the temp variable is cleared out
    set intlSetup(enterLicense) ""
    ttk::entry $frame4.entry1 -textvariable intlSetup(enterLicense)
    ttk::button $frame4.button1 -text [mc "Add"] -command {eAssistSetup::addToIntlListbox LICENSE .container.setup.frame4.listbox .container.setup.frame4.entry1}
    ttk::button $frame4.button2 -text [mc "Delete"] -command {eAssistSetup::removeFromIntlListbox LICENSEList .container.setup.frame4.listbox}
    
    listbox $frame4.listbox -selectmode single -height 3
    
    ${log}::debug  info exists = [info exists intlSetup(LICENSEList)]
    
    if {[info exists intlSetup(LICENSEList)] == 1} {
        foreach item $intlSetup(LICENSEList) {
            $frame4.listbox insert end $item
        }
    }
    
    ${log}::debug ****Add ability to figure duties cost by box, rather than piece, and what cost to associate with it****
    
    
    #----------- Grid
    grid $frame4.entry1 -column 0 -row 0 -padx 5p -pady 5p
    grid $frame4.listbox -column 0 -row 1 -rowspan 4 -padx 5p -pady 5p
    
    grid $frame4.button1 -column 1 -row 0 -sticky news -padx 5p -pady 5p
    grid $frame4.button2 -column 1 -row 1 -sticky ewn -padx 5p -pady 5p

    
    #---------- Bindings
    
    bind $frame4.listbox <Double-1> {
        ${log}::notice Removing item from Listbox from binding
        eAssistSetup::removeFromIntlListbox LICENSEList .container.setup.frame4.listbox
    }
    
    bind $frame4.entry1 <Return> {
        eAssistSetup::addToIntlListbox LICENSE .container.setup.frame4.listbox .container.setup.frame4.entry1
    }
    
} ;# eAssistSetup::setup_GUI