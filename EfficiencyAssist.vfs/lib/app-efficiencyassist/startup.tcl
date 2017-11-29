# Creator: Casey Ackels
# Initial Date: February 13, 2011]
# Heavily modified: August 28, 2013]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 612 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2014-09-14 15:39:41 -0700 (Sun, 14 Sep 2014) $
#
########################################################################################

##
## - Overview
# This file holds the launch code for Efficiency Assist.

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

## Coding Conventions
# - Namespaces: These should have two parts, a _gui and a _code. Both words should be capitalized. i.e. Example_Code

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

# We use the prefix ' because we are in the global namespace now, and we don't want to pollute it.

package provide app-efficiencyassist 1.0

proc 'eAssist_sourceReqdFiles {} {
    #****f* 'eAssist_sourceReqdFiles/global
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
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
    #	'eAssist_sourceOtherFiles
    #
    #***
	global log logSettings
	## All files that need to be sourced should go here. That way if any of them fail to load, we'll catch it.

	#Modify the Auto_path so our 'package requires' work.
    ##
    ## Binaries
    ##

	lappend ::auto_path [file join [file dirname [info script]]]
	lappend ::auto_path [file join [file dirname [info script]] Binaries]
	#lappend ::auto_path [file join [file dirname [info script]] Binaries sqlite3.3.8]
	#lappend ::auto_path [file join [file dirname [info script]] Binaries tkdnd2.2]

    ##
    ## 3rd party tcl scripts
    ##
	lappend ::auto_path [file join [file dirname [info script]] Libraries]
	lappend ::auto_path [file join [file dirname [info script]] Libraries autoscroll]
	lappend ::auto_path [file join [file dirname [info script]] Libraries csv]
	lappend ::auto_path [file join [file dirname [info script]] Libraries tablelist5.13]
	#lappend ::auto_path [file join [file dirname [info script]] Libraries tcom3.9]
	lappend ::auto_path [file join [file dirname [info script]] Libraries twapi_4.1-dev]
	lappend ::auto_path [file join [file dirname [info script]] Libraries tooltip]
	lappend ::auto_path [file join [file dirname [info script]] Libraries about]
	lappend ::auto_path [file join [file dirname [info script]] Libraries debug] ;# Deprecated
	# MIME requires Base64
	lappend ::auto_path [file join [file dirname [info script]] Libraries mime]
	lappend ::auto_path [file join [file dirname [info script]] Libraries base64]
	lappend ::auto_path [file join [file dirname [info script]] Libraries smtp]
	#lappend ::auto_path [file join [file dirname [info script]] Libraries Cawt_1.0.7]
    lappend ::auto_path [file join [file dirname [info script]] Libraries Cawt-2.1.0-User]
	lappend ::auto_path [file join [file dirname [info script]] Libraries struct]
	lappend ::auto_path [file join [file dirname [info script]] Libraries report]
	lappend ::auto_path [file join [file dirname [info script]] Libraries cmdline]
	lappend ::auto_path [file join [file dirname [info script]] Libraries soundex]
    lappend ::auto_path [file join [file dirname [info script]] Libraries tdbc]


	##
    ## Project built scripts
    ##
	lappend ::auto_path [file join [file dirname [info script]] Modules]
	lappend ::auto_path [file join [file dirname [info script]] Modules Core]
	lappend ::auto_path [file join [file dirname [info script]] Modules BoxLabels]
	lappend ::auto_path [file join [file dirname [info script]] Modules Addresses]
	lappend ::auto_path [file join [file dirname [info script]] Modules Tools]
	lappend ::auto_path [file join [file dirname [info script]] Modules vUpdate]
	lappend ::auto_path [file join [file dirname [info script]] Modules Email]
	lappend ::auto_path [file join [file dirname [info script]] Modules Preferences]
    lappend ::auto_path [file join [file dirname [info script]] Modules Scheduler]
    lappend ::auto_path [file join [file dirname [info script]] Modules LabelDesigner]
    lappend ::auto_path [file join [file dirname [info script]] Modules LoadFlags]
	
	## Init namespaces
	namespace eval ea::sec {} ;# do not use
	namespace eval ea::code::sec {}
	
	# Setup, Admin
	namespace eval ea::code::admin {}
	namespace eval ea::db::admin {}
	namespace eval ea::gui::admin {}
	
	# Preferences
	namespace eval ea::code::pref {}
	namespace eval ea::db::pref {}
	namespace eval ea::gui::pref {}
	
	# Batch Maker
	namespace eval ea::code::bm {}
	namespace eval ea::db::bm {}
	namespace eval ea::gui::bm	{}
	
	# Reports (not really a module)
	namespace eval ea::code::export {}
    
    # Customer GUI/Info
    namespace eval ea::code::customer {}
    namespace eval ea::gui::customer {}
    namespace eval ea::db::customer {}
    
    # Adding samples
    namespace eval ea::code::samples {}
    namespace eval ea::gui::samples {}
    namespace eval ea::db::samples {}
    
    # Reports
    namespace eval ea::code::reports {}
    namespace eval ea::gui::reports {}
    namespace eval ea::db::reports {}
    
    # Publish
    namespace eval ea::code::publish {}
    namespace eval ea::gui::publish {}
    namespace eval ea::db::publish {}
    
    # Notes
    namespace eval ea::code::notes {}
    namespace eval ea::gui::notes {}
    namespace eval ea::db::notes {}
    
    # Init Vars
    namespace eval ea::code::init {}
    namespace eval ea::db::init {}
    
    # Batch formatter
    namespace eval ea::code::bf {}
    namespace eval ea::gui::bf {}
    namespace eval ea::db::bf {}
    
    # Label Designer; LD, ld
    namespace eval ea::code::lb {}
    namespace eval ea::gui::lb {}
    namespace eval ea::db::lb {}
    
    # Load Flags (LF)
    namespace eval ea::code::lf {}
    namespace eval ea::gui::lf {}
    namespace eval ea::db::lf {}
	  
    
	## Start the Package Require
	# System Packages
	package require msgcat
	# Import msgcat namespace so we only have to use [mc]
	namespace import msgcat::mc

	## 3rd Party modules
	#package require tkdnd
	package require Tablelist_tile
	#package require tcom
	package require tooltip
	package require autoscroll
	package require csv
	package require debug
	package require smtp
	package require mime
	package require base64
	package require twapi
	package require cawt
	package require cmdline
	package require struct
	package require report
	package require soundex
    package require tdbc
	
	
	# Logger; MD5 are [package require]'d below.
	

	## Efficiency Assist modules
	package require eAssist_core ;# Includes Preferences, and Setup mode
	package require eAssist_ModImportFiles
	package require eAssist_ModBoxLabels
	package require aboutwindow
	package require eAssist_Preferences
    package require eAssist_ModBatchFormatter
    package require eAssist_ModScheduler
    package require eAssist_ModLabelDesigner
    package require eAssist_ModLoadFlags
	
	# non-gui elements
	package require eAssist_tools
	package require vUpdate
	package require eAssist_email


	# Source files that are not in a package
	source [file join [file dirname [info script]] Libraries popups.tcl]
	source [file join [file dirname [info script]] Libraries errorMsg_gui.tcl]
	source [file join [file dirname [info script]] Libraries global_helpers.tcl]
	source [file join [file dirname [info script]] Libraries StreetSuffixState.tcl]
	source [file join [file dirname [info script]] Libraries fileProperties.tcl]
	source [file join [file dirname [info script]] Libraries saveSettings.tcl]
	source [file join [file dirname [info script]] Libraries password_util.tcl]
	source [file join [file dirname [info script]] Libraries AutoComplete.tcl]
	source [file join [file dirname [info script]] Libraries dateFormatting.tcl]
    
	loadSuffix ;# Initialize variables from StreetSuffixState.tcl
    
	#load [file join [file dirname [info script]] Libraries twapi twapi_base.dll]
	#load [file join [file dirname [info script]] Libraries sqlite3_3801 sqlite3801.dll] Sqlite3
	#source [file join [file dirname [info script]] Libraries debug.tcl]

} ;# 'eAssist_sourceReqdFiles


