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
    #	Open the target file and assign headers if available.
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
    global GL_file GS_file GS_job GS_ship GS_address header tempVars


    # Cleanse file name, and prepare it for when we create the output file.
    set GS_file(Name) [join [lrange [file rootname [file tail $filename]] 0 end]]
    'debug "GS_file(Name): $GS_file(Name)"

    set GS_job(Number) [join [lrange [split $GS_file(Name)] 0 0]]
    set GS_job(Number) [string trimleft $GS_job(Number) #]
    'debug "Job Number: $GS_job(Number)"
    'debug "filename: $filename"

    # Open the file
    set fileName [open "$filename" RDONLY]

    # Make the data useful, and put it into lists
    # While we are at it, make everything UPPER CASE
    while { [gets $fileName line] >= 0 } {
        # Guard against lines of comma's, this will not be viewable in excel. Only in a text editor.
        if {[string is punc [string trim $line]] eq 1} {continue}

        lappend GL_file(dataList) [string toupper $line]
        'debug while: $line
    }

    chan close $fileName

    # Only retrieve the first record. We use this as the 'header' row.
    set GL_file(Header) [string toupper [csv::split [lindex $GL_file(dataList) 0]]]


    # Set the entry widgets to normal state, special handling for the Customer frame is required since they are not always used.
    Disthelper_Helper::getChildren normal

    foreach line $GL_file(Header) {
        # If the file has headers, lets auto-insert the values to help the user.

        # Remove extra whitespace
        set line1 [string trimleft $line]
        set line1 [string trimright $line1]

        # If this stays 'no', we will assume we have no headers in the file.
        set ea_header(haveHeaders) no

        # Insert all headers into the listbox
        .container.frame1.listbox insert end $line

        # Find potential matches and assign the correct value.
        if { [lsearch -nocase $header(shipvia) $line1] != -1} {
            set GS_ship(shipVia) $line
            Disthelper_RemoveListBoxItem $line
            
            } elseif { [lsearch -nocase $header(company) $line1] != -1} {
                set GS_address(Company) $line
                Disthelper_RemoveListBoxItem $line
            
            } elseif { [lsearch -nocase $header(attention) $line1] != -1} {
                set GS_address(Attention) $line
                Disthelper_RemoveListBoxItem $line
            
            } elseif { [lsearch -nocase $header(address1) $line1] != -1} {
                set GS_address(deliveryAddr) $line
                Disthelper_RemoveListBoxItem $line
            
            } elseif { [lsearch -nocase $header(address2) $line1] != -1} {
                set GS_address(addrTwo) $line
                Disthelper_RemoveListBoxItem $line
            
            } elseif { [lsearch -nocase $header(address3) $line1] != -1} {
                set GS_address(addrThree) $line
                Disthelper_RemoveListBoxItem $line
            
            # Feature to be added; to split columns that contain city,state,zip
            #elseif {[lsearch -nocase $header(CityStateZip) $line1] != -1} {set internal_line cityStateZip; 'debug Found a CityStateZip!}
            #if {[lsearch -nocase $city $line] != -1} {set internal_line City}
            } elseif { [lsearch -nocase $header(state) $line1] != -1} {
                set GS_address(State) $line
                Disthelper_RemoveListBoxItem $line
            
            } elseif {[lsearch -nocase $header(quantity) $line1] != -1} {
                set GS_job(Quantity) $line; set ea_header(haveHeaders) yes
                Disthelper_RemoveListBoxItem $line
            
            } elseif {[lsearch -nocase $header(version) $line1] != -1} {
                set GS_job(Version) $line
                Disthelper_RemoveListBoxItem $line
            
            } elseif {[lsearch -nocase $header(zip) $line1] != -1} {
                set GS_address(Zip) $line
                Disthelper_RemoveListBoxItem $line
            
            } elseif {[lsearch -nocase $header(3rdPartyNumber) $line1] != -1} {
                set GS_job(3rdParty) $line
                Disthelper_RemoveListBoxItem $line
            }

        # Continue processing the list for potential matches where we don't need to search for possible alternate spellings
        switch -nocase -- $line1 {
            City                {set GS_address(City) $line; Disthelper_RemoveListBoxItem $line}
            Phone               {set GS_address(Phone) $line; Disthelper_RemoveListBoxItem $line}
            "Ship Date"         {set GS_job(Date) $line; Disthelper_RemoveListBoxItem $line}
            EmailContact        {set GS_job(Contact) $line; Disthelper_RemoveListBoxItem $line}
            email               {set GS_job(Email) $line; 'debug Email Set: $GS_job(Email); Disthelper_RemoveListBoxItem $line}
            pieceweight         {set GS_job(pieceWeight) $line; Disthelper_RemoveListBoxItem $line; Disthelper_Helper::detectData .container.frame2.frame2d.shipmentPieceWeightEntry .container.frame2.frame2d.shipmentPieceWeightField pieceWeight}
            fullbox             {set GS_job(fullBoxQty) $line; Disthelper_RemoveListBoxItem $line; Disthelper_Helper::detectData .container.frame2.frame2d.shipmentFullBoxEntry .container.frame2.frame2d.shipmentFullBoxField fullBox}
            default             {'debug Inserted Unidentified Header: $line}
        }
    }
    
    # Highlight list elements if they exist to raise visiblity that they are there.
    Disthelper_HighlightListBoxItem

    if {$ea_header(haveHeaders) eq "yes"} {
        # We have headers, so lets skip the first line.
        #'debug "Headers Found"
        set GL_file(dataList_modified) [lrange $GL_file(dataList) 1 end]

        #'debug dataList: $GL_file(dataList_modified)
    } else {
        # not modified, but we need to save as the same name
        #'debug "No Headers Found"
        set GL_file(dataList_modified) $GL_file(dataList)
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
    if {$totalQuantity == "" || $totalQuantity == 0} {
        puts "I need a total qty argument!"
        return failed
    }

    if {$totalQuantity < $maxPerBox} {
	lappend partialBoxQTY
    }

    set divideTotalQuantity [expr {$totalQuantity/$maxPerBox}]
    'debug "divideTotalQuantity: $divideTotalQuantity"

    set totalFullBoxs [expr {round($divideTotalQuantity)}]
    set fullBoxQTY [expr {round(floor($divideTotalQuantity) * $maxPerBox)}]

    ## Use fullBoxQty as a starting point for the partial box.
    lappend partialBoxQTY [expr {round($totalQuantity - $fullBoxQTY)}]

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
    global GS_job GS_ship GS_address GL_file GS_file settings program importFile

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
        3rdParty    [lsearch $GL_file(Header) $GS_job(3rdParty)]
        pieceweight [lsearch $GL_file(Header) $GS_job(pieceWeight)]
        fullbox     [lsearch $GL_file(Header) $GS_job(fullBoxQty)]
    "
    # Only imported values are listed here.
    #'debug UI_Company: $GS_address(Company)
    #'debug Header: $GL_file(Header)
    #'debug Company: $importFile(Company)

    # Open the destination file for writing
    set filesDestination [open [file join $settings(outFilePath) "$GS_file(Name) EA GENERATED.csv"] w]

    # line = each address string
    # GL_file(dataList) = the entire shipping file
    foreach line $GL_file(dataList_modified) {
        #'debug "Start Processing List..."

        # escape if we have 'blank' lines
        # It will show up as a string of ,,,,,,,,,
        if {[string is punc $line] == 1} {continue}

        set l_line [csv::split $line]
        set l_line [join [split $l_line ,] ""] ;# remove all comma's
        'debug Line: $l_line


        # Map data to variable
        # Name = individual name of array
        foreach name [array names importFile] {
            #'debug Name: $name
            # if we come across a line with no data, exit right away
            if {[lindex $l_line $importFile(shipVia)] == ""} {return}

            switch -- $name {
                shipVia {
                    set ship_via [Disthelper_Helper::shipVia $l_line $name]

                    set shipVia [lindex $ship_via 0]
                    set 3rd_Party [lindex $ship_via 1]
                    set PaymentTerms [lindex $ship_via 2]
                }
                Zip     {
                        #'debug Zip/$name - Detect if we need to add a leading zero
                        if {[string length [lindex $l_line $importFile($name)]] == 4} {
                                set $name 0[list [lindex $l_line $importFile($name)]]
                        } else {
                            set $name [list [lindex $l_line $importFile($name)]]
                        }
                }
                Email   {
                        #'debug email/$importFile($name)
                        #Make sure we only activate the following two variables if the data actually exists.
                        if {[lindex $l_line $importFile($name)] != ""} {
                            set $name [list [lindex $l_line $importFile($name)]]
                            set EmailGateway Y
                        } else {
                                set EmailGateway N
                                set $name .
                            }
                }
                pieceweight {
                            #'debug pieceweight/$importFile($name)
                            # Use this so we can import the pieceweight. Useful if we have multiple versions with different pieceweights
                            if {[lindex $l_line $importFile($name)] != ""} {
                                'debug "pieceweight: located in header"
                                set $name [list [lindex $l_line $importFile($name)]]
                            } else {
                                'debug "pieceweight: no header, user set: $GS_job(pieceWeight)"
                                set $name $GS_job(pieceWeight)
                            }
                }
                fullbox     {
                            'debug fullbox/[lindex $l_line $importFile($name)]
                            # Import the fullbox qty per version. Useful if we have multiple versions with various full box qty's.
                            if {[lindex $l_line $importFile($name)] != ""} {
                                'debug "fullbox: located in header"
                                set $name [list [lindex $l_line $importFile($name)]]
                                'debug "fullbox1: $name/$fullbox"
                            } else {
                                'debug "fullbox: no header, user set: $GS_job(fullBoxQty)"
                                set $name $GS_job(fullBoxQty)
                                'debug "fullbox2: $name/$fullbox"
                            }
                }
                default {
                        #'debug default/$name - If no data is present we fill it with dummy data
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
            #set val [Disthelper_Code::doMath [lindex $l_line $importFile(Quantity)] $GS_job(fullBoxQty)]
            set val [Disthelper_Code::doMath [lindex $l_line $importFile(Quantity)] $fullbox]
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
                #incr program(totalBooks) $GS_job(fullBoxQty)
                incr program(totalBooks) $fullbox

                #if {[string match $Version .] == 1 } { set boxVersion $fullbox} else { set boxVersion [list [join [concat $Version _ $fullbox] ""]] }
                if {[string match $Version .] == 1 } { set boxVersion $fullbox} else { set boxVersion [list [concat $Version / $fullbox]]}
                #set boxWeight [::tcl::mathfunc::round [expr {$GS_job(fullBoxQty) * $GS_job(pieceWeight) + $settings(BoxTareWeight)}]]
                #set boxWeight [::tcl::mathfunc::round [expr {$GS_job(fullBoxQty) * $pieceweight + $settings(BoxTareWeight)}]]
                set boxWeight [::tcl::mathfunc::round [expr {$fullbox * $pieceweight + $settings(BoxTareWeight)}]]
                'debug "fullbox-3: $fullbox"

                #'debug "FullBoxes_err: $err_1"
                #'debug [::csv::join "$shipVia $Company $Attention $delAddr $delAddr2 $delAddr3 $City $State $Zip $Phone $GS_job(Number) $boxVersion $GS_job(fullBoxQty) $PaymentTerms $3rd_Party $boxWeight $x $totalBoxes $EmailGateway $Email $Contact"]
                #chan puts $filesDestination [::csv::join "$shipVia $Company $Attention $delAddr $delAddr2 $delAddr3 $City $State $Zip $Phone $GS_job(Number) $boxVersion $GS_job(fullBoxQty) $PaymentTerms $3rd_Party $boxWeight $x $totalBoxes $EmailGateway $Email $Contact"]

                'debug [::csv::join "$shipVia $Company $Attention $delAddr $delAddr2 $delAddr3 $City $State $Zip $Phone $GS_job(Number) $boxVersion $fullbox $PaymentTerms $3rd_Party $boxWeight $x $totalBoxes $EmailGateway $Email $Contact"]
                chan puts $filesDestination [::csv::join "$shipVia $Company $Attention $delAddr $delAddr2 $delAddr3 $City $State $Zip $Phone $GS_job(Number) $boxVersion $fullbox $PaymentTerms $3rd_Party $boxWeight $x $totalBoxes $EmailGateway $Email $Contact"]

            } elseif {($x == $totalBoxes) || ($onlyFullBoxes eq no)} {
                'debug "boxes: $x - TotalBoxes (Partials): $totalBoxes"
                incr program(totalBooks) [lindex $val 1]

                if {[string match $Version .] == 1} { set boxVersion [lindex $val 1] } else { set boxVersion [list [join [concat $Version _ [lindex $val 1]] ""]] }
                #set boxWeight [::tcl::mathfunc::round [expr {[lindex $val 1] * $GS_job(pieceWeight) + $settings(BoxTareWeight)}]]
                set boxWeight [::tcl::mathfunc::round [expr {[lindex $val 1] * $pieceweight + $settings(BoxTareWeight)}]]

                #'debug "PartialBoxes_err: $err_2"
                'debug [::csv::join "$shipVia $Company $Attention $delAddr $delAddr2 $delAddr3 $City $State $Zip $Phone $GS_job(Number) $boxVersion [lindex $val 1] $PaymentTerms $3rd_Party $boxWeight $x $totalBoxes $EmailGateway $Email $Contact"]
                chan puts $filesDestination [::csv::join "$shipVia $Company $Attention $delAddr $delAddr2 $delAddr3 $City $State $Zip $Phone $GS_job(Number) $boxVersion [lindex $val 1] $PaymentTerms $3rd_Party $boxWeight $x $totalBoxes $EmailGateway $Email $Contact"]
            }
            incr program(totalBoxes)

        }
        update
        incr program(ProgressBar)
        incr program(totalAddress)
        'debug "--------------"
    }
    # This is here to get the last address recorded
    incr program(ProgressBar)
    chan close $filesDestination

} ;# End of writeOutPut
