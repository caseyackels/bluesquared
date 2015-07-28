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