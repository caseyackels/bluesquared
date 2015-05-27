# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 02 26,2014
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 169 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2015-03-11 17:33:06 -0700 (Wed, 11 Mar 2015) $
#
########################################################################################

##
## - Overview
# Overview

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample



proc importFiles::fileImportGUI {} {
    #****f* fileImportGUI/importFiles
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	GUI for importing all files
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
    global log w options mySettings headerParent process job
    #${log}::debug Height: [winfo height .] - [winfo x .]
    #${log}::debug Width: [winfo width .] - [winfo y .]
    if {[eAssistHelper::checkProjSetup] == 1} {return}
    
    if {[winfo exists .wi] == 1} {destroy .wi}
    
    toplevel .wi

    wm transient .wi .
    wm title .wi [mc "File Importer"]

    # Put the window in the center of the parent window
    set locX [expr {[winfo screenwidth .] / 4}]
    set locY [expr {[winfo screenheight .] / 4}]
    #set locX [expr {[winfo x .] / 3}]
    #set locY [expr {[winfo y .] / 3}]
    wm geometry .wi 625x375+${locX}+${locY}

    focus .wi
    
    set w(wi) .wi
    # .. make it so that the user can't see the main program, until after importing their file.
    #catch {tkwait visibility .}
    #catch {grab $w(wi)}
    
    
    #------------- Frame 1a - Top frame
    set f0 [ttk::labelframe $w(wi).top -text [mc "Open file"]]
    pack $f0 -side top -fill both -padx 5p -pady 5p
    
    ttk::label $f0.txt1 -text [mc "File Name"]
    ttk::entry $f0.entry1 -textvariable process(fileName) -width 50
        $f0.entry1 delete 0 end
    
    grid $f0.txt1 -column 0 -row 0 -pady 5p -sticky e ;#-padx 2p
    grid $f0.entry1 -column 1 -row 0 -pady 5p -sticky ew ;#-padx 2p
    
    ttk::button $f0.btn1 -text [mc "Open File"] -command {importFiles::readFile [eAssist_Global::OpenFile "Open File" $job(JobSaveFileLocation) file -ext csv -filetype {{Comma Separated Values} {.csv}}] $w(wi).lbox1.listbox}
    ttk::button $f0.btn2 -text [mc "Import"] -command {lib::savePreferences; importFiles::processFile $w(wi)} -state disabled
    #ttk::button $frame1a.btn3 -text [mc "Reset"] -command {{$log}::debug Reset Interface} -state disabled
    
    grid $f0.btn1 -column 2 -row 0 -padx 5p
    grid $f0.btn2 -column 3 -row 0 -padx 3p
    #grid $frame1a.btn3 -column 4 -row 0 -padx 3p
    
    # This option should be saved, and read from the config file.
        #set options(AutoAssignHeader) 1
        #set options(ClearExistingData) 1
    ttk::checkbutton $f0.chkbtn1 -text [mc "Auto-Assign Header Names"] -variable options(AutoAssignHeader)
    #ttk::checkbutton $f0.chkbtn2 -text [mc "Clear existing data before importing"] -variable options(ClearExistingData)
        #tooltip::tooltip $f0.chkbtn2 [mc "This will remove existing data from the database!"]
        
    grid $f0.chkbtn1 -column 0 -columnspan 2 -row 1 -sticky w
    #grid $f0.chkbtn2 -column 0 -columnspan 2 -row 2 -sticky w

    
    #ttk::label $frame1a.txt2 -text [mc "Number of Records:"]
    #ttk::label $frame1a.entry2 -textvariable process(numOfRecords) -relief flat
    #
    #grid $frame1a.txt2 -column 0 -row 2 -sticky e
    #grid $frame1a.entry2 -column 1 -row 2 -sticky ew
    
    #------------- Frame 1 - Listbox for unassigned file headers
    set f1 [ttk::labelframe $w(wi).lbox1 -text [mc "Unassigned Columns"]]
    pack $f1 -side left -fill both -padx 5p -pady 5p ;#-ipady 2p -anchor nw -side left

    listbox $f1.listbox \
                -width 22 \
                -selectbackground yellow \
                -selectforeground black \
                -exportselection no \
                -selectmode single \
                -yscrollcommand [list $f1.scrolly set] \
                -xscrollcommand [list $f1.scrollx set]


    ttk::scrollbar $f1.scrolly -orient v -command [list $f1.listbox yview]
    ttk::scrollbar $f1.scrollx -orient h -command [list $f1.listbox xview]
    

    grid $f1.listbox -column 0 -row 0 -sticky news
    grid columnconfigure $f1 $f1.listbox -weight 1
    grid rowconfigure $f1 $f1.listbox -weight 1

    grid $f1.scrolly -column 1 -row 0 -sticky nse
    grid $f1.scrollx -column 0 -row 1 -sticky ews
    

    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $f1.scrolly
    ::autoscroll::autoscroll $f1.scrollx
    
    #-------------- Frame 2 - Listbox, available headers to map to.
    set f2 [ttk::labelframe $w(wi).lbox2 -text [mc "Available Columns"]]
    pack $f2 -side left -fill both -padx 5p -pady 5p
    
    listbox $f2.listbox \
                -width 25 \
                -selectbackground yellow \
                -selectforeground black \
                -exportselection no \
                -selectmode single \
                -yscrollcommand [list $f2.scrolly set] \
                -xscrollcommand [list $f2.scrollx set]
    
    if {[info exists headerParent(headerList)] != 0 } {
        foreach item $headerParent(headerList) {
            $f2.listbox insert end $item
        }
        ${log}::debug Inserting masterHeader into $f2.listbox: $headerParent(headerList)
    }

    ttk::scrollbar $f2.scrolly -orient v -command [list $f2.listbox yview]
    ttk::scrollbar $f2.scrollx -orient h -command [list $f2.listbox xview]
    

    grid $f2.listbox -column 0 -row 0 -sticky news
    grid columnconfigure $f2 $f2.listbox -weight 1
    grid rowconfigure $f2 $f2.listbox -weight 1

    grid $f2.scrolly -column 1 -row 0 -sticky nse
    grid $f2.scrollx -column 0 -row 1 -sticky ews
    

    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $f2.scrolly
    ::autoscroll::autoscroll $f2.scrollx
    

    #--------------- Frame 2a - Buttons
    set fbtns [ttk::frame $w(wi).btns]
    pack $fbtns -side left -fill both -padx 5p -pady 5p
    
    ttk::button $fbtns.btn1 -text [mc "Add >"] -command {eAssistHelper::mapHeader} -state disabled
    ttk::button $fbtns.btn2 -text [mc "< Remove"] -command {eAssistHelper::unMapHeader} -state disabled
    
    grid $fbtns.btn1 -column 0 -row 0 -sticky n -pady 5p
    grid $fbtns.btn2 -column 0 -row 1 -sticky n -pady 5p

    #--------------- Frame 3 - Listbox, mapped headers
    set f3 [ttk::labelframe $w(wi).lbox3 -text [mc "Mapped Columns"]]
    pack $f3 -side left -fill both -padx 5p -pady 5p
    
    listbox $f3.listbox \
                -width 28 \
                -selectbackground yellow \
                -selectforeground black \
                -exportselection no \
                -selectmode single \
                -yscrollcommand [list $f3.scrolly set] \
                -xscrollcommand [list $f3.scrollx set]

    ttk::scrollbar $f3.scrolly -orient v -command [list $f3.listbox yview]
    ttk::scrollbar $f3.scrollx -orient h -command [list $f3.listbox xview]

    grid $f3.listbox -column 0 -row 0 -sticky news
    grid columnconfigure $f3 $f3.listbox -weight 2
    grid rowconfigure $f3 $f3.listbox -weight 2

    grid $f3.scrolly -column 1 -row 0 -sticky nse
    grid $f3.scrollx -column 0 -row 1 -sticky ews

    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $f3.scrolly
    ::autoscroll::autoscroll $f3.scrollx
    

} ;# importFiles::fileImportGUI


