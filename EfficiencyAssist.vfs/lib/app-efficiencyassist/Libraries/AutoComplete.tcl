# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 09 23,2014
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 572 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2014-11-07 17:01:16 -0800 (Fri, 07 Nov 2014) $
#
########################################################################################

##
## - Overview
# Auto-Complete package found on wiki.tcl.tk

namespace eval AutoComplete {}


proc AutoComplete::AutoComplete {win action validation value valuelist {capitalize 1}} {
    #****f* AutoComplete/AutoComplete
    # CREATION DATE
    #   09/23/2014 (Tuesday Sep 23)
    #
    # AUTHOR
    #	Andrew Black
    #   
    #
    # SYNOPSIS
    #   This is for the ttk::entry widget
    #   AutoComplete::AutoComplete %W %d %v %P <list to search on> ?upper|title?
    #
    # FUNCTION
    #	use autocomplete in the validate command of an entry box as follows
    #	-validatecommand {autocomplete %W %d %v %P $list}
    #	where list is a tcl list of values to complete the entry with
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   Found on http://wiki.tcl.tk/13267
    #   ttk::combobox specific http://wiki.tcl.tk/15780
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log
    
    if {[info exists newVal]} {unset newVal}
    switch -- [string tolower $capitalize] {
        upper   {
                    set newVal [string toupper $value]
                    #${log}::debug To Upper: $value
        }
        title   {
                    foreach val $value {
                        lappend newVal [string totitle $val]
                    }
                
                #${log}::debug To Title: $value
        }
        1       {
            # Nothing will change
        }
        default {${log}::notice [mc "AutoComplete: Capitalization will not be changed"]}
    } 

    
    if {$action == 1 & $value != {} & [set pop [lsearch -nocase -inline $valuelist $value*]] != {}} {
         $win delete 0 end;  $win insert end $pop
         $win selection range [string length $value] end
         $win icursor [string length $value]
    } elseif {$action == -1} {
        # insert the correct capitalized version if we don't have a match
        if {![info exists newVal]} {return 1}
        $win delete 0 end; $win insert end $newVal
   } else {
        $win selection clear
   }
   
   after idle [list $win configure -validate $validation]
   return 1
    
} ;# AutoComplete::AutoComplete


proc AutoComplete::AutoCompleteComboBox {path key} {
    #****f* AutoCompleteComboBox/AutoComplete
    # CREATION DATE
    #   11/07/2014 (Friday Nov 07)
    #
    # AUTHOR
    #	Torsten Berg
    #
    # COPYRIGHT
    #	(c) Torsten Berg
    #   
    #
    # SYNOPSIS
    #   Autocomplete for the ttk::combobox
    #   AutoComplete::AutoCompleteComboBox path key 
    #
    # FUNCTION
    #   Inserts matched values into the combobox. If you keep typing, it will replace the current value with the next one that matches.
    #
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   From http://wiki.tcl.tk/15780
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log

    ${log}::debug PRESSED $path __ $key
    
    if {[string length $key] > 1 && [string tolower $key] != $key} {
            ${log}::debug Length is less than 1.
            #bind $path <KeyRelease> break
            return
        }
    
    set text [string map [list {[} {\[} {]} {\]}] [$path get]]
    if {[string equal $text ""]} {return}
    
    set values [$path cget -values]
    set x [lsearch -nocase $values $text*]
    if {$x < 0} {
        #${log}::debug No Matches
        ##set index [expr {[$path index insert] -1}]
        #set index [$path index insert]
        ##$path set [lindex $values $x]
        ##$path icursor $index
        ##$path selection range insert end
        #${log}::debug $path delete $index
        #$path delete $index

        return
    } else {
        set index [$path index insert]
        $path set [lindex $values $x]
        $path icursor $index
        $path selection range insert end
    }

    
} ;# AutoComplete::AutoCompleteComboBox

