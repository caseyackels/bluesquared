# Creator: Casey Ackels
# Initial Date: July 8th, 2011
# Dependencies: about_gui.tcl, pkgIndex.tcl
# Notes: This is a complete package to build your own About Window
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
# This file holds the code for the About window package

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

## Coding Conventions
# - Namespaces:

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

proc BlueSquared_About::aboutOpenFiles {about_Text changeLog_Text} {
    #****f* aboutOpenFiles/BlueSquared_About
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
    #	Open the text files: ABOUT, CHANGES, and the LICENSES files that we find
    #
    # CHILDREN
    #
    #
    # PARENTS
    #
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***

    # About Window
    set fileAbout [file join $starkit::topdir lib app-distributionhelper about.txt]
    set openFileAbout [open $fileAbout RDONLY]


    while { [gets $openFileAbout line] >= 0 } {
        $about_Text insert end $line\n
    }

    # Since we inserted our text, lets disable the widget to prevent the deletion of text (not that it matters, but adds a bit of professionalism)
    $about_Text configure -state disabled

    chan close $openFileAbout

    #
    # Change Log
    #
    set fileChangeLog [file join $starkit::topdir lib app-distributionhelper CHANGELOG.txt]
    set openChangeLog [open $fileChangeLog RDONLY]


    while { [gets $openChangeLog line] >= 0 } {
        $changeLog_Text insert end $line\n
    }

    # Since we inserted our text, lets disable the widget to prevent the deletion of text (not that it matters, but adds a bit of professionalism)
    $changeLog_Text configure -state disabled

    chan close $openChangeLog

    #
    # Licenses
    #
}