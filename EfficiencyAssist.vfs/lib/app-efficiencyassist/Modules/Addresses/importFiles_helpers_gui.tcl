# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 507 $
# $LastChangedBy: casey.ackels $
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

proc eAssistHelper::insertItems {tbl} {
    #****f* insertItems/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Opens a dialog and allows the user to input data that should be the same for each cell that they selected
    #	Will only work in [Extended] Mode for BatchMaker
    #
    # SYNOPSIS
    #	eAssistHelper::insertItems <tbl>
    #
    # CHILDREN
    #	eAssistHelper::insValuesToTable
    #
    # PARENTS
    #	IFMenus::tblPopup
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global log files headerParams dist carrierSetup packagingSetup txtVariable 
    #${log}::debug --START-- [info level 1]
    
    set w(di) .di
    if {[winfo exists $w(di)]} {destroy .di}
    if {[info exists txtVariable]} {unset txtVariable}
	
	    
    toplevel $w(di)
    wm transient $w(di) .
    wm title $w(di) [mc "Quick Insert"]

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    wm geometry $w(di) +${locX}+${locY}
	
	set txtVariable ""
	
	set f1 [ttk::frame $w(di).f1]
	pack $f1 -expand yes -fill both -pady 5p -padx 5p
	
	ttk::label $f1.txt0 -text [mc "This will fill all selected cells with the same value"]
	grid $f1.txt0 -column 0 -row 0 -rowspan 2 -sticky news -pady 5p -padx 5p
	
	set f2 [ttk::frame $w(di).f2]
	pack $f2 -expand yes -fill both -pady 5p -padx 5p
	

	if {[info exists curCol]} {unset curCol}
	set origCells [$tbl curcellselection]
	set cells [$tbl curcellselection]
	
	foreach val $cells {
		# Initialize that variable
		if {![info exists curCol]} {set curCol [$tbl columncget [lrange [split $val ,] end end] -name]}
		
		# This should get over written during our cycles
		set curCol1 [$tbl columncget [lrange [split $val ,] end end] -name]
		
		# if we arent the same lets save the column name
		if {[string match $curCol1 $curCol] ne 1} {lappend curCol [$tbl columncget [lrange [split $val ,] end end] -name]}

	}
	
	# Button Bar
	set btnBar [ttk::frame $w(di).btnBar]
	pack $btnBar -side right -pady 5p -padx 5p

	ttk::button $btnBar.ok		-text [mc "OK"] -command "[list eAssistHelper::insValuesToTableCells -window $tbl "" $origCells]; destroy .di"
	ttk::button $btnBar.cancel	-text [mc "Cancel"] -command {destroy .di}

	grid $btnBar.ok -column 0 -row 0 -sticky news -pady 5p -padx 5p
	grid $btnBar.cancel -column 1 -row 0 -sticky news -pady 5p -pady 5p

	#### END GUI
	
	# Guard against multiple cells being selected ...
	
	if {[llength $curCol] == 1} {
		foreach header $curCol {
			incr x
			incr i
			#${log}::debug Header: $header / Widgets: [lrange $headerParams($header) 2 2]
			# Check to make sure that the column hasn't been hidden, if it is, lets stop the current loop.
			if {[$tbl columncget $header -hide] == 1} {continue}
			
			#set wid [catch {[string tolower [lrange $headerParams($header) 2 2]]} err]
			#set wid [db eval "SELECT Widget FROM Headers WHERE InternalHeaderName='$header'"]
			set wid [db eval "SELECT widWidget from HeadersConfig WHERE dbColName = '$header'"]
			
			# default to ttk::entry
			#if {$wid eq ""} {set wid ttk::entry}
			
			if {$wid eq "ttk::combobox"} {
				switch -glob -- [string tolower $header] {
					distributiontype	{
						#${log}::debug DistributionType
						ttk::label $f2.txt$i -text [mc "$header"]
						$wid $f2.$x$header -values $dist(distributionTypes) -textvariable txtVariable -width 35
						
						$f2.$x$header delete 0 end
						$f2.$x$header configure -state readonly
						
						grid $f2.txt$i -column 0 -row $x -sticky news -pady 5p -padx 5p
						grid $f2.$x$header -column 1 -row $x -sticky news -pady 5p -padx 5p
						$btnBar.ok configure -command "[list eAssistHelper::insValuesToTableCells -window $tbl "" $origCells]; ea::code::bm::writeHiddenShipment $txtVariable; destroy .di"
						AutoComplete::typeahead $f2.$x$header
					}
					shipvia		{
						#${log}::debug CarrierMethod
						ttk::label $f2.txt$i -text [mc "$header"]
						$wid $f2.$x$header -values $carrierSetup(ShipViaName) -textvariable txtVariable -width 35
						$f2.$x$header delete 0 end
						$f2.$x$header configure -state readonly
						
						grid $f2.txt$i -column 0 -row $x -sticky news -pady 5p -padx 5p
						grid $f2.$x$header -column 1 -row $x -sticky news -pady 5p -padx 5p
						${log}::debug shipvia: $f2.$x$header
						AutoComplete::typeahead $f2.$x$header
					}
					packagetype			{
						#${log}::debug PackageType
						ttk::label $f2.txt$i -text [mc "$header"]
						$wid $f2.$x$header -values $packagingSetup(PackageType) -textvariable txtVariable -width 35
						$f2.$x$header delete 0 end
						$f2.$x$header configure -state readonly
						
						grid $f2.txt$i -column 0 -row $x -sticky news -pady 5p -padx 5p
						grid $f2.$x$header -column 1 -row $x -sticky news -pady 5p -padx 5p
						AutoComplete::typeahead $f2.$x$header
					}
					containertype		{
						#${log}::debug ContainerType
						ttk::label $f2.txt$i -text [mc "$header"]
						$wid $f2.$x$header -values $packagingSetup(ContainerType) -textvariable txtVariable -width 35
						$f2.$x$header delete 0 end
						$f2.$x$header configure -state readonly
						
						grid $f2.txt$i -column 0 -row $x -sticky news -pady 5p -padx 5p
						grid $f2.$x$header -column 1 -row $x -sticky news -pady 5p -padx 5p
						AutoComplete::typeahead $f2.$x$header
					}
					shippingclass		{
						#${log}::debug ShippingClass
						ttk::label $f2.txt$i -text [mc "$header"]
						$wid $f2.$x$header -values $carrierSetup(ShippingClass) -textvariable txtVariable -width 35
						$f2.$x$header delete 0 end
						$f2.$x$header configure -state readonly
						
						grid $f2.txt$i -column 0 -row $x -sticky news -pady 5p -padx 5p
						grid $f2.$x$header -column 1 -row $x -sticky news -pady 5p -padx 5p
						AutoComplete::typeahead $f2.$x$header
					}
					versions		{
						set values [job::db::getVersion -name -all -active 1]
                        #set cmd [list -textvariable shipOrder($dbColName) -width $widMaxWidth -values $values]
						ttk::label $f2.txt$i -text [mc "$header"]
						$wid $f2.$x$header -values $values -textvariable txtVariable -width 35
						
						$f2.$x$header delete 0 end
						$f2.$x$header configure -state readonly
						grid $f2.txt$i -column 0 -row $x -sticky news -pady 5p -padx 5p
						grid $f2.$x$header -column 1 -row $x -sticky news -pady 5p -padx 5p
						AutoComplete::typeahead $f2.$x$header
						#$btnBar.ok configure -command "[list eAssistHelper::insValuesToTableCells -window $tbl "" $origCells]; destroy .di"
					}
					default			{
						${log}::notice Item not setup to use the ComboBox, displaying a generic text widget
						ttk::entry $f2.$x$header -textvariable txtVariable -width 35
						
						grid $f2.$x$header -column 0 -row $x -sticky news -pady 5p -padx 5p
						}
				}
			} else {
						#${log}::debug General
						ttk::label $f2.txt$i -text [mc "$header"]
						# Create the widget specified in Setup for the column; typically will be ttk::entry
						#if {$wid eq ""} {set wid ttk::entry}
						$wid $f2.$x$header -textvariable txtVariable -width 35
				
						grid $f2.txt$i -column 0 -row $x -sticky news -pady 5p -padx 5p
						grid $f2.$x$header -column 1 -row $x -sticky news -pady 5p -padx 5p
			}
			focus $f2.$x$header
		}
	
	} else {
		ttk::label $f2.txt1 -text [mc "Please select cells in one column only"]
		grid $f2.txt1 -column 0 -row 0 -sticky news -pady 5p -padx 5p
		
		# Remove the regular text, and cancel button. Redirect the command of the OK button to just closing the window.
		grid forget $f1
		grid forget $btnBar.cancel
		$btnBar.ok configure -command {destroy .di}
	}

    #${log}::debug --END-- [info level 1]
} ;# eAssistHelper::insertItems




