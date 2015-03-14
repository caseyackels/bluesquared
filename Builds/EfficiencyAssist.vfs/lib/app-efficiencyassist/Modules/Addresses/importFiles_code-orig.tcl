# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 338 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2014-09-14 21:48:00 -0700 (Sun, 14 Sep 2014) $
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

namespace eval eAssist_Code {}


proc eAssist_Code::readFile {filename} {
    #****f* readFile/eAssist_Code
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
    #	eAssist_Code::getOpenFile
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
    set GS_file(Name) [string trimleft $GS_file(Name) #]
    set GS_file(Name) [string trim $GS_file(Name) .]
    'debug "GS_file(Name): $GS_file(Name)"

    set GS_job(Number) [join [lrange [split $GS_file(Name)] 0 0]]
    set GS_job(Number) [string trimleft $GS_job(Number) #]
    'debug "Job Number: $GS_job(Number)"
    'debug "filename: $filename"
    
    set GS_job(Description) [join [lrange [split $GS_file(Name)] 1 end-1]]
    set GS_job(DescLength) [string length $GS_job(Description)]

    # Open the file
    set fileName [open "$filename" RDONLY]

    # Make the data useful, and put it into lists
    # While we are at it, make everything UPPER CASE
    #while {-1 != [gets $fp line]}
    while { [gets $fileName line] >= 0 } {
        # Guard against lines of comma's, this will not be viewable in excel. Only in a text editor.
        if {[string is punc [join [split [string trim $line] " "] ""]] eq 1} {continue}

        lappend GL_file(dataList) [string toupper $line]
        #'debug while: $line
    }
    
    #'debug ***RECORDS*: [llength $GL_file(dataList)]

    chan close $fileName

    # Only retrieve the first record. We use this as the 'header' row.
    set GL_file(Header) [string toupper [csv::split [lindex $GL_file(dataList) 0]]]


    # Set the entry widgets to normal state, special handling for the Customer frame is required since they are not always used.
    eAssist_Helper::getChildren normal

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
            eAssist_Helper::RemoveListBoxItem $line
            eAssist_Helper::detectData .container.frame2.frame2d.shipmentShipViaEntry .container.frame2.frame2d.shipmentShipViaField shipVia
            #set ea_header(haveHeaders) yes

            } elseif { [lsearch -nocase $header(company) $line1] != -1} {
                set GS_address(Company) $line
                eAssist_Helper::RemoveListBoxItem $line

            } elseif { [lsearch -nocase $header(attention) $line1] != -1} {
                set GS_address(Attention) $line
                eAssist_Helper::RemoveListBoxItem $line

            } elseif { [lsearch -nocase $header(address1) $line1] != -1} {
                set GS_address(deliveryAddr) $line
                eAssist_Helper::RemoveListBoxItem $line

            } elseif { [lsearch -nocase $header(address2) $line1] != -1} {
                set GS_address(addrTwo) $line
                eAssist_Helper::RemoveListBoxItem $line

            } elseif { [lsearch -nocase $header(address3) $line1] != -1} {
                set GS_address(addrThree) $line
                eAssist_Helper::RemoveListBoxItem $line

            # Feature to be added; to split columns that contain city,state,zip
            #elseif {[lsearch -nocase $header(CityStateZip) $line1] != -1} {set internal_line cityStateZip; 'debug Found a CityStateZip!}
            #if {[lsearch -nocase $city $line] != -1} {set internal_line City}
            
            } elseif { [lsearch -nocase $header(city) $line1] != -1} {
                set GS_address(City) $line
                eAssist_Helper::RemoveListBoxItem $line

            } elseif { [lsearch -nocase $header(state) $line1] != -1} {
                set GS_address(State) $line
                eAssist_Helper::RemoveListBoxItem $line

            } elseif { [lsearch -nocase $header(zip) $line1] != -1} {
                set GS_address(Zip) $line
                eAssist_Helper::RemoveListBoxItem $line
                
            } elseif { [lsearch -nocase $header(country) $line1] != -1} {
                set GS_address(Country) $line
                eAssist_Helper::RemoveListBoxItem $line

            } elseif {[lsearch -nocase $header(phone) $line1] != -1} {
                set GS_address(Phone) $line
                eAssist_Helper::RemoveListBoxItem $line
                
            } elseif {[lsearch -nocase $header(email) $line1] != -1} {
                set GS_job(Email) $line
                eAssist_Helper::RemoveListBoxItem $line
                
            } elseif {[lsearch -nocase $header(shipdate) $line1] != -1} {
                set GS_job(Date) $line
                eAssist_Helper::RemoveListBoxItem $line
                eAssist_Helper::detectData .container.frame2.frame2d.shipmentDateEntry .container.frame2.frame2d.shipmentDateField shipDate
            
            } elseif {[lsearch -nocase $header(quantity) $line1] != -1} {
                set GS_job(Quantity) $line
                eAssist_Helper::RemoveListBoxItem $line
                set ea_header(haveHeaders) yes

            } elseif {[lsearch -nocase $header(version) $line1] != -1} {
                set GS_job(Version) $line
                eAssist_Helper::RemoveListBoxItem $line
            
            } elseif {[lsearch -nocase $header(pieceweight) $line1] != -1} {
                set GS_job(pieceWeight) $line
                eAssist_Helper::RemoveListBoxItem $line
                eAssist_Helper::detectData .container.frame2.frame2d.shipmentPieceWeightEntry .container.frame2.frame2d.shipmentPieceWeightField pieceWeight
            
            } elseif {[lsearch -nocase $header(fullbox) $line1] != -1} {
                set GS_job(fullBoxQty) $line
                eAssist_Helper::RemoveListBoxItem $line
                eAssist_Helper::detectData .container.frame2.frame2d.shipmentFullBoxEntry .container.frame2.frame2d.shipmentFullBoxField fullBox
            }
            
        # Continue processing the list for potential matches where we don't need to search for possible alternate spellings
        switch -nocase -- $line1 {
            ResidentialDelivery {set GS_job(Residential) $line; eAssist_Helper::RemoveListBoxItem $line}
            default             {'debug Inserted Auto-Assigned Header: $line; set ea_header(haveHeaders) yes}
        }
    }

    # Highlight list elements if they exist to raise visiblity that they are there.
    eAssist_Helper::HighlightListBoxItem
    #set ea_header(haveHeaders) ""
    
    if {$ea_header(haveHeaders) eq "yes"} {
        # We have headers, so lets skip the first line.
        #'debug "Headers Found"
        set GL_file(dataList_modified) [lrange $GL_file(dataList) 1 end]
    } else {
        # not modified, but we need to save as the same name
        #'debug "No Headers Found"
        set GL_file(dataList_modified) $GL_file(dataList)
    }

    # If there isn't a date that we import, lets insert today's date. The user can still change it, but atleast they won't have to type it out.
    if {$GS_job(Date) == ""} {
        puts "Date is not set. Inserting Default"
        set GS_job(Date) [clock format [clock seconds] -format %D]
        eAssist_Helper::detectData .container.frame2.frame2d.shipmentDateEntry .container.frame2.frame2d.shipmentDateField shipDate
        }

} ;# eAssist_Code::readFile


proc eAssist_Code::doMath {totalQuantity maxPerBox} {
    #****f* doMath/eAssist_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	eAssist_Code::doMath TotalQuantity MaxPerBox
    #
    # SYNOPSIS
    #	Read in the total quantity of a shipment, along with the maximum qty per box, the output is total number of full boxes, and the qty of the partial.
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	eAssist_Code::writeOutPut
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


proc eAssist_Code::writeOutPut {} {
    #****f* writeOutPut/eAssist_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Process the data, and write out to the file
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #   eAssist_Code::processAddresses
    #
    # PARENTS
    #	eAssist_Helper::parentGUI
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
    global GS_job GS_ship GS_address GL_file GS_file settings mySettings program importFile matrix intl ship

    # Get the indices of each element of the address/shipment information. Later we will use this to map the data.
    array set importFile "
        01_shipVia         [lsearch $GL_file(Header) $GS_ship(shipVia)]
        02_Company         [lsearch $GL_file(Header) $GS_address(Company)]
        03_Attention       [lsearch $GL_file(Header) $GS_address(Attention)]
        04_delAddr         [lsearch $GL_file(Header) $GS_address(deliveryAddr)]
        05_delAddr2        [lsearch $GL_file(Header) $GS_address(addrTwo)]
        06_delAddr3        [lsearch $GL_file(Header) $GS_address(addrThree)]
        07_City            [lsearch $GL_file(Header) $GS_address(City)]
        08_State           [lsearch $GL_file(Header) $GS_address(State)]
        09_Zip             [lsearch $GL_file(Header) $GS_address(Zip)]
        10_Country         [lsearch $GL_file(Header) $GS_address(Country)]
        11_Phone           [lsearch $GL_file(Header) $GS_address(Phone)]
        12_Quantity        [lsearch $GL_file(Header) $GS_job(Quantity)]
        13_Version         [lsearch $GL_file(Header) $GS_job(Version)]
        14_Date            [lsearch $GL_file(Header) $GS_job(Date)]
        15_Email           [lsearch $GL_file(Header) $GS_job(Email)]
        16_3rdPartyName    [lsearch $GL_file(Header) $GS_job(3rdPartyName)]
        17_pieceweight     [lsearch $GL_file(Header) $GS_job(pieceWeight)]
        18_fullbox         [lsearch $GL_file(Header) $GS_job(fullBoxQty)]
    "
    # Initialize variables for foreign shipments. Process Shipper requires a UNIQUE pkgId (the field we use to print out the box qty)
    set alphaList [list a b c d e f g h i j k l m n o p q r s t u v w x y z]
    set F_pkg 0
    set P_pkg 0

    # Only imported values are listed here.
    #'debug UI_Company: $GS_address(Company)
    #'debug Header: $GL_file(Header)
    #'debug Company: $importFile(Company)
    #puts [parray importFile]
    #return



    # line = each address string
    # GL_file(dataList) = the entire shipping file
    foreach line $GL_file(dataList_modified) {
        #'debug "Start Processing List..."

        # escape if we have 'blank' lines
        # It will show up as a string of ,,,,,,,,, in a csv file
        if {[string is punc $line] == 1} {continue}

        set l_line [csv::split $line]
        set l_line [join [split $l_line ,] ""] ;# remove all comma's
        
        #'debug Line: $l_line

        # Map data to variable
        # Name = individual name of array
        foreach name [array names importFile] {
            #'debug Name: $name
            # if we come across a line with no data or data is not an integer, exit right away
            if {[lindex $l_line $importFile(01_shipVia)] == ""} {return}
            if {![string is integer $importFile(01_shipVia)]} {return}

            switch -- $name {
                01_shipVia {
                    set ship_via [eAssist_Helper::shipVia $l_line $name]

                    set $name [lindex $ship_via 0]
                    set 3PCode [lindex $ship_via 1]
                    set 3PAccount [lindex $ship_via 2]
                    #{} else {}
                    #            #'debug "pieceweight: no header, user set: $GS_job(pieceWeight)"
                    #            set $name $GS_job(pieceWeight)
                    #        {}
                }
                02_Company {
                        #'debug Company/$name
                        if {([lindex $l_line $importFile($name)] != "") && ([lindex $l_line $importFile($name)] != " ")} {
                            set $name [list [lindex $l_line $importFile($name)]]
                        } else {
                            set $name [list .] ;# We need a place holder ONLY for Company if none exists.
                        }
                        #set Company [eAssist_Code::processAddresses Company $Company]
                        #puts "Cleansed: $Company [string length $Company]"
                        set $name [eAssist_Code::processAddresses Company $02_Company]
                }
                03_Attention {
                            #'debug Attention/$name
                        if {([lindex $l_line $importFile($name)] != "") && ([lindex $l_line $importFile($name)] != " ")} {
                            set $name [list [lindex $l_line $importFile($name)]]
                        } else {
                            set $name [list ""]
                        }
                        set $name [eAssist_Code::processAddresses Attention $03_Attention]
                }
                04_delAddr {
                        #'debug delAddr/$name
                        if {([lindex $l_line $importFile($name)] != "") && ([lindex $l_line $importFile($name)] != " ")} {
                            set $name [list [lindex $l_line $importFile($name)]]
                        } else {
                            set $name [list ""]
                        }

                        set deladdr [eAssist_Code::processAddresses delAddr $04_delAddr]
                        
                        if {[lindex $deladdr 0] == "fail"} {
                            set $name [join [lindex $deladdr 1]]
                        } else {
                            set $name [join $deladdr]
                        }
                        
                        #puts "***### 04_delAddr: $04_delAddr"
                }
                05_delAddr2 {
                        #'debug delAddr2/$name
                        set 05_delAddr2 ""
                        if {([lindex $l_line $importFile($name)] != "") && ([lindex $l_line $importFile($name)] != " ")} {
                            set $name [list [lindex $l_line $importFile($name)]]
                        }
                        
                        if {[lindex $deladdr 0] == "fail"} {
                            if {$05_delAddr2 == ""} {
                                #puts "FAILED - No secondary Address, so reusing"
                                set $name [join [lindex $deladdr 2]]
                            } else {
                                set $name [list [lindex $l_line $importFile($name)] [lindex $deladdr 2]]
                            }
                            #puts "***### 05_delAddr2: [lindex $deladdr 2]"
                        }
                        #if {$05_delAddr2 == ""} {set $name [list ""]}
                }
                06_delAddr3 {
                        #'debug delAddr3/$name
                        if {([lindex $l_line $importFile($name)] != "") && ([lindex $l_line $importFile($name)] != " ")} {
                            set $name [list [lindex $l_line $importFile($name)]]
                        } else {
                            set $name [list ""]
                        }   
                }
                07_City {
                        #'debug City/$name
                        if {([lindex $l_line $importFile($name)] != "") && ([lindex $l_line $importFile($name)] != " ")} {
                            set $name [list [lindex $l_line $importFile($name)]]
                        } else {
                            set $name [list ""]
                        }
                        set $name [eAssist_Code::processAddresses City $07_City]
                }
                08_State {
                        #'debug State/$name
                        if {([lindex $l_line $importFile($name)] != "") && ([lindex $l_line $importFile($name)] != " ")} {
                            set $name [list [lindex $l_line $importFile($name)]]
                        } else {
                            set $name [list ""]
                        }
                        set $name [eAssist_Code::processAddresses State $08_State]
                }
                09_Zip {
                        #'debug Zip/$name
                        if {([lindex $l_line $importFile($name)] != "") && ([lindex $l_line $importFile($name)] != " ")} {
                            set $name [list [lindex $l_line $importFile($name)]]
                        } else {
                            set $name [list ""]
                        }
                        set $name [eAssist_Code::processAddresses Zip $09_Zip]
                }
                10_Country {
                        #'debug Country/$name
                        if {([lindex $l_line $importFile($name)] != "") && ([lindex $l_line $importFile($name)] != " ")} {
                            set $name [list [lindex $l_line $importFile($name)]]
                            'debug 10_Country_A = $10_Country
                            'debug 10_Country_Line = [lindex $l_line $importFile($name)]
                        } else {
                            # Default to United States
                            set $name [list US]
                            'debug 10_Country_B = $10_Country
                        }
                }
                11_Phone {
                        #'debug Phone/$name
                        if {([lindex $l_line $importFile($name)] != "") && ([lindex $l_line $importFile($name)] != " ")} {
                            set $name [list [lindex $l_line $importFile($name)]]
                        } else {
                            set $name [list ""]
                        }
                        # Cleanse the phone number
                        set $name [eAssist_Code::processAddresses Phone $11_Phone]
                }
                12_Zip     {
                        #'debug Zip/$name - Detect if we need to add a leading zero
                        if {[string length [lindex $l_line $importFile($name)]] == 4} {
                                set $name 0[list [lindex $l_line $importFile($name)]]
                        } else {
                            set $name [list [lindex $l_line $importFile($name)]]
                        }
                }
                15_Email   {
                        #'debug email/$importFile($name)
                        if {([lindex $l_line $importFile($name)] != "") && ([lindex $l_line $importFile($name)] != " ")} {
                            set $name [list [lindex $l_line $importFile($name)]]
                        } else {
                            set $name [list ""]
                        }
                }
                16_3rdPartyName {
                            # If we're blank, check to see if the textvariable from the combobox has a value; if blank we assume it isn't 3rdParty
                    
                }
                17_pieceweight {
                            #'debug pieceweight/$importFile($name)
                            # Use this so we can import the pieceweight. Useful if we have multiple versions with different pieceweights
                            if {([lindex $l_line $importFile($name)] != "") && ([lindex $l_line $importFile($name)] != " ")} {
                                #'debug "pieceweight: located in header"
                                set $name [list [lindex $l_line $importFile($name)]]
                            } else {
                                #'debug "pieceweight: no header, user set: $GS_job(pieceWeight)"
                                set $name $GS_job(pieceWeight)
                            }
                }
                18_fullbox     {
                            #'debug fullbox/[lindex $l_line $importFile($name)]
                            # Import the fullbox qty per version. Useful if we have multiple versions with various full box qty's.
                            if {([lindex $l_line $importFile($name)] != "") && ([lindex $l_line $importFile($name)] != " ")} {
                                #'debug "fullbox: located in header"
                                set $name [list [lindex $l_line $importFile($name)]]
                                #'debug "fullbox1: $name/$fullbox"
                            } else {
                                #'debug "fullbox: no header, user set: $GS_job(fullBoxQty)"
                                set $name $GS_job(fullBoxQty)
                                #'debug "fullbox2: $name/$fullbox"
                            }
                }
                13_Version     {
                            #'debug version/[lindex $l_line $importFile($name)]
                            if {([lindex $l_line $importFile($name)] != "") && ([lindex $l_line $importFile($name)] != " ")} {
                                set $name [lindex $l_line $importFile($name)]
                            } else {
                                set $name [list ""]
                            }
                }
                14_Date     {
                            #'debug version/[lindex $l_line $importFile($name)]
                            if {([lindex $l_line $importFile($name)] != "") && ([lindex $l_line $importFile($name)] != " ")} {
                                set $name [lindex $l_line $importFile($name)]
                            } elseif { $GS_job(Date) != "Ship Date"} {
                                set $name $GS_job(Date)
                            } else {
                                # default to today's date
                                set $name [clock format [clock seconds] -format %D]
                            }
                }
                default     {
                            #'debug default/$name - If no data is present we fill it with dummy data
                            if {([lindex $l_line $importFile($name)] != "") && ([lindex $l_line $importFile($name)] != " ")} {
                                    #'debug "renaming1: $name"
                                    set $name [list [lindex $l_line $importFile($name)]]
                                    } else {
                                       set $name [list ""]
                                        #'debug "renaming2: $name"
                                    }   
                }
            } ;# End Switch
        } ;# End foreach
        

        if {[string is integer [lindex $l_line $importFile(12_Quantity)]]} {
            set val [eAssist_Code::doMath [lindex $l_line $importFile(12_Quantity)] $18_fullbox]
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
                            continue
        }

        # Checking for amount of boxes per shipment
        # First we assume we have full boxes, and a partial
        if {([lindex $val 0] != 0) && ([lindex $val 1] != 0)} {
            set totalBoxes [expr [lindex $val 0]+1]
            set onlyFullBoxes no
            #'debug "(boxes1) $totalBoxes - Full boxes and Partials"

        # Now we check to see if we have full boxes, and no partials
        } elseif {([lindex $val 0] != 0) && ([lindex $val 1] == 0)} {
            set totalBoxes [lindex $val 0]
            set onlyFullBoxes yes ;# now we can process like a full box in a multiple box shipment
            #'debug "(boxes2) $totalBoxes - Full boxes only"

        # Now we check to see if we have zero full boxes, and a partial
        } elseif {([lindex $val 0] == 0) && ([lindex $val 1] != 0)} {
            set onlyFullBoxes no
            set totalBoxes 1
            #'debug "(boxes3) $totalBoxes - Partial Only"
        }
        
        if {$10_Country ne "US"} {
            if {$11_Phone eq ""} {
                set 11_Phone 5037909100
            }
        }
        

        

        for {set x 1} {$x <= $totalBoxes} {incr x} {
            'debug Writing to file...
            if {($x != $totalBoxes) || ($onlyFullBoxes eq yes)} {
                #'debug "boxes: $x - TotalBoxes: $totalBoxes"
                incr program(totalBooks) $18_fullbox
                
                # Detect if we are shipping to int'l addresses; if we are, set the required int'l parameters.
                eAssist_Code::international $10_Country $17_pieceweight $14_Date $18_fullbox
                
                if {[string toupper $10_Country] eq "CA"} {
                    if {$01_shipVia eq "17" || $01_shipVia eq "017"} {
                        set 01_shipVia 016
                    }
                }
                
                if {[string match $13_Version [list ""]] == 1 } { set boxVersion $18_fullbox } else { set boxVersion [list [concat [join $13_Version] / $18_fullbox]] }
                set boxWeight [::tcl::mathfunc::round [expr {$18_fullbox * $17_pieceweight + $settings(BoxTareWeight)}]]
                
                if {$GS_job(country) ne "US"} {
                    set pkg 0
                    set boxVersion [list [lindex $alphaList $F_pkg]_$boxVersion]
                    incr F_pkg
                }
                
                ## usps priority mail - MediumFlatRate
                    if {($intl(13_PackingType) eq "") && ($01_shipVia == 201) || ($01_shipVia == 202)} {
                        set intl(13_PackingType) MediumFlatRateBox
                    }
                ## usps priority mail - Flats
                    if {($intl(13_PackingType) eq "") && ($01_shipVia == 203) || ($01_shipVia == 204)} {
                        set intl(13_PackingType) Flat
                    }

                #'debug [::csv::join "$shipVia $Company $Attention $delAddr $delAddr2 $delAddr3 $City $State $Zip $Phone $GS_job(Number) $boxVersion $fullbox $GS_job(Description) $3PCode $3PAccount $boxWeight $x $totalBoxes $Email"]
                #chan puts $filesDestination [::csv::join "$shipVia $Company $Attention $delAddr $delAddr2 $delAddr3 $City $State $Zip US $Phone $Email $GS_job(Number) $GS_job(Number) $boxVersion $fullbox $GS_job(Description) $3PCode $3PAccount $boxWeight $x $totalBoxes"]
                #### MATRIX ####
                lappend matrix(importFile) [list '$01_shipVia \
                                            $02_Company \
                                            $03_Attention \
                                            $04_delAddr \
                                            $05_delAddr2 \
                                            $06_delAddr3 \
                                            $07_City \
                                            $08_State \
                                            $09_Zip \
                                            $10_Country \
                                            $11_Phone \
                                            $15_Email \
                                            $GS_job(Number) \
                                            $GS_job(Number) \
                                            $boxVersion \
                                            $18_fullbox \
                                            $GS_job(Description) \
                                            $3PCode \
                                            $3PAccount \
                                            $boxWeight \
                                            $x \
                                            $totalBoxes \
                                            $14_Date \
                                            $intl(01_ItemDescription) \
                                            $intl(02_ItemNumber) \
                                            $intl(03_ItemQuantity) \
                                            $intl(04_UOM) \
                                            $intl(05_DutiesPayer) \
                                            $intl(06_DutiesPayerAccountNumber) \
                                            $intl(07_License) \
                                            $intl(08_LicenseDate) \
                                            $intl(09_CountryOfOrigin) \
                                            $intl(10_TermsOfShipment) \
                                            $intl(11_UnitValue) \
                                            $intl(12_ItemWeight) \
                                            $intl(13_PackingType) \
                                            $ship(01_ShipFromName) \
                                            $ship(02_ShipFromContact) \
                                            $ship(03_ShipFromAddressLine1) \
                                            $ship(04_ShipFromAddressLine2) \
                                            $ship(05_ShipFromCity) \
                                            $ship(06_ShipFromState) \
                                            $ship(07_ShipFromCountry) \
                                            $ship(08_ShipFromZipCode) \
                                            $ship(09_ShipFromPhoneNo)]

            } elseif {($x == $totalBoxes) || ($onlyFullBoxes eq no)} {
                #'debug "boxes: $x - TotalBoxes (Partials): $totalBoxes"
                incr program(totalBooks) [lindex $val 1]

                # Detect if we are shipping to int'l addresses; if we are, set the required int'l parameters.
                eAssist_Code::international $10_Country $17_pieceweight $14_Date [lindex $val 1]
                
                if {[string match $13_Version [list ""]] == 1} {
                    set boxVersion [lindex $val 1]
                    } else {
                        set boxVersion [list [concat [join $13_Version] / [lindex $val 1]]]
                    }
                    
                if {$GS_job(country) ne "US"} {
                    set boxVersion [list [lindex $alphaList $P_pkg]_$boxVersion]
                    incr P_pkg
                }

                set boxWeight [::tcl::mathfunc::round [expr {[lindex $val 1] * $17_pieceweight + $settings(BoxTareWeight)}]]
                
                ## usps priority mail - MediumFlatRate
                    if {($intl(13_PackingType) eq "") && ($01_shipVia == 201) || ($01_shipVia == 202)} {
                        set intl(13_PackingType) MediumFlatRateBox
                    }
                ## usps priority mail - Flats
                    if {($intl(13_PackingType) eq "") && ($01_shipVia == 203) || ($01_shipVia == 204)} {
                        set intl(13_PackingType) Flat
                    }
                    
                if {[string toupper $10_Country] eq "CA"} {
                    if {$01_shipVia eq "17" || $01_shipVia eq "017"} {
                        set 01_shipVia 016
                    }
                }
                    
                #'debug "PartialBoxes_err: $err_2"
                #'debug [::csv::join "$shipVia $Company $Attention $delAddr $delAddr2 $delAddr3 $City $State $Zip $Phone $GS_job(Number) $boxVersion [lindex $val 1] $GS_job(Description) $3PCode $3PAccount $boxWeight $x $totalBoxes $Email"]
                #chan puts $filesDestination [::csv::join "$shipVia $Company $Attention $delAddr $delAddr2 $delAddr3 $City $State $Zip US $Phone $Email $GS_job(Number) $GS_job(Number) $boxVersion [lindex $val 1] $GS_job(Description) $3PCode $3PAccount $boxWeight $x $totalBoxes"]
                #### MATRIX ####
                lappend matrix(importFile) [list '$01_shipVia \
                                            $02_Company \
                                            $03_Attention \
                                            $04_delAddr \
                                            $05_delAddr2 \
                                            $06_delAddr3 \
                                            $07_City \
                                            $08_State \
                                            $09_Zip \
                                            $10_Country \
                                            $11_Phone \
                                            $15_Email \
                                            $GS_job(Number) \
                                            $GS_job(Number) \
                                            $boxVersion \
                                            [lindex $val 1] \
                                            $GS_job(Description) \
                                            $3PCode \
                                            $3PAccount \
                                            $boxWeight \
                                            $x \
                                            $totalBoxes \
                                            $14_Date \
                                            $intl(01_ItemDescription) \
                                            $intl(02_ItemNumber) \
                                            $intl(03_ItemQuantity) \
                                            $intl(04_UOM) \
                                            $intl(05_DutiesPayer) \
                                            $intl(06_DutiesPayerAccountNumber) \
                                            $intl(07_License) \
                                            $intl(08_LicenseDate) \
                                            $intl(09_CountryOfOrigin) \
                                            $intl(10_TermsOfShipment) \
                                            $intl(11_UnitValue) \
                                            $intl(12_ItemWeight) \
                                            $intl(13_PackingType) \
                                            $ship(01_ShipFromName) \
                                            $ship(02_ShipFromContact) \
                                            $ship(03_ShipFromAddressLine1) \
                                            $ship(04_ShipFromAddressLine2) \
                                            $ship(05_ShipFromCity) \
                                            $ship(06_ShipFromState) \
                                            $ship(07_ShipFromCountry) \
                                            $ship(08_ShipFromZipCode) \
                                            $ship(09_ShipFromPhoneNo)]
            }
            incr program(totalBoxes)

        }
        update
        incr program(ProgressBar)
        incr program(totalAddress)
        'debug "--------------"
    } ;# End of Foreach
    # This is here to get the last address recorded
    incr program(ProgressBar)

    # Set the file path and name
    set outFile [file join $mySettings(outFilePath) "$GS_file(Name) EA GENERATED"]
    set xfile [file nativename [file normalize $outFile]]

    eAssist_Helper::Excel $xfile
     
    #puts "matrix: $matrix(importFile)"

} ;# End of writeOutPut
