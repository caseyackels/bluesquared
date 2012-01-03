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
    global program
	'debug widget: $args
	
	# use the catch because it will return an error if no files are found. It is ok to use [catch], because on first startup, there won't be any files.
	set profileList [glob -directory $program(Profiles) *]
	set purchasedList [catch {[glob -directory $program(PCL) *]} pclError]
	
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
			'debug profileList: $program(profileList)
			[lindex $args 1] configure -values $program(profileList)
		}
		-comboPCL {
			# Clear variable before adding to it
			set program(purchasedList) ""
			foreach pcl $purchasedList {
				lappend program(purchasedList) [file tail [file rootname $pcl]]
			}
			'debug profileList: $program(purchasedeList)
			[lindex $args 1] configure -values $program(purchasedList)
		}
		default {}
	}

} ;# nextgenrm_Code::showProfiles


proc nextgenrm_Code::controlWidgetState {} {
	#****f* controlWidgetState/nextgenrm_Code
	# AUTHOR
	#	Casey Ackels
	#
	# COPYRIGHT
	#	(c) 2012 - Casey Ackels
	#
	# FUNCTION
	#	Helper for the Add Profile/Add Purchased List window's - Control's GUI elements of disabling/enabling controls
	#
	# SYNOPSIS
	#	-type [pcl|profile] -path [root path to widgets] 
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
	
	# Disable combobox because we are creating a blank list
	.addPCL.frame1.pclCombo configure -state disabled
	
	# Enable combobox because we want to clone an existing list
	.addPCL.frame1.pclCombo configure -state normal
	
	# Check that we have something in the entry widget, if we do, enable the button.
	.addPCL.button.ok configure -state normal
	
	
} ;# nextgenrm_Code::controlWidgetState

