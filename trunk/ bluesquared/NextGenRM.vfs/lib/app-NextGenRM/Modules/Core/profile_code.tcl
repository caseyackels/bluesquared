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


proc nextgenrm_Code::displayProfileSettings {comboPath} {
		#****f* displayProfileSettings/nextgenrm_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2012 - Casey Ackels
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
	global profile
	set oldValue ""
	

	set currentValue [$comboPath current]
	
	if {[string match $currentValue $oldValue] eq 0} {
		.profile.container.nb.f1.frame1.listbox.listbox delete 0 end
	
		if {[info exists profile($profile(Store),table)]} {
			if {[string match $profile($profile(Store),table) [.profile.container.nb.f1.frame1.listbox.listbox get 0 end]] eq 0} {
				foreach storeOptions $profile($profile(Store),table) {
					.profile.container.nb.f1.frame1.listbox.listbox insert end $storeOptions
				}
			}
		} else {
			.profile.container.nb.f1.frame1.listbox.listbox delete 0 end
			.profile.container.nb.f1.frame1.listbox.listbox insert end ""
		}
	} else {
		'debug "Items match, not reinserting"
	}
	
	
	set oldValue $currentValue
}
