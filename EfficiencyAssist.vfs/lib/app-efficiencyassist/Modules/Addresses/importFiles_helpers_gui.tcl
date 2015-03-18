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

#
#proc eAssistHelper::addDistTypes_GUI {} {
#    #****f* addDistTypes_GUI/eAssistHelper
#    # AUTHOR
#    #	Casey Ackels
#    #
#    # COPYRIGHT
#    #	(c) 2011-2013 Casey Ackels
#    #
#    # FUNCTION
#    #	Add an address that wasn't in the source file
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
#    global log process dist files
#    
#	toplevel .d
#    wm transient .d .
#    wm title .d [mc "Add Destination"]
#
#    # Put the window in the center of the parent window
#    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
#    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
#    wm geometry .d +${locX}+${locY}
#
#	
#	set w(dType) [ttk::frame .d.frame1]
#	pack $w(dType) -expand yes -fill both -pady 5p -padx 5p
#	
#	ttk::label $w(dType).txt1 -text [mc "Attention"]
#	ttk::entry $w(dType).entry1
#	ttk::button $w(dType).btn1 -text [mc "Select an Address..."] -command {} -state disabled
#	focu $w(dType).entry1
#	
#	ttk::label $w(dType).txt2 -text [mc "Company"]
#	ttk::entry $w(dType).entry2
#	
#	ttk::label $w(dType).txt3 -text [mc "Address1/Address2"]
#	ttk::entry $w(dType).entry3
#	ttk::entry $w(dType).entry4
#	
#	ttk::label $w(dType).txt4 -text [mc "Address3"]
#	ttk::entry $w(dType).entry5
#	
#	ttk::label $w(dType).txt5 -text [mc "City/State/Zip"]
#	ttk::entry $w(dType).entry6
#	ttk::entry $w(dType).entry7 -width 5
#	ttk::entry $w(dType).entry8 -width 10
#	
#	ttk::label $w(dType).txt6 -text [mc "Country/Phone"]
#	ttk::entry $w(dType).entry9
#	ttk::entry $w(dType).entry10
#	
#
#	#ttk::label $w(dType).txt2 -text [mc "Insert this address for each version?"]
#
#	ttk::button $w(dType).close -text [mc "Close"] -command {destroy .d}
#	
#	
#	#----- Grid
#	grid $w(dType).txt1 -column 0 -row 0 -sticky news
#	grid $w(dType).entry1 -column 1 -row 0 -sticky news
#	grid $w(dType).btn1 -column 2 -row 0 -sticky news
#	
#	grid $w(dType).txt2 -column 0 -row 1 -sticky news
#	grid $w(dType).entry2 -column 1 -row 1 -sticky news
#	
#	grid $w(dType).txt3 -column 0 -row 2 -sticky news
#	grid $w(dType).entry3 -column 1 -row 2 -sticky news
#	grid $w(dType).entry4 -column 2 -row 2 -sticky news
#	
#	grid $w(dType).txt4 -column 0 -row 3 -sticky news
#	grid $w(dType).entry5 -column 1 -row 3 -sticky news
#	
#	grid $w(dType).txt5 -column 0 -row 4 -sticky news
#	grid $w(dType).entry6 -column 1 -row 4 -sticky news
#	grid $w(dType).entry7 -column 2 -row 4 -sticky news
#	grid $w(dType).entry8 -column 3 -row 4 -sticky news
#	
#	grid $w(dType).txt6 -column 0 -row 5 -sticky news
#	grid $w(dType).entry9 -column 1 -row 5 -sticky news
#	grid $w(dType).entry10 -column 2 -row 5 -sticky news
#	
#	#grid $w(dType).txt2 -column 0 -row 1 -sticky news
#	grid $w(dType).close -column 3 -row 6 -sticky  news
#	
#} ;# eAssistHelper::addDistTypes_GUI


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

	# END GUI
	
	# Guard against multiple cells being selected ...
	# Var to use to get versions: $process(versionList)
	
	if {[llength $curCol] == 1} {
		foreach header $curCol {
			incr x
			incr i
			#${log}::debug Header: $header / Widgets: [lrange $headerParams($header) 2 2]
			# Check to make sure that the column hasn't been hidden, if it is, lets stop the current loop.
			if {[$tbl columncget $header -hide] == 1} {continue}
			
			#set wid [catch {[string tolower [lrange $headerParams($header) 2 2]]} err]
			set wid [db eval "SELECT Widget FROM Headers WHERE InternalHeaderName='$header'"]
			
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
						#$btnBar.ok configure -command "eAssistHelper::insValuesToTableCells [list $tbl] $txtVariable $origCells; destroy .di"
						
					}
					shipvia		{
						#${log}::debug CarrierMethod
						ttk::label $f2.txt$i -text [mc "$header"]
						$wid $f2.$x$header -values $carrierSetup(ShipViaName) -textvariable txtVariable -width 35
						$f2.$x$header delete 0 end
						$f2.$x$header configure -state readonly
						
						grid $f2.txt$i -column 0 -row $x -sticky news -pady 5p -padx 5p
						grid $f2.$x$header -column 1 -row $x -sticky news -pady 5p -padx 5p
					}
					packagetype			{
						#${log}::debug PackageType
						ttk::label $f2.txt$i -text [mc "$header"]
						$wid $f2.$x$header -values $packagingSetup(PackageType) -textvariable txtVariable -width 35
						$f2.$x$header delete 0 end
						$f2.$x$header configure -state readonly
						
						grid $f2.txt$i -column 0 -row $x -sticky news -pady 5p -padx 5p
						grid $f2.$x$header -column 1 -row $x -sticky news -pady 5p -padx 5p
					}
					containertype		{
						#${log}::debug ContainerType
						ttk::label $f2.txt$i -text [mc "$header"]
						$wid $f2.$x$header -values $packagingSetup(ContainerType) -textvariable txtVariable -width 35
						$f2.$x$header delete 0 end
						$f2.$x$header configure -state readonly
						
						grid $f2.txt$i -column 0 -row $x -sticky news -pady 5p -padx 5p
						grid $f2.$x$header -column 1 -row $x -sticky news -pady 5p -padx 5p
					}
					shippingclass		{
						#${log}::debug ShippingClass
						ttk::label $f2.txt$i -text [mc "$header"]
						$wid $f2.$x$header -values $carrierSetup(ShippingClass) -textvariable txtVariable -width 35
						$f2.$x$header delete 0 end
						$f2.$x$header configure -state readonly
						
						grid $f2.txt$i -column 0 -row $x -sticky news -pady 5p -padx 5p
						grid $f2.$x$header -column 1 -row $x -sticky news -pady 5p -padx 5p
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


proc eAssistHelper::importProgBar {args} {
    #****f* importProgBar/eAssistHelper
    # CREATION DATE
    #   11/18/2014 (Tuesday Nov 18)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistHelper::importProgBar args 
    #
    # FUNCTION
    #	Displays a progress bar when importing a file.
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # NOTES
	#	Set length: $::gwin(importpbar) configure -maximum <value>
	# 	Update: $::gwin(importpbar) step <value>
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log

	set w .pb
    if {[winfo exists w]} {destroy $w}
	
	if {$args eq "destroy"} {destroy $w; return}

    toplevel $w
    wm transient $w .
    wm title $w [mc "Progress Bar"]
    
    set locX [expr {[winfo screenwidth . ] / 4 + [winfo x .]}]
    set locY [expr {[winfo screenheight . ] / 5 + [winfo y .]}]
    wm geometry $w 150x75+${locX}+${locY}

    set f1 [ttk::labelframe $w.f1 -text [mc "Importing Records"] -padding 10]
    pack $f1 -fill both -expand yes -padx 5p -pady 5p
	
    set ::gwin(importpbar) [ttk::progressbar $f1.pbar]
	
	grid $::gwin(importpbar) -column 0 -row 0 -sticky news

    
} ;# eAssistHelper::importProgBar


proc eAssistHelper::editNotes {} {
    #****f* editNotes/eAssistHelper
    # CREATION DATE
    #   03/11/2015 (Wednesday Mar 11)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistHelper::editNotes  
    #
    # FUNCTION
    #	Displays the Notes window for the job level
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
    global log job hist user
	# Do not launch if a job has not been loaded
	if {![info exists job(db,Name)]} {${log}::debug The job database has not been loaded yet; return}

	set w .notes
    eAssist_Global::detectWin $w -k
	
	# Setup the history array
	set hist(log,User) $user(id)
	set hist(log,Date) [ea::date::getTodaysDate]
	
	toplevel $w
    wm transient $w .
    wm title $w [mc "Job Level Notes"]
    
    set locX [expr {[winfo screenwidth . ] / 4 + [winfo x .]}]
    set locY [expr {[winfo screenheight . ] / 5 + [winfo y .]}]
    wm geometry $w +${locX}+${locY}

	## Revision Frame
	##
    set f0 [ttk::frame $w.f0]
    pack $f0 -fill both -padx 5p
	
	ttk::label $f0.txt1 -text [mc "View Revision"]
	ttk::combobox $f0.cbox -width 5 \
							-values [$job(db,Name) eval "SELECT Notes_ID FROM NOTES"] \
							-state readonly
							#-postcommand 
	ttk::button $f0.btn -text [mc "Refresh"] -command [list job::db::readNotes $f0.cbox $w.f1.txt $w.f2.bottom.txt]
	
	grid $f0.txt1 -column 0 -row 0 -pady 2p -padx 2p
	grid $f0.cbox -column 1 -row 0 -pady 2p -padx 2p
	grid $f0.btn -column 2 -row 0 -pady 2p -padx 2p

	## Job Notes Frame
	##
    set f1 [ttk::labelframe $w.f1 -text [mc "Job Notes"] -padding 10]
    pack $f1 -fill both -expand yes -padx 5p -pady 5p -anchor n
	
	text $f1.txt -height 10 \
				-wrap word \
				-yscrollcommand [list $f1.scrolly set]
	
	ttk::scrollbar $f1.scrolly -orient v -command [list $f1.txt yview]
	
	grid $f1.txt -column 0 -row 0 -sticky news
	grid $f1.scrolly -column 1 -row 0 -sticky nse
	
	grid columnconfigure $f1 0 -weight 2
	grid rowconfigure $f1 0 -weight 2
	
	::autoscroll::autoscroll $f1.scrolly ;# Enable the 'autoscrollbar'
	
	## Log notes Frame
	##
    set f2 [ttk::labelframe $w.f2 -text [mc "Log Notes"] -padding 10]
    pack $f2 -fill both -expand yes -padx 5p -pady 5p -anchor n
	
	set f2_a [ttk::frame $f2.top]
	pack $f2_a -fill both
	
	ttk::label $f2_a.txt1a -text [mc User]
	ttk::label $f2_a.txt1b -textvariable hist(log,User)
	ttk::label $f2_a.txt2a -text [mc Date/Time]
	ttk::label $f2_a.txt2b -textvariable hist(log,Date)
	ttk::label $f2_a.txt2c -textvariable hist(log,Time)
	
	grid $f2_a.txt1a -column 0 -row 0 -sticky e -padx 2p
	grid $f2_a.txt1b -column 1 -row 0 -sticky w
	grid $f2_a.txt2a -column 0 -row 1 -sticky e -padx 2p
	grid $f2_a.txt2b -column 1 -row 1 -sticky w
	grid $f2_a.txt2c -column 2 -row 1 -sticky w
	
	set f2_b [ttk::frame $f2.bottom]
	pack $f2_b -fill both -expand yes
	
	text $f2_b.txt -height 5 \
					-wrap word \
					-yscrollcommand [list $f2_b.scrolly set]
	
	ttk::scrollbar $f2_b.scrolly -orient v -command [list $f2_b.txt yview]

	grid $f2_b.txt -column 0 -row 0 -sticky news
	grid $f2_b.scrolly -column 1 -row 0 -sticky nse
	
	grid columnconfigure $f2_b 0 -weight 2
	grid rowconfigure $f2_b 0 -weight 2
	
	::autoscroll::autoscroll $f2_b.scrolly ;# Enable the 'autoscrollbar'
	
	## Button Frame
	##
	set btn [ttk::frame $w.btns -padding 10]
	pack $btn -padx 5p -pady 5p -anchor se
	
	ttk::button $btn.ok -text [mc "OK"] -command [list job::db::insertNotes $f1.txt $f2_b.txt]
	ttk::button $btn.cancel -text [mc "Cancel"] -command [list destroy $w]
	
	grid $btn.ok -column 0 -row 0 -padx 5p -sticky e
	grid $btn.cancel -column 1 -row 0 -sticky e

    
} ;# eAssistHelper::editNotes
