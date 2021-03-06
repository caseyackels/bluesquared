# Creator: Casey Ackels (C) 2006 - 2007
# Initial Date: October 28th, 2006
# Massive Rewrite: February 2nd, 2007
# Version: See shipping_launch_code.tcl
# Dependencies: See shipping_launch_code.tcl
#-------------------------------------------------------------------------------

namespace eval Shipping_Code {

proc filterKeys {args} {
    #****f* filterKeys/Shipping_Code
    # AUTHOR
    #	Casey ACkels
    #
    # COPYRIGHT
    #	(c) 2008 - Casey Ackels
    #
    # FUNCTION
    #	Only allows numeric values to be inserted
    #
    # SYNOPSIS
    #	filterKeys %S -textLength|-numeric %W %d %i %P %s %v %V
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	Shipping_Gui::shippingGUI
    #
    # NOTES
    #	This should really be a library; as it is useful for different parts of the application, and not just the Shipping module
    #	https://www.tcl.tk/man/tcl/TkCmd/ttk_entry.htm#M39
    #   %d = Type of action: 1 for _insert_, 0 for _delete_ or _-1_ for revalidation
    #   %i = Index of character string to be inserted/deleted, if any, otherwise -1
    #   %P = current string
    #   %s = The current value of entry prior to editing
    #   %S = The text string being inserted/deleted, if any, {} otherwise.
    #   %v = The current value of the -validate option
    #   %V = The validation condition that triggered the callback (key, focusin, focusout, or forced)
    #   %W = The name of the entry widget
    #
    # SEE ALSO
    #	N/A
    #
    #***
    global GS_textVar
    # Set the default value to passing
    set returnValue 0

    set type [lindex $args 0]
    set entryValue [lindex $args 1]
    set window [lindex $args 2]
    set validate_P [lindex $args 3]

    # 2020-03-23 TextLength was 29 chars
    switch -- $type {
        -numeric    {if {[string is integer $entryValue] == 1} {set returnValue 1}}
        -textLength {if {[string length $validate_P] <= 29} {set returnValue 1}}
    }

    return $returnValue
} ;# filterKeys

proc controlFile {args} {
    #****f* controlFile/Shipping_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2008 - Casey Ackels
    #
    # FUNCTION
    #	Opens a file named 'listdisplay.csv' to write the output to.
    #
    # SYNOPSIS
    #	controlFile destination fileopen|fileclose
    #	controlFile history fileappend|fileread|fileclose
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	Shipping_Code::displayListHelper
    #
    # NOTES
    #	The name is hard-coded. We should extrapolate this, and make it a core library. Setting the name at run-time.
    #   The permissions on opening the files are hardcoded.
    #   destination = open $fileName w
    #   history = open $fileName a+
    #
    #
    # SEE ALSO
    #	N/A
    #
    #***
    global log files mySettings tmp tplLabel job
    ${log}::debug Initiating controlFile - $args

    switch -- [lindex $args 0] {
        destination {
                    if {$tplLabel(LabelVersionID) != ""} {
                        ${log}::debug controlFile - Using custom label settings
                        set tmp(hdr_names) "[db eval "SELECT LabelHeaderDesc FROM LabelHeaders WHERE LabelHeaderSystemOnly = 1 ORDER BY LabelHeaderID"] [db eval "SELECT labelRowNum FROM LabelData WHERE labelVersionID = $tplLabel(LabelVersionID) ORDER BY labelRowNum"]"

                        set headers [::csv::join $tmp(hdr_names)]
                        set f_name $job(TemplateName)
                        set f_path [file dirname $tplLabel(LabelPath)]
                        ${log}::debug file name: [file join $f_path $f_name.csv]
                    } else {
                        # Set Default headers - These are used in all Generic labels (Generic1 through Generic5)
                        ${log}::debug controlFile - Using default settings
                        set f_path $mySettings(path,labelDBfile)
                        set f_name $mySettings(name,labelDBfile)
                        set headers [::csv::join "Labels Quantity Line1 Line2 Line3 Line4 Line5"]
                    }

                    if {[lindex $args 1] eq "fileopen"} {
                        set files(destination) [open [file join $f_path [join $f_name].csv] w]

                        # Insert Header row
                        chan puts $files(destination) $headers

                    } elseif {[lindex $args 1] eq "fileclose"} {
                        chan close $files(destination)
                        unset files(destination)
                        }
                    }
        history {
                    if {[file exists [file join $mySettings(Home) history.csv]] ne 1} {
                        set files(history) [open [file join $mySettings(Home) history.csv] w]
                    }

                    if {[lindex $args 1] eq "filewrite"} {
                        #set files(history_tmp) [open history_tmp.csv w+]
                        set files(history) [open [file join $mySettings(Home) history.csv] w]

                    } elseif {[lindex $args 1] eq "fileappend"} {
                        set files(history) [open [file join $mySettings(Home) history.csv] a+]

                    } elseif { [lindex $args 1] eq "fileread"} {
                        set files(history) [open [file join $mySettings(Home) history.csv] r+]

                    } elseif {[lindex $args 1] eq "fileclose"} {
                        flush $files(history)
                        chan close $files(history)
                        unset files(history)
                    }
            }
    }
} ;# End of controlFile

proc writeText {labels quantity total_boxes} {
    ## ATTENTION: The Open/Close commands are in proc [controlFile]
    global log files GS_textVar tplLabel tmp labelText job
    ${log}::debug Initiating writeText

    # Set the system data, label data will be after.
    if {$job(Template) ne ""} {
        ${log}::debug writeText - Using the template data
        set NumLabels $labels
        set BoxQuantity $quantity
        set TotalBoxes $total_boxes

        lappend textValues $quantity $labels $total_boxes $job(Number)
        ${log}::debug writeText - $textValues

        if {$tplLabel(SerializeLabel) eq ""} {
            ${log}::debug We are not serializing.
            #lappend textValues $quantity $labels $tplLabel(JobNumber)
            #lappend textValues $quantity $labels $tplLabel(JobNumber)
        } else {
            ${log}::debug We are serializing, inserting total boxes for shipment
            #lappend textValues $quantity $labels $tplLabel(JobNumber) $total_boxes
            #lappend textValues $quantity $labels $total_boxes $tplLabel(JobNumber)
        }
    } else {
        # This is for the Generic labels
        ${log}::debug writeText - Using the generic data
        lappend textValues $labels $quantity
        ${log}::debug writeText - $textValues
    }

    # Set the label data
    foreach item [lsort [array names labelText]] {
        if {[string match Row* $item]} {
            if {$labelText($item) != ""} {
                lappend textValues "$labelText($item)"
            }
        }
    }

    # Insert the values
    chan puts $files(destination) [::csv::join $textValues]

	${log}::debug writeText: textValues: $textValues
} ;# End of writeText

proc insertInListbox {args} {
    # Insert the numbers into the listbox
    global blWid

    #puts "insertInListbox: $args"
    set qty [lindex $args 0] ;# qty = piece qty
    #puts "qty $qty"
    set batch [lindex $args 1] ;# batch = how many shipments of $qty to enter. (i.e 5 shipments at 5 pieces each)
    #puts "batch $batch"
    set shipvia [lindex $args 2] ;# shipvia = How the shipment will ship (i.e. Import or Freight)

    if {[string is integer $qty] == 1} {
	if {$qty == 0} {return}
        if {($batch == 0) || ($batch == "")} {
            $blWid(f2BL).listbox insert end [list "" "" "$qty" "$shipvia"]

        } else {
            for {set x 0} {$x<$batch} {incr x} {
                $blWid(f2BL).listbox insert end [list "" "" "$qty" "$shipvia"]
                #puts "insertInListbox - BATCH: $qty"
                }
        }

    } else {
        Error_Message::errorMsg insertInListBox1 ""

        return
    }
    # This way we can see incoming values
    $blWid(f2BL).listbox see end

    # Add everything together for the running total
    addListboxNums
} ;# insertInListbox

proc addListboxNums {{reset 0}} {
    #****f* addListboxNums/Shipping_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2008 - Casey Ackels
    #
    # FUNCTION
    #	Displays the running total
    #
    # SYNOPSIS
    #	addListboxNums ?reset? (Value of 0 [default] or 1)
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	N/A
    #
    # NOTES
    #	N/A
    #
    # SEE ALSO
    #	N/A
    #
    #***
    global log blWid GI_textVar GS_textVar

    ;# If we clear the entire list, we want to reset all counters.
    if {$reset ne 0} {
        ${log}::debug addListboxNums - Resetting vars GI_textVar qty,labels,labelsPartial1,labelsPartial2
        set GI_textVar(qty) 0
        set GI_textVar(labels) ""
        set GI_textVar(labelsPartial1) ""
        set GI_textVar(labelsPartial2) ""

    }

    # row,column
    catch {set S_rawNum [$blWid(f2BL).listbox getcells 0,2 end,2]} err
    #puts "addListboxNums - catchErr: $err"

    if {[info exist err] eq 1} {
        ${log}::debug addListboxNums: err - $err [lindex $err 0]
        if {[string is integer [lindex $err 0]] eq 1} {
                set GI_textVar(qty) [expr [join $err +]]
            } else {
                set GI_textVar(qty) 0
                # Keep the breakdown window updated even if it is open
                set GS_textVar(labelsFull) ""
                set GS_textVar(labelsPartialLike) ""
                set GS_textVar(labelsPartialUnique) ""

                if {[winfo exists .breakdown]} {
                    # Find out if the window exists before finding out if we can see it or not.
                    if {[winfo ismapped .breakdown] == 1} {${log}::debug "addlistbox Refreshing Break Down"; Shipping_Gui::breakDown}
                }
            }
    }
} ;# addListboxNums

proc createList {args} {
    global log GS_textVar tplLabel blWid job

    ${log}::debug Start Createlist
    ea::code::bl::trackTotalQuantities

    if {$tplLabel(LabelVersionID) == 0} {
        ${log}::debug No Profile ID, skipping createList
        return
    }

    if {[info exists GS_textVar(maxBoxQty)] == 0} {Error_Message::errorMsg BL004; return}
    if {$GS_textVar(maxBoxQty) == ""} {Error_Message::errorMsg BL004; return}

    set L_rawEntries [split [join [$blWid(f2BL).listbox getcells 0,2 end,2]]]
    set L_rawShipVia [split [join [$blWid(f2BL).listbox getcells 0,3 end,3]]]

    ${log}::debug L_rawEntries1: $L_rawEntries
    ${log}::debug L_rawEntries2: [catch {[$blWid(f2BL).listbox getcells 0,2 end,2]} err0]

    # Make sure the variables are cleared out; we don't want any data to lag behind.
    set FullBoxes ""
    set PartialQty ""

    # L_rawEntries holds each qty (i.e. 200 204 317)
    foreach entry $L_rawEntries {
        set result [doMath $entry $GS_textVar(maxBoxQty)]

        # Make sure the variables are cleared out; we don't want any data to lag behind.
        set FullBoxes_text ""
        set PartialQty_text ""

        # FullBoxes
        if {[lrange $result 0 0] != 0} {
            lappend FullBoxes [lrange $result 0 0]
            set FullBoxes_text [lrange $result 0 0]
            ${log}::debug Fullbox Result ($GS_textVar(maxBoxQty)): [lrange $result 0 0]
        }

        # Partials
        if {[lrange $result 1 1] != 0} {
            lappend PartialQty [lsort -decreasing [lrange $result 1 1]]
            set PartialQty_text [lrange $result 1 1]
            ${log}::debug Result: 1 Label @ [lrange $result 1 end]
        }

        # This controls the Total Boxes value that we need for serialized labels
        set tmpFullBoxes $FullBoxes
        set tmpPartialQty $PartialQty
        ${log}::debug tmpFullBoxes (If empty this will default to blank): $FullBoxes
        ${log}::debug tmpPartialQty: $tmpPartialQty

        if {$tmpFullBoxes ne ""} {
            if {[llength $tmpFullBoxes] <= 2} {
                ${log}::debug Two or more full boxes, we need to join them with +: $tmpFullBoxes
                set tmpFullBoxes [join $tmpFullBoxes " + "]
            }
            ${log}::debug full boxes: $tmpFullBoxes

        } else {
            ${log}::debug No fullboxes: $tmpFullBoxes (set to 0)
            set tmpFullBoxes 0
        }

        if {$tmpPartialQty eq ""} {
            ${log}::debug tmpPartialQty is blank, using tmpFullBoxes: $tmpFullBoxes
            set total_boxes $tmpFullBoxes

        } else {
            set tmpPartialQty [llength $tmpPartialQty]
            set tmpFullBoxes [join $tmpFullBoxes " + "]
            ${log}::debug adding tmpFullboxes and tmpPartialQty together: $tmpFullBoxes - $tmpPartialQty
            set total_boxes [expr "$tmpFullBoxes + $tmpPartialQty"]
            ${log}::debug Total Boxes: $total_boxes
        }
    }


    if {[info exists FullBoxes] == 1} {
        if {![info exists PartialQty]} {set PartialQty ""}

        displayListHelper $FullBoxes $PartialQty $total_boxes
            ${log}::debug Full Boxes: $FullBoxes $PartialQty

    } elseif {[info exists PartialQty] == 1} {
        set FullBoxes ""

        displayListHelper $FullBoxes $PartialQty $total_boxes
            ${log}::debug Partial Boxes: $FullBoxes $PartialQty

    } else {
        ${log}::debug Something happened and we aren't sure if we're healthy. (boxlabels_code.tcl / createList)
        #Error_Message::errorMsg createList2
    }

    set GS_textVar(labelsFull) $FullBoxes
    set GS_textVar(labelsPartial) $PartialQty

    #${log}::debug Labels Full: $GS_textVar(labelsFull)

    # Keep the breakdown window updated even if it is open
    if {[winfo exists .breakdown] == 1} {${log}::debug Refreshing Break Down; Shipping_Gui::breakDown}
} ;# createList

proc doMath {totalQuantity maxPerBox} {
    global log
    # Do mathmatical equations, then double check to make sure it comes out to the value of totalQty
    if {($totalQuantity == "") || ($totalQuantity == 0) || $totalQuantity == {}} {
        ${log}::debug doMath: totalQuantity should have a value, exiting: $totalQuantity
        return
    }

    ${log}::debug totalQuantity: $totalQuantity
    ${log}::debug maxPerBox: $maxPerBox

    if {$totalQuantity < $maxPerBox} {
        lappend partialBoxQTY
    }


    set divideTotalQuantity [expr {$totalQuantity / $maxPerBox}]

    set totalFullBoxs [expr {round($divideTotalQuantity)}]
    set fullBoxQTY [expr {round(floor($divideTotalQuantity) * $maxPerBox)}]

    ## Use fullBoxQty as a starting point for the partial box.
    lappend partialBoxQTY [expr {round($totalQuantity - $fullBoxQTY)}]

    if {[expr {$partialBoxQTY + $fullBoxQTY}] != $totalQuantity} {
    	bgerror "Incorrect sum."
    }

    return "$totalFullBoxs $partialBoxQTY"
} ;# doMath

proc extractFromList {list} {
    # Cycle through the list and extract 'like' numbers. Put all non-'like' numbers in its own variable
    # Example: extractFromList {1 2 2 3 4 5 5 5 6 7 8 9 9 9}
    # Outputs: {8 4 1 6 7 3} {9 9 9} {5 5 5} {2 2}

    foreach item $list {lappend a($item) $item}

    set GI_uniques ""
    set GI_groups ""

    #foreach key [array names a] {}
    # Make sure the list is sorted, so we present the numbers in an orderly way.
    foreach key [lsort -decreasing -integer [array names a]] {
        if {[llength $a($key)] == 1} {
		lappend GI_uniques $key
	} else {
	    lappend GI_groups $a($key)
	}
    }
    linsert $GI_groups 0 $GI_uniques
} ; #extractFromList

proc displayListHelper {fullboxes partialboxes total_boxes {reset 0}} {
    # Insert values into final listbox/text widgets
    global log GS_textVar GI_textVar frame2b

    ${log}::debug Initiating displayListHelper
    ${log}::debug reset: $reset

    if {$reset ne 0} {
        ;# If we clear the entire list, we want to reset all counters.
        ${log}::debug displayListHelper - Resetting Vars, GI_textVar qty,labels,labelsPartial1,labelsPartial2
        set GI_textVar(qty) 0
        set GI_textVar(labels) ""
        set GI_textVar(labelsPartial1) ""
        set GI_textVar(labelsPartial2) ""

    }

    controlFile destination fileopen

    set GI_textVar(labels) ""
    set GI_textVar(labelsPartial1) ""
    set GI_textVar(labelsPartial2) ""

    if {($fullboxes != "") && ($fullboxes != 0)} {
	# This is only for FullBoxes!
        set fullboxes [expr [join "$fullboxes" +]]
        # If we only have one label, make it nonplural. Otherwise make it plural
        if {$fullboxes < 2} {
                set labels Box
            } else {
                set labels Boxes
        }

        set GI_textVar(labels) "$fullboxes $labels @ $GS_textVar(maxBoxQty)"
        writeText $fullboxes $GS_textVar(maxBoxQty) $total_boxes
    }

    # Lets sort out the like groups, and the unique group/numbers.
    set valueLists [extractFromList $partialboxes]
    ${log}::debug valueLists1_1: $valueLists

    # Sort out the 'like' number groups; start at 1, because the 'unique' numbers are always 0.
    set valueLists2 [lrange $valueLists 1 end]


    set x 0
    set GS_textVar(labelsPartialLike) "" ;# clear it out
    foreach value $valueLists2 {
	# This is for the groups of "like numbers"
        set GI_textVar(labelsPartial1) "[llength [lindex $valueLists2 $x]] Boxes @ [lindex $valueLists2 $x end]"

        lappend GS_textVar(labelsPartialLike) $GI_textVar(labelsPartial1)

        writeText [llength [lindex $valueLists2 $x]] [lindex $valueLists2 $x end] $total_boxes
        incr x
    }

    if {[info exists GS_textVar(labelsPartialLike)] == 1} {
        ${log}::debug Like Partials: $GS_textVar(labelsPartialLike)
    }


    # now we insert the 'unique' numbers, these should always just be one box each. Hence the hard-coding.
    set valueLists [split [join [lrange $valueLists 0 0]]]
    ${log}::debug "valueLists1_2: $valueLists"

    set GS_textVar(labelsPartialUnique) $valueLists ;# get clean list with no other text
     foreach value $valueLists {
        set GI_textVar(labelsPartial2) "1 Box @ $valueLists"

        writeText 1 $value $total_boxes
    }

    #${log}::debug Shipment Qty: $GI_textVar(qty)

    controlFile destination fileclose
} ;# End of displayListHelper proc

proc printLabels {} {
    global log GS_textVar programPath lineNumber mySettings tplLabel tmp labelText job

    ${log}::debug Initiating printLabels
    set gate 1

    # These apply to all labels
	if {[info exists mySettings(path,bartender)] != 0} {
		if { $mySettings(path,bartender) == ""} {
            set gate 0
			${log}::critical path,bartender is empty: $mySettings(path,bartender)
			#return
		}
	}

	if {$mySettings(path,labelDir) == ""} {
		${log}::critical path,labelDir is empty: $mySettings(path,labelDir)
        set gate 0
		#return
	}

    if {![info exists GS_textVar(maxBoxQty)]} {
        set gate 0
        #Error_Message::errorMsg BL002
        ${log}::debug maxBoxQty doesn't exist. Input a quantity.
        #return
    }
    if {$GS_textVar(maxBoxQty) eq ""} {
        set gate 0
        #Error_Message::errorMsg BL002
        ${log}::debug maxBoxQty exists, but is empty. Input a quantity.
        #return
    }

    if {$GS_textVar(destQty) ne ""} {
        ${log}::debug DestQty should not be empty: $GS_textVar(destQty)
        set gate 0
        Error_Message::errorMsg BL003
        #return
    }

    catch {Shipping_Code::createList} err ;# Make sure our totals add up
    if {[info exists err]} {
        if {$err ne ""} {
            set gate 0
            ${log}::debug Clicked Print Labels and received an error: $err
            #return
        }
    }

    if {$gate == 0} {
        # if we encounter an error and the user dismisses the dialog, EA will still print labels on it's own.
        ${log}::debug We encountered an error, exiting PrintLabels.
        return
    }

    Shipping_Gui::printbreakDown email ; # Send an email of the breakdown


    if {$job(Template) != ""} {
        ${log}::debug Printing from template: $job(Template) $job(TemplateName)

        set labelDir [file dirname $tplLabel(LabelPath)]
        set filename [file tail $tplLabel(LabelPath)]

        # Set filepath to windows standard for BarTender
        set labelDir [join [split $labelDir /] \\]

        # Set runlist file name, maybe this should be placed into the tplLabel array? tplLabel(RunListFile)
        set runlist "$labelDir\\$job(TemplateName).csv"

        # Using a specific printer: /PRN=<printer name>
        if {$tplLabel(LabelPrinter) eq ""} {
            ${log}::debug $mySettings(path,bartender) /AF=$labelDir\\$filename /D=$runlist /P /CLOSE /MIN=TASKBAR
            exec $mySettings(path,bartender) /AF=$labelDir\\$filename /D=$runlist /P /CLOSE /MIN=TASKBAR
        } else {
            ${log}::debug $mySettings(path,bartender) /AF=$labelDir\\$filename /D=$runlist /PRN=$tplLabel(LabelPrinter) /P /CLOSE /MIN=TASKBAR
            exec $mySettings(path,bartender) /AF=$labelDir\\$filename /D=$runlist /PRN=$tplLabel(LabelPrinter) /P /CLOSE /MIN=TASKBAR
        }
        update idletasks
    } else {
            ${log}::debug Printing Generic Labels
            # Fix the file paths so that bartender doesn't choke
            set labelDir [join [split $mySettings(path,labelDir) /] \\]

            if {$labelText(Row05) != ""} {
                exec $mySettings(path,bartender) /AF=$labelDir\\6LINEDB.btw /P /CLOSE /MIN=TASKBAR
                ${log}::debug $mySettings(path,bartender) /AF=$labelDir\\6LINEDB.btw /P /CLOSE /MIN=TASKBAR

            } elseif {$labelText(Row04) != ""} {
                exec $mySettings(path,bartender) /AF=$labelDir\\5LINEDB.btw /P /CLOSE /MIN=TASKBAR
                ${log}::debug $mySettings(path,bartender) /AF=$labelDir\\5LINEDB.btw /P /CLOSE /MIN=TASKBAR

            } elseif {$labelText(Row03) != ""} {
                exec $mySettings(path,bartender) /AF=$labelDir\\4LINEDB.btw /P /CLOSE /MIN=TASKBAR
                ${log}::debug $mySettings(path,bartender) /AF=$labelDir\\4LINEDB.btw /P /CLOSE /MIN=TASKBAR

            } elseif {$labelText(Row02) != ""} {
                exec $mySettings(path,bartender) /AF=$labelDir\\3LINEDB.btw /P /CLOSE /MIN=TASKBAR
                ${log}::debug $mySettings(path,bartender) /AF=$labelDir\\3LINEDB.btw /P /CLOSE /MIN=TASKBAR

            } elseif {$labelText(Row01) != ""} {
                exec $mySettings(path,bartender) /AF=$labelDir\\2LINEDB.btw /P /CLOSE /MIN=TASKBAR
                ${log}::debug $mySettings(path,bartender) /AF=$labelDir\\2LINEDB.btw /P /CLOSE /MIN=TASKBAR
            }
            update idletasks
    } ;# End generic labels
} ;# printLabels

proc addMaster {destQty batch shipvia} {
    #****f* addmaster/Shipping_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2008 - Casey Ackels
    #
    # FUNCTION
    #	Puts all code related to adding data to the listbox in one place. So the [bind]ing and the control button
    #	can call one proc. DRY.
    #
    # SYNOPSIS
    #	addMaster destQty batch
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	N/A
    #
    # NOTES
    #	N/A
    #
    # SEE ALSO
    #	N/A
    #
    #***
    global log GS_textVar tplLabel blWid

    # This shouldn't be needed, we have existing code in the [bind]ing, and in the button command
    #if {$GS_textVar(destQty) eq ""} {return}

    # Serialize Labels
    # After we enter one shipment, disable widgets so that the end-user cannot add more. This is a restriction because of how we create the runlist file.
    # These widgets should be re-enabled if the shipment is removed.
    if {$tplLabel(SerializeLabel) == 1} {
        ${log}::debug We are serializng the label, disable the entry/button/dropdown widgets

        foreach child [winfo child $blWid(f1BL)] {
            if {[string match *entry* $child]} {
                $child configure -state disable
            }
        }
    }

    Shipping_Code::insertInListbox $destQty $batch $shipvia

    ;# Reset the variables
    set GS_textVar(destQty) ""
    set GS_textVar(batch) ""
    #set GS_textVar(labelsFull) ""
    #set GS_textVar(labelsPartialLike) ""
    #set GS_textVar(labelsPartialUnique) ""

    ;# Display the updated amount of entries that we have
    Shipping_Code::createList
} ;# addMaster

proc clearList {} {
    #****f* clearList/Shipping_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2008 - Casey Ackels
    #
    # FUNCTION
    #	Clears the listbox of residual breakdown quantities.
    #
    # SYNOPSIS
    #	clearList
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	N/A
    #
    # NOTES
    #	N/A
    #
    # SEE ALSO
    #	N/A
    #
    #***
    global blWid

    #puts clearList
    #puts "clearList: [$frame2b.listbox delete 0 end]"
    catch {$blWid(f2BL).listbox delete 0 end} ;# This always generates "0,0 cell not in range" error

    Shipping_Code::addListboxNums 1 ;# Reset Counter
    Shipping_Code::displayListHelper "" "" "" 1 ;# Reset Counter
} ;# clearList

} ;# End of Shipping_Code namespace

