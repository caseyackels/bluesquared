# Creator: Casey Ackels
# Initial Date: April 8th, 2011
# Dependencies: about_code.tcl, package.tcl
# Notes: This is a complete package to build your own About Window
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

package provide aboutwindow 0.1

namespace eval BlueSquared_About {}
    
    # Set About Window variables
    set about(windowName) [mc "About - Efficiency Assist"]


proc BlueSquared_About::aboutWindow {} {
    #****f* aboutWindow/BlueSquared_About
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
    #	GUI for the About window
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
    global about
    toplevel .about
    wm title .about [mc $about(windowName)]
    wm transient .about .
    
        ##
    ## Parent Frame
    ##
    set frame0 [ttk::frame .about.frame0]
    pack $frame0 -expand yes -fill both -pady 5p -padx 5p
    
    ##
    ## Notebook
    ##
    set nb [ttk::notebook $frame0.nb]
    pack $nb -expand yes -fill both
    

    $nb add [ttk::frame $nb.f1] -text [mc "About"]
    $nb add [ttk::frame $nb.f2] -text [mc "Licenses"]
    $nb add [ttk::frame $nb.f3] -text [mc "Change Log"]
    $nb select $nb.f1

    ttk::notebook::enableTraversal $nb
    
    
    ##
    ## Button Bar
    ##
    
    set buttonbar [ttk::frame .about.buttonbar]
    ttk::button $buttonbar.ok -text [mc "Save & Close"] -command {  }
    ttk::button $buttonbar.close -text [mc "Discard Changes"] -command { destroy .about }
    
    grid $buttonbar.ok -column 0 -row 3 -sticky nse -padx 8p -ipadx 4p
    grid $buttonbar.close -column 1 -row 3 -sticky nse -ipadx 4p
    pack $buttonbar -side bottom -anchor e -pady 8p -padx 5p
    
    
} ;# End aboutWindow