proc AutoComplete::AutoCompleteComboBox_test {path key} {
    #****f* AutoCompleteComboBox/AutoComplete
    # CREATION DATE
    #   11/07/2014 (Friday Nov 07)
    #
    # AUTHOR
    #	Torsten Berg
    #
    # COPYRIGHT
    #	(c) Torsten Berg
    #   
    #
    # SYNOPSIS
    #   Autocomplete for the ttk::combobox
    #   AutoComplete::AutoCompleteComboBox path key 
    #
    # FUNCTION
    #   Inserts matched values into the combobox. If you keep typing, it will replace the current value with the next one that matches.
    #
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   From http://wiki.tcl.tk/15780
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log tmp
    #if {[string length $key] > 1 && [string tolower $key] != $key} {
    #        return
    #    }
    
    #set key $tmp(typeahead)
    puts "starting autocomplete ... $key"
    
    #set text [string map [list {[} {\[} {]} {\]}] [$path get]]
    #puts "ac: $text"
    #if {[string equal $text ""]} {return}
    
    set values [$path cget -values]
    
    #puts "ac: values: $values"
    set x [lsearch -nocase $values $key*]
    if {$x < 0} {
        return
    } else {
        #set index [$path index insert]
        #puts "carrier: [lindex $values $x]"
        $path set [lindex $values $x]
    }
    
} ;# AutoComplete::AutoCompleteComboBox

