# Creator: Casey Ackels
# Initial Date: March 12, 2011]
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

namespace eval Disthelper_Helper {}


proc Disthelper_Helper::resetVars {args} { 
    #****f* resetVars/Disthelper_Helper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Reset variables and the lisbox, just before bringing in another file.
    #	-resetGUI (Reset the variables controlling the data in the GUI)
    #
    # SYNOPSIS
    #	N/A
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
    global GL_file GS_address GS_job GS_ship
    
    switch -- $args {
	-resetGUI {
		    # Clear out all the variables (We need this so we don't have to keep exiting the app to make more import files
		    foreach name [array names GL_file] {
			set GL_file($name) ""
		    }
		    foreach name [array names GS_address] {
			set GS_address($name) ""
		    }
		    foreach name [array names GS_job] {
			set GS_job($name) ""
		    }
		    foreach name [array names GS_ship] {
			set GS_ship($name) ""
		    }
	    
		    # Clear out the listbox
		    .container.frame1.listbox delete 0 end

	}
    }
} ;# Disthelper_Helper::resetVars


proc Disthelper_Helper::getOpenFile {} {
    #****f* getOpenFile/Disthelper_Helper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Allows the user to find the target file, we save it into a variable and pass it along
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	Disthelper_Code::readFile, Disthelper_Helper::resetVars
    #
    # PARENTS
    #	disthelper::parentGUI
    #
    # NOTES
    #
    # SEE ALSO
    #	
    #
    #***
    global settings
    
    set filetypes {
        {{CSV Files}    {.csv}      }
    }
    
    set filename [tk_getOpenFile \
        -parent . \
        -title [mc "Choose a File"] \
	-initialdir $settings(sourceFiles) \
        -defaultextension .csv \
        -filetypes $filetypes
    ]
    
    puts "fileName: $filename"
    
    # If we do not select a file name, and cancel out of the dialog, do not produce an error.
    if {$filename eq ""} {return}
    
    # Reset the variables before importing another file
    Disthelper_Helper::resetVars -resetGUI

    # read the file in, and populate the listbox
    Disthelper_Code::readFile $filename

} ;# Disthelper_Helper::getOpenFile


