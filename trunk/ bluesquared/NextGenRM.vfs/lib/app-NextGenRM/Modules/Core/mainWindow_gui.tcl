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

namespace eval nextgenrm_GUI {}
namespace eval nextgenrm_Code {}

proc nextgenrm_GUI::nextgenrmGUI {} {
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
    global profile GS_textVar program

    wm title . "$program(Name) - $program(Version)"
    focus -force .
    
    
##
## Frame 1 - Select store profile, date, purchased list
##

    set frame1 [ttk::labelframe .container.frame1 -text [mc "Receipt Data"]]
    pack $frame1 -fill both -padx 5p -pady 5p -ipady 2p -anchor n
    
    ttk::label $frame1.store -text [mc "Store Profile"]
		set program(profileList) " " ;# initialize variable
    ttk::combobox $frame1.storeCombo -textvariable GS_textVar(storelist) \
									-values $program(profileList) \
									-state readonly \
									-postcommand "nextgenrm_Code::showProfiles -combobox $frame1.storeCombo"

	
    ttk::label $frame1.date -text [mc "Date"]
    ttk::entry $frame1.entry -width 20
    
    ttk::label $frame1.pList -text [mc "Purchased List"]
    ttk::combobox $frame1.plistCombo -textvariable GS_textVar(purchasedlist) \
                                    -values [list Food Clothes Other <None>]
    
    
    
    grid $frame1.store -column 0 -row 0 -padx 3p -pady 5p -sticky e
    grid $frame1.storeCombo -column 1 -row 0 -padx 2p -pady 5p -sticky w
    #grid $frame1.profile -column 2 -row 0 -padx 3p -pady 5p -sticky news
    
    grid $frame1.date -column 0 -row 1 -padx 3p -pady 2p -sticky e
    grid $frame1.entry -column 1 -row 1 -padx 2p -pady 3p -sticky news
    
    grid $frame1.pList -column 0 -row 2 -padx 3p -pady 2p -sticky e
    grid $frame1.plistCombo -column 1 -row 2 -padx 2p -pady 3p -sticky w
    
    
##
## Frame 2 - Enter products, quantities, and price
##

    set frame2 [ttk::labelframe .container.frame2 -text [mc "Product Information"]]
    pack $frame2 -fill both -padx 5p -pady 5p -ipadx 5p -ipady 2p -anchor n
    
    # Header Row
    ttk::label $frame2.header1 -text [mc "Product"]
    ttk::label $frame2.header2 -text [mc "Quantity"]
    ttk::label $frame2.header3 -text [mc "Price"]
    
    grid $frame2.header1 -column 1 -row 0
    grid $frame2.header2 -column 2 -row 0
    grid $frame2.header3 -column 3 -row 0
    
    # Lines 1 - 10
    set col 0
    set row 1
    for {set x 1} {11 > $x} {incr x} {
        set child_col 0
        ttk::label $frame2.line$x -text "[mc Line] $x"
        ttk::entry $frame2.productline$x -textvariable GS_product(product,line$x) -width 25
        ttk::entry $frame2.quantityline$x -textvariable GS_product(quantity,line$x) -width 3
        ttk::entry $frame2.priceline$x -textvariable GS_product(price,line$x) -width 6
        
        # Grid the widgets
        grid $frame2.line$x -column $child_col -row $row -padx 3p -pady 2p -sticky e
        grid $frame2.productline$x -column [incr child_col] -row $row -padx 2p -pady 2p -sticky news
        grid $frame2.quantityline$x -column [incr child_col] -row $row -padx 2p -pady 2p -sticky news
        grid $frame2.priceline$x -column [incr child_col] -row $row -padx 2p -pady 2p -sticky news
        
        incr col
        incr row
    }
    
    # Create Separator Frame
    #set sep_frame1 [ttk::frame .container.sep_frame1]
    #ttk::separator $sep_frame1.separator -orient horizontal

    #grid $sep_frame1.separator - -sticky ew -ipadx 1i
    #grid $sep_frame1.separator - -ipadx 1i
    #pack $sep_frame1 ;#-fill x -expand yes
    
}