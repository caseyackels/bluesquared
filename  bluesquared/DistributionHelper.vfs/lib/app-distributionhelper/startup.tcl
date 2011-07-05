# Creator: Casey Ackels
# Initial Date: February 13, 2011]
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
# This file holds the launch code for Distribution Helper.

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

## Coding Conventions
# - Namespaces: These should have two parts, a _gui and a _code. Both words should be capitalized. i.e. Example_Code

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

# We use the prefix 'blueSquirrel_ because we are in the global namespace now, and we don't want to pollute it.

package provide app-disthelper 1.0

proc 'distHelper_sourceReqdFiles {} {
    #****f* 'distHelper_sourceReqdFiles/global
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Sources the required files. This means a faster load time for the gui.
    #
    # SYNOPSIS
    #	Add required files to the source lists
    #
    # CHILDREN
    #	None
    #
    # PARENTS
    #	None
    #
    # NOTES
    #	N/A
    #
    # SEE ALSO
    #	'distHelper_sourceOtherFiles
    #
    #***
	## All files that need to be sourced should go here. That way if any of them fail to load, we'll catch it.
	
	#Modify the Auto_path so our 'package requires' work.
        ##
        ## Binaries
        ##
	lappend ::auto_path [file join [file dirname [info script]]]
        lappend ::auto_path [file join [file dirname [info script]] Binaries]
        #lappend ::auto_path [file join [file dirname [info script]] Binaries sqlite3.3.8]
	lappend ::auto_path [file join [file dirname [info script]] Binaries tkdnd2.2]
        
	##
        ## 3rd party tcl scripts
        ##
	lappend ::auto_path [file join [file dirname [info script]] Libraries]
	lappend ::auto_path [file join [file dirname [info script]] Libraries autoscroll]
	lappend ::auto_path [file join [file dirname [info script]] Libraries csv]
	##lappend ::auto_path [file join [file dirname [info script]] Libraries tablelist5.2]
	lappend ::auto_path [file join [file dirname [info script]] Libraries tooltip]
	
	##
        ## Project built scripts
        ##
	lappend ::auto_path [file join [file dirname [info script]] Modules]
	lappend ::auto_path [file join [file dirname [info script]] Modules Core]
	lappend ::auto_path [file join [file dirname [info script]] Modules Importfiles]
	
	#
	## Start the Package Require
	#
	
	## System Packages
	package require msgcat
	
	## 3rd Party modules
	package require tkdnd
	#package require Tablelist_tile 5.2
	package require tooltip
	package require autoscroll
	package require csv
	
	## Distribution Helper modules
	package require disthelper_core
	package require disthelper_importFiles

	
	# Source files that are not in a package
        source [file join [file dirname [info script]] Libraries popups.tcl]
        source [file join [file dirname [info script]] Libraries errorMsg_gui.tcl]
        source [file join [file dirname [info script]] Libraries debug.tcl]
        
        #namespace import dh_Debug::debug
        'debug "Loaded"
}


proc 'distHelper_sourceOtherFiles {} {
    #****f* 'distHelper_sourceOtherFiles/global
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 20011 - Casey Ackels
    #
    # FUNCTION
    #	Sources the rest of the files.
    #
    # SYNOPSIS
    #	Add the files / packages to the source lists
    #
    # CHILDREN
    #	None
    #
    # PARENTS
    #	None
    #
    # NOTES
    #	N/A
    #
    # SEE ALSO
    #	'blueSquirrel_sourceReqdFiles
    #
    #***

}


