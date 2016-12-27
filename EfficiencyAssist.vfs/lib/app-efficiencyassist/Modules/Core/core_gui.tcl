# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 508 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2015-03-12 13:09:23 -0700 (Thu, 12 Mar 2015) $
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
    global program settings btn log mb options user
    ${log}::debug Entering parentGUI

    set locX [expr {[winfo screenwidth . ] / 4 + [winfo x .]}]
    set locY [expr {[winfo screenheight . ] / 5 + [winfo y .]}]
    wm geometry . 640x610+${locX}+${locY}
    
    if {![info exists settings(currentModule)]} {
        ${log}::debug currentModule doesn't exist, creating...!
        set settings(currentModule) {Batch Maker}
        set settings(currentModule_machine) [join $settings(currentModule) _]
    }
    
    wm protocol . WM_DELETE_WINDOW {eAssistSetup::SaveGlobalSettings; destroy .}
    wm protocol . WM_SAVE_YOURSELF {eAssistSetup::SaveGlobalSettings}

    
    wm title . $program(FullName)
    focus -force .

    # Create the Menu's
    set mb [menu .mb]
    . configure -menu $mb

    ### *** Main menu's are listed here. The sub-menu's are listed elsewhere.
    ## File
    menu $mb.file -tearoff 0 -relief raised -bd 2

    $mb add cascade -label [mc "File"] -menu $mb.file

    ## Module Menu - This is a dynamic menu for the active module.
    menu $mb.modMenu -tearoff 0 -relief raised -bd 2
    $mb add cascade -label [mc "Edit"] -menu $mb.modMenu

    # Start the gui
    # All frames that make up the GUI are children to .container  

    ## Modules
    # Create the main menu item
    menu $mb.module -tearoff 0 -relief raised -bd 2
    $mb add cascade -label [mc "Module"] -menu $mb.module
    if {[llength $user($user(id),modules)] > 1} {
        # Add in the sub-menus
        foreach mod [lsort $user($user(id),modules)] {
            switch -- $mod {
                "Batch Maker"       {$mb.module add command -label [mc "Batch Maker"] -command "ea::sec::modLauncher $mod"}
                "Batch Formatter"   {$mb.module add command -label [mc "Batch Formatter"] -command "ea::sec::modLauncher $mod"}
                "Box Labels"        {$mb.module add command -label [mc "Box Labels"] -command "ea::sec::modLauncher $mod"}
                Scheduler           {$mb.module add command -label [mc "Scheduler"] -command "ea::sec::modLauncher $mod"}
                Setup               {$mb.module add command -label [mc "Setup"] -command "ea::sec::modLauncher $mod"}
                default             {${log}::critical "$mod: doesn't have a menu configuration setup."}
            }
        }
    } else {
        if {$user($user(id),modules) != ""} {
            $mb.module add command -label $user($user(id),modules)
        } else {
            $mb.module add command -label "NO GROUP"
        }
    }


    ## Help
    menu $mb.help -tearoff 0 -relief raised -bd 2
    $mb add cascade -label [mc "Help"] -menu $mb.help

    $mb.help add command -label [mc "About..."] -command { BlueSquared_About::aboutWindow 1}
    $mb.help add command -label [mc "Release Notes..."] -command { BlueSquared_About::aboutWindow 2}


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
    
    #${log}::debug CurrentModule: $settings(currentModule)
    eAssist::buttonBarGUI $settings(currentModule)

    
    eAssist_GUI::editPopup

} ;# End of eAssist::parentGUI


