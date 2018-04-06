# Creator: Casey Ackels (C) 2006 - 2007
# Initial Date: October 28th, 2006
# Massive Rewrite: February 2nd, 2007
# Version: See shipping_launch_code.tcl
# Dependencies: See shipping_launch_code.tcl
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 470 $
# $LastChangedBy: casey.ackels@gmail.com $
# $LastChangedDate: 2015-03-06 13:29:36 -0800 (Fri, 06 Mar 2015) $
#
########################################################################################

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

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
    #	filterKeys %S -textLength %W %d %i %P %s %v %V
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	Shipping_Gui::shippingGUI
    #
    # NOTES
    #	This should really be a library; as it is useful for different parts of the application, and not just the Shipping module
    #   %P = current string; %i = current index
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

    switch -- $type {
        -numeric    {if {[string is integer $entryValue] == 1} {set returnValue 1}}
        -textLength {if {[string length $validate_P] <= 33} {set returnValue 1}}
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
    global files mySettings tmp

    if {![info exists tmp(databaseFilePath)]} {
        set tmp(databaseFilePath) $mySettings(path,labelDBfile)
    }

    switch -- [lindex $args 0] {
        destination {
                        if {[lindex $args 1] eq "fileopen"} {
                            #set files(destination) [open [file join $mySettings(path,labelDBfile) $mySettings(name,labelDBfile).csv] w]
                            
                            set files(destination) [open [file join $tmp(databaseFilePath) $mySettings(name,labelDBfile).csv] w]
                            
                            # Insert Header row
                            chan puts $files(destination) [::csv::join "Labels Quantity Line1 Line2 Line3 Line4 Line5"]
            
                        } elseif {[lindex $args 1] eq "fileclose"} {
                            chan close $files(destination)
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
                    }
            }
    }

} ;# End of controlFile


proc writeText {labels quantity} {
    global files GS_textVar log

    ## ATTENTION: The Open/Close commands are in proc [controlFile]

    # Use lappend so that if the text contains spaces ::csv::join will handle it correctly
    lappend textValues $labels $quantity "$GS_textVar(line1)" "$GS_textVar(line2)" "$GS_textVar(line3)" "$GS_textVar(line4)" "$GS_textVar(line5)"
    # Insert the values
    chan puts $files(destination) [::csv::join $textValues]
	
	${log}::debug writeText: textValues: $textValues

} ;# End of writeText


proc insertInListbox {args} {
    # Insert the numbers into the listbox
    global frame2b

    puts "insertInListbox: $args"
    set qty [lindex $args 0] ;# qty = piece qty
    #puts "qty $qty"
    set batch [lindex $args 1] ;# batch = how many shipments of $qty to enter. (i.e 5 shipments at 5 pieces each)
    #puts "batch $batch"
    set shipvia [lindex $args 2] ;# shipvia = How the shipment will ship (i.e. Import or Freight)

    if {[string is integer $qty] == 1} {
	if {$qty == 0} {return}
        if {($batch == 0) || ($batch == "")} {
            $frame2b.listbox insert end [list "" "$qty" "$shipvia"]

        } else {
            for {set x 0} {$x<$batch} {incr x} {
                $frame2b.listbox insert end [list "" "$qty" "$shipvia"]
                #puts "insertInListbox - BATCH: $qty"
                }
        }

    } else {
	Error_Message::errorMsg insertInListBox1 ""; return
    }
    # This way we can see incoming values
    $frame2b.listbox see end

    ;# Add everything together for the running total
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
    global frame2b GI_textVar GS_textVar

    ;# If we clear the entire list, we want to reset all counters.
    if {$reset ne 0} {
        set GI_textVar(qty) 0
        set GI_textVar(labels) ""
        set GI_textVar(labelsPartial1) ""
        set GI_textVar(labelsPartial2) ""

    }

    # row,column
    catch {set S_rawNum [$frame2b.listbox getcells 0,1 end,1]} err
    puts "addListboxNums - catchErr: $err"

    if {[info exist err] eq 1} {
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
				if {[winfo ismapped .breakdown] == 1} {puts "addlistbox::Refreshing Break Down"; Shipping_Gui::breakDown}
			}
        }
    }
} ;# addListboxNums
 

