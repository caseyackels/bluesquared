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
namespace eval msg {}


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
        jobNumber1      {set message [mc "Please specify a job number."]
                            set message2 [mc "Error Location %s" $code]
                            set title $defaultTitle
                            set icon error}
        shipVia1        {set message [mc "Please specify how to ship your shipments."]
                            set message2 [mc "Error Locations %s" $code]
                            set title $defaultTitle
                            set icon error}
        pieceWeight1    {set message [mc "Please insert a value for your Piece Weight."]
                            set message2 [mc "Error Location: %s" $code]
                            set title $defaultTitle
                            set icon error}
        fullBoxQty1     {set message [mc "Please enter the full box amount."]
                            set message2 [mc "Error Location: %s" $code]
                            set title $defaultTitle
                            set icon error}
        3rdParty1       {set message [mc "Please enter a 3rd Party Account Number."]
                            set message2 [mc "Error Location: %s" $code]
                            set title $defaultTitle
                            set icon error}
        header1         {set message [mc "This name already exists and cannot be used twice.\nIt is located in the %s header" $args]
                            set message2 ""
                            set title $dupeTitle
                            set icon error}
        quantity1       {set message [mc "Please enter the Shipment Quantity."]
                            set message2 [mc "Error Location: %s" $code]
                            set title $defaultTitle
                            set icon error}
        saveSettings1   {set message [mc "Please specify what folder you would like files to be saved in, and where to look when opening files. You can set these options in Preferences."]
                            set message2 [mc "Error Location: %s" $code]
                            set title [mc "New Information"]
                            set icon info}
        deladdress1     {set message [mc "Detected an address over 35 characters, you must fix this before shipping!\n$args"]
                            set message2 [mc "Error Location: %s" $code]
                            set title $defaultTitle
                            set icon warning}
        seattleMet1     {set message [mc "Detected an address over 35 characters, you must fix this before shipping!\n$args"]
                            set message2 [mc "Error Location: %s" $code]
                            set title $defaultTitle
                            set icon warning}
        seattleMet2     {set message [mc "You must have more than 2 lines of information"]
                            set message2 [mc "Error Location: %s" $code]
                            set title $defaultTitle
                            set icon warning}
        BM001           {set message [mc "Alpha Characters were detected, quantity will not be totaled. Remove the non-numeric characters"]
                            set message2 [mc "Error Location: %s" $code]
                            set title [mc Warning]
                            set icon warning}
        BM002           {set message [mc "Customer ID must be filled in."]
                            set message2 [mc "Error Location: %s" $code]
                            set title [mc $defaultTitle]
                            set icon warning
                            }
        BM003           {set message [mc "Only one address can be assigned to a single version."]
                            set message2 [mc "Error Location: %s" $code]
                            set title [mc Warning]
                            set icon warning
                        }
        EA001           {set message [mc "You have not yet been set up in the system.\n$args\User: $user(id)"]
                            set message2 [mc "Error Location: %s" $code]
                            set title [mc $defaultTitle]
                            set icon warning}
        SETUP001        {set message [mc "Record is already used on Header: %s" $args]
                            set message2 [mc "Error Location: %s" $code]
                            set title $dupeTitle
                            set icon warning
                        }
        BL001           {set message [mc "Template ID is invalid. Try again."]
                            set message2 [mc "Error Location: %s" $code]
                            set title [mc "Warning"]
                            set icon warning
                        }
        BL002           {set message [mc "Please enter a quantity for Max. Qty per Box"]
                            set message2 [mc "Error Location: %s" $code]
                            set title [mc "Warning"]
                            set icon warning
                        }
        BL003           {set message [mc "You still have a quantity in the Quantity field."]
                            set message2 [mc "Error Location: %s" $code]
                            set title [mc "Warning"]
                            set icon warning
                        }
        default         {set message [mc "Unknown Error Message"]
                            set message2 [mc "Received Message: %s" $code]
                            set title $defaultTitle
                            set icon error}
    }
    
    tk_messageBox \
        -parent . \
        -default ok \
        -icon $icon \
        -title $title \
        -message "$message\n\n$message2"
    
} ;# end of errorMsg


proc msg::initMessages {} {
    #****f* initMessages/msg
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Initialize messages
    #
    # SYNOPSIS
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
    # SEE ALSO
    #
    #***
    global log msgs
    #${log}::debug --START-- [info level 1]
    
    # Initialize
    set msgs [dict create]
    
    dict set $msgs 
    
	
    #${log}::debug --END-- [info level 1]
} ;# msg::initMessages
