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
    global log files process position headerParent w
    ${log}::debug --START -- [info level 1]
	
	# setup the variables
	set lboxOrig $w(wi).lbox1.listbox
	set lboxAvail $w(wi).lbox2.listbox
	set lboxMapped $w(wi).lbox3.listbox
    
	# Insert mapped headers into the Mapped headers listbox
	$lboxMapped insert end "$fileHeader > $masterHeader"
	
	# Color the mapped headers
	$lboxOrig itemconfigure end -foreground lightgrey -selectforeground grey
	
	foreach item $headerParent(headerList) {
		if {[string compare -nocase $item $masterHeader] != -1} {
			$lboxAvail itemconfigure [lsearch $headerParent(headerList) $masterHeader] -foreground lightgrey -selectforeground grey
		}
	}
	
	#lsearch -nocase [$w(wi).lbox2.listbox get 0 end] shipdate
	set cSelection [lsearch -nocase $process(Header) $fileHeader]
	
	#set cSelection [expr {[lsearch -nocase [$w(wi).lbox2.listbox get 0 end] $masterHeader] + 1}]
	${log}::debug cSelection: $cSelection
	
	if {[string length $cSelection] <= 1} {
		set cSelection "0$cSelection"
	} else {
		${log}::debug cSelection has two digits: $cSelection
	}
	
	set position([join [list $cSelection $masterHeader] _]) ""
	${log}::debug cSelection: $cSelection
	${log}::debug masterHeader: $masterHeader
	${log}::debug New Pos: [join [list [lsearch -nocase $process(Header) $masterHeader]] _]
	
	${log}::debug [lsort [array names position]]
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
    global log files position w
	${log}::debug --START-- [info level 1]
	
	# setup the variables
	set lboxOrig $w(wi).lbox1.listbox
	set lboxAvail $w(wi).lbox2.listbox
	set lboxMapped $w(wi).lbox3.listbox
    
	#${log}::debug textvar: [$files(tab1f1).listbox get [$files(tab1f1).listbox curselection]] > [$files(tab1f2).listbox get [$files(tab1f2).listbox curselection]]
	
	# Insert the two mapped headers into the "Mapped" listbox.
    $lboxMapped insert end "[$lboxOrig get [$lboxOrig curselection]] > [$lboxAvail get [$lboxAvail curselection]]"

	if {[string length [$lboxOrig curselection]] <= 1 } {
			set cSelection 0[$lboxOrig curselection]
			${log}::debug selection $cSelection
	} else {
		set cSelection [$lboxOrig curselection]
		${log}::debug selection $cSelection
	}
	
	# cSelection = index; header Name = 01_Address
	set header [join [join [split [list [$lboxAvail get [$lboxAvail curselection] ] ] ] ""]]
	${log}::debug header: $header
	
	set position([join [list $cSelection $header] _]) ""
	
	# Delete "un-assigned column" entry
	$lboxOrig itemconfigure [$lboxOrig curselection] -foreground lightgrey -selectforeground grey
	
	# Delete "available column" entry
	$lboxAvail itemconfigure [$lboxAvail curselection] -foreground lightgrey -selectforeground grey
	
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
	
	# setup the variables
	set lboxOrig $w(wi).lbox1.listbox
	set lboxAvail $w(wi).lbox2.listbox
	set lboxMapped $w(wi).lbox3.listbox
	
	set hdr [$lboxMapped get [$lboxMapped curselection]]
	set hdr [join [join [lrange [split $hdr >] 1 end]]]
	
	set hdr1 [lsearch -glob [array names position] *$hdr]
	set hdr1 [lindex [array names position] $hdr1]

	# Remove the header from the array, so we can re-assign if neccessary.
	unset position($hdr1) 
	$lboxMapped delete [$lboxMapped curselection]
	
	#parray position
	
	${log}::debug --END-- [info level 1]
} ;# ::unMapHeader


proc eAssistHelper::unHideColumns {args} {
    #****f* unHideColumns/eAssistHelper
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
	
	# detect if we are using the context menu or the listbox (args will be blank if we're using the listbox)
	if {$args == ""} {
		set col [lsearch $headerParent(headerList) [$files(tab3f1a).lbox1 get [$files(tab3f1a).lbox1 curselection]]]
	} else {
		set col $args
	}
	
	if {$col != ""} {
		$files(tab3f2).tbl columnconfigure $col -hide no
	} else {
		${log}::debug Add Columns did not receive a selection
	}
	
	# Delete the entry
	if {$args == ""} {
		$files(tab3f1a).lbox1 delete [$files(tab3f1a).lbox1 curselection]
	} else {
		$files(tab3f1a).lbox1 delete $args
	}
	
	
    ${log}::debug --END -- [info level 1]
} ;# eAssistHelper::unHideColumns


proc eAssistHelper::resetImportInterface {args} {
    #****f* resetImportInterface/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	eAssistHelper::resetImportInterface <1|2>
    #
    # SYNOPSIS
    #	Resets the import file interface.
	#	1 = Reset variables
	#	2 = Reset GUI
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
	
	
	if {$args == 1} {
	# Clear out the variables
		if {[array exists process] == 1} {
			unset process
		}
		
		if {[array exists position] == 1} {
			unset position
		}
	} else {
		# Completely reset GUI
		importFiles::eAssistGUI
	}
	
    ${log}::debug --END -- [info level 1]
} ;# eAssistHelper::resetImportInterface


proc eAssistHelper::insValuesToTableCells {tbl txtVar cells} {
    #****f* insValuesToTableCells/eAssistHelper
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
    #	eAssistHelper::insValuesToTableCells <tbl> <txtVar> <cell>
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	eAssistHelper::insertItems, IFMenus::tblPopup
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global log files txtVariable w
	
	if {$txtVar == ""} {
			set txtVar $txtVariable
	}
	
	foreach val $cells {
		${log}::debug Inserting $txtVar into $tbl - $val
		$tbl cellconfigure $val -text $txtVar
	}

	
} ;# eAssistHelper::insValuesToTableCells


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
