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
namespace eval lib {}

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
    global program settings btn log mb
    ${log}::debug Entering parentGUI

    set locX [expr {[winfo screenwidth . ] / 4 + [winfo x .]}]
    set locY [expr {[winfo screenheight . ] / 5 + [winfo y .]}]
    #wm geometry .wi 625x375+${locX}+${locY}
    wm geometry . 640x610+${locX}+${locY}

    
    wm title . $program(FullName)
    focus -force .

    # Create the Menu's
    set mb [menu .mb]
    . configure -menu $mb

    ## File
    menu $mb.file -tearoff 0 -relief raised -bd 2

    $mb add cascade -label [mc "File"] -menu $mb.file
    $mb.file add command -label [mc "Import File"] -command {importFiles::fileImportGUI}
    #$mb.file add command -label [mc "Preferences..."] -command {eAssistPref::launchPreferences}
    $mb.file add command -label [mc "Export File"] -command {export::DataToExport} -state disabled
    $mb.file add command -label [mc "Exit"] -command {exit}

    ## Module Menu - This is a dynamic menu for the active module.
    menu $mb.modMenu -tearoff 0 -relief raised -bd 2
    $mb add cascade -label [mc "Edit"] -menu $mb.modMenu


    ## Modules
    menu $mb.module -tearoff 0 -relief raised -bd 2
    $mb add cascade -label [mc "Module"] -menu $mb.module

    $mb.module add command -label [mc "Box Labels"] -command {eAssist::buttonBarGUI BoxLabels 0}
    $mb.module add command -label [mc "Batch Maker"] -command {eAssist::buttonBarGUI BatchMaker 1}
    $mb.module add command -label [mc "Setup"] -command {eAssist::buttonBarGUI Setup 2}

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

 
    ##
    ## Control Buttons
    ##
    set btn(Bar) [ttk::frame .btnBar]
    pack $btn(Bar) -side bottom -anchor e -pady 13p -padx 5p
    
    ttk::button $btn(Bar).btn1
    ttk::button $btn(Bar).btn2

    # Start the gui
    # All frames that make up the GUI are children to .container  
    if {![info exists settings(currentModule)]} {
        set settings(currentModule) [list Setup 2]
    }
    
    #${log}::debug CurrentModule: $settings(currentModule)
    eAssist::buttonBarGUI $settings(currentModule)

    
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


proc eAssist::buttonBarGUI {args} {
    #****f* buttonBarGUI/eAssist
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Controls what module we start in, and re-configure the button bar as needed, depending on what 'mode' we are in, or going to.
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
    global log btn program settings mb
    ${log}::debug Entering buttonBarGUI
    
    set module [lrange [join $args] 0 0]
    set idx [lrange [join $args] 1 1]
    
    set menuCount [$mb.module index end]
    
    # Enable/Disable the menu items depending on which one is active.
    for {set x 0} {$menuCount >= $x} {incr x} {
        if {$idx == $x} {
            $mb.module entryconfigure $x -state disable
        } else {
            $mb.module entryconfigure $x -state normal
        }
    }
    
    #${log}::debug INDEX: [lrange $args 1 1]
        
    ${log}::debug Entering - $module
    switch -- $module {
        BoxLabels   {
            ${log}::debug Entering $module mode
            # .. remember what module we are in ..
            set settings(currentModule) [list BoxLabels 0]
            
            # .. setup the buttons on the button bar
            eAssist::remButtons $btn(Bar)
            eAssist::addButtons [mc "Print Labels"] {} btn1 0 8p
            eAssist::addButtons [mc "Exit"] exit btn2 1 0p

            # .. launch the mode
            Shipping_Gui::shippingGUI
            
            # .. save the settings
            #eAssistSetup::SaveGlobalSettings
            lib::savePreferences
        }
        BatchMaker   {
            ${log}::debug Entering $module mode
            # .. remember what module we are in ..
            set settings(currentModule) [list BatchMaker 1]

            # .. setup the buttons and status bar
            eAssist::remButtons $btn(Bar)
            eAssist::statusBar
            
            # .. Initialize menu options
            importFiles::initMenu
            
            # .. launch the mode
            importFiles::eAssistGUI
            
            # .. save the settings
            #eAssistSetup::SaveGlobalSettings
            lib::savePreferences
            }
        Setup       {
            ${log}::debug Entering $module mode
            # .. remember what module we are in ..
            set settings(currentModule) [list Setup 2]

            # .. setup the buttons on the button bar
            eAssist::remButtons $btn(Bar)
            eAssist::addButtons [mc "Save"] eAssistSetup::SaveGlobalSettings btn1 0 8p
            eAssist::addButtons [mc "Exit"] exit btn2 1 0p

            # .. launch the mode
            eAssistSetup::eAssistSetup
            
            # .. save the settings
            #eAssistSetup::SaveGlobalSettings
            lib::savePreferences 
        }
        default     {}
    }
    
    
} ;# buttonBarGUI


proc eAssist::addButtons {text command btn1 column padX args} {
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
    global log btn settings
    ${log}::debug --START-- [info level 1]
    
    if {[lrange $settings(currentModule) 0 0] eq "Setup"} {
        
        if {$text eq [mc "Save"]} {
            set state [eAssist::stateButtons]
        } else {
            set state normal
        }
    } else {
        set state normal
    }
    
    # reconfigure btn(bar)
    pack configure $btn(Bar) -side right -fill x -pady 5p
    
    {*}$btn(Bar).$btn1 configure -text $text -command $command -state $state
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

proc eAssist::stateButtons {} {
    #****f* stateButtons/eAssist
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Configures the state of the Save button, depending on if we can read/write to the config file in Setup mode
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
    global log mySettings program
    ${log}::debug --START-- [info level 1]
 
    if {[eAssist_Global::fileAccessibility $program(Home) $mySettings(ConfigFile)] != 3} {
        return disable
    } else {
        return normal
    }
	
    ${log}::debug --END-- [info level 1]
} ;# eAssist::stateButtons


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
    pack configure $btn(Bar) -side left -fill x -pady 5p
    
    if {[winfo exists $btn(Bar).f1]} {destroy $btn(Bar).f1}
    set f1 [ttk::frame $btn(Bar).f1 -padding 2 -borderwidth 2]
    grid $f1 -column 0 -row 0 -sticky nse
    
    ttk::label $f1.txt1 -text [mc "Total Copies:"]
    ttk::entry $f1.txt2 -textvariable job(TotalCopies) -width 15 -state disabled -justify center
    
    grid $f1.txt1 -column 0 -row 0 -sticky nse
    grid $f1.txt2 -column 1 -row 0 -sticky nsw -padx 5p
    

    
    ${log}::debug --END-- [info level 1]
} ;# eAssist::statusBar
