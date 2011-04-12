# Creator: Casey Ackels (C) 2006 - 20011
# Initial Date: October 28th, 2006
# Massive Rewrite: February 2nd, 2007


##
## - Overview
# This file holds the error messages for the List Display (Shipping).

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

namespace eval Error_Message {}


proc Error_Message::detectError {windowPath} {
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


proc Error_Message::errorMsg {code} {
    
    switch -- $code {
        jobNumber1  {set message [mc "You must specify a job number."]; set message2 [mc "Error Location %s" $code]}
        pieceWeight1 {set message [mc "You do not have a value set for your Piece Weight"]; set message2 [mc "Error Location: %s" $code]}
        fullBoxQty1 {set message [mc "You did not enter the full box amount"]; set message2 [mc "Error Location: %s" $code]}
        default {set message [mc "Unknown Error Message"]; set message2 ""}
    }
    
    tk_messageBox \
        -parent . \
        -default ok \
        -icon warning \
        -title [mc "Missing Information"] \
        -message "$message\n\nPlease fix this, then I can continue.\n\n$message2"
    
} ;# end of errorMsg