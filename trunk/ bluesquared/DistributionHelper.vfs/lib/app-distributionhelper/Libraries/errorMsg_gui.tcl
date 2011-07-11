# Creator: Casey Ackels (C) 2006 - 20011
# Initial Date: October 28th, 2006
# Massive Rewrite: February 2nd, 2007


##
## - Overview
# This file holds the error messages for Efficiency Assist

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


proc Error_Message::errorMsg {code args} {
    
    set defaultTitle [mc "Missing Information"]
    set dupeTitle [mc "Duplicate Information"]
    
    switch -- $code {
        jobNumber1      {set message [mc "Please specify a job number."]; set message2 [mc "Error Location %s" $code]; set title $defaultTitle}
        shipVia1        {set message [mc "Please specify how to ship your shipments."]; set message2 [mc "Error Locations %s" $code]; set title $defaultTitle}
        pieceWeight1    {set message [mc "Please insert a value for your Piece Weight."]; set message2 [mc "Error Location: %s" $code]; set title $defaultTitle}
        fullBoxQty1     {set message [mc "Please enter the full box amount."]; set message2 [mc "Error Location: %s" $code]; set title $defaultTitle}
        3rdParty1       {set message [mc "Please enter a 3rd Party Account Number."]; set message2 [mc "Error Location: %s" $code]; set title $defaultTitle}
        header1         {set message [mc "This name already exists and cannot be used twice.\nIt is located in the %s header" $args]; set message2 ""; set title $dupeTitle}
        default         {set message [mc "Unknown Error Message"]; set message2 ""}
    }
    
    tk_messageBox \
        -parent . \
        -default ok \
        -icon warning \
        -title $title \
        -message "$message\n\nPlease fix this, then I can continue.\n\n$message2"
    
} ;# end of errorMsg