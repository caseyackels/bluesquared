# Creator: Casey Ackels
# Initial Date: March 12, 2011
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

package provide debug 1.0

namespace eval 'debug {
    namespace export 'debug
}

proc 'debug::'debug {args} { 
    #****f* 'debug/bs_debug
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Set debug(onOff) to on/off to 
    #
    # SYNOPSIS
    #	Create a way to turn on/off debugging, and allow us from having to type so much repetitive information.
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	
    #
    # NOTES
    #   Eventually this should be written out to a text widget, instead of to the WISH console
    #
    # SEE ALSO
    #
    #***
    global debug
    
    if {$debug(onOff) eq "Off"} {return}
    
    # Configuration parameters
    #switch -- [lindex [string tolower $args] 0] {
    #    -on {
    #        # Initialize window
    #        'debug::debugWindow
    #        }
    #    -level {}
    #    default {}
    #}
    #
    #
    #switch -- [lindex $args 0] {
    #    -L1 {
    #        # L1 is for basic reporting but we don't always want to see this
    #    }
    #    -L2 {
    #        # L2 is for slight problem area's under active development area's
    #    }
    #    -L3 {
    #        # L3 is for problematic active development area's. This will always be reported.
    #    }
    #    default {
    #        # Same as L3
    #    }
    #}
    puts "[info level 1]: $args"
    #'debug::debugWindow [info level 1] $args
    #.debug.container.frame1.txt insert end [info level 1](L1) $args

    
} ;# End 'debug::'debug


proc 'debug::debugWindow {} {
    #****f* debugWindow/'debug
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Create window to output the debugging information
    #
    # SYNOPSIS
    #	Not public
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	
    #
    # NOTES
    #   Called by bs_debug::'debug
    #
    # SEE ALSO
    #
    #***
    toplevel .debug
    wm title .debug "Debug Window"

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    wm geometry .debug +${locX}+${locY}
    
    set container [ttk::frame .debug.container]
    pack $container -expand yes -fill both
    
    set frame1 [ttk::frame $container.frame1]
    pack $frame1 -expand yes -fill both
    
    text $frame1.txt
    
    grid $frame1.txt -column 0 -row 0 -sticky news
    
    #$frame1.txt insert end $args
}

