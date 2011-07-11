# Creator: Casey Ackels
# Initial Date: July 10th, 2011
# Dependencies: progressWindow_code.tcl
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


proc Disthelper_GUI::progressWindow {} { 
    #****f* progressWindow/Disthelper_GUI
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Disthelper_GUI::progressWindow
    #
    # SYNOPSIS
    #	Calling this command brings up the progress window, and starts processing the file
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
    global GL_file program
    toplevel .progress
    wm title .progress [mc "Processing File"]
    wm transient .progress .
    
    focus .progress
    
    set locX [expr {([winfo screenwidth .] - [winfo width .]) / 2}]
    set locY [expr {([winfo screenheight .] - [winfo height .]) / 2}]
    wm geometry .progress +${locX}+${locY}
    
    # Reset variables
    set program(ProgressBar) 0
    set program(totalAddress) 0
    set program(totalBoxes) 0
    set program(totalBooks) 0
    set program(totalAddress) 0
    #set program(totalAddress) [llength $GL_file(dataList)]
    
    ##
    ## Parent Frame
    ##
    set container [ttk::labelframe .progress.container -text [mc "File Progress"]]
    pack $container -expand yes -fill both -pady 5p -padx 5p
    
    set frame1 [ttk::frame $container.frame1]
    pack $frame1 -expand yes -fill both -pady 5p -padx 5p
    
    #ttk::progressbar $frame1.bar -length [llength $GL_file(dataList)]
    ttk::progressbar $frame1.bar -mode determinate -variable program(ProgressBar) -maximum [llength $GL_file(dataList)]
    pack $frame1.bar -fill x -expand 1 -padx 4p -pady 10p
    
    
    set frame2 [ttk::frame $container.frame2]
    pack $frame2 -expand yes -fill both -pady 5p -padx 5p
    
    ttk::label $frame2.txt1a -text [mc "Addresses"]
    ttk::label $frame2.txt1b -textvariable program(totalAddress)
    
    ttk::label $frame2.txt2a -text [mc "Boxes"]
    ttk::label $frame2.txt2b -textvariable program(totalBoxes)
    
    ttk::label $frame2.txt3a -text [mc "Books"]
    ttk::label $frame2.txt3b -textvariable program(totalBooks)
    
    grid $frame2.txt1a -column 0 -row 0 -sticky nse -padx 4p
    grid $frame2.txt1b -column 1 -row 0 -sticky nsw
    
    grid $frame2.txt2a -column 0 -row 1 -sticky nse -padx 4p
    grid $frame2.txt2b -column 1 -row 1 -sticky nsw
    
    grid $frame2.txt3a -column 0 -row 2 -sticky nse -padx 4p
    grid $frame2.txt3b -column 1 -row 2 -sticky nsw
    
    set btnbar [ttk::frame .progress.btnbar]
    pack $btnbar -padx 4p -pady 10p -side right
    
    ttk::button $btnbar.close -text [mc "Close"] -command {destroy .progress}

    grid $btnbar.close -column 0 -row 0 -sticky nse
    
    Disthelper_Code::writeOutPut
}



