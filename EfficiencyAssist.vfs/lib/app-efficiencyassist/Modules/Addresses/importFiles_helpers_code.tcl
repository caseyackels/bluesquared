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
namespace eval ea::helper {}

proc ea::helper::updateTabText {txt} {
    #****f* updateTabText/ea::helper
    # CREATION DATE
    #   06/24/2015 (Wednesday Jun 24)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # USAGE
    #   ea::helper::updateTabText txt 
    #
    # FUNCTION
    #	Updates the text on the title level tab
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # EXAMPLE
    #   ea::helper::updateTabText "$titleName / $jobName"
    #
    # NOTES
    #   
    #  
    # SEE ALSO
    #   
    #   
    #***
    global log w

    $w(nbk) tab $w(nbk).f3 -text $txt

} ;# ea::helper::updateTabText


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
    global log w process position files

	
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
	
	${log}::debug configuring the bindings ...
	# Setup the bindings
    set bodyTag [$files(tab3f2).tbl bodytag]
    set labelTag [$files(tab3f2).tbl labeltag]
    set editWinTag [$files(tab3f2).tbl editwintag]
    
    # Begin bodyTag
    #bind $bodyTag <<Button3>> +[list tk_popup .tblMenu %X %Y]
	# Toggle between selecting a row, or a single cell
	bind $bodyTag <Button-1> {
		#${log}::debug Clicked on column %W %x %y
		#${log}::debug Column Name: [$files(tab3f2).tbl containingcolumn %x]
		set colName [$files(tab3f2).tbl columncget [$files(tab3f2).tbl containingcolumn %x] -name]
		#${log}::debug Column Name: $colName
		
		if {$colName eq "OrderNumber"} {
			$files(tab3f2).tbl configure -selecttype row
		} else {
			$files(tab3f2).tbl configure -selecttype cell
		}
	}
	
	bind $bodyTag <Double-1> {
		#${log}::debug Clicked on column %W %x %y
		#${log}::debug Column Name: [$files(tab3f2).tbl containingcolumn %x]
		set colName [$files(tab3f2).tbl columncget [$files(tab3f2).tbl containingcolumn %x] -name]
		#${log}::debug Column Name: $colName
		if {$colName eq "OrderNumber"} {
			eAssistHelper::shippingOrder $files(tab3f2).tbl -edit
			${log}::debug Current Row: [$files(tab3f2).tbl curselection]
		}
	}
   
	
	bind $bodyTag <Control-v> {
		#eAssistHelper::insValuesToTableCells -hotkey $files(tab3f2).tbl [clipboard get] [$files(tab3f2).tbl curcellselection]
		#${log}::debug CLIPBOARD _ CTRL+V t [split [clipboard get] \t]
		#${log}::debug CLIPBOARD _ CTRL+V n [split [clipboard get] \n]
		#${log}::debug CLIPBOARD _ CTRL+V _list [list [clipboard get]]
		#${log}::debug Pressed <Control-V>
	}
	
	bind $bodyTag <Control-c> {
		#IFMenus::copyCell $files(tab3f2).tbl hotkey
		#${log}::debug Pressed <Control-C>
	}
		# Initialize popup menus
		IFMenus::tblPopup $files(tab3f2).tbl browse .tblMenu
		IFMenus::createToggleMenu $files(tab3f2).tbl
    
    # Begin labelTag
    bind $labelTag <Button-3> +[list tk_popup .tblToggleColumns %X %Y]
    #bind $labelTag <Enter> {tooltip::tooltip $labelTag testing}

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
	
	set colName [$tbl columncget [lindex [join [split $cells ,]] 1] -name]
	
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
			# Create list that only has row numbers, then pass it to job::db::write once. Within job::db::write, we have a db statement using 'IN'.
			set row [lindex [split $val ,] 0]
			lappend rowList $row
			if {[string match -nocase *vers* $colName]} {
				lappend idList [ea::db::getRecord -shippingOrderID $row]
			} else {
				lappend idList '[ea::db::getRecord -addressID $row]'
				#lappend idList [ea::db::getRecord -shippingOrderID $row]
			}
			
		}
		
		#${log}::debug $tbl cellconfigure $cells -text $txtVar
		foreach cell $cells {
			$tbl cellconfigure $cell -text $txtVar
		}
		
		
		job::db::write $job(db,Name) {} $txtVar $tbl $cells $rowList $idList $colName
		
		# Clean up
		unset rowList
		unset idList
		
		#foreach val $cells {
		#	#${log}::debug Window Inserting $txtVar into $tbl - $val - $cells
		#	#${log}::debug Window MULTIPLE CELLS: $txtVar - cells: $cells
		#	#${log}::debug Selected Cells: [$tbl curcellselection]
		#	
		#	#if {[llength $txtVar] != 1} {}
		#	if {[llength $cells] != 1} {
		#		# Pasting multiple cells
		#		#foreach item $txtVar cell [$tbl curcellselection] {} ;# pasting into highlighted cells only
		#		foreach cell $cells {
		#			#${log}::debug Column Name: [$tbl columncget [lindex [split $cell ,] end] -name]
		#			#${log}::debug Window Multiple Inserting $txtVar - $cell
		#			#$tbl cellconfigure $cell -text $txtVar
		#			#set colName [$tbl columncget [lindex [split $cell ,] end] -name]
		#			job::db::write $job(db,Name) Addresses $txtVar $tbl $cell
		#		}
		#	} else {
		#		# Pasting a single cell
		#		#${log}::debug Window SINGLE CELL: $txtVar - $cells
		#		#$tbl cellconfigure $val -text $txtVar
		#		#$tbl cellconfigure $cells -text $txtVar
		#		job::db::write $job(db,Name) Addresses $txtVar $tbl $cells
		#	}
		#}
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
	
	set modify new
	foreach topic {TitleSaveFileLocation CustID CSRName Title Name Number JobSaveFileLocation} {
		# Check to make sure the required variables are filled out.
		if {$job($topic) eq ""} {
				incr i; set modify edit
				}
	}

	if {[info exists i]} {
		#${log}::debug I: $i - Modify: $modify
		#${log}::debug The Project has not yet been set up yet, would you like to do it now?
		set answer [tk_messageBox -message [mc "Oops, we're missing information about the job."] \
						-icon question -type yesno \
						-detail [mc "Would you like to go to the Project Setup window?"]]
				switch -- $answer {
						yes {
							customer::projSetup $modify
							}
						no {}
				}
		return 1
	}
} ;# eAssistHelper::checkProjSetup


