<<<<<<< .mine
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

proc 'debug {args} { 
    #****f* debug/dh_Debug
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
    
    if {![info exists debug(onOff)]} {puts "debug variable isn't found ... exiting"; return}
    if {$debug(onOff) eq off} {
        console show
        puts "debug is off"
        return
    }

    
    puts "[info level 1]: $args"
    
}=======
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


proc 'debug {args} { 
    #****f* debug/dh_Debug
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
    
    if {![info exists debug(onOff)]} {puts "debug variable isn't found ... exiting"; return}
    if {$debug(onOff) eq off} {puts "debug is off"; return}
    
    puts "[info level 1]: $args"
    
}>>>>>>> .r198
