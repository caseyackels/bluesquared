# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 479 $
# $LastChangedBy: casey.ackels@gmail.com $
# $LastChangedDate: 2015-03-11 17:33:06 -0700 (Wed, 11 Mar 2015) $
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
    #${log}::debug --START -- [info level 1]
	
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
	#${log}::debug cSelection: $cSelection
	
	if {[string length $cSelection] <= 1} {
		set cSelection "0$cSelection"
	} else {
		${log}::notice eAssistHelper::autoMap cSelection has two digits: $cSelection
	}
	
	set position([join [list $cSelection $masterHeader] _]) ""
#	${log}::debug cSelection: $cSelection
#	${log}::debug masterHeader: $masterHeader
#	${log}::debug New Pos: [join [list [lsearch -nocase $process(Header) $masterHeader]] _]
#	
#	${log}::debug [lsort [array names position]]
#    ${log}::debug --END -- [info level 1]
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
   # ${log}::debug --START -- [info level 1]
	
	
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
	
    #${log}::debug --END -- [info level 1]
} ;# eAssistHelper::resetImportInterface


proc eAssistHelper::insValuesToTableCells {type tbl txtVar cells} {
    #****f* insValuesToTableCells/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Insert values set through the GUI into selected cells.
	#	Type can be; -menu or -window, -hotkey.
	#	Orient - V (Vertical) or H (Horizontal)
    #
    # SYNOPSIS
    #	eAssistHelper::insValuesToTableCells <type> <orient><tbl> <txtVar> <cell>
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	eAssistHelper::insertItems, IFMenus::tblPopup
    #
    # NOTES
    #$$
    # SEE ALSO
    #
    #***
    global log files txtVariable w copy job
	# 'Inserting {{Brent Olsen} {Janet Esfeld} {Noni Wiggin}} into .container.frame0.nbk.f3.nb.f1.f2.tbl - 0,0'
	
	
	if {$txtVar == ""} {
		if {[info exists txtVariable]} {
				${log}::debug txtVar doesn't exist, using $txtVariable
				set txtVar $txtVariable ;# txtVariable is set for the columns that have the dropdown widget.
		} else {
			set txtVar "" ;# We just want to clear the cells
		}
	}
	
	
	if {$type eq "-window"} {
		foreach val $cells {
			#${log}::debug Window Inserting $txtVar into $tbl - $val - $cells
			#${log}::debug Window MULTIPLE CELLS: $txtVar - cells: $cells
			#${log}::debug Selected Cells: [$tbl curcellselection]
			
			#if {[llength $txtVar] != 1} {}
			if {[llength $cells] != 1} {
				# Pasting multiple cells
				#foreach item $txtVar cell [$tbl curcellselection] {} ;# pasting into highlighted cells only
				foreach cell $cells {
					#${log}::debug Column Name: [$tbl columncget [lindex [split $cell ,] end] -name]
					#${log}::debug Window Multiple Inserting $txtVar - $cell
					#$tbl cellconfigure $cell -text $txtVar
					#set colName [$tbl columncget [lindex [split $cell ,] end] -name]
					job::db::write $job(db,Name) Addresses $txtVar $tbl $cell
				}
			} else {
				# Pasting a single cell
				#${log}::debug Window SINGLE CELL: $txtVar - $cells
				#$tbl cellconfigure $val -text $txtVar
				#$tbl cellconfigure $cells -text $txtVar
				job::db::write $job(db,Name) Addresses $txtVar $tbl $cells
			}
		}
	} elseif {$type eq "-menu"} {
		if {$copy(cellsCopied) >= 2} {
			# Pasting multiple cells
			${log}::debug Menu MULTIPLE CELLS: $txtVar - cells: $cells
			#foreach item $txtVar cell [$tbl curcellselection] {} ;# pasting into highlighted cells only
			set incrCells [lindex [split $cells ,] 0]
			set incrCol [lindex [split $cells ,] 1]
			
			foreach item $txtVar cell $cells {
				#${log}::debug Inserting $item - $incrCells,$incrCol
				#$tbl cellconfigure $incrCells,$incrCol -text $item
				job::db::write $job(db,Name) Addresses $item $tbl $incrCells,$incrCol
				
				if {$copy(orient) eq "Vertical"} {
					set incrCells [incr incrCells]
				} else {
					set incrCol [incr incrCol]
				}
				
				if {[info exists err]} {
					${log}::debug Error, ran out of cells: $cells
					unset err
				}			
			}
		} elseif {[llength $cells] > 1} {
			# We may copy one cell, but want to paste it multiple times
			#${log}::debug MULTIPLE CELLS were selected, we only have $txtVar to paste!
			foreach cell $cells {
				#${log}::debug $tbl cellconfigure $cell -text $txtVar
				#$tbl cellconfigure $cell -text $txtVar
				job::db::write $job(db,Name) Addresses $txtVar $tbl $cell
			}
			
		} else {
			# Pasting a single cell
			#${log}::debug Menu SINGLE CELL: $txtVar - $cells
			job::db::write $job(db,Name) Addresses $txtVar $tbl $cells
		}
	} elseif {$type eq "-hotkey"} {
			switch -- $copy(orient) {
				"Vertical"		{set txtVar [split [clipboard get] \n]}
				"Horizontal"	{set txtVar [split [clipboard get] \t]}
			}

			${log}::debug SELECTED cell to PASTE INTO $cells
			${log}::debug $txtVar [llength $txtVar]
			${log}::debug Orientation $copy(orient)
					
			if {$copy(cellsCopied) >= 2} {
				${log}::debug Cells Copied $copy(cellsCopied)
				${log}::debug Cells Selected: [llength $cells]
				# Find out if we copied multiple horizontal rows, and selected multiple vertical rows
				if {$copy(cellsCopied) > 1 && [llength $cells] > 1} {set copy(orient) HorzVert}
				set cell [lindex $cells 0] ;# compensate for when the user selects a range to paste into
				set incrRow [lindex [split $cell ,] 0]
				set incrCol [lindex [split $cell ,] 1]
				set origCol $incrCol
				
				if {$copy(method) != "hotkey"} {set txtVar [join $txtVar]}
				if {$copy(orient) != "HorzVert"} {
					foreach val $txtVar {
						${log}::debug single cell: $incrRow,$incrCol $val
						job::db::write $job(db,Name) Addresses $val $tbl $incrRow,$incrCol
						
						if {$copy(orient) eq "Vertical"} {
							incr incrRow
						} else {
							incr incrCol
						}
					}
				} else {
					${log}::debug We selected multiple cells Row and Column
					#${log}::debug Raw Data: [split [clipboard get] \n]
					foreach horzVal [split [clipboard get] \n] {
						foreach vertVal [split $horzVal \t] {
							# Moving vertically
							for {set x 0} {[llength $cells] > $x} {incr x} {
								# Moving horizontally
								foreach val $vertVal {
									${log}::debug Pasting Horz and Vert: [join $val] row: $incrRow, col: $incrCol
									#$tbl cellconfigure $incrRow,$incrCol -text $vertVal
									job::db::write $job(db,Name) Addresses [join $val] $tbl $incrRow,$incrCol
									incr incrCol
								}
								set incrCol $origCol ;# reset since we need to move down a row; but go back to the starting column
								incr incrRow
							}
						}
					}
				}
			} elseif {[llength $cells] > 1} {
				# We may copy one cell, but want to paste it multiple times
				${log}::debug Copied one cell, pasting into MULTIPLE CELLS
				foreach cell $cells {
					${log}::debug cell $cell -text $txtVar
					#$tbl cellconfigure $cell -text $txtVar
					job::db::write $job(db,Name) Addresses $txtVar $tbl $cell
				}
			} else {
				# Pasting a single cell
				${log}::debug SINGLE CELL: $txtVar - $cells
				job::db::write $job(db,Name) Addresses [join $txtVar] $tbl $cells
			}
	}
	# Apply the highlights ... Technically we should also prevent the user from entering too much data into each field.
	importFiles::highlightAllRecords $tbl
	
	# Get total copies
    #set job(TotalCopies) [ea::db::countQuantity $job(db,Name) Addresses]
	job::db::getTotalCopies

} ;# eAssistHelper::insValuesToTableCells


