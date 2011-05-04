# Creator: Casey Ackels (C) 2006 - 2007
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

package provide shipping 1.0


namespace eval Shipping_Gui {

proc shippingGUI {} {
    #****f* shippingGUI/Shipping_Gui
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2006 - 2008 - Casey Ackels
    #
    # FUNCTION
    #	Builds the GUI of the shipping Module, with bindings
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	blueSquirrel::parentGUI
    #
    # NOTES
    #	None
    #
    # SEE ALSO
    #	TODO: List the other *GUI procs.
    #
    #***
    global GI_textVar GS_textVar frame1 frame2b genResults GS_windows
    
    # Destroy frames
    # NOTE: GS_windows is set in core_gui.tcl
    if {[winfo exists .frame1]} {
        foreach window $GS_windows {
            destroy $window
        }
    }
    
    wm title . "Box Labels"

# Frame 1
    set frame1 [ttk::labelframe .container.frame1 -text "Label Information"]
    pack $frame1 -expand yes -fill both -padx 5p -pady 3p -ipady 2p ;#-ipadx 5p
    
    
    ttk::label $frame1.text1 -text "Line 1"
    ;# NOTE: We populate the *(history) variable just under [openHistory]
    ttk::combobox $frame1.entry1 -textvariable GS_textVar(line1) \
                                -values $GS_textVar(history)
                                ;#-width 43
    
    ttk::label $frame1.text2 -text "Line 2"
    ttk::entry $frame1.entry2 -textvariable GS_textVar(line2) ;#-width 43
  
    ttk::label $frame1.text3 -text "Line 3"
    ttk::entry $frame1.entry3 -textvariable GS_textVar(line3) ;#-width 43
    
    ttk::label $frame1.text4 -text "Line 4"
    ttk::entry $frame1.entry4 -textvariable GS_textVar(line4) ;#-width 43
    
    ttk::label $frame1.text5 -text "Line 5"
    ttk::entry $frame1.entry5 -textvariable GS_textVar(line5) ;#-width 43
    
    # With ttk widgets, we need to populate the variables or else we get an error. :(
    foreach num {1 2 3 4 5} {
        set GS_textVar(line$num) ""
    }
    

    grid $frame1.text1 -column 0 -row 2 -sticky nes -padx 5p
    grid $frame1.entry1 -column 1 -row 2 -sticky news -pady 2p -padx 5p
    
    grid $frame1.text2 -column 0 -row 3 -sticky nes -padx 5p
    grid $frame1.entry2 -column 1 -row 3 -sticky news -pady 2p -padx 5p

    grid $frame1.text3 -column 0 -row 4 -sticky nes -padx 5p
    grid $frame1.entry3 -column 1 -row 4 -sticky news -pady 2p -padx 5p
    
    grid $frame1.text4 -column 0 -row 5 -sticky nes -padx 5p
    grid $frame1.entry4 -column 1 -row 5 -sticky news -pady 2p -padx 5p
    
    grid $frame1.text5 -column 0 -row 6 -sticky nes -padx 5p
    grid $frame1.entry5 -column 1 -row 6 -sticky news -pady 2p -padx 5p
    
    grid columnconfigure $frame1 1 -weight 1
    focus $frame1.entry1
    
# Frame 2 (This is a container for two frames)
    set frame2 [ttk::labelframe .container.frame2 -text "Shipment Information"]
    pack $frame2 -expand yes -fill both -padx 5p -pady 1p -ipady 2p
    
    # Child frame
    set frame2a [ttk::frame $frame2.frame2a]
    grid $frame2a -column 0 -row 0 -sticky news -padx 5p -pady 2p
    grid columnconfigure $frame2 $frame2a -weight 1
    
    ttk::label $frame2a.text -text "Max. Qty per Box"
    ttk::entry $frame2a.entry -textvariable GS_textVar(maxBoxQty) \
                        -width 25 \
                        -validate key \
                        -validatecommand {Shipping_Code::filterKeys %S}

    ttk::label $frame2a.text1 -text "Quantity / Shipments" 
    ttk::entry $frame2a.entry1 -textvariable GS_textVar(destQty) \
                        -width 15 \
                        -validate key \
                        -validatecommand {Shipping_Code::filterKeys %S}

    ttk::entry $frame2a.entry2 -textvariable GS_textVar(batch) \
                        -width 5 \
                        -validate key \
                        -validatecommand {Shipping_Code::filterKeys %S}
    set GS_textVar(batch) ""
                        
                        
                        
    ttk::button $frame2a.add -text "Add to List" -command {
            ;# Guard against the user inadvertantly hitting <Enter> or "Add" button without anything in the entry fields
            if {[info exists GS_textVar(destQty)] eq 0} {return}
            
            Shipping_Code::addMaster $GS_textVar(destQty) $GS_textVar(batch)
    }
    
    grid $frame2a.text -column 0 -row 0
    grid $frame2a.entry -column 1 -row 0 -columnspan 2 -sticky news -padx 3p -pady 2p
    #grid columnconfigure $frame2a $frame2a.entry -weight 1
    
    grid $frame2a.text1 -column 0 -row 1 -sticky w
    grid $frame2a.entry1 -column 1 -row 1 -sticky ew -padx 2p -pady 2p
    grid $frame2a.entry2 -column 2 -row 1 -sticky ew -padx 4p -pady 2p
    
    grid $frame2a.add -column 3 -row 1 -sticky nes -padx 5p
    tooltip::tooltip $frame2a.add "Add to List (Enter)"
    

    
# Frame 2b
    # Child frame
    set frame2b [ttk::frame $frame2.frame2b]
    grid $frame2b -column 0 -row 1 -sticky news -padx 5p -pady 3p
    
    tablelist::tablelist $frame2b.listbox -columns {2 "Count" 0 "Shipments"} \
                -showlabels yes \
                -stretch all \
                -height 5 \
                -selectbackground yellow \
                -selectforeground black \
                -stripebackground lightblue \
                -exportselection yes \
                -showseparators yes \
                -yscrollcommand [list $frame2b.scrolly set]
    
        $frame2b.listbox columnconfigure 0 -showlinenumbers 1 \
                                            -labelalign center \
                                            -align center
    
        # This is not in use now because we need to figure out how to update the ToolTip to reflect changes.
        #$frame2b.listbox columnconfigure 1 -editable yes \
                                            -editwindow ttk::entry
    
    ttk::scrollbar $frame2b.scrolly -orient v -command [list $frame2b.listbox yview]
    
    grid $frame2b.listbox -column 0 -row 0 -sticky news
    grid columnconfigure $frame2b $frame2b.listbox -weight 1
    
    grid $frame2b.scrolly -column 1 -row 0 -sticky nse
    
    ::autoscroll::autoscroll $frame2b.scrolly ;# Enable the 'autoscrollbar'
    # Tooltip: The tooltip code is in shippin_code.tcl, in the displayListHelper proc.
    

#Frame3
    #set frame3 [ttk::labelframe .container.frame3 -text "Did you know?" -width 4.5i -labelanchor nw]
    set frame3 [ttk::frame .container.frame3]
    pack $frame3 -side right -padx 5p -pady 5p

    ttk::checkbutton $frame3.checkbutton -text "Print Manifest?" -variable printManifest

    grid $frame3.checkbutton -column 0 -row 0 -sticky nse
   

##
## - Bindings
##

;# The ttk way, to change the background
ttk::style map TCombobox -fieldbackground [list focus yellow]
ttk::style map TEntry -fieldbackground [list focus yellow]



foreach window "$frame2a.add $frame2a.entry1 $frame2a.entry2" {
    bind $window <Return> {
        ;# Guard against the user inadvertantly hitting <Enter> or "Add" button without anything in the entry fields
        if {[info exists GS_textVar(destQty)] eq 0} {return}
        Shipping_Code::addMaster $GS_textVar(destQty) $GS_textVar(batch)

    }
}


foreach window "entry1 entry2 entry3 entry4 entry5" {
    ;# Insert the current month
    bind $frame1.$window <Control-KeyPress-m-> "
        $frame1.$window insert insert {[clock format [clock seconds] -format %B]}
    "
    
    ;# Insert the next month (i.e. this month is October, next month is November)
    bind $frame1.$window <Control-KeyPress-n> "
        $frame1.$window insert insert {[clock format [clock scan month] -format %B]}
    "
    
    ;# Insert the current year
    bind $frame1.$window <Control-KeyPress-y> "
        $frame1.$window insert insert {[clock format [clock seconds] -format %Y]}
    "
    
    ;# Bind the Enter key to traverse through the entry fields like <Tab>
    bind $frame1.$window <Return> {tk::TabToWindow [tk_focusNext %W]}
    bind $frame1.$window <Shift-Return> {tk::TabToWindow [tk_focusPrev %W]}
    
    bind $frame1.$window <Control-KeyPress-k> {%W delete 0 end}
    bind $frame1.$window <ButtonPress-3> {tk_popup .editPopup %X %Y}

}


bind [$frame2b.listbox bodytag] <KeyPress-BackSpace> {
    $frame2b.listbox delete [$frame2b.listbox curselection]
        
    ;# Make sure we keep all the textvars updated when we delete something
    Shipping_Code::addListboxNums ;# Add everything together for the running total
    Shipping_Code::createList ;# Make sure our totals add up
}


bind [$frame2b.listbox bodytag] <Double-1> {
    #puts "selection2: [$frame2b.listbox curselection]"

    $frame2b.listbox delete [$frame2b.listbox curselection]
    
    # Make sure we keep all the textvars updated when we delete something
    Shipping_Code::addListboxNums ;# Add everything together for the running total
    # If we don't have the [catch] here, then we will get an error if we remove the last entry.
    # cell index "0,1" out of range
    catch {Shipping_Code::createList} err ;# Make sure our totals add up
    #puts "binding-Double1: $err"
}



bind all <<ComboboxSelected>> {
    Shipping_Code::readHistory [$frame1.entry1 current]
}


bind all <Escape> {exit}
bind all <F1> {console show}
bind all <F2> {console hide}

} ;# End of shippingGUI

proc breakDown {} {
    #****f* breakDown/Shipping_Gui
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Displays the breakdown per boxes. (I.E. 5 Boxes at 50, 3 Boxes at 25)
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	blueSquirrel::parentGUI, Shipping_Code::createList
    #
    # NOTES
    #	None
    #
    # SEE ALSO
    #	TODO: List the other *GUI procs.
    #
    #***
    global GS_textVar GS_widget
    
    if {![winfo exists .breakdown]} {
        toplevel .breakdown
        wm title .breakdown "Break Down"
    
        text .breakdown.txt
        set GS_widget(breakdown) .breakdown.txt
        ttk::button .breakdown.refresh -text "Refresh" -command { Shipping_Gui::breakDown }
    
        pack $GS_widget(breakdown)
        pack .breakdown.refresh
        focus $GS_widget(breakdown)
    
        bind $GS_widget(breakdown) <KeyPress> {break} ;# Prevent people from entering/removing anything
        #bind $GS_widget(breakdown) <Button-1> {break} ;# Prevent people from entering/removing anything
    
    } else {
        # Refreshing
        .breakdown.txt delete 0.0 end       
    }
    

    # This is the overview.
    # Make sure the variable exists and that it contains a value
    if {([info exists GS_textVar(labelsFull)] == 1) && ($GS_textVar(labelsFull) != "")} {
        # Make sure that it has 2 or more values
        if {[llength $GS_textVar(labelsFull)] >= 2} {
            puts "LabelsFull <=: $GS_textVar(labelsFull)"
            $GS_widget(breakdown) insert end "Full Boxes: [expr [join $GS_textVar(labelsFull) +]]\n"
        } else {
            # If we have less than 2 values, just insert what the full boxes are.
            $GS_widget(breakdown) insert end "Full Boxes: $GS_textVar(labelsFull)\n"
        }
    }

    # Like Numbers
    if {[info exists GS_textVar(labelsPartialLike)] == 1} {
        foreach value $GS_textVar(labelsPartialLike) {
            $GS_widget(breakdown) insert end "Partial: $value\n"
        }
    }
    
    # Unique Numbers
    if {[info exists GS_textVar(labelsPartialUnique)] == 1} {
        foreach value $GS_textVar(labelsPartialUnique) {
            $GS_widget(breakdown) insert end "Partial: 1 Label @ $value\n"
        }
    }
    

} ;# End of breakDown
} ;# End of Shipping_Gui namespace