proc 'eAssist_bootStrap {} {
	global program log env
	
	set program(Home) [pwd]
	
	# enable packages that are required before the rest of the packages need to be loaded
	# Third Party packages
	lappend ::auto_path [file join [file dirname [info script]] Libraries log]
	lappend ::auto_path [file join [file dirname [info script]] Libraries md5]
	lappend ::auto_path [file join [file dirname [info script]] Libraries md5crypt]
	lappend ::auto_path [file join [file dirname [info script]] Libraries sqlite3_3801]
	
	package require md5
	package require md5crypt
	package require log
	package require logger
	package require logger::appender
	package require logger::utils
	package require sqlite3
	
	# Project built packages
	lappend ::auto_path [file join [file dirname [info script]] Modules Update]
	lappend ::auto_path [file join [file dirname [info script]] Modules Database]
	
	package require eAssist_db
	
	set debug(onOff) on ;# Old - Still exists so we don't receive errors, on the instances where it still exists
	set logSettings(loglevel) notice ;# Default to notice, over ridden if the user selects a different option
	set logSettings(displayConsole) 0 ;# disable by default, same as above. We read in the user settings file later; so if specific users want to see it, they will.

	# initialize logging service
	set log [logger::init log_svc]
	logger::utils::applyAppender -appender colorConsole
	${log}::notice "Initialized log_svc logging"
	
	# load the DB
	eAssist_db::loadDB

} ;#'eAssist_bootStrap


