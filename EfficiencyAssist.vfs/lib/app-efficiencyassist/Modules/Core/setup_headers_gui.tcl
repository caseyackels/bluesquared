# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 10 11,2013
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 444 $
# $LastChangedBy: casey.ackels@gmail.com $
# $LastChangedDate: 2015-02-11 08:12:38 -0800 (Wed, 11 Feb 2015) $
#
########################################################################################

##
## - Overview
# Overview

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


proc eAssistSetup::addressHeaders_GUI {} {
    #****f* addressHeadersI/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Batch Addresses - Add/Edit header mappings, to headers that we have in the system already.
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
    global log G_setupFrame currentModule program headerParams headerParent
    global GUI w filters
    #variable GUI
    
    #set currentModule addressHeaders
    eAssist_Global::resetSetupFrames ;# Reset all frames so we start clean
    
    # Initialize the filters array
    eAssist_Global::launchFilters
    
    ##
    ## Parent Frame
    ##

    set w(hdr_frame1) [ttk::frame $G_setupFrame.frame1]
    pack $w(hdr_frame1) -expand yes -fill both -ipadx 5p -ipady 5p
    

    #
    #------- Frame 1a
    #
    set w(hdr_frame1a) [ttk::labelframe $w(hdr_frame1).a -text [mc "Master Header"] -padding 10]
    pack $w(hdr_frame1a) -expand yes -fill both ;#-ipadx 5p -ipady 5p
	
	# Sub Frame - 1b
		set w(hdr_frame1b) [ttk::frame $w(hdr_frame1a).b]
		grid $w(hdr_frame1b) -column 0 -row 0 -sticky nsw
	
		ttk::button $w(hdr_frame1b).btn1 -text [mc "Add"] -command {eAssistSetup::Headers add}
		ttk::button $w(hdr_frame1b).btn2 -text [mc "Edit"] -command {eAssistSetup::Headers edit $w(hdr_frame1a).listbox}
		ttk::button $w(hdr_frame1b).btn3 -text [mc "Delete"] -command {ea::db::delMasterHeader $w(hdr_frame1a).listbox}
		
		grid $w(hdr_frame1b).btn1 -column 0 -row 0 -padx 2p -pady 0p -sticky new
		grid $w(hdr_frame1b).btn2 -column 1 -row 0 -padx 2p -pady 0p -sticky new
		grid $w(hdr_frame1b).btn3 -column 2 -row 0 -padx 2p -pady 0p -sticky new
    
    tablelist::tablelist $w(hdr_frame1a).listbox -columns {
                                                    0   "..." center
													0	"Header ID" center
                                                    0	"Internal Header"
                                                    0	"Output Header" 
                                                    0 	"Max String Length" center
													0	"Column Width" center
                                                    0	"Highlight"
													0	"Widget"
													0	"Display Order" center
													0	"Required" center
													0	"Always Display" center
													0	"Resize" center
                                                    } \
                                        -showlabels yes \
                                        -height 10 \
                                        -selectbackground yellow \
                                        -selectforeground black \
                                        -stripebackground lightblue \
                                        -exportselection yes \
                                        -showseparators yes \
                                        -fullseparators yes \
                                        -movablecolumns yes \
                                        -movablerows yes \
                                        -editselectedonly 1 \
                                        -yscrollcommand [list $w(hdr_frame1a).scrolly set] \
                                        -xscrollcommand [list $w(hdr_frame1a).scrollx set] \
                                        -editstartcommand {eAssistSetup::startCmdHdr} \
                                        -editendcommand {eAssistSetup::endCmdHdr}
    
        $w(hdr_frame1a).listbox columnconfigure 0 -name "OrderNumber" \
                                            -showlinenumbers 1 \
                                            -labelalign center
		
        $w(hdr_frame1a).listbox columnconfigure 1 -name "Header_ID" \
                                            -labelalign center \
											-hide yes
    
        $w(hdr_frame1a).listbox columnconfigure 2 -name "InternalHeaderName" \
                                            -labelalign center
        
        $w(hdr_frame1a).listbox columnconfigure 3 -name "OutputHeaderName" \
                                            -labelalign center
        
        $w(hdr_frame1a).listbox columnconfigure 4 -name "HeaderMaxLength" \
                                            -labelalign center
        
        $w(hdr_frame1a).listbox columnconfigure 5 -name "DefaultWidth" \
                                            -labelalign center
		
        $w(hdr_frame1a).listbox columnconfigure 6 -name "Highlight" \
                                            -labelalign center
											
        $w(hdr_frame1a).listbox columnconfigure 7 -name "Widget" \
                                            -labelalign center
                                            
		$w(hdr_frame1a).listbox columnconfigure 8 -name "Required" \
											-labelalign center

		$w(hdr_frame1a).listbox columnconfigure 9 -name "DisplayOrder" \
                                            -labelalign center
		
	    $w(hdr_frame1a).listbox columnconfigure 10 -name "AlwaysDisplay" \
                                            -labelalign center
		
	    $w(hdr_frame1a).listbox columnconfigure 11 -name "ResizeColumn" \
                                            -labelalign center
		


    ea::db::updateHeaderWidTbl $w(hdr_frame1a).listbox Headers "Header_ID InternalHeaderName OutputHeaderName HeaderMaxLength DefaultWidth Highlight Widget DisplayOrder Required AlwaysDisplay ResizeColumn"
    
    
    ttk::scrollbar $w(hdr_frame1a).scrolly -orient v -command [list $w(hdr_frame1a).listbox yview]
    ttk::scrollbar $w(hdr_frame1a).scrollx -orient h -command [list $w(hdr_frame1a).listbox xview]
	
	grid $w(hdr_frame1a).listbox -column 0 -row 1 -sticky news
    grid columnconfigure $w(hdr_frame1a) $w(hdr_frame1a).listbox -weight 1
    grid rowconfigure $w(hdr_frame1a) $w(hdr_frame1a).listbox -weight 1
    
    grid $w(hdr_frame1a).scrolly -column 1 -row 1 -sticky nse
    grid $w(hdr_frame1a).scrollx -column 0 -row 2 -sticky ews
    
    ::autoscroll::autoscroll $w(hdr_frame1a).scrolly ;# Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $w(hdr_frame1a).scrollx


    

    ##--------
	# Frame 1b
    set w(hdr_frame1b) [ttk::labelframe $w(hdr_frame1).b -text [mc "Sub-Headers"] -padding 10]
    pack $w(hdr_frame1b) -expand yes -fill both
    
    ttk::label $w(hdr_frame1b).label1 -text [mc "Header Name"]

    ttk::combobox $w(hdr_frame1b).cbox1 -width 20 \
							-state readonly \
                            -textvariable masterHeader \
                            -postcommand [list ea::db::getInternalHeader $w(hdr_frame1b).cbox1]
    
    ttk::entry $w(hdr_frame1b).entry1 -width 20 -textvariable insertChildHeader
    
    ttk::button $w(hdr_frame1b).btn1 -text [mc "Add"] -command "ea::db::addSubHeaders $w(hdr_frame1b).lbox1 $w(hdr_frame1b).entry1 $w(hdr_frame1b).cbox1"
	ttk::button $w(hdr_frame1b).btn2 -text [mc "Delete"] -command "ea::db::delSubHeaders $w(hdr_frame1b).lbox1 $w(hdr_frame1b).cbox1"
    
    listbox $w(hdr_frame1b).lbox1 -yscrollcommand [list $w(hdr_frame1b).scrolly set] \
                                -xscrollcommand [list $w(hdr_frame1b).scrollx set] \
								-height 8 -width 20
    
	ttk::scrollbar $w(hdr_frame1b).scrolly -orient v -command [list $w(hdr_frame1b).lbox1 yview]
    ttk::scrollbar $w(hdr_frame1b).scrollx -orient h -command [list $w(hdr_frame1b).lbox1 xview]
	
	::autoscroll::autoscroll $w(hdr_frame1b).scrolly ;# Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $w(hdr_frame1b).scrollx
	
	
    ##--------
	# Grid Frame 1b
    grid $w(hdr_frame1b).label1 -column 0 -row 0
    grid $w(hdr_frame1b).cbox1 -column 1 -row 0
    
    grid $w(hdr_frame1b).entry1 -column 1 -row 1 -sticky news
    grid $w(hdr_frame1b).btn1 -column 3 -row 1 -sticky ne -padx 3p
    grid $w(hdr_frame1b).btn2 -column 3 -row 2 -sticky ne -padx 3p
	
    grid $w(hdr_frame1b).lbox1 -column 1 -row 2 -sticky news
	grid $w(hdr_frame1b).scrolly -column 2 -row 2 -sticky ns
	grid $w(hdr_frame1b).scrollx -column 1 -row 3 -sticky ws
    
    ##----------
	## Binding
	bind [$w(hdr_frame1a).listbox bodytag] <Double-1> {
		eAssistSetup::Headers edit $w(hdr_frame1a).listbox
		#[$w(hdr_frame1a).listbox get [$w(hdr_frame1a).listbox curselection]]
	}
	
    bind $w(hdr_frame1b).cbox1 <<ComboboxSelected>> {
        # Display the child headers associated with the parent header
		ea::db::getSubHeaders $masterHeader $w(hdr_frame1b).lbox1
    }
	
} ;# eAssistSetup::addressHeaders_GUI


