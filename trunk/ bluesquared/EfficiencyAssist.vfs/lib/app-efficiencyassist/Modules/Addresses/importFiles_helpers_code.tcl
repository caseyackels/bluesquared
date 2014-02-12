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
	
	set hdr1 [lsearch -glob [array names position] *$hdr]
	set hdr1 [lindex [array names position] $hdr1]

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


proc eAssistHelper::insValuesToTable {args} {
    #****f* insValuesToTable/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Insert values set through the GUI into selected cells
    #
    # SYNOPSIS
    #	$args = textvar with new data, and cell locations
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	eAssistHelper::insertItems
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global log files
    ${log}::debug --START-- [info level 1]
    
	set newType [join [lrange $args 0 0]]
	set cellLocations [join [lrange $args 1 end]]
	
	${log}::debug Inserting ...
	
	foreach val $cellLocations {
		${log}::debug Inserting $newType into $val
		$files(tab3f2).tbl cellconfigure $val -text $newType
	}

	
    ${log}::debug --END-- [info level 1]
} ;# eAssistHelper::insValuesToTable

proc eAssistHelper::multiCells {} {
    #****f* multiCells/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Check to see if we are selected on multiple columns; returns 1 if we are, 0 if aren't
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
    global log files
    ${log}::debug --START-- [info level 1]
	set curCol 1
	
    set cells [$files(tab3f2).tbl curcellselection]
	
	#if {[info exists curCol]} {unset curCol}
	foreach val $cells {
		# Initialize that variable
		if {![info exists curCol]} {set curCol [$files(tab3f2).tbl columncget [lrange [split $val ,] end end] -name]}
		
		# This should get over written during our cycles
		set curCol1 [$files(tab3f2).tbl columncget [lrange [split $val ,] end end] -name]
		
		# if we arent the same lets save the column name
		if {[string match $curCol1 $curCol] ne 1} {lappend curCol [$files(tab3f2).tbl columncget [lrange [split $val ,] end end] -name]}

	}
	
	if {[llength $curCol] eq 2} {return 1} else {return 0}
	#${log}::debug We are selected on [llength $curCol] columns
	
    ${log}::debug --END-- [info level 1]
} ;# eAssistHelper::multiCells
