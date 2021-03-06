# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 01/05/2014
# Dependencies:
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 169 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2014-09-14 21:48:00 -0700 (Sun, 14 Sep 2014) $
#
########################################################################################

##
## - Overview
# Overview



namespace eval ea::filter {}

proc ea::filter::runFilters {widTbl} {
    #****f* runFilters/ea::filter
    # CREATION DATE
    #   03/18/2015 (Wednesday Mar 18)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #
    #
    # SYNOPSIS
    #   ea::filter::runFilters <tablelist widget path>
    #
    # FUNCTION
    #	Cycles through a set of columns; using the filters that the user selected in eAssist_tools::FilterEditor
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
    #
    # SEE ALSO
    #   eAssist_tools::FilterEditor
    #
    #***
    global log job filter
	#set filters [list ea::filter::stripASCII_CC ea::filter::stripExtraSpaces ea::filter::stripUDL ea::filter::abbrvAddrState]
	#set filters [list ea::filter::stripUDL]

    ${log}::debug Table Path: $widTbl
	set columns [list Attention Company Address1 Address2 City State Zip Notes]



	if {[info exists filters]} {unset filters}
	foreach fltr [array names filter] {
		if {[string match run,* $fltr] != 0} {
			if {$filter($fltr) != 0 && $filter($fltr) != 1} {
				${log}::debug $filter($fltr) _ $fltr
				lappend filters $filter($fltr)
			}
		}
	}
	# retrieve max records to filter and set the progress bar
	$filter(f2).progbar configure -maximum [expr {[llength $filters] * [llength $columns]}]

	${log}::debug Running [llength $filters] filters, on [llength $columns] Columns!


	# Cycling through the columns
    foreach col $columns {
		# Retrieve column data
		${log}::debug Column: $col

        # Ensure the column exists, if it doesn't let's skip this iteration
        if {[$widTbl findcolumnname $col] == -1} {continue}

        set colData [$widTbl getcolumns $col]
        set i_row 0
		# Cycling through the data
        foreach item $colData {
			# Running the filters
			#${log}::debug row/item: $i_row / $item
			if {$item == ""} {continue} ;# Don't try to process if there isn't data
			set data $item
			foreach current_filter $filters {
				#${log}::debug Running $current_filter ...
				set data [$current_filter $data $col]
				incr filter(progbarProgress)
				set filter(progbarFilterName) "Column: $col, Filter: $current_filter"
			}
			if {![string match $item $data]} {
				# Only write the data and update the widget if data has changed ...
                # job::db::write <dbName> <dbTable> <text> <widTbl> <row,col> ?Db Col Name?
                ${log}::debug Clean Data -- WAS: $item NOW: $data
                ${log}::debug i_row,col: $i_row,$col
                #${log}::debug Column Name: [$widTbl columncget [lindex [split $widCells ,] end] -name]
                ${log}::debug Column Name: [$widTbl columncget 0 -name]
				#job::db::write $job(db,Name) Addresses $data $widTbl $i_row,$col
				#${log}::debug CLEAN DATA

			}
            incr i_row
        }
	}
	${log}::debug Finished!
	set filter(progbarFilterName) Finished!
} ;# ea::filter::runFilters $files(tab3f2).tbl {Company Attention Address1 Address2 City State} {ea::filter::stripASCII_CC ea::filter::stripExtraSpaces ea::filter::stripUDL ea::filter::abbrvAddrState}


proc ea::filter::stripASCII_CC {cellData args} {
    #****f* stripASCII_CC/ea::filter
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Strip Hi-Bit ASCII and Control Characters
    #
    # SYNOPSIS
    #
    #
    # CHILDREN
    #
    #
    # PARENTS
    #
    #
    # NOTES
    #   Found on rosettacode.org; modified from original finding.
    #   http://www.unicode.org/charts/PDF/U0000.pdf
    #
    # SEE ALSO
    #
    #***
    global log filter counter

    #set newString [eAssist_tools::stripExtraSpaces [regsub -all {[^\u0020-\u007e]+} $cellData ""]]
    set newString [regsub -all {[^\u0020-\u007e]+} $cellData ""]
    set newString [join $newString]

    return $newString
} ;# ea::filter::stripASCII_CC