proc 'distHelper_initVariables {} { 
    #****f* initVariables/Disthelper_Helper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	
    #
    # SYNOPSIS
    #	Initialize program defaults. Create new file if one does not exist.
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
    global settings
    
    # hackish, but this will allow us to add new defaults/settings without killing an existing config file.
    
    if {![info exists setings(Home)]} {
        # Application location
        set settings(Home) [pwd]
    }
    
    if {![info exists settings(outFilePath)]} {
        # Location for saving the file
        set settings(outFilePath) [file dirname $settings(Home)]
    }
    
    if {![info exists settings(outFilePathCopy)]} {
        # Location for saving a copy of the file (this should just be up one directory)
        set settings(outFilePathCopy) [file dirname $settings(Home)]
    }
    
    if {![info exists settings(sourceFiles)]} {
        # Default for finding the source import files
        set settings(sourceFiles) [file dirname $settings(Home)]
    }
    
    if {![info exists settings(importOrder)]} {
        # Set default for headers; wording is used internally
        set settings(importOrder) [list shipVia Company Consignee delAddr delAddr2 delAddr3 City State Zip Phone Quantity Version Date Contact Email 3rdParty]
    }

    if {![info exists settings(header,shipvia)]} {
        set settings(header,shipvia) [list "ship via" shipvia]
    }
    
    if {![info exists settings(header,company)]} {
        set settings(header,company) [list company destination "company name"]
    }

    if {![info exists settings(header,consignee)]} {
        # Variations on spelling of consignee
        set settings(header,consignee) [list consignee contact attention attn attn:]
    }
    
    if {![info exists settings(header,address1)]} {
        set settings(header,address1) [list address address1 "address 1" add add1 "add 1" addr addr1 "addr 1"]
    }
    
    if {![info exists settings(header,address2)]} {
        set settings(header,address2) [list address2 "address 2" add2 "add 2" addr2 "addr 2"]
    }
    
    if {![info exists settings(header,address3)]} {
        set settings(header,address3) [list address3 "address 3" add3 "add 3" addr3 "addr 3"]
    }
    
    if {![info exists settings(header,csv)]} {
        set settings(header,csv) [list city-state-zip city-st-zip "city state zip" "city st zip" csv state/region]
    }
    
    if {![info exists settings(header,state)]} {
        set settings(header,state) [list st st. state]
    }
    
    if {![info exists settings(header,quantity)]} {
        set settings(header,quantity) [list quantity qty]
    }
    
    if {![info exists settings(header,version)]} {
        set settings(header,version) [list version vers]
    }
    
    if {![info exists settings(header,zip)]} {
        set settings(header,zip) [list zip zipcode "zip code" postalcode "postal code" postal]
    }
    
    if {![info exists settings(BoxTareWeight)]} {
        # Box Tare Weight
        set settings(BoxTareWeight) .566
    }
    
}


proc 'distHelper_loadSettings {} {
    #****f* 'distHelper_loadSettings/global
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2008 - Casey Ackels
    #
    # FUNCTION
    #	Load the mandatory defaults. Everything else should be loaded in options
    #
    # SYNOPSIS
    #	None
    #
    # CHILDREN
    #	None
    #
    # PARENTS
    #	None
    #
    # NOTES
    #	N/A
    #
    # SEE ALSO
    #	'distHelper_loadOptions
    #
    #***
    global settings debug
    
    # Enable / Disable Debugging
    # See 'distHelper_sourceReqdFiles for the [namespace import] command
    set debug(onOff) on
    
    # Theme setting for Tile
    #ttk::style theme use xpnative
    
    # Import msgcat namespace so we only have to use [mc]
    namespace import msgcat::mc
    
    if {[catch {open config.txt r} fd]} {
	puts "unable to load defaults"
        puts "execute initVariables"
        
        # Initialize default values 
        'distHelper_initVariables
        
        #Disthelper_Preferences::saveConfig
        
    } else {
	set configFile [split [read $fd] \n]
	catch {chan close $fd}
	
	foreach line $configFile {
	    if {$line == ""} {continue}
	    set l_line [split $line " "]
	    set [lindex $l_line 0] [join [lrange $l_line 1 end] " "]
	}
        
        # Check to see if we have new default settings
        'distHelper_initVariables
        
        puts "Loaded variables"
    }
}


# Load the config file
'distHelper_loadSettings

# Load required files / packages
'distHelper_sourceReqdFiles

# Load the Option Database options
#'distHelper_loadOptions

# Start the GUI
disthelper::parentGUI

# Load the rest of the files
#'distHelper_sourceOtherFiles