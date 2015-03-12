# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 09 23,2014
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision$
# $LastChangedBy: casey.ackels $
# $LastChangedDate$
#
########################################################################################

##
## - Overview
# Auto-Complete package found on wiki.tcl.tk

namespace eval AutoComplete {}

proc AutoComplete::AutoComplete {win action validation value valuelist} {
    #****f* AutoComplete/AutoComplete
    # CREATION DATE
    #   09/23/2014 (Tuesday Sep 23)
    #
    # AUTHOR
    #	Andrew Black
    #   
    #
    # SYNOPSIS
    #   AutoComplete::AutoComplete %W %d %v %P ?list to search on?
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
    #   
    # SEE ALSO
    #   
    #   
    #***
    
    if {$action == 1 & $value != {} & [set pop [lsearch -nocase -inline $valuelist $value*]] != {}} {
         $win delete 0 end;  $win insert end $pop
         $win selection range [string length $value] end
         $win icursor [string length $value]
    } else {
        $win selection clear
   }
   
   after idle [list $win configure -validate $validation]
   return 1
    
} ;# AutoComplete::AutoComplete

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