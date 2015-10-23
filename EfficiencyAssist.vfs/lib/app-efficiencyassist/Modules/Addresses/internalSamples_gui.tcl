# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 10 24,2013
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 422 $
# $LastChangedBy: casey.ackels@gmail.com $
# $LastChangedDate: 2014-09-14 21:48:00 -0700 (Sun, 14 Sep 2014) $
#
########################################################################################

##
## - Overview
# Internal Samples GUI

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


proc ea::gui::samples::SampleGUI {} {
    #****f* SampleGUI/ea::gui::samples
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2015 Casey Ackels
    #
    # FUNCTION
    #	Add company samples, with the ability to do so per version, or for all.
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
    global log job process csmpls files dist packagingSetup
	
	# Ensure we have data in the table before creating this window
	if {[$files(tab3f2).tbl size] < 1} {return}
        
    set win .csmpls
    
	toplevel $win
    wm transient $win .
    wm title $win [mc "Internal Samples"]

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    #wm geometry .csmpls 625x400+${locX}+${locY}
	wm geometry $win 625x490+${locX}+${locY}
	
	# // Get the most updated list of the versions
	set process(versionList) [job::db::getVersionCount -type names -job $job(Number)]

    focus $win
	# --------------
	
	# Container frame for everything above the tablelist
	set f0 [ttk::frame .csmpls.frame0]
	pack $f0 -expand yes -fill both
	
	#
	# Frame, Quick Add
	#
	set f1 [ttk::labelframe $f0.f1 -text [mc "Sample Distribution"] -padding 10]
	grid $f1 -column 0 -row 0 -sticky news -pady 2p -padx 2p
	

	# Variable's must match names that are listed in the Table, or else this will break.
	grid [ttk::checkbutton $f1.ticket -text [mc "Ticket"] -variable csmpls(Ticket)] -column 0 -row 0 -pady 1p -padx 2p -sticky w
	grid [ttk::checkbutton $f1.csr -text [mc "CSR"] -variable csmpls(CSR)] -column 0 -row 1 -pady 1p -padx 2p -sticky w
	grid [ttk::checkbutton $f1.smplrm -text [mc "Sample Room"] -variable csmpls(SampleRoom)] -column 1 -row 0 -pady 1p -padx 2p -sticky w
	grid [ttk::checkbutton $f1.sales -text [mc "Sales"] -variable csmpls(Sales)] -column 1 -row 1 -pady 1p -padx 2p -sticky w

	#
	# Frame, Distribution Type, Package Type
	#
	set f2 [ttk::labelframe $f0.f2 -text [mc "Packaging"] -padding 10]
	grid $f2 -column 1 -row 0 -sticky news -pady 2p -padx 2p
	
	# Search for the "internal" samples. This is dangerous, and we should create a an option on the DistributionType Setup
	set csmpls(distributionType) [lindex $dist(distributionTypes) [lsearch $dist(distributionTypes) *02*]]
        grid [ttk::label $f2.txt1 -text [mc "Distribution Type"]] -column 0 -row 0 -pady 2p -padx 5p -sticky nes
        grid [ttk::combobox $f2.cbox1 -values $dist(distributionTypes) \
                                            -textvariable csmpls(distributionType) \
                                            -width 35 \
                                            -state readonly] -column 1 -row 0 -pady 2p -padx 5p -sticky news
	
	# Create a user defined default option for this. Same as above
	grid [ttk::label $f2.txt2 -text [mc "Package Type"]] -column 0 -row 1 -pady 2p -padx 5p -sticky nes
	grid [ttk::combobox $f2.cbox2 -values $packagingSetup(PackageType) \
										-textvariable csmpls(packageType) \
                                        -width 35 \
										-state readonly] -column 1 -row 1 -pady 2p -padx 5p -sticky news

    
    set f2a [ttk::frame $f0.f2a -padding 10]
    grid $f2a -column 0 -row 1 -sticky nes -pady 2p -padx 2p
    
    # Versions
    grid [ttk::label $f2a.txt0 -text [mc "Version"]] -column 0 -row 0 -pady 2p -padx 2p -sticky e
    grid [ttk::combobox $f2a.cbox0 -values $process(versionList) -width 35] -column 1 -row 0 -pady 2p -padx 2p -sticky ew
    grid [ttk::checkbutton $f2a.ckbtn0 -text [mc "Assign to all versions"]] -column 1 -row 1 -pady 2p -padx 2p -sticky w
    
    # Quantity and control button
    grid [ttk::label $f2a.txt1 -text [mc "Quantity"]] -column 0 -row 2 -pady 2p -padx 2p -sticky e
    grid [ttk::entry $f2a.addEntry -textvariable entryTxt] -column 1 -row 2 -pady 2p -padx 2p -sticky e
	grid [ttk::button $f2a.btn -text [mc "Add"] -command {}] -column 2 -row 2 -pady 2p -padx 2p
	#
	# Frame, Table
	#
	
	set f3 [ttk::frame $f0.f3 -padding 10]
	grid $f3 -column 0 -columnspan 2 -row 2 -sticky news -pady 2p -padx 2p
	
	set scrolly $f3.scrolly
	set scrollx $f3.scrollx
	grid [tablelist::tablelist $f3.tbl -columns {
												0   "..." center
												0	"Version"
												0	"Ticket"
												0	"CSR"
												0	"Sample Room"
												0	"Sales"
												} \
								-showlabels yes \
								-selectbackground lightblue \
								-selectforeground black \
								-stripebackground lightyellow \
								-exportselection yes \
								-showseparators yes \
								-fullseparators yes \
								-movablecolumns no \
								-movablerows no \
								-editselectedonly 1 \
                                -selectmode extended \
                                -selecttype cell \
								-editstartcommand {eAssistHelper::editStartSmpl} \
								-editendcommand {eAssistHelper::editEndSmpl} \
								-yscrollcommand [list $scrolly set] \
								-xscrollcommand [list $scrollx set]] -column 0 -row 0 -sticky news

	bind [$f3.tbl editwintag] <Return> "[bind TablelistEdit <Down>]; break"
	
	$f3.tbl columnconfigure 0 -name "count" \
										-showlinenumbers 1 \
										-labelalign center
	
	$f3.tbl columnconfigure 1 -name "Version" \
										-editable no \
										-editwindow ttk::entry \
										-labelalign center
	
	$f3.tbl columnconfigure 2 -name "Ticket" \
										-editable yes \
										-editwindow ttk::entry \
										-labelalign center
	
	$f3.tbl columnconfigure 3 -name "CSR" \
										-editable yes \
										-editwindow ttk::entry \
										-labelalign center
	
	$f3.tbl columnconfigure 4 -name "SampleRoom" \
										-editable yes \
										-editwindow ttk::entry \
										-labelalign center
	
	$f3.tbl columnconfigure 5 -name "Sales" \
										-editable yes \
										-editwindow ttk::entry \
										-labelalign center
	
	
	ttk::scrollbar $scrolly -orient v -command [list $f3.tbl yview]
	ttk::scrollbar $scrollx -orient h -command [list $f3.tbl xview]
		
	grid $scrolly -column 1 -row 0 -sticky ns
	grid $scrollx -column 0 -row 1 -sticky ew
		
	::autoscroll::autoscroll $scrolly ;# Enable the 'autoscrollbar'
	::autoscroll::autoscroll $scrollx ;# Enable the 'autoscrollbar'
	
	# Insert the versions; we aren't allowing them to be renamed here.
	foreach version $process(versionList) {
		if {$version != ""} {
			# Guard against a blank entry
			$f3.tbl insert end "{} [list $version]"
		}
	}
	

	#----- GRID
	grid columnconfigure $f3 $f3.tbl -weight 2
	grid rowconfigure $f3 $f3.tbl -weight 2

	#------ Button Bar
	set btnBar [ttk::frame .csmpls.btnbar]
	pack $btnBar -side bottom -pady 13p -padx 5p -anchor se -pady 8p -padx 5p

	ttk::button $btnBar.btn1 -text [mc "OK"] -command {}
	ttk::button $btnBar.btn2 -text [mc "Cancel"] -command {destroy .csmpls}
	
	grid $btnBar.btn1 -column 0 -row 0 -sticky nse -padx 8p
	grid $btnBar.btn2 -column 1 -row 0 -sticky nse

	##
	## Frame, Totals
	##
	#set w(csmpls.f5) [ttk::labelframe .csmpls.frame5 -text [mc "Totals"]]
	#pack $w(csmpls.f5) -expand yes -fill both -side left -pady 5p -padx 5p -side left -anchor w
	#
	#ttk::label $w(csmpls.f5).txt1 -text [mc "Ticket"]
	#ttk::label $w(csmpls.f5).txt2 -textvariable csmpls(TicketTotal)
	#ttk::label $w(csmpls.f5).txt3 -text [mc "CSR"]
	#ttk::label $w(csmpls.f5).txt4 -textvariable csmpls(CSRTotal)
	#ttk::label $w(csmpls.f5).txt5 -text [mc "Sample Room"]
	#ttk::label $w(csmpls.f5).txt6 -textvariable csmpls(SmplRoomTotal)
	#ttk::label $w(csmpls.f5).txt7 -text [mc "Sales"]
	#ttk::label $w(csmpls.f5).txt8 -textvariable csmpls(SalesTotal)
	#
	#grid $w(csmpls.f5).txt1 -column 0 -row 0 -padx 5p -sticky ew
	#grid $w(csmpls.f5).txt2 -column 1 -row 0 -padx 5p -sticky ew
	#grid $w(csmpls.f5).txt3 -column 0 -row 1 -padx 5p -sticky ew
	#grid $w(csmpls.f5).txt4 -column 1 -row 1 -padx 5p -sticky ew
	#grid $w(csmpls.f5).txt5 -column 0 -row 2 -padx 5p -sticky ew
	#grid $w(csmpls.f5).txt6 -column 1 -row 2 -padx 5p -sticky ew
	#grid $w(csmpls.f5).txt7 -column 0 -row 3 -padx 5p -sticky ew
	#grid $w(csmpls.f5).txt8 -column 1 -row 3 -padx 5p -sticky ew
	#
	##--------- Options
	#set w(csmpls.f6) [ttk::labelframe .csmpls.frame3 -text [mc "Options"]]
	#pack $w(csmpls.f6) -expand yes -fill both -side right -pady 5p -padx 5p -anchor e
	#
	#ttk::radiobutton $w(csmpls.f6).chck1 -text [mc "Use Company Address"] -state disabled
	#ttk::radiobutton $w(csmpls.f6).chck2 -text [mc "Consolidate into one Address"] -state disabled
	#
	#grid $w(csmpls.f6).chck1 -column 0 -row 0 -sticky nsw
	#grid $w(csmpls.f6).chck2 -column 0 -row 1 -sticky nsw

} ;# ea::gui::samples::SampleGUI