proc eAssistHelper::tmpPaste {} {
	global log files txtVariable w copy job
	
	switch -- $copy(orient) {
				"Vertical"		{set txtVar [split [clipboard get] \n]}
				"Horizontal"	{set txtVar [split [clipboard get] \t]}
			}

			${log}::debug SELECTED cell to PASTE INTO $cells
			${log}::debug $txtVar [llength $txtVar]
			
			set incrRow [lindex [split $cells ,] 0]
			set incrCol [lindex [split $cells ,] 1]
			set origCol $incrCol
			
			if {$copy(orient) != "HorzVert"} {
				foreach val $txtVar {
					#${log}::debug single cell: $incrRow,$incrCol $val
					
					#$tbl cellconfigure $incrRow,$incrCol -text $val
					job::db::write $job(db,Name) Addresses $val $tbl $incrRow,$incrCol
					
					if {$copy(orient) eq "Vertical"} {
						incr incrRow
					} else {
						incr incrCol
					}
				}
			} else {
				foreach horzVal [split [clipboard get] \n] {
					foreach vertVal [split $horzVal \t] {
						#${log}::debug Multiple Cells: $vertVal row: $incrRow, col: $incrCol
						#$tbl cellconfigure $incrRow,$incrCol -text $vertVal
						job::db::write $job(db,Name) Addresses $val $tbl $incrRow,$incrCol
						incr incrCol
					}
					set incrCol $origCol ;# reset since we need to move down a row; but go back to the starting column
					incr incrRow
				}
			}
}
	

