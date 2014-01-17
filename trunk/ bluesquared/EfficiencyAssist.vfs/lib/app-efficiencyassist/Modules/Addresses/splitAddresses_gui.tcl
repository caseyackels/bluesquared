# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 10 24,2013
# Dependencies: 
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
# Split addresses code

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


proc eAssistHelper::splitVersions {} {
    #****f* splitVersions/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Split versions up, and re-distribute them among the current addresses (Mostly needed for Hometown Values)
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
    global log w process splitVers files
    ${log}::debug --START-- [info level 1]
    
    if {[winfo exists .splitVersions] == 1} {destroy .splitVersions}
    if {[winfo exists .mb1] == 1} {destroy .mb1}
    
    toplevel .splitVersions
    wm transient .splitVersions .
    wm title .splitVersions [mc "Split Versions"]

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    wm geometry .splitVersions 625x375+${locX}+${locY}

    focus .splitVersions
	  
    #Menu
    set mb1 [menu .mb1]
    .splitVersions configure -menu $mb1
    
    #File Menu
    menu $mb1.file -tearoff 0 -relief raised -bd 2
    
    $mb1 add cascade -label [mc "File"] -menu $mb1.file
    $mb1.file add command -label [mc "Add Destination"] -command {eAssistHelper::addDestination $w(sVersf2).tbl}
    $mb1.file add command -label [mc "Close"] -command {destroy .splitVersions}
    
	set f1 [ttk::frame .splitVersions.f1]
	pack $f1 -fill both -pady 5p -padx 5p

	# // Get the most updated list of the versions
	set process(versionList) [$files(tab3f2).tbl getcolumn Version]
	
    ttk::label $f1.txt1 -text [mc "Version"]
    ttk::combobox $f1.cbox1 -values $process(versionList) \
                                -width 40 \
                                -state readonly \
                                -textvariable splitVers(activeVersion) \
                                -postcommand {}

    # Populate the quantity variables right away
    eAssistHelper::displayVerQty [lindex $process(versionList) 0]
    
    set splitVers(activeVersion) [lindex $process(versionList) 0]
    
    bind $f1.cbox1 <<ComboboxSelected>> {      
		eAssistHelper::displayVerQty $splitVers(activeVersion)
		eAssistHelper::calcColumn $w(sVersf2).tbl quantity
		eAssistHelper::resetQuantityColumn $splitVers(activeVersion)
    }
    
    grid $f1.txt1 -column 0 -row 0 -sticky e -padx 2p -pady 2p
    grid $f1.cbox1 -column 1 -row 0 -sticky w -padx 2p -pady 2p
    
    set f2 [ttk::frame .splitVersions.f2]
    pack $f2 -anchor nw -fill both
    
    set f2a [ttk::frame $f2.f2a -relief ridge]
    pack $f2a -side left -fill both -pady 5p -padx 5p
    
	ttk::label $f2a.txt1 -text [mc "Total Version Quantity"]
    ttk::label $f2a.txt2 -textvariable splitVers(totalVersionQty)


    #---- Grid    
    grid $f2a.txt1 -column 0 -row 0 -sticky e -padx 2p -pady 2p
    grid $f2a.txt2 -column 1 -row 0 -sticky w -padx 2p -pady 2p
    
    #---- Frame f2b
    set f2b [ttk::frame $f2.f2b -relief ridge]
    pack $f2b -fill both -pady 5p -padx 5p 

    ttk::label $f2b.txt5 -text [mc "Allocated"]
        set splitVers(allocated) 0
    ttk::label $f2b.txt6 -textvariable splitVers(allocated)
    
    ttk::label $f2b.txt7 -text [mc "Unallocated"]
        set splitVers(unallocated) $splitVers(totalVersionQty)
    ttk::label $f2b.txt8 -textvariable splitVers(unallocated) ;# ;# This is hardcoded in [eAssistHelper::calcColumn]
	${log}::debug Unallocated $f2b.txt8
    
    #---- Grid
    grid $f2b.txt5 -column 0 -row 0 -sticky e -padx 2p -pady 2p
    grid $f2b.txt6 -column 1 -row 0 -sticky w -padx 2p -pady 2p
    grid $f2b.txt7 -column 0 -row 1 -sticky e -padx 2p -pady 2p
    grid $f2b.txt8 -column 1 -row 1 -sticky w -padx 2p -pady 2p

    #---- Frame f4
	set w(sVersf2) [ttk::frame .splitVersions.f4]
	pack $w(sVersf2) -fill both -expand yes -pady 5p -padx 5p -anchor n
    
    set scrolly $w(sVersf2).scrolly
	set scrollx $w(sVersf2).scrollx
	tablelist::tablelist $w(sVersf2).tbl -showlabels yes \
								-selectbackground lightblue \
								-selectforeground black \
								-stripebackground lightyellow \
								-exportselection yes \
								-showseparators yes \
								-fullseparators yes \
								-movablecolumns yes \
								-movablerows yes \
								-editstartcommand {eAssistHelper::editStartSplit} \
								-editendcommand {eAssistHelper::editEndSplit} \
								-yscrollcommand [list $scrolly set] \
								-xscrollcommand [list $scrollx set]

	ttk::scrollbar $scrolly -orient v -command [list $w(sVersf2).tbl yview]
	ttk::scrollbar $scrollx -orient h -command [list $w(sVersf2).tbl xview]
		
	grid $scrolly -column 1 -row 0 -sticky ns
	grid $scrollx -column 0 -row 1 -sticky ew
		
	::autoscroll::autoscroll $scrolly ;# Enable the 'autoscrollbar'
	::autoscroll::autoscroll $scrollx ;# Enable the 'autoscrollbar'
	
    # Insert the data, and show only the relevant columns
    eAssistHelper::splitInsertData $w(sVersf2).tbl $files(tab3f2).tbl
    
    grid $w(sVersf2).tbl -column 0 -row 0 -sticky news
    grid columnconfigure $w(sVersf2) $w(sVersf2).tbl -weight 2
    grid rowconfigure $w(sVersf2) $w(sVersf2).tbl -weight 2
    
	set w(sVersBtn) [ttk::frame .splitVersions.btn]
	pack $w(sVersBtn) -side bottom -anchor se -pady 8p -padx 5p
    
    ttk::button $w(sVersBtn).btn1 -text [mc "Cancel"] -command {destroy .splitVersions}
    ttk::button $w(sVersBtn).btn2 -text [mc "OK"]
    
    grid $w(sVersBtn).btn1 -column 0 -row 0 -padx 2p -pady 2p
	grid $w(sVersBtn).btn2 -column 1 -row 0 -padx 2p -pady 2p
    
    ${log}::debug --END -- [info level 1]
} ;# eAssistHelper::splitVersions



