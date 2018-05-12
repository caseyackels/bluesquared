# Creator: Casey Ackels (C) 2006 - 2007
# Initial Date: October 28th, 2006
# Massive Rewrite: February 2nd, 2007
# Version: See shipping_launch_code.tcl
# Dependencies: See shipping_launch_code.tcl
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 498 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2015-03-10 10:54:00 -0700 (Tue, 10 Mar 2015) $
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

#package provide boxlabels 1.0
package provide eAssist_ModBoxLabels 1.0

# init the db
eAssist_db::loadDB

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
    global GI_textVar GS_textVar frame1 frame2b genResults GS_windows program job tplLabel
    
    Shipping_Code::openHistory ;# Populate the variable so we don't get errors upon startup.
    
    # Clear the frames before continuing
    eAssist_Global::resetFrames parent
	
    set nbk [ttk::notebook .container.frame0 -padding 5]
    pack $nbk -expand yes -fill both
    
    ttk::notebook::enableTraversal $nbk
    
    #
    # Setup the notebook
    #
    $nbk add [ttk::frame $nbk.boxlabels] -text [mc "Box Labels"]
    $nbk add [ttk::frame $nbk.shipto] -text [mc "Ship To"]

###
### - Box Labels
### 
# Frame 0
	set frame0 [ttk::labelframe $nbk.boxlabels.frame0 -text "Template"]
	pack $frame0 -expand yes -fill both -padx 5p -pady 3p -ipady 2p
	
	set GS_textVar(Template) ""
	grid [ttk::label $frame0.txt1 -text [mc "Template #"]] -column 0 -row 0 -padx 2p -pady 2p
	grid [ttk::entry $frame0.entry -textvariable GS_textVar(Template)] -column 1 -row 0 -padx 2p -pady 2p -sticky w
	grid [ttk::button $frame0.btn -text [mc "Get Data"] -command {ea::db::bl::getTplData $GS_textVar(Template)}] -column 2 -row 0 -padx 2p -pady 2p -sticky w
	
	grid [ttk::label $frame0.txt2a -text [mc "Customer"]] -column 0 -row 1 -padx 2p -pady 2p
	grid [ttk::label $frame0.txt2b -textvariable job(CustName)] -column 1 -columnspan 4 -row 1 -padx 2p -pady 2p -sticky w
	
	grid [ttk::label $frame0.txt3a -text [mc "Job Title"]] -column 0 -row 2 -padx 2p -pady 2p
	grid [ttk::label $frame0.txt3b -textvariable job(Title)] -column 1 -columnspan 4 -row 2 -padx 2p -pady 2p -sticky w
	
	grid [ttk::label $frame0.txt4a -text [mc "Label Path"]] -column 0 -row 3 -padx 2p -pady 2p
	grid [ttk::label $frame0.txt4b -textvariable tplLabel(LabelPath)] -column 1 -columnspan 4 -row 3 -padx 2p -pady 2p ;#-sticky w
	#grid [ttk::entry $frame0.txt4b -textvariable tplLabel(LabelPath)] -column 1 -columnspan 4 -row 3 -padx 2p -pady 2p ;#-sticky w
	
	grid [ttk::label $frame0.txt5a -text [mc "Label Name"]] -column 0 -row 4 -padx 2p -pady 2p
	grid [ttk::combobox $frame0.cbox] -column 1 -row 4 -padx 2p -pady 2p -sticky w
	
		bind $frame0.cbox <<ComboboxSelected>> {
				set tplLabel(LabelVersionDesc,current) [%W get]		
				ea::db::bl::populateWidget
		}
		
		bind $frame0.entry <Return> {
			if {$GS_textVar(Template) != ""} {
				ea::db::bl::getTplData $GS_textVar(Template)
			}
		}
	
	 
