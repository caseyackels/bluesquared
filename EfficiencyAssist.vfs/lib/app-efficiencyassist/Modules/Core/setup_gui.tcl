# Creator: Casey Ackels
# Initial Date: September, 2013]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 478 $
# $LastChangedBy: casey.ackels@gmail.com $
# $LastChangedDate: 2015-02-22 12:50:13 -0800 (Sun, 22 Feb 2015) $
#
########################################################################################

##
## - Overview
# This file holds the setup GUI for Efficiency Assist

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

## Coding Conventions
# - Namespaces:

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

package provide eAssist_setup 1.0

namespace eval eAssistSetup {
    global program
    # List of namespace variables
        # w - Useage: Array, w(module_frame).widget
            variable GUI
}


proc eAssistSetup::eAssistSetup {} {
    #****f* eAssistSetup/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Setup Efficiency Assist; this is not a Preference window, so it shouldn't be used by anyone outside of the person setting it.
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	eAssistSetup::selectionChanged
    #
    # PARENTS
    #	eAssist::parentGUI
    #
    # NOTES
    #
    # SEE ALSO
    #
    #
    #***
    global G_setupFrame program tree log GS options settings

    # Reset frames before continuing
    eAssist_Global::resetFrames parent

    # Create tree for Setup
    set tbl [ttk::frame .container.tree]
    pack $tbl -fill both -side left -anchor nw -padx 5p -pady 5p -ipady 2p

    # Create main frame for all children in Setup
    set G_setupFrame [ttk::frame .container.setup]
    pack $G_setupFrame -expand yes -fill both -anchor n -padx 5p -pady 5p -ipady 2p

    # Create groups and children
    #
    # *** Add your new options to: eAssistSetup::selectionChanged in setup_code.tcl
    set tree(groups) {BoxLabels BatchMaker Packaging DistTypes CSR Company Logging EmailSetup Scheduler Admin}
    #set tree(groups) [list BoxLabels BatchMaker Packaging DistTypes CSR Company Logging "Email Setup"]

    set tree(BoxLabelsChildren) [list Paths Labels Delimiters BoxHeaders ShipMethod Misc.] ;# when changing these, also change them in eAssistSetup::selectionChanged
        set BoxLabelsChildren_length [llength $tree(BoxLabelsChildren)] ;# so we can add new tree items without having to adjust manually. Used in following childLists.

    set tree(BatchAddressesChildren) [list International AddressHeaders Carrier Countries]
        set BatchAddressesChildren_length [llength $tree(BatchAddressesChildren)]



    tablelist::tablelist $tbl.t -columns {18 ""}\
                                -background white \
                                -exportselection yes \
                                -showlabels no \
                                -yscrollcommand [list $tbl.scrolly set] \
                                -xscrollcommand [list $tbl.scrollx set]

    grid $tbl.t -column 0 -row 0 -sticky news

    ttk::scrollbar $tbl.scrolly -orient v -command [list $tbl.t yview]
    ttk::scrollbar $tbl.scrollx -orient h -command [list $tbl.t xview]

    grid $tbl.t -column 0 -row 0 -sticky news;# -padx 5p -pady 5p
    grid columnconfigure $tbl $tbl.t -weight 1
    grid rowconfigure $tbl $tbl.t -weight 1

    grid $tbl.scrolly -column 1 -row 0 -sticky nse
    grid $tbl.scrollx -column 0 -row 1 -sticky ews

    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $tbl.scrolly
    ::autoscroll::autoscroll $tbl.scrollx

    # Insert groups
    $tbl.t insertchildlist root end $tree(groups)

    # Group - BoxLabels
    $tbl.t insertchildlist 0 end $tree(BoxLabelsChildren)

    # Group - BatchAddresses
    $tbl.t insertchildlist [incr BoxLabelsChildren_length] end $tree(BatchAddressesChildren)


    ##
    ## Main Frame
    ##

    # Default window
    ${log}::notice currentSetupFrame: [info exists GS(gui,lastFrame)]

    if {[info exists GS(gui,lastFrame)] == 0} {
        set GS(gui,lastFrame) selectFilePaths_GUI
    }
    eAssistSetup::$GS(gui,lastFrame)

    ##
    ## Bindings
    ##
    # For Tree widget
    bind $tbl.t <<TablelistSelect>> {eAssistSetup::selectionChanged %W}

} ;# eAssistSetup::eAssistSetup


