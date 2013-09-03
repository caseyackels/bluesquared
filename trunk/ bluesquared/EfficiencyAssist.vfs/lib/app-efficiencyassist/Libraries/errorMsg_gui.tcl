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
        default         {set message [mc "Unknown Error Message"]
                            set message2 ""
                            set icon error}
    }
    
    tk_messageBox \
        -parent . \
        -default ok \
        -icon $icon \
        -title $title \
        -message "$message\n\n$message2"
    
} ;# end of errorMsg


proc Error_Message::newVersion {txt command args} {
    #****f* newVersion/Error_Message
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2012 - Casey Ackels
    #
    # FUNCTION
    #	Error_Message::newVersion {Button Text} {Button Code} {args (Text)}
    #
    # SYNOPSIS
    #	Calling this command detects if the user is launching this version for the first time, if so we tell them where to look for new features, bug fixes, etc.
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
    
    toplevel .newVersion
    wm transient .newVersion .
    wm title .newVersion [mc "New Version Detected"]

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 2 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 2 + [winfo y .]}]
    puts "newVersion_x: $locX"
    puts "newVersion_y: $locY"
    
    wm geometry .newVersion +${locX}+${locY}
    #wm geometry . 640x575 ;# width x Height

    focus .newVersion
    
    ##
    ## Parent Frame
    ##
    set frame0 [ttk::frame .newVersion.frame0]
    pack $frame0 -expand yes -fill both -pady 5p -padx 5p
    
    ttk::label $frame0.txt -text [mc "A new version has been detected!"]
    ttk::label $frame0.notes1 -text [mc "Special Notes:"]
    ttk::label $frame0.notes2 -text [join $args]
    ttk::label $frame0.notes3 -text [mc "To prevent seeing this message again, open Preferences, and click 'Save & Close'"]
    
    grid $frame0.txt -column 0 -row 0 -columnspan 2 -sticky ns
    grid $frame0.notes1 -column 0 -row 1 -sticky ew
    grid $frame0.notes2 -column 1 -row 2 -sticky ew
    grid $frame0.notes3 -column 1 -row 3 -sticky ew
    
    
    ##
    ## Button Bar
    ##

    set buttonbar [ttk::frame .newVersion.buttonbar]
    if {$txt ne "" && $command ne ""} {
        ttk::button $buttonbar.misc -text $txt -command $command
        grid $buttonbar.misc -column 0 -row 3 -sticky news
    }
    ttk::button $buttonbar.ok -text [mc "View Change Log"] -command { BlueSquared_About::aboutWindow 2 }
    ttk::button $buttonbar.close -text [mc "Close"] -command { destroy .newVersion }

    grid $buttonbar.ok -column 1 -row 3 -sticky nwe -padx 8p -ipadx 4p
    grid $buttonbar.close -column 2 -row 3 -sticky nse -ipadx 4p
    pack $buttonbar -side bottom -anchor e -pady 8p -padx 5p
}
