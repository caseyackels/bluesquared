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
#eAssist_db::loadDB

proc ea::gui::bl::Main {} {
	global log labelText job GS_textVar tplLabel blWid

	# Clear the frames before continuing
    eAssist_Global::resetFrames parent

	Shipping_Gui::initMenu
	Shipping_Gui::initVariables

	# Init global vars
	set GS_textVar(destQty) ""
	set GS_textVar(batch) ""
	set GS_textVar(shipvia) ""

	set blWid(f) [ttk::labelframe .container.f0 -text [mc "Job Information"]]
	pack $blWid(f) -fill x -padx 5p -pady 3p -ipady 2p

	grid [ttk::label $blWid(f).text1a -text [mc "Customer:"]] -column 0 -row 0 -padx 2p -pady 2p -sticky e
	grid [ttk::label $blWid(f).text1b -textvariable job(CustName)] -column 1 -columnspan 4 -row 0 -padx 2p -pady 2p -sticky w

	grid [ttk::label $blWid(f).text2a -text [mc "Job Title / Name:"]] -column 0 -row 1 -padx 2p -pady 2p -sticky e
	grid [ttk::label $blWid(f).text2b -textvariable job(Description) ] -column 1 -columnspan 4 -row 1 -padx 2p -pady 2p -sticky w

	grid [ttk::label $blWid(f).text3a -text [mc "Job #:"]] -column 0 -row 2 -padx 2p -pady 2p -sticky e
	grid [ttk::entry $blWid(f).entry1 -textvariable job(Number) -width 20 \
								-validate key \
								-validatecommand {Shipping_Code::filterKeys -numeric %S %W %P}] -column 1 -row 2 -padx 2p -pady 2p -sticky ew
		focus $blWid(f).entry1
		bind $blWid(f).entry1 <Return> {
			if {$job(Number) != ""} {
				ea::db::bl::getJobData ".container.f0.btn1" $blWid(f0BL).cbox1 $blWid(tab2f2).txt $blWid(f2BL).listbox
			}
		}

	grid [ttk::button $blWid(f).btn1 -text [mc "Search"] -command {${log}::debug Searching for $job(Number) ; ea::db::bl::getJobData ".container.f0.btn1" $blWid(f0BL).cbox1 $blWid(tab2f2).txt $blWid(f2BL).listbox}] -column 3 -padx 2p -pady 2p -row 2 -sticky w

	##
	## Setup the Notebook
	##
    set nbk [ttk::notebook .container.f1 -padding 10]
    pack $nbk -fill both

    ttk::notebook::enableTraversal $nbk

    # Create the tabs
    #
    $nbk add [ttk::frame $nbk.boxlabels] -text [mc "Box Labels"]
    $nbk add [ttk::frame $nbk.shipto] -text [mc "Ship To"]


	# Label Information
	set blWid(f0BL) [ttk::labelframe $nbk.boxlabels.f0 -text [mc "Label Information"] -padding 5]
	pack $blWid(f0BL) -fill x -pady 3p -padx 5p

	grid [ttk::label $blWid(f0BL).cboxText -text [mc "Versions"]] -column 0 -row 0 -pady 15p -padx 5p -sticky ne
	grid [ttk::combobox $blWid(f0BL).cbox1 -state readonly] -column 1 -row 0 -pady 15p -padx 4p -sticky new

		bind $blWid(f0BL).cbox1 <<ComboboxSelected>> {
			${log}::debug Selecting an item from the version dropdown
			set job(Version) [%W get]
			set GS_textVar(maxBoxQty) "" ;# Clear out the var, just in case we are switching from a template to Planner data.
				# Check to see if the current selected version is a template version
				set verExists ""
				if {$job(Template) ne ""} {
					# If the job(Template) var is empty, that means we didn't find a template. So we'll be using Planner only data.
					set ver [ea::code::bl::cleanVersionNames $job(Version)]
					set verExists [db eval "SELECT LabelVersionDesc FROM LabelVersions WHERE tplID = $job(Template) AND LOWER(LabelVersionDesc) = LOWER('$ver')"]
					unset ver
				}
				if {$verExists ne ""} {
					${log}::debug We are using a template.
					ea::code::bl::resetLabelText
					ea::db::bl::getTplVersions
				} else {
					# Version doesn't exists, probably from Planner.....
					ea::code::bl::resetLabelText
					${log}::debug No Templates, using data from Planner.
					set labelText(Row01) $job(Title)
					set labelText(Row02) $job(Name)
					if {[llength $job(TotalVersions)] > 1} {
						set labelText(Row03) $job(Version)
						${log}::debug Change Version to $job(Version)
					}
				}
			${log}::debug Change Counts
			ea::db::bl::getShipCounts
		}

	set col 0
	for {set row 1} {5 >= $row} {incr row} {
		set labelText(Row0$row) ""

		grid [ttk::label $blWid(f0BL).text$row -text [mc "Row $row"]] -column $col -row $row -padx 5p -pady 2p -sticky e

		incr col
		grid [ttk::entry $blWid(f0BL).entry$row -textvariable labelText(Row0$row) -width 60 \
											-validate key \
											-validatecommand {Shipping_Code::filterKeys -textLength %S %W %P}] -column $col -row $row -padx 4p -pady 2p -sticky ew
		incr col
		grid [ttk::button $blWid(f0BL).btn$row -text [mc "C"] -command "ea::code::bl::clearEntryWidgets $blWid(f0BL).entry$row -single" -width 3] -column $col -row $row -padx 2p -sticky w

		set col 0
	}

	# Shipment Information
	set blWid(f1BL) [ttk::labelframe $nbk.boxlabels.f1 -text [mc "Shipment Information"] -padding 5]
	pack $blWid(f1BL) -fill x -pady 3p -padx 5p
	#grid columnconfigure $f1BL 1 -weight 2
	${log}::debug shipment info frame: $blWid(f1BL)

	# Max per box
	grid [ttk::label $blWid(f1BL).txt1 -text [mc "Max. Per Box"]] -column 0 -row 0 -padx 5p -pady 2p -sticky e
	grid [ttk::entry $blWid(f1BL).entry1 -textvariable GS_textVar(maxBoxQty) -width 10 \
									-validate key \
									-validatecommand {Shipping_Code::filterKeys -numeric %S %W %P}] -column 1 -row 0 -padx 5p -pady 2p -sticky w

	# Num shipments
	grid [ttk::label $blWid(f1BL).txt2 -text [mc "Num. Shipments"]] -column 0 -row 1 -padx 5p -pady 2p -sticky e
	grid [ttk::entry $blWid(f1BL).entry2 -textvariable GS_textVar(batch) -width 10 \
									-validate key \
									-validatecommand {Shipping_Code::filterKeys -numeric %S %W %P}] -column 1 -row 1 -padx 5p -pady 2p -sticky w

	# Ship Qty
	grid [ttk::label $blWid(f1BL).txt3 -text [mc "Ship Qty"]] -column 0 -row 2 -padx 5p -pady 2p -sticky e
	grid [ttk::entry $blWid(f1BL).entry3 -textvariable GS_textVar(destQty) -width 15 \
									-validate key \
									-validatecommand {Shipping_Code::filterKeys -numeric %S %W %P}] -column 1 -row 2 -padx 5p -pady 2p -sticky w
		    bind $blWid(f1BL).entry3 <Return> {
				# Guard against the user inadvertantly hitting <Enter> or "Add" button without anything in the entry fields
				if {([info exists GS_textVar(destQty)] eq 0) || ($GS_textVar(destQty) eq "")} {return}
				Shipping_Code::addMaster $GS_textVar(destQty) $GS_textVar(batch) $GS_textVar(shipvia)
				#${log}::debug bind-Return if serialize: Disable widgets
			}

	grid [ttk::combobox $blWid(f1BL).cbox3 -state readonly] -column 2 -row 2 -padx 0p -pady 0p -sticky ew
	grid [ttk::button $blWid(f1BL).btn3 -text [mc "Add to list"] -command {
							;# Guard against the user inadvertantly hitting <Enter> or "Add" button without anything in the entry fields
							if {([info exists GS_textVar(destQty)] eq 0) || ($GS_textVar(destQty) eq "")} {return}

							Shipping_Code::addMaster $GS_textVar(destQty) $GS_textVar(batch) $GS_textVar(shipvia)
					}] -column 3 -row 2 -padx 5p -pady 2p -sticky w

	# Table
	set blWid(f2BL) [ttk::frame $nbk.boxlabels.f2 -padding 5]
	pack $blWid(f2BL) -fill both -pady 3p -padx 5p

	tablelist::tablelist $blWid(f2BL).listbox -columns {
                                                    3 "..." center
													0 "Order ID" center
                                                    0 "Ship Qty"
													25 "Distribution Type"
                                                    } \
                                        -showlabels yes \
                                        -height 5 \
                                        -selectbackground yellow \
                                        -selectforeground black \
                                        -stripebackground lightblue \
                                        -exportselection yes \
                                        -showseparators yes \
                                        -fullseparators yes \
                                        -yscrollcommand [list $blWid(f2BL).scrolly set]

        $blWid(f2BL).listbox columnconfigure 0 -showlinenumbers 1 -name count
		$blWid(f2BL).listbox columnconfigure 1 -name orderid
        $blWid(f2BL).listbox columnconfigure 2 -name shipments -labelalign center
		$blWid(f2BL).listbox columnconfigure 3 -name disttype -labelalign center

    ttk::scrollbar $blWid(f2BL).scrolly -orient v -command [list $blWid(f2BL).listbox yview]

    grid $blWid(f2BL).listbox -column 0 -row 0 -sticky news
    grid columnconfigure $blWid(f2BL) $blWid(f2BL).listbox -weight 2

    grid $blWid(f2BL).scrolly -column 1 -row 0 -sticky nse

    ::autoscroll::autoscroll $blWid(f2BL).scrolly ;# Enable the 'autoscrollbar'

	# Status
	set blWid(f3BL) [ttk::frame $nbk.boxlabels.f3 -padding 2]
	pack $blWid(f3BL) -fill both -pady 3p -padx 5p

	#set job(bl,TotalShipments) 999
	grid [ttk::label $blWid(f3BL).text1 -text [mc "Shipments:"]] -column 0 -row 0 -pady 2p -padx 2p -sticky e
	grid [ttk::label $blWid(f3BL).text2 -textvariable job(bl,TotalShipments)] -column 1 -row 0 -pady 2p -padx 2p -sticky w

	#set job(bl,TotalQuantity) 9,999,999
	grid [ttk::label $blWid(f3BL).text3 -text [mc "Quantity:"]] -column 2 -row 0 -pady 2p -padx 2p -sticky e
	grid [ttk::label $blWid(f3BL).text4 -textvariable job(bl,TotalQuantity)] -column 3 -row 0 -pady 2p -padx 2p -sticky w


	bind [$blWid(f2BL).listbox bodytag] <Double-1> {
		# Error Trapping
		if {[$blWid(f2BL).listbox curselection] eq ""} {return}
		if {[info exists GS_textVar(maxBoxQty)] == 0} {Error_Message::errorMsg BL004; return}
		if {$GS_textVar(maxBoxQty) == ""} {Error_Message::errorMsg BL004; return}

		${log}::debug Deleting [$blWid(f2BL).listbox curselection]
		$blWid(f2BL).listbox delete [$blWid(f2BL).listbox curselection]

		# Make sure we keep all the textvars updated when we delete something
		Shipping_Code::addListboxNums ;# Add everything together for the running total
		# If we don't have the [catch] here, then we will get an error if we remove the last entry.
		# cell index "0,1" out of range
		catch {Shipping_Code::createList} err ;# Make sure our totals add up

		if {[info exists err]} {${log}::debug listbox BINDING > Double-clicked and received an error: $err}
		# Serialize Labels
		if {$tplLabel(SerializeLabel) == 1} {
			# disable all of the widgets if we are serializing or working off of a runlist with no user interaction
			# Entry, Entry2, Add
			${log}::debug Re-enable widgets in $blWid(f1BL) Max Box, Qty and Add to List
			foreach child [winfo children $blWid(f1BL)] {
				$child configure -state normal
			}
		}
	}

	##
	## Ship To
	##

	set blWid(tab2f1) [ttk::labelframe $nbk.shipto.f1 -text [mc "Ship Orders"] -padding 10]
	pack $blWid(tab2f1) -fill x -padx 5p -pady 3p -ipady 2p

	grid [ttk::label $blWid(tab2f1).txt1 -text [mc "Order ID"]] -column 0 -row 0 -padx 2p -pady 2p -sticky e
	grid [ttk::combobox $blWid(tab2f1).cbox1 -width 10 -state readonly -textvariable job(ShipOrderID)] -column 1 -row 0 -padx 2p -pady 2p -sticky w
	#grid [ttk::button $tab2f1.btn1 -text [mc "Get Data"] -command "ea::db::bl::getShipToData $tab2f1.btn1 $nbk.shipto.frame1.txt"] -column 3 -row 0 -padx 2p -pady 2p -sticky w

	grid [ttk::label $blWid(tab2f1).txt2 -text [mc "Num. Pallets"]] -column 0 -row 2 -padx 2p -pady 2p -sticky e
	grid [ttk::entry $blWid(tab2f1).entry2 -textvariable job(ShipOrderNumPallets) -width 4] -column 1 -row 2 -padx 2p -pady 2p -sticky w


	set blWid(tab2f2) [ttk::labelframe $nbk.shipto.f2 -text "Ship To Destination" -padding 10]
	pack $blWid(tab2f2) -expand yes -fill both -padx 5p -pady 3p -ipady 2p

	# Create text widget to throw the ship to info into
	grid [text $blWid(tab2f2).txt -width 30 \
			-height 10 \
			-xscrollcommand [list $blWid(tab2f2).scrollx set] \
			-yscrollcommand [list $blWid(tab2f2).scrolly set]] -column 0 -row 0 -sticky news -pady 3p -padx 3p
	grid columnconfigure $blWid(tab2f2) $blWid(tab2f2).txt -weight 1

	# setup the autoscroll bars
	ttk::scrollbar $blWid(tab2f2).scrollx -orient h -command [list $blWid(tab2f2).txt xview]
	ttk::scrollbar $blWid(tab2f2).scrolly -orient v -command [list $blWid(tab2f2).txt yview]

	# Ship To Bindings
	bind $blWid(tab2f1).cbox1 <<ComboboxSelected>> {
		${log}::debug Display Ship To for Order $job(ShipOrderID)
		ea::db::bl::getShipToData {} $blWid(tab2f2).txt
	}

   # NOTEBOOK BINDINGS
	bind $nbk <<NotebookTabChanged>> {
		${log}::debug Notebook tab changed to: [%W select] / $blWid(f1BL)
		if {[%W select] eq ".container.f1.boxlabels"} {
			eAssist::remButtons $btn(Bar)
            eAssist::addButtons [mc "Print Labels"] Shipping_Code::printLabels btn1 0 8p
            eAssist::addButtons [mc "Print Breakdown"] Shipping_Gui::printbreakDown btn2 1 0p
		} else {
			eAssist::remButtons $btn(Bar)
            eAssist::addButtons [mc "Print Labels"] "Shipping_Code::writeShipTo {} $blWid(tab2f2).txt" btn1 0 0p
		}
	}
}

