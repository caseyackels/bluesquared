# Creator: Casey Ackels (C) 2006 - 2007
# Initial Date: October 28th, 2006
# Massive Rewrite: February 2nd, 2007
# Version: See shipping_launch_code.tcl
# Dependencies: See shipping_launch_code.tcl
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
# This file holds the window for the Shipping Mode.

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

package provide boxlabels 1.0


namespace eval Shipping_Gui {

proc shippingGUI {} {
    #****f* shippingGUI/Shipping_Gui
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2006-2013 - Casey Ackels
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
    global GI_textVar GS_textVar frame1 frame2b genResults GS_windows program
    
    Shipping_Code::openHistory ;# Populate the variable so we don't get errors upon startup.
    
    wm geometry . 450x475
    #set program(currentModule) BoxLabels
    #set currentModule BoxLabels

    # Clear the frames before continuing
    eAssist_Global::resetFrames parent


# Frame 1
    set frame1 [ttk::labelframe .container.frame1 -text "Label Information"]
    pack $frame1 -expand yes -fill both -padx 5p -pady 3p -ipady 2p


    ttk::label $frame1.text1 -text "Line 1"
    ;# NOTE: We populate the *(history) variable just under [openHistory]
    ttk::combobox $frame1.entry1 -textvariable GS_textVar(line1) \
                                -values $GS_textVar(history) \
                                -validate key \
                                -validatecommand {Shipping_Code::filterKeys -textLength %S %W %P}
    ttk::label $frame1.data1 -textvariable lineText(data1) -width 2
    tooltip::tooltip $frame1.data1 "33 Chars Max."

    ttk::label $frame1.text2 -text "Line 2"
    ttk::entry $frame1.entry2 -textvariable GS_textVar(line2) \
                            -validate key \
                            -validatecommand {Shipping_Code::filterKeys -textLength %S %W %P} ;#-width 33
    ttk::label $frame1.data2 -textvariable lineText(data2) -width 2

    ttk::label $frame1.text3 -text "Line 3"
    ttk::entry $frame1.entry3 -textvariable GS_textVar(line3) \
                            -validate key \
                            -validatecommand {Shipping_Code::filterKeys -textLength %S %W %P} ;#-width 33
    ttk::label $frame1.data3 -textvariable lineText(data3) -width 2

    ttk::label $frame1.text4 -text "Line 4"
    ttk::entry $frame1.entry4 -textvariable GS_textVar(line4) \
                            -validate key \
                            -validatecommand {Shipping_Code::filterKeys -textLength %S %W %P} ;#-width 33
    ttk::label $frame1.data4 -textvariable lineText(data4) -width 2

    ttk::label $frame1.text5 -text "Line 5"
    ttk::entry $frame1.entry5 -textvariable GS_textVar(line5) \
                            -validate key \
                            -validatecommand {Shipping_Code::filterKeys -textLength %S %W %P}
    ttk::label $frame1.data5 -textvariable lineText(data5) -width 2

    # With ttk widgets, we need to populate the variables or else we get an error. :(
    foreach num {1 2 3 4 5} {
        set GS_textVar(line$num) ""
    }


    grid $frame1.text1 -column 0 -row 2 -sticky nes -padx 5p
    grid $frame1.entry1 -column 1 -row 2 -sticky news -pady 2p -padx 4p
    grid $frame1.data1 -column 2 -row 2 -sticky nws -padx 3p

    grid $frame1.text2 -column 0 -row 3 -sticky nes -padx 5p
    grid $frame1.entry2 -column 1 -row 3 -sticky news -pady 2p -padx 4p
    grid $frame1.data2 -column 2 -row 3 -sticky nws -padx 3p

    grid $frame1.text3 -column 0 -row 4 -sticky nes -padx 5p
    grid $frame1.entry3 -column 1 -row 4 -sticky news -pady 2p -padx 4p
    grid $frame1.data3 -column 2 -row 4 -sticky nws -padx 3p

    grid $frame1.text4 -column 0 -row 5 -sticky nes -padx 5p
    grid $frame1.entry4 -column 1 -row 5 -sticky news -pady 2p -padx 4p
    grid $frame1.data4 -column 2 -row 5 -sticky nws -padx 3p

    grid $frame1.text5 -column 0 -row 6 -sticky nes -padx 5p
    grid $frame1.entry5 -column 1 -row 6 -sticky news -pady 2p -padx 4p
    grid $frame1.data5 -column 2 -row 6 -sticky nws -padx 3p

    grid columnconfigure $frame1 1 -weight 2
    focus $frame1.entry1

# Frame 2 (This is a container for two frames)
    set frame2 [ttk::labelframe .container.frame2 -text "Shipment Information"]
    pack $frame2 -expand yes -fill both -padx 5p -pady 1p -ipady 2p

    # Frame for Entry fields
    set frame2a [ttk::frame $frame2.frame2a]
    grid $frame2a -column 0 -row 0 -sticky news -padx 5p -pady 2p
    grid columnconfigure $frame2 $frame2a -weight 1

    ttk::label $frame2a.text -text "Max. Qty per Box"
    ttk::entry $frame2a.entry -textvariable GS_textVar(maxBoxQty) \
                        -width 25 \
                        -validate key \
                        -validatecommand {Shipping_Code::filterKeys -numeric %S %W %P}

    ttk::label $frame2a.text1 -text "Shipments"
    ttk::entry $frame2a.entry1 -textvariable GS_textVar(batch) \
                        -width 5 \
                        -validate key \
                        -validatecommand {Shipping_Code::filterKeys -numeric %S %W %P}
    set GS_textVar(batch) ""


    ttk::label $frame2a.text2 -text "Quantity"
    ttk::entry $frame2a.entry2 -textvariable GS_textVar(destQty) \
                        -width 15 \
                        -validate key \
                        -validatecommand {Shipping_Code::filterKeys -numeric %S %W %P}

    set GS_textVar(shipvia) Freight
    ttk::combobox $frame2a.cbox -textvar GS_textVar(shipvia) \
                                -width 7 \
                                -values [list "Freight" "Import"]
                                #-validate key \
                                #-validatecommand {Shipping_Code::filterKeys -textLength %S %W %P}


    ttk::button $frame2a.add -text "Add to List" -command {
            ;# Guard against the user inadvertantly hitting <Enter> or "Add" button without anything in the entry fields
            if {([info exists GS_textVar(destQty)] eq 0) || ($GS_textVar(destQty) eq "")} {return}

            Shipping_Code::addMaster $GS_textVar(destQty) $GS_textVar(batch) $GS_textVar(shipvia)
    }

    grid $frame2a.text -column 0 -row 0 -sticky e
    grid $frame2a.entry -column 1 -row 0 -columnspan 2 -sticky w -padx 3p -pady 2p
    #grid columnconfigure $frame2a $frame2a.entry -weight 1

    grid $frame2a.text1 -column 0 -row 1 -sticky e
    grid $frame2a.entry1 -column 1 -row 1 -columnspan 2 -sticky w -padx 3p -pady 2p

    grid $frame2a.text2 -column 0 -row 2 -sticky e
    grid $frame2a.entry2 -column 1 -row 2 -sticky w -padx 3p
    grid $frame2a.cbox -column 2 -row 2

    grid $frame2a.add -column 3 -row 2 -sticky nes -padx 5p
    tooltip::tooltip $frame2a.add "Add to List (Enter)"



# Frame 2b
    # Frame for data display
    set frame2b [ttk::frame $frame2.frame2b]
    grid $frame2b -column 0 -row 1 -sticky news -padx 5p -pady 3p

    tablelist::tablelist $frame2b.listbox -columns {
                                                    3   "..."       center
                                                    0   "Shipments" center
                                                    0   "Ship Via"  center
                                                    } \
                                        -showlabels yes \
                                        -height 5 \
                                        -selectbackground yellow \
                                        -selectforeground black \
                                        -stripebackground lightblue \
                                        -exportselection yes \
                                        -showseparators yes \
                                        -fullseparators yes \
                                        -yscrollcommand [list $frame2b.scrolly set]

        $frame2b.listbox columnconfigure 0 -showlinenumbers 1 \
                                            -name count

        $frame2b.listbox columnconfigure 1 -name shipments

        $frame2b.listbox columnconfigure 2 -name shipvia


    ttk::scrollbar $frame2b.scrolly -orient v -command [list $frame2b.listbox yview]

    grid $frame2b.listbox -column 0 -row 0 -sticky news
    grid columnconfigure $frame2b $frame2b.listbox -weight 1

    grid $frame2b.scrolly -column 1 -row 0 -sticky nse

    ::autoscroll::autoscroll $frame2b.scrolly ;# Enable the 'autoscrollbar'
    # Tooltip: The tooltip code is in shipping_code.tcl, in the displayListHelper proc.


##
## - Bindings
##

;# The ttk way, to change the background
ttk::style map TCombobox -fieldbackground [list focus yellow]
ttk::style map TEntry -fieldbackground [list focus yellow]

bind $frame2a.entry <KeyPress-Down> {tk::TabToWindow [tk_focusNext %W]}
bind $frame2a.entry <KeyPress-Up> {tk::TabToWindow [tk_focusPrev %W]}

foreach window "$frame2a.add $frame2a.entry1 $frame2a.entry2" {
    bind $window <KeyPress-Right> {tk::TabToWindow [tk_focusNext %W]}
    bind $window <KeyPress-Left> {tk::TabToWindow [tk_focusPrev %W]}
    bind $window <KeyPress-Up> {tk::TabToWindow [tk_focusPrev %W]}
    bind $window <KeyPress-Down> {tk::TabToWindow [tk_focusPrev %W]}

    bind $window <Return> {
        ;# Guard against the user inadvertantly hitting <Enter> or "Add" button without anything in the entry fields
        if {([info exists GS_textVar(destQty)] eq 0) || ($GS_textVar(destQty) eq "")} {return}
        Shipping_Code::addMaster $GS_textVar(destQty) $GS_textVar(batch) $GS_textVar(shipvia)
    }
}

bind $frame1.entry1 <KeyRelease> {
    if {[string length $GS_textVar(line1)] != 0} {
        set lineText(data1) [string length $GS_textVar(line1)]
        } else {
            set lineText(data1) ""
    }
}

#bind $frame1.entry1 <Control-KeyPress-M> {%W insert end "[string toupper [clock format [clock seconds] -format %%B]] "}

bind $frame1.entry2 <KeyRelease> {
    if {[string length $GS_textVar(line2)] != 0} {
        set lineText(data2) [string length $GS_textVar(line2)]
        } else {
            set lineText(data2) ""
    }
}

bind $frame1.entry3 <KeyRelease> {
    if {[string length $GS_textVar(line3)] != 0} {
        set lineText(data3) [string length $GS_textVar(line3)]
        } else {
            set lineText(data3) ""
    }
}
bind $frame1.entry4 <KeyRelease> {
    if {[string length $GS_textVar(line4)] != 0} {
        set lineText(data4) [string length $GS_textVar(line4)]
        } else {
            set lineText(data4) ""
    }
}
bind $frame1.entry5 <KeyRelease> {
    if {[string length $GS_textVar(line5)] != 0} {
        set lineText(data5) [string length $GS_textVar(line5)]
        } else {
            set lineText(data5) ""
    }
}

foreach window [list 1 2 3 4 5] {
    # We must use %% because the %b identifier is used by [bind] and [clock format]
    ;# Insert the current month
    bind $frame1.entry$window <Control-KeyPress-M> {
        %W insert end "[string toupper [clock format [clock seconds] -format %%B]] "
    }

    ;# Insert the next month (i.e. this month is October, next month is November)
    bind $frame1.entry$window <Control-KeyPress-N> {
        %W insert end "[string toupper [clock format [clock scan month] -format %%B]] "
    }

    ;# Insert the current year
    bind $frame1.entry$window <Control-KeyPress-Y> {
        %W insert end "[string toupper [clock format [clock seconds] -format %%Y]] "
    }

    ;# Bind the Enter key to traverse through the entry fields like <Tab>
    bind $frame1.entry$window <Return> {tk::TabToWindow [tk_focusNext %W]}

    bind $frame1.entry$window <KeyPress-Down> {tk::TabToWindow [tk_focusNext %W]}

    bind $frame1.entry$window <Shift-Return> {tk::TabToWindow [tk_focusPrev %W]}
    bind $frame1.entry$window <KeyPress-Up> {tk::TabToWindow [tk_focusNext %W]}

    bind $frame1.entry$window <Control-KeyPress-D> {%W delete 0 end}

    bind $frame1.entry$window <ButtonPress-3> {tk_popup .editPopup %X %Y}
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



#bind all <<ComboboxSelected>> {
#    Shipping_Code::readHistory [$frame1.entry1 current]
#    $frame1.entry1 configure -values $GS_textVar(history) ;# Refresh the data in the comobobox
#}

bind $frame1.entry1 <<ComboboxSelected>> {
    Shipping_Code::readHistory [$frame1.entry1 current]
    $frame1.entry1 configure -values $GS_textVar(history) ;# Refresh the data in the comobobox
}




bind all <Escape> {exit}
bind all <F1> {console show}
bind all <F2> {console hide}


Shipping_Gui::initMenu
Shipping_Gui::initVariables

   
} ;# End of shippingGUI

proc printbreakDown {args} {
    #****f* printbreakDown/Shipping_Gui
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
    global GS_textVar mySettings log
    
    if {![info exists mySettings(path,printer)]} {
        ${log}::debug Path to printer does not exist. Exiting...
        return
    }
    if {![info exists mySettings(path,wordpad)]} {
        ${log}::debug Path to WordPad does not exist. Exiting...
        return
    }
    if {![info exists mySettings(path,bdfile)]} {
        ${log}::debug Path to the BreakDown file does not exist. Exiting...
        return
    }
    
    # Guard against the possiblity that the breakdown window has never been launched.
    # If it doesn't exist, lets launch it, then immediately hide it.
    if {![winfo exists .breakdown]} {
        breakDown
        wm withdraw .breakdown
    }
        
    set myBreakDownText [.breakdown.frame1.txt get 0.0 end]
    set file [open [file join $mySettings(Home) $mySettings(path,bdfile)] w]

    puts $file [clock format [clock scan now] -format "%A %B %d %r"]\n
    puts $file $GS_textVar(line1)
    puts $file $GS_textVar(line2)
    puts $file $GS_textVar(line3)
    puts $file $GS_textVar(line4)
    puts $file $GS_textVar(line5)\n
    puts $file $myBreakDownText

    chan close $file


    
    if {$args eq "email"} {
        ##
        ## Email
        ##
        mail::mail "$GS_textVar(line1)" "$GS_textVar(line1)\n$GS_textVar(line2)\n$GS_textVar(line3)\n$GS_textVar(line4)\n$GS_textVar(line5)\n\n$myBreakDownText"
        ${log}::debug [list $GS_textVar(line1) $GS_textVar(line2) $myBreakDownText]
    } else {
        ##
        ## Email
        ##
        mail::mail "$GS_textVar(line1)" "$GS_textVar(line1)\n$GS_textVar(line2)\n$GS_textVar(line3)\n$GS_textVar(line4)\n$GS_textVar(line5)\n\n$myBreakDownText"
        ${log}::debug [list $GS_textVar(line1) $GS_textVar(line2) $myBreakDownText]
        
        ##
        ## Print the breakdown
        ## 
        #catch {exec [file join C:\\ "Program Files" "Windows NT" Accessories wordpad.exe] /pt breakdown.txt {\\vm-printserver\Shipping-Time}}
        ${log}::debug [file join $mySettings(path,wordpad)] /pt [file join $mySettings(Home) $mySettings(path,bdfile)] "$mySettings(path,printer)"
        catch {exec [file join $mySettings(path,wordpad)] /pt [file join $mySettings(Home) $mySettings(path,bdfile)] "$mySettings(path,printer)"} 
    }
    

    
} ;# End of printbreakDown


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
    global GS_textVar GS_widget GS_winGeom log
    
    ${log}::debug Creating Breakdown window ...

    if {![winfo exists .breakdown]} {
        toplevel .breakdown
        wm title .breakdown "Break Down"

        puts "winfo geom: [winfo geometry .]"
        wm geometry .breakdown +854+214

        ${log}::debug Breadown window Created...


        set frame1 [ttk::frame .breakdown.frame1]
        pack $frame1 -fill both -expand yes -pady 5p

        set GS_widget(breakdown) $frame1.txt
        text $frame1.txt -width 30 \
                -xscrollcommand [list $frame1.scrollx set] \
                -yscrollcommand [list $frame1.scrolly set]
        
        # setup the autoscroll bars
        ttk::scrollbar $frame1.scrollx -orient h -command [list $frame1.txt xview]
        ttk::scrollbar $frame1.scrolly -orient v -command [list $frame1.txt yview]
       
        grid $frame1.txt -column 0 -row 0 -sticky news -padx 5p
       #grid columnconfigure $frame1 $frame1.txt -weight 1

        grid $frame1.scrolly -column 1 -row 0 -sticky nse
        grid $frame1.scrollx -column 0 -row 1 -sticky ews

        ::autoscroll::autoscroll $frame1.scrollx ;# Enable the 'autoscrollbar'
        ::autoscroll::autoscroll $frame1.scrolly ;# Enable the 'autoscrollbar'



        set frame2 [ttk::frame .breakdown.frame2]
        pack $frame2 -pady 10p -anchor se

        ttk::button $frame2.print -text [mc "Print"] -command {Shipping_Gui::printbreakDown}
        ttk::button $frame2.close -text [mc "Close"] -command {destroy .breakdown}

        grid $frame2.print -column 0 -row 0 -padx 3p
        grid $frame2.close -column 1 -row 0 -padx 5p


        bind $GS_widget(breakdown) <KeyPress> {break} ;# Prevent people from entering/removing anything
        ${log}::debug Breakdown window - 1st time ...

    } else {
        if {![winfo ismapped .breakdown]} {
            # Display the window
            wm deiconify .breakdown
            
            ${log}::debug Breakdown window - all ready mapped ...
        }
        
        # Refreshing
        .breakdown.frame1.txt delete 0.0 end
    }


    # This is the overview.
    # Make sure the variable exists and that it contains a value
    if {([info exists GS_textVar(labelsFull)] == 1) && ($GS_textVar(labelsFull) != "")} {
        # Make sure that it has 2 or more values
        if {[llength $GS_textVar(labelsFull)] >= 2} {
            puts "LabelsFull <=: $GS_textVar(labelsFull)"
            $GS_widget(breakdown) insert end "Full Boxes:\n"
            $GS_widget(breakdown) insert end "-----------\n"
            $GS_widget(breakdown) insert end "[expr [join $GS_textVar(labelsFull) +]] @ $GS_textVar(maxBoxQty)\n"
        } else {
            # If we have less than 2 values, just insert what the full boxes are.
            $GS_widget(breakdown) insert end "Full Box:\n"
            $GS_widget(breakdown) insert end "---------\n"
            $GS_widget(breakdown) insert end "$GS_textVar(labelsFull) @ $GS_textVar(maxBoxQty)\n"
        }
    }

    # Like Numbers
    if {([info exists GS_textVar(labelsPartialLike)] == 1) && ($GS_textVar(labelsPartialLike) != "")} {
            $GS_widget(breakdown) insert end "\nPartial:\n"
            $GS_widget(breakdown) insert end "--------\n"

        foreach value $GS_textVar(labelsPartialLike) {
            $GS_widget(breakdown) insert end "$value\n"
        }
    }

    # Unique Numbers
    if {([info exists GS_textVar(labelsPartialUnique)] == 1) && ($GS_textVar(labelsPartialUnique) != "")} {
            $GS_widget(breakdown) insert end "\nPartial (Unique):\n"
            $GS_widget(breakdown) insert end "-----------------\n"

        foreach value $GS_textVar(labelsPartialUnique) {
            $GS_widget(breakdown) insert end "1 Box @ $value\n"
        }
    }

} ;# End of breakDown


proc chooseLabel {lines} {
    #****f* chooseLabel/Shipping_Gui
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	If the text "Seattle Met" is detected, we launch this window so that use can choose what type of label they want to use.
    #
    # SYNOPSIS
    #	chooseLabel $line (Where line is a value between 1 and 6; referring to how many lines the label is using)
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #
    #
    # NOTES
    #	None
    #
    # SEE ALSO
    #
    #
    #***
    global log GS_textVar GS_widget

    toplevel .chooseLabel
    wm title .chooseLabel "Choose your Label"
    wm transient .chooseLabel .
    ${log}::debug Using lines: $lines

    # x = horizontal
    # y = vertical
    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]

