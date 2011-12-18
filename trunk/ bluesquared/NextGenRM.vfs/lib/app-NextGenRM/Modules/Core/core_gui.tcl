# Creator: Casey Ackels
# Initial Date: November 26, 2011]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 156 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2011-10-02 22:00:38 -0700 (Sun, 02 Oct 2011) $
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

# Start GUI
package provide nextgenrm1 1.0

namespace eval nextgenrm {}

proc nextgenrm::parentGUI {} {
    #****f* parentGUI/nextgenrm
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 20011 Casey Ackels
    #
    # FUNCTION
    #	Generate the parent GUI container and buttons (Cancel / Generate File)
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #
    # PARENTS
    #	None
    #
    # NOTES
    #	None
    #
    # SEE ALSO
    #	N/A
    #
    #***

    #wm geometry . 640x600 ;# width x Height

    # Create the Menu's
    set mb [menu .mb]
    . configure -menu $mb

    ## File
    menu $mb.file -tearoff 0 -relief raised -bd 2

    $mb add cascade -label [mc "File"] -menu $mb.file
    $mb.file add command -label [mc "Add/Edit Profile"] -command {nextgenrm_GUI::addEditWindow}
    $mb.file add command -label [mc "Exit"] -command {exit}

    ## Edit
    menu $mb.edit -tearoff 0 -relief raised -bd 2
    $mb add cascade -label [mc "Edit"] -menu $mb.edit

    $mb.edit add command -label [mc "Preferences..."] -command { nextgenrm_Preferences::prefGUI }
    $mb.edit add command -label "Reset" -command { nextgenrm_Helper::resetVars -resetGUI }


    ## Help
    menu $mb.help -tearoff 0 -relief raised -bd 2
    $mb add cascade -label [mc "Help"] -menu $mb.help

    $mb.help add command -label [mc "About..."] -command { BlueSquared_About::aboutWindow }


    # Create Separator Frame
    #set frame0 [ttk::frame .frame0]
    #ttk::separator $frame0.separator -orient horizontal

    #grid $frame0.separator - -sticky ew -ipadx 4i
    #pack $frame0 -anchor n -fill x -expand yes -pady 3p

    # Create the container frame
    ttk::frame .container
    pack .container -expand yes -fill both

    # Start the gui
    # All frames that make up the GUI are children to .container
    nextgenrm_GUI::nextgenrmGUI


    ##
    ## Control Buttons
    ##

    set btnBar [ttk::frame .btnBar]

    ttk::button $btnBar.print -text [mc "Print"] -command { nextgenrm_Helper::checkForErrors }

    grid $btnBar.print -column 0 -row 3 -sticky nse -padx 8p
    pack $btnBar -side bottom -anchor e -pady 13p -padx 5p


} ;# End of parentGUI