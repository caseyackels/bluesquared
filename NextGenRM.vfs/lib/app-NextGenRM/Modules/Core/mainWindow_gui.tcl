# Initial Date: 6/21/2016

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
    #	
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

    set f1 [ttk::labelframe .container.f1 -text [mc "Receipt Data"]]
    pack $f1 -fill both -padx 5p -pady 5p -anchor n
    
    #grid [ttk::label $f1.store -text [mc "Purchased List"]] -column 0 -row 0 -padx 3p -pady 3p -sticky e
    #grid [ttk::combobox $f1.pcl -state readonly] -column 1 -row 0 -padx 2p -pady 3p -sticky ew

    grid [ttk::label $f1.date1 -text [mc "Date Start"]] -column 0 -row 1 -padx 2p -pady 3p -sticky e
    grid [ttk::entry $f1.entry1 -width 20] -column 1 -row 1 -padx 2p -pady 3p -sticky ew
    grid [ttk::label $f1.date2 -text [mc "Date End"]] -column 2 -row 1 -padx 2p -pady 3p -sticky e
    grid [ttk::entry $f1.entry2 -width 20] -column 3 -row 1 -padx 2p -pady 3p -sticky ew
    
    grid [ttk::label $f1.pList -text [mc "Liquor Type"]] -column 0 -row 2 -padx 3p -pady 2p -sticky e
    grid [ttk::combobox $f1.plistCombo -textvariable GS_textVar(purchasedlist) \
                                    -values [list Wine Beer Liquor -All-] \
                                    -state readonly] -column 1 -row 2 -padx 3p -pady 2p -sticky ew
    grid [ttk::label $f1.txt3 -text [mc "Num. of Forms"]] -column 2 -row 2
    grid [ttk::entry $f1.entry3] -column 3 -row 2

    
    
##
## Frame 2 - Enter products, quantities, and price
##

    set f2 [ttk::labelframe .container.f2 -text [mc "Product Information"]]
    pack $f2 -fill both -expand yes -padx 5p -pady 5p -anchor n
    
    # Header Row
    ttk::label $f2.header1 -text [mc "Product"]
    ttk::label $f2.header2 -text [mc "Quantity"]
    ttk::label $f2.header3 -text [mc "Price"]
    
    grid $f2.header1 -column 1 -row 0
    grid $f2.header2 -column 2 -row 0
    grid $f2.header3 -column 3 -row 0
    
    # Lines 1 - 10
    set col 0
    set row 1
    for {set x 1} {6 > $x} {incr x} {
        set child_col 0
        ttk::label $f2.line$x -text "[mc Line] $x"
        ttk::entry $f2.productline$x -textvariable GS_product(product,line$x) -width 25
        ttk::entry $f2.quantityline$x -textvariable GS_product(quantity,line$x) -width 3
        ttk::entry $f2.priceline$x -textvariable GS_product(price,line$x) -width 6
        
        # Grid the widgets
        grid $f2.line$x -column $child_col -row $row -padx 3p -pady 2p -sticky e
        grid $f2.productline$x -column [incr child_col] -row $row -padx 2p -pady 2p -sticky news
        grid $f2.quantityline$x -column [incr child_col] -row $row -padx 2p -pady 2p -sticky news
        grid $f2.priceline$x -column [incr child_col] -row $row -padx 2p -pady 2p -sticky news
        
        incr col
        incr row
    }
    
    grid columnconfigure $f2 1 -weight 2

}