proc eAssistSetup::selectFilePaths_GUI {} {
    #****f* eAssistSetup/selectFilePaths_GUI
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Setup Efficiency Assist; this is not a Preference window, so it shouldn't be used by anyone outside of the person setting it.
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	eAssistSetup::selectionChanged
    #
    # PARENTS
    #	eAssist::parentGUI
    #
    # NOTES
    #
    # SEE ALSO
    #
    #
    #***
    global G_setupFrame GS_filePathSetup savePage
    # Default settings, but can be overridden at the user settings level.

    eAssist_Global::resetSetupFrames ;#selectFilePaths_GUI ;# Reset all frames so we start clean

    set frame1 [ttk::labelframe $G_setupFrame.frame1 -text [mc "File Paths"]]
    pack $frame1 -expand yes -fill both ;#-side top -anchor n -expand yes -fill both -padx 5p -pady 5p -ipady 2p

    ttk::label $frame1.txt1 -text [mc "Bartender"]
    ttk::entry $frame1.entry1 -textvariable GS_filePathSetup(bartenderEXE) -state disabled
    ttk::button $frame1.button1 -text [mc "Browse..."] -state disabled -command {set GS_filePathSetup(bartenderEXE) [eAssist_Global::OpenFile [mc "Find Bartender"] [pwd] file *.exe]}

        set GS_filePathSetup(enable,Bartender) 1
    ttk::checkbutton $frame1.checkbutton1 -text [mc "Disable"] -variable GS_filePathSetup(enable,Bartender) \
                                            -command {eAssistSetup::controlState $GS_filePathSetup(enable,Bartender) .container.setup.frame1.entry1 .container.setup.frame1.button1}

    ttk::label $frame1.txt2 -text [mc "Look in Directory"]
    ttk::entry $frame1.entry2 -textvariable GS_filePathSetup(lookInDirectory)
    ttk::button $frame1.button2 -text [mc "Browse..."] -command {set GS_filePathSetup(lookInDirectory) [eAssist_Global::OpenFile [mc "Set default Directory"] [pwd] dir]}
    #ttk::checkbutton $frame1.checkbutton2 -text [mc "Enable"] -command {} -variable GS_filePathSetup(enable,lookInDirectory)

    ttk::label $frame1.txt3 -text [mc "Save to Directory"]
    ttk::entry $frame1.entry3 -textvariable GS_filePathSetup(saveInDirectory)
    ttk::button $frame1.button3 -text [mc "Browse..."] -command {set GS_filePathSetup(saveInDirectory) [eAssist_Global::OpenFile [mc "Set default Save-to Directory"] [pwd] dir]}
    #ttk::checkbutton $frame1.checkbutton3 -text [mc "Enable"] -command {} -variable GS_filePathSetup(enable,saveInDirectory)

    #------------------------------

    grid $frame1.txt1 -column 0 -row 0 -padx 2p -pady 2p -sticky nse
    grid $frame1.entry1 -column 1 -row 0 -padx 2p -pady 2p -sticky news
    grid $frame1.button1 -column 2 -row 0 -padx 2p -pady 2p -sticky news
    grid $frame1.checkbutton1 -column 1 -row 1 -padx 2p -pady 2p -sticky nws

    grid $frame1.txt2 -column 0 -row 2 -padx 2p -pady 2p -sticky nse
    grid $frame1.entry2 -column 1 -row 2 -padx 2p -pady 2p -sticky news
    grid $frame1.button2 -column 2 -row 2 -padx 2p -pady 2p -sticky news

    grid $frame1.txt3 -column 0 -row 3 -padx 2p -pady 2p -sticky nse
    grid $frame1.entry3 -column 1 -row 3 -padx 2p -pady 2p -sticky news
    grid $frame1.button3 -column 2 -row 3 -padx 2p -pady 2p -sticky news

    grid columnconfigure $frame1 1 -weight 1
} ;# eAssistSetup::selectFilePaths_GUI


