# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 169 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2011-10-17 16:11:20 -0700 (Mon, 17 Oct 2011) $
#
########################################################################################

##
## - Overview
# This file holds the helper procs for the Addresses

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

## Coding Conventions
# - Namespaces:

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

namespace eval eAssistHelper {}


proc eAssistHelper::autoMap {masterHeader fileHeader} {
    #****f* autoMap/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Automatically maps File Headers to the corresponding Master Header
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
    global log files process position headerParent
    ${log}::debug --START -- [info level 1]
	
    # Insert mapped headers into the Mapped headers listbox
	$files(tab1f3).listbox insert end "$fileHeader > $masterHeader"
	
	# Color the mapped headers
	$files(tab1f1).listbox itemconfigure end -foreground lightgrey -selectforeground grey
	
	foreach item $headerParent(headerList) {
		if {[string compare -nocase $item $masterHeader] != -1} {
			$files(tab1f2).listbox itemconfigure [lsearch $headerParent(headerList) $masterHeader] -foreground lightgrey -selectforeground grey
		}
	}
	
	set cSelection [lsearch -nocase $process(Header) $fileHeader]
	
	if {[string length $cSelection] <= 1} {
		set cSelection "0$cSelection"
	} else {
		${log}::debug cSelection has two digits: $cSelection
	}
	
	set position([join [list $cSelection $masterHeader] _]) ""
		
    ${log}::debug --END -- [info level 1]
} ;# eAssistHelper::autoMap


proc eAssistHelper::mapHeader {} {
    #****f* mapHeader/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Maps the two headers together, and inserts them into the 'Mapped' listbox. Behind the scenes we take care of the mapping a different way than what is displayed.
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
    global log files position
	${log}::debug --START-- [info level 1]
    
	#${log}::debug textvar: [$files(tab1f1).listbox get [$files(tab1f1).listbox curselection]] > [$files(tab1f2).listbox get [$files(tab1f2).listbox curselection]]
	
	# Insert the two mapped headers into the "Mapped" listbox.
    $files(tab1f3).listbox insert end "[$files(tab1f1).listbox get [$files(tab1f1).listbox curselection]] > [$files(tab1f2).listbox get [$files(tab1f2).listbox curselection]]"

	# 
	if {[string length [$files(tab1f1).listbox curselection]] <= 1 } {
			set cSelection 0[$files(tab1f1).listbox curselection]
			${log}::debug selection $cSelection
	} else {
		set cSelection [$files(tab1f1).listbox curselection]
		${log}::debug selection $cSelection
	}
	
	# cSelection = index; header Name = 01_Address
	set header [join [join [split [list [$files(tab1f2).listbox get [$files(tab1f2).listbox curselection] ] ] ] ""]]
	${log}::debug header: $header
	
	set position([join [list $cSelection $header] _]) ""
	
	# Delete "un-assigned column" entry
	$files(tab1f1).listbox itemconfigure [$files(tab1f1).listbox curselection] -foreground lightgrey -selectforeground grey
	
	# Delete "available column" entry
	$files(tab1f2).listbox itemconfigure [$files(tab1f2).listbox curselection] -foreground lightgrey -selectforeground grey
	
	${log}::debug --END-- [info level 1]
} ;# eAssistHelper::mapHeader


proc eAssistHelper::unMapHeader {} {
    #****f* unMapHeader/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Unmap the mapped headers
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
    global log files position
	${log}::debug --START-- [info level 1]
	
	set hdr [$files(tab1f3).listbox get [$files(tab1f3).listbox curselection]]
	set hdr [join [join [lrange [split $hdr >] 1 end]]]
	#${log}::debug hdr $hdr
	
	set hdr1 [lsearch -glob [array names position] *$hdr]
	#${log}::debug hdr1a $hdr1
	set hdr1 [lindex [array names position] $hdr1]
	#${log}::debug hdr1b $hdr1
	
	#${log}::debug Deleting Record: [$files(tab1f3).listbox curselection]
	#${log}::debug Remove Header: [string trim $hdr]
	#${log}::debug Real Header: position($hdr1)

	# Remove the header from the array, so we can re-assign if neccessary.
	unset position($hdr1) 
	$files(tab1f3).listbox delete [$files(tab1f3).listbox curselection]
	
	#parray position
	
	${log}::debug --END-- [info level 1]
} ;# ::unMapHeader


proc eAssistHelper::unHideColumns {} {
    #****f* addColumns/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2013 Casey Ackels
    #
    # FUNCTION
    #	Add the selected Distribution Types to the table
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
    global log files process dist headerParent
    ${log}::debug --START -- [info level 1]
	
	set col [lsearch $headerParent(headerList) [$files(tab3f1a).lbox1 get [$files(tab3f1a).lbox1 curselection]]]
	
	if {$col != ""} {
		$files(tab3f2).tbl columnconfigure $col -hide no
	} else {
		${log}::debug Add Columns did not receive a selection
	}
	
	# Delete the entry
	$files(tab3f1a).lbox1 delete [$files(tab3f1a).lbox1 curselection]
	
    ${log}::debug --END -- [info level 1]
} ;# eAssistHelper::addColumns