proc importFiles::enableButtons {args} {
    #****f* enableButtons/importFiles
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	importFiles::enableButtons <args>
    #
    # SYNOPSIS
    #
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	importFiles::readFile
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global log
    #${log}::debug --START-- [info level 1]
    
    
    foreach btn $args {
        $btn configure -state normal
    }
	
    #${log}::debug --END-- [info level 1]
} ;# importFiles::enableButtons


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
    global log user

	set w .pb
    if {[winfo exists w]} {destroy $w}
	
	if {$args eq "destroy"} {destroy $w; return}

    toplevel $w
    wm transient $w .
    wm title $w [mc "Progress Bar"]
    
    set locX [expr {[winfo screenwidth . ] / 4 + [winfo x .]}]
    set locY [expr {[winfo screenheight . ] / 5 + [winfo y .]}]
    wm geometry $w 300x200+${locX}+${locY}

    set f1 [ttk::frame $w.f1 -padding 10]
    pack $f1 -fill both -expand yes -padx 5p ;#-padx 5p -pady 5p
	
    set ::gwin(importpbar) [ttk::progressbar $f1.pbar]
	ttk::label $f1.txt01a -text [mc "Records found in file:"]
	ttk::label $f1.txt01b -text 2000 -textvariable user(fileRecordCount)
	
	grid $f1.txt01a -column 0 -row 0 -sticky w
	grid $f1.txt01b -column 1 -row 0 -sticky e
	grid $::gwin(importpbar) -column 0 -columnspan 2 -row 1 -sticky news
	
	set f2 [ttk::labelframe $w.f2 -text "Stats" -padding 10]
	pack $f2 -fill both -expand yes -padx 5p ;#-padx 5p -pady 5p
	
	ttk::label $f2.txt01a -text [mc "New"]
	ttk::label $f2.txt01b -textvariable user(fileRecordNew)
	
	ttk::label $f2.txt02a -text [mc "Matched Existing"]
	ttk::label $f2.txt02b -textvariable user(fileRecordMatchedExisting)
	
	ttk::label $f2.txt03a -text [mc "Merged"]
	ttk::label $f2.txt03b -textvariable user(fileRecordMerged)
	
	grid $f2.txt01a -column 0 -row 0 -sticky e
	grid $f2.txt01b -column 1 -row 0 -sticky w
	grid $f2.txt02a -column 0 -row 1 -sticky e
	grid $f2.txt02b -column 1 -row 1 -sticky w
	grid $f2.txt03a -column 0 -row 2 -sticky e
	grid $f2.txt03b -column 1 -row 2 -sticky w
	
	set btns [ttk::frame $w.btns -padding 10]
	pack $btns -anchor se
	
	ttk::button $btns.ok -text [mc "OK"] -command {}
	grid $btns.ok -column 0 -row 0 -sticky se

} ;# eAssistHelper::importProgBar