proc eAssist_tools::stripCC {cellData} {
    #****f* stripCC/eAssist_tools
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Only strip Control Characters
    #
    # SYNOPSIS
    #
    #
    # CHILDREN
    #
    #
    # PARENTS
    #
    #
    # NOTES
    #   Found on: rosettacode.org
    #
    # SEE ALSO
    #
    #***
    global log filter counter
    #${log}::debug --START-- [info level 1]
    #if {$filter(run,stripCC) != 1} {${log}::debug Filter not set; return}

    #set newString [eAssist_tools::stripExtraSpaces [regsub -all {[\u0000-\u001f][\u007f]+} $cellData ""]]
    set newString [regsub -all {[\u0000-\u001f][\u007f]+} $cellData ""]
    set newString [join $newString]

    #$filter(f2).progbar step
    incr filter(progbarProgress)
    incr counter
    update
	return $newString
    #${log}::debug --END-- [info level 1]
} ;# eAssist_tools::stripCC


proc ea::filter::stripExtraSpaces {cellData args} {
    #****f* stripExtraSpaces/ea::filter
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Strip additional spaces in a string
    #
    # SYNOPSIS
    #
    #
    # CHILDREN
    #
    #
    # PARENTS
    #
    #
    # NOTES
    #
    #
    # SEE ALSO
    #
    #***
    global log filter

    # ... strip extra spaces
    if {$cellData == {} } {
        return
    }

    foreach value [split $cellData { }] {
        if {$value != {}} {
            lappend newString [string trim $value]
        }
        #lappend newString [join [string trim $value]]
    }

    set newString [join $newString]

    return $newString
} ;# ea::filter::stripExtraSpaces