    wm geometry .chooseLabel +$locX+$locY

    focus .chooseLabel

    set frame0 [ttk::frame .chooseLabel.frame0]
    grid $frame0 -padx 5p -pady 5p

    set labels ""

    ttk::radiobutton $frame0.white -text "White Label - Standard" -variable labels -value LINEDB.btw -command "set lines $lines"
    ttk::radiobutton $frame0.green -text "Green Label - Special" -variable labels -value LINEDB_Seattle.btw -command "set lines $lines"
    #$frame0.white invoke ;# set the default

    grid $frame0.white -column 0 -row 0 -padx 5p -pady 5p -sticky w
    grid $frame0.green -column 0 -row 1 -padx 5p -pady 5p -sticky w

    set frame1 [ttk::frame .chooseLabel.frame1]
    grid $frame1 -padx 5p -pady 5p
    
    ${log}::debug Number of lines to be printed: $lines
   
    ttk::button $frame1.print -text "Print" -command {Shipping_Code::printCustomLabels $lines $labels; destroy .chooseLabel}
    ttk::button $frame1.close -text "Close" -command {destroy .chooseLabel}

    grid $frame1.print -column 0 -row 0 -sticky ne
    grid $frame1.close -column 1 -row 0 -sticky ne


} ;# End of chooseLabel


} ;# End of Shipping_Gui namespace

