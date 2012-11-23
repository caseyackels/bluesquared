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

	set profileList [glob -nocomplain -directory $program(Profiles) *]
	set purchasedList [glob -nocomplain -directory $program(PCL) *]
	

	set gate_profile 0 ;# Keep control on if we have already inserted the information
	switch -- [lindex $args 0] {
		-listbox {
			'debug $profileList
			foreach profile $profileList {
				eval [[lindex $args 1] insert end [file tail [file rootname $profile]]]
			}
		}
		-comboProfile {
			# Get files, if none exist launch the Add Window
			if {$profileList == ""} {nextgenrm_GUI::addListWindow profile .profile; return}
			# Clear variables before adding to it
			set program(profileList) ""
			set profile_list ""
			foreach profile_list $profileList {
				lappend program(profileList) [file tail [file rootname $profile_list]]
			}
			
			'debug profileList_B: $program(profileList)
			# List the available profile's that exist already, and enable the rename, and delete buttons.
			[lindex $args 1] configure -values $program(profileList)
			
			if {$profile_list != ""} {
				# Guard against the list being blank, and enabling editing commands unncessarily.
				[lindex $args 2] configure -state normal
				[lindex $args 3] configure -state normal
			}
		}
		-comboPCL {
			# Get files, if none exist launch the Add Window
			if {$purchasedList == ""} {nextgenrm_GUI::addListWindow pcl .pclwindow; return}
			# Clear variable before adding to it
			set program(purchasedList) ""
			set purchased_list ""
			foreach purchased_list $purchasedList {
				lappend program(purchasedList) [file tail [file rootname $purchased_list]]
			}
			[lindex $args 1] configure -values $program(purchasedList)
			
			if {$purchased_list != ""} {
				# Guard against the list being blank, and enabling editing commands unncessarily.
				[lindex $args 2] configure -state normal
				[lindex $args 3] configure -state normal
			}
		}
		-comboProfileClone {
			# Clear variables before adding to it
			set program(profileList) ""
			set profile_list ""
			foreach profile_list $profileList {
				lappend program(profileList) [file tail [file rootname $profile_list]]
			}
			puts "-comboClone (list of profiles): $program(profileList)"
			puts "args: $args"
			[lindex $args 1] configure -values $program(profileList)
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
	#	Control the state of the combobox. If the checkbutton "Clone" is checked we enable the combobox.
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
	global program
	
	set entryWidgetText [$entryWidget get]
	#'debug cstate: $entryWidgetText

	# If no text in the entry field, exit.
	if {$entryWidgetText eq ""} {set state disabled; set combo_state disabled; return}
	
	# If the checkbutton isn't turned on, disable widgets
	if {$clone eq "0"} {
		if {$entryWidgetText ne ""} {
			#'debug 1a: Entry Widget returned: $entryWidgetText
			set state disabled
			set combo_state disabled
			set program(fileGateway) fileCreate
		} else {
			#'debug 2a: Entry Widget returned: $entryWidgetText
			set state normal
			set combo_state readonly
			set program(fileGatway) fileRename
		}
	} else {
		if {$entryWidgetText eq ""} {
			#'debug 1b: Entry Widget returned: $entryWidgetText
			set state disabled
			set combo_state disabled
			set program(fileGateway) fileCreate
		} else {
			#'debug 2b: Entry Widget returned: $entryWidgetText
			set state normal
			set combo_state readonly
			set program(fileGateway) fileCreate
		}
	}
	
	#'debug State: $state

	# Enable combobox because we want to clone an existing list
	$comboWidget configure -state $combo_state
	
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
		# TODO: if there is no other purchased list or profile the checkbutton should NOT even be allowed to be checked.
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
			set profile(table) [.profile.container.nb.f1.frame1.listbox.listbox get 0 end]
			set profile(table) [lrange $profile(table) 0 end-1] ;# Get rid of the empty list generated by an empty line in the listbox
			set myFile [open [file join $program(Profiles) [lindex $args 1].txt] w]
		}
		pcl		{
			set type purchased ;# Array name
			set myFile [open [file join $program(PCL) [lindex $args 1].txt] w]
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
	
	'debug Table Contents: [.profile.container.nb.f1.frame1.listbox.listbox get 0 end]

} ;# nextgenrm_Code::save


proc nextgenrm_Code::saveAs {args} {
	#****f* saveAs/nextgenrm_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2012 - Casey Ackels
    #
    # FUNCTION
    #	This RENAMES the file.
    #
    # SYNOPSIS
    #	Save the data from Profile or a PurchasedList as a new file
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
	puts "args: $args"
	set txtWidget [lindex $args 3]
	
	switch -- [lindex $args 0] {
		profile {
			#puts "From [lindex $args 1].txt"
			#puts "To [[lindex $args 2] get].txt"
			file copy -- [file join $program(Profiles) [lindex $args 1].txt] [file join $program(Profiles) [[lindex $args 2] get].txt]
			
			#Clear combobox widget
			$txtWidget set [[lindex $args 2] get]
			
			# Delete old file.
			#puts "Deleting [lindex $args 1].txt"
			file delete -- [file join $program(Profiles) [lindex $args 1].txt]
		}
		pcl		{
			#puts "From [lindex $args 1].txt"
			#puts "To [[lindex $args 2] get].txt"
			file copy -- [file join $program(PCL) [lindex $args 1].txt] [file join $program(PCL) [[lindex $args 2] get].txt]
			
			#Clear combobox widget
			$txtWidget set [[lindex $args 2] get]
			
			# Delete old file.
			#puts "Deleting [lindex $args 1].txt"
			file delete -- [file join $program(PCL) [lindex $args 1].txt]
		}
		default	{
			return -code error
			puts "error in saveAs proc"
		}
	}
	
	
} ;# nextgenrm_Code::saveAs

proc nextgenrm_Code::openFile {args} {
	#****f* open/nextgenrm_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2012 - Casey Ackels
    #
    # FUNCTION
    #	args = profile name
    #
    # SYNOPSIS
    #	Open the profile or purchased list for editing
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
	
	# Clear out all the profile variables
	set profStore_tmp $profile(Store) ;# Remember current store name before clearing everything out.
	array unset profile
	set profile(Store) $profStore_tmp
	
	
	
	set fileName [file join $program(Profiles) $args.txt]
	set myFile [open $fileName r]
	
	set readProfile [split [chan read $myFile] \n]
	chan close $myFile
	
	'debug readProfile: $readProfile
			
	foreach line $readProfile {
		if {$line eq ""} {continue}
	
		set l_line [split $line " "]
		set [lindex $l_line 0] [join [lrange $l_line 1 end] " "]
		'debug variable: $[lindex $l_line 0]
	}
	'debug array: [array names profile]
	
	
} ;# End nextgenrm_Code::openFile


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
	#	usage: create -rename profile|pcl newFileName oldFileName
	#	usage: create -create profile|pcl newFileName
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
	
	#puts "Started to Create: $args"
	#return
	
    # Open the file (Could be Profiles/Purchased list)
	set type [lindex $args 0]
	set fileType [lindex $args 1]
	set newFileName [lindex $args 2]
	set oldFileName [lindex $args 3]
	
	# Setup path to contain the correct file path
	switch -- $fileType {
		profile {
			set path $program(Profiles)
			set fileList profileList
		}
		pcl 	{
			set path $program(PCL)
			set fileList purchasedList
		}
		default {
			return -code error
			puts "error #1 in create proc"
		}
	}

	switch -- $type {
		fileRename	{
			#file copy -- [file join $program(Profiles) [lindex $args 1].txt] [file join $program(Profiles) [[lindex $args 2] get].txt]
			file copy -- [file join $path $oldFileName.txt] [file join $path $newFileName.txt]
			puts "Args: $args"
			puts "CLONED: [file join $path $oldFileName.txt] [file join $path $newFileName.txt]"
			puts "File Cloned: $oldFileName/$newFileName"
		}
		fileCreate	{
			set new [open [file join $path $newFileName].txt w+]
			puts $new "" ;# Insert a blank line in the file
			chan flush $new
			chan close $new
			}
		default	{
			return -code error
			puts "error #2 in create proc"
		}
	}
	
	# Update the combobox that holds the profile names
	set file_list [glob -nocomplain -directory $path *]
	foreach myFile $file_list {
				# See above for linking information on the $fileList variable
				lappend program($fileList) [file tail [file rootname $myFile]]
	}
	

} ;# nextgenrm_Code::create
