# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# Dependencies: See Below
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
    global settings program mySettings currentModule btn log mb

    wm geometry . 640x610 ;# Width x Height
    
    wm title . $program(FullName)
    focus -force .

    # Create the Menu's
    set mb [menu .mb]
    . configure -menu $mb

    ## File
    menu $mb.file -tearoff 0 -relief raised -bd 2

    $mb add cascade -label [mc "File"] -menu $mb.file
    #$mb.file add command -label [mc "Preferences..."] -command {eAssistPref::launchPreferences}
    #$mb.file add command -label [mc "Import File"] -command { eAssist_Helper::getOpenFile }
    $mb.file add command -label [mc "Exit"] -command {exit}

    ## Module Menu - This is a dynamic menu for the active module.
    menu $mb.modMenu -tearoff 0 -relief raised -bd 2
    $mb add cascade -label [mc "Menu"] -menu $mb.modMenu


    ## Modules
    menu $mb.module -tearoff 0 -relief raised -bd 2
    $mb add cascade -label [mc "Module"] -menu $mb.module

    $mb.module add command -label [mc "Box Labels"] -command {eAssist::buttonBarGUI BoxLabels}
    $mb.module add command -label [mc "Batch Imports"] -command {eAssist::buttonBarGUI Addresses}
    $mb.module add command -label [mc "Setup"] -command {eAssist::buttonBarGUI Setup}

    ## Help
    menu $mb.help -tearoff 0 -relief raised -bd 2
    $mb add cascade -label [mc "Help"] -menu $mb.help

    $mb.help add command -label [mc "About..."] -command { BlueSquared_About::aboutWindow }


    ## Create Separator Frame
    #set frame0 [ttk::frame .frame0]
    #ttk::separator $frame0.separator -orient horizontal
    #
    #grid $frame0.separator - -sticky ew -ipadx 4i
    #pack $frame0 -anchor n -fill x

    # Create the container frame
    ttk::frame .container
    pack .container -expand yes -fill both

    # Start the gui
    # All frames that make up the GUI are children to .container
       
    if {![info exists program(currentModule)]} {
        #${log}::debug current module : $program(currentModule)
        set program(currentModule) Setup
    }
 
    ##
    ## Control Buttons
    ##
    set btn(Bar) [ttk::frame .btnBar]
    pack $btn(Bar) -side bottom -anchor e -pady 13p -padx 5p
    
    ttk::button $btn(Bar).print
    ttk::button $btn(Bar).close
    grid $btn(Bar).print -column 0 -row 3 -sticky nse -padx 8p
    grid $btn(Bar).close -column 1 -row 3 -sticky nse
    
    eAssist::buttonBarGUI $program(currentModule)

    
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


proc eAssist::buttonBarGUI {module} {
    #****f* buttonBarGUI/eAssist
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	re-configure the button bar as needed, depending on what 'mode' we are in, or going to.
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	
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
    global btn
  
    switch -- $module {
        BoxLabels   {
            Shipping_Gui::shippingGUI
            eAssistSetup::SaveGlobalSettings
            $btn(Bar).print configure -text [mc "Print Labels"] -command {} -state disabled
            $btn(Bar).close configure -text [mc "Exit"] -command {exit}
        }
        Addresses   {
            importFiles::eAssistGUI
            eAssistSetup::SaveGlobalSettings
            importFiles::initMenu
            $btn(Bar).print configure -text [mc "Import File"] -command {eAssist_Helper::checkForErrors} -state disabled
            $btn(Bar).close configure -text [mc "Exit"] -command {exit}
            }
        Setup       {
            eAssistSetup::eAssistSetup
            eAssistSetup::SaveGlobalSettings
            $btn(Bar).print configure -text [mc "Save"] -command {eAssistSetup::SaveGlobalSettings} -state enable
            $btn(Bar).close configure -text [mc "Exit"] -command {exit}
        }
        default     {}
    }
    

    
} ;# buttonBarGUI