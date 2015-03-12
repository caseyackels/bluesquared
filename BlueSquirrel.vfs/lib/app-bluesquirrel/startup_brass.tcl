# Name: Blue Squirrel
# Creator: Casey Ackels
# Initial Date: October 28th, 2006]
# Massive Rewrite: May 3rd, 2008
# Last Updated: February 16th, 2007
# Version: 0.3.3
# Dependencies: shipping_gui.tcl
# 		shipping_code.tcl
# 		shipping_window2_gui.tcl
# 		Libraries/autoscroll.tcl

##
## - Overview
# This file holds the launch code for List Display (Shipping).

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

## Coding Conventions
# - Namespaces: These should have two parts, a _gui and a _code. Both words should be capitalized. i.e. Example_Code

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


##
## Source Files
##

# We use the prefix 'shipping_ because we are in the global namespace now, and we don't want to pollute it.


proc 'brass_sourceFiles {} {
    console show

set appdir [file dirname [info script]]

    catch {
	## All files that need to be sourced should go here. That way if any of them fail to load, we'll catch it.
	
	#Modify the Auto_path so our 'package requires' work.
	## Only use this if we are FreeWrapped
	lappend ::auto_path [file join [file dirname [info script]]]
	lappend ::auto_path [file join [file dirname [info script]] Libraries]
	lappend ::auto_path [file join [file dirname [info script]] Libraries csv]
	
	#Modify the Auto_path so our 'package requires' work.
	## Only use this if we are NOT FreeWrapped.
	#lappend ::auto_path [file join [pwd] Backend_Code]
	#lappend ::auto_path [file join [pwd] Gui]
	#lappend ::auto_path [file join [pwd] Libraries]
	#lappend ::auto_path [file join [pwd] Libraries autoscroll]
	#lappend ::auto_path [file join [pwd] Libraries tile0.7.8]
	
	# Start the Package Require
	#package require autoscroll
	package require csv

	
	
	## Source the Gui files
	source [file join [file dirname [info script]] Modules Brass core_gui.tcl]
	
	## Source the Backend_Code files
	source [file join [file dirname [info script]] Modules Brass core_code.tcl]
	source [file join [file dirname [info script]] Modules Brass StreetSuffixState.tcl]
	
	source [file join [file dirname [info script]] Libraries brass_libraries.tcl]
	source [file join [file dirname [info script]] Libraries errorMsg_gui.tcl]

	} S_errMsg
	
	if {([info exists S_errMsg]) && ($S_errMsg != "")} {
	    tk_messageBox \
                -parent . \
                -default ok \
                -icon warning \
                -title "Couldn't find File" \
                -message "I'm sorry, but I need a file to start. Can you please locate it, and put it here:\n[pwd]\n\n$S_errMsg"
	    
	    unset S_errMsg
	    exit ;# Don't even open the GUI. Exit right away.
    }
}


proc 'brass_loadOptions {} {
    #option add *font {tahoma 10}
    option add *Listbox.font {tahoma 12}
    
    # Theme setting for Tile
    ttk::style theme use $ttk::currentTheme
    #style theme use clam
}

# Load all files / packages
'brass_sourceFiles

# Load the Option Database options
'brass_loadOptions

# Finally start the GUI
Brass_Gui::brassGUI

# Initialize StreetSuffixState
loadSuffix