proc eAssistSetup::boxLabels_GUI {} {
    #****f* eAssistSetup/boxLabels_GUI
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2013 Casey Ackels
    #
    # FUNCTION
    #	Configure the box labels, this is where we will link the bartender label to eAssist.
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	eAssistSetup::selectionChanged
    #
    # PARENTS
    #	eAssist::parentGUI
    #
    # NOTES
    #   Widgets that end with:
    #   _1 (state is always enabled)
    #   _2 (state can change between disabled/enabled)
    #   _3 (state is controlled by a separate method)
    #   _4 (state fluctuates between Readonly and Enabled)
    #
    # SEE ALSO
    #
    #
    #***
    global G_setupFrame internal log boxLabelInfo w GS_filePathSetup GS_label

    eAssist_Global::resetSetupFrames ;# boxLabels_GUI ;# Reset all frames so we start clean

 
   ##
   ## Frame 2
   ##

    set w(bxFR2) [ttk::labelframe $G_setupFrame.frame2 -text [mc "Add/Modify Box Labels"]]
    pack $w(bxFR2) -expand yes -fill both -side top -anchor n ;#-pady 5p -padx 5p

    ttk::label $w(bxFR2).txt0_1 -text [mc "Label Name"]
    ttk::combobox $w(bxFR2).cbox1_4 -width 20 \
                                -values $boxLabelInfo(labelNames) \
                                -state readonly \
                                -textvariable boxLabelInfo(currentBoxLabel) \
                                -postcommand {eAssistSetup::viewBoxLabel $boxLabelInfo(currentBoxLabel)}

        # Display the current label; guard against a label not being there.
        if {[info exists boxLabelInfo(currentBoxLabel)] == 1} {
            eAssistSetup::viewBoxLabel $boxLabelInfo(currentBoxLabel)
        } else {
            set boxLabelInfo(currentBoxLabel) ""
        }

    ttk::button $w(bxFR2).del_1 -text [mc "Delete"] -command {eAssistSetup::deleteBoxLabel $boxLabelInfo(currentBoxLabel)}

    ttk::label $w(bxFR2).txt1_1 -text [mc "Label Folder"]
        set GS_filePathSetup(labelDirectory) "" ;# initialize variable
    ttk::entry $w(bxFR2).entry1_2 -textvariable GS_filePathSetup(labelDirectory) -state disabled


    ttk::button $w(bxFR2).button1_2 -text [mc "Browse..."] \
            -command {set GS_filePathSetup(labelDirectory) [eAssist_Global::OpenFile [mc "Set default Save-to Folder"] [pwd] dir]} \
            -state disabled

        set GS_filePathSetup(checkToggle) 0
    ttk::checkbutton $w(bxFR2).checkbutton1 -text [mc "Use global path"] -variable GS_filePathSetup(useGlobalPath) \
                                            -state disabled \
                                            -variable GS_filePathSetup(checkToggle) \
                                            -command {eAssistSetup::controlState}


    ttk::label $w(bxFR2).txt3_1 -text [mc "Number of Fields"]
    ttk::entry $w(bxFR2).entry3_2 -textvariable GS_label(numberOfFields) -state disabled

    ttk::button $w(bxFR2).cncl_2 -text [mc "Cancel"] -command {eAssistSetup::cancelBoxLabel} -state disabled
    ttk::button $w(bxFR2).add_1 -text [mc "Add"] -command {eAssistSetup::addBoxLabel}
    ttk::button $w(bxFR2).ok_1 -text [mc "Change"] -command {eAssistSetup::changeBoxLabel}

    #------------- Grid Frame2

    grid $w(bxFR2).txt0_1 -column 0 -row 0 -padx 2p -pady 2p -sticky nse
    grid $w(bxFR2).cbox1_4 -column 1 -row 0 -padx 2p -pady 2p -sticky news
    grid $w(bxFR2).del_1 -column 2 -row 0 -padx 2p -pady 2p -sticky news

    grid $w(bxFR2).txt1_1 -column 0 -row 1 -padx 2p -pady 2p -sticky nse
    grid $w(bxFR2).entry1_2 -column 1 -columnspan 2 -row 1 -padx 2p -pady 2p -sticky news

    grid $w(bxFR2).button1_2 -column 3 -row 1 -padx 2p -pady 2p -sticky ew
    grid $w(bxFR2).checkbutton1 -column 1 -row 2 -sticky nsw

    grid $w(bxFR2).txt3_1 -column 0 -row 5 -padx 2p -pady 2p -sticky nse
    grid $w(bxFR2).entry3_2 -column 1 -row 5 -padx 2p -pady 2p -sticky news

    grid $w(bxFR2).cncl_2 -column 1 -row 6 -padx 2p -pady 2p -sticky nse
    grid $w(bxFR2).add_1 -column 2 -row 6 -padx 2p -pady 2p -sticky nse
    grid $w(bxFR2).ok_1 -column 3 -row 6 -padx 2p -pady 2p -sticky nse

    #------------- Tooltips
    tooltip::tooltip $w(bxFR2).entry3_2 [mc "Total number of fields in the label, not including the Qty field."]


} ;# eAssistSetup::boxLabels_GUI
