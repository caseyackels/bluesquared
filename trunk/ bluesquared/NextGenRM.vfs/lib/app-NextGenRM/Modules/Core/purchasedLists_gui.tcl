# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 50 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2011-03-13 17:09:18 -0700 (Sun, 13 Mar 2011) $
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


proc nextgenrm_GUI::pclWindow {} {
    #****f* pclWindow/nextgenrm_GUI
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
    #	N/A
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

    # Make sure the window has been destroyed before creating.
    if {[winfo exists .pclwindow]} {destroy .pclwindow}
##
## Window Manager
##
    
    toplevel .pclwindow
    wm title .pclwindow [mc "Purchased Lists"]
    wm transient .pclwindow .
    focus -force .pclwindow

    # x = horizontal
    # y = vertical
    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 4 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 4 + [winfo y .]}]

    wm geometry .pclwindow +$locX+$locY
    #set tab3 [ttk::frame $nb.f3.frame1]
    #pack $tab3 -expand yes -fill both -padx 5p -pady 5p
    #
    #set frame2 [ttk::frame $tab3.frame2]
    #pack $frame2 -expand yes -fill both -padx 5p -pady 5p
    
    set frame1 [ttk::frame .pclwindow.frame1]
    pack $frame1 -fill both -expand yes -pady 5p
    
    ttk::label $frame1.pclText -text [mc "Purchased Lists"]
    ttk::combobox $frame1.pclBox -textvariable profile(store,pcl)
    
    grid $frame1.pclText -column 0 -row 0
    grid $frame1.pclBox -column 1 -row 0
    
    # container for listbox
    set pcl [ttk::frame $frame1.listbox]
    pack $pcl -expand yes -fill both
    
    set scrolly $pcl.scrolly
    tablelist::tablelist $pcl.listbox \
                -columns {0  "Item"     center
                        8    "Quantity"  center
                        5    "Price"    center
                        15   "Taxable"   center } \
                -showlabels yes \
                -stretch 0 \
                -height 5 \
                -selectbackground yellow \
                -selectforeground black \
                -stripebackground lightblue \
                -exportselection yes \
                -showseparators yes \
                -fullseparators yes \
                -editstartcommand nextgenrm_GUI::startCmd \
                -editendcommand nextgenrm_GUI::endCmd \
                -yscrollcommand [list $scrolly set]
        
        $pcl.listbox columnconfigure 0 -name item \
                                            -editable yes \
                                            -editwindow ttk::entry
        
        $pcl.listbox columnconfigure 1 -name quantity \
                                            -editable yes \
                                            -editwindow ttk::entry
        
        $pcl.listbox columnconfigure 2 -name price \
                                            -editable yes \
                                            -editwindow ttk::entry
        
        $pcl.listbox columnconfigure 3 -name taxable \
                                            -editable yes \
                                            -editwindow ttk::combobox
        
        # Create the first line
        $pcl.listbox insert end ""
        
        ttk::scrollbar $scrolly -orient v -command [list $pcl.listbox yview]
        
        grid $pcl.listbox -column 0 -row 0 -sticky news
        grid $scrolly -column 1 -row 0 -sticky ns

        # This is needed so the scrollbar displays properly
        grid columnconfigure    $pcl 0 -weight 1
        grid rowconfigure       $pcl 0 -weight 1
        
        ::autoscroll::autoscroll $scrolly ;# Enable the 'autoscrollbar'
        
# Separator Frame
    set sep_frame1 [ttk::frame .pclwindow.sep_frame1]
    ttk::separator $sep_frame1.separator -orient horizontal

    grid $sep_frame1.separator - -ipadx 1i
    pack $sep_frame1
    
# Button frame
    set button_frame [ttk::frame .pclwindow.button]
    pack $button_frame -side right
    
    ttk::button $button_frame.close -text [mc "Close"] -command {destroy .add}
    grid $button_frame.close -column 0 -row 0 -padx 5p -pady 5p
}


proc nextgenrm_GUI::startCmd {tbl row col text} { 
    #****f* startCmd/nextgenrm_GUI
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Configuration options when the user enters the listbox
    #
    # SYNOPSIS
    #	N/A
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
    
        set w [$tbl editwinpath]
        
        #'debug index: [$w index bottom]
        
        switch -- [$tbl columncget $col -name] {
            quantity {
                # Allow only 2 numbers
                $w configure -invalidcommand bell \
                              -validate key \
                              -validatecommand {expr {[string length %P] <= 2 && [regexp {^[0-9]*$} %S]}}
            }
            price {
                # Allow only 4 numbers, and the . character. (ex. 1.04)
                $w configure -invalidcommand bell \
                              -validate key \
                              -validatecommand {expr {[string length %P] <= 4 && [regexp {^[0-9.]*$} %S]}}
            }
            taxable {
                # Populate and make it readonly, and insert another line.
                $w configure -values {"Tax (Food)" "Tax (Other)" None} -state readonly

                'debug INDEX: [expr {[$tbl index end] - 1}] # Using index-end, and subtracting 1
                'debug INDEX: [$tbl index end] # Using the standard index-end
                'debug ROW: $row # If row and INDEX-end match, insert a row.
                set myRow [expr {[$tbl index end] - 1}]
                if {$row == 0} {$tbl insert end ""; 'debug Inserting 2nd Row}
                # See tablelist help for using 'end' as an index point.
                if {($row != 0) && ($row == $myRow)} {$tbl insert end ""; 'debug Inserting Row}
                }
            default {}
        }
        
        #'debug Text: $text
        return $text
}


proc nextgenrm_GUI::endCmd {tbl row col text} { 
    #****f* endCmd/nextgenrm_GUI
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Configuration options when the user leaves the listbox
    #
    # SYNOPSIS
    #	N/A
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
    global internal
   
    set w [$tbl editwinpath]
    
    switch -- [$tbl columncget $col -name] {
            taxable {
                # Set the current row at the last column (Taxable) so we have an accurate row count.
                incr internal(table,currentRow)
                }
            default {}
    }
    return $text
    
}