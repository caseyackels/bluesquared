# Creator: Casey Ackels
# Initial Date: November 26, 2011]
# Dependencies: See Below
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
# This file holds the parent GUI frame, buttons and menu for Distribution Helper

# Start GUI
package provide rm_ng 1.0

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
    #	Generate the parent GUI container and buttons
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
    global profile

    #wm geometry . 640x600 ;# width x Height

    # Create the Menu's
    set mb [menu .mb]
    . configure -menu $mb

    ## File
    menu $mb.file -tearoff 0 -relief raised -bd 2

    $mb add cascade -label [mc "File"] -menu $mb.file
    $mb.file add command -label [mc "Store Profile..."] -command {nextgenrm_GUI::profile}
    $mb.file add command -label [mc "Purchased Lists..."] -command {nextgenrm_GUI::pclWindow}
    $mb.file add command -label [mc "Exit"] -command {exit}

    ## Edit
    #menu $mb.edit -tearoff 0 -relief raised -bd 2
    #$mb add cascade -label [mc "Edit"] -menu $mb.edit

    #$mb.edit add command -label [mc "Preferences..."] -command { nextgenrm_Preferences::prefGUI }
    #$mb.edit add command -label "Reset" -command { nextgenrm_Helper::resetVars -resetGUI }


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

    ttk::button $btnBar.print -text [mc "Exit"] -command { 'debug [array names profile] }

    grid $btnBar.print -column 0 -row 3 -sticky nse -padx 8p
    pack $btnBar -side bottom -anchor e -pady 13p -padx 5p


} ;# End of parentGUI