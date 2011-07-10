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
    global GL_file GS_file GS_job GS_ship GS_address header

    
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
    
    set GL_file(Header) [string toupper [csv::split [lindex $GL_file(dataList) 0]]]
    

    # Set the entry widgets to normal state, special handling for the Customer frame is required since they are not always used.
    Disthelper_Helper::getChildren normal
    
    # Header spellings
    #set shipVia [list "SHIP VIA" SHIPVIA]
    #set company [list COMPANY DESTINATION]
    #set consignee [list ATTENTION ATTN ATTN: CONSIGNEE CONTACT]
    #set address1 [list ADDRESS ADDRESS1 ADD ADD1 "ADD 1" ADDR ADDR1 "ADDRESS 1"]
    #set address2 [list ADD2 "ADD 2" ADDR2 "ADDR 2" ADDRESS2 "ADDRESS 2"]
    #set address3 [list ADD3 "ADD 3" ADDR3 "ADDR 3" ADDRESS3 "ADDRESS 3"]
    #set cityStateZip [list CITY-STATE-ZIP CITY-ST-ZIP "CITY ST ZIP" "CITY STATE ZIP" CSV]
    #set state [list ST ST. STATE]
    #set quantity [list QUANTITY QTY]
    #set version [list VERSION VERS]

    foreach line $GL_file(Header) {
        # If the file has headers, lets auto-insert the values to help the user.
        
        # Remove extra whitespace
        #set line [string trimleft $line]
        #set line [string trimright $line]
        
        # Insert all headers into the listbox
        .container.frame1.listbox insert end $line

        # Find potential matches and assign the correct value.
        #if {[lsearch -nocase $shipVia $line] != -1} {set GS_ship(shipVia) $line}
        if {[lsearch -nocase $header(shipvia) $line] != -1} {set GS_ship(shipVia) $line}
        #if {[lsearch -nocase $company $line] != -1} {set GS_address(Company) $line}
        if {[lsearch -nocase $header(company) $line] != -1} {set GS_ship(company) $line}
        #if {[lsearch -nocase $consignee $line] != -1} {set GS_address(Consignee) $line}
        if {[lsearch -nocase $header(attention) $line] != -1} {set GS_address(Attention) $line}
        #if {[lsearch -nocase $address1 $line] != -1} {set GS_address(deliveryAddr) $line}
        if {[lsearch -nocase $header(address1) $line] != -1} {set GS_address(deliveryAddr) $line}
        #if {[lsearch -nocase $address2 $line] != -1} {set GS_address(addrTwo) $line}
        if {[lsearch -nocase $header(address2) $line] != -1} {set GS_address(addrTwo) $line}
        #if {[lsearch -nocase $address3 $line] != -1} {set GS_address(addrThree) $line}
        if {[lsearch -nocase $header(address3) $line] != -1} {set GS_address(addrThree) $line}
        # Feature to be added; to split columns that contain city,state,zip
        #if {[lsearch -nocase $cityStateZip $line] != -1} {set internal_line cityStateZip; 'debug Found a CityStateZip!}
        if {[lsearch -nocase $header(CityStateZip) $line] != -1} {set internal_line cityStateZip; 'debug Found a CityStateZip!}
        
        #if {[lsearch -nocase $city $line] != -1} {set internal_line City}
        
        #if {[lsearch -nocase $state $line] != -1} {set GS_address(State) $line}
        if {[lsearch -nocase $header(state) $line] != -1} {set GS_address(State) $line}
        #if {[lsearch -nocase $quantity $line] != -1} {set GS_job(Quantity) $line}
        if {[lsearch -nocase $header(quantity) $line] != -1} {set GS_job(Quantity) $line}
        #if {[lsearch -nocase $version $line] != -1} {set GS_job(Version) $line}
        if {[lsearch -nocase $header(version) $line] != -1} {set GS_job(Version) $line}
        
        if {[lsearch -nocase $header(zip) $line] != -1} {set GS_address(Zip) $line}

        # Continue processing the list for potential matches where we don't need to search for possible alternate spellings
        switch -nocase $line {
            City                {set GS_address(City) $line}
            Phone               {set GS_address(Phone) $line}
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
    if {$totalQuantity == "" || $totalQuantity == 0} {puts "I need a total qty argument!"; return failed}
    
    if {$totalQuantity < $maxPerBox} {
	lappend partialBoxQTY
    }
    
    set divideTotalQuantity [expr {$totalQuantity/$maxPerBox}]
    'debug "divideTotalQuantity: $divideTotalQuantity"
    
    set totalFullBoxs [expr {round($divideTotalQuantity)}]
    set fullBoxQTY [expr {round(floor($divideTotalQuantity) * $maxPerBox)}]
    
    ## Use fullBoxQty as a starting point for the partial box.
    lappend partialBoxQTY [expr {round($totalQuantity - $fullBoxQTY)}]
    
    #puts "doMath::TotalQty: $totalQuantity"
    #puts "doMath::maxPerBox: $maxPerBox"
    #puts "doMath::totalFullBoxs: $totalFullBoxs"
    #puts "doMath::partialBoxQTY: $partialBoxQTY"
    
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
    #   GS_internal / progressBarLength
    #
    #   Set: Global Arrays
    #
    # SEE ALSO
    #	
    #
    #***
    global GS_job GS_ship GS_address GL_file GS_file settings GS_internal

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
        Attention   [lsearch $GL_file(Header) $GS_address(Attention)]
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
    "
    # Only imported values are listed here.
    #'debug UI_Company: $GS_address(Company)
    #'debug Header: $GL_file(Header)
    #'debug Company: $importFile(Company)

    # Make sure we only activate the following two variables if the data actually exists.
    if {$GS_job(Email) != ""} {set EmailGateway Y} else {set EmailGateway .}
    #set PaymentTerms . ;# Initialize with dummy data
    
    
    # Open the destination file for writing
    set filesDestination [open [file join $settings(outFilePath) "$GS_file(Name) Copy.csv"] w]
    
    # Get total amount of records so we can make an accurate progressbar
    set GS_internal(progressBarLength) [llength $GL_file(dataList)]
    # Incr the variable at the end of the [foreach]
    set GS_internal(progressBarIncr) 0

    # line = each address string
    # GL_file(dataList) = the entire shipping file
    foreach line $GL_file(dataList) {
        set l_line [csv::split $line]
        set l_line [join [split $l_line ,] ""] ;# remove all comma's
 
        # Map data to variable
        # Name = individual name of array
        foreach name [array names importFile] {
        
            switch $name {
                shipVia { #'debug shipVia/$name - Detect if its 3rd party or if we need to add a leading zero
                        if {[string length [lindex $l_line $importFile($name)]] == 2} {
                                set $name 0[list [lindex $l_line $importFile($name)]]
                                } else {
                                    if {$name == ""} {
                                        #'debug String is not an integer - shipVia
                                        return
                                    }
                                    set $name [list [lindex $l_line $importFile($name)]]
                                }
                            # Guard against the user not putting in an actual 3rd party code!!
                            if {$shipVia eq "067" || $shipVia eq "068"} {
                                   #'debug We should only see this for 3rd party
                                    if {$GS_job(3rdParty) != ""} {
                                        #'debug Checking if we have a 3rd party acct
                                        set 3rdParty $GS_job(3rdParty); set PaymentTerms 3
                                        } else {
                                            #'debug No acct found, show the error message
                                            Error_Message::errorMsg 3rdParty1
                                            return
                                    }
                                } else {
                                    #'debug Not sending 3rd party, fill the variables with dummy data
                                        set 3rdParty .; set PaymentTerms .
                            }
                }
                Zip     { #'debug Zip/$name - Detect if we need to add a leading zero
                        if {[string length [lindex $l_line $importFile($name)]] == 4} {
                                set $name 0[list [lindex $l_line $importFile($name)]]
                        } else {
                            set $name [list [lindex $l_line $importFile($name)]]
                        }
                }
                default { #'debug default/$name - If no data is present we fill it with dummy data
                         # we need a placeholder if there isn't any data, and reassign variable names.
                         # Build a black list
                        if {[lsearch [list "" " "] [lindex $l_line $importFile($name)]] != -1} {
                        #if {[lindex $l_line $importFile($name)] eq ""} {}
                            set $name .
                        } else {
                            set $name [list [lindex $l_line $importFile($name)]]
                        }
                        #'debug NAME: $name
                }
            }  
        }

        #'debug importFile(Quantity) [lindex $l_line $importFile(Quantity)]
        
        if {[string is integer [lindex $l_line $importFile(Quantity)]]} {
            set val [Disthelper_Code::doMath [lindex $l_line $importFile(Quantity)] $GS_job(fullBoxQty)]
            #'debug "(val) $val"
        } else {
            # If we come across a quantity that isn't an integer, we will skip it.
            # I'm using this to skip the header (if there is one).
            'debug "String is not an integer. Skipping..."
            continue
        }
        
        # if the doMath proc returns the value 'failed', we skip that entry and continue until we reach the end of the file.
        # this can occur if there is extra invisible formatting in the excel file, but in the .csv file there are extra lines of empty data.
        if {$val == "failed"} {
                            'debug no quantity, exiting
                            continue}
        
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
                'debug [::csv::join "$shipVia $Company $Attention $delAddr $delAddr2 $delAddr3 $City $State $Zip $Phone $GS_job(Number) $boxVersion $GS_job(fullBoxQty) $PaymentTerms $3rdParty $boxWeight $x $totalBoxes $EmailGateway $Email $Contact"]
                chan puts $filesDestination [::csv::join "$shipVia $Company $Attention $delAddr $delAddr2 $delAddr3 $City $State $Zip $Phone $GS_job(Number) $boxVersion $GS_job(fullBoxQty) $PaymentTerms $3rdParty $boxWeight $x $totalBoxes $EmailGateway $Email $Contact"]
            
            } elseif {($x == $totalBoxes) || ($onlyFullBoxes eq no)} {
                'debug "boxes: $x - TotalBoxes (Partials): $totalBoxes"
                if {[string match $Version .] == 1} { set boxVersion [lindex $val 1] } else { set boxVersion [list [join [concat $Version _ [lindex $val 1]] ""]] } 
                #set boxWeight [catch {[::tcl::mathfunc::round [expr {[lindex $val 1] * $GS_job(pieceWeight) + $settings(BoxTareWeight)}]]} err_2]
                set boxWeight [::tcl::mathfunc::round [expr {[lindex $val 1] * $GS_job(pieceWeight) + $settings(BoxTareWeight)}]]
                
                #'debug "PartialBoxes_err: $err_2"
                'debug [::csv::join "$shipVia $Company $Attention $delAddr $delAddr2 $delAddr3 $City $State $Zip $Phone $GS_job(Number) $boxVersion [lindex $val 1] $PaymentTerms $3rdParty $boxWeight $x $totalBoxes $EmailGateway $Email $Contact"]
                chan puts $filesDestination [::csv::join "$shipVia $Company $Attention $delAddr $delAddr2 $delAddr3 $City $State $Zip $Phone $GS_job(Number) $boxVersion [lindex $val 1] $PaymentTerms $3rdParty $boxWeight $x $totalBoxes $EmailGateway $Email $Contact"]
            }
        }
        incr GS_internal(progressBarIncr)
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