proc createList {} {
    global log frame2b GS_textVar

    ${log}::debug Start Createlist
    
    if {[info exists GS_textVar(maxBoxQty)] == 0} {Error_Message::errorMsg createList1; return}
    if {$GS_textVar(maxBoxQty) == ""} {Error_Message::errorMsg createList1; return}

    set L_rawEntries [split [join [$frame2b.listbox getcells 0,1 end,1]]]
    set L_rawShipVia [split [join [$frame2b.listbox getcells 0,2 end,2]]]

    ${log}::debug L_rawEntries1: $L_rawEntries
    ${log}::debug L_rawEntries2: [$frame2b.listbox getcells 0,1 end,1]

    # Make sure the variables are cleared out; we don't want any data to lag behind.
    set FullBoxes ""
    set PartialQty ""

    # L_rawEntries holds each qty (i.e. 200 204 317)
    foreach entry $L_rawEntries {
        set result [doMath $entry $GS_textVar(maxBoxQty)]
    
            if {[lrange $result 0 0 ]!= 0} {
                ${log}::debug Result: [lrange $result 0 0] Label @ $GS_textVar(maxBoxQty)
            }
    
            if {[lrange $result 1 end] != 0} {
                ${log}::debug Result: 1 Label @ [lrange $result 1 end]
            }
    
        # Make sure the variables are cleared out; we don't want any data to lag behind.
        set FullBoxes_text ""
        set PartialQty_text ""
    
        if {[lrange $result 0 0] != 0} {lappend FullBoxes [lrange $result 0 0]; set FullBoxes_text [lrange $result 0 0]}
        if {[lrange $result 1 1] != 0} {lappend PartialQty [lsort -decreasing [lrange $result 1 1]]; set PartialQty_text [lrange $result 1 1]}
    }


    if {[info exists FullBoxes] == 1} {
        if {![info exists PartialQty]} {set PartialQty ""}
    
        displayListHelper $FullBoxes $PartialQty
            ${log}::debug DisplayListHelper_A: $FullBoxes $PartialQty

    } elseif {[info exists PartialQty] == 1} {
        set FullBoxes ""
    
        displayListHelper $FullBoxes $PartialQty
            ${log}::debug DisplayListHelper_B: $FullBoxes $PartialQty

    } else {
        Error_Message::errorMsg createList2
    }

    set GS_textVar(labelsFull) $FullBoxes
    set GS_textVar(labelsPartial) $PartialQty

    ${log}::debug LabelsFull: $GS_textVar(labelsFull)

    # Keep the breakdown window updated even if it is open
    if {[winfo exists .breakdown] == 1} {${log}::debug Refreshing Break Down; Shipping_Gui::breakDown}

} ;# createList


proc doMath {totalQuantity maxPerBox} {
# Do mathmatical equations, then double check to make sure it comes out to the value of totalQty

    #puts "TOTALQUANTITY: $totalQuantity"
    if {($totalQuantity == "") || ($totalQuantity == 0) || $totalQuantity == {}} {return}

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
#puts "totalFullBoxs: $totalFullBoxs"
#puts "partialBoxQTY: $partialBoxQTY"
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

} ;# extractFromList


proc displayListHelper {fullboxes partialboxes {reset 0}} {
    # Insert values into final listbox/text widgets
    global log GS_textVar GI_textVar frame2b

    ${log}::debug Starting displayListHelper
    ${log}::debug reset: $reset
    
    if {$reset ne 0} {
        ;# If we clear the entire list, we want to reset all counters.
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
                #puts "non-plural - $fullboxes"
               } else {
                set labels Boxes
                #puts "plural - $fullboxes"
            }


        set GI_textVar(labels) "$fullboxes $labels @ $GS_textVar(maxBoxQty)"

	writeText $fullboxes $GS_textVar(maxBoxQty)
    }

    # Lets sort out the like groups, and the unique group/numbers.
    set valueLists [extractFromList $partialboxes]
    puts "valueLists1_1: $valueLists"

    # Sort out the 'like' number groups; start at 1, because the 'unique' numbers are always 0.
    set valueLists2 [lrange $valueLists 1 end]


    set x 0
    set GS_textVar(labelsPartialLike) "" ;# clear it out
    foreach value $valueLists2 {
	# This is for the groups of "like numbers"
        set GI_textVar(labelsPartial1) "[llength [lindex $valueLists2 $x]] Boxes @ [lindex $valueLists2 $x end]"
        #set GI_textVar(labelsPartial_noTextLike) [lindex $valueLists2 $x end]
        #puts "valueLists2: $value"
        lappend GS_textVar(labelsPartialLike) $GI_textVar(labelsPartial1)


	writeText [llength [lindex $valueLists2 $x]] [lindex $valueLists2 $x end]

	incr x
    }

    if {[info exists GS_textVar(labelsPartialLike)] == 1} {
    puts "Like Partials: $GS_textVar(labelsPartialLike)"
    }


    # now we insert the 'unique' numbers, these should always just be one box each. Hence the hard-coding.
    set valueLists [split [join [lrange $valueLists 0 0]]]
    puts "valueLists1_2: $valueLists"

    set GS_textVar(labelsPartialUnique) $valueLists ;# get clean list with no other text
     foreach value $valueLists {
	set GI_textVar(labelsPartial2) "1 Box @ $valueLists"

	writeText 1 $value
    }

    puts "qty: $GI_textVar(qty)"

    controlFile destination fileclose
} ;# End of displayListHelper proc


