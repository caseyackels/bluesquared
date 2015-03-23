# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 1/5/2014
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 169 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2014-03-30 10:33:19 -0700 (Sun, 30 Mar 2014) $
#
########################################################################################

##
## - Overview
# Overview

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

package provide eAssist_tools 1.0
namespace eval eAssist_tools {}

proc eAssist_tools::FilterEditor {} {
    #****f* FilterEditor/eAssist_tools
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Displays the options for filtering
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
    global log filter files
    ${log}::debug Launching Filter Editor ...
    
    if {[winfo exists .filterEditor] == 1} {destroy .filterEditor}
    
    # .. Create the dialog window
    toplevel .filterEditor
    wm transient .filterEditor .
    wm title .filterEditor [mc "Filter Editor"]

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    #wm geometry .filterEditor 625x375+${locX}+${locY}
    wm geometry .filterEditor +${locX}+${locY}

    focus .filterEditor
    
    # reset the progressbar and Filter Message
    if {[info exists filter(progbarProgress)]} {unset filter(progbarProgress)}

    set filter(stopRunning) 0
    set filter(progbarFilterName) [mc "Ready ..."]
    
    # .. create the frames
    set frame1 [ttk::frame .filterEditor.frame1]
    pack $frame1
    
    ttk::separator .filterEditor.sepbar -orient horizontal
    pack .filterEditor.sepbar -fill x
    
    set filter(f2) [ttk::frame .filterEditor.frame2]
    pack $filter(f2)
    
    set btnBar [ttk::frame .filterEditor.btnBar]
    pack $btnBar -anchor se
    
    
    # Setup the array for the filters
    # .. Frame 1 - create the children widgets
    ttk::checkbutton $frame1.chkbtn1 -text [mc "Remove Hi-Bit Characters"] \
									-command {eAssist_tools::closeFilterEditor reset} \
									-variable filter(run,stripASCII_CC) \
									-onvalue ea::filter::stripASCII_CC
		tooltip::tooltip $frame1.chkbtn1 [mc "Affects columns: Company, Attention, Address1, Address2, State, Zip, Country, Notes"]
    
	ttk::button $frame1.btn -text [mc "Edit..."] -command {} -state disabled
    
	ttk::checkbutton $frame1.chkbtn2 -text [mc "Remove Control Characters"] \
									-command {eAssist_tools::closeFilterEditor reset} \
									-variable filter(run,stripExtraSpaces) \
									-onvalue ea::filter::stripExtraSpaces
		tooltip::tooltip $frame1.chkbtn2 [mc "Affects columns: Company, Attention, Address1, Address2, State, Zip, Country, Notes"]
    
	ttk::checkbutton $frame1.chkbtn3 -text [mc "Abbreviate words in address"] \
									-command {eAssist_tools::closeFilterEditor reset} \
									-variable filter(run,abbrvAddrState) \
									-onvalue ea::filter::abbrvAddrState
        tooltip::tooltip $frame1.chkbtn3 [mc "Affects columns: Address1, Address2, State"]
    
    ttk::checkbutton $frame1.chkbtn4 -text [mc "Remove Punctuation"] \
									-command {eAssist_tools::closeFilterEditor reset} \
									-variable filter(run,stripUDL) \
									-onvalue ea::filter::stripUDL
		tooltip::tooltip $frame1.chkbtn4 [mc "Affects columns: Company, Attention, Address1, Address2, State, Zip, Country, Notes"]
        #tooltip::tooltip $frame1.chkbtn4 [mc "Affects all Columns! Re-assign your Distribution Types if you run this."]
    
    

    grid $frame1.chkbtn1 -column 0 -row 0 -pady 2p -padx 5p -sticky w
    grid $frame1.btn     -column 1 -row 0 -pady 2p -padx 5p -sticky news
    grid $frame1.chkbtn2 -column 0 -row 1 -pady 2p -padx 5p -sticky w
    grid $frame1.chkbtn3 -column 0 -row 2 -pady 2p -padx 5p -sticky w
    grid $frame1.chkbtn4 -column 0 -row 3 -pady 2p -padx 5p -sticky w
    

    
    # Progress bar
    # .. Frame 2
    ttk::label $filter(f2).txt -textvariable filter(progbarFilterName) 
    # Maximum is set in [runFilters] after we figure out how many filters we are running...
    ttk::progressbar $filter(f2).progbar -length 200 -mode determinate -variable filter(progbarProgress)
    
    grid $filter(f2).txt -column 0 -row 0 -pady 2p -padx 5p -sticky w
    grid $filter(f2).progbar -column 0 -columnspan 2 -row 1 -pady 2p -padx 5p -sticky ew
    
    
    
    # .. Button Bar - create the children widgets
    ttk::button $btnBar.ok -text [mc "OK"] -command {ea::filter::runFilters $files(tab3f2).tbl}
    ttk::button $btnBar.cancel -text [mc "Close"] -command {eAssist_tools::closeFilterEditor kill .filterEditor}

    grid $btnBar.ok -column 0 -row 0 -pady 5p -padx 5p -sticky se 
    grid $btnBar.cancel -column 1 -row 0 -pady 5p -padx 5p -sticky se

} ;# eAssist_tools::FilterEditor


proc eAssist_tools::closeFilterEditor {function args} {
    #****f* closeFilterEditor/eAssist_tools
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Close the filter editor and clear out the progress bar variable
    #
    # SYNOPSIS
    #   closeFilterEditor <kill|reset> <winPathToKill>
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
    global log filter
    #${log}::debug --START-- [info level 1]

    
    switch -- $function {
        kill    {
                set filter(stopRunning) 1
                destroy $args
                set filter(progbarProgress) 0
        }
        reset   {
                set filter(progbarProgress) 0
                set filter(progbarFilterName) [mc "Ready..."]
        }
    }
	
    #${log}::debug --END-- [info level 1]
} ;# eAssist_tools::closeFilterEditor