proc Shipping_Code::onPrint_event {args} {
    #****f* emailBoxLabels/Shipping_Code
    # CREATION DATE
    #   09/17/2014 (Wednesday Sep 17)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #
    #
    # SYNOPSIS
    #   Shipping_Code::email::boxlabels -line1 <arg> -line2 <arg> -line3 <arg> -line4 <arg> -line5 <arg> -breakdown <arg>
    #
    # FUNCTION
    #	Preprocesses data before sending it on to email::email
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
    #
    # SEE ALSO
    #   email::email
    #
    #***
	global log
	set wrongArgs [mc "wrong # args should be: Shipping_Code::onPrint_event -line1 <arg> -line2 <arg> -line3 <arg> -line4 <arg> -line5 <arg> -breakdown <arg>"]

	# Just in case no arguments are passed
	if {(![info exists args]) || ($args eq "")} {
		return -code 1 $wrongArgs
	}

	set eventName [lindex [split [lindex [split [lindex [info level 0] 0] ::] 2] _] 0]

	set Subj [join [maildb::getEmailText  $::boxLabelsVars::cModName $eventName -subject]]
	set Body [join [maildb::getEmailText  $::boxLabelsVars::cModName $eventName -body]]

	# String Map
	# set myText "Line 1 of the label"
	# set emailBody "Body of the email: %b"
	# string map "%b [list $myText]" $emailBody
	foreach {key value} $args {
			# List all eligible sections for the macro's.
			# We keep the same Subj variable, because we are continually re[set]ing it, an want to keep the original data.
			# Once we hit the body, we go through an iterative process.
			switch -- $key {
				-line1		{
							set Subj [string map "%1 [list $value]" $Subj]
							set Body [string map "%1 [list $value]" $Body]
							}
				-line2		{
							set Subj [string map "%2 [list $value]" $Subj]
							set Body [string map "%2 [list $value]" $Body]
							}
				-line3		{
							set Subj [string map "%3 [list $value]" $Subj]
							set Body [string map "%3 [list $value]" $Body]
							}
				-line4		{
							set Subj [string map "%4 [list $value]" $Subj]
							set Body [string map "%4 [list $value]" $Body]

							}
				-line5		{
							set Subj [string map "%5 [list $value]" $Subj]
							set Body [string map "%5 [list $value]" $Body]
							}
				-breakdown	{
							set Subj [string map "%b [list $value]" $Subj]
							set Body [string map "%b [list $value]" $Body]
							}
				default		{return -code 1 $wrongArgs}

			}
	}

    #${log}::debug New Subject: $Subj
	#${log}::debug New Body: $Body
	mail::mail $::boxLabelsVars::cModName $eventName -subject $Subj -body $Body
} ;# Shipping_Code::emailBoxLabels