proc printLabels {} {
    global log GS_textVar programPath lineNumber mySettings tplLabel tmp


	if {[info exists mySettings(path,bartender)] != 0} {
		if { $mySettings(path,bartender) == ""} {
			${log}::debug path,bartender is empty: $mySettings(path,bartender)
			return
		}
	}
	
	if {$mySettings(path,labelDir) == ""} {
		${log}::debug path,labelDir is empty: $mySettings(path,labelDir)
		return
	}

    if {$tplLabel(ID) eq ""} {
        if {![info exists GS_textVar(maxBoxQty)]} {
            Error_Message::errorMsg printLabels1
            return
        }
        
        Shipping_Code::createList
        Shipping_Code::writeHistory $GS_textVar(maxBoxQty)
        Shipping_Code::openHistory
    
        Shipping_Gui::printbreakDown email ; # Send an email of the breakdown
    }


    if {$tplLabel(ID) != ""} {
        ${log}::debug Printing from template: $tplLabel(ID) $tplLabel(Name)
        #set tmp(databaseFilePath) $tplLabel(labelDBfile)
        
        set labelDir [file dirname $tplLabel(LabelPath)]
        set filename [file tail $tplLabel(LabelPath)]

        set labelDir [join [split $labelDir /] \\]
        
        ${log}::debug $mySettings(path,bartender) /AF=$labelDir\\$filename /P /CLOSE /X
        exec $mySettings(path,bartender) /AF=$labelDir\\$filename /P /CLOSE /X
        
    } else {
        ${log}::debug Printing Generic Labels
        
        # Fix the file paths so that bartender doesn't choke
        set labelDir [join [split $mySettings(path,labelDir) /] \\]
        
        if {$GS_textVar(line5) != ""} {
            if {[string match "seattle met" [string tolower $GS_textVar(line1)]] eq 1} {
                        #set lineNumber 5
                        # Redirect for special print options
                        Shipping_Gui::chooseLabel 6
                        puts "5 Line Label"
    
            } else {
                exec $mySettings(path,bartender) /AF=$labelDir\\6LINEDB.btw /P /CLOSE /X
                ${log}::debug $mySettings(path,bartender) /AF=$labelDir\\6LINEDB.btw /P /CLOSE /X
            }
    
        } elseif {$GS_textVar(line4) != ""} {
            if {[string match "seattle met" [string tolower $GS_textVar(line1)]] eq 1} {
                        #set lineNumber 4
                        # Redirect for special print options
                        Shipping_Gui::chooseLabel 5
                        puts "5 Line Label"
    
                    } else {
                exec $mySettings(path,bartender) /AF=$labelDir\\5LINEDB.btw /P /CLOSE /X
                ${log}::debug $mySettings(path,bartender) /AF=$labelDir\\5LINEDB.btw /P /CLOSE /X
            }
    
        } elseif {$GS_textVar(line3) != ""} {
            if {[string match "seattle met" [string tolower $GS_textVar(line1)]] eq 1} {
                        #set lineNumber 3
                        # Redirect for special print options
                        Shipping_Gui::chooseLabel 4
                        puts "4 Line Label"
    
                    } else {
                exec $mySettings(path,bartender) /AF=$labelDir\\4LINEDB.btw /P /CLOSE /X
                ${log}::debug $mySettings(path,bartender) /AF=$labelDir\\4LINEDB.btw /P /CLOSE /X
            }
    
        } elseif {$GS_textVar(line2) != ""} {
            if {[string match "seattle met" [string tolower $GS_textVar(line1)]] eq 1} {
                            Error_Message::errorMsg seattleMet2; return
            } else {
            exec $mySettings(path,bartender) /AF=$labelDir\\3LINEDB.btw /P /CLOSE /X
            ${log}::debug $mySettings(path,bartender) /AF=$labelDir\\3LINEDB.btw /P /CLOSE /X
            }
    
        } elseif {$GS_textVar(line1) != ""} {
            if {[string match "seattle met" [string tolower $GS_textVar(line1)]] eq 1} {
                            Error_Message::errorMsg seattleMet2; return
            } else {
            exec $mySettings(path,bartender) /AF=$labelDir\\2LINEDB.btw /P /CLOSE /X
            ${log}::debug $mySettings(path,bartender) /AF=$labelDir\\2LINEDB.btw /P /CLOSE /X
            }
        }
    } ;# End generic labels
	
	

} ;# printLabels

