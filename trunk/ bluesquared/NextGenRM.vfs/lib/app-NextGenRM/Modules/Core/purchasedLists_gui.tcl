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
    global purchased

    # Make sure the window has been destroyed before creating.
    if {[winfo exists .pclwindow]} {destroy .pclwindow}
##
## Window Manager
##
    
    toplevel .pclwindow
    wm title .pclwindow [mc "Purchased List Editor"]
    wm transient .pclwindow .
    focus -force .pclwindow

    # x = horizontal
    # y = vertical
    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 15 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 6 + [winfo y .]}]

    wm geometry .pclwindow +$locX+$locY

##
## Frame 1
##    
    set frame1 [ttk::frame .pclwindow.frame1]
    pack $frame1 -fill both -expand yes -pady 8p -padx 5p
    
    #Initialize variable
    set program(purchasedList) ""
    ttk::label $frame1.pclText -text [mc "Purchased Lists"]
        #set purchased(Name) defaultList
    ttk::combobox $frame1.pclBox -textvariable purchased(Name) \
                                    -values $program(purchasedList) \
									-state readonly \
									-postcommand "nextgenrm_Code::showProfiles -comboPCL $frame1.pclBox"
    
    ttk::button $frame1.pclNew -image add16x16 -command {'debug _new New Profile; nextgenrm_GUI::addListWindow pcl .pclwindow}
    ttk::button $frame1.pclRename -image rename16x16 -command {'debug _rename Rename Profile; nextgenrm_GUI::renameListWindow pcl .pclwindow}
    ttk::button $frame1.pclDelete -image del16x16 -command {'debug _delete Delete Profile}
    
    grid $frame1.pclText -column 0 -row 0 -padx 3p -pady 2p -sticky w
    grid $frame1.pclBox -column 1 -row 0 -padx 2p -pady 2p -sticky news
    grid $frame1.pclNew -column 2 -row 0 -padx 2p -pady 2p
    grid $frame1.pclRename -column 3 -row 0 -padx 2p -pady 2p
    grid $frame1.pclDelete -column 4 -row 0 -padx 2p -pady 2p
    
    
    set pcl [ttk::frame .pclwindow.frame2]
    pack $pcl -fill both -expand yes -padx 5p
    
    set scrolly $pcl.scrolly
    tablelist::tablelist $pcl.listbox \
                -columns {
                        15  "Item"    left
                        5    "Price"    center
                        15   "Taxable"  center
                        } \
                -showlabels yes \
                -stretch 0 \
                -height 15 \
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
                                            -labelalign center \
                                            -editable yes \
                                            -editwindow ttk::entry
        
        $pcl.listbox columnconfigure 1 -name price \
                                            -editable yes \
                                            -editwindow ttk::entry
        
        $pcl.listbox columnconfigure 2 -name taxable \
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
    #set sep_frame1 [ttk::frame .pclwindow.sep_frame1]
    #ttk::separator $sep_frame1.separator -orient horizontal
    #
    #grid $sep_frame1.separator - -ipadx 1i
    #pack $sep_frame1
    
# Button frame   
    set button_frame [ttk::frame .pclwindow.button]
    pack $button_frame -side right
    
    ttk::button $button_frame.ok -text [mc "OK"] -command {nextgenrm_Code::save profile $purchased(Name); destroy .pclwindow}
    ttk::button $button_frame.cancel -text [mc "Cancel"] -command {destroy .pclwindow}
    
    grid $button_frame.ok -column 0 -row 0 -padx 2p -pady 5p
    grid $button_frame.cancel -column 1 -row 0 -padx 5p -pady 5p
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
    global purchased
        set w [$tbl editwinpath]
        
        #'debug index: [$w index bottom]
        
        switch -- [$tbl columncget $col -name] {
            item {
                # 
                $w configure -textvariable purchased($purchased(Name),$row,item)
            }
            price {
                # Allow only 4 numbers, and the . character. (ex. 1.04)
                $w configure -invalidcommand bell \
                              -validate key \
                              -validatecommand {expr {[string length %P] <= 4 && [regexp {^[0-9.]*$} %S]}} \
                                -textvariable purchased($purchased(Name),$row,price)
            }
            taxable {
                # Populate and make it readonly, and insert another line.
                $w configure -values {"Tax (Food)" "Tax (Other)" None} \
                            -state readonly \
                            -textvariable purchased($purchased(Name),$row,tax)

                #'debug INDEX: [expr {[$tbl index end] - 1}] # Using index-end, and subtracting 1
                #'debug INDEX: [$tbl index end] # Using the standard index-end
                #'debug ROW: $row # If row and INDEX-end match, insert a row.
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