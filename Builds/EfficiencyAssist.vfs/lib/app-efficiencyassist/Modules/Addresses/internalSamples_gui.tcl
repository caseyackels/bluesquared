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


proc eAssistHelper::addCompanySamples {} {
    #****f* addCompanySamples/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
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
    global log process w csmpls files dist packagingSetup
    ${log}::debug --START-- [info level 1]
	
	# Ensure we have data in the table before creating this window
	if {[$files(tab3f2).tbl size] <= 2} {return}
    
	toplevel .csmpls
    wm transient .csmpls .
    wm title .csmpls [mc "Internal Samples"]

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    #wm geometry .csmpls 625x400+${locX}+${locY}
	wm geometry .csmpls 625x490+${locX}+${locY}
	
	# // Get the most updated list of the versions
	#set process(versionList) [$files(tab3f2).tbl getcolumn Version]

    focus .csmpls
	# --------------
	
	# Container frame for everything above the tablelist
	set w(csmpls.f0) [ttk::frame .csmpls.frame0]
	pack $w(csmpls.f0) -expand yes -fill both
	
	#
	# Frame, Quick Add
	#
	set w(csmpls.f2) [ttk::labelframe .csmpls.frame0.f1 -text [mc "Quick Add"] -padding 10]
	grid $w(csmpls.f2) -column 0 -row 0 -sticky news -pady 5p -padx 5p
	

	# Variable's must match names that are listed in the Table, or else this will break.
	ttk::checkbutton $w(csmpls.f2).ticket	-text [mc "Ticket"] -variable csmpls(Ticket)
	ttk::checkbutton $w(csmpls.f2).csr		-text [mc "CSR"] -variable csmpls(CSR)
	ttk::checkbutton $w(csmpls.f2).smplrm	-text [mc "Sample Room"] -variable csmpls(SampleRoom)
	ttk::checkbutton $w(csmpls.f2).sales	-text [mc "Sales"] -variable csmpls(Sales)
	ttk::entry $w(csmpls.f2).addEntry		-textvariable entryTxt
	ttk::button $w(csmpls.f2).btn			-text [mc "Quick Add"] -command {eAssistHelper::quickAddSmpls $w(csmpls.f1).tbl $entryTxt}
	
	grid $w(csmpls.f2).ticket	-column 0 -row 0 -pady 1p -padx 2p -sticky w
	grid $w(csmpls.f2).csr		-column 0 -row 1 -pady 1p -padx 2p -sticky w
	grid $w(csmpls.f2).smplrm	-column 1 -row 0 -pady 1p -padx 2p -sticky w
	grid $w(csmpls.f2).sales	-column 1 -row 1 -pady 1p -padx 2p -sticky w
	grid $w(csmpls.f2).addEntry -column 0 -columnspan 2 -row 2 -pady 5p -padx 2p -sticky ew
	grid $w(csmpls.f2).btn		-column 2 -row 2 -pady 5p -padx 2p
	
	#
	# Frame, Distribution Type, Package Type
	#
	set w(csmpls.f1a) [ttk::labelframe .csmpls.frame0.f1a -text [mc "General"] -padding 10]
	grid $w(csmpls.f1a) -column 1 -row 0 -sticky news -pady 5p -padx 5p
	
	# we are search for the "internal" samples. This is dangerous, and we should create a User defined default.
		set csmpls(distributionType) [lindex $dist(distributionTypes) [lsearch $dist(distributionTypes) *02*]]
	ttk::label $w(csmpls.f1a).txt1 -text [mc "Distribution Type"]
	ttk::combobox $w(csmpls.f1a).cbox1 -values $dist(distributionTypes) \
										-textvariable csmpls(distributionType) \
										-state readonly
	
	# Create a user defined default option for this
	ttk::label $w(csmpls.f1a).txt2 -text [mc "Package Type"]
	ttk::combobox $w(csmpls.f1a).cbox2 -values $packagingSetup(PackageType) \
										-textvariable csmpls(packageType) \
										-state readonly
	
	grid $w(csmpls.f1a).txt1	-column 0 -row 0 -sticky nes -pady 2p -padx 5p
	grid $w(csmpls.f1a).cbox1	-column 1 -row 0 -sticky news -pady 2p -padx 5p
	grid $w(csmpls.f1a).txt2	-column 0 -row 1 -sticky nes -pady 2p -padx 5p
	grid $w(csmpls.f1a).cbox2	-column 1 -row 1 -sticky news -pady 2p -padx 5p
	
	#
	# Frame, Table
	#
	
	set w(csmpls.f1) [ttk::frame .csmpls.frame1]
	pack $w(csmpls.f1) -expand yes -fill both -pady 5p -padx 5p
	
	set scrolly $w(csmpls.f1).scrolly
	set scrollx $w(csmpls.f1).scrollx
	tablelist::tablelist $w(csmpls.f1).tbl -columns {
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
								-xscrollcommand [list $scrollx set]

	bind [$w(csmpls.f1).tbl editwintag] <Return> "[bind TablelistEdit <Down>]; break"
	
	$w(csmpls.f1).tbl columnconfigure 0 -name "count" \
										-showlinenumbers 1 \
										-labelalign center
	
	$w(csmpls.f1).tbl columnconfigure 1 -name "Version" \
										-editable no \
										-editwindow ttk::entry \
										-labelalign center
	
	$w(csmpls.f1).tbl columnconfigure 2 -name "Ticket" \
										-editable yes \
										-editwindow ttk::entry \
										-labelalign center
	
	$w(csmpls.f1).tbl columnconfigure 3 -name "CSR" \
										-editable yes \
										-editwindow ttk::entry \
										-labelalign center
	
	$w(csmpls.f1).tbl columnconfigure 4 -name "SampleRoom" \
										-editable yes \
										-editwindow ttk::entry \
										-labelalign center
	
	$w(csmpls.f1).tbl columnconfigure 5 -name "Sales" \
										-editable yes \
										-editwindow ttk::entry \
										-labelalign center
	
	
	ttk::scrollbar $scrolly -orient v -command [list $w(csmpls.f1).tbl yview]
	ttk::scrollbar $scrollx -orient h -command [list $w(csmpls.f1).tbl xview]
		
	grid $scrolly -column 1 -row 0 -sticky ns
	grid $scrollx -column 0 -row 1 -sticky ew
		
	::autoscroll::autoscroll $scrolly ;# Enable the 'autoscrollbar'
	::autoscroll::autoscroll $scrollx ;# Enable the 'autoscrollbar'
	
	# Insert the versions; we aren't allowing them to be renamed here either.
	foreach version $process(versionList) {
		if {$version != ""} {
			# Guard against a blank entry
			$w(csmpls.f1).tbl insert end "{} [list $version]"
		}
	}
	

	#----- GRID
	grid $w(csmpls.f1).tbl -column 0 -row 0 -sticky news -padx 5p -pady 5p
	grid columnconfigure $w(csmpls.f1) $w(csmpls.f1).tbl -weight 2
	grid rowconfigure $w(csmpls.f1) $w(csmpls.f1).tbl -weight 2

	#------ Button Bar
	set w(csmpls.btnbar) [ttk::frame .csmpls.btnbar]
	pack $w(csmpls.btnbar) -side bottom -pady 13p -padx 5p -anchor se -pady 8p -padx 5p

	ttk::button $w(csmpls.btnbar).btn1 -text [mc "OK"] -command {eAssistHelper::saveCSMPLS $w(csmpls.f1).tbl $files(tab3f2).tbl; destroy .csmpls}
	ttk::button $w(csmpls.btnbar).btn2 -text [mc "Cancel"] -command {destroy .csmpls}
	
	grid $w(csmpls.btnbar).btn1 -column 0 -row 0 -sticky nse -padx 8p
	grid $w(csmpls.btnbar).btn2 -column 1 -row 0 -sticky nse

	#
	# Frame, Totals
	#
	set w(csmpls.f5) [ttk::labelframe .csmpls.frame5 -text [mc "Totals"]]
	pack $w(csmpls.f5) -expand yes -fill both -side left -pady 5p -padx 5p -side left -anchor w
	
	ttk::label $w(csmpls.f5).txt1 -text [mc "Ticket"]
	ttk::label $w(csmpls.f5).txt2 -textvariable csmpls(TicketTotal)
	ttk::label $w(csmpls.f5).txt3 -text [mc "CSR"]
	ttk::label $w(csmpls.f5).txt4 -textvariable csmpls(CSRTotal)
	ttk::label $w(csmpls.f5).txt5 -text [mc "Sample Room"]
	ttk::label $w(csmpls.f5).txt6 -textvariable csmpls(SmplRoomTotal)
	ttk::label $w(csmpls.f5).txt7 -text [mc "Sales"]
	ttk::label $w(csmpls.f5).txt8 -textvariable csmpls(SalesTotal)
	
	grid $w(csmpls.f5).txt1 -column 0 -row 0 -padx 5p -sticky ew
	grid $w(csmpls.f5).txt2 -column 1 -row 0 -padx 5p -sticky ew
	grid $w(csmpls.f5).txt3 -column 0 -row 1 -padx 5p -sticky ew
	grid $w(csmpls.f5).txt4 -column 1 -row 1 -padx 5p -sticky ew
	grid $w(csmpls.f5).txt5 -column 0 -row 2 -padx 5p -sticky ew
	grid $w(csmpls.f5).txt6 -column 1 -row 2 -padx 5p -sticky ew
	grid $w(csmpls.f5).txt7 -column 0 -row 3 -padx 5p -sticky ew
	grid $w(csmpls.f5).txt8 -column 1 -row 3 -padx 5p -sticky ew
	
	#--------- Options
	set w(csmpls.f6) [ttk::labelframe .csmpls.frame3 -text [mc "Options"]]
	pack $w(csmpls.f6) -expand yes -fill both -side right -pady 5p -padx 5p -anchor e
	
	ttk::radiobutton $w(csmpls.f6).chck1 -text [mc "Use Company Address"] -state disabled
	ttk::radiobutton $w(csmpls.f6).chck2 -text [mc "Consolidate into one Address"] -state disabled
	
	grid $w(csmpls.f6).chck1 -column 0 -row 0 -sticky nsw
	grid $w(csmpls.f6).chck2 -column 0 -row 1 -sticky nsw


	
    ${log}::debug --END -- [info level 1]
} ;# ::addCompanySamples