proc eAssist::buttonBarGUI {Module} {
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
    global log btn program settings mb options user
    #${log}::debug Entering buttonBarGUI
    set module [join $Module]
    
    # Update "BatchMaker" to "Batch Maker"
    if {$module eq "BatchMaker"} {set module {Batch Maker}}
    
    set menuCount [$mb.module index end]
    
    # Enable/Disable the menu items depending on which one is active.
    # Cycle through the items in the menu, if they match the active module, disable it. If the module doesn't match their list of permissible modules, disable it.
    ${log}::debug User Modules: $user($user(id),modules)
    for {set x 0} {$menuCount >= $x} {incr x} {
            #${log}::debug Active Module: $module
            #${log}::debug Module in list: [$mb.module entrycget $x -label]
            #${log}::debug String Match: [string match [$mb.module entrycget $x -label] $module]
            #${log}::debug LSEARCH: [lsearch $user($user(id),modules) $module]
        if {[string match [$mb.module entrycget $x -label] $module] == 1 || [lsearch $user($user(id),modules) [$mb.module entrycget $x -label]] == -1} {
            $mb.module entryconfigure $x -state disable
        } else {
            $mb.module entryconfigure $x -state normal
        }
    }
    
    $mb.modMenu delete 0 end
    $mb.file delete 0 end
    switch -- $module {
        "Box Labels"   {
            ${log}::debug Entering $module mode
            # .. remember what module we are in ..
            set settings(currentModule) $module
            set settings(currentModule_machine) [join $module _]
            
            # .. setup the buttons on the button bar
            eAssist::remButtons $btn(Bar)
            eAssist::addButtons [mc "Print Labels"] Shipping_Code::printLabels btn1 0 8p
            eAssist::addButtons [mc "Print Breakdown"] Shipping_Gui::printbreakDown btn2 1 0p

            # .. launch the mode
            Shipping_Gui::shippingGUI
            
            # .. Setup the Geometry
            eAssist_Global::getGeom $settings(currentModule_machine) 450x475
            # .. save the settings
            #eAssistSetup::SaveGlobalSettings
            lib::savePreferences
        }
        "Batch Formatter"   {
            ${log}::debug Entering $module mode
            # .. remember what module we are in ..

            set settings(currentModule) $module
            set settings(currentModule_machine) [join $module _]
            
            # .. setup the buttons and status bar
            eAssist::remButtons $btn(Bar)
            
            # .. launch the module
            ea::gui::bf::LaunchGUI
            
            # .. Setup the geometry
            eAssist_Global::getGeom $settings(currentModule_machine) 900x610+240+124
            
            # .. save the settings
            #eAssistSetup::SaveGlobalSettings
            lib::savePreferences
        }
        "Batch Maker"   {
            ${log}::debug Entering $module mode
            # .. remember what module we are in ..
            #set settings(currentModule) [list $module 1]
            set settings(currentModule) $module
            set settings(currentModule_machine) [join $module _]


            # .. setup the buttons and status bar
            eAssist::remButtons $btn(Bar)
            eAssist::statusBar
            
            # .. Initialize menu options
            importFiles::initMenu
            
            # .. launch the mode
            importFiles::eAssistGUI
            
            # .. Setup the geometry
            eAssist_Global::getGeom $settings(currentModule_machine) 900x610+240+124
            
            # .. save the settings
            #eAssistSetup::SaveGlobalSettings
            lib::savePreferences
        }
        "Scheduler"     {
            ${log}::debug Entering $module mode
                        # .. remember what module we are in ..
            #set settings(currentModule) [list $module 1]
            set settings(currentModule) $module
            set settings(currentModule_machine) [join $module _]


            # .. setup the buttons and status bar
            eAssist::remButtons $btn(Bar)
            #eAssist::statusBar
            
            # .. Initialize menu options
            # ::initMenu
            
            # .. launch the mode
            ea::sched::gui::schedGUI
            
            # .. Setup the geometry
            eAssist_Global::getGeom $settings(currentModule_machine) 900x610+240+124
            
            # .. save the settings
            lib::savePreferences
        }
        Setup       {
            ${log}::debug Entering $module mode
            # .. remember what module we are in ..
            #set settings(currentModule) [list Setup 2]
            set settings(currentModule) $module
            set settings(currentModule_machine) [join $module _]

            # .. setup the buttons on the button bar
            eAssist::remButtons $btn(Bar)
            eAssist::addButtons [mc "Save"] eAssistSetup::SaveGlobalSettings btn1 0 8p
            eAssist::addButtons [mc "Exit"] exit btn2 1 0p

            # .. launch the mode
            eAssistSetup::eAssistSetup

            # .. Setup the geometry
            eAssist_Global::getGeom $settings(currentModule_machine) 845x573+247+156
            # .. save the settings
            #eAssistSetup::SaveGlobalSettings
            lib::savePreferences
        }
        default     {${log}::debug Hit the default: $module}
    }
    
    # If we do not have anything else in this menu; we don't need the separator bar. So lets skip it.
    set fileMenuCount [$mb.file index end]
    if {$fileMenuCount ne "none"} {
        $mb.file add separator
    }

    # Adding menu items that should always be shown
    $mb.file add command -label [mc "Preferences"] -command {ea::gui::pref::startPref}
    $mb.file add command -label [mc "Change User"] -command {lib::showPwordWindow}
    $mb.file add command -label [mc "Exit"] -command {eAssistSetup::SaveGlobalSettings ; exit}
    
    # Check the versions
    vUpdate::whatVersion
    
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
    #${log}::debug --START-- [info level 1]
    
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
	
    #${log}::debug --END-- [info level 1]
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
    #${log}::debug --START-- [info level 1]

    if {[grid slaves $path] != ""} { 
        foreach value [grid slaves $path] {
            grid forget $value
        }
    }
	
    #${log}::debug --END-- [info level 1]
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
    #${log}::debug --START-- [info level 1]
 
    if {[eAssist_Global::fileAccessibility $program(Home) $mySettings(ConfigFile)] != 3} {
        return disable
    } else {
        return normal
    }
	
    #${log}::debug --END-- [info level 1]
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
    #${log}::debug --START-- [info level 1]

    # reconfigure btn(bar)
    pack configure $btn(Bar) -side left -fill x -pady 5p
    
    if {[winfo exists $btn(Bar).f1]} {destroy $btn(Bar).f1}
    set f1 [ttk::frame $btn(Bar).f1 -padding 2 -borderwidth 2]
    grid $f1 -column 0 -row 0 -sticky nse
    
    ttk::label $f1.txt1 -text [mc "Total Copies:"]
    ttk::entry $f1.txt2 -textvariable job(TotalCopies) -width 15 -state disabled -justify center
    
    grid $f1.txt1 -column 0 -row 0 -sticky nse
    grid $f1.txt2 -column 1 -row 0 -sticky nsw -padx 5p
    

    
    #${log}::debug --END-- [info level 1]
} ;# eAssist::statusBar


proc eAssist::detectHeightWidth {} {
    #****f* detectHeightWidth/eAssist
    # CREATION DATE
    #   10/30/2014 (Thursday Oct 30)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssist::detectHeightWidth args 
    #
    # FUNCTION
    #	Figure out if we were maximized the last time we were closed
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
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log

    if {[winfo screenheight . ] == [winfo height .]} {
        #wm attributes . -zoomed 1
        wm state . zoomed
        } elseif {[winfo screenwidth .] == [winfo width .]} {
           #wm attributes . -zoomed 1
           wm state . zoomed
        }
} ;# eAssist::detectHeightWidth