#proc eAssistHelper::multiCells {} {
#    #****f* multiCells/eAssistHelper
#    # AUTHOR
#    #	Casey Ackels
#    #
#    # COPYRIGHT
#    #	(c) 2011-2014 Casey Ackels
#    #
#    # FUNCTION
#    #	Check to see if we are selected on multiple columns; returns 1 if we are, 0 if aren't
#    #
#    # SYNOPSIS
#    #
#    #
#    # CHILDREN
#    #	N/A
#    #
#    # PARENTS
#    #	
#    #
#    # NOTES
#    #
#    # SEE ALSO
#    #
#    #***
#    global log files
#    ${log}::debug --START-- [info level 1]
#	set curCol 1
#	
#    set cells [$files(tab3f2).tbl curcellselection]
#	
#	#if {[info exists curCol]} {unset curCol}
#	foreach val $cells {
#		# Initialize that variable
#		if {![info exists curCol]} {set curCol [$files(tab3f2).tbl columncget [lrange [split $val ,] end end] -name]}
#		
#		# This should get over written during our cycles
#		set curCol1 [$files(tab3f2).tbl columncget [lrange [split $val ,] end end] -name]
#		
#		# if we arent the same lets save the column name
#		if {[string match $curCol1 $curCol] ne 1} {lappend curCol [$files(tab3f2).tbl columncget [lrange [split $val ,] end end] -name]}
#
#	}
#	
#	if {[llength $curCol] eq 2} {return 1} else {return 0}
#	#${log}::debug We are selected on [llength $curCol] columns
#	
#    ${log}::debug --END-- [info level 1]
#} ;# eAssistHelper::multiCells


