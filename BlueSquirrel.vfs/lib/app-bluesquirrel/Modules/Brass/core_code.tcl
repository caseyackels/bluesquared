# Creator: Casey Ackels
# Date: May 26th, 2007
# Last Updated:
# Version: .2
# Dependencies: See brass_launch_code.tcl


namespace eval Brass_BackEnd {

proc generateFile {} {
    global gui boxSize A_header
    
    # Initiate the header and boxInfo array, below we clear it out at each break in the address file
    header_array
    boxInfo_array

    
    # Open the file, run the helper procs, and generate the .csv file
    set fp [open $gui(S_brassFile)]
    set targetFile [open brassUPS_finished.csv w]
    
    # Insert the top row (this will be used as a header row)
    # Month Code CUname Boxes Quantity
    #puts $targetFile [::csv::join "Company, Attn, Address1, Address2, Address3, City, State, Zip, Phone, Qty/boxSize, NumberOfBoxInShipment"]

	while {-1 != [gets $fp line]} {			
			parseList $targetFile $line
	}
	
	
	# Close the open files after parsing and writing to them.
	close $fp
	close $targetFile


	tk_messageBox -default ok \
	    -type ok \
	    -icon info \
	    -title "File has been generated" \
	    -parent . \
	    -message "The file has been generated.\n\nPlease confirm in Excel that everything is correct.\n\nThe generated file name is brassUPS_finished.csv."

} ;# End of generateFile    


proc parseList {targetFile line} {
    global address A_header A_brassAddress
    
    
    set L_csvList [string trim $line ,]
    #set L_csvList [::csv::split $line]
    
    if {$L_csvList == ""} {
	# Clear out the values in the Header array
        
        header_array ; #puts "Cleared A_header"
	boxInfo_array ; #puts "Cleared A_boxInfo"
	return
    
    } else {
	#puts "detectAddress - csvList: $L_csvList"
	detectAddress $L_csvList
	
    }

} ;# End of parseList

  
proc detectAddress {addressLine} {
    global L_states L_streetSuffix L_secondaryUnit A_header boxSize


    # Control gate to let us know that we have/haven't passed through $L_states, or $L_secondaryUnit
    set I_isCSZ 0
    set I_isSecUnit 0
    
    # Keep one string in 'raw' format.
    set addressLine2 $addressLine
    
    # Make this string all lowercase
    set addressLine [string tolower $addressLine]
    
    
    #puts "Starting..."
	foreach item $L_secondaryUnit {
	    set cleanedAddress [string trim $addressLine \"]
	    set I_secUnit [lsearch -exact $cleanedAddress $item]
	    
	    # Guard against secondary Units, having the same word in the Company name.
	    if {[lsearch [string tolower $cleanedAddress] credit] == -1} {
	    
	    if {$I_secUnit != -1} {
		# Make sure that the address1 and address2 are in separate fields
		# So we sort it out here.
		set A_header(03_address1) [lrange $cleanedAddress 0 [incr I_secUnit -1] ]
		set A_header(03_address1) [join [split $A_header(03_address1) ,] ""]
		
		set A_header(04_address2) [lrange $cleanedAddress [incr I_secUnit 1] end]
		
		set I_isSecUnit 1

		#puts "address1: [join [split $A_header(03_address1) ,] ""]"
		#puts "address1: $A_header(03_address1)"
		#puts "address2: $A_header(04_address2)"
		#puts "secUnit: $I_secUnit"
	    }
	    
	    }
	}
    #puts "Halfway through..."
	# Cycle through the list of States and their abreviations
	foreach item $L_states {
	    set I_statePos [lsearch [string trim $addressLine \",] $item]
	    #puts "I_statePos: $I_statePos"
	
	    if {$I_statePos != -1} {
		# Guard against Credit Union Names that include a State name
		#if {[string is integer [join [split [lindex [string trim $addressLine2 \",] end] -] ""]] == 1} {}
		if {[zip+4 [join [split [lindex [string trim $addressLine2 \",] end] -] ""]] == 1} {
		    puts "Passed Zip Check"
		
		
		    # We are assuming that city, state, zip are all on one line.
		    # In the 0, 1 and 2 positions.
		    set CSV_length [llength [split $addressLine2]]
		    
		    set A_header(08_zip) [lindex [string trim $addressLine2 \",] [incr CSV_length -1]]
		    set A_header(08_zip) [zip+4 $A_header(08_zip)]
		    
		    set A_header(07_state) [lindex [string trim $addressLine2 \",] [incr CSV_length -1]]
		    
		    set A_header(06_city) [lrange [string trim $addressLine2 \",] 0 [incr CSV_length -1]]
		    set A_header(06_city) [join [split $A_header(06_city) ,] ""]
		    
		    
		
		    # Control Gate
		    # CSZ, City State Zip
		    set I_isCSZ 1
		
		    puts "City: [join [split $A_header(06_city) ,] ""]"
		    puts "City: $A_header(06_city)"
		    puts "State: $A_header(07_state)"
		    #puts "Zip: $A_header(08_zip)"
		    #puts "ZIP2: [zip+4 $A_header(08_zip)]"
		    #puts "statePos: $I_statePos"
		}
	    }
	}
	
	if {($I_isSecUnit == 0) && ($I_isCSZ == 0)} {
	    # Since the above vars, should both equal 0, we know that we are NOT in city,state,zip or address2
 
            if {$A_header(01_company) == ""} {
                set A_header(01_company) [lindex [join [split [::csv::split $addressLine2] ,] ""] 0]
		#set A_header(01_company) [lindex [join [split $addressLine2 ,] ""] 0]
		set A_boxInfo(01_qtyInShipment) [lindex [::csv::split $addressLine2] 1]
		#set A_header(11_qtyInShipment) [lindex $addressLine2 1]
                puts "Company: $A_header(01_company)"
		#puts "Qty: $A_boxInfo(01_qtyInShipment)"
		
                # Remove all comma's
                set A_boxInfo(01_qtyInShipment) [join [split $A_boxInfo(01_qtyInShipment) ,] ""]
                # Retrieve quantities.
		Brass_Libraries::doMath $A_boxInfo(01_qtyInShipment) $boxSize(9,qty)
            
            } elseif {$A_header(02_attn) == ""} {
                
                set A_header(02_attn) [split $addressLine2 ,]
                set A_header(02_attn) [string trim [lindex $A_header(02_attn) 0] \"]
                #puts "Attn: $A_header(02_attn)"
		
	    } elseif {$A_header(03_address1) == ""} {
                set A_header(03_address1) [string trim $addressLine2 \",]
                #puts "Address1: $A_header(03_address1)"
	    
	    } elseif {$A_header(09_phone) == ""} {
		set A_header(09_phone) $addressLine2
		#puts "Phone: $A_header(09_phone)"
		
		# All vars, should be populated now. So lets write it out to a file.
		writeFile ;#$targetFile
	    }

	}

} ;# End of detectAddress

#set addressLine2 {"Parlin, NJ 08859",}
#zip+4 [join [split [lindex [string trim $addressLine2 \",] end] -] ""]
proc zip+4 {S_zip} {
    #global A_header
    # make sure the Zip is 5 numbers, which include leading zeros. Or is 9 numbers, Zip+4 and includes the hypen. 10 Chars.
    
    ## TODO: If the zip has Zip+4, but has no leading zero(s), this will fail.
    ## Detect if we have a hypen, if we do, split the string, then do our mathmatics.

    if {[string is integer $S_zip] == 1} {
	set I_zip 1
	#puts "I_zip: $I_zip"
    
    } else {
	set I_zip_4 2
	#puts "I_zip_4: $I_zip_4"
	
	set S_zip_split [split $S_zip -]
	#puts "S_zip_split: $S_zip_split"
	
	set S_zip [lindex $S_zip_split 0]
	#puts "S_zip: $S_zip"
	
	set S_zip_4 [lindex $S_zip_split 1]
	#puts "S_zip_4: $S_zip_4"
	#puts $S_zip_4
    }
    
    if {4 >= [string length $S_zip]} {
	set I_zipDiff [expr 5 - [string length $S_zip]]
	#puts "I_zipDiff: $I_zipDiff"
	
	
	for {set x 0} {$x < $I_zipDiff} {incr x} {
	    append I_zipTemp 0
	    #puts "I_zipTemp: $I_zipTemp"
            #puts "I_zipTemp: $I_zipTemp"
            #puts "I_zipDiff: $I_zipDiff"
	}
    }
    
    if {[info exists I_zip_4] == 1} {
	set S_zip [append I_zipTemp $S_zip - $S_zip_4]
	#puts "S_zip: $S_zip"
    
    } else {
	set S_zip [append I_zipTemp $S_zip]
	#puts "S_zip: $S_zip"
    }
} ;# End of zip+4


proc header_array {} {
    global A_header
    
    	# Create Header array
	# We want this reset after every pass.
	array set A_header {
	01_company ""
	02_attn ""
	03_address1 ""
	04_address2 ""
	05_address3 ""
	06_city ""
	07_state ""
	08_zip ""
	09_phone ""
	}
} ;# End of header_array

proc boxInfo_array {} {
    global A_boxInfo
    
    array set A_boxInfo {
	01_qtyInShipment ""
	02_qtyPerBox ""
	03_numberOfBoxInShipment ""
	04_TotalNumberOfBoxInShipment ""
    }
} ;# End of boxInfo_array


#proc writeFile {targetFile} {}
proc writeFile {} {
    global A_header boxSize A_boxInfo

    
    # Add a dot (period), for each element that is empty so that we end up with uniform amount of fields.
    foreach {element value} [array get A_header] {
	if {$value == ""} {set A_header($element) .}
	#puts "$element $value"
    }
    
    # Write out info for the Full boxes
    if {$boxSize(numFullBoxes) != ""} {
	set TotalNumberOfBoxInShipment [expr {$boxSize(numFullBoxes) + 1}]
	
	for {set x 0} {$x < $boxSize(numFullBoxes)} {incr x} {
            # This is the line that controls FULL boxes
	    set numOfBoxInShipment [expr {$x + 1}]
	    # Add $targetFile for writing to an actual file.
	    parray A_header
            puts [csv::join "[list $A_header(01_company)] [list $A_header(02_attn)] [list $A_header(03_address1)] [list $A_header(04_address2)] [list $A_header(05_address3)] [list $A_header(06_city)] [list $A_header(07_state)] $A_header(08_zip) [list $A_header(09_phone)] $boxSize(9,qty) $boxSize(fullBoxWeight) $numOfBoxInShipment $TotalNumberOfBoxInShipment"]
        }
	
    } else {
	set TotalNumberOfBoxInShipment 1
    }
    
    #puts "boxSize(generic,qty): $boxSize(generic,qty)"
    #puts "boxSize(generic,lb): $boxSize(generic,lb)"
    
    if {([info exists boxSize(generic,qty)] != 0) && ($boxSize(generic,qty) != "")} {
	# Write out info for the Partial Boxes
        # Add $targetFile for writing to an actual file.
	puts [csv::join "[list $A_header(01_company)] [list $A_header(02_attn)] [list $A_header(03_address1)] [list $A_header(04_address2)] [list $A_header(05_address3)] [list $A_header(06_city)] [list $A_header(07_state)] $A_header(08_zip) [list $A_header(09_phone)] $boxSize(generic,qty) $boxSize(generic,lb) $TotalNumberOfBoxInShipment $TotalNumberOfBoxInShipment"]
    }
    
} ;# End of writeFile

} ;# End of Brass_BackEnd
