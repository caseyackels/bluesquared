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