proc Disthelper_Helper::getAutoOpenFile { jobNumber } { 
    #****f* getAutoOpenFile/Disthelper_Helper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Search directory for a file containing the number that the user supplies
    #	They will supply the number to a job. That job is always in the filename.
    #
    # SYNOPSIS
    #	N/A
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
    global settings GS_job
    
    # Error control. Exit gracefully if the user clicks the Import Button without a job number.
    if {$jobNumber == ""} {Disthelper_Helper::getOpenFile; return}
    
    # Strip off the (#) number if it exists
    set jobNumber [string trimleft $jobNumber #]
	
    # Get the list of files in the directory
    set data [glob -tails -directory $settings(sourceFiles) *csv]
    
    # use join, to make it a string, if we don't for some reason it doesn't work as intended.
    foreach list $data {
	'debug "getAUtoOpen: $data"
	'debug "lsearch: [lsearch -glob [join $list] #$jobNumber]"
	if {[lsearch -glob [join $list] #$jobNumber] != -1} {
	    lappend OpenFile $list
	}
    }

    if {![info exists OpenFile]} { 
	set reply [tk_dialog .warning "Can't Find Job Number" "I can't seem to locate that job number, please try again." warning 0 Ok]
	Disthelper_Helper::resetVars -resetGUI
	return
    }

    
    # Reset the variables before importing another file
    Disthelper_Helper::resetVars -resetGUI
    
    if {[llength $OpenFile] >= 2} {
	# We have multiple files, lets open a window and let the user select which one that they want
	Disthelper_Helper::displayLists $OpenFile $jobNumber

    } else {
	# We only have one file, so lets import it.
	Disthelper_Code::readFile [file join $settings(sourceFiles) [join $OpenFile]]
    }
    
} ;# Disthelper_Helper::getAutoOpenFile


proc Disthelper_Helper::displayLists { OpenFile jobNumber } { 
    #****f* displayLists/Disthelper_Helper
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
    #	There are multiple files that matched the same job number, so lets open a window with a listbox and have the user select which one they really want
    #
    # CHILDREN
    #	Disthelper_Helper::resetVars
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

    
    toplevel .displayList
    wm transient .displayList .
    
    set locX [expr {([winfo screenwidth .] - [winfo width .]) / 2}]
    set locY [expr {([winfo screenheight .] - [winfo height .]) / 2}]
    wm geometry .displayList +${locX}+${locY}
    
    focus -force .displayList
    
    set frame0 [ttk::frame .displayList.frame0]
    ttk::label $frame0.label -text [mc "There are multiple matches to your Job Number.\n\nPlease select the appropriate file that you want to use."]
    
    grid $frame0.label -column 0 -row 0 -sticky news -padx 5p -pady 5p
    pack $frame0 -expand yes -fill both
    
    set frame1 [ttk::frame .displayList.frame1]
    listbox $frame1.listbox \
                -width 60 \
		-height 5 \
                -selectbackground yellow \
                -selectforeground black \
                -exportselection yes \
                -selectmode browse
    

    grid $frame1.listbox -column 0 -row 0 -sticky news -padx 5p -pady 5p
    pack $frame1 -expand yes -fill both
    
    
    foreach file $OpenFile {
	$frame1.listbox insert end $file
    }
    
    set frame2 [ttk::frame .displayList.frame2]
    ttk::button $frame2.btn1 -text [mc "Import"] -command {Disthelper_Code::readFile [file join $settings(sourceFiles) [.displayList.frame1.listbox get [.displayList.frame1.listbox curselection]]]; destroy .displayList}
    ttk::button $frame2.btn2 -text [mc "Cancel"] -command {destroy .displayList}
    
    grid $frame2.btn1 -column 0 -row 0 -sticky nse -padx 8p
    grid $frame2.btn2 -column 1 -row 0 -sticky e

    pack $frame2 -side bottom -anchor e -pady 10p -padx 5p
    
    
} ;# Disthelper_Helper::displayLists


proc Disthelper_Helper::getChildren {} { 
    #****f* getChildren/Disthelper_Helper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Get the children of the frame to configure the widgets
    #
    # SYNOPSIS
    #	N/A
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
    
    # Get the children widgets, so that we can enable/disable them.
    # *2c/*2b is the last part of the widget name
    foreach child [winfo children .container.frame2] {
        'debug (child) $child
        if {[lsearch -glob $child *2b] != -1} {
            # Now get the child widgets (notably the Entry widget)
            foreach child2 [winfo children $child] {
                if {[lsearch -glob $child2 *Entry] != -1} {
                    #'debug (child2b) [lrange $child2 [lsearch -glob $child2 *Entry] [lsearch -glob $child2 *Entry]]
		    #'debug (child2b) "set state to normal [lrange $child2 [lsearch -glob $child2 *Entry] [lsearch -glob $child2 *Entry]]"
		    [lrange $child2 [lsearch -glob $child2 *Entry] [lsearch -glob $child2 *Entry]] configure -state normal
                }
            }
        }
    
        if {[lsearch -glob $child *2c] != -1} {
            # Now get the child widgets (notably the Entry widget)
            foreach child2 [winfo children $child] {
                if {[lsearch -glob $child2 *Entry] != -1} {
                    #'debug (child2c) [lrange $child2 [lsearch -glob $child2 *Entry] [lsearch -glob $child2 *Entry]]
		    #'debug (child2c) "set state to normal [lrange $child2 [lsearch -glob $child2 *Entry] [lsearch -glob $child2 *Entry]]"
		    [lrange $child2 [lsearch -glob $child2 *Entry] [lsearch -glob $child2 *Entry]] configure -state normal
                }
            }
        }
    }

} ;# Disthelper_Helper::getChildren


proc Disthelper_Helper::detectData {args} { 
    #****f* detectData/Disthelper_Helper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Detect if there is enough data in the entry field, to change the label text from Red to Black.
    #
    # SYNOPSIS
    #	Two widget paths make up the arguments. The first path is for the [Label Widget] the second is for the [Entry Widget]
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
    global tempVars
    
    #'debug "Data: [[lindex $args 0] get]"
    #'debug "arg1: [lindex $args 0]"
    #'debug "arg2: [lindex $args 1]"
    'debug "StringLength: [string length [[lindex $args 0] get]]"
    'debug "String: [[lindex $args 0] get]"
    #'debug "Widget: [lindex $args 1]"

    switch -- [lindex $args 2] {
	shipVia {
		    if {[string length [[lindex $args 0] get]] >= 3} {[lindex $args 1] configure -foreground black
			set tempVars(shipVia) 1
			} else {
			    set tempVars(shipVia) 0
			    [lindex $args 1] configure -foreground red
			    .btnBar.print configure -state disabled
			    return
		    }
	}
	pieceWeight {
		    if {[string length [[lindex $args 0] get]] >= 3} {[lindex $args 1] configure -foreground black
			set tempVars(pieceWeightTmp) 1
			} else {
			    set tempVars(pieceWeightTmp) 0
			    [lindex $args 1] configure -foreground red
			    .btnBar.print configure -state disabled
			    return
		    }
	}
	fullBox	{
		if {[string length [[lindex $args 0] get]] >= 1} {[lindex $args 1] configure -foreground black
		    set tempVars(fullBoxTmp) 1
			} else {
			    set tempVars(fullBoxTmp) 0
			    [lindex $args 1] configure -foreground red
			    .btnBar.print configure -state disabled
			    return
		}
	}
    }
	# Only enable the Generate File button if the required fields are populated.
	'debug "shipVia: [info exists tempVars(shipVia)]"
	'debug "pieceWeightTmp: [info exists tempVars(pieceWeightTmp)]"
	'debug "fullBoxTmp: [info exists tempVars(fullBoxTmp)]"
	
	#if {![info exists tempVars(shipVia)]} {return}
	if {![info exists tempVars(pieceWeightTmp)]} {return}
	if {![info exists tempVars(fullBoxTmp)]} {return}
	if {($tempVars(pieceWeightTmp) == 1) && ($tempVars(fullBoxTmp) == 1)} {.btnBar.print configure -state enabled}
} ;# Disthelper_Helper::detectData