proc AutoComplete::typeahead {win} {
    #****if* typehead/AutoComplete
    # CREATION DATE
    #   11/09/2015 (Monday Nov 09)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   This is used for read-only comboboxes, use AutoComplete::AutoComplete for entry boxes, and AutoComplete::AutoCompleteComboBox for editable
    #   
    #***
	global log tmp
		#bind .di <Key> {puts "You pressed the key called \"%K\""}
	bind $win <Key> {
		switch -- %k {
			8	{
				# Backspace - BackSpace
				set word [string range $word 0 end-1]
			}
			9	{
				# Tab - Tab
			}
			13	{
				# Enter - Return (keypad)
			}
			16	{
				# Left Shift - Shift_L
			}
			17	{
				# Left Control - Control_L
				# Right Control - Control_R
			}
			18	{
				# Left Alt - Alt_L
				# Right Alt - Alt_R
			}
			20	{
				# Caps Lock - Caps_Lock
			}
			27	{
				# Esc - Escape
			}
			32	{
				# Space
				append word " "
			}
			33	{
				# Page Up - Prior
			}
			34	{
				# Page Down - Next
			}
			35	{
				# End
			}
			36	{
				# Home
			}
			37	{
				# Left Arrow - Left
			}
			38	{
				# Up Arrow - Up
			}
			39	{
				# Right Arrow - Right
			}
			40	{
				# Down Arrow - Down
			}
			45	{
				# Insert
			}
			46	{
				# Delete
			}
			49	{
				# Exclamation - exclam
				# Number 1 - 1
				if {%K == 1} {set x 1} else {set x !}
				append word $x
			}
			50	{
				# @ - at
				# Number 2 - 2
				if {%K == 2} {set x 2} else {set x @}
				append word $x
			}
			51	{
				# # - numbersign
				# Number 3 - 3
				append word $x
			}
			52	{
				# $ - dollar
				# Number 4 - 4
				if {%K == 4} {set x 4} else {set x $}
				append word $x
			}
			53	{
				# % - percent
				# Number 5 - 5
				if {%K == 5} {set x 5} else {set x \%}
				append word $x
			}
			54	{
				# (shift+6) - asciicircum
				# Number 6 - 6
				if {%K == 6} {set x 6} else {set x \^}
				append word $x
			}
			55	{
				# & - ampersand
				# Number 7 - 7
				if {%K == 7} {set x 7} else {set x &}
				append word $x
			}
			56	{
				# * - asterisk
				# Number 8 - 8
				if {%K == 8} {set x 8} else {set x *}
				append word $x
			}
			57	{
				#  parenleft
				# Number 9 - 9
				#if {%K == 9} {set x 9} else {set x }
				append word $x
			}
			58 {
				#  parenright
				# Number 0 - 0
				#if {%K == 0} {set x 0} else {set x }
				append word $x
			}
			96	{
				# (keypad) 0
				append word 0
			}
			97	{
				# (keypad) 1
				append word 1
			}
			98	{
				# (keypad) 2
				append word 2
			}
			99	{
				# (keypad) 3
				append word 3
			}
			100	{
				# (keypad) 4
				append word 4
			}
			101	{
				# (keypad 5)
				append word 5
			}
			102	{
				# (keypad 6)
				append word 6
			}
			103	{
				# (keypad) 7
				append word 7
			}
			104	{
				# (keypad) 8
				append word 8
			}
			105	{
				# (keypad) 9
				append word 9
			}
			106	{
				# * - asterisk (keypad)
			}
			107	{
				# + - plus (keypad)
			}
			109	{
				# - - minus (keypad)
			}
			110	{
				# . - period (keypad)
				append word .
			}
			111	{
				# / - slash (keypad)
			}
			187	{
				# + - plus
				# = - equal
			}
			189	{
				# _ - underscore
				# (-) - minus
				if {"%K eq "minus"} {set x -} else {set x _}
				append word $x
			}
			112	{
				# F1
			}
			113 {
				# F2
			}
			114 {
				# F3
			}
			115 {
				# F4
			}
			116	{
				# F5
			}
			117	{
				# F6
			}
			118	{
				# F7
			}
			119	{
				# F8
			}
			120	{
				# F9
			}
			121	{
				# F10
			}
			122	{
				# F11
			}
			123	{
				# F12
			}
			145	{
				# Scroll Lock - Scroll_Lock
			}
			186	{
				# : - colon
				# - semicolon
			}
			188	{
				# , - comma
				# < - less
				if {"%K" eq "comma"} {set x ,} else {set x <}
				append word $x
			}
			190	{
				# . - period
				# > - greater
				if {"%K" eq "period"} {set x .} else {set x >}
				append word $x
			}
			191	{
				# ? - question
				#  - slash
			}
			192	{
				# Quote Left  - quoteleft
				# ~ - asciitilde
			}
			219	{
				#   - braceleft
				#  - bracketleft
			}
			220	{
				# | - bar
				# 
			}
			221	{
				#  - braceright
				#  - bracketright
			}
			222	{
				# Double Quote - quotedbl
				# Single Quote - quoteright
			}
			default {
				append word %K
			}
		}
		#puts $word
        if {[info exists word]} {
            set tmp(typeahead) $word
        } else {
            return
        }
        set tmp(typeahead) $word
        #after 3000 ${log}::debug unsetting -nocomplain tmp(typeahead)
        after 3000 unset -nocomplain tmp(typeahead)
        after 3000 unset -nocomplain word
		AutoComplete::AutoCompleteComboBox_test %W $tmp(typeahead)
	}
    
    bind $win <FocusOut> {
        #${log}::debug Unsetting by FocusOut
        unset -nocomplain tmp(typeahead)
        unset -nocomplain word
    }
}
###
### -- This is useful if we want to search on ShipViaCode, and return the name of the carrier.
###
#proc AutoComplete::AutoCompleteShipVia {win action validation value} {
#if {[string is digit $value]} {
#    puts "digits..."
#    # Look at the ShipViaCode table, and return the carrier name
#    # Valuelist = db query for shipviacodes; value = what we're typing
#    set valuelist [db eval {SELECT ShipViaCode FROM ShipVia}]
#    #puts "valuelist: $valuelist"
#    set pop [lsearch -nocase -inline $valuelist $value*]
#    #puts "pop: $pop"
#        if {$pop ne ""} {
#            set dbQuery [db eval {SELECT Name FROM ShipVia 
#                        INNER JOIN Carriers
#                            ON Carriers.Carrier_ID = ShipVia.CarrierID
#                        WHERE ShipViaCode = $pop}]
#        }
#        #puts "dbQuery: $dbQuery"
#    } else {
#    # The user is typing letters ...
#    # valuelist = dbquery for carrier names
#    puts "letters..."
#    set valuelist [db eval {SELECT Name FROM Carriers}]
#        #puts "valuelist: valuelist"
#        set dbQuery [lsearch -nocase -inline $valuelist $value*]
#        #puts "dbQuery: $dbQuery"
#    }
#    
#    if {$action == 1 & $value != {} & $dbQuery != {}} {
#         $win delete 0 end;  $win insert end [join $dbQuery]
#         $win selection range [string length $value] end
#         $win icursor [string length $value]
#    } else {
#        $win selection clear
#   }
#   
#   after idle [list $win configure -validate $validation]
#   return 1
#}