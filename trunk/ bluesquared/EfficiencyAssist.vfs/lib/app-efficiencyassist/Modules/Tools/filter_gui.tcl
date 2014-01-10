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
# $LastChangedDate$
#
########################################################################################

##
## - Overview
# Overview

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

namespace eval eAssist_tools {}
package provide eAssist_tools 1.0

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
    global log
    ${log}::debug --START-- [info level 1]
    ${log}::debug Launching Filter Editor ...
    
    if {[winfo exists .filterEditor] == 1} {destroy .filterEditor}
    #if {[winfo exists .mb1] == 1} {destroy .mb1}
    
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
    
    # .. create the frames
    set frame1 [ttk::frame .filterEditor.frame1]
    pack $frame1
    
    set btnBar [ttk::frame .filterEditor.btnBar]
    pack $btnBar -anchor se
    
    
    # Setup the array for the filters
    array set filter {
        run,stripASCII_CC 1
        run,stripCC 1
        run,stripUDL 1
        run,abbrvAddrState 1
    }
    # .. Frame 1 - create the children widgets
    ttk::checkbutton $frame1.chkbtn1 -text [mc "Remove Hi-Bit Characters"] -variable filter(run,stripASCII_CC) ;#-command {${log}::debug Removing Hi-Bit Characters}
    ttk::checkbutton $frame1.chkbtn2 -text [mc "Remove Control Characters"] -variable filter(run,stripCC) ;#-command {${log}::debug Removing Control Characters}
    ttk::checkbutton $frame1.chkbtn3 -text [mc "Remove Leading/Trailing White Space"] -variable filter(run,stripUDL) ;#-command {${log}::debug Removing Leading White Space}
    ttk::checkbutton $frame1.chkbtn4 -text [mc "Abbreviate words in address"] -variable filter(run,abbrvAddrState) ;#-commnd {${log}::debug Abbreviate words ...}
        tooltip::tooltip $frame1.chkbtn4 [mc "Affects only the columns: Address1, Address2 and State"]
    
    grid $frame1.chkbtn1 -column 0 -row 0 -pady 2p -padx 5p -sticky w
    grid $frame1.chkbtn2 -column 0 -row 1 -pady 2p -padx 5p -sticky w
    grid $frame1.chkbtn3 -column 0 -row 2 -pady 2p -padx 5p -sticky w
    grid $frame1.chkbtn4 -column 0 -row 3 -pady 2p -padx 5p -sticky w
    
    
    
    # .. Button Bar - create the children widgets
    ttk::button $btnBar.cancel -text [mc "Cancel"] -command {destroy .filterEditor}
    ttk::button $btnBar.ok -text [mc "OK"] -command {eAssist_tools::executeFilters}
    
    grid $btnBar.cancel -column 0 -row 0 -pady 5p -padx 5p -sticky se
    grid $btnBar.ok -column 1 -row 0 -pady 5p -padx 5p -sticky se
    
	
    ${log}::debug --END-- [info level 1]
} ;# eAssist_tools::FilterEditor