proc eAssistSetup::headersGUI {{mode add} widTable} {
    #****f* headersGUI/eAssistSetup
    # CREATION DATE
    #   10/21/2014 (Tuesday Oct 21)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::Headers args 
    #
    # FUNCTION
    #	Add/Edit headers
	#	mode = add|edit (add is default; edit will populate the widgets with the selected data)
	#	tblWid = Path to the tablelist widget
    #   
    #   
    # CHILDREN
    #	ea::db::populateHeaderEditWindow
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   The prefixed number to the entry/combo/check widgets depicts which sequence they are in, within the DB.
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log
    
    set wid .modHeader
	
	if {[winfo exists $wid)] == 1} {destroy $wid}
    
    # .. Create the dialog window
    toplevel $wid
    wm transient $wid .
    wm title $wid [mc "Add/Edit Headers"]

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    wm geometry $wid +${locX}+${locY}
    
    ##
    ## CONTAINER 0 - Holds the containers
    ##
    set c0 [ttk::frame $wid.c0]
    pack $c0 -expand yes -fill both
    
    ##
    ## CONTAINER 1 - Left Side
    ##
    set c1 [ttk::frame $c0.c1 -padding 5]
    pack $c1 -side left -anchor ne
    
    ## ---------
	## Frame 1 / Database Setup
    #
	set f1 [ttk::labelframe $c1.f1 -text [mc "Database Setup"] -padding 10]
    grid $f1 -column 0 -row 0 -sticky news
    
    ttk::label $f1.txt00 -text [mc "Column Name"]
    ttk::entry $f1.entry00
        focus $f1.entry00
    
    ttk::label $f1.txt01 -text [mc "Data Type"]
    ttk::combobox $f1.cbox01 -values [list INTEGER TEXT] \
                                -state readonly
    
    ttk::checkbutton $f1.ckbtn01 -text [mc "Primary Key"]
    
    #
    # ++ GRID FRAME 1 ++
    #
    grid $f1.txt00 -column 0 -row 0 -sticky nse
    grid $f1.entry00 -column 1 -row 0 -sticky ew
    
    grid $f1.txt01 -column 0 -row 1 -sticky nse
    grid $f1.cbox01 -column 1 -row 1 -sticky ew
    
    grid $f1.ckbtn01 -column 1 -row 2 -sticky nsw
    
    ## ---------
	## Frame 1a / Sub Headers
    #
	set f1a [ttk::labelframe $c1.f1a -text [mc "Sub Headers"] -padding 10]
    grid $f1a -column 0 -row 2 -sticky news
    
    ttk::label $f1a.txt01 -text [mc "Name"]
    ttk::entry $f1a.entry01
    ttk::button $f1a.btn01 -text [mc "Add"] -state disable
    
    listbox $f1a.lbox02 -height 16 -width 25 \
                        -yscrollcommand [list $f1a.scrolly set] \
                        -xscrollcommand [list $f1a.scrollx set]
        
        tooltip::tooltip $f1a.lbox02 [mc "Double-click an entry to edit"]
    
    ttk::button $f1a.btn02 -text [mc "Delete"] -state disable
    
	ttk::scrollbar $f1a.scrolly -orient v -command [list $f1a.lbox1 yview]
    ttk::scrollbar $f1a.scrollx -orient h -command [list $f1a.lbox1 xview]
	
	::autoscroll::autoscroll $f1a.scrolly ;# Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $f1a.scrollx

    
    #
    # ++ GRID FRAME 2 ++
    #
    grid $f1a.txt01 -column 0 -row 0 -sticky nse
    grid $f1a.entry01 -column 1 -row 0 -sticky ew
    grid $f1a.btn01 -column 3 -row 0 -sticky ew
    
    grid $f1a.lbox02 -column 1 -row 1 -sticky news
    grid $f1a.btn02 -column 3 -row 1 -sticky new
    
    grid $f1a.scrolly -column 2 -row 1 -sticky ns
    grid $f1a.scrollx -column 1 -row 2 -sticky ews
    
    #
    # -- Bindings, FRAME 2 --
    #
    
    bind $f1a.entry01 <FocusIn> [list $f1a.btn01 configure -state normal]
    #bind $f1a.entry01 <FocusOut> [list $f1a.btn01 configure -state disable]
    
    ##
    ## CONTAINER 2 - Right Side
    ##
    set c2 [ttk::frame $c0.c2 -padding 5]
    pack $c2 -side left -anchor ne
    
    ## ---------
	## Frame 2 / Tablelist Setup
    #
    set f2 [ttk::labelframe $c2.f2 -text [mc "Tablelist Setup"] -padding 10]
    grid $f2 -column 0 -row 0 -sticky news


    ttk::label $f2.txt00 -text [mc "Label Name"]
    ttk::entry $f2.entry00
        tooltip::tooltip $f2.entry00 [mc "The header name of the column"]
    
    ttk::label $f2.txt04 -text [mc "Label Alignment"]
    ttk::combobox $f2.cbox04 -values [list Left Center Right] \
                                -state readonly
        tooltip::tooltip $f2.cbox04 [mc "The alignment of the header"]
    
    ttk::label $f2.txt01 -text [mc "Widget"]
    ttk::combobox $f2.cbox01 -values [list ttk::entry ttk::combobox] \
                                -state readonly
        tooltip::tooltip $f2.cbox01 [mc "This should always be ttk::entry unless specifying a list in the Values dropdown"]
    
    ttk::label $f2.txt01a -text [mc "Values"]
    ttk::combobox $f2.cbox01a -values [list ShipVia Packages Containers Versions]
        tooltip::tooltip $f2.cbox01a [mc "Versions is a dynamic list built by values in the imported file, or any added by the User"]
    
    ttk::label $f2.txt02 -text [mc "Data Type"]
    ttk::combobox $f2.cbox02 -values [list ASCII ASCIINOCASE DICTIONARY INTEGER REAL] \
                            -state readonly
        tooltip::tooltip $f2.cbox02 [mc "This will allow the widge to sort correctly"]
    
    ttk::label $f2.txt06 -text [mc "Format"]
    ttk::combobox $f2.cbox06 -values [list Date] -state readonly
       
    ttk::label $f2.txt05 -text [mc "Col. Alignment"]
    ttk::combobox $f2.cbox05 -values [list Left Center Right] \
                                -state readonly
        tooltip::tooltip $f2.cbox05 [mc "The alignment of the data in the cells"]

    ttk::label $f2.txt03 -text [mc "Starting Col. Width"]
    ttk::entry $f2.entry03 -width 4
        tooltip::tooltip $f2.entry03 [mc "This is the width of the column when we first open Efficiency Assist, before any data is imported or a project is opened."]
    
    ttk::label $f2.txt07 -text [mc "Max. Width"]
    ttk::entry $f2.entry07 -width 4
        tooltip::tooltip $f2.entry07 [mc "The column will not expand past this width, unless resized by the user."]
    
    ttk::checkbutton $f2.chkbtn08 -text [mc "Resize to longest entry"]
  
    #
    # ++ GRID FRAME 2 ++
    #
    grid $f2.txt00 -column 0 -row 0 -sticky nse
    grid $f2.entry00 -column 1 -row 0 -sticky ew
    
    grid $f2.txt04 -column 0 -row 1 -sticky nse
    grid $f2.cbox04 -column 1 -row 1 -sticky ew
    
    grid $f2.txt01 -column 0 -row 2 -sticky nse
    grid $f2.cbox01 -column 1 -row 2 -sticky ew
    
    grid $f2.txt01a -column 0 -row 3 -sticky nse
    grid $f2.cbox01a -column 1 -row 3 -sticky ew
    
    grid $f2.txt02 -column 0 -row 4 -sticky nse
    grid $f2.cbox02 -column 1 -row 4 -sticky ew

    grid $f2.txt06 -column 0 -row 5 -sticky nse
    grid $f2.cbox06 -column 1 -row 5 -sticky ew
    
    grid $f2.txt05 -column 0 -row 6 -sticky nse
    grid $f2.cbox05 -column 1 -row 6 -sticky ew
    
    grid $f2.txt03 -column 0 -row 7 -sticky nse
    grid $f2.entry03 -column 1 -row 7 -sticky w

    grid $f2.txt07 -column 0 -row 8 -sticky nse
    grid $f2.entry07 -column 1 -row 8 -sticky w
    
    grid $f2.chkbtn08 -column 1 -row 9 -sticky nsw
    

    
    ## ---------
	## Frame 2a / Misc. Options
    set f2a [ttk::labelframe $c2.f2a -text [mc "Misc. Options"] -padding 10]
    grid $f2a -column 0 -row 1 -sticky news
    
    ttk::label $f2a.txt01 -text [mc "Max. String Length"]
    ttk::entry $f2a.entry01 -width 4
    
    ttk::label $f2a.txt02 -text [mc "Highlight Color"]
    ttk::entry $f2a.entry02
    
    ttk::label $f2a.txt03 -text [mc "UI Group"]
    ttk::combobox $f2a.cbox03 -values [list Address {Shipping Order} Other] \
                                -state readonly
    
    ttk::checkbutton $f2a.chkbtn04 -text [mc "Exportable"]
    ttk::checkbutton $f2a.chkbtn05 -text [mc "Required"]
    
    ttk::radiobutton $f2a.rbtn06 -text [mc "Always Display"]
    ttk::radiobutton $f2a.rbtn07 -text [mc "Never Display"]
    ttk::radiobutton $f2a.rbtn08 -text [mc "Dynamic"]
        tooltip::tooltip $f2a.rbtn08 [mc "Display only if data exists"]
    
    
    #
    # ++ GRID FRAME 2a ++
    #
    grid $f2a.txt01 -column 0 -row 0 -sticky nse
    grid $f2a.entry01 -column 1 -row 0 -sticky w
    
    grid $f2a.txt02 -column 0 -row 1 -sticky nse
    grid $f2a.entry02 -column 1 -row 1 -sticky ew
    
    grid $f2a.txt03 -column 0 -row 2 -sticky nse
    grid $f2a.cbox03 -column 1 -row 2 -sticky ew
    
    grid $f2a.chkbtn04 -column 1 -row 3 -sticky nsw
    grid $f2a.chkbtn05 -column 1 -row 4 -sticky nsw
    
    grid $f2a.rbtn06 -column 1 -row 6 -sticky nsw
    grid $f2a.rbtn07 -column 1 -row 7 -sticky nsw
    grid $f2a.rbtn08 -column 1 -row 8 -sticky nsw
    
    ##
    ## CONTAINER 3 - Bottom (Control Buttons)
    ##
    set btn [ttk::frame $wid.btn -padding 15]
    pack $btn -anchor se -padx 2p
    
    ttk::button $btn.btn_OK -text [mc "OK"]
    ttk::button $btn.btn_okNew -text [mc "OK > New"]
    ttk::button $btn.btn_Cancel -text [mc "Cancel"]
    
    grid $btn.btn_OK -column 0 -row 0
    grid $btn.btn_okNew -column 1 -row 0
    grid $btn.btn_Cancel -column 2 -row 0


} ;# eAssistSetup::headersGUI add .
    
    

