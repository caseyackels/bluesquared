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

    if {$action == 1 & $value != {} & [set pop [lsort [lsearch -inline $valuelist $value*]]] != {}} {
         $win delete 0 end;  $win insert end $pop
         $win selection range [string length $value] end
         $win icursor [string length $value]
    } else {
        $win selection clear
   }
   
   after idle [list $win configure -validate $validation]
   return 1
    
} ;# AutoComplete::AutoComplete
