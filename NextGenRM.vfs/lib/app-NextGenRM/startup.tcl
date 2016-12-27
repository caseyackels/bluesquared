# Initial Date: June 20, 2016]

##
## - Overview
# This file holds the launch code for Receipt Maker NG


package provide app-nextgenrm 1.0

proc 'ng_BootStrap {} {
    global log logSettings program
    
    lappend ::auto_path [file join [file dirname [info script]] Libraries sqlite3_3801]
    lappend ::auto_path [file join [file dirname [info script]] Libraries log]
    lappend ::auto_path [file join [file dirname [info script]] Libraries md5]
    
    package require sqlite3
    package require md5
    package require log
	package require logger
	package require logger::appender
	package require logger::utils
    
    set logSettings(loglevel) notice ;# Default to notice, over ridden if the user selects a different option
	set logSettings(displayConsole) 1 ;# disable by default, same as above. We read in the user settings file later; so if specific users want to see it, they will.

	# initialize logging service
	set log [logger::init log_svc]
	logger::utils::applyAppender -appender colorConsole
	${log}::notice "Initialized log_svc logging"
    
    # init namepaces
    namespace eval rmGUI {}
    namespace eval rmDB {}
}


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
    'ng_BootStrap

	#Modify the Auto_path so our 'package requires' work.

	##
    ## 3rd party tcl scripts
    ##
	lappend ::auto_path [file join [file dirname [info script]] Libraries]
	lappend ::auto_path [file join [file dirname [info script]] Libraries autoscroll]
	#lappend ::auto_path [file join [file dirname [info script]] Libraries csv]
	lappend ::auto_path [file join [file dirname [info script]] Libraries tablelist5.13]
	lappend ::auto_path [file join [file dirname [info script]] Libraries tooltip]
	lappend ::auto_path [file join [file dirname [info script]] Libraries about]
	#lappend ::auto_path [file join [file dirname [info script]] Libraries debug]
	lappend ::auto_path [file join [file dirname [info script]] Libraries img]

	##
    ## Project built scripts
    ##
	lappend ::auto_path [file join [file dirname [info script]] Modules]
	lappend ::auto_path [file join [file dirname [info script]] Modules Core]

	
	## Start the Package Require
	## System Packages
	package require msgcat

	## 3rd Party modules
	#package require tkdnd
	package require Tablelist_tile 5.13
	package require tooltip
	package require autoscroll
	package require img::png
	#package require csv
	#package require debug
	package require aboutwindow

	## ReceiptMaker NG
    package require rm_ng
	
	# Import namespace commands 
    namespace import msgcat::mc

}


proc 'nextGenRM_initVariables {} {
    #****f* initVariables/Disthelper_Helper
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
    global program tmp

    set program(Name) "Receipt Maker NG"
    set program(Version) "[package versions app-nextgenrm] Alpha"
    
    # Init arrays
    array set tmp {
        taxtype,id      ""
        liquortype,id   ""
    }
}


proc 'nextGenRM_loadSettings {} {
    #****f* 'nextGenRM_loadSettings/global
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
    global program log
    # Basic variable initialization
    
    # Enable / Disable Debugging
    #set debug(onOff) on
    console show
    
    # Files
    set program(Path) [pwd]
    #set program(Settings) [file join $program(Path) settings.txt]
        
    # load the DB
	set myDB [file join $program(Path) rm.db]
    sqlite3 db $myDB

    # Check to see if we have new default settings
    'nextGenRM_initVariables
    ${log}::notice "Loaded variables"
    nextgenrm_Icons::InitializeIcons
}

# Load required files / packages
'nextGenRM_sourceReqdFiles

# Load the config file
'nextGenRM_loadSettings

# Start the GUI
nextgenrm::parentGUI