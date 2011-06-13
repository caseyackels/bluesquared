# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision$
# $LastChangedBy$
# $LastChangedDate$
#
########################################################################################

##
## - Overview
# This file holds the parent GUI frame, buttons and menu for Distribution Helper

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

## Coding Conventions
# - Namespaces: 

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

namespace eval Disthelper_Code {}


proc Disthelper_Code::readFile {filename} {
    #****f* readFile/Disthelper_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Open the target file, and read it into Distribtion Helper
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	Disthelper_Code::getOpenFile
    #
    # NOTES
    #   Global Array
    #   GL_file / DataList Header
    #   GS_file / Name
    #   GS_job / Number, Name, Quantity, pieceWeight, fullBoxQty, Date, Version
    #
    # SEE ALSO
    #
    #
    #***
    global GL_file GS_file GS_job GS_ship GS_address

    
    # Cleanse file name, and prepare it for when we create the output file.
    set GS_file(Name) [join [lrange [file rootname [file tail $filename]] 0 end]]
    'debug "GS_file(Name): $GS_file(Name)"
    
    set GS_job(Number) [join [lrange [split $GS_file(Name)] 0 0]]
    set GS_job(Number) [string trimleft $GS_job(Number) #]
    'debug "Job Number: $GS_job(Number)"
    'debug "filename: $filename"
    
    # Open File the file
    set fileName [open "$filename" RDONLY]
      
    # Make the data useful, and put it into lists
    # While we are at it, make everything UPPER CASE
    while { [gets $fileName line] >= 0 } {
        lappend GL_file(dataList) [string toupper $line]
        'debug "while: $line"
    }

    chan close $fileName
    
    set GL_file(Header) [csv::split [lindex $GL_file(dataList) 0]]
    

    # Set the entry widgets to normal state, special handling for the Customer frame is required since they are not always used.
    Disthelper_Helper::getChildren normal
    
    foreach line $GL_file(Header) {
        # If the file has headers, lets auto-insert the values to help the user.
        .container.frame1.listbox insert end $line

        switch -nocase $line {
            "Ship Via"          {set GS_ship(shipVia) $line}
            Company             {set GS_address(Company) $line}
            Consignee           {set GS_address(Consignee) $line}
            Address1            {set GS_address(deliveryAddr) $line}
            Address2            {set GS_address(addrTwo) $line}
            Address3            {set GS_address(addrThree) $line}
            City                {set GS_address(City) $line}
            State               {set GS_address(State) $line}
            Zip                 {set GS_address(Zip) $line}
            Phone               {set GS_address(Phone) $line}
            Quantity            {set GS_job(Quantity) $line}
            Version             {set GS_job(Version) $line}
            "Ship Date"         {set GS_job(Date) $line}
            "3rd Party"         {set GS_job(3rdParty) $line}
            EmailContact        {set GS_job(Contact) $line}
            email               {set GS_job(Email) $line}
            default             {puts "Didn't set anything"}
        }
    }


} ;# Disthelper_Code::readFile


proc Disthelper_Code::doMath {totalQuantity maxPerBox} {
    #****f* doMath/Disthelper_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Disthelper_Code::doMath TotalQuantity MaxPerBox
    #
    # SYNOPSIS
    #	Read in the total quantity of a shipment, along with the maximum qty per box, the output is total number of full boxes, and the qty of the partial.
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	Disthelper_Code::writeOutPut
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    # Do mathmatical equations, then double check to make sure it comes out to the value of totalQty
    
    # Guard against a mistake that we could make
    if {$totalQuantity == "" || $totalQuantity == 0} {puts "I need a total qty argument!"; return}
    
    if {$totalQuantity < $maxPerBox} {
	lappend partialBoxQTY
    }
    
    set divideTotalQuantity [expr {$totalQuantity/$maxPerBox}]
    'debug "divideTotalQuantity: $divideTotalQuantity"
    
    set totalFullBoxs [expr {round($divideTotalQuantity)}]
    set fullBoxQTY [expr {round(floor($divideTotalQuantity) * $maxPerBox)}]
    
    ## Use fullBoxQty as a starting point for the partial box.
    lappend partialBoxQTY [expr {round($totalQuantity - $fullBoxQTY)}]
    
    puts "doMath::TotalQty: $totalQuantity"
    puts "doMath::maxPerBox: $maxPerBox"
    puts "doMath::totalFullBoxs: $totalFullBoxs"
    puts "doMath::partialBoxQTY: $partialBoxQTY"
    
    #totalFullBoxs = full box total for that shipment
    #partialBoxQty = the partial amount of that shipment. 
    return [list $totalFullBoxs $partialBoxQTY]

    #puts "Ending doMath"
    
} ;# End of doMath


proc Disthelper_Code::writeOutPut {} {
    #****f* writeOutPut/Disthelper_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Write out the data to a file
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	
    #
    # PARENTS
    #	disthelper::parentGUI
    #
    # NOTES
    #	Set the ability to save the path to where you want the files saved to.
    #
    #   Used: Global Arrays
    #   GL_file / dataList, Header
    #   GS_job / Number, Name, Quantity, pieceWeight, fullBoxQty, Date, Version, Contact, Email, 3rdParty
    #   GS_ship / shipVia
    #   GS_address / Consignee, Company, addrThree, addrTwo, deliveryAddr, City, State, Zip, Phone
    #   settings / BoxTareWeight
    #
    #   Set: Global Arrays
    #
    # SEE ALSO
    #	
    #
    #***
    global GS_job GS_ship GS_address GL_file GS_file settings

    # Error checking
    # Delivery Address
    if {$GS_job(Number) == ""} {Error_Message::errorMsg jobNumber1; return}
    if {$GS_ship(shipVia) == ""} {Error_Message:errorMsg shipVia1; return}
    if {$GS_job(pieceWeight) == ""} {Error_Message::errorMsg pieceWeight1; return}
    if {$GS_job(fullBoxQty) == ""} {Error_Message::errorMsg fullBoxQty1; return}


    # Get the indices of each element of the address/shipment information. Later we will use this to map the data.
    array set importFile "
        shipVia     [lsearch $GL_file(Header) $GS_ship(shipVia)]
        Company     [lsearch $GL_file(Header) $GS_address(Company)]
        Consignee   [lsearch $GL_file(Header) $GS_address(Consignee)]
        delAddr     [lsearch $GL_file(Header) $GS_address(deliveryAddr)]
        delAddr2    [lsearch $GL_file(Header) $GS_address(addrTwo)]
        delAddr3    [lsearch $GL_file(Header) $GS_address(addrThree)]
        City        [lsearch $GL_file(Header) $GS_address(City)]
        State       [lsearch $GL_file(Header) $GS_address(State)]
        Zip         [lsearch $GL_file(Header) $GS_address(Zip)]
        Phone       [lsearch $GL_file(Header) $GS_address(Phone)]
        Quantity    [lsearch $GL_file(Header) $GS_job(Quantity)]
        Version     [lsearch $GL_file(Header) $GS_job(Version)]
        Date        [lsearch $GL_file(Header) $GS_job(Date)]
        Contact     [lsearch $GL_file(Header) $GS_job(Contact)]
        Email       [lsearch $GL_file(Header) $GS_job(Email)]
        3rdParty    [lsearch $GL_file(Header) $GS_job(3rdParty)]
    "

    # Make sure we only activate the following two variables if they data actually exists.
    if {$importFile(Email) != -1} {set EmailGateway Y} else {set EmailGateway .}
    if {$importFile(3rdParty) != -1} {set PaymentTerms 3} else {set PaymentTerms .}
    
    
    # Open the destination file for writing
    set filesDestination [open [file join $settings(outFilePath) "$GS_file(Name) Copy.csv"] w]

    # line = each address string
    # GL_file(dataList) = the entire shipping file
    foreach line $GL_file(dataList) {
        set l_line [csv::split $line]
        set l_line [join [split $l_line ,] ""] ;# remove all comma's
        
        # Map data to variable
        foreach name [array names importFile] {
            if {[lindex $l_line $importFile($name)] eq ""} {
                # we need a placeholder if there isn't any data
                set $name .
            } elseif {$name eq "shipVia"} {
                # add a zero to the front because SmartLinc requires it.
                set $name 0[list [string toupper [lindex $l_line $importFile($name)]]]
            } elseif {$name eq "Zip"} {
                'debug Zip --- name - $name
                    # Make sure that leading zero's are present when required.
                    if {[string length [lindex $l_line $importFile($name)]] == 4} {
                        set $name 0[list [lindex $l_line $importFile($name)]]
                        'debug reset Zip $name
                    } else {
                        set $name [list [string toupper [lindex $l_line $importFile($name)]]]
                        }
            } else {
                set $name [list [string toupper [lindex $l_line $importFile($name)]]]
            }
            
            #lappend printVariables $importFile($name)
        }
        #'debug "(printVariables) $printVariables"
        
        if {[string is integer [lindex $l_line $importFile(Quantity)]]} {
            set val [Disthelper_Code::doMath [lindex $l_line $importFile(Quantity)] $GS_job(fullBoxQty)]
            'debug "(val) $val"
        } else {
            # If we come across a quantity that isn't an integer, we will skip it.
            # I'm using this to skip the header (if there is one).
            'debug "String is not an integer. Skipping..."
            continue
        }
        
        # Checking for amount of boxes per shipment
        # First we assume we have full boxes, and a partial
        if {([lindex $val 0] != 0) && ([lindex $val 1] != 0)} {
            set totalBoxes [expr [lindex $val 0]+1]
            set onlyFullBoxes no
            #set boxAndVersion "$totalBoxes$Version"
            'debug "(boxes1) $totalBoxes - Full boxes and Partials"
            
        # Now we check to see if we have full boxes, and no partials
        } elseif {([lindex $val 0] != 0) && ([lindex $val 1] == 0)} {
            set totalBoxes [lindex $val 0]
            set onlyFullBoxes yes ;# now we can process like a full box in a multiple box shipment
            'debug "(boxes2) $totalBoxes - Full boxes only"
        
        # Now we check to see if we have zero full boxes, and a partial
        } elseif {([lindex $val 0] == 0) && ([lindex $val 1] != 0)} {
            set onlyFullBoxes no
            set totalBoxes 1
            'debug "(boxes3) $totalBoxes - Partial Only"
        }
        
        for {set x 1} {$x <= $totalBoxes} {incr x} {
            if {($x != $totalBoxes) || ($onlyFullBoxes eq yes)} {
                'debug "boxes: $x - TotalBoxes: $totalBoxes"
                if {[string match $Version .] == 1 } { set boxVersion $GS_job(fullBoxQty)} else { set boxVersion [list [join [concat $Version _ $GS_job(fullBoxQty)] ""]] }
                #set boxWeight [catch {[::tcl::mathfunc::round [expr {$GS_job(fullBoxQty) * $GS_job(pieceWeight) + $settings(BoxTareWeight)}]]} err_1]
                set boxWeight [::tcl::mathfunc::round [expr {$GS_job(fullBoxQty) * $GS_job(pieceWeight) + $settings(BoxTareWeight)}]]
                
                #'debug "FullBoxes_err: $err_1"
                'debug [::csv::join "$shipVia $Company $Consignee $delAddr $delAddr2 $delAddr3 $City $State $Zip $Phone $GS_job(Number) $boxVersion $GS_job(fullBoxQty) PaymentTerms $3rdParty $boxWeight $x $totalBoxes $EmailGateway $Email $Contact"]
                chan puts $filesDestination [::csv::join "$shipVia $Company $Consignee $delAddr $delAddr2 $delAddr3 $City $State $Zip $Phone $GS_job(Number) $boxVersion $GS_job(fullBoxQty) $PaymentTerms $3rdParty $boxWeight $x $totalBoxes $EmailGateway $Email $Contact"]
            
            } elseif {($x == $totalBoxes) || ($onlyFullBoxes eq no)} {
                'debug "boxes: $x - TotalBoxes (Partials): $totalBoxes"
                if {[string match $Version .] == 1} { set boxVersion [lindex $val 1] } else { set boxVersion [list [join [concat $Version _ [lindex $val 1]] ""]] } 
                #set boxWeight [catch {[::tcl::mathfunc::round [expr {[lindex $val 1] * $GS_job(pieceWeight) + $settings(BoxTareWeight)}]]} err_2]
                set boxWeight [::tcl::mathfunc::round [expr {[lindex $val 1] * $GS_job(pieceWeight) + $settings(BoxTareWeight)}]]
                
                #'debug "PartialBoxes_err: $err_2"
                'debug [::csv::join "$shipVia $Company $Consignee $delAddr $delAddr2 $delAddr3 $City $State $Zip $Phone $GS_job(Number) $boxVersion [lindex $val 1] $PaymentTerms $3rdParty $boxWeight $x $totalBoxes $EmailGateway $Email $Contact"]
                chan puts $filesDestination [::csv::join "$shipVia $Company $Consignee $delAddr $delAddr2 $delAddr3 $City $State $Zip $Phone $GS_job(Number) $boxVersion [lindex $val 1] $PaymentTerms $3rdParty $boxWeight $x $totalBoxes $EmailGateway $Email $Contact"]
            }
        }
        
        'debug "--------------"
    }
    
    chan close $filesDestination
    
    # Tell the user that the file has been generated once we close the channel
    tk_messageBox -type ok \
                    -message [mc "Your file has been generated!"] \
                    -title [mc "Finished Creating File"] \
                    -icon info \
                    -parent .

} ;# End of writeOutPut

