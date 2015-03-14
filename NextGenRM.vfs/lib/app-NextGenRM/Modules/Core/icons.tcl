# Creator: Casey Ackels
# Initial Date: January 1, 2012]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 241 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2012-03-01 21:26:50 -0800 (Thu, 01 Mar 2012) $
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
	set program(themeName) led
	#set program(theme,add) 
	set iconDir16x16 [file join $starkit::topdir lib app-NextGenRM Themes $program(themeName) icons16x16]
	#set iconDir24x24 [file join $starkit::topdir lib app-NextGenRM Themes $program(themeName) icons24x24]
	
	## 16x16 Images
	# Add
	#image create photo add16x16 -file [file join $iconDir16x16 Plus.gif]
	image create photo add16x16 -file [file join $iconDir16x16 page.png]
	
	# Delete
	#image create photo del16x16 -file [file join $iconDir16x16 Cancel.gif]
	image create photo del16x16 -file [file join $iconDir16x16 page_white_delete.png]
	
	# Rename
	#image create photo rename16x16 -file [file join $iconDir16x16 Write2.gif]
	image create photo rename16x16 -file [file join $iconDir16x16 page_white_edit.png]

	
	## 24x24 Images
	# Delete
	#image create photo add24x24 -file [file join $iconDir24x24 Plus.gif]
	# Delete
	#image create photo del24x24 -file [file join $iconDir24x24 Cancel.gif]
	# New
	#image create photo new24x24 -file [file join $iconDir24x24 "Document New.gif"]
	# Rename
	#image create photo rename24x24 -file [file join $iconDir24x24 Write2.gif]
	
} ;# nextgenrm_Icons::InitializeIcons