proc printCustomLabels {args} {
    #****f* printCustomLabels/Shipping_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Prints custom labels
    #
    # SYNOPSIS
    #	printCustomLabels 3|4|5|6
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	Shipping_Code::writeHistory
    #
    # NOTES
    #	N/A
    #
    # SEE ALSO
    #	N/A
    #
    #***
    global mySettings log
	
	${log}::debug Printing custom labels: [join $args ""]
	set args [join $args ""]
	
	
	set labelDir [join [split $mySettings(path,labelDir) /] \\]
    exec $mySettings(path,bartender) /AF=$labelDir\\$args /P /CLOSE /X
    #${log}::debug programPath(Bartend) /AF=programPath(LabelPath)\\$args /P /CLOSE
}

proc truncateHistory {} {
    #****f* truncateHistory/Shipping_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2008 - Casey Ackels
    #
    # FUNCTION
    #	Opens the history file, and truncates it.
    #
    # SYNOPSIS
    #	truncateHistory
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	Shipping_Code::writeHistory
    #
    # NOTES
    #	N/A
    #
    # SEE ALSO
    #	N/A
    #
    #***
    global files GS_textVar frame1 log

    controlFile history fileread
    set history_data [read $files(history)]
    controlFile history fileclose
    set lines [split $history_data \n]

    # Keep the history file trimmed down
    if {[llength $lines] >= 16} {
        # llength starts at 1

        controlFile history filewrite
        set GS_textVar(history) "" ;# clear out the variable
        foreach line [lrange $lines end-15 end] {
            if {$line != ""} {
            #puts "truncate_csv: [::csv::join $line]"
            chan puts $files(history) $line
            puts "truncate lines: $line"
            }
            lappend GS_textVar(history) [lindex [::csv::split $line] 0]
        }
        controlFile history fileclose
    }

    if {[winfo exists .container] eq 1} {
        puts "config textVar: $GS_textVar(history)"
        $frame1.entry1 configure -values $GS_textVar(history)
    }

} ;# truncateHistory


proc writeHistory {maxBoxQty} {
    #****f* writeHistory/Shipping_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2008 - Casey Ackels
    #
    # FUNCTION
    #	Write the history of the entry labels out to a file; allowing a user to select it from the combobox
    #
    # SYNOPSIS
    #	 writeHistory
    #
    # CHILDREN
    #	 Shipping_Code::truncateHistory
    #
    # PARENTS
    #	Shipping_Code::displayListHelper
    #
    # NOTES
    #	N/A
    #
    # SEE ALSO
    #	N/A
    #
    #***
    global GS_textVar files log

    #puts "lsearch: [lsearch -glob -inline $GS_textVar(history) $GS_textVar(line1)]"

    if {[lsearch -glob -inline $GS_textVar(history) $GS_textVar(line1)] eq ""} {
        # Save only an entry if it is unique. Otherwise, discard it.
        # Use lappend so that if the text contains spaces ::csv::join will handle it correctly
        lappend textHistory "$GS_textVar(line1)" "$GS_textVar(line2)" "$GS_textVar(line3)" "$GS_textVar(line4)" "$GS_textVar(line5)" $maxBoxQty

        # Insert the values
        controlFile history fileappend
        chan puts $files(history) [::csv::join $textHistory]
        #puts "text: $textHistory"
        controlFile history fileclose
        
        ${log}::debug "WriteHistory: Saved $GS_textVar(line1)"
    }

    # After we add the new labels, lets make sure we trim the file back down to the allotted amount.
    truncateHistory

} ;# writeHistory


