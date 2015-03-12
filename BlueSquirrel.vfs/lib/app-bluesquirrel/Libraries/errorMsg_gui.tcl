# Name: List Display
# Creator: Casey Ackels (C) 2006 - 2007
# Initial Date: October 28th, 2006
# Massive Rewrite: February 2nd, 2007
# Last Updated: See shipping_gui.tcl
# Version: See shipping_launch_code.tcl
# Dependencies: See shipping_launch_code.tcl

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


proc detectError {windowPath} {
    global gui
    
    switch -- $windowPath {
        $gui(S_brassFile) {
                        if {$gui(S_brassFile) eq "Please select a file"} { errorMsg brassGUI_1
                        } else {
                            set gui(S_brassFile) [tk_getOpenFile]
                        }
        }
    }
}


proc errorMsg {code} {
    global frame2
    
    switch -- $code {
        brassGUI_1 {set message "It looks like you forgot to select your file."; set message2  "Error Location: $code"; focus $frame2.entry1}
        createList2 {set message "It looks like you forgot to include a \'Destination Quantity\'"; set message2 "Error Location: $code"}
        insertInListBox1 {set message "Oops, that isn't a number"; set message2 "Error Location: $code"; focus $frame1.entry1}
        printLabels1 {set message "Looks like the 'Max Qty per Box' was never set. Please do so now."; set message2 "Error Location: $code"}
        seattleMet1 {set message "You have too many lines for Seattle Met labels. 3 Lines allowed."; set message2 "Error Location: $code"}
        seattleMet2 {set message "You are missing a few lines of text for Seattle Met labels. Must use 3 lines."; set message2 "Error Location: $code"}
        default {set message "Unknown Error Message"; set message2 ""}
    }
    
    tk_messageBox \
        -parent . \
        -default ok \
        -icon warning \
        -title "Missing Information" \
        -message "$message\n\nPlease fix this, then I can continue.\n\n$message2"
} ;# end of errorMsg


} ;# End namespace Error_Message