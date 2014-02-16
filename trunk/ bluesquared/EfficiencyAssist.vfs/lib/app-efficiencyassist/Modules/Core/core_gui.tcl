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
    global settings program mySettings currentModule btn log mb wait

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
    $mb.file add command -label [mc "Export File"] -command {export::DataToExport}
    $mb.file add command -label [mc "Exit"] -command {exit}

    ## Module Menu - This is a dynamic menu for the active module.
    menu $mb.modMenu -tearoff 0 -relief raised -bd 2
    $mb add cascade -label [mc "Menu"] -menu $mb.modMenu


    ## Modules
    menu $mb.module -tearoff 0 -relief raised -bd 2
    $mb add cascade -label [mc "Module"] -menu $mb.module

    $mb.module add command -label [mc "Box Labels"] -command {eAssist::buttonBarGUI BoxLabels}
    $mb.module add command -label [mc "Batch Maker"] -command {eAssist::buttonBarGUI BatchMaker}
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
    
    ttk::button $btn(Bar).btn1
    ttk::button $btn(Bar).btn2
    #grid $btn(Bar).print -column 0 -row 3 -sticky nse -padx 8p
    #grid $btn(Bar).close -column 1 -row 3 -sticky nse
    
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
    #	(c) 2011-2014 Casey Ackels
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
    global btn program
  
    switch -- $module {
        BoxLabels   {
            # .. setup the buttons on the button bar
            eAssist::remButtons $btn(Bar)
            eAssist::addButtons [mc "Print Labels"] {} btn1 0 8p
            eAssist::addButtons [mc "Exit"] exit btn2 1 0p
            # .. remember what module we are in ..
            set program(currentModule) BoxLabels
            # .. launch the mode
            Shipping_Gui::shippingGUI
            # .. save the settings
            eAssistSetup::SaveGlobalSettings
        }
        BatchMaker   {
            # .. setup the buttons on the button bar
            eAssist::remButtons $btn(Bar) ;# Remove buttons
            eAssist::statusBar ;# Add the status bar
            # .. Initialize menu options
            importFiles::initMenu
            # .. remember what module we are in ..
            set program(currentModule) BatchMaker
            #eAssist::addButtons [mc "Export Files"] exit btn1 0 2p
            # .. launch the mode
            importFiles::eAssistGUI
            # .. save the settings
            eAssistSetup::SaveGlobalSettings
            }
        Setup       {
            # .. setup the buttons on the button bar
            eAssist::remButtons $btn(Bar)
            eAssist::addButtons [mc "Save"] eAssistSetup::SaveGlobalSettings btn1 0 8p
            eAssist::addButtons [mc "Exit"] exit btn2 1 0p
            # .. remember what module we are in ..
            set program(currentModule) Setup
            # .. launch the mode
            eAssistSetup::eAssistSetup
            # .. save the settings
            eAssistSetup::SaveGlobalSettings
        }
        default     {}
    }
    
} ;# buttonBarGUI


proc eAssist::addButtons {text command btn1 column padX} {
    #****f* addButtons/eAssist
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Add one button for each invocation to the Button Bar
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
    #   eAssist::remButtons
    #
    #***
    global log btn
    ${log}::debug --START-- [info level 1]
    
    {*}$btn(Bar).$btn1 configure -text $text -command $command
    grid $btn(Bar).$btn1 -column $column -row 3 -sticky nse -padx $padX
	
    ${log}::debug --END-- [info level 1]
} ;# eAssist::addButtons


proc eAssist::remButtons {path} {
    #****f* remButtons/eAssist
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Remove all widgets that exist in the slave, used in conjunction with eAssist::addButtons
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
    #   eAssist::addButtons
    #***
    global log
    ${log}::debug --START-- [info level 1]

    if {[grid slaves $path] != ""} { 
        foreach value [grid slaves $path] {
            grid forget $value
        }
    }
	
    ${log}::debug --END-- [info level 1]
} ;# eAssist::remButtons


proc eAssist::statusBar {args} {
    #****f* statusBar/eAssist
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	General Status bar
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
    global log btn job
    ${log}::debug --START-- [info level 1]

    # reconfigure btn(bar)
    pack configure $btn(Bar) -anchor w -fill x -pady 5p
    
    if {[winfo exists $btn(Bar).f1]} {destroy $btn(Bar).f1}
    set f1 [ttk::frame $btn(Bar).f1 -padding 2 -relief groove -borderwidth 2]
    grid $f1 -column 0 -row 0 -sticky nse
    
    ttk::label $f1.txt1 -text [mc "Total Copies:"]
    ttk::entry $f1.txt2 -textvariable job(TotalCopies) -width 5 -state disabled -justify center
    
    grid $f1.txt1 -column 0 -row 0 -sticky nse
    grid $f1.txt2 -column 1 -row 0 -sticky nsw -padx 5p
    

    
    ${log}::debug --END-- [info level 1]
} ;# eAssist::statusBar
