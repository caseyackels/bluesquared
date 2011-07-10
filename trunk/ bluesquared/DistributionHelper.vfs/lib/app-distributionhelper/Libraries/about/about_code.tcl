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

proc BlueSquared_About::aboutOpenFiles {} {
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
    
    ## Open the ABOUT file
    #set fileName [open "$filename" RDONLY]
    #  
    ## Make the data useful, and put it into lists
    ## While we are at it, make everything UPPER CASE
    #while { [gets $fileName line] >= 0 } {
    #    lappend GL_file(dataList) [string toupper $line]
    #    'debug "while: $line"
    #}
    #
    #chan close $fileName
}