proc Shipping_Code::writeShipTo {wid_entry3 wid_txt} {
    global log files job mySettings

    # wid_entry3 is old and should be removed

    set job(ShipToDestination) ""

    #if {[$wid_entry3 get] eq "" } {}
    if {$job(ShipOrderNumPallets) eq ""} {
        ${log}::critical Nothing entered for the number of pallets (Box Labels). Aborting.
        return
    }

    for {set x 1} {[$wid_txt count -lines 1.0 end] >= $x} {incr x} {
        ${log}::debug Line: [$wid_txt get $x.0 $x.end]
        lappend job(ShipToDestination) [string trim [$wid_txt get $x.0 $x.end]]
    }

    set job(ShipToDestination) [list [join $job(ShipToDestination) " _N_ "]]
    set files(ShipTo) [open [file join {\\\\fileprint\\Labels\\Templates\\Blank Ship To\\shipto.csv}] w]


    chan puts $files(ShipTo) [::csv::join "[string toupper $job(ShipToDestination)] $job(ShipOrderNumPallets)"]
    ${log}::debug Output:  [::csv::join "[string toupper $job(ShipToDestination)] $job(ShipOrderNumPallets)"]

    flush $files(ShipTo)
    chan close $files(ShipTo)
    unset files(ShipTo)

    exec $mySettings(path,bartender) "/AF=\\\\fileprint\\Labels\\Templates\\Blank Ship To\\BLANK SHIP TO.btw" /P /CLOSE /MIN=TASKBAR
    ${log}::debug $mySettings(path,bartender) "/AF=\\\\fileprint\\Labels\\Templates\\Blank Ship To\\BLANK SHIP TO.btw" /P /CLOSE /MIN=TASKBAR
} ;# Shipping_Code::writeShipTo

