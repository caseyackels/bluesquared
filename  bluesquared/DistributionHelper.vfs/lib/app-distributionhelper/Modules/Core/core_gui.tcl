# Creator: Casey Ackels
# Initial Date: March 12, 2011]
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
package provide disthelper_core 1.0

namespace eval disthelper {}

proc disthelper::parentGUI {} {
    #****f* parentGUI/disthelper
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
    #	disthelper::upsImportGUI
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
 
    wm geometry . 640x480 ;# width X Height
    
    # Create the Menu's
    set mb [menu .mb]
    . configure -menu $mb
    
    ## File
    menu $mb.file -tearoff 0 -relief raised -bd 2
    
    $mb add cascade -label [mc "File"] -menu $mb.file
    $mb.file add command -label [mc "Import File"] -command {Disthelper_Code::getOpenFile}
    $mb.file add command -label [mc "Exit"] -command {exit}
    
    ## Edit
    menu $mb.edit -tearoff 0 -relief raised -bd 2
    $mb add cascade -label [mc "Edit"] -menu $mb.edit
    
    $mb.edit add command -label "Clear List" -command {}
    $mb.edit add command -label "Breakdown" -command {}
    
    ## Help
    menu $mb.help -tearoff 0 -relief raised -bd 2
    $mb add cascade -label [mc "Help"] -menu $mb.help
    
    $mb.help add command -label [mc "About"] -command {}
    #$mb.help add command -label "v0.4" -command {}
    

    # Create Separator Frame
    set frame0 [ttk::frame .frame0]
    ttk::separator $frame0.separator -orient horizontal
    
    grid $frame0.separator - -sticky ew -ipadx 4i
    pack $frame0 -anchor n -fill x -expand yes
    
    # Create the container frame
    ttk::frame .container
    pack .container -expand yes -fill both
    
    # Start the gui
    # All frames that make up the GUI are children to .container
    Disthelper_GUI::disthelperGUI
    

    ## 
    ## Control Buttons
    ##
    
    set btnBar [ttk::frame .btnBar]
    
    ttk::button $btnBar.print -text "Generate File" -command { Disthelper_Code::writeOutPut }
    ttk::button $btnBar.close -text "Cancel" -command {exit}
    
    grid $btnBar.print -column 0 -row 3 -sticky nse -padx 8p  
    grid $btnBar.close -column 1 -row 3 -sticky nse
    pack $btnBar -side bottom -anchor e -pady 10p -padx 5p
    
    # ToolTips
    #tooltip::tooltip $btnBar.close "Close (Esc)"
    
    # Bindings
    bind $btnBar.close <Return> {exit}
    #bind all <Control-p> "Shipping_Code::printLabels"

} ;# End of parentGUI