proc eAssistHelper::filters {} {
    #****f* filters/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Filters select columns
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
    global log files headerParams filter
    ${log}::debug --START -- [info level 1]
    
	#${log}::debug Addresses: [$files(tab3f2).tbl getcells 0,end]
	set ColumnCount [$files(tab3f2).tbl columncount]
	set RowCount [llength [$files(tab3f2).tbl getcells 0,0 end,0]]
	
	${log}::debug ColumnCount: $ColumnCount
	${log}::debug RowCount: $RowCount
	
	# Retrieve the column names, so we know if we have a second or third address field.
	# Columns
	for {set y 0} {$ColumnCount > $y} {incr y} {
		lappend ColumnName1 [$files(tab3f2).tbl columncget $y -name]
	}
	
	${log}::debug ColumnNames: $ColumnName1
	set haveAddress2 [lsearch $ColumnName1 Address2]
	set haveAddress3 [lsearch $ColumnName1 Address3]

	
	set byPass ""
	set cellNumber ""
	
	# List the qualified filters
	set filter(Address1) ""
	set filter(Address2) ""
	set filter(State) ""
	
	# Rows
	for {set x 0} {$RowCount > $x} {incr x} {
		# Columns
		for {set y 0} {$ColumnCount > $y} {incr y} {
			set ColumnName [$files(tab3f2).tbl columncget $y -name]
			
			# If we haven't set up any params for the header, lets make sure we skip it.
			if {[lsearch [array names headerParams] $ColumnName] != -1} {
				set maxChar [lindex $headerParams($ColumnName) 0]
				} else {
					set byPass 1
				}

			set filterExists [lsearch [array name filter] $ColumnName]
			
			set cellData [string tolower [join [$files(tab3f2).tbl getcells $x,$y $x,$y] ""]]
			# Remove any periods
			set cellData [join [split $cellData .] ""]
			
			# Run the data through the filters, only if it exists for the corresponding column name
			if {$filterExists != -1} {
				
				# Address 1 and 2, need multiple passes.
				if {$ColumnName eq "Address1"} {
					${log}::debug Before changes: $cellData
					
					# Cycle through our list of suffices to match against our cellData; if they do then lets map the words to our abbreviations
					foreach item $filter(addrStreetSuffix) {
						set newItem [lsearch $cellData $item]
						
						if {$newItem != -1} {
							set prefix [lrange $cellData 0 [expr {$newItem} -1]]
							#${log}::debug Prefix: $prefix
							
							set suffix [lrange $cellData $newItem end]
							#${log}::debug Suffix: $suffix
							
							#set suffix [join [string map $filter(addrStreetSuffix) $suffix]]
							set suffix [string map $filter(addrStreetSuffix) $suffix]
							
							set suffix [string map $filter(secondaryUnits) $suffix]
							#${log}::debug Changed Suffix: $suffix
							
							set cellData "$prefix $suffix"
							#${log}::debug New Cell Data: $cellData
						}
					}
					${log}::debug Street Suffix Changes: $cellData
				}
				
				# No need to cycle over lists that probably would never apply....
				if {$ColumnName eq "Address2"} {
					set cellData [string map $filter(secondaryUnits) $cellData]
				}
				
				if {$ColumnName eq "State"} {
					#if {[lsearch $filter(State) $cellData] == -1} {${log}::debug State doesn't exist $cellData}
					${log}::debug State Before: $cellData
					set cellData [string map $filter(StateList) $cellData]
					${log}::debug State After: $cellData
				}

			}
			
			# Keep track of the cells which contain more data than they should
			if {$byPass != 1} {
				#${log}::debug Bypass is not activated - $cellData
				if {[string length $cellData] > $maxChar} {
					lappend cellNumber $y
				}
			}
			lappend newRow [string toupper $cellData]
		}
		# We must first delete the existing row, then insert the new row.
		$files(tab3f2).tbl delete $x
		$files(tab3f2).tbl insert $x $newRow
		
		# Now we can highlight the appropriate cells if the data still exceeds the MaxChar requirements
		if {$cellNumber != ""} {
			#${log}::debug cellNumber contains: $cellNumber
			foreach column $cellNumber {
					#set column [expr $column -1] ;# Columns start at 0
					set hdName [$files(tab3f2).tbl columncget $column -name]
					
					if {[lindex $headerParams($hdName) 3] != ""} {
						set backGround [lindex $headerParams($hdName) 3]
					} else {
						set backGround yellow
					}
					$files(tab3f2).tbl cellconfigure $x,$column -bg $backGround
			}
		}
		
		unset newRow
		set cellNumber ""
		set byPass ""
	}

	
    ${log}::debug --END -- [info level 1]
} ;# eAssistHelper::filters


proc eAssistHelper::resetImportInterface {} {
    #****f* resetImportInterface/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Resets the import file interface
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
    global log w process position
    ${log}::debug --START -- [info level 1]
    
	#Enable the widgets
	#$w(nbk) tab 1 -state normal
	$w(nbk) tab 2 -state disable
	
	$w(nbk).f1.top.btn2 configure -state normal
	$w(nbk).f1.btns.btn1 configure -state normal
	$w(nbk).f1.btns.btn2 configure -state normal
	
	# Clear out the listboxes and tables
	$w(nbk).f1.lbox1.listbox delete 0 end
	$w(nbk).f1.lbox3.listbox delete 0 end
	$w(nbk).f3.nb.f1.f2.tbl delete 0 end
	
	# Clear out the variables
	if {[array exists process] == 1} {
		unset process
	}
	
	if {[array exists position] == 1} {
		unset position
	}
	
    ${log}::debug --END -- [info level 1]
} ;# eAssistHelper::resetImportInterface
