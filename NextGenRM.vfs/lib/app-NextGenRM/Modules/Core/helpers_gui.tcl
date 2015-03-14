# Creator: Casey Ackels
# Initial Date: January, 2012]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 226 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2012-01-02 21:39:36 -0800 (Mon, 02 Jan 2012) $
#
########################################################################################

##
## - Overview
# This file holds the dialogs which are 'helpers' to the main windows

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


proc nextgenrm_GUI::addListWindow {type parent} {
    #****f* addListWindow/nextgenrm_GUI
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2012 - Casey Ackels
    #
    # FUNCTION
    #	Add a new Purchased List or Profile
    #
    # SYNOPSIS
    #	-parentWindow (.pcl/.profile) -type [profile|pcl]
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
    global program clone myType myList
    # myType is just a temp variable; but apparently it doesn't work when we try to send it as an argument without making it a global variable.
    # myList is the same way
	
    # Make sure the window has been destroyed before creating.
    if {[winfo exists .addWindow]} {destroy .addWindow}
        
##
## Pre window calculations
##
    switch -- $type {
        profile {
            set windowName [mc "Add Profile"]
            set parentWindow $parent
            set generalText [mc "Profile Name"]
            set cloneText [mc "Clone"]
            set cloneTooltip [mc "Clone an existing profile"]
            set myPostCommand "nextgenrm_Code::showProfiles -comboProfileClone .addWindow.frame1.pclCombo"
            set myType profile
            #set myValues [glob -nocomplain -directory $program(Profiles) *]
        }
        pcl     {
            set windowName [mc "Add Purchased List"]
            set parentWindow $parent
            set generalText [mc "Purchased List"]
            set cloneText [mc "Clone"]
            set cloneTooltip [mc "Clone an existing purchased list"]
            set myPostCommand {puts "my PostCommand"};#"nextgenrm_Code::showProfiles -comboPCL .addWindow.frame1.pclCombo"
            set myType pcl
        }
        default {}
    }
    
    # Default is to create a file; if we select/deselect the checkbox to clone, this variable will be updated.
    set program(fileGateway) fileCreate
        
     
##
## Window Manager
##
    
    toplevel .addWindow
    wm title .addWindow $windowName
    wm transient .addWindow $parent
    focus -force .addWindow

    # x = horizontal
    # y = vertical
    # Put the window in the center of the parent window
    set locX [expr {[winfo width $parent ] / 4 + [winfo x $parent]}]
    set locY [expr {[winfo height $parent ] / 4 + [winfo y $parent]}]

    wm geometry .addWindow +$locX+$locY
    
    
##
## Frames
##
    
    set frame1 [ttk::frame .addWindow.frame1]
    pack $frame1 -fill both -expand yes -pady 5p
    
    ttk::label $frame1.name -text $generalText
    
    #set newName 0 ;# initialize variable
    set program(newName) ""
    ttk::entry $frame1.nameEntry -textvariable program(newName) \
                                -validate key \
                                -validatecommand {nextgenrm_Code::controlCheck %P .addWindow.frame1.duplicate .addWindow.frame1.pclCombo .addWindow.button.ok}
    focus $frame1.nameEntry

    set clone 0 ;# initialize variable
    ttk::checkbutton $frame1.duplicate -text $cloneText \
                                        -variable clone \
                                        -command {nextgenrm_Code::controlComboState .addWindow.frame1.nameEntry .addWindow.frame1.pclCombo .addWindow.button.ok .addWindow.frame1.duplicate $clone}
    $frame1.duplicate configure -state disabled
    tooltip::tooltip $frame1.duplicate $cloneTooltip
    

    # Start out in disabled mode; clear the textvariable
    set myList {}
    ttk::combobox $frame1.pclCombo -textvariable myList \
									-state disabled \
									-postcommand $myPostCommand
    
    grid $frame1.name       -column 0 -row 0 -sticky w -padx 5p -pady 5p
    grid $frame1.nameEntry  -column 1 -row 0 -sticky news -padx 5p -pady 5p
    grid $frame1.duplicate  -column 0 -row 1 -sticky w -pady 2p -padx 5p
    grid $frame1.pclCombo   -column 1 -row 1 -sticky news -pady 2p -padx 5p
    
    
# Separator Frame
    set sep_frame1 [ttk::frame .addWindow.sep_frame1]
    ttk::separator $sep_frame1.separator -orient horizontal

    grid $sep_frame1.separator - -ipadx 1i
    pack $sep_frame1
    
# Button frame
    set button_frame [ttk::frame .addWindow.button]
    pack $button_frame -side right
    #lappend program(profileList) $program(newName) ;# update main variable that holds the list of profiles.
    #"puts myType: $myType, newName: $program(newName), myList; $myList"
    ttk::button $button_frame.ok -text [mc "OK"] -state disabled \
                                                -command { nextgenrm_Code::create $program(fileGateway) $myType $program(newName) $myList; destroy .addWindow }
                                                #[lappend program(profileList) [subst -nocommand $program(newName)]]
                                                #destroy .addWindow
    ttk::button $button_frame.cancel -text [mc "Cancel"] -command {destroy .addWindow}
    
    
    grid $button_frame.ok -column 0 -row 0 -padx 2p -pady 5p
    grid $button_frame.cancel -column 1 -row 0 -padx 5p -pady 5p
    
} ;# End nextgenrm_GUI::addPCLWindow