#proc eAssistHelper::fillCountry {} {
#    #****f* fillCountry/eAssistHelper
#    # CREATION DATE
#    #   10/30/2014 (Thursday Oct 30)
#    #
#    # AUTHOR
#    #	Casey Ackels
#    #
#    # COPYRIGHT
#    #	(c) 2014 Casey Ackels
#    #   
#    #
#    # SYNOPSIS
#    #   eAssistHelper::fillCountry  
#    #
#    # FUNCTION
#    #	Fills the country column with the correct country
#    #   
#    #   
#    # CHILDREN
#    #	N/A
#    #   
#    # PARENTS
#    #   
#    #   
#    # NOTES
#    #   
#    #   
#    # SEE ALSO
#    #   
#    #   
#    #***
#    global log
#
#    set rowCount [$files(tab3f2).tbl size]
#	set colCount [expr {[$files(tab3f2).tbl columncount] - 1}]
#	
#	# Find the country column
#	for {set x 0} {$colCount >= $x} {incr x} {
#		set colName [string tolower [$files(tab3f2).tbl columncget $x -name]]
#		switch -nocase $colName {
#			state		{set colStateIdx $x}
#			zip			{set colZipIdx $x}
#			country		{set colCountryIdx $x}
#		}
#	}
#	
#	for {set x 0} {$rowCount > $x} {incr x} {
#		# row,col
#		#${log}::debug Zip Codes: [$files(tab3f2).tbl cellcget $x,$colZipIdx -text]
#		#set zip3 [string range [$files(tab3f2).tbl cellcget $x,$colZipIdx -text] 0 2]
#		
#		# Ensure the state value matches the Zip
#		
#	}
#    
#} ;# eAssistHelper::fillCountry


proc eAssistHelper::checkProjSetup {} {
    #****f* checkProjSetup/eAssistHelper
    # CREATION DATE
    #   02/13/2015 (Friday Feb 13)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistHelper::checkProjSetup  
    #
    # FUNCTION
    #	Check's to make sure we have created a project, if we haven't. Warn the user, and allow them to launch Project Setup
	#	Returns 1, and launches the message. When using, check to see if we return 1, stop processing whatever proc called this one.
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
    #   
    #   
    #***
    global log job
	
	foreach topic {Title Name Number} {
		if {$job($topic) eq ""} {incr i}
	}

	if {[info exists i]} {
		${log}::debug The Project has not yet been set up yet, would you like to do it now?
		set answer [tk_messageBox -message [mc "Oops, we're missing information about the job."] \
						-icon question -type yesno \
						-detail [mc "Would you like to go to the Project Setup window?"]]
				switch -- $answer {
						yes {customer::projSetup}
						no {}
				}
		return 1
	}
} ;# eAssistHelper::checkProjSetup


proc eAssistHelper::initShipOrderArray {} {
    #****f* initShipOrderArray/eAssistHelper
    # CREATION DATE
    #   03/01/2015 (Sunday Mar 01)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistHelper::initShipOrderArray  
    #
    # FUNCTION
    #	Initializes shipOrder array; initially, or to clear it out
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
    #   
    #   
    #***
    global log headerParent shipOrder

    foreach name $headerParent(headerList) {
        set shipOrder($name) ""
    }
   
} ;# eAssistHelper::initShipOrderArray

proc eAssistHelper::loadShipOrderArray {db dbTbl id} {
    #****f* loadShipOrderArray/eAssistHelper
    # CREATION DATE
    #   03/02/2015 (Monday Mar 02)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistHelper::loadShipOrderArray db dbTable id 
    #
    # FUNCTION
    #	Populats the Ship Order array, based on the ID passed to the function (ID is Index in Database)
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
    #   
    #   
    #***
    global log shipOrder headerParent
	
	set columnNames [join $headerParent(headerList) ,]
	
	$db eval "SELECT * FROM $dbTbl WHERE OrderNumber='$id'" {
			foreach name [array name shipOrder] {
				set shipOrder($name) [subst $$name]
			}
	}

} ;# eAssistHelper::loadShipOrderArray