proc eAssistHelper::MergeRecords {} {
    #****f* MergeRecords/eAssistHelper
    # CREATION DATE
    #   05/26/2015 (Tuesday May 26)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # USAGE
    #   eAssistHelper::MergeRecords  
    #
    # FUNCTION
    #	Displays the Existing and new Records; allowing the user to tell the program if the new record really should be considerd new, or if the existing and new should be merged together
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # EXAMPLE
    #   eAssistHelper::MergeRecords 
    #
    # NOTES
    #   
    #  
    # SEE ALSO
    #   
    #   
    #***
    global log

	set w .mr
    if {[winfo exists w]} {destroy $w}
	
	#if {$args eq "destroy"} {destroy $w; return}

    toplevel $w
    wm transient $w .
    wm title $w [mc "Progress Bar"]
    
    set locX [expr {[winfo screenwidth . ] / 4 + [winfo x .]}]
    set locY [expr {[winfo screenheight . ] / 5 + [winfo y .]}]
    wm geometry $w 475x300+${locX}+${locY}

    set f1 [ttk::frame $w.f1 -padding 10]
    pack $f1 -fill both -expand yes -padx 5p ;#-padx 5p -pady 5p
    
    ttk::label $f1.txt01 -text [mc "Are these two addresses the same?"]
    pack $f1.txt01
    
    # Container for the two text widgets
    set f2 [ttk::frame $w.f1.f2 -padding 8]
    pack $f2 -fill both -expand yes
    
    # Existing addresses - Left Frame
    set f2a [ttk::frame $f2.a -padding 2]
    grid $f2a -column 0 -row 0 -sticky e
    
        ttk::label $f2a.txt_label -text [mc "Existing Address"]
        text $f2a.txt -width 25 -height 10
        
        grid $f2a.txt_label -column 0 -row 0 -sticky n
        grid $f2a.txt -column 0 -row 1 -sticky news
        
    # New Addresses - Right Frame
    set f2b [ttk::frame $f2.b -padding 2]
    grid $f2b -column 1 -row 0 -sticky w
        
        ttk::label $f2b.txt_label -text [mc "New Address"]
        text $f2b.txt -width 25 -height 10
        
        grid $f2b.txt_label -column 0 -row 0 -sticky n
        grid $f2b.txt -column 0 -row 1 -sticky news

        
    set f2c [ttk::frame $f2.c -padding 2]
    grid $f2c -column 1 -row 2 -sticky e
    
        ttk::radiobutton $f2c.rbtn01 -text [mc "Keep New"]
        ttk::radiobutton $f2c.rbtn02 -text [mc "Merge"]
        
        grid $f2c.rbtn01 -column 0 -row 0 -sticky w
        grid $f2c.rbtn02 -column 0 -row 1 -sticky w  
    
        
    # Buttons
    set f3 [ttk::frame $w.f3 -padding 3]
    pack $f3 -anchor e -padx 2p
    
    ttk::button $f3.ok -text [mc "OK"]
    #ttk::button $f3.cncl -text [mc "Cancel"]
    
    grid $f3.ok -column 0 -row 0
    #grid $f3.cncl -column 1 -row 0
    
insertTestData $f2a.txt $f2b.txt
    
} ;# eAssistHelper::MergeRecords

proc insertTestData {txt1 txt2} {
    # Setup the tags for formatting
    
    $txt1 tag config Normal -font {verdana 9}
    $txt1 tag config bold -font {bold}
    $txt1 tag config diff -font {verdana 9 bold} -background #FFB2B2
    
    $txt2 tag config Normal -font {verdana 9}
    $txt2 tag config bold -font {bold}
    $txt2 tag config diff -font {verdana 9 bold} -background #FFB2B2

    foreach wid [list $txt1 $txt2] {
        $wid insert end "Company Name\nAttention\nAddress1\nAddress2\n" Normal
        $wid insert end "Address3\n" diff
        $wid insert end "City\nState\nZip\nPhone\nCountry" {Normal bold}
    }
}
