# Creator: Casey Ackels
# Initial Date: January 1, 2012]
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
# This file holds procedures for creating icons


namespace eval nextgenrm_Icons {}

proc nextgenrm_Icons::InitializeIcons {args} {
	#****f* InitilizeIcons/nextgenrm_Icons
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
    #	Initialize icons
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
	
	#set iconList [glob -directory [file join $starkit::topdir lib app-NextGenRM icons] *]
	set iconDir16x16 [file join $starkit::topdir lib app-NextGenRM Themes lightgrey icons16x16]
	set iconDir24x24 [file join $starkit::topdir lib app-NextGenRM Themes lightgrey icons24x24]
	
	## 16x16 Images
	# Add
	image create photo add16x16 -file [file join $iconDir16x16 Plus.gif]
	# Delete
	image create photo del16x16 -file [file join $iconDir16x16 Cancel.gif]
	# New
	image create photo new16x16 -file [file join $iconDir16x16 "Document New.gif"]
	# Rename
	image create photo rename16x16 -file [file join $iconDir16x16 Write2.gif]

	
	## 24x24 Images
	# Delete
	image create photo add24x24 -file [file join $iconDir24x24 Plus.gif]
	# Delete
	image create photo del24x24 -file [file join $iconDir24x24 Cancel.gif]
	# New
	image create photo new24x24 -file [file join $iconDir24x24 "Document New.gif"]
	# Rename
	image create photo rename24x24 -file [file join $iconDir24x24 Write2.gif]
	
} ;# nextgenrm_Icons::InitializeIcons
