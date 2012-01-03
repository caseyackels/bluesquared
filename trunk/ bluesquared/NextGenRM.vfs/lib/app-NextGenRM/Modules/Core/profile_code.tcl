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
    global profile program
	
    # Open the file (Could be Profiles/Purchased list)

	switch -- [lindex $args 0] {
		profile {
			set type profile ;# Array name
			set myFile [open [file join $program(Profile) [lindex $args 1].txt] w]
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
