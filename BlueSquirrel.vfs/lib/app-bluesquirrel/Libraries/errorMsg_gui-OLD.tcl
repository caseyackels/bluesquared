# Creator: Casey Ackels (C) 2006 - 2007
# Initial Date: October 28th, 2006
# Massive Rewrite: February 2nd, 2007
# Last Updated: See shipping_gui.tcl
# Dependencies: See shipping_launch_code.tcl
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 7 $
# $LastChangedBy: casey $
# $LastChangedDate: 2007-02-21 20:09:36 -0800 (Wed, 21 Feb 2007) $
#
########################################################################################

##
## - Overview
# This file holds the error messages for the List Display (Shipping).

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

namespace eval Error_Message {
    namespace export errorMsg
    
proc errorMsg {code} {
    global frame1
    
    switch -- $code {
        createList1 {set message1 "It looks like you forgot to include the \'Max. Qty per Box amount\'"; set message2  "Error Location: $code"; focus $frame1.entry}
        createList2 {set message1 "It looks like you forgot to include a \'Destination Quantity\'"; set message2 "Error Location: $code"}
        insertInListBox1 {set message1 "Oops, that isn't a number"; set message2 "Error Location: $code"; focus $frame1.entry1}
        default {set message1 "Unknown Error Message"}
    }
    
    tk_messageBox \
        -parent . \
        -default ok \
        -icon warning \
        -title "Missing Information" \
        -message "$message1.\n\nPlease fix this, then I can continue.\n\n$message2"
} ;# end of errorMsg


} ;# End namespace Error_Message