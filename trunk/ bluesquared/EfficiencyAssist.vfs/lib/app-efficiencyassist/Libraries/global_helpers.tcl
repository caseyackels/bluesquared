# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 169 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2011-10-17 16:11:20 -0700 (Mon, 17 Oct 2011) $
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

namespace eval eAssist_Global {}

proc eAssist_Global::resetFrames {} {
    #****f* resetFrames/eAssist_Global
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Reset frames in the main window so we can switch modes.
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
    
    foreach child [winfo children .container] {
        puts $child
    }
    
    foreach child [winfo children .container] {
        destroy $child
    }

} ;# eAssist_Global::resetFrames


proc eAssist_Global::resetSetupFrames {args} {
    #****f* resetSetupFrames/eAssist_Global
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Reset frames in the setup window so we can switch modes tree groups.
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
    global savePage
    
    foreach child [winfo children .container.setup] {
        puts $child
    }
    
    foreach child [winfo children .container.setup] {
        destroy $child
    }
    
    set savePage $args ;# Allows us to save what is on that page

} ;# eAssist_Global::resetSetupFrames


proc eAssist_Global::OpenFile {title initDir type args} {
    #****f* getOpenFile/eAssist_Global
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Allows the user to find the target file or directory; we save it into a variable and pass it back to the originating proc
    #   e.g. set file [eAssist_Global::OpenFile [mc "Pick File"] [pwd] file *.exe]
    #
    # SYNOPSIS
    #	eAssist_Global::OpenFile <title> <initDir> <file|dir> <args(fileExtension)>
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
    #
    #***

    if {$type eq "file"} {
        set filename [tk_getOpenFile \
                      -parent . \
                      -title $title \
                      -initialdir $initDir \
                      -defaultextension $args
        ]
    } else {
        set filename [tk_chooseDirectory \
                 -initialdir $initDir -title $title]
        }

    # If we do not select a file name, and cancel out of the dialog, do not produce an error.
    if {$filename eq ""} {return}

    return $filename

} ;# eAssist_Global::OpenFile