proc ea::filter::stripUDL {cellData args} {
    #****f* stripUDL/ea::filter
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Using a "User Defined List (UDL)", strip characters from string
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
    global log

	# This will need to reference a saved list from the users profile/preferences file.
    set StripChars [list ' ` ~ . ? ! _ , : | $ ! + = ( ) ~]

    set newString $cellData

    foreach value $StripChars {
        #set newString [join [eAssist_tools::stripExtraSpaces [string map [list [concat \ $value] ""] $newString]]]
        #set newString [join [string map [list [concat \ $value] ""] $newString]]
		set newString [string map [list [concat \ $value] ""] $newString]
    }

	return $newString
} ;# ea::filter::stripUDL 32 E. 31st St.


proc ea::filter::abbrvAddrState {cellData args} {
    #****f* abbrvAddrState/ea::filter
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Abbreviate the addresses and states from most likely words to known abbreviations.
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
    global log filter counter
    #${log}::debug --START-- [info level 1]
    #if {$filter(run,abbrvAddrState) != 1} {${log}::debug Filter not set; return}

    # Keep source cellData and output cellData separate
    set cellDataWorking [string tolower $cellData]
    set cellDataOrig [string tolower $cellData]
    set newString ""
    set whatChanged "Nothing Changed:"

    ## Stop processing if we aren't on a column that we want to process
    switch -- $args {
        Address1    {}
        Address2    {}
        State       {}
        default     {return $cellData}
    }

    # Run the data through the filters only if it exists for the corresponding column name
    # Address 1 and 2, need multiple passes.
    if {$args eq "Address1"} {
		# It is very likely that data that should be in Address2 ends up at the end of Address1.
		# Lets account for that, and first look for these. If found, we can move them to the correct column.
		# This will also help us, when trying to sanitize the real address1 data.

		# set cellDataWorking [string tolower {785 Market Street circle  Suite 900 Floor 25}]
		# set cellDataWorking [string tolower {785 Market Street}]
		foreach secUnit [string tolower $filter(secondaryUnits)] {
			set secUnitIndex [lsearch $cellDataWorking $secUnit]

			# Ex. 785 Market St  Ste 900
			if {$secUnitIndex != -1} {
				# We have a match, grab the whole suffix
				#set suffix [lrange $cellDataWorking $secUnitIndex end]
				lappend secUnit_index $secUnitIndex
			}
		}
		# Sanitize it, so it matches the USPS recommended abbr.
		# We have the indices; now lets grab the data
		if {[info exists secUnit_index]} {
			set suffix_secUnitIndex [lindex [lsort -integer $secUnit_index] 0]
			set suffix [lrange $cellDataWorking $suffix_secUnitIndex end]
			set suffix [string map [string tolower $filter(secondaryUnits)] $suffix]

			${log}::debug SUFFIX: $suffix

			unset secUnit_index
		}

		# We've found the suffix (address2 data), now lets find the address1 data and sanitize
		# Test
		# set cellDataWorking [string tolower {785 Market Street}]
		foreach addr_suffix [string tolower $filter(addrStreetSuffix)] {
            set addr_suffixIndex [lsearch $cellDataWorking $addr_suffix]

            if {$addr_suffixIndex != -1} {
				# Grab the part of the address that we want to manipulate; if we don't some addresses could be sanitized incorrectly.
				lappend indice_addr1 $addr_suffixIndex
            }
        }

		if {[info exists indice_addr1]} {
			# We must handle the address info in two passes. First pass is used if we found a secondary address.
			# Second pass is used if we found a secondary in the address1 data.
			set addr_1Index [lindex [lsort -integer $indice_addr1] 0]

			if {[info exists suffix_secUnitIndex]} {
				# split the data that we don't want, from the data that we do want.
				# the value of addr_1 will be street, road, or any other Street type
				set addr_1 [lrange $cellDataWorking $addr_1Index [expr {$suffix_secUnitIndex - 1}]]
				set addr_1 [string map [string tolower $filter(addrStreetSuffix)] $addr_1]

				# Add the two strings back together again
				set cellDataWorking [join "[lrange $cellDataWorking 0 [expr {$addr_1Index -1}]] $addr_1"]
				${log}::debug ADDR_1: $addr_1

			} else {
				# There could be a addrSuffix in the data; lets check.
				#set cellDataWorking $cellDataWorking
				set addr1 [lrange $cellDataWorking 0 [expr {$addr_1Index -1}]]
				set addr2 [string map [string tolower $filter(addrStreetSuffix)] [lrange $cellDataWorking $addr_1Index end]]
				set cellDataWorking [join "$addr1 $addr2"]
				${log}::debug No Secondary Unit/Suffix, looking for road, street, etc.
				${log}::debug Addr1: $addr1 - Addr2: $addr2
				${log}::debug cellDataWorking: $cellDataWorking
			}

			if {[info exists suffix]} {
				set cellDataWorking [join "$cellDataWorking $suffix"]
				${log}::debug Address WITH Suffix
				${log}::debug cellDataWorking: $cellDataWorking - Suffix: $suffix
			}
			unset indice_addr1
		} else {
			# No secondary address info was found ... Looking for the street type
			foreach street [string tolower $filter(addrStreetSuffix)] {
				set addr_streetIndex [lsearch $cellDataWorking $street]

				if {$addr_streetIndex != -1} {
					lappend indice_street $addr_streetIndex
				}
			}

			if {[info exists indice_street]} {
				set address [lrange $cellDataWorking 0 [expr {$indice_street - 1}]]
				set street_name [lrange $cellDataWorking $indice_street end]
				set street_name [string map [string tolower $filter(addrStreetSuffix)] $street_name]

				set cellDataWorking [join "$address $street_name"]
				${log}::debug Address - NO SUFFIX
				${log}::debug cellDataWorking: $cellDataWorking
			}
		}

		${log}::debug Whole Addr: $cellDataWorking

        if {[string compare $cellDataWorking $cellDataOrig] != 0} {
            set whatChanged "Address1 Changed:"
        }
    }

    # No need to cycle over lists that probably would never apply....
    if {$args eq "Address2"} {
        set cellDataWorking [string map [string tolower $filter(secondaryUnits)] $cellDataWorking]

        if {[string compare $cellDataWorking $cellDataOrig] != 0} {
            set whatChanged "Address2 Changed:"
        }
    }

    if {$args eq "State"} {
        #set cellData [string map $filter(StateList) $cellDataWorking]

        if {[string compare $cellDataWorking $cellDataOrig] != 0} {
            set whatChanged "State Changed:"
        }
    }

    ##
	## Set Title Case
	##
    set cellData [list {*}$cellDataWorking]
    if {[info exists newString]} {unset newString}

    foreach word $cellData {
        # Ensure that we set items with only one list item to all upper case.
        if {[llength $cellData] == 1} {
            set Case toupper
        } else {
            set Case totitle
        }

        lappend newString [string $Case $word]
    }

    if {![info exists newString]} {set newString $cellData}
    #${log}::notice $whatChanged $cellDataOrig -to- $newString

    #$filter(f2).progbar step
    #return $cellData
    #incr filter(progbarProgress)
    #update
    return $newString
    #${log}::debug --END-- [info level 1]
} ;# ea::filter::abbrvAddrState

#ea::filter::runFilters $files(tab3f2).tbl {Address1 Address2} {ea::filter::abbrvAddrState}
