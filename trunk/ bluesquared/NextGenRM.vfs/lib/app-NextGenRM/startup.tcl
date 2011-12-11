# Initial Date: November 26, 2011]
# Dependencies: See Below
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

package provide app-nextgenrm 1.0

proc 'nextGenRM_sourceReqdFiles {} {
    #****f* 'nextGenRM_sourceReqdFiles/global
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
    #	'nextGenRM_sourceOtherFiles
    #
    #***
	## All files that need to be sourced should go here. That way if any of them fail to load, we'll catch it.

	#Modify the Auto_path so our 'package requires' work.
        ##
        ## Binaries
        ##
	#lappend ::auto_path [file join [file dirname [info script]]]
        #lappend ::auto_path [file join [file dirname [info script]] Binaries]
        #lappend ::auto_path [file join [file dirname [info script]] Binaries sqlite3.3.8]
	#lappend ::auto_path [file join [file dirname [info script]] Binaries tkdnd2.2]

	##
        ## 3rd party tcl scripts
        ##
	lappend ::auto_path [file join [file dirname [info script]] Libraries]
	lappend ::auto_path [file join [file dirname [info script]] Libraries autoscroll]
	#lappend ::auto_path [file join [file dirname [info script]] Libraries csv]
	##lappend ::auto_path [file join [file dirname [info script]] Libraries tablelist5.2]
	#lappend ::auto_path [file join [file dirname [info script]] Libraries tooltip]
        lappend ::auto_path [file join [file dirname [info script]] Libraries about]

	##
        ## Project built scripts
        ##
	lappend ::auto_path [file join [file dirname [info script]] Modules]
	lappend ::auto_path [file join [file dirname [info script]] Modules Core]
	#lappend ::auto_path [file join [file dirname [info script]] Modules Importfiles]

	#
	## Start the Package Require
	#

	## System Packages
	package require msgcat

	## 3rd Party modules
	#package require tkdnd
	#package require Tablelist_tile 5.2
	#package require tooltip
	#package require autoscroll
	#package require csv

	## Distribution Helper modules
	#package require disthelper_core
	#package require disthelper_importFiles
        #package require aboutwindow


	# Source files that are not in a package
        #source [file join [file dirname [info script]] Libraries popups.tcl]
        #source [file join [file dirname [info script]] Libraries errorMsg_gui.tcl]
        #source [file join [file dirname [info script]] Libraries debug.tcl]

        #namespace import dh_Debug::debug
        'debug "Loaded"
}


proc 'nextGenRM_initVariables {} {
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
    global settings header

    # hackish, but this will allow us to add new defaults/settings without killing an existing config file.
    if {![info exists settings(Home)]} {
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
}


proc 'nextGenRM_loadSettings {} {
    #****f* 'nextGenRM_loadSettings/global
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
    #	'nextGenRM_loadOptions
    #
    #***
    global settings debug program header

    # Enable / Disable Debugging
    # See 'nextGenRM_sourceReqdFiles for the [namespace import] command
    set debug(onOff) on

    set program(Name) "NextGen - RM"
    set program(Version) ".01"
    tk appname $program(Name)

    # Theme setting for Tile
    #ttk::style theme use xpnative
    #puts "theme names: [ttk::style theme names]"


    # Import msgcat namespace so we only have to use [mc]
    namespace import msgcat::mc

    if {[catch {open config.txt r} fd]} {
	puts "unable to load defaults"
        puts "execute initVariables"

        # Initialize default values
        'nextGenRM_initVariables

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
        'nextGenRM_initVariables

        puts "Loaded variables"
    }
}


# Load the config file
'nextGenRM_loadSettings

# Load required files / packages
'nextGenRM_sourceReqdFiles

# Load the Option Database options
#'nextGenRM_loadOptions

# Start the GUI
disthelper::parentGUI

# Load the rest of the files
#'nextGenRM_sourceOtherFiles