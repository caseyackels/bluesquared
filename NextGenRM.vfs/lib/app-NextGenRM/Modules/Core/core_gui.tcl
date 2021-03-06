# Creator: Casey Ackels
# Initial Date: November 26, 2011]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 251 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2012-11-03 11:14:16 -0700 (Sat, 03 Nov 2012) $
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
    $mb.file add command -label [mc "Setup..."] -command {rmGUI::prefGUI}
    $mb.file add command -label [mc "Exit"] -command {exit}


    ## Help
    menu $mb.help -tearoff 0 -relief raised -bd 2
    $mb add cascade -label [mc "Help"] -menu $mb.help

    $mb.help add command -label [mc "About..."] -command { BlueSquared_About::aboutWindow }

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
    pack $btnBar -side bottom -anchor e -pady 13p -padx 5p
    
    grid [ttk::button $btnBar.print -text [mc "Exit"] -command {destroy .}] -column 0 -row 0 -sticky se
   

} ;# End of parentGUI