proc openHistory {} {
    #****f* openHistory/Shipping_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2008 - Casey Ackels
    #
    # FUNCTION
    #	Reads the history file
    #
    # SYNOPSIS
    #	openHistory
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	Shipping_Code::writeHistory Shipping_Code::readHistory
    #
    # NOTES
    #	N/A
    #
    # SEE ALSO
    #	Shipping_Code::writeHistory Shipping_Code::readHistory Shipping_Code::controlFile
    #
    #***
    global GS_textVar files frame1 log
    puts "openHistory: Starting"

    controlFile history fileread
    set history_data [read $files(history)]
    controlFile history fileclose

    puts "Open historyData: $history_data"
    ;# Guard against an empty history file. If nothing is found set the *(history) variable with an empty string
    if {$history_data eq ""} {
        set GS_textVar(history) ""

    } else {
        set lines [split $history_data \n]
        #set lines [lrange [split $history_data \n] end-5 end] ;# This means we'll have 5 labels, and one "empty label"
        #puts "openHistory_lines: $lines"
        set GS_textVar(history) "" ;# make sure the variable is cleared out.

        foreach line $lines {
            lappend GS_textVar(history) [lindex [::csv::split $line] 0]
        }
    }
    
    ${log}::debug "historyData: $GS_textVar(history)"

    #puts "openHistory: Ending"
} ;#openHistory


proc readHistory {args} {
    #****f* openHistory/Shipping_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2008 - Casey Ackels
    #
    # FUNCTION
    #	Opens the flat-file database of the 15 most recent labels that have previously been made.
    #   This is called by the <<ComboboxSelected>> virtual event
    #
    # SYNOPSIS
    #	openHistory
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
    global GS_textVar files lineText

    controlFile history fileread
    set history_data [read $files(history)]
    set lines [split $history_data \n]
    puts "Read history lines: $lines"
    controlFile history fileclose


    set text [lindex $lines $args]
    puts "text: $text"

    set x 1
    foreach line [::csv::split $text] {
        #puts "retrieve: $line"
        if {$x <= 5} {
            set GS_textVar(line$x) $line
            #set lineText(data$x) [string length $GS_textVar(line$x)]
            if {[string length $GS_textVar(line$x)] != 0} {
                set lineText(data$x) [string length $GS_textVar(line$x)]
                    } else {
                set lineText(data$x) ""
            }
            incr x
        } else {
            set GS_textVar(maxBoxQty) $line
            }
    }
    # If text holds no data, clear all lines
      if {$text eq ""} {
        for {set x 1} {$x<6} {incr x} {
            set GS_textVar(line$x) ""
            #set lineText(data$x) [string length $GS_textVar(line$x)]
            if {[string length $GS_textVar(line$x)] != 0} {
                set lineText(data$x) [string length $GS_textVar(line$x)]
                    } else {
                set lineText(data$x) ""
            }
        }
        set GS_textVar(maxBoxQty) ""
    }

    ;# clear the listbox
    Shipping_Code::clearList
} ;# readHistory

proc countLength {args} {
    # arg1 = Line Number
    # arg2 =
    global lineLength
    [string length $GS_textVar(line1)]
}


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
    global GS_textVar

    # This shouldn't be needed, we have existing code in the [bind]ing, and in the button command
    #if {$GS_textVar(destQty) eq ""} {return}

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
    global frame2b

    #puts clearList
    #puts "clearList: [$frame2b.listbox delete 0 end]"
    catch {$frame2b.listbox delete 0 end} ;# This always generates "0,0 cell not in range" error

    Shipping_Code::addListboxNums 1 ;# Reset Counter
    Shipping_Code::displayListHelper "" "" 1 ;# Reset Counter
}
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