proc 'eAssist_initVariables {} {
    #****f* 'eAssist_initVariables/global
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2013-2011 Casey Ackels
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
	#	file: db_initvars.tcl
    #
    #***
    global settings header mySettings env intl ship program boxLabelInfo log logSettings intlSetup csmpls filter auth options emailSetup emailEvent job user setupJobDB widSec

	# Init namespaces
#    namespace eval ea {}
#	namespace eval ea::code {}
#	namespace eval ea::gui {}
#	namespace eval ea::db {}
	
	# Setup, Admin
	#namespace eval ea::code::admin {}
	#namespace eval ea::db::admin {}
	#namespace eval ea::gui::admin {}
	
	#-------- CORE SETTINGS
	#if {$logSettings(displayConsole) == 1} {console show}
	if {[info exists logSettings(displayConsole)]} {
		eAssistSetup::toggleConsole $logSettings(displayConsole)
	}
	
	# admin7954
	set auth(adminPword) {$1$6JV2D0G7$RHuHLMxJuuQ3HWWG3wOML1}
	set auth(adminSalt) {6JV2D0G7iPZ.xfGbLxnx}
	
	# Insert Setup into the Modules
	eAssist_db::checkModuleName Setup
	
	# init the user array - This is reset on Change User!
	ea::sec::initUser
	
	# init variables (arrays usually)
	ea::db::init_vars

		
	## Defaults
	# Just in case we can't figure out where we last stopped
	if {![info exists program(lastFrame)]} {
		# Set default last frame for Setup
		set program(lastFrame) company_GUI
	}
	
	if {![info exists program(checkUpdateTime)]} {
		set program(checkUpdateTime) 15:02
	}

	if {![info exists boxLabelInfo(labelNames)]} {
		# Setup variable for holding list of box label names
		set boxLabelInfo(labelNames) ""
	}

	if {![info exists program(updateFilePath)]} {
		# Path to the MANIFEST file (located on a shared drive)
		set program(updateFilePath) ""
	}
	
	if {![info exists program(updateFileName)]} {
		# Update file name - defualts to MANIFEST
		set program(updateFileName) MANIFEST
	}
	
	if {![info exists emailSetup(boxlabels,Notification)]} {
		set emailSetup(boxlabels,Notification) 0
	}

	
	##
	## Quick preferences - these are options that aren't in the Preference window, but sprinkled throughout the main program
	##
	
    if {![info exists options(AutoAssignHeader)]} {
		# Auto-Assign headers in BatchMaker
		set options(AutoAssignHeader) 1
	}
	
	if {![info exists options(ClearExistingData)]} {
		# Clears data from BatchMaker if it exists; this is useful if you want to overwrite what is already there.
		# 3/11/15 - Defaults to 0, we now have 'projects', and save data to a database. If a new project is started, the GUI is cleared out, and a new database is created.
		set options(ClearExistingData) 0
	}
    

	#-------- Initialize variables
	
	
	# Address Module
	# All are used in the Internal Samples window
	# Totals, are of course Totals
	# Start, is what they start out with (contains the totals)
	# no prefix/suffix, Checkboxes for the quick add feature
	array set csmpls [list startTicket "" \
					  TicketTotal 0 \
					  startCSR "" \
					  CSRTotal 0 \
					  startSmpl "" \
					  SmplRoomTotal 0 \
					  startSales "" \
					  SalesTotal 0 \
					  Ticket 0 \
					  CSR 0 \
					  SampleRoom 0 \
					  Sales 0 \
                      assignAllVersions 0 \
                      activeVersion ""]
	
	array set job [list CustName "" \
				   CustID "" \
				   CSRName "" \
				   Title "" \
				   Name "" \
				   Number "" \
				   JobSaveFileLocation "" \
				   TitleSaveFileLocation "" \
				   JobFirstShipDate "" \
				   JobBalanceShipDate "" \
                   ForestCert ""]
	
	# Filters
	array set filter [list run,stripASCII_CC 0 \
					  run,stripExtraSpaces 0 \
					  run,stripUDL 0 \
					  run,abbrvAddrState 0]

	
    if {![info exists mySettings(outFilePath)]} {
        # Location for saving the file
        set mySettings(outFilePath) [file dirname $mySettings(Home)]
    }

    if {![info exists mySettings(outFilePathCopy)]} {
        # Location for saving a copy of the file (this should just be up one directory)
        set mySettings(outFilePathCopy) [file dirname $mySettings(Home)]
    }
   
    if {![info exists mySettings(sourceFiles)]} {
        # Default for finding the source import files
        set mySettings(sourceFiles) [file dirname $mySettings(Home)]
    }
	
	if {![info exists mySettings(job,fileName)]} {
		# Default for the file name
		set mySettings(job,fileName) "%number %title %name"
	}

    if {![info exists settings(shipvia3P)]} {
        # Set possible 3rd party shipvia codes
        set settings(shipvia3P) [list 067 154 166]
    }

    if {![info exists settings(shipviaPP)]} {
        # Set possible pre paid shipvia codes
        set settings(shipviaPP) [list 017 018]
    }

    if {![info exists settings(BoxTareWeight)]} {
        # Box Tare Weight
        set settings(BoxTareWeight) .566
    }
	
	array set widSec [list group,Name "" \
					  group,Active 0 \
					  users,User_ID "" \
					  users,UserName "" \
					  users,UserLogin "" \
					  users,User_Status 0 \
					  users,UserEmail "" \
				      users,UserPwd "" \
					  users,UserSalt "" \
					  users,wid_id ""]

	# Schedule a time to check for updates
	#eAssist_Global::at $program(checkUpdateTime) vUpdate::checkForUpdates
	
	# Adding the available data to the UserDefinedValues table, which will show up in a dropdown on the Header Config page, in Setup.
	ea::db::initUserDefinedValues -desc Packages -table Packages -pk Pkg_ID -displayColumn Package
	ea::db::initUserDefinedValues -desc Container -table Containers -pk Container_ID -displayColumn Container
	ea::db::initUserDefinedValues -desc "Ship Via" -table ShipVia -pk ShipVia_ID -displayColumn ShipViaName
	ea::db::initUserDefinedValues -desc "Distribution Type" -table DistributionTypes -pk DistributionType_ID -displayColumn DistTypeName
	ea::db::initUserDefinedValues -desc "Shipping Class" -table ShippingClasses -pk ShippingClass_ID -displayColumn ShippingClass
	
	# This is dynamically populated, based on what is in the imported file and what the user types in. Default entry is "Version 1".
	ea::db::initUserDefinedValues -desc Versions -table Versions -pk Version_ID -displayColumn VersionName
	

} ;# 'eAssist_initVariables