proc nextgenrm_GUI::renameListWindow {type parent txtWidget} {
    #****f* renameListWindow/nextgenrm_GUI
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2012 - Casey Ackels
    #
    # FUNCTION
    #	Rename an existing profile or purchased list
    #
    # SYNOPSIS
    #	-parent (.pcl/.profile) -type [profile|pcl]
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
    global program
	
    # Make sure the window has been destroyed before creating.
    if {[winfo exists .renameWindow]} {destroy .renameWindow}
        
##
## Pre window calculations
##
    switch -- $type {
        profile {
            set windowTitle [mc "Rename Profile"]
            set parentWindow $parent
            set generalText [mc "New Name"]
            set txtVar [$txtWidget get]
            #set myPostCommand "nextgenrm_Code::showProfiles -comboProfile .addWindow.frame1.pclCombo"
        }
        pcl     {
            set windowTitle [mc "Rename Purchased List"]
            set parentWindow $parent
            set generalText [mc "New Name"]
            set txtVar [$txtWidget get]
            #set myPostCommand "nextgenrm_Code::showProfiles -comboPCL .addWindow.frame1.pclCombo"
        }
        default {}
    }
     
##
## Window Manager
##
    set w .renameWindow
    
    toplevel $w
    wm title $w $windowTitle
    wm transient $w $parent
    focus -force $w

    # x = horizontal
    # y = vertical
    # Put the window in the center of the parent window
    set locX [expr {[winfo width $parent ] / 4 + [winfo x $parent]}]
    set locY [expr {[winfo height $parent ] / 4 + [winfo y $parent]}]

    wm geometry $w +$locX+$locY
    
    set frame1 [ttk::frame $w.frame1]
    pack $frame1 -fill both -expand yes -pady 7p -padx 5p
    
    ttk::label $frame1.name -text $generalText
    ttk::entry $frame1.entry
    focus $frame1.entry
    # Insert txt into the entry widget (We want to rename it, so lets start with the original name)
    $frame1.entry insert end $txtVar
    
    grid $frame1.name -column 0 -row 0 -padx 4p -pady 3p
    grid $frame1.entry -column 1 -row 0 -padx 4p -pady 3p
    
# Separator Frame
    set sep_frame1 [ttk::frame $w.sep_frame1]
    ttk::separator $sep_frame1.separator -orient horizontal

    grid $sep_frame1.separator - -ipadx 1i
    pack $sep_frame1
    
# Button frame
    set button_frame [ttk::frame $w.button]
    pack $button_frame -side right
    
    ttk::button $button_frame.ok -text [mc "OK"] -command "nextgenrm_Code::saveAs $type $txtVar $frame1.entry $txtWidget; destroy $w"
    ttk::button $button_frame.cancel -text [mc "Cancel"] -command [list destroy $w]
    
    grid $button_frame.ok -column 0 -row 0 -padx 2p -pady 5p
    grid $button_frame.cancel -column 1 -row 0 -padx 5p -pady 5p
}

proc nextgenrm_GUI::tooltipAddCmd {tbl row col} {
    #****f* tooltipAddCmd/nextgenrm_GUI
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2012 - Casey Ackels
    #
    # FUNCTION
    #	Display a tooltip in the Tablelist
    #
    # SYNOPSIS
    #	The args are returned by the tabelist::tablelist command.
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
    #puts "tooltip: tbl:$tbl row:$row col:$col"
    # We only want to display the "Delete" text when we are in the 4th column, named "..."
    if {$col == 4} {
        tooltip::tooltip $tbl [mc "Double-Click to Delete"]
    }
}