# Frame 1
    set frame1 [ttk::labelframe $nbk.boxlabels.frame1 -text "Label Information"]
    pack $frame1 -expand yes -fill both -padx 5p -pady 3p -ipady 2p


    ttk::label $frame1.text1 -text "Row 1"
    # NOTE: We populate the *(history) variable just under [openHistory]
    ttk::combobox $frame1.entry1 -textvariable GS_textVar(Row01) \
                                -values $GS_textVar(history) \
                                -validate key \
                                -validatecommand {Shipping_Code::filterKeys -textLength %S %W %P}
    ttk::label $frame1.data1 -textvariable lineText(data1) -width 2
    tooltip::tooltip $frame1.data1 "33 Chars Max."

    ttk::label $frame1.text2 -text "Row 2"
    ttk::entry $frame1.entry2 -textvariable GS_textVar(Row02) \
                            -validate key \
                            -validatecommand {Shipping_Code::filterKeys -textLength %S %W %P} ;#-width 33
    ttk::label $frame1.data2 -textvariable lineText(data2) -width 2

    ttk::label $frame1.text3 -text "Row 3"
    ttk::entry $frame1.entry3 -textvariable GS_textVar(Row03) \
                            -validate key \
                            -validatecommand {Shipping_Code::filterKeys -textLength %S %W %P} ;#-width 33
    ttk::label $frame1.data3 -textvariable lineText(data3) -width 2

    ttk::label $frame1.text4 -text "Row 4"
    ttk::entry $frame1.entry4 -textvariable GS_textVar(Row04) \
                            -validate key \
                            -validatecommand {Shipping_Code::filterKeys -textLength %S %W %P} ;#-width 33
    ttk::label $frame1.data4 -textvariable lineText(data4) -width 2

    ttk::label $frame1.text5 -text "Row 5"
    ttk::entry $frame1.entry5 -textvariable GS_textVar(Row05) \
                            -validate key \
                            -validatecommand {Shipping_Code::filterKeys -textLength %S %W %P}
    ttk::label $frame1.data5 -textvariable lineText(data5) -width 2

    # With ttk widgets, we need to populate the variables or else we get an error. :(
    foreach num {01 02 03 04 05} {
        set GS_textVar(Row$num) ""
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
    set frame2 [ttk::labelframe $nbk.boxlabels.frame2 -text "Shipment Information"]
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
		tooltip::tooltip $frame2a.entry2 "Add to List (Enter)"

    set GS_textVar(shipvia) Freight
    ttk::combobox $frame2a.cbox -textvar GS_textVar(shipvia) \
                                -width 7 \
                                -values [list "Freight" "Import"] \
								-state readonly
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

foreach window "$frame2a.add $frame2a.entry $frame2a.entry1" {
	bind $window <Return> {tk::TabToWindow [tk_focusNext %W]}
	bind $window <KeyPress-Down> {tk::TabToWindow [tk_focusNext %W]}
    bind $window <KeyPress-Right> {tk::TabToWindow [tk_focusNext %W]}
	
    bind $window <KeyPress-Left> {tk::TabToWindow [tk_focusPrev %W]}
    bind $window <KeyPress-Up> {tk::TabToWindow [tk_focusPrev %W]}
    
}

    bind $frame2a.entry2 <Return> {
        ;# Guard against the user inadvertantly hitting <Enter> or "Add" button without anything in the entry fields
        if {([info exists GS_textVar(destQty)] eq 0) || ($GS_textVar(destQty) eq "")} {return}
        Shipping_Code::addMaster $GS_textVar(destQty) $GS_textVar(batch) $GS_textVar(shipvia)
		#${log}::debug bind-Return if serialize: Disable widgets
    }

bind $frame1.entry1 <KeyRelease> {
    if {[string length $GS_textVar(Row01)] != 0} {
        set lineText(data1) [string length $GS_textVar(Row01)]
        } else {
            set lineText(data1) ""
    }
}


bind $frame1.entry2 <KeyRelease> {
    if {[string length $GS_textVar(Row02)] != 0} {
        set lineText(data2) [string length $GS_textVar(Row02)]
        } else {
            set lineText(data2) ""
    }
}

bind $frame1.entry3 <KeyRelease> {
    if {[string length $GS_textVar(Row03)] != 0} {
        set lineText(data3) [string length $GS_textVar(Row03)]
        } else {
            set lineText(data3) ""
    }
}
bind $frame1.entry4 <KeyRelease> {
    if {[string length $GS_textVar(Row04)] != 0} {
        set lineText(data4) [string length $GS_textVar(Row04)]
        } else {
            set lineText(data4) ""
    }
}
bind $frame1.entry5 <KeyRelease> {
    if {[string length $GS_textVar(Row05)] != 0} {
        set lineText(data5) [string length $GS_textVar(Row05)]
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
	# Go backwards
	bind $frame1.entry$window <Shift-Return> {tk::TabToWindow [tk_focusPrev %W]}
	bind $frame1.entry$window <KeyPress-Up> {tk::TabToWindow [tk_focusPrev %W]}
	
	# Go forwards
    bind $frame1.entry$window <Return> {tk::TabToWindow [tk_focusNext %W]}
    bind $frame1.entry$window <KeyPress-Down> {tk::TabToWindow [tk_focusNext %W]}
    
    bind $frame1.entry$window <Control-KeyPress-D> {%W delete 0 end}

    bind $frame1.entry$window <ButtonPress-3> {tk_popup .editPopup %X %Y}
}


bind [$frame2b.listbox bodytag] <KeyPress-BackSpace> {
    $frame2b.listbox delete [$frame2b.listbox curselection]

    ;# Make sure we keep all the textvars updated when we delete something
    Shipping_Code::addListboxNums ;# Add everything together for the running total
    catch {Shipping_Code::createList} err ;# Make sure our totals add up
	
    # Serialize Labels
    if {$tplLabel(SerializeLabel) == 1} {
        ${log}::debug <Bind-BackSpace> Serialize Label: Deleting entry, reenable the entry/button/dropdown widgets
        
        foreach child [winfo child .container.frame2.frame2a] {
            if {![string match *text* $child]} {
                $child configure -state normal
            }
        }
    }
}


bind [$frame2b.listbox bodytag] <Double-1> {
	if {[$frame2b.listbox curselection] eq ""} {return}
    $frame2b.listbox delete [$frame2b.listbox curselection]

    # Make sure we keep all the textvars updated when we delete something
    Shipping_Code::addListboxNums ;# Add everything together for the running total
    # If we don't have the [catch] here, then we will get an error if we remove the last entry.
    # cell index "0,1" out of range
    catch {Shipping_Code::createList} err ;# Make sure our totals add up

	if {[info exists err]} {${log}::debug Double-clicked and received an error: $err}
	# Serialize Labels
    if {$tplLabel(SerializeLabel) == 1} {
        # disable all of the widgets if we are serializing or working off of a runlist with no user interaction
		# Entry, Entry2, Add
        ${log}::debug Re-enable widgets in .container.frame2.frame2a. Max Box, Qty and Add to List
        foreach child [winfo children .container.frame2.frame2a] {
			if {[string match *entry1 $child] != 1 || [string match *cbox* $child] == 1 || [string match *add* $child] == 1} {
				$child configure -state normal
			}
        }
    }

}


bind $frame1.entry1 <<ComboboxSelected>> {
    Shipping_Code::readHistory [$frame1.entry1 current]
    $frame1.entry1 configure -values $GS_textVar(history) ;# Refresh the data in the comobobox
}


 
###
### - Ship To
### 
	set tab2f1 [ttk::labelframe $nbk.shipto.frame0 -text "Job Information" -padding 10]
	pack $tab2f1 -fill x -padx 5p -pady 3p -ipady 2p
	
	grid [ttk::label $tab2f1.txt1 -text [mc "Job # / Order ID"]] -column 0 -row 0 -padx 2p -pady 2p -sticky e
	grid [ttk::entry $tab2f1.entry1 -width 10 -textvariable job(Number)] -column 1 -row 0 -padx 2p -pady 2p -sticky w
	grid [ttk::entry $tab2f1.entry2 -width 5 -textvariable job(ShipOrderID)] -column 2 -row 0 -padx 2p -pady 2p -sticky w
	grid [ttk::button $tab2f1.btn1 -text [mc "Get Data"] -command "ea::db::bl::getShipToData $nbk.shipto.frame1.txt"] -column 3 -row 0 -padx 2p -pady 2p -sticky w
	grid [ttk::button $tab2f1.bnt2 -text [mc "Print Labels"] -command "Shipping_Code::writeShipTo $nbk.shipto.frame0.entry3"] -column 4 -row 0 -padx 2p -pady 2p -sticky w
	
	grid [ttk::label $tab2f1.txt2 -text [mc "Num. Pallets"]] -column 0 -row 2 -padx 2p -pady 2p -sticky e
	grid [ttk::entry $tab2f1.entry3 -width 4] -column 1 -row 2 -padx 2p -pady 2p -sticky w
	
	set tab2f2 [ttk::labelframe $nbk.shipto.frame1 -text "Ship To Destination" -padding 10]
	pack $tab2f2 -expand yes -fill both -padx 5p -pady 3p -ipady 2p
	
	# Create text widget to throw the ship to info into
	grid [text $tab2f2.txt -width 30 \
			-xscrollcommand [list $tab2f2.scrollx set] \
			-yscrollcommand [list $tab2f2.scrolly set]] -column 0 -row 0 -sticky news -pady 3p -padx 3p
	grid columnconfigure $tab2f2 $tab2f2.txt -weight 1
	
	# setup the autoscroll bars
	ttk::scrollbar $tab2f2.scrollx -orient h -command [list $tab2f2.txt xview]
	ttk::scrollbar $tab2f2.scrolly -orient v -command [list $tab2f2.txt yview]
   

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
    #	parentGUI, Shipping_Code::createList
    #
    # NOTES
    #	None
    #
    # SEE ALSO
    #	TODO: List the other *GUI procs.
    #
    #***
    global GS_textVar mySettings log
    
    if {![info exists mySettings(path,bdfile)]} {
        ${log}::debug Path to the BreakDown file does not exist. Exiting...
        return
    }
    
    # Guard against the possiblity that the breakdown window has never been launched.
    # If it doesn't exist, lets launch it, then immediately hide it.
    if {![winfo exists .breakdown]} {
        breakDown
        focus .breakdown
        wm withdraw .breakdown
        focus .
    }
        
    set myBreakDownText [.breakdown.frame1.txt get 0.0 end]
    set file [open [file join $mySettings(Home) $mySettings(path,bdfile)] w]

    puts $file [clock format [clock scan now] -format "%A %B %d %r"]\n
    puts $file $GS_textVar(Row01)
    puts $file $GS_textVar(Row02)
    puts $file $GS_textVar(Row03)
    puts $file $GS_textVar(Row04)
    puts $file $GS_textVar(Row05)\n
    puts $file $myBreakDownText

    chan close $file


    
    if {$args eq "email"} {
        ## *** Send an email regardless if we print the breakdown or not.
        ## Email
        ##
        #mail::mail boxlabels "$GS_textVar(line1)" "$GS_textVar(line1)\n$GS_textVar(line2)\n$GS_textVar(line3)\n$GS_textVar(line4)\n$GS_textVar(line5)\n\n$myBreakDownText"
        Shipping_Code::onPrint_event -line1 $GS_textVar(Row01) \
                                        -line2 $GS_textVar(Row02) \
                                        -line3 $GS_textVar(Row03) \
                                        -line4 $GS_textVar(Row04) \
                                        -line5 $GS_textVar(Row05) \
                                        -breakdown $myBreakDownText
        #${log}::debug [list $GS_textVar(line1) $GS_textVar(line2) $myBreakDownText]
    } else {
        ## *** Send an email and print out the breakdown.
        ## Email
        ##
        #mail::mail boxlabels "$GS_textVar(line1)" "$GS_textVar(line1)\n$GS_textVar(line2)\n$GS_textVar(line3)\n$GS_textVar(line4)\n$GS_textVar(line5)\n\n$myBreakDownText"
        Shipping_Code::onPrint_event -line1 $GS_textVar(Row01) \
                                        -line2 $GS_textVar(Row02) \
                                        -line3 $GS_textVar(Row03) \
                                        -line4 $GS_textVar(Row04) \
                                        -line5 $GS_textVar(Row05) \
                                        -breakdown $myBreakDownText
        #${log}::debug [list $GS_textVar(line1) $GS_textVar(line2) $myBreakDownText]
        
        # Check for required settings, exit if we don't have them
        if {![info exists mySettings(path,printer)]} {
            ${log}::debug Path to printer does not exist. Exiting...
            return
        }
        if {![info exists mySettings(path,wordpad)]} {
            ${log}::debug Path to WordPad does not exist. Exiting...
            return
        }
        
        ##
        ## Print the breakdown
        ## 
        #catch {exec [file join C:\\ "Program Files" "Windows NT" Accessories wordpad.exe] /pt breakdown.txt {\\vm-printserver\Shipping-Time}}
        ${log}::debug [file join $mySettings(path,wordpad)] /pt [file join $mySettings(Home) $mySettings(path,bdfile)] "$mySettings(path,printer)"
        catch {exec [file join $mySettings(path,wordpad)] /pt [file join $mySettings(Home) $mySettings(path,bdfile)] "$mySettings(path,printer)"} 
    }
    

    
} ;# End of printbreakDown


proc breakDown {{show_win 0}} {
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
		wm protocol .breakdown WM_DELETE_WINDOW {wm withdraw .breakdown; focus .; ${log}::debug Close window was selected. Hiding .breakdown}

        ${log}::debug breakDown: winfo geom: [winfo geometry .]
        wm geometry .breakdown +854+214

        ${log}::debug Breadown window Created...


        set frame1 [ttk::frame .breakdown.frame1]
        pack $frame1 -fill both -expand yes

        set GS_widget(breakdown) $frame1.txt
        text $frame1.txt -width 30 \
                -xscrollcommand [list $frame1.scrollx set] \
                -yscrollcommand [list $frame1.scrolly set]
        
        # setup the autoscroll bars
        ttk::scrollbar $frame1.scrollx -orient h -command [list $frame1.txt xview]
        ttk::scrollbar $frame1.scrolly -orient v -command [list $frame1.txt yview]
       
        grid $frame1.txt -column 0 -row 0 -sticky news -pady 3p -padx 3p
        grid columnconfigure $frame1 $frame1.txt -weight 1

        grid $frame1.scrolly -column 1 -row 0 -sticky nse
        grid $frame1.scrollx -column 0 -row 1 -sticky ews

        ::autoscroll::autoscroll $frame1.scrollx ;# Enable the 'autoscrollbar'
        ::autoscroll::autoscroll $frame1.scrolly ;# Enable the 'autoscrollbar'



        set frame2 [ttk::frame .breakdown.frame2]
        pack $frame2 -pady 2p -anchor se

        ttk::button $frame2.print -text [mc "Print"] -command {Shipping_Gui::printbreakDown}
        ttk::button $frame2.close -text [mc "Close"] -command {wm withdraw .breakdown ; focus .}

        grid $frame2.print -column 0 -row 0 -padx 3p
        grid $frame2.close -column 1 -row 0 -padx 5p


        bind $GS_widget(breakdown) <KeyPress> {break} ;# Prevent people from entering/removing anything
        ${log}::debug Breakdown window - 1st time ...

    } else {
        if {[winfo ismapped .breakdown] == 0 && $show_win != 0} {
            # Display the window
            wm deiconify .breakdown
            
            ${log}::debug Breakdown window is already mapped, deiconify(ing)
        }
        
        # Refreshing
        .breakdown.frame1.txt delete 0.0 end
    }


    # This is the overview.
    # Make sure the variable exists and that it contains a value
    if {([info exists GS_textVar(labelsFull)] == 1) && ($GS_textVar(labelsFull) != "")} {
        # Make sure that it has 2 or more values
        if {[llength $GS_textVar(labelsFull)] >= 2} {
            ${log}::debug breakDown: Multiple LabelsFull <=: $GS_textVar(labelsFull)
            $GS_widget(breakdown) insert end "Full Boxes:\n"
            $GS_widget(breakdown) insert end "-----------\n"
            $GS_widget(breakdown) insert end "[expr [join $GS_textVar(labelsFull) +]] @ $GS_textVar(maxBoxQty)\n"
        } else {
            # If we have less than 2 values, just insert what the full boxes are.
			${log}::debug breakDown: Single LabelsFull <=: $GS_textVar(labelsFull)
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


#proc chooseLabel {lines} {
#    #****f* chooseLabel/Shipping_Gui
#    # AUTHOR
#    #	Casey Ackels
#    #
#    # COPYRIGHT
#    #	(c) 2011 - Casey Ackels
#    #
#    # FUNCTION
#    #	If the text "Seattle Met" is detected, we launch this window so that use can choose what type of label they want to use.
#    #
#    # SYNOPSIS
#    #	chooseLabel $line (Where line is a value between 1 and 6; referring to how many lines the label is using)
#    #
#    # CHILDREN
#    #	N/A
#    #
#    # PARENTS
#    #
#    #
#    # NOTES
#    #	4-23-18 Old functionality, should be removed.
#    #
#    # SEE ALSO
#    #
#    #
#    #***
#    global log GS_textVar GS_widget
#
#    toplevel .chooseLabel
#    wm title .chooseLabel "Choose your Label"
#    wm transient .chooseLabel .
#    ${log}::debug Using lines: $lines
#
#    # x = horizontal
#    # y = vertical
#    # Put the window in the center of the parent window
#    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
#    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
#
#    wm geometry .chooseLabel +$locX+$locY
#
#    focus .chooseLabel
#
#    set frame0 [ttk::frame .chooseLabel.frame0]
#    grid $frame0 -padx 5p -pady 5p
#
#    set labels ""
#
#    ttk::radiobutton $frame0.white -text "White Label - Standard" -variable labels -value LINEDB.btw -command "set lines $lines"
#    ttk::radiobutton $frame0.green -text "Green Label - Special" -variable labels -value LINEDB_Seattle.btw -command "set lines $lines"
#    #$frame0.white invoke ;# set the default
#
#    grid $frame0.white -column 0 -row 0 -padx 5p -pady 5p -sticky w
#    grid $frame0.green -column 0 -row 1 -padx 5p -pady 5p -sticky w
#
#    set frame1 [ttk::frame .chooseLabel.frame1]
#    grid $frame1 -padx 5p -pady 5p
#    
#    ${log}::debug Number of lines to be printed: $lines
#   
#    ttk::button $frame1.print -text "Print" -command {Shipping_Code::printCustomLabels $lines $labels; destroy .chooseLabel}
#    ttk::button $frame1.close -text "Close" -command {destroy .chooseLabel}
#
#    grid $frame1.print -column 0 -row 0 -sticky ne
#    grid $frame1.close -column 1 -row 0 -sticky ne
#
#
#} ;# End of chooseLabel


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
    #	Initialize menus for the box labels module
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
    
    $mb.modMenu add command -label [mc "Clear List"] -command {Shipping_Code::clearList}
    $mb.modMenu add command -label [mc "Show Breakdown"] -command {Shipping_Gui::breakDown 1}
    $mb.modMenu add command -label [mc "Preferences"] -command {ea::gui::pref::startPref} 
	
    ${log}::debug --END -- [info level 1]
} ;# Shipping_Gui::initMenu