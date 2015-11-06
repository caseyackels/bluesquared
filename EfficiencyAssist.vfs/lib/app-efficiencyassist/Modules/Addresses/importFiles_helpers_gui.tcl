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
					versions		{
						set values [job::db::getVersion -name -all -active 1]
                        #set cmd [list -textvariable shipOrder($dbColName) -width $widMaxWidth -values $values]
						ttk::label $f2.txt$i -text [mc "$header"]
						$wid $f2.$x$header -values $values -textvariable txtVariable -width 35
						
						$f2.$x$header delete 0 end
						$f2.$x$header configure -state readonly
						grid $f2.txt$i -column 0 -row $x -sticky news -pady 5p -padx 5p
						grid $f2.$x$header -column 1 -row $x -sticky news -pady 5p -padx 5p
						
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
	
	set revList [list [$job(db,Name) eval {SELECT Notes_ID FROM NOTES}]]
	
	ttk::label $f0.txt1 -text [mc "View Revision"]
	ttk::combobox $f0.cbox -width 5 \
							-state readonly \
							-postcommand "$f0.cbox configure -values $revList"

	
	#ttk::button $f0.btn -text [mc "Refresh"] -command [list job::db::readNotes $f0.cbox $w.f1.txt $w.f2.bottom.txt]
	
	grid $f0.txt1 -column 0 -row 0 -pady 2p -padx 2p
	grid $f0.cbox -column 1 -row 0 -pady 2p -padx 2p
	#grid $f0.btn -column 2 -row 0 -pady 2p -padx 2p

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
    set f2 [ttk::labelframe $w.f2 -text [mc "Internal Revision Notes"] -padding 10]
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
	
	ttk::button $btn.ok -text [mc "OK"] -command "[list job::db::insertNotes $f1.txt $f2_b.txt -job]; destroy $w"
	ttk::button $btn.cancel -text [mc "Cancel"] -command [list destroy $w]
	
	grid $btn.ok -column 0 -row 0 -padx 5p -sticky e
	grid $btn.cancel -column 1 -row 0 -sticky e
	
	##
	## Bindings
	##
	
	bind $f0.cbox <<ComboboxSelected>> [list job::db::readNotes $f0.cbox $w.f1.txt $w.f2.bottom.txt]
	
	## *****
	## Show the latest revision automatically
		
	if {$revList ne ""} {
		$f0.cbox set [lindex [join $revList] end]
		job::db::readNotes $f0.cbox $w.f1.txt $w.f2.bottom.txt
	}

    
} ;# eAssistHelper::editNotes


	#bind .di <Key> {puts "You pressed the key called \"%K\""}
bind . <Key> {
	puts "k: %k"
	puts "K: %K"
	
	switch -- %k {
		8	{
			# Backspace - BackSpace
		}
		9	{
			# Tab - Tab
		}
		13	{
			# Enter - Return (keypad)
		}
		16	{
			# Left Shift - Shift_L
		}
		17	{
			# Left Control - Control_L
			# Right Control - Control_R
		}
		18	{
			# Left Alt - Alt_L
			# Right Alt - Alt_R
		}
		20	{
			# Caps Lock - Caps_Lock
		}
		27	{
			# Esc - Escape
		}
		32	{
			# Space
			append word " "
		}
		33	{
			# Page Up - Prior
		}
		34	{
			# Page Down - Next
		}
		35	{
			# End
		}
		36	{
			# Home
		}
		37	{
			# Left Arrow - Left
		}
		38	{
			# Up Arrow - Up
		}
		39	{
			# Right Arrow - Right
		}
		40	{
			# Down Arrow - Down
		}
		45	{
			# Insert
		}
		46	{
			# Delete
		}
		49	{
			# Exclamation - exclam
			# Number 1 - 1
			if {%K == 1} {set x 1} else {set x !}
			append word $x
		}
		50	{
			# @ - at
			# Number 2 - 2
			if {%K == 2} {set x 2} else {set x @}
			append word $x
		}
		51	{
			# # - numbersign
			# Number 3 - 3
			append word $x
		}
		52	{
			# $ - dollar
			# Number 4 - 4
			if {%K == 4} {set x 4} else {set x $}
			append word $x
		}
		53	{
			# % - percent
			# Number 5 - 5
			if {%K == 5} {set x 5} else {set x \%}
			append word $x
		}
		54	{
			# (shift+6) - asciicircum
			# Number 6 - 6
			if {%K == 6} {set x 6} else {set x \^}
			append word $x
		}
		55	{
			# & - ampersand
			# Number 7 - 7
			if {%K == 7} {set x 7} else {set x &}
			append word $x
		}
		56	{
			# * - asterisk
			# Number 8 - 8
			if {%K == 8} {set x 8} else {set x *}
			append word $x
		}
		57	{
			#  parenleft
			# Number 9 - 9
			#if {%K == 9} {set x 9} else {set x }
			append word $x
		}
		58 {
			#  parenright
			# Number 0 - 0
			#if {%K == 0} {set x 0} else {set x }
			append word $x
		}
		96	{
			# (keypad) 0
			append word 0
		}
		97	{
			# (keypad) 1
			append word 1
		}
		98	{
			# (keypad) 2
			append word 2
		}
		99	{
			# (keypad) 3
			append word 3
		}
		100	{
			# (keypad) 4
			append word 4
		}
		101	{
			# (keypad 5)
			append word 5
		}
		102	{
			# (keypad 6)
			append word 6
		}
		103	{
			# (keypad) 7
			append word 7
		}
		104	{
			# (keypad) 8
			append word 8
		}
		105	{
			# (keypad) 9
			append word 9
		}
		106	{
			# * - asterisk (keypad)
		}
		107	{
			# + - plus (keypad)
		}
		109	{
			# - - minus (keypad)
		}
		110	{
			# . - period (keypad)
			append word .
		}
		111	{
			# / - slash (keypad)
		}
		187	{
			# + - plus
			# = - equal
		}
		189	{
			# _ - underscore
			# (-) - minus
			if {"%K eq "minus"} {set x -} else {set x _}
			append word $x
		}
		112	{
			# F1
		}
		113 {
			# F2
		}
		114 {
			# F3
		}
		115 {
			# F4
		}
		116	{
			# F5
		}
		117	{
			# F6
		}
		118	{
			# F7
		}
		119	{
			# F8
		}
		120	{
			# F9
		}
		121	{
			# F10
		}
		122	{
			# F11
		}
		123	{
			# F12
		}
		145	{
			# Scroll Lock - Scroll_Lock
		}
		186	{
			# : - colon
			# - semicolon
		}
		188	{
			# , - comma
			# < - less
			if {"%K" eq "comma"} {set x ,} else {set x <}
			append word $x
		}
		190	{
			# . - period
			# > - greater
			if {"%K" eq "period"} {set x .} else {set x >}
			append word $x
		}
		191	{
			# ? - question
			#  - slash
		}
		192	{
			# Quote Left  - quoteleft
			# ~ - asciitilde
		}
		219	{
			#   - braceleft
			#  - bracketleft
		}
		220	{
			# | - bar
			# 
		}
		221	{
			#  - braceright
			#  - bracketright
		}
		222	{
			# Double Quote - quotedbl
			# Single Quote - quoteright
		}
		default {
			append word %K
		}
	}
	puts $word
}

#bind . <FocusOut> {
#	unset word
#}