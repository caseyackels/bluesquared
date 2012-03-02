# Creator: Casey Ackels
# Initial Date: December 29, 2011]
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
# This file holds generic helper procedures


## Coding Conventions
# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


proc nextgenrm_Code::showProfiles {args} {
	#****f* showProfiles/nextgenrm_Code
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
    global program profile
	'debug widget: $args
	
	# use the catch because it will return an error if no files are found. It is ok to use [catch], because on first startup, there won't be any files.
	set profileList [glob -directory $program(Profiles) *]
	'debug profileList_A: $profileList
	set purchasedList [catch {[glob -directory $program(PCL) *]} pclError]
	'debug purchasedList_A: $purchasedList
	
	switch -- [lindex $args 0] {
		-listbox {
			'debug $profileList
			foreach profile $profileList {
				eval [[lindex $args 1] insert end [file tail [file rootname $profile]]]
			}
		}
		-comboProfile {
			# Clear variable before adding to it
			set program(profileList) ""
			foreach profile $profileList {
				lappend program(profileList) [file tail [file rootname $profile]]
			}
			'debug profileList_B: $program(profileList)
			[lindex $args 1] configure -values $program(profileList)
			[lindex $args 2] configure -state normal
			[lindex $args 3] configure -state normal
			'debug profile $profile(Store)
		}
		-comboPCL {
			# Clear variable before adding to it
			set program(purchasedList) ""
			foreach pcl $purchasedList {
				lappend program(purchasedList) [file tail [file rootname $pcl]]
			}
			'debug purchasedList_B: $program(purchasedList)
			[lindex $args 1] configure -values $program(purchasedList)			
		}
		default {}
	}

} ;# nextgenrm_Code::showProfiles


proc nextgenrm_Code::controlComboState {entryWidget comboWidget buttonWidget checkWidget clone} {
	#****f* controlComboState/nextgenrm_Code
	# AUTHOR
	#	Casey Ackels
	#
	# COPYRIGHT
	#	(c) 2012 - Casey Ackels
	#
	# FUNCTION
	#	paths to the various widgets
	#
	# SYNOPSIS
	#	entryWidget comboWidget buttonWidget clone (on|off)
	#
	# CHILDREN
	#	N/A
	#
	# PARENTS
	#	
	#
	# NOTES
	#	Helper for the Add Profile/Add Purchased List window's - Control's GUI elements of disabling/enabling controls
	#
	# SEE ALSO
	#
	#***
	
	set entryWidgetText [$entryWidget get]
	'debug cstate: $entryWidgetText

	# If no text in the entry field, exit.
	if {$entryWidgetText eq ""} {set state disabled; return}
	
	# If the checkbutton isn't turned on, disable widgets
	if {$clone eq "0"} {
		if {$entryWidgetText ne ""} {
			'debug 1a: Entry Widget returned: $entryWidgetText
			set state disabled	
		} else {
			'debug 2a: Entry Widget returned: $entryWidgetText
			set state normal
		}
	} else {
		if {$entryWidgetText eq ""} {
			'debug 1b: Entry Widget returned: $entryWidgetText
			set state disabled	
		} else {
			'debug 2b: Entry Widget returned: $entryWidgetText
			set state normal
		}
	}
	
	'debug State: $state

	# Enable combobox because we want to clone an existing list
	$comboWidget configure -state $state
	
	# Allow the user to press Ok
	$buttonWidget configure -state $state
	
} ;# nextgenrm_Code::controlComboState


proc nextgenrm_Code::controlCheck {txtString checkWidget comboWidget buttonWidget} {
	#****f* controlCheck/nextgenrm_Code
	# AUTHOR
	#	Casey Ackels
	#
	# COPYRIGHT
	#	(c) 2012 - Casey Ackels
	#
	# FUNCTION
	#	Control the checkbutton widget, by telling it if the entry widget has any data or not. Enable/disable the [Ok] button also.
	#
	# SYNOPSIS
	#	txtString checkWidget comboWidget buttonWidget
	#
	# CHILDREN
	#	N/A
	#
	# PARENTS
	#	
	#
	# NOTES
	#	Helper for the Add Profile/Add Purchased List window's - Control's GUI elements of disabling/enabling controls
	#
	# SEE ALSO
	#
	#***
	global clone
	# set return value to failing
	set returnValue 0
	
	'debug txtString Prevalidation: $txtString
	
	# enable the checkbutton if there is anything but ""
	if {$txtString ne ""} {
		'debug $txtString != ""
		set returnValue 1
		$checkWidget configure -state normal
		$buttonWidget configure -state normal

	} else {
		'debug $txtString == ""
		set returnValue 1
		set clone 0 ;# Turn the checkbutton off
		$checkWidget configure -state disabled
		$comboWidget configure -state disabled
		$buttonWidget configure -state disabled
	}
	
	

	return $returnValue
} ;# nextgenrm_Code::controlWidgetState

proc nextgenrm_Code::save {args} {
	#****f* save/nextgenrm_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	arg1 = profile|purchased; arg2 = file name
    #
    # SYNOPSIS
    #	Save the data from Profile or PurchasedList depending on what proc calls this.
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
    global profile program
	
    # Open the file (Could be Profiles/Purchased list)
	'debug $args

	switch -- [lindex $args 0] {
		profile {
			set type profile ;# Array name
			set myFile [open [file join $program(Profiles) [lindex $args 1].txt] w]
		}
		pcl		{
			set type purchased ;# Array name
			set myFile [open [file join $program(Purchased) [lindex $args 1].txt] w]
		}
		default	{
			return -code error
		}
	}

    # Write out profile array
    foreach value [array names $type] {
            chan puts $myFile "profile($value) $profile($value)"
    }
	chan flush $myFile
	chan close $myFile

} ;# nextgenrm_Code::save


proc nextgenrm_Code::create {args} {
	#****f* create/nextgenrm_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2012 - Casey Ackels
    #
    # FUNCTION
    #	create [-rename|-create] [profile|pcl] ?name?
    #
    # SYNOPSIS
    #	Create will: Rename an existing profile/purchased list, Initiate a new profile/purchased list.
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
    global profile program
	
    # Open the file (Could be Profiles/Purchased list)
	'debug $args
	set type [lindex $args 0]
	set fileType [lindex $args 1]
	set fileName $program(newName)
	
	# Setup path to contain the correct file path
	switch -- $fileType {
		profile {
			set path $program(Profiles)
		}
		pcl 	{
			set path $program(PCL)
		}
		default {
			return -code error
		}
	}

	switch -- $type {
		-rename	{
			
		}
		-create	{
			set new [open [file join $path $fileName].txt w+]
			chan flush $new
			chan close $new
			}
		default	{
			return -code error
		}
	}

} ;# nextgenrm_Code::create
