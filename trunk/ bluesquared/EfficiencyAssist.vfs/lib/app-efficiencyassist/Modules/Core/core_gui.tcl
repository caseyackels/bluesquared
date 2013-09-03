# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 156 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2011-10-02 22:00:38 -0700 (Sun, 02 Oct 2011) $
#
########################################################################################

##
## - Overview
# This file holds the parent GUI frame, buttons and menu for Distribution Helper

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

## Coding Conventions
# - Namespaces:

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

# Start GUI
package provide eAssist_core 1.0

namespace eval eAssist {}

proc eAssist::parentGUI {} {
    #****f* parentGUI/eAssist
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Generate the parent GUI container and buttons (Cancel / Generate File)
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	eAssist::upsImportGUI
    #
    # PARENTS
    #	None
    #
    # NOTES
    #	None
    #
    # SEE ALSO
    #	N/A
    #
    #***
    global settings program mySettings

    wm geometry . 640x575 ;# width x Height
    
    wm title . $program(FullName)
    focus -force .

    # Create the Menu's
    set mb [menu .mb]
    . configure -menu $mb

    ## File
    menu $mb.file -tearoff 0 -relief raised -bd 2

    $mb add cascade -label [mc "File"] -menu $mb.file
    $mb.file add command -label [mc "Import File"] -command { eAssist_Helper::getOpenFile }
    $mb.file add command -label [mc "Exit"] -command {exit}

    ## Edit
    menu $mb.edit -tearoff 0 -relief raised -bd 2
    $mb add cascade -label [mc "Edit"] -menu $mb.edit

    $mb.edit add command -label [mc "Preferences..."] -command { eAssist_Preferences::prefGUI }
    $mb.edit add command -label "Reset" -command { eAssist_Helper::resetVars -resetGUI }

    ## Modules
    menu $mb.module -tearoff 0 -relief raised -bd 2
    $mb add cascade -label [mc "Module"] -menu $mb.module

    $mb.module add command -label [mc "Box Labels"] -command {eAssist_Global::resetFrames Shipping_Gui::shippingGUI}
    $mb.module add command -label [mc "Batch Imports"] -command {eAssist_Global::resetFrames eAssist_GUI::eAssistGUI}
    $mb.module add command -label [mc "Setup"] -command {eAssist_Global::resetFrames eAssistSetup::eAssistSetup}

    ## Help
    menu $mb.help -tearoff 0 -relief raised -bd 2
    $mb add cascade -label [mc "Help"] -menu $mb.help

    $mb.help add command -label [mc "About..."] -command { BlueSquared_About::aboutWindow }


    # Create Separator Frame
    set frame0 [ttk::frame .frame0]
    ttk::separator $frame0.separator -orient horizontal

    grid $frame0.separator - -sticky ew -ipadx 4i
    pack $frame0 -anchor n -fill x -expand yes

    # Create the container frame
    ttk::frame .container
    pack .container -expand yes -fill both -anchor n -side top

    # Start the gui
    # All frames that make up the GUI are children to .container
    #eAssist_GUI::eAssistGUI
    eAssistSetup::eAssistSetup


    ##
    ## Control Buttons
    ##

    set btnBar [ttk::frame .btnBar]

    ttk::button $btnBar.print -text [mc "Generate File"] -command { eAssist_Helper::checkForErrors } -state disabled
    ttk::button $btnBar.close -text [mc "Exit"] -command {exit}

    grid $btnBar.print -column 0 -row 3 -sticky nse -padx 8p
    grid $btnBar.close -column 1 -row 3 -sticky nse
    pack $btnBar -side bottom -anchor e -pady 13p -padx 5p


    # ToolTips
    tooltip::tooltip $btnBar.close "Close (Esc)"

    # Bindings

    bind $btnBar.close <Return> {exit}
    
    eAssist_GUI::editPopup
    
    ##
    ## If this is the first startup for the machine on this version, we should launch the "New Feature Dialog"
    ##
    #if {$settings(newSettingsTxt) eq no} {
    #    ### Check version and patchLevel to see if we are greater than those numbers, if so display the new version dialog.
    #    #Error_Message::newVersion buttontxt buttoncmd VersionTxt
    #    set mySettings(FullVersion) $program(Version).$program(PatchLevel)
    #    Error_Message::newVersion [mc "View Settings"] "eassist_Preferences::prefGUI" This version changes how your files are opened and saved.\nPlease ensure that the files will save to an appropriate location.\nWould you like to go there now?
    #    #Error_Message::errorMsg saveSettings1
    #}
    
    #if {$settings(newSettingsTxt) eq yes} {
    #    if {[info exists mySettings(FullVersion)]} {
    #        #if {$settings(FullVersion) ne $program(Version).$program(PatchLevel)} {}
    #        if {[string match $mySettings(FullVersion) $program(Version).$program(PatchLevel)] ne 1} {
    #            Error_Message::newVersion "" "" EA Version $program(Version).$program(PatchLevel)
    #            set mySettings(FullVersion) $program(Version).$program(PatchLevel)
    #            #eassist_Preferences::saveConfig
    #        }
    #    }
    #}

} ;# End of parentGUI