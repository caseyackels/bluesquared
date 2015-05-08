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
    global log G_setupFrame currentModule program headerParams headerParent setupHeadersConfig
    global GUI w filters
    #variable GUI
    
    #set currentModule addressHeaders
    eAssist_Global::resetSetupFrames ;# Reset all frames so we start clean
    
    # Initialize the filters array
    #eAssist_Global::launchFilters
    
    # Initialize the setupHeadersConfig array
    eAssistSetup::initsetupHeadersConfigArray
    
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

    ttk::button $w(hdr_frame1b).btn1 -text [mc "Add"] -command {eAssistSetup::headersGUI add}
    ttk::button $w(hdr_frame1b).btn2 -text [mc "Edit"] -command {eAssistSetup::headersGUI edit $w(hdr_frame1a).listbox}
    ttk::button $w(hdr_frame1b).btn3 -text [mc "Delete"] -command {eAssistSetup::headersGUI $w(hdr_frame1a).listbox} -state disabled
    
    grid $w(hdr_frame1b).btn1 -column 0 -row 0 -padx 2p -pady 0p -sticky new
    grid $w(hdr_frame1b).btn2 -column 1 -row 0 -padx 2p -pady 0p -sticky new
    grid $w(hdr_frame1b).btn3 -column 2 -row 0 -padx 2p -pady 0p -sticky new
    
    tablelist::tablelist $w(hdr_frame1a).listbox -columns {
                                                    0   "..." center
                                                    0   "ID" center
													0	"DB Column Name" center
                                                    0	"DB Data Type" center
                                                    0	"Label Name" center
                                                    0 	"Label Alignment" center
													0	"Widget" center
                                                    0   "Values" center
                                                    0	"Data Type" center
													0	"Format" center
													0	"Column Alignment" center
													0	"Starting Width" center
													0	"Maximum Width" center
													0	"Resize" center
                                                    0   "Max. String Length" center
                                                    0   "Highlight Color" center
                                                    0   "UI Group" center
                                                    0   "UI Position Weight" center
                                                    0   "Exportable" center
                                                    0   "Required" center
                                                    0   "Display Type" center
                                                    } \
                                        -showlabels yes \
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
    
        $w(hdr_frame1a).listbox columnconfigure 0 -name "..." \
                                            -showlinenumbers 1 \
                                            -labelalign center
		
        $w(hdr_frame1a).listbox columnconfigure 1 -name "HeaderConfig_ID" \
                                            -labelalign center \
											-hide yes
    
        $w(hdr_frame1a).listbox columnconfigure 2 -name "dbColName" \
                                            -labelalign center
        
        $w(hdr_frame1a).listbox columnconfigure 3 -name "dbDataType" \
                                            -labelalign center
        
        $w(hdr_frame1a).listbox columnconfigure 4 -name "widLabelName" \
                                            -labelalign center
        
        $w(hdr_frame1a).listbox columnconfigure 5 -name "widLabelAlignment" \
                                            -labelalign center
		
        $w(hdr_frame1a).listbox columnconfigure 6 -name "widWidget" \
                                            -labelalign center
											
        $w(hdr_frame1a).listbox columnconfigure 7 -name "widValues" \
                                            -labelalign center
                                            
		$w(hdr_frame1a).listbox columnconfigure 8 -name "widDataType" \
											-labelalign center

		$w(hdr_frame1a).listbox columnconfigure 9 -name "widFormat" \
                                            -labelalign center
		
	    $w(hdr_frame1a).listbox columnconfigure 10 -name "widColAlignment" \
                                            -labelalign center
		
	    $w(hdr_frame1a).listbox columnconfigure 11 -name "widStartColWidth" \
                                            -labelalign center
        
        $w(hdr_frame1a).listbox columnconfigure 12 -name "widMaxWidth" \
                                            -labelalign center
        
        $w(hdr_frame1a).listbox columnconfigure 13 -name "widResizeToLongestEntry" \
                                            -labelalign center
		
        $w(hdr_frame1a).listbox columnconfigure 14 -name "widMaxStringLength" \
                                            -labelalign center
        
        $w(hdr_frame1a).listbox columnconfigure 15 -name "widHighlightColor" \
                                            -labelalign center
        
        $w(hdr_frame1a).listbox columnconfigure 16 -name "widUIGroup" \
                                            -labelalign center
        
        $w(hdr_frame1a).listbox columnconfigure 17 -name "widUIPositionWeight" \
                                            -labelalign center
        
        $w(hdr_frame1a).listbox columnconfigure 18 -name "widExportable" \
                                            -labelalign center
        
        $w(hdr_frame1a).listbox columnconfigure 19 -name "widRequired" \
                                            -labelalign center
        
        $w(hdr_frame1a).listbox columnconfigure 20 -name "widDisplayType" \
                                            -labelalign center


    #ea::db::updateHeaderWidTbl $w(hdr_frame1a).listbox Headers "Header_ID InternalHeaderName OutputHeaderName HeaderMaxLength DefaultWidth Highlight Widget DisplayOrder Required AlwaysDisplay ResizeColumn"
    ea::db::updateHeaderWidTbl $w(hdr_frame1a).listbox
    
    ttk::scrollbar $w(hdr_frame1a).scrolly -orient v -command [list $w(hdr_frame1a).listbox yview]
    ttk::scrollbar $w(hdr_frame1a).scrollx -orient h -command [list $w(hdr_frame1a).listbox xview]
	
	grid $w(hdr_frame1a).listbox -column 0 -row 1 -sticky news
    grid columnconfigure $w(hdr_frame1a) $w(hdr_frame1a).listbox -weight 1
    grid rowconfigure $w(hdr_frame1a) $w(hdr_frame1a).listbox -weight 1
    
    grid $w(hdr_frame1a).scrolly -column 1 -row 1 -sticky nse
    grid $w(hdr_frame1a).scrollx -column 0 -row 2 -sticky ews
    
    ::autoscroll::autoscroll $w(hdr_frame1a).scrolly ;# Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $w(hdr_frame1a).scrollx


    
    ##----------
	## Binding
	bind [$w(hdr_frame1a).listbox bodytag] <Double-1> {
		eAssistSetup::headersGUI edit $w(hdr_frame1a).listbox
		#[$w(hdr_frame1a).listbox get [$w(hdr_frame1a).listbox curselection]]
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
    #   headersGUI <add|edit|view> <table widget path> 
    #
    # FUNCTION
    #	Add/Edit/View headers
	#	mode = add|edit|view (add is default; edit will populate the widgets with the selected data)
    #   
    #   
    # CHILDREN
    #	ea::db::populateHeaderEditWindow
    #   
    # PARENTS
    #   eAssistSetup::addressHeaders_GUI
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log setup
    
    set wid .modHeader
	
	if {[winfo exists $wid)] == 1} {destroy $wid}
        
    switch -- $mode {
        add     {set titleName [mc Add]}
        edit    {set titleName [mc Edit]}
        view    {set titleName [mc View]}
        default {}
    }
    
    # .. Create the dialog window
    toplevel $wid
    wm transient $wid .
    wm title $wid "$titleName [mc {header configuration}]"

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    wm geometry $wid +${locX}+${locY}
    
    # Init the variables
    eAssistSetup::initsetupHeadersConfigArray
    ea::db::initHeaderVariables ;# Available options to populate the 'values' dropdown
    
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
    ttk::entry $f1.entry00  -textvariable setupHeadersConfig(dbColName)
        focus $f1.entry00
    
    ttk::label $f1.txt01 -text [mc "Data Type"]
    ttk::combobox $f1.cbox01 -values [list TEXT INTEGER DATE TIME] \
                                -textvariable setupHeadersConfig(dbDataType) \
                                -state readonly
    
    ttk::checkbutton $f1.ckbtn01 -text [mc "Record Active"] -variable setupHeadersConfig(dbActive)
    
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
    ttk::button $f1a.btn01 -text [mc "Add"] -state disable ;#-command "ea::db::addSubHeaders $w(hdr_frame1b).lbox1 $w(hdr_frame1b).entry1 $w(hdr_frame1b).cbox1"
    
    listbox $f1a.lbox02 -height 16 -width 25 \
                        -yscrollcommand [list $f1a.scrolly set] \
                        -xscrollcommand [list $f1a.scrollx set]
        
        tooltip::tooltip $f1a.lbox02 [mc "Double-click an entry to edit"]
    
    ttk::button $f1a.btn02 -text [mc "Delete"] -state disable ;#-command "ea::db::delSubHeaders $w(hdr_frame1b).lbox1 $w(hdr_frame1b).cbox1"
    
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
    ttk::entry $f2.entry00 -textvariable setupHeadersConfig(widLabelName)
        tooltip::tooltip $f2.entry00 [mc "The header name of the column"]
    
    ttk::label $f2.txt04 -text [mc "Label Alignment"]
    ttk::combobox $f2.cbox04 -values [list Left Center Right] \
                                -textvariable setupHeadersConfig(widLabelAlignment) \
                                -state readonly
        tooltip::tooltip $f2.cbox04 [mc "The alignment of the header"]
    
    ttk::label $f2.txt01 -text [mc "Widget"]
    ttk::combobox $f2.cbox01 -values [list ttk::entry ttk::combobox] \
                                -textvariable setupHeadersConfig(widWidget) \
                                -state readonly
        tooltip::tooltip $f2.cbox01 [mc "This should always be ttk::entry unless specifying a list in the Values dropdown"]
    
    ttk::label $f2.txt01a -text [mc "Values"]
    ttk::combobox $f2.cbox01a -values "$setup(hdr,valuesList) {}" \
                                -textvariable setupHeadersConfig(widValues) \
                                -state readonly
        tooltip::tooltip $f2.cbox01a [mc "Versions is a dynamic list built by values in the imported file, or any added by the User"] 
        #tooltip::tooltip $f2.cbox01a [mc "Versions is a dynamic list built by values in the imported file, or any added by the User"]
    
    ttk::label $f2.txt02 -text [mc "Data Type"]
    ttk::combobox $f2.cbox02 -values [list ASCII ASCIINOCASE DICTIONARY INTEGER REAL] \
                            -textvariable setupHeadersConfig(widDataType) \
                            -state readonly
        tooltip::tooltip $f2.cbox02 [mc "This will allow the widget to sort correctly"]
    
    ttk::label $f2.txt06 -text [mc "Format"]
    ttk::combobox $f2.cbox06 -values [list Date ""] \
                                -textvariable setupHeadersConfig(widFormat) \
                                -state readonly
       
    ttk::label $f2.txt05 -text [mc "Col. Alignment"]
    ttk::combobox $f2.cbox05 -values [list Left Center Right] \
                                -textvariable setupHeadersConfig(widColAlignment) \
                                -state readonly
        tooltip::tooltip $f2.cbox05 [mc "The alignment of the data in the cells"]

    ttk::label $f2.txt03 -text [mc "Starting Col. Width"]
    ttk::entry $f2.entry03 -width 4 -validate all -validatecommand {eAssist_Global::validate %W %d %S -integer only} \
                            -textvariable setupHeadersConfig(widStartColWidth)
        tooltip::tooltip $f2.entry03 [mc "This is the width of the column when we first open Efficiency Assist, before any data is imported or a project is opened."]
    
    ttk::label $f2.txt07 -text [mc "Max. Col. Width"]
    ttk::entry $f2.entry07 -width 4 -validate all -validatecommand {eAssist_Global::validate %W %d %S -integer only} \
                            -textvariable setupHeadersConfig(widMaxWidth)
        tooltip::tooltip $f2.entry07 [mc "The column will not expand past this width, unless resized by the user."]
    
    ttk::checkbutton $f2.chkbtn08 -text [mc "Resize to longest entry"] -variable setupHeadersConfig(widResizeToLongestEntry)
  
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
    ttk::entry $f2a.entry01 -width 4 -validate all -validatecommand {eAssist_Global::validate %W %d %S -integer only} \
                                -textvariable setupHeadersConfig(widMaxStringLength)
    
    ttk::label $f2a.txt02 -text [mc "Highlight Color"]
    ttk::entry $f2a.entry02 -textvariable setupHeadersConfig(widHighlightColor)
    
    ttk::label $f2a.txt03 -text [mc "UI Group"]
    ttk::combobox $f2a.cbox03 -values [list Consignee {Shipping Order} Packaging Miscellaneous] \
                                -textvariable setupHeadersConfig(widUIGroup) \
                                -state readonly
        tooltip::tooltip $f2a.cbox03 [mc "This will help determine where this entry is placed: Both in the Form view and the Spreadsheet."]
        
    #ttk::label $f2a.txt04a -text [mc "UI Group Color"]
    #ttk::entry $f2a.entry04a
    
    ttk::label $f2a.txt04b -text [mc "UI Position Weight"]
    ttk::entry $f2a.entry04b -validate all -validatecommand {eAssist_Global::validate %W %d %S -integer only} \
                                -textvariable setupHeadersConfig(widUIPositionWeight)

    ttk::label $f2a.text06 -text [mc "Display"]
    ttk::combobox $f2a.cbox06 -values [list Dynamic Always Never] \
                                -textvariable setupHeadersConfig(widDisplayType) \
                                -state readonly
    
    ttk::checkbutton $f2a.chkbtn04 -text [mc "Exportable"] -variable setupHeadersConfig(widExportable)
    ttk::checkbutton $f2a.chkbtn05 -text [mc "Required"] -variable setupHeadersConfig(widRequired)
    
    #
    # ++ GRID FRAME 2a ++
    #
    grid $f2a.txt01 -column 0 -row 0 -sticky nse
    grid $f2a.entry01 -column 1 -row 0 -sticky w
    
    grid $f2a.txt02 -column 0 -row 1 -sticky nse
    grid $f2a.entry02 -column 1 -row 1 -sticky ew
    
    grid $f2a.txt03 -column 0 -row 2 -sticky nse
    grid $f2a.cbox03 -column 1 -row 2 -sticky ew
    
    #grid $f2a.txt04a -column 0 -row 3 -sticky nse
    #grid $f2a.entry04a -column 1 -row 3 -sticky ew
    
    grid $f2a.txt04b -column 0 -row 4 -sticky nse
    grid $f2a.entry04b -column 1 -row 4 -sticky ew
    
    grid $f2a.text06 -column 0 -row 5 -sticky nse
    grid $f2a.cbox06 -column 1 -row 5 -sticky ew
    
    grid $f2a.chkbtn04 -column 1 -row 6 -sticky nsw
    grid $f2a.chkbtn05 -column 1 -row 7 -sticky nsw

    ##
    ## CONTAINER 3 - Bottom (Control Buttons)
    ##
    set btn [ttk::frame $wid.btn -padding 15]
    pack $btn -anchor se -padx 2p
    
    ttk::button $btn.btn_OK -text [mc "OK"] -command {ea::db::writeHeaderToDB widTable}
    ttk::button $btn.btn_okNew -text [mc "OK > New"]
    ttk::button $btn.btn_Cancel -text [mc "Cancel"]
    
    grid $btn.btn_OK -column 0 -row 0
    grid $btn.btn_okNew -column 1 -row 0
    grid $btn.btn_Cancel -column 2 -row 0


} ;# eAssistSetup::headersGUI add .
    
    