proc 'eAssist_checkPrefFile {} {
    #****f* 'eAssist_checkPrefFile/global
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Find out what permissions we have for the Preferences
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
    global log mySettings program env
    #${log}::debug --START-- [info level 1]
    
	set folderAccess ""
	
	# Set file names
	set mySettings(File) mySettings.txt
	set mySettings(ConfigFile) config.txt
	set mySettings(Folder) eAssistSettings
	
	if {![info exists program(Name)]} {set program(Name) "EfficiencyAssist"}

	
	## FOLDER
	# Create or check personal settings folder %appdata%, to ensure that we can read/write to it
	if {![file isdirectory [file join $env(APPDATA) $mySettings(Folder)]]} {
			set folderAppDataAccess [eAssist_Global::folderAccessibility $env(APPDATA)]
			${log}::notice -WARNING- [file join $env(APPDATA) $mySettings(Folder)] does not exist, checking to see if we can create it...
			
			if {$folderAppDataAccess == 3} {
				file mkdir [file join $env(APPDATA) $mySettings(Folder)]
				set mySettings(Home) [file join $env(APPDATA) $mySettings(Folder)]
				${log}::notice -PASS- Creating $mySettings(Home) ...
			
			} else {
				${log}::critical -FAIL- Folder Access Code: $folderAppDataAccess
				${log}::critical -FAIL- Cannot create folder in $env(APPDATA), named $mySettings(Folder)
				set state d0
				return $state
			}
	
	} else {
		set folderAccess [eAssist_Global::folderAccessibility [file join $env(APPDATA) $mySettings(Folder)]]
		
		if {$folderAccess != 3} {
			${log}::critical -FAIL- Folder Access Code: $folderAccess
			${log}::critical -FAIL- Can't read/write to [file join $env(APPDATA) $mySettings(Folder)], this must be resolved to run $program(Name)
			set state d0
			return $state
		}
		
		if {$folderAccess == 3} {
			set mySettings(Home) [file join $env(APPDATA) $mySettings(Folder)]
			${log}::notice -PASS- $mySettings(Home) exists and has correct permissions ...
		}
	}
	

	
	## FILE
	# Create personal settings file mySettings.txt
	if {![file exists [file join $mySettings(Home) $mySettings(File)]]} {
		# File doesn't exist, check to see if we can read/write to it
		if {$folderAccess == 3} {
			${log}::notice -WARNING- $mySettings(File) doesn't exist, defaults will be loaded.
			set state f1
			return $state
		}

	} else {
		# file exists, but we can't read/write to it.
		if {[eAssist_Global::fileAccessibility $mySettings(Home) $mySettings(File)] != 3} {
			${log}::critical -FAIL- We can't read/write to $mySettings(File), this must be resolved to run $program(Name)
			set state f0
			return $state
		}
		
		# File seems to be ok
		${log}::notice -PASS- $mySettings(File) exists and has correct permissions ...
		set state f1
		return $state
	}

    #${log}::debug --END-- [info level 1]
} ;# 'eAssist_checkPrefFile


