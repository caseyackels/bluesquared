# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 03 02,2014
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 169 $
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
    #	N/A
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
    global log GS_filePaths GS_filePathSetup program company logSettings boxLabelInfo intlSetup headerParams headerParent headerAddress headerBoxes setup GS
    global dist w carrierSetup CSR packagingSetup mySettings

    
    #${log}::debug Folder: [eAssist_Global::folderAccessibility $program(Home)]
    #${log}::debug File: [eAssist_Global::fileAccessibility $program(Home) $mySettings(ConfigFile)]
    
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
    
    foreach value [array names logSettings] {
            chan puts $fd "logSettings($value) $logSettings($value)"
    }
    
    foreach value [array names boxLabelInfo] {
        ${log}::debug boxLabelInfo: $value
            chan puts $fd "boxLabelInfo($value) $boxLabelInfo($value)"
    }
    
    foreach value [array names intlSetup] {
            chan puts $fd "intlSetup($value) $intlSetup($value)"
    }
    
    foreach value [array names headerParent] {
            chan puts $fd "headerParent($value) $headerParent($value)"
    }
    
    foreach value [array names headerAddress] {
            chan puts $fd "headerAddress($value) $headerAddress($value)"
    }
    
    foreach value [array names headerParams] {
            chan puts $fd "headerParams($value) $headerParams($value)"
    }

    
    foreach value [array names headerBoxes] {
            chan puts $fd "headerBoxes($value) $headerBoxes($value)"
    }
    
    foreach value [array names dist] {
            chan puts $fd "dist($value) $dist($value)"
    }
 
    
    if {[info exists setup(smallPackageCarrierName)] == 1} {
        chan puts $fd "setup(smallPackageCarrierName) $setup(smallPackageCarrierName)"
        #${log}::debug smallPackageCarrierName: [lrange $setup(smallPackageCarriers) 0 end-1]
    }
    
    if {[info exists setup(smallPackageCarriers)] == 1} {
        chan puts $fd "setup(smallPackageCarriers) $setup(smallPackageCarriers)"
        foreach carrier $setup(smallPackageCarriers) {
            lappend testCarrier [join [lrange $carrier 0 0]]
        }
        #${log}::debug carriers: $testCarrier
    }
    
    foreach value [array names carrierSetup] {
        #if {![info exists carrierSetup($value)]} {continue}
        chan puts $fd "carrierSetup($value) $carrierSetup($value)"
    }
    
    foreach value [array names packagingSetup] {
        #if {![info exists packagingSetup($value)]} {continue}
        chan puts $fd "packagingSetup($value) $packagingSetup($value)"
    }
    
    foreach value [array names CSR] {
        #if {![info exists CSR($value)]} {continue}
        chan puts $fd "CSR($value) $CSR($value)"
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
    global log pref settings program mySettings GS
    ${log}::debug --START-- saveConfig
    #global settings header internal customer3P mySettings env international company shipVia3P
    
    if {['eAssist_checkPrefFile] eq "f1"} {
        set fd [open [file join $mySettings(Home) $mySettings(File)] w]
    } else {
        ${log}::critical -WARNING- Can't write to [file join $mySettings(Home) $mySettings(File)]. Settings will not be saved if changes occur.
        return
    }
    

    # Do processing (if applicable) before writing out to the file
    if {[info exists pref(nb)]} {
        set customer3P(table) [$pref(nb).f2.tab2b.listbox get 0 end]
        set customer3P(table) [lrange $customer3P(table) 0 end-1] ;# Get rid of the empty list generated by inserting an empty line in the listbox.
        
        set customer3P(name) "" ;# Always generate a new list
        
        foreach customer $customer3P(table) {
            lappend customer3P(name) [join [lrange $customer 0 0]]
        }
        
        chan puts $fd "customer3P(table) $customer3P(table)"
        chan puts $fd "customer3P(name) $customer3P(name)"
        
        #foreach value [array names customer3P] {
        #    chan puts $fd "company($value) $company($value)"
        #}

        # ---- #
        set shipVia3P(table) [$pref(nb).f2.tab2.listbox get 0 end]
        set shipVia3P(table) [lrange $shipVia3P(table) 0 end-1] ;# Get rid of the empty list generated by inserting an empty line in the listbox.
    
        set settings(shipvia3P) ""
        foreach shipVia_3P $shipVia3P(table) {
            lappend settings(shipvia3P) [join [lrange $shipVia_3P 1 1]]
        }
        
        # Write to file
        chan puts $fd "shipVia3P(table) $shipVia3P(table)"
    }
    
    # Write out individual variables
    chan puts $fd "program(Version) $program(Version)"
    chan puts $fd "program(PatchLevel) $program(PatchLevel)"
    chan puts $fd "program(beta) $program(beta)"
    
    
    # Write out entire arrays
    foreach value [array names settings] {
        chan puts $fd "settings($value) $settings($value)"
        #puts $mySettings($value)
        #${log}::debug Writing Settings : settings($value) $settings($value)
    }
    
    # Individual variables
    chan puts $fd "GS(gui,lastFrame) $GS(gui,lastFrame)"
    
    
    chan close $fd

    ${log}::debug --END-- saveConfig
} ;# lib::savePreferences 