#proc eAssistSetup::Headers {{mode add} widTable} {
#    #****f* Headers/eAssistSetup
#    # CREATION DATE
#    #   10/21/2014 (Tuesday Oct 21)
#    #
#    # AUTHOR
#    #	Casey Ackels
#    #
#    # COPYRIGHT
#    #	(c) 2014 Casey Ackels
#    #   
#    #
#    # SYNOPSIS
#    #   eAssistSetup::Headers args 
#    #
#    # FUNCTION
#    #	Add/Edit headers
#	#	mode = add|edit (add is default; edit will populate the widgets with the selected data)
#	#	tblWid = Path to the tablelist widget
#    #   
#    #   
#    # CHILDREN
#    #	ea::db::populateHeaderEditWindow
#    #   
#    # PARENTS
#    #   
#    #   
#    # NOTES
#    #   The prefixed number to the entry/combo/check widgets depicts which sequence they are in, within the DB.
#    #   
#    # SEE ALSO
#    #   
#    #   
#    #***
#    global log tmp_headerOpts
#	
#	set wid .modHeader
#	
#	if {[winfo exists $wid)] == 1} {destroy $wid}
#    
#    # .. Create the dialog window
#    toplevel $wid
#    wm transient $wid .
#    wm title $wid [mc "Add/Edit Headers"]
#
#    # Put the window in the center of the parent window
#    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
#    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
#    wm geometry $wid +${locX}+${locY}
#
#	
#	## --------
#	## General setup
#	array set tmp_headerOpts {
#		07_ckbtn 0
#		08_ckbtn 1
#		09_ckbtn 0
#	}
#	
#	
#	## ---------
#	## Frame 1 / General widgets
#	
#	set f1 [ttk::labelframe $wid.f1 -text [mc "Header Setup"] -padding 10]
#	pack $f1 -padx 2p -pady 2p
#	
#    ttk::label $f1.txt1 -text [mc "Internal Header"]
#	ttk::entry $f1.01_entry
#	
#	ttk::label $f1.txt2 -text [mc "Output Header"]
#	ttk::entry $f1.02_entry
#	
#	ttk::label $f1.txt3 -text [mc "Max String Length"]
#	ttk::entry $f1.03_entry -validate all -validatecommand {eAssist_Global::validate %W %d %S -integer only}
#	
#	ttk::label $f1.txt4 -text [mc "Column Width"]
#	ttk::entry $f1.04_entry -validate all -validatecommand {eAssist_Global::validate %W %d %S -integer only}
#	
#	ttk::label $f1.txt5 -text [mc "Highlight"]
#	ttk::combobox $f1.05_cbox -values [list "" Red Yellow] -state readonly -width 15
#	
#	ttk::label $f1.txt6 -text [mc "Widgets"]
#	ttk::combobox $f1.06_cbox -values [list ttk::entry ttk::combobox] -state readonly -width 15
#	
#	ttk::label $f1.txt6a -text [mc "Display Order"]
#	ttk::entry $f1.06a_entry -validate all -validatecommand {eAssist_Global::validate %W %d %S -integer only}
#	
#	ttk::checkbutton $f1.07_ckbtn -text [mc "Required"] -variable tmp_headerOpts(07_ckbtn)
#	ttk::checkbutton $f1.08_ckbtn -text [mc "Always Display?"] -variable tmp_headerOpts(08_ckbtn)
#	ttk::checkbutton $f1.09_ckbtn -text [mc "Resize to string width"] -variable tmp_headerOpts(09_ckbtn)
#	
#	
#	
#	grid $f1.txt1 -column 0 -row 0 -padx 2p -pady 2p -sticky e
#	grid $f1.01_entry -column 1 -row 0 -padx 2p -pady 2p -sticky w
#	
#	grid $f1.txt2 -column 0 -row 1 -padx 2p -pady 2p -sticky e
#	grid $f1.02_entry -column 1 -row 1 -padx 2p -pady 2p -sticky w
#	
#	grid $f1.txt3 -column 0 -row 2 -padx 2p -pady 2p -sticky e
#	grid $f1.03_entry -column 1 -row 2 -padx 2p -pady 2p -sticky w
#	
#	grid $f1.txt4 -column 0 -row 3 -padx 2p -pady 2p -sticky e
#	grid $f1.04_entry -column 1 -row 3 -padx 2p -pady 2p -sticky w	
#	
#	grid $f1.txt5 -column 0 -row 4 -padx 2p -pady 2p -sticky e
#	grid $f1.05_cbox -column 1 -row 4 -padx 2p -pady 2p -sticky w
#	
#	grid $f1.txt6 -column 0 -row 5 -padx 2p -pady 2p -sticky e
#	grid $f1.06_cbox -column 1 -row 5 -padx 2p -pady 2p -sticky w
#	
#	grid $f1.txt6a -column 0 -row 6 -padx 2p -pady 2p -sticky e
#	grid $f1.06a_entry -column 1 -row 6 -padx 2p -pady 2p -sticky w
#	
#	grid $f1.07_ckbtn -column 1 -row 7 -sticky w
#	grid $f1.08_ckbtn -column 1 -row 8 -sticky w
#	grid $f1.09_ckbtn -column 1 -row 9 -sticky w
#	
#	## ---------
#	## Buttons
#	
#	set btns [ttk::frame $wid.btns -padding 10]
#	pack $btns -padx 2p -pady 2p -anchor se
#	
#	ttk::button $btns.cncl -text [mc "Cancel"] -command "destroy $wid"
#	ttk::button $btns.save -text [mc "OK"] -command "ea::db::writeHeaderToDB $f1 $widTable Headers; destroy $wid"
#	ttk::button $btns.svnew -text [mc "OK > New"] -state disable
#	
#	grid $btns.cncl -column 0 -row 0 -padx 2p -pady 2p -sticky e
#	grid $btns.save -column 1 -row 0 -padx 2p -pady 2p -sticky e
#	grid $btns.svnew -column 2 -row 0 -padx 2p -pady 2p -sticky e
#	
#	## --------
#	## Options / Bindings
#	focus $f1.01_entry
#	
#	#bind [$f2.tbl2 bodytag] <Double-ButtonRelease-1> 
#	
#	## --------
#	## Commands
#	switch -nocase $mode {
#			"edit"	{
#					#if {[info exists cols]} {unset cols}
#					#set colCount [$tblWid columncount]
#					#	for {set x 0} {$colCount > $x} {incr x} {
#					#		puts [.container.setup.frame1.a.listbox columncget $x -name]
#					#		lappend cols [.container.setup.frame1.a.listbox columncget $x -name]
#					#	}
#					ea::db::populateHeaderEditWindow $widTable $f1 Headers
#				}
#	}
#
#    
#} ;# eAssistSetup::Headers