proc Shipping_Gui::initMenu {} {
    #****f* initMenu/importFiles
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Initialize menus for the Addresses module
    #
    # SYNOPSIS
    #
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
    global log mb
    ${log}::debug --START -- [info level 1]
    
    if {[winfo exists $mb.modMenu.quick]} {
        destroy $mb.modMenu.quick
    }
    
    # Disable menu items
    $mb.file entryconfigure 0 -state disable

    $mb.modMenu delete 0 end
    
    ## Change menu name
    ##$mb entryconfigure Edit -label Distribution
    ## Add cascade
    #menu $mb.modMenu.quick
    #$mb.modMenu add cascade -label [mc "Quick Add"] -menu $mb.modMenu.quick 
    ##$mb.modMenu.quick add command -label [mc "JG Mail"]
    ##$mb.modMenu.quick add command -label [mc "JG Inventory"]
    #
    #$mb.modMenu add separator
    
    $mb.modMenu add command -label [mc "Clear List"] -command {Shipping_Code::clearList}
    $mb.modMenu add command -label [mc "Show Breakdown"] -command {Shipping_Gui::breakDown}
    #$mb.modMenu add command -label [mc "Filters..."] -command {eAssist_tools::FilterEditor} -state disable
    #$mb.modMenu add command -label [mc "Internal Samples"] -command {eAssistHelper::addCompanySamples} -state disable
    ##$mb.modMenu add command -label [mc "Split"] -command {eAssistHelper::splitVersions}
    #
    #$mb.modMenu add separator
    
    $mb.modMenu add command -label [mc "Preferences"] -command {eAssistPref::launchPreferences}
	
    ${log}::debug --END -- [info level 1]
} ;# Shipping_Gui::initMenu