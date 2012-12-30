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

proc BlueSquared_About::aboutWindow {args} {
    #****f* aboutWindow/BlueSquared_About
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #   BlueSquared_About::aboutWindow ?args?
    #
    #
    # SYNOPSIS
    #	GUI for the About window. If no args are present then we open to the About tab.
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
    #wm geometry .about +${locX}+${locY}
    
    if {$args eq ""} {set args 1}
    #if {$args ne 1 || $args ne 2} {return}
 

    ##
    ## Parent Frame
    ##
    set frame0 [ttk::frame .about.frame0]
    pack $frame0 ;#-expand yes -fill both ;#-pady 5p -padx 5p

    ##
    ## Notebook
    ##
    set nb [ttk::notebook $frame0.nb]
    pack $nb ;#-expand yes -fill both


    $nb add [ttk::frame $nb.f1] -text [mc "About"]
    $nb add [ttk::frame $nb.f2] -text [mc "Release Notes"]
    #$nb add [ttk::frame $nb.f3] -text [mc "Licenses"]
    $nb select $nb.f1
    $nb select $nb.f$args

    ttk::notebook::enableTraversal $nb

    ##
    ## Tab 1 (About)
    ##
    text $nb.f1.text -wrap word \
                    -yscrollcommand [list $nb.f1.scrolly set] \
                    -xscrollcommand [list $nb.f1.scrollx set]

    ttk::scrollbar $nb.f1.scrolly -orient v -command [list $nb.f1.listbox yview]
    ttk::scrollbar $nb.f1.scrollx -orient h -command [list $nb.f1.listbox xview]

    pack $nb.f1.text -padx 5p -pady 5p

    pack $nb.f1.scrolly
    pack $nb.f1.scrollx

    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $nb.f1.scrolly
    ::autoscroll::autoscroll $nb.f1.scrollx



    ##
    ## Tab 2 (Release Notes)
    ##

    set tab2 [ttk::frame $nb.f2.frame1]
    pack $tab2 -expand yes -fill both -padx 5p -pady 5p
    #pack $tab2 -padx 5p -pady 5p


    text $tab2.text -wrap word \
                    -tabs 4 \
                    -tabstyle wordprocessor \
                    -yscrollcommand [list $tab2.scrolly set] \
                    -xscrollcommand [list $tab2.scrollx set]

    ttk::scrollbar $tab2.scrolly -orient v -command [list $tab2.text yview]
    ttk::scrollbar $tab2.scrollx -orient h -command [list $tab2.text xview]

    grid $tab2.text -column 0 -row 0 ;#-sticky news;# -padx 5p -pady 5p
    grid columnconfigure $tab2 $tab2.text -weight 1

    grid $tab2.scrolly -column 1 -row 0 -sticky nse
    grid $tab2.scrollx -column 0 -row 1 -sticky ews

    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $tab2.scrolly
    ::autoscroll::autoscroll $tab2.scrollx



    ##
    ## Tab 3 (Licenses)
    ##



    ##
    ## Button Bar
    ##

    set buttonbar [ttk::frame $frame0.buttonbar]
    ttk::button $buttonbar.close -text [mc "Close"] -command { destroy .about }

    grid $buttonbar.close -column 0 -row 0 -sticky nse -ipadx 4p
    pack $buttonbar -side bottom -anchor e -pady 8p -padx 5p

    #bind $tab2.text <Configure> "$tab2.text.hr configure -width %w"
    #frame $tab2.text.hr -relief raised -height 2 -background gray

    BlueSquared_About::aboutOpenFiles $nb.f1.text $tab2.text



} ;# End aboutWindow