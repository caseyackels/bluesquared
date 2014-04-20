# Creator: Casey Ackels
# Initial Date: February 13, 2011]
# Heavily modified: August 28, 2013]
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
	lappend ::auto_path [file join [file dirname [info script]] Libraries tablelist5.11]
	lappend ::auto_path [file join [file dirname [info script]] Libraries tcom3.9]
	#lappend ::auto_path [file join [file dirname [info script]] Libraries twapi]
	lappend ::auto_path [file join [file dirname [info script]] Libraries tooltip]
	lappend ::auto_path [file join [file dirname [info script]] Libraries about]
	lappend ::auto_path [file join [file dirname [info script]] Libraries debug] ;# Deprecated


	##
    ## Project built scripts
    ##
	lappend ::auto_path [file join [file dirname [info script]] Modules]
	lappend ::auto_path [file join [file dirname [info script]] Modules Core]
	lappend ::auto_path [file join [file dirname [info script]] Modules BoxLabels]
	lappend ::auto_path [file join [file dirname [info script]] Modules Addresses]
	lappend ::auto_path [file join [file dirname [info script]] Modules Tools]
	lappend ::auto_path [file join [file dirname [info script]] Modules vUpdate]

	#
	## Start the Package Require
	#

	## System Packages
	package require msgcat

	## 3rd Party modules
	#package require tkdnd
	package require Tablelist_tile 5.11
	package require tcom
	#package require twapi
	package require tooltip
	package require autoscroll
	package require csv
	package require debug
	
	
	# Logger; MD5 are [package require]'d below.
	

	## Efficiency Assist modules
	#package require eAssist_Preferences
	package require eAssist_core ;# Includes Preferences, and Setup mode
	package require eAssist_importFiles
	package require aboutwindow
	package require boxlabels
	package require eAssist_tools
	package require vUpdate
	
    


	# Source files that are not in a package
    source [file join [file dirname [info script]] Libraries popups.tcl]
    source [file join [file dirname [info script]] Libraries errorMsg_gui.tcl]
	source [file join [file dirname [info script]] Libraries global_helpers.tcl]
    source [file join [file dirname [info script]] Libraries StreetSuffixState.tcl]
	source [file join [file dirname [info script]] Libraries fileProperties.tcl]
	source [file join [file dirname [info script]] Libraries saveSettings.tcl]
    
    loadSuffix ;# Initialize variables from StreetSuffixState.tcl
    
    load [file join [file dirname [info script]] Libraries twapi twapi-x86-3.1.17.dll]
    #source [file join [file dirname [info script]] Libraries debug.tcl]
	
	if {[info exists logSettings(displayConsole)]} {
        # Setup variable for holding list of box label names
        eAssistSetup::toggleConsole $logSettings(displayConsole)
    }	

} ;# 'eAssist_sourceReqdFiles


