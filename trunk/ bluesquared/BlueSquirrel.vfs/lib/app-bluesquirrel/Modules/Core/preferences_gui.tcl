# Creator: Casey Ackels (C) 2006 - 20011
# Initial Date: October 28th, 2006
# Massive Rewrite: February 2nd, 2007
# Version: See shipping_launch_code.tcl
# Dependencies: See shipping_launch_code.tcl
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 12 $
# $LastChangedBy: casey $
# $LastChangedDate: 2007-02-24 14:12:13 -0800 (Sat, 24 Feb 2007) $
#
########################################################################################

##
## - Overview
# This file holds the window for the Shipping Mode.

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

proc blueSquirrel::preferences {} {
    #****f* preferences/blueSquirrel_Preferences
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
    #	GUI for the preferences window
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
    global program

    toplevel .preferences
    wm transient .preferences .
    wm title .preferences "Preferences"

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    wm geometry .preferences +${locX}+${locY}

    focus .preferences

    ##
    ## Parent Frame
    ##
    set frame0 [ttk::frame .preferences.frame0]
    pack $frame0 -expand yes -fill both -pady 5p -padx 5p

    ##
    ## Notebook
    ##
    set nb [ttk::notebook $frame0.nb]
    pack $nb -expand yes -fill both


    $nb add [ttk::frame $nb.f1] -text "Labels"
    $nb add [ttk::frame $nb.f2] -text "Miscellaneous"
    #$nb add [ttk::frame $nb.f3] -text [mc "Header Names"]
    $nb select $nb.f1

    ttk::notebook::enableTraversal $nb

    ##
    ## Tab 1 (Labels)
    ##

    set frame1 [ttk::labelframe $nb.f1.frame1 -text "labels"]
    pack $frame1 -padx 5p -pady 5p -ipady 5p -padx 5p -side left


    listbox $frame1.listbox

    grid $frame1.listbox -column 0 -row 0

    set frame2 [ttk::frame $nb.f1.frame2]
    pack $frame2 -padx 5p -pady 5p -ipady 2p

    ttk::button $frame2.new -text "New..."
    ttk::button $frame2.edit -text "Edit..."
    ttk::button $frame2.del -text "Remove"

    grid $frame2.new -column 0 -row 0
    grid $frame2.edit -column 0 -row 1
    grid $frame2.del -column 0 -row 2

    ##
    ## Tab 2 (File Paths)
    ##
    ttk::label $nb.f2.barTenderText -text "Bartender"
    ttk::entry $nb.f2.barTenderEntry -textvariable programPath(Bartend)
    ttk::button $nb.f2.barTenderButton -text ... ;#-command {Disthelper_Preferences::chooseDir barTenderFiles}

    ttk::label $nb.f2.labelsText -text "Labels"
    ttk::entry $nb.f2.labelsEntry -textvariable programPath(LabelPath)
    ttk::button $nb.f2.labelsButton -text ... ;#-command {Disthelper_Preferences::chooseDir outFilePath}

    grid $nb.f2.barTenderText -column 0 -row 0 -sticky e -padx 5p -pady 5p
    grid $nb.f2.barTenderEntry -column 1 -row 0 -sticky ew -padx 5p -pady 5p
    grid $nb.f2.barTenderButton -column 2 -row 0 -sticky e -padx 5p -pady 5p

    grid $nb.f2.labelsText -column 0 -row 1 -sticky e -padx 5p -pady 5p
    grid $nb.f2.labelsEntry -column 1 -row 1 -sticky ew -padx 5p -pady 5p
    grid $nb.f2.labelsButton -column 2 -row 1 -sticky e -padx 5p -pady 5p

    ##
    ## Button Bar
    ##

    set buttonbar [ttk::frame .preferences.buttonbar]
    ttk::button $buttonbar.ok -text "Save & Close" -command { Disthelper_Preferences::saveConfig; destroy .preferences }
    ttk::button $buttonbar.close -text "Discard Changes" -command { destroy .preferences }

    grid $buttonbar.ok -column 0 -row 3 -sticky nse -padx 8p -ipadx 4p
    grid $buttonbar.close -column 1 -row 3 -sticky nse -ipadx 4p
    pack $buttonbar -side bottom -anchor e -pady 8p -padx 5p
}