namespace eval Shipping_Gui {
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
    global GS_textVar mySettings log labelText

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
    puts $file $labelText(Row01)
    puts $file $labelText(Row02)
    puts $file $labelText(Row03)
    puts $file $labelText(Row04)
    puts $file $labelText(Row05)\n
    puts $file $myBreakDownText

    chan close $file



    if {$args eq "email"} {
        ## *** Send an email regardless if we print the breakdown or not.
        ## Email
        ##
        #mail::mail boxlabels "$GS_textVar(line1)" "$GS_textVar(line1)\n$GS_textVar(line2)\n$GS_textVar(line3)\n$GS_textVar(line4)\n$GS_textVar(line5)\n\n$myBreakDownText"
        Shipping_Code::onPrint_event -line1 $labelText(Row01) \
                                        -line2 $labelText(Row02) \
                                        -line3 $labelText(Row03) \
                                        -line4 $labelText(Row04) \
                                        -line5 $labelText(Row05) \
                                        -breakdown $myBreakDownText
        #${log}::debug [list $GS_textVar(line1) $GS_textVar(line2) $myBreakDownText]
    } else {
        ## *** Send an email and print out the breakdown.
        ## Email
        ##
        #mail::mail boxlabels "$GS_textVar(line1)" "$GS_textVar(line1)\n$GS_textVar(line2)\n$GS_textVar(line3)\n$GS_textVar(line4)\n$GS_textVar(line5)\n\n$myBreakDownText"
        Shipping_Code::onPrint_event -line1 $labelText(Row01) \
                                        -line2 $labelText(Row02) \
                                        -line3 $labelText(Row03) \
                                        -line4 $labelText(Row04) \
                                        -line5 $labelText(Row05) \
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
	$mb.modMenu add command -label [mc "Clear all Rows"] -command {ea::code::bl::clearEntryWidgets "" -all}
    $mb.modMenu add command -label [mc "Show Breakdown"] -command {Shipping_Gui::breakDown 1}
    $mb.modMenu add command -label [mc "Preferences"] -command {ea::gui::pref::startPref}

    ${log}::debug --END -- [info level 1]
} ;# Shipping_Gui::initMenu