proc 'eAssist_bootStrap {} {
	# enable packages that are required before the rest of the packages need to be loaded
	# Project built packages
	lappend ::auto_path [file join [file dirname [info script]] Modules Update]
	
	#package require vUpdate
	
	# Third Party packages
	lappend ::auto_path [file join [file dirname [info script]] Libraries log]
	lappend ::auto_path [file join [file dirname [info script]] Libraries md5]
	
	package require md5
	package require log
	package require logger
	package require logger::appender
	package require logger::utils
	
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
    #
    #***
    global settings header mySettings env intl ship program boxLabelInfo log logSettings intlSetup csmpls filter logSettings

	#-------- CORE SETTINGS
	if {$logSettings(displayConsole) == 1} {console show}
	
	## Defaults
	#
	
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
					  Sales 0]
	
	# Filters
	array set filter [list run,stripASCII_CC 1 \
					  run,stripCC 1 \
					  run,stripUDL 1 \
					  run,abbrvAddrState 1]
	
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

    if {![info exists settings(importOrder)]} {
        # Set default for headers; wording is used internally
        set settings(importOrder) [list shipVia Company Consignee delAddr delAddr2 delAddr3 City State Zip Phone Quantity Version Date Contact Email 3rdParty]
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

    #
    # Header
    #
    
    if {![info exists header(shipvia)]} {
        set header(shipvia) [list ShipViaCode "ship via" shipvia]
    }

    if {![info exists header(company)]} {
        set header(company) [list ShipToName company destination "company name"]
    }

    if {![info exists header(attention)]} {
        # Variations on spelling of consignee
        set header(attention) [list ShipToContact contact attention attn attn:]
    }

    if {![info exists header(address1)]} {
        set header(address1) [list ShipToAddressline1 address address1 "address 1" add add1 "add 1" addr addr1 "addr 1"]
    }

    if {![info exists header(address2)]} {
        set header(address2) [list ShipToAddressline2 address2 "address 2" add2 "add 2" addr2 "addr 2"]
    }

    if {![info exists header(address3)]} {
        set header(address3) [list ShipToAddressline3 address3 "address 3" add3 "add 3" addr3 "addr 3"]
    }

    if {![info exists header(CityStateZip)]} {
        set header(CityStateZip) [list city-state-zip city-st-zip "city state zip" "city st zip" csv state/region]
    }

    if {![info exists header(city)]} {
        set header(city) [list City ShipToCity]
    }
    
    if {![info exists header(state)]} {
        set header(state) [list ShipToState st st. state]
    }
    
    if {![info exists header(country)]} {
        set header(country) [list country ShipToCountry]
    }

     if {![info exists header(zip)]} {
        set header(zip) [list ShipToZipCode zip zipcode "zip code" postalcode "postal code" postal]
    }
    
    if {![info exists header(phone)]} {
        set header(phone) [list phone ShipToPhone]
    }
    
    if {![info exists header(email)]} {
        set header(email) [list email ShipToEmail]
    }
    
    if {![info exists header(shipdate)]} {
        set header(shipdate) [list "Ship Date" shipdate]
    }

     if {![info exists header(BatchNumberReference)]} {
        # This will hold the job number and a alpha at the end
        # E.G 60155_A (or 60155A)
        set header(BatchNumberReference) [list BatchNumberReference]
    }

    if {![info exists header(Reference1)]} {
        # After we output the file, Reference1 will hold the job number
        set header(Reference1) [list Reference1]
    }
    
    if {![info exists header(version)]} {
        # This is used in the original file, and reassigned to the Reference2 column
        set header(version) [list version vers]
    }
    
    if {![info exists header(Reference2)]} {
        # After we output the file, Reference2 will hold the Version/Qty
        set header(Reference2) [list Reference2]
    }

    if {![info exists header(quantity)]} {
        # This is used in the original file, and reassigned to the Reference2 column
        set header(quantity) [list quantity qty]
    }
    
    if {![info exists header(PackageQuantity)]} {
        set header(PackageQuantity) [list PackageQuantity]
    }

    if {![info exists header(3rdPartyNumber)]} {
        # 3P Account Number
        set header(3rdPartyNumber) [list ThirdPartyAccountNumber "3rd Party" 3rdParty 3p]
    }
    
    if {![info exists header(3rdPartyCode)]} {
        # Customer Code within Process Shipper
        set header(3rdPartyCode) [list ThirdPartyID]
    }
	


    # - These are used internally
    # 8/28/2013 - Move this so we see them within Efficiency
	
    if {![info exists header(pieceweight)]} {
        set header(pieceweight) [list pieceweight "pc weight" "piece weight" "pc wgt"]
    }

    if {![info exists header(fullbox)]} {
        set header(fullbox) [list fullbox "full box"]
    }
    
    if {![info exists header(residential)]} {
        # This column is used when we use address cleansing.
        set header(residential) [list ResidentialDelivery]
    }
    
	
	# Schedule a time to check for updates
	#eAssist_Global::at $program(checkUpdateTime) vUpdate::checkForUpdates
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
    ${log}::debug --START-- [info level 1]
    
	set folderAccess ""
	
	# Set file names
	set mySettings(File) mySettings.txt
	set mySettings(ConfigFile) config.txt
    set program(Home) [pwd]
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

    ${log}::debug --END-- [info level 1]
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
	global headerParent headerAddress headerParams headerBoxes GS_filePathSetup GS currentModule pref dist carrierSetup CSR packagingSetup
	
	set debug(onOff) on ;# Old - Still exists so we don't receive errors, on the instances where it still exists
	set logSettings(loglevel) notice ;# Default to notice, over ridden if the user selects a different option
	set logSettings(displayConsole) 0 ;# disable by default, same as above
	
	# Load required packages
	'eAssist_bootStrap

	# initialize logging service
	set log [logger::init eAssist_svc]
	logger::utils::applyAppender -appender colorConsole
	${log}::notice "Initialized eAssist_svc logging"

    # Set required configuration changes here, i.e.
    # set cVersion(Setup,message) <informational message>
    # set cVersion(Setup,newconfig) <setup page>, <setup page, ...
    # set cVersion(Options,message) <informational message>
    # set cVersion(Options,newconfig) <options page>, <options page>, ...
    

    # Import msgcat namespace so we only have to use [mc]
    namespace import msgcat::mc
	
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
        }
    }
	
    # Initialize default values
    'eAssist_initVariables
	
	
	# Set options in the Options DB
	option add *tearOff 0
	
#	# check for updates
#    set fd "" ;# Make sure we are cleared out before reusing.
#	set updateFile [file join $program(updateFilePath) $program(updateFileName)]
#    if {[catch {open $updateFile r} fd]} {
#        ${log}::notice "File doesn't exist $program(updateFileName); loading defaults"
#
#    } else {
#        set updateFile [split [read $fd] \n]
#        catch {chan close $fd}
#        
#        foreach line $updateFile {
#                if {$line == ""} {continue}
#                set l_line [split $line " "]
#                set [lindex $l_line 0] [join [lrange $l_line 1 end] " "]
#                #${log}::notice "line: $line"
#        }
#    }
	
}

# Load required files / packages
'eAssist_sourceReqdFiles


# Load the config file
'eAssist_loadSettings



# Load the Option Database options
#'distHelper_loadOptions
vUpdate::saveCurrentVersion

# Start the GUI
eAssist::parentGUI