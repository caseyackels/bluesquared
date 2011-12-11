# Initial Date: November 26, 2011]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 157 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2011-10-03 14:41:48 -0700 (Mon, 03 Oct 2011) $
#
########################################################################################

##
## - Overview
# This file holds the parent GUI for Distribution Helper

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

## Coding Conventions
# - Namespaces:

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

namespace eval NextgenRM_GUI {

proc nextgenrmGUI {} {
    #****f* nextgenrmGUI/NextgenRM_GUI
    # AUTHOR
    #	PickleJuice
    #
    # COPYRIGHT
    #	(c) 2011 - PickleJuice
    #
    # FUNCTION
    #	Builds the GUI of the Import Files Module, with bindings
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	disthelper::parentGUI
    #
    # NOTES
    #	Global Array
    #
    # SEE ALSO
    #
    #***
    global GS_profile GS_textVar

    wm title . "$program(Name) - $program(Version)"
    focus -force .
    

# Frame 1 - Select store profile, date, purchased list
    set frame1 [ttk::labelframe .container.frame1 -text [mc "Store Data"]]
    pack $frame1 -fill both -padx 5p -pady 5p -ipady 2p -anchor nw -side left
    
    ttk::label $frame1.store -text [mc "Store Profile"]
    ttk::combobox $frame1.storeCombo -textvariable GS_textVar(storelist) \
                                    -values [list Safeway "Fred Meyer" Albertsons]
    
    ttk::label $frame1.date -text [mc "Date"]
    ttk::entry $frame1.entry
    
    ttk::label $frame1.pList -text [mc "Purchased List"]
    ttk::combobox $frame1.plistCombo -textvariable GS_textVar(purchasedlist) \
                                    -values [list Food Clothes Other <None>]
    
    
    
    grid $frame1.store -column 0 -row 0 -padx 5p -pady 5p -sticky e
    grid $frame1.storeCombo -column 1 -row 0 -padx 5p -pady 5p -sticky w
    
    grid $frame1.date -column 0 -row 1 -sticky e
    grid $frame1.entry -column 1 -row 1 -sticky w
    
    grid $frame1.pList -column 0 -row 2 -sticky e
    grid $frame1.plistCombo -column 1 -row 2 -sticky w
    
} ;# End of NextgenRM_GUI namespace