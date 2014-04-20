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


proc eAssistHelper::addDistTypes_GUI {} {
    #****f* addDistTypes_GUI/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Add an address that wasn't in the source file
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
    global log process dist files
    ${log}::debug --START -- [info level 1]
    
	toplevel .d
    wm transient .d .
    wm title .d [mc ""]

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    wm geometry .d +${locX}+${locY}

    focus .d
	
	set w(dType) [ttk::frame .d.frame1]
	pack $w(dType) -expand yes -fill both -pady 5p -padx 5p
	
	ttk::label $w(dType).txt1 -text [mc "Attention"]
	ttk::entry $w(dType).entry1
	ttk::button $w(dType).btn1 -text [mc "Select an Address..."] -command {}
	
	ttk::label $w(dType).txt2 -text [mc "Company"]
	ttk::entry $w(dType).entry2
	
	ttk::label $w(dType).txt3 -text [mc "Address1/Address2"]
	ttk::entry $w(dType).entry3
	ttk::entry $w(dType).entry4
	
	ttk::label $w(dType).txt4 -text [mc "Address3"]
	ttk::entry $w(dType).entry5
	
	ttk::label $w(dType).txt5 -text [mc "City/State/Zip"]
	ttk::entry $w(dType).entry6
	ttk::entry $w(dType).entry7 -width 5
	ttk::entry $w(dType).entry8 -width 10
	
	ttk::label $w(dType).txt6 -text [mc "Country/Phone"]
	ttk::entry $w(dType).entry9
	ttk::entry $w(dType).entry10
	

	#ttk::label $w(dType).txt2 -text [mc "Insert this address for each version?"]

	ttk::button $w(dType).close -text [mc "Close"] -command {destroy .d}
	
	
	#----- Grid
	grid $w(dType).txt1 -column 0 -row 0 -sticky news
	grid $w(dType).entry1 -column 1 -row 0 -sticky news
	grid $w(dType).btn1 -column 2 -row 0 -sticky news
	
	grid $w(dType).txt2 -column 0 -row 1 -sticky news
	grid $w(dType).entry2 -column 1 -row 1 -sticky news
	
	grid $w(dType).txt3 -column 0 -row 2 -sticky news
	grid $w(dType).entry3 -column 1 -row 2 -sticky news
	grid $w(dType).entry4 -column 2 -row 2 -sticky news
	
	grid $w(dType).txt4 -column 0 -row 3 -sticky news
	grid $w(dType).entry5 -column 1 -row 3 -sticky news
	
	grid $w(dType).txt5 -column 0 -row 4 -sticky news
	grid $w(dType).entry6 -column 1 -row 4 -sticky news
	grid $w(dType).entry7 -column 2 -row 4 -sticky news
	grid $w(dType).entry8 -column 3 -row 4 -sticky news
	
	grid $w(dType).txt6 -column 0 -row 5 -sticky news
	grid $w(dType).entry9 -column 1 -row 5 -sticky news
	grid $w(dType).entry10 -column 2 -row 5 -sticky news
	
	#grid $w(dType).txt2 -column 0 -row 1 -sticky news
	grid $w(dType).close -column 3 -row 6 -sticky  news
	
    ${log}::debug --END -- [info level 1]
} ;# eAssistHelper::addDistTypes_GUI


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
    ${log}::debug --START-- [info level 1]
    
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

    focus $w(di)
	
	set f1 [ttk::frame $w(di).f1]
	pack $f1 -expand yes -fill both -pady 5p -padx 5p
	
	ttk::label $f1.txt0 -text [mc "This will fill all selected cells with the same value"]
	grid $f1.txt0 -column 0 -row 0 -rowspan 2 -sticky news -pady 5p -padx 5p
	
	set f2 [ttk::frame $w(di).f2]
	pack $f2 -expand yes -fill both -pady 5p -padx 5p
	

	if {[info exists curCol]} {unset curCol}
	#set newType ""
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
	


	# Guard against multiple cells being selected ...	
	if {[llength $curCol] == 1} {
		foreach header $curCol {
			incr x
			incr i
			${log}::debug $header / Widgets: [lrange $headerParams($header) 2 2]
			# Check to make sure that the column hasn't been hidden, if it is, lets stop the current loop.
			if {[$tbl columncget $header -hide] == 1} {continue}
			
			set wid [string tolower [lrange $headerParams($header) 2 2]]
			
			if {$wid eq "ttk::combobox"} {
				switch -glob -- [string tolower $header] {
					distributiontype	{
						ttk::label $f2.txt$i -text [mc "$header"]
						$wid $f2.$x$header -values $dist(distributionTypes) -textvariable txtVariable
						
						$f2.$x$header delete 0 end
						$f2.$x$header configure -state readonly
						
						grid $f2.txt$i -column 0 -row $x -sticky news -pady 5p -padx 5p
						grid $f2.$x$header -column 1 -row $x -sticky news -pady 5p -padx 5p
						
						#$btnBar.ok configure -command "eAssistHelper::insValuesToTableCells [list $tbl] $txtVariable $origCells; destroy .di"
						
					}
					carriermethod		{
						ttk::label $f2.txt$i -text [mc "$header"]
						$wid $f2.$x$header -values $carrierSetup(CarrierList) -textvariable txtVariable
						$f2.$x$header delete 0 end
						$f2.$x$header configure -state readonly
						
						grid $f2.txt$i -column 0 -row $x -sticky news -pady 5p -padx 5p
						grid $f2.$x$header -column 1 -row $x -sticky news -pady 5p -padx 5p
					}
					packagetype			{
						ttk::label $f2.txt$i -text [mc "$header"]
						$wid $f2.$x$header -values $packagingSetup(PackageType) -textvariable txtVariable
						$f2.$x$header delete 0 end
						$f2.$x$header configure -state readonly
						
						grid $f2.txt$i -column 0 -row $x -sticky news -pady 5p -padx 5p
						grid $f2.$x$header -column 1 -row $x -sticky news -pady 5p -padx 5p
					}
					containertype		{
						ttk::label $f2.txt$i -text [mc "$header"]
						$wid $f2.$x$header -values $packagingSetup(ContainerType) -textvariable txtVariable
						$f2.$x$header delete 0 end
						$f2.$x$header configure -state readonly
						
						grid $f2.txt$i -column 0 -row $x -sticky news -pady 5p -padx 5p
						grid $f2.$x$header -column 1 -row $x -sticky news -pady 5p -padx 5p
					}
					shippingclass		{
						ttk::label $f2.txt$i -text [mc "$header"]
						$wid $f2.$x$header -values $carrierSetup(ShippingClass) -textvariable txtVariable
						$f2.$x$header delete 0 end
						$f2.$x$header configure -state readonly
						
						grid $f2.txt$i -column 0 -row $x -sticky news -pady 5p -padx 5p
						grid $f2.$x$header -column 1 -row $x -sticky news -pady 5p -padx 5p
					}
					default			{
						${log}::notice Item not setup to use the ComboBox!}
				}
			} else {
						ttk::label $f2.txt$i -text [mc "$header"]
						# Create the widget specified in Setup for the column; typically will be ttk::entry
						$wid $f2.$x$header -textvariable txtVariable
				
						grid $f2.txt$i -column 0 -row $x -sticky news -pady 5p -padx 5p
						grid $f2.$x$header -column 1 -row $x -sticky news -pady 5p -padx 5p
			}
		}
	
	} else {
		ttk::label $f2.txt1 -text [mc "Please select cells in one column only"]
		grid $f2.txt1 -column 0 -row 0 -sticky news -pady 5p -padx 5p
		
		grid forget $f1
		$btnBar.ok configure -command {destroy .di}
	}
	
	# Create the buttons here, but we'll [grid] it at the bottom of this proc.
	#${log}::debug newType: $newType
	ttk::button $btnBar.ok		-text [mc "OK"] -command "[list eAssistHelper::insValuesToTableCells $tbl "" $origCells]; destroy .di" ;#"eAssistHelper::insValuesToTableCells [list $tbl] $txtVariable $origCells; destroy .di"
	#ttk::button $btnBar.ok		-text [mc "OK"] -command {${log}::debug [uplevel 1]}
	#ttk::button $btnBar.ok		-text [mc "OK"] -command [list puts "tbl: $tbl, newType: [$f2.$x$header get], origCells: $origCells"]
	ttk::button $btnBar.cancel	-text [mc "Cancel"] -command {destroy .di}

	# Look above for the initiation of the btnBar
	grid $btnBar.ok -column 0 -row 0 -sticky news -pady 5p -padx 5p
	grid $btnBar.cancel -column 1 -row 0 -sticky news -pady 5p -pady 5p

	#bind $f2.$x$header <<ComboboxSelected>> {
	#	set newType txtVariable
	#	eval $btnBar.ok configure -command "eAssistHelper::insValuesToTableCells [list $tbl] $txtVariable $origCells; destroy .di"
	#}

	
	
    ${log}::debug --END-- [info level 1]
} ;# eAssistHelper::insertItems


