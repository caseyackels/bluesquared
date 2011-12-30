# Creator: Casey Ackels
# Initial Date: December 29, 2011]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 50 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2011-03-13 17:09:18 -0700 (Sun, 13 Mar 2011) $
#
########################################################################################

##
## - Overview
# This file holds generic helper procedures

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

## Coding Conventions
# - Namespaces: 

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
	
	set profileList [glob -directory [file join $program(Path) Profiles] *]
	
	switch -- [lindex $args 0] {
		-listbox {
			foreach profile $profileList {
				eval [[lindex $args 1] insert end [file tail [file rootname $profile]]]
			}
		}
		-combobox {
			foreach profile $profileList {
				lappend program(profileList) [file tail [file rootname $profile]]
			}
			'debug profileList: $program(profileList)
			[lindex $args 1] configure -values $program(profileList)
		}
		default {}
	}

}