proc ea::code::bm::writeShipment {{mode normal} args} {
    #****f* writeShipment/ea::code::bm
    # CREATION DATE
    #   11/02/2015 (Monday Nov 02)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # USAGE
    #   ea::code::bm::writeShipment <hidden|normal>
    #
    # FUNCTION
    #	<normal> (default) Writes new entries, or updates existing into the db tables: Addresses, Shipping Orders
    #   <hidden> Same as <normal> except passes the Hidden flag so it doesn't show up in the main list.
    #   
    #   
    # EXAMPLE
    #   ea::code::bm::writeShipment normal
    #
    # NOTES
    #   This uses the shipOrder() array, so before using this command make sure that the array contains the data that you want.
    #   
    #***
    global log shipOrder job title program
	
	switch -- $mode {
		normal	{ set hidden 0}
		hidden	{ set hidden 1}
		default	{${log}::debug [info level 0] Invalid parameter: $mode, should be: normal or hidden}
	}

#    set title(shipOrder_id) [$job(db,Name) eval "SELECT SysAddresses_ID FROM Addresses
#													INNER JOIN ShippingOrders on ShippingOrders.AddressID = Addresses.SysAddresses_ID
#													WHERE Company LIKE '%$shipOrder(Company)%'
#													AND ShippingOrders.Versions = $shipOrder(Versions)"]

	set program(id,Versions) [lindex [job::db::getVersion -name "$shipOrder(Versions)" -active 1] 0]
	
	# Set in PopulateShippingOrder
	#set title(SysAddresses_ID) [$job(db,Name) eval "SELECT SysAddresses_ID FROM Addresses
	#												WHERE Company LIKE '%$shipOrder(Company)%'"]
	
	set versExistsOnJob [$job(db,Name) eval "SELECT DISTINCT SysAddresses_ID FROM Addresses
												INNER JOIN ShippingOrders on ShippingOrders.AddressID = Addresses.SysAddresses_ID
												INNER JOIN Versions on Versions.Version_ID = ShippingOrders.Versions
													WHERE Company LIKE '%$shipOrder(Company)%'
													AND ShippingOrders.Versions = $program(id,Versions)"]			

    if {$title(SysAddresses_ID) ne ""} {
        # Entry was in the database, check to see if it exists as a shippingorder on the current job.
        set existsOnJob [$job(db,Name) eval "SELECT AddressID FROM ShippingOrders 
												INNER JOIN Addresses on Addresses.SysAddresses_ID = ShippingOrders.AddressID
												WHERE JobInformationID = '$job(Number)'
												AND AddressID = '$title(SysAddresses_ID)'
												AND Company LIKE '%$shipOrder(Company)%'"]
		
        ${log}::debug Entry Exists, listed in ShippingOrders? $existsOnJob
        
		
        if {$existsOnJob eq ""} {
            # Insert record into the shipping table
			${log}::debug Deleting old record ...
			$job(db,Name) eval "DELETE FROM ShippingOrders WHERE ShippingOrder_ID = $title(shipOrder_id)"
			${log}::debug Entry doesn't exist on the job, adding....
			ea::db::writeSingleAddressToDB $hidden ;# title(shipOrder_ID) is set in writeSingleAddressToDB
#            $job(db,Name) eval "INSERT INTO ShippingOrders (AddressID, JobInformationID, Hidden, Versions, Quantity, ShipVia)
#									VALUES ('$title(SysAddresses_ID)', '$job(Number)', $hidden, $program(id,Versions), $shipOrder(Quantity), '$shipOrder(ShipVia)')"
        
		} elseif {$versExistsOnJob eq ""} {
			${log}::debug Entry exists on the job, but not for the version.
			# New Version, insert record into the shipping table
            $job(db,Name) eval "INSERT INTO ShippingOrders (AddressID, JobInformationID, Hidden, Versions, Quantity, ShipVia)
									VALUES ('$title(SysAddresses_ID)', '$job(Number)', $hidden, $program(id,Versions), $shipOrder(Quantity), '$shipOrder(ShipVia)')"
		
		} else {
			# Exists on the Job, and Version exists ...
            # Address Entry already exists; update.
            ${log}::debug Address for $shipOrder(Company) exists, updating...
            ea::db::updateSingleAddressToDB $hidden
        }

    } else {
        # Doesn't exist; insert.
        ${log}::debug Address for $shipOrder(Company) doesn't exist, adding.
		
		${log}::debug Version ID: $shipOrder(Versions)
		# Convert to Name
		#set shipOrder(Versions) [lindex [job::db::getVersion -id "$shipOrder(Versions)" -active 1] 1]
		#${log}::debug Version Name: $shipOrder(Versions)
        
		ea::db::writeSingleAddressToDB $hidden
    }

} ;# ea::code::bm::writeShipment
