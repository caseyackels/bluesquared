# Initial Date: November 26, 2011]
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
	lappend ::auto_path [file join [file dirname [info script]] Libraries tablelist5.4]
	#lappend ::auto_path [file join [file dirname [info script]] Libraries tooltip]
        lappend ::auto_path [file join [file dirname [info script]] Libraries about]
	lappend ::auto_path [file join [file dirname [info script]] Libraries debug]

	##
        ## Project built scripts
        ##
	lappend ::auto_path [file join [file dirname [info script]] Modules]
	lappend ::auto_path [file join [file dirname [info script]] Modules Core]
	#lappend ::auto_path [file join [file dirname [info script]] Modules Importfiles]

	#
	## Start the Package Require
	## System Packages
	package require msgcat

	## 3rd Party modules
	#package require tkdnd
	package require Tablelist_tile 5.4
	#package require tooltip
	package require autoscroll
	#package require csv
	package require debug
	package require aboutwindow

	## ReceiptMaker NG
    package require rm_ng
	
	# Import namespace commands 
    namespace import 'debug::*
    namespace import msgcat::mc
	
	# Source files that are not in a package
        #source [file join [file dirname [info script]] Libraries popups.tcl]
        #source [file join [file dirname [info script]] Libraries errorMsg_gui.tcl]

        #'debug "Loaded"
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
    global program


	

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
    set debug(onOff) on
	console show

    set program(Name) "Receipt Maker NG"
    set program(Version) "Alpha"
    tk appname $program(Name)

	set program(Path) [pwd]
	#'debug pwd [pwd]
	
	set program(Profiles) [file join $program(Path) Profiles]
	set program(PCL) [file join $program(Path) PurchasedList]
	
	# Create the directories
	file mkdir $program(Profiles)
	file mkdir $program(PCL)
	
	# Files
	set program(Settings) [file join $program(Path) settings.txt]
	
		# Determine if settings file has been created
		# If file exists, read the variables (settings)
		if {![file exists $program(Settings)]} {
		'debug settings.txt doesn't exist. Creating...
		set Settings [open $program(Settings) w]
		chan close $Settings
	
		} else {
				'debug settings.txt exists. Opening...
				set Settings [open $program(Settings) r]
				'debug Settings: $Settings

				set readSettings [split [read $Settings] \n]
				chan close $Settings
			
				foreach line $readSettings {
						if {$line eq ""} {continue}
						set l_line [split $line " "]
						set [lindex $l_line 0] [join [lrange $l_line 1 end] " "]
				}
		# Check to see if we have new default settings
		'nextGenRM_initVariables

		puts "Loaded variables"
		}
		
		nextgenrm_Icons::InitializeIcons
}


# Load required files / packages
'nextGenRM_sourceReqdFiles

# Load the config file
'nextGenRM_loadSettings

# Load the Option Database options
#'nextGenRM_loadOptions

# Start the GUI
#disthelper::parentGUI
nextgenrm::parentGUI
# Load the rest of the files
#'nextGenRM_sourceOtherFiles