proc eAssistSetup::Headers {{mode add} widTable} {
    #****f* Headers/eAssistSetup
    # CREATION DATE
    #   10/21/2014 (Tuesday Oct 21)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::Headers args 
    #
    # FUNCTION
    #	Add/Edit headers
	#	mode = add|edit (add is default; edit will populate the widgets with the selected data)
	#	tblWid = Path to the tablelist widget
    #   
    #   
    # CHILDREN
    #	ea::db::populateHeaderEditWindow
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   The prefixed number to the entry/combo/check widgets depicts which sequence they are in, within the DB.
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log tmp_headerOpts
	
	set wid .modHeader
	
	if {[winfo exists $wid)] == 1} {destroy $wid}
    
    # .. Create the dialog window
    toplevel $wid
    wm transient $wid .
    wm title $wid [mc "Add/Edit Headers"]

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    wm geometry $wid +${locX}+${locY}

	
	## --------
	## General setup
	array set tmp_headerOpts {
		07_ckbtn 0
		08_ckbtn 1
		09_ckbtn 0
	}
	
	
	## ---------
	## Frame 1 / General widgets
	
	set f1 [ttk::labelframe $wid.f1 -text [mc "Header Setup"] -padding 10]
	pack $f1 -padx 2p -pady 2p
	
    ttk::label $f1.txt1 -text [mc "Internal Header"]
	ttk::entry $f1.01_entry
	
	ttk::label $f1.txt2 -text [mc "Output Header"]
	ttk::entry $f1.02_entry
	
	ttk::label $f1.txt3 -text [mc "Max String Length"]
	ttk::entry $f1.03_entry -validate all -validatecommand {eAssist_Global::validate %W %d %S -integer only}
	
	ttk::label $f1.txt4 -text [mc "Column Width"]
	ttk::entry $f1.04_entry -validate all -validatecommand {eAssist_Global::validate %W %d %S -integer only}
	
	ttk::label $f1.txt5 -text [mc "Highlight"]
	ttk::combobox $f1.05_cbox -values [list "" Red Yellow] -state readonly -width 15
	
	ttk::label $f1.txt6 -text [mc "Widgets"]
	ttk::combobox $f1.06_cbox -values [list ttk::entry ttk::combobox] -state readonly -width 15
	
	ttk::label $f1.txt6a -text [mc "Display Order"]
	ttk::entry $f1.06a_entry -validate all -validatecommand {eAssist_Global::validate %W %d %S -integer only}
	
	ttk::checkbutton $f1.07_ckbtn -text [mc "Required"] -variable tmp_headerOpts(07_ckbtn)
	ttk::checkbutton $f1.08_ckbtn -text [mc "Always Display?"] -variable tmp_headerOpts(08_ckbtn)
	ttk::checkbutton $f1.09_ckbtn -text [mc "Resize to string width"] -variable tmp_headerOpts(09_ckbtn)
	
	
	
	grid $f1.txt1 -column 0 -row 0 -padx 2p -pady 2p -sticky e
	grid $f1.01_entry -column 1 -row 0 -padx 2p -pady 2p -sticky w
	
	grid $f1.txt2 -column 0 -row 1 -padx 2p -pady 2p -sticky e
	grid $f1.02_entry -column 1 -row 1 -padx 2p -pady 2p -sticky w
	
	grid $f1.txt3 -column 0 -row 2 -padx 2p -pady 2p -sticky e
	grid $f1.03_entry -column 1 -row 2 -padx 2p -pady 2p -sticky w
	
	grid $f1.txt4 -column 0 -row 3 -padx 2p -pady 2p -sticky e
	grid $f1.04_entry -column 1 -row 3 -padx 2p -pady 2p -sticky w	
	
	grid $f1.txt5 -column 0 -row 4 -padx 2p -pady 2p -sticky e
	grid $f1.05_cbox -column 1 -row 4 -padx 2p -pady 2p -sticky w
	
	grid $f1.txt6 -column 0 -row 5 -padx 2p -pady 2p -sticky e
	grid $f1.06_cbox -column 1 -row 5 -padx 2p -pady 2p -sticky w
	
	grid $f1.txt6a -column 0 -row 6 -padx 2p -pady 2p -sticky e
	grid $f1.06a_entry -column 1 -row 6 -padx 2p -pady 2p -sticky w
	
	grid $f1.07_ckbtn -column 1 -row 7 -sticky w
	grid $f1.08_ckbtn -column 1 -row 8 -sticky w
	grid $f1.09_ckbtn -column 1 -row 9 -sticky w
	
	## ---------
	## Buttons
	
	set btns [ttk::frame $wid.btns -padding 10]
	pack $btns -padx 2p -pady 2p -anchor se
	
	ttk::button $btns.cncl -text [mc "Cancel"] -command "destroy $wid"
	ttk::button $btns.save -text [mc "OK"] -command "ea::db::writeHeaderToDB $f1 $widTable Headers; destroy $wid"
	ttk::button $btns.svnew -text [mc "OK > New"] -state disable
	
	grid $btns.cncl -column 0 -row 0 -padx 2p -pady 2p -sticky e
	grid $btns.save -column 1 -row 0 -padx 2p -pady 2p -sticky e
	grid $btns.svnew -column 2 -row 0 -padx 2p -pady 2p -sticky e
	
	## --------
	## Options / Bindings
	focus $f1.01_entry
	
	#bind [$f2.tbl2 bodytag] <Double-ButtonRelease-1> 
	
	## --------
	## Commands
	switch -nocase $mode {
			"edit"	{
					#if {[info exists cols]} {unset cols}
					#set colCount [$tblWid columncount]
					#	for {set x 0} {$colCount > $x} {incr x} {
					#		puts [.container.setup.frame1.a.listbox columncget $x -name]
					#		lappend cols [.container.setup.frame1.a.listbox columncget $x -name]
					#	}
					ea::db::populateHeaderEditWindow $widTable $f1 Headers
				}
	}

    
} ;# eAssistSetup::Headers
