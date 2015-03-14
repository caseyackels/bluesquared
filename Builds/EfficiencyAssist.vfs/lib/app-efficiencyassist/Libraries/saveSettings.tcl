# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 03 02,2014
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 612 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2011-10-17 16:11:20 -0700 (Mon, 17 Oct 2011) $
#
########################################################################################

##
## - Overview
# Save Settings

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

proc eAssistSetup::SaveGlobalSettings {} {
    #****f* SaveGlobalSettings/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2013 Casey Ackels
    #
    # FUNCTION
    #	Save the Gloal Settings to a file. These settings are what affect everyone's usage of Efficiency Assist.
    #	
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	eAssistSetup::saveHeaderParams
    #
    # PARENTS
    #	eAssistSetup::saveBoxLabels
    #
    # NOTES
    #   When adding new global variables, make sure you put it into ['eAssist_loadSettings]
    #
    # SEE ALSO
    #
    #
    #***
    global log GS_filePaths GS_filePathSetup program company boxLabelInfo intlSetup headerParams headerParent headerAddress headerBoxes setup GS
    global dist w carrierSetup CSR packagingSetup mySettings settings

    
    #${log}::debug Folder: [eAssist_Global::folderAccessibility $program(Home)]
    #${log}::debug File: [eAssist_Global::fileAccessibility $program(Home) $mySettings(ConfigFile)]
    # Make sure we set the current modules' geometry before saving
    
    lib::savePreferences

    
    # If we can't read or write, lets return.
    if {[eAssist_Global::folderAccessibility $program(Home)] != 3} {
        ${log}::critical -FAIL- Can't read/write to $program(Home)! Any changes to Setup was not saved.
        return
    }
    
    # we only care if we can write to the file
    if {[eAssist_Global::fileAccessibility $program(Home) $mySettings(ConfigFile)] == 3} {
        set fd [open [file join $program(Home) $mySettings(ConfigFile)] w]
    } else {
        ${log}::critical -FAIL- Can't read/write to $mySettings(Home)! Any changes to Setup was not saved.
        return
    }
    
    # Update Header parameters; we'll get an error if we haven't gone to the Header page
    #catch {eAssistSetup::saveHeaderParams} err
    
    
    ${log}::notice Starting to write out Setup settings ...
    # ******************************
    
    foreach value [array names GS_filePaths] {
            chan puts $fd "GS_filePaths($value) $GS_filePaths($value)"
    }
    
    foreach value [array names GS_filePathSetup] {
            chan puts $fd "GS_filePathSetup($value) $GS_filePathSetup($value)"
    }
    
    
    foreach value [array names company] {
            chan puts $fd "company($value) $company($value)"
    }
        
    chan close $fd
    
    ${log}::notice Finished writing out the Setup settings
} ;# eAssistSetup::SaveGlobalSettings


proc lib::savePreferences {} {
    #****f* savePreferences/lib
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 - Casey Ackels
    #
    # FUNCTION
    #	saveConfig
    #
    # SYNOPSIS
    #	Write settings to config.txt file.
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	eAssistSetup::SaveGlobalSettings
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global log pref settings program mySettings GS options logSettings
    #${log}::debug --START-- saveConfig
    #global settings header internal customer3P mySettings env international company shipVia3P
    
    if {['eAssist_checkPrefFile] eq "f1"} {
        set fd [open [file join $mySettings(Home) $mySettings(File)] w]
    } else {
        ${log}::critical -WARNING- Can't write to [file join $mySettings(Home) $mySettings(File)]. Settings will not be saved if changes occur.
        return
    }
    
    # Update the geometry settings, just in case the user resized the window before saving.
    set options(geom,$settings(currentModule_machine)) [wm geometry .]
    
    # Write out individual variables
    chan puts $fd "program(Version) $program(Version)"
    chan puts $fd "program(PatchLevel) $program(PatchLevel)"
    chan puts $fd "program(beta) $program(beta)"
    chan puts $fd "program(updateFilePath) $program(updateFilePath)"
    chan puts $fd "program(updateFileName) $program(updateFileName)"
    
    if {[info exists GS(gui,lastFrame)]} {
        chan puts $fd "GS(gui,lastFrame) $GS(gui,lastFrame)"
    }
    
    # Write out entire arrays
    foreach value [array names settings] {
        chan puts $fd "settings($value) $settings($value)"
    }

    foreach value [array names mySettings] {
        chan puts $fd "mySettings($value) $mySettings($value)"
    }
    
    foreach value [array names options] {
        chan puts $fd "options($value) $options($value)"
    }
    
    foreach value [array names logSettings] {
            chan puts $fd "logSettings($value) $logSettings($value)"
    }
    
    chan close $fd

    #${log}::debug --END-- saveConfig
} ;# lib::savePreferences 