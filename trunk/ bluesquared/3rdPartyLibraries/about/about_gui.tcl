# Creator: Casey Ackels
# Initial Date: April 8th, 2011
# Dependencies: about_code.tcl, pkgIndex.tcl
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

package provide aboutwindow 1.0

namespace eval BlueSquared_About {}

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
    global about program

    toplevel .about
    wm title .about $program(Name)
    wm transient .about .

    set locX [expr {([winfo screenwidth .] - [winfo width .]) / 2}]
    set locY [expr {([winfo screenheight .] - [winfo height .]) / 2}]

    wm geometry .about 450x500+${locX}+${locY}



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
    $nb add [ttk::frame $nb.f2] -text [mc "Release Notes"]
    #$nb add [ttk::frame $nb.f3] -text [mc "Licenses"]
    $nb select $nb.f1

    ttk::notebook::enableTraversal $nb

    ##
    ## Tab 1 (About)
    ##
    text $nb.f1.text -wrap word \
                    -yscrollcommand [list $nb.f1.scrolly set] \
                    -xscrollcommand [list $nb.f1.scrollx set]

    ttk::scrollbar $nb.f1.scrolly -orient v -command [list $nb.f1.listbox yview]
    ttk::scrollbar $nb.f1.scrollx -orient h -command [list $nb.f1.listbox xview]

    pack $nb.f1.text -expand yes -fill both -padx 5p -pady 5p
    #grid $nb.f1.text -column 0 -row 0 -sticky news -padx 5p -pady 5p

    #grid $nb.f1.scrolly -column 1 -row 0 -sticky nse
    #grid $nb.f1.scrollx -column 0 -row 1 -sticky ews
    pack $nb.f1.scrolly
    pack $nb.f1.scrollx

    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $nb.f1.scrolly
    ::autoscroll::autoscroll $nb.f1.scrollx



    ##
    ## Tab 2 (Release Notes)
    ##

    text $nb.f2.text -wrap word \
                    -tabs 4 \
                    -tabstyle wordprocessor \
                    -yscrollcommand [list $nb.f1.scrolly set] \
                    -xscrollcommand [list $nb.f1.scrollx set]

    ttk::scrollbar $nb.f2.scrolly -orient v -command [list $nb.f2.listbox yview]
    ttk::scrollbar $nb.f2.scrollx -orient h -command [list $nb.f2.listbox xview]

    #pack $nb.f2.text -expand yes -fill both -padx 5p -pady 5p
    grid $nb.f2.text -column 0 -row 0 -sticky news -padx 5p -pady 5p

    grid $nb.f2.scrolly -column 1 -row 0 -sticky nse
    grid $nb.f2.scrollx -column 0 -row 1 -sticky ews

    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $nb.f2.scrolly
    ::autoscroll::autoscroll $nb.f2.scrollx



    ##
    ## Tab 3 (Licenses)
    ##



    ##
    ## Button Bar
    ##

    set buttonbar [ttk::frame .about.buttonbar]
    ttk::button $buttonbar.close -text [mc "Close"] -command { destroy .about }

    grid $buttonbar.close -column 1 -row 3 -sticky nse -ipadx 4p
    pack $buttonbar -side bottom -anchor e -pady 8p -padx 5p

    bind $nb.f2.text <Configure> "$nb.f2.text.hr configure -width %w"

    frame $nb.f2.text.hr -relief raised -height 2 -background gray

    BlueSquared_About::aboutOpenFiles $nb.f1.text $nb.f2.text



} ;# End aboutWindow