proc ea::code::bl::resetLabelText {} {
    global log labelText

    foreach item [array names labelText] {
        set labelText($item) ""
    }
} ;# ea::code::bl::resetLabelText

proc ea::code::bl::resetBoxLabels {btn shipToWid shipListWid} {
    # reset all widgets and box variables
    global log job blWid GS_textVar tplLabel files

    ${log}::notice Reset Job Array
    foreach item [array names job] {
        set job($item) ""
    }

    ${log}::notice Reset tplLabel array
    foreach item [array names tplLabel] {
        set tplLabel($item) ""
    }

    ${log}::notice Box Labels: Reset GS_textVar array
    set GS_textVar(maxBoxQty) ""
    set GS_textVar(destQty) ""
    set GS_textVar(batch) ""
    set GS_textVar(shipvia) ""

    ${log}::notice Box Labels: Reset Version dropdown
    $blWid(f0BL).cbox1 configure -values ""
    $blWid(f0BL).cbox1 set ""

    ${log}::notice Box Labels: Reset Row Data
    ea::code::bl::resetLabelText

    ${log}::notice Box Labels: Clear Shipment List Widget
    $shipListWid delete 0 end

    ${log}::notice Box Labels: Enable Widgets, except version dropdown widget
    # Make sure widgets are enabled, ignoring the version dropdown widget
    foreach item [winfo children $blWid(f0BL)] {
        if {![string match *cbox* $item]} {
            ${log}::debug Enable Widget: $item
            $item configure -state normal
        }
    }

    foreach item [winfo children $blWid(f1BL)] {
        ${log}::debug Enable Widget: $item
        $item configure -state normal
    }

    # Enable entry widgets
    $blWid(f).entry1 configure -state normal
        focus $blWid(f).entry1
    #$blWid(f).entry2 configure -state normal

    ${log}::debug ShipTo: Clear ShipOrder ID dropdown
    $blWid(tab2f1).cbox1 configure -values ""
    $blWid(tab2f1).cbox1 set ""

    ${log}::debug ShipTo: Clear ShipTo Widget
    $shipToWid delete 0.0 end



    ${log}::debug Change Button back to Original State
    $btn configure -text [mc "Search"] -command {ea::db::bl::getJobData .container.f0.btn1 $blWid(f0BL).cbox1 $blWid(tab2f2).txt $blWid(f2BL).listbox}

    # Ensure that the files that we are writing to are closed (they may stay open if a bug is encountered after opening the file)
    ${log}::debug Closing files ...
    if {[info exists files(destination)] == 1} {
        flush $files(destination)
        chan close $files(destination)
    }

    if {[info exists files(ShipTo)] == 1} {
        flush $files(ShipTo)
        chan close $files(ShipTo)
    }

    ${log}::debug Closing and reopening the sqlite db...
    eAssist_db::loadDB -close
    eAssist_db::loadDB -open

} ;# ea::code::bl::resetBoxLabels

