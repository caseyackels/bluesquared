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

    # Make the markup tags
    $changeLog_Text tag config Heading1 -font {verdana 12 bold}
    $changeLog_Text tag config Heading2 -font {verdana 10 bold}
    $changeLog_Text tag config Normal -font {arial 10}
    $changeLog_Text tag config List1 -font {verdana 9} -lmargin1 8 -lmargin2 12
    $changeLog_Text tag config List2 -font {verdana 9} -lmargin1 8 -lmargin2 12

    ttk::separator $changeLog_Text.sep -orient horizontal
    #pack $changeLog_Text.sep

    set i 0
    set idx 0
    while { [gets $openChangeLog line] >= 0 } {
        # Keep track of how many lines we insert
        incr idx
        #'debug StringRange: [string range $line 0 1]
        # Capture our 'markup' and format the text
        # = Heading
        # + 2nd Heading
        # * Non-numbered list
        # # Numbered list

        set stringFormat [string range $line 2 end]
        # \u25C6 ;# Diamond
        # \u00B7 ;# Small
        # \U2022 ;# unicode

        switch -- [string range $line 0 1] {
            "= "    {set textFormat Heading1; set i 0 ;# Heading1}
            "+ "    {set textFormat Heading2; set i 0 ;# Heading2}
            "* "    {set stringFormat "\u2022 $stringFormat"; set textFormat List1; set i 0 ;# List1}
            "# "    {set stringFormat "[incr i]: $stringFormat"; set textFormat List2;# List2}
            "--"    {set stringFormat [$changeLog_Text window create $idx.end -window $changeLog_Text.sep -stretch yes]}
            default {set stringFormat $line; set textFormat Normal; set i 0;# No markup detected}
        }

        $changeLog_Text insert end $stringFormat $textFormat
        $changeLog_Text insert end \n
    }

    # Since we inserted our text, lets disable the widget to prevent the deletion of text (not that it matters, but adds a bit of professionalism)
    $changeLog_Text configure -state disabled

    chan close $openChangeLog

    #
    # Licenses
    #
}