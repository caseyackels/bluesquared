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
    global log

    # Open the files
    set fileAbout [file join $starkit::topdir about.txt]
    set fileChangeLog [file join $starkit::topdir CHANGELOG.txt]
    
    
    set openFileAbout [open $fileAbout RDONLY]
    set openChangeLog [open $fileChangeLog RDONLY]

    foreach item [list about changelog] {
        switch -- $item {
            changelog   {
                            # Set the file
                            set fd $openChangeLog
                            set wid $changeLog_Text
                        }
            about       {
                            # Set the file
                            set fd $openFileAbout
                            set wid $about_Text
            }
            default     {}
        }
        
            # Make the markup tags
            $wid tag config Heading1 \
                            -font {verdana 12 bold} \
                            -spacing1 5 \
                            -spacing3 10
    
            $wid tag config Heading2 \
                            -font {verdana 10 bold} \
                            -lmargin1 2 \
                            -spacing1 5 \
                            -spacing3 0
    
            $wid tag config Normal \
                            -font {verdana 10} \
                            -lmargin1 12 \
                            -lmargin2 4 \
                            -spacing1 4 \
                            -spacing2 4 \
                            -spacing3 4
    
            $wid tag config List1 \
                            -font {verdana 9} \
                            -lmargin2 24 \
                            -spacing1 10 \
                            -spacing2 4 \
                            -spacing3 10
    
            $wid tag config List2 \
                            -font {verdana 9} \
                            -lmargin1 12 \
                            -lmargin2 24
    
            $wid tag configure hr \
                            -font {fixed -1} \
                            -borderwidth 2 \
                            -relief sunken \
                            -background gray
    
            $wid tag configure BUG \
                            -font {verdana 10 bold}
            
        if {$item eq "about"} {
            $wid tag configure Normal \
                            -font {verdana 10} \
                            -lmargin1 4 \
                            -lmargin2 4 \
                            -spacing1 4 \
                            -spacing2 4 \
                            -spacing3 4
        }
    
        set i 0
        set idx 0
        set idx2 0
        while { [gets $fd line] >= 0 } {
            # Keep track of how many lines we insert
            incr idx
            set newTag ""
            #'debug StringRange: [string range $line 0 1]
            # Capture our 'markup' and format the text
            # = Heading
            # == 2nd Heading
            # * Bullets list
            # # Numbered list
            # -- Horizontal rule
            # *[ Group
    
            set stringFormat [string range $line 2 end]
            #${log}::debug stringFormat: $stringFormat
            # \u25C6 ;# Diamond
            # \u00B7 ;# Small
            # \U2022 ;# unicode
            switch -- [string range $line 0 1] {
                "= "        {set textFormat Heading1; set i 0 ;# Heading1}
                "=="        {set textFormat Heading2; set i 0 ;# Heading2}
                "* "        {set stringFormat "\u0009 \u2022 $stringFormat"; set textFormat List1; set i 0 ;# List1}
                "# "        {set stringFormat "\u0009 [incr i]. $stringFormat"; set textFormat List2;# List2}
                "--"        {
                                set textFormat hr
                                set stringFormat "\n"
                            }
                default     {set stringFormat $line; set textFormat Normal; set i 0; ${log}::debug Detected $line ;# No markup detected}
            }
    
            # Insert the copyright symbol instead of (C)
            if {[string match -nocase *(C)* $stringFormat]} {
                set stringFormat [string map {(C) \u00A9} $stringFormat]
            }
            
            $wid insert end $stringFormat $textFormat
            
            if {$stringFormat != "\n"} {
                # We only want to enter one newline ...
                $wid insert end \n
            }
            
            
            if {[string first \[ $stringFormat] != -1} {
                # We use expr because [string first] starts at 0; [string range] starts at 1
                set grpTag1 [string first \[ $stringFormat]
                set grpTag2 [string first \] $stringFormat]
                set grpName [string range $stringFormat $grpTag1 $grpTag2]
                
                ${log}::debug string length: [string length $grpName]
                ${log}::debug Full String: $stringFormat
                
                switch -nocase $grpName {
                    [BUG] {set newTag BUG}
                    default {${log}::debug no tag for: $grpName}
                }
                
                ${log}::debug Line $idx / $idx.$grpTag1 _ $idx.$grpTag2 / inserting Group1 Tag
                ${log}::debug String [string range $stringFormat $grpTag1 $grpTag2]
                if {$newTag != ""} {
                    # use [incr] because text widget starts at 1; [string] starts at 0
                    incr grpTag2
                    $wid tag add $newTag $idx.$grpTag1 $idx.$grpTag2
                }
            }
        }
    
        # Since we inserted our text, lets disable the widget to prevent the deletion of text (not that it matters, but adds a bit of professionalism)
        $wid configure -state disabled
    
        chan close $fd
    }

    #
    # Licenses
    #
}