proc ea::code::bl::trackTotalQuantities {} {
    global log job blWid

    # Retrieve the list of Shipments (column Shipments (2))
    set shipqty [$blWid(f2BL).listbox getcolumn 2]

    set job(bl,TotalShipments) [llength $shipqty]

    if {$job(bl,TotalShipments) > 1} {
        ${log}::debug Ship Qty: [expr [join $shipqty +]]
        set job(bl,TotalQuantity) [expr [join $shipqty +]]
    } else {
        # We only have one quantity
        ${log}::debug Ship Qty: $shipqty
        set job(bl,TotalQuantity) $shipqty
    }
} ;# ea::code::bl::trackTotalQuantities

proc ea::code::bl::clearEntryWidgets {wid lines} {
    global log blWid

    if {$lines eq "-single"} {
        $wid delete 0 end
        ${log}::debug Delete text $wid
    } else {
        ${log}::debug Deleting all text
        foreach item [winfo child $blWid(f0BL)] {
            if {[string match *entry* $item] == 1} {
                $item delete 0 end
            }
        }
    }
} ;# ea::code::bl::clearEntryWidgets

proc ea::code::bl::cleanVersionNames {versionName} {
    global log

    set idx [lsearch -exact $versionName .CUSTOM.]

    if {$idx ne -1} {
        set var [string trim [lreplace $versionName $idx $idx]]
        } else {
            set var [string trim $versionName]
        }
    return $var
} ;# ea::code::bl::cleanVersionNames

proc ea::code::bl::transformToVar {labelRowText} {
    # See file: db_initvars.tcl / ea::db::init_mod
    global log job date

    # Currents
    set date(CurrentMonth) [clock format [clock seconds] -format %B]
    set date(CurrentYear) [clock format [clock seconds] -format %Y]

    # Nexts
    set date(NextMonth) [clock format [clock add [clock seconds] 1 month] -format %B]
    set date(NextYear) [clock format [clock add [clock seconds] 1 year] -format %Y]

    set varMapping {#JobName $job(Name) \
                    #TitleName $job(Title) \
                    #CustomerName $job(CustName) \
                    #CurrentMonth $date(CurrentMonth) \
                    #CurrentYear $date(CurrentYear) \
                    #NextMonth $date(NextMonth) \
                    #NextYear $date(NextYear) \
                    #JobNumber $job(Number)}
    return [subst [string map $varMapping $labelRowText]]
} ;# ea::code::bl::transformToVar