proc 'eAssist_loadSettings {} {
    #****f* 'eAssist_loadSettings/global
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2008-2013 Casey Ackels
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
    #	'eAssist_loadOptions
    #
    #***
    global settings debug program header customer3P env mySettings international company shipVia3P tcl_platform setup logSettings log boxSettings boxLabelInfo intlSetup
	global headerParent headerAddress headerParams headerBoxes GS_filePathSetup GS currentModule pref dist carrierSetup CSR packagingSetup options emailSetup

	# Ensure we have proper permissions for the preferences file before continuing
	'eAssist_checkPrefFile

	# Initialize setup variables
	foreach myFile [list $mySettings(ConfigFile)] {
		set fd [open [file join $program(Home) $myFile] r]
		
		set configFile [split [read $fd] \n]
		catch {chan close $fd}
	
		foreach line $configFile {
			if {$line == ""} {continue}
			set l_line [split $line " "]
			set [lindex $l_line 0] [join [lrange $l_line 1 end] " "]
			${log}::notice "Loaded variables ($myFile): $l_line"
		}
		${log}::notice "Loaded variables ($myFile): Complete!"
	}
    
    set fd "" ;# Make sure we are cleared out before reusing.
    # Load Personalized settings
	set settingsFile [file join $mySettings(Home) $mySettings(File)]
    if {[catch {open $settingsFile r} fd]} {
        ${log}::notice "File doesn't exist $mySettings(File); loading defaults"
        
    } else {
        set settingsFile [split [read $fd] \n]
        catch {chan close $fd}
        
        foreach line $settingsFile {
                if {$line == ""} {continue}
                set l_line [split $line " "]
                set [lindex $l_line 0] [join [lrange $l_line 1 end] " "]
				${log}::notice "Loaded variables ($mySettings(File)): $l_line"
        }
		${log}::notice "Loaded variables ($mySettings(File)): Complete!"
    }
	
    # Initialize default values
    'eAssist_initVariables
	
	
	# Set options in the Options DB
	option add *tearOff 0
	
	job::reports::initReportTables
	# Get excel version
	# Office 2003 = 11
	# Office 2007 = 12
}
# Load required packages and DB
'eAssist_bootStrap

# Load required files / packages
'eAssist_sourceReqdFiles

# Load the config file
'eAssist_loadSettings



# Get the currently loaded modules (box labels, batch maker, etc)
#eAssist_Global::getModules

# Load the Option Database options
#'distHelper_loadOptions
vUpdate::saveCurrentVersion

# Start the GUI
eAssist::parentGUI
