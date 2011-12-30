# Creator: Casey Ackels
# Initial Date: March 12, 2011]
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


proc nextgenrm_Code::save {} {
	#****f* save/nextgenrm_Code
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
    global profile program
	
    # Open the file

	set Profile [open [file join $program(Path) Profiles $profile(Store).txt] w]
	
	#chan configure $Profile -buffering line

    # Write out profile array
    foreach value [array names profile] {
            chan puts $Profile "profile($value) $profile($value)"
    }
	chan flush $Profile
	chan close $Profile

	
#	set Settings [open $program(Settings) w]
#    # Write out program array
#    foreach value [array names program] {
#            puts $Settings "program($value) $program($value)"
#    }
#
#    chan close $Settings
}
