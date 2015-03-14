# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 02 08,2015
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 169 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2011-10-17 16:11:20 -0700 (Mon, 17 Oct 2011) $
#
########################################################################################

##
## - Overview
# GUI for the Update detector

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

proc vUpdate::newVersion {txt expln} {
    #****f* newVersion/vUpdate
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #
    # FUNCTION
    #	We are running a new version, so lets let the User know about it, and show the Changelog (if the user desires). This does not detect a new version to download!
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	
    #
    # NOTES
    #   Using Arrays: cVersion, program
    #
    # SEE ALSO
    #
    #
    #***
    global log cVersion program
    
    # Connect to the code.google.com page and query a file ...
    # https://docs.google.com/document/d/1k-O1ZjObXcCMcVYE8oNXUnWEq5GcPsHMQTaHdFgAxwk/edit?usp=sharing
    
    ##
    ## Add proc to launch a dialog
    ## [New Update: Version <4.3.1>]
    ## [Old Version: 4.2.1]
    ## [A new update has been installed]
    ## [Would you like to view the changes?]
    ## Buttons Yes/No (Yes opens up the Change Log), (No closes the update dialog)
    set win .newVers
    
    if {[winfo exists $win]} {destroy $win}
    toplevel $win
    wm transient $win .
    wm title $win [mc "New version detected"]

    # Put the window in the center of the parent window
    set locX [expr {[winfo screenwidth . ] / 4 + [winfo x .]}]
    set locY [expr {[winfo screenheight . ] / 5 + [winfo y .]}]
    wm geometry $win +${locX}+${locY}

    focus $win
	
    # ----- Frame 1
	set wvers(f1) [ttk::frame $win.frame1 -padding 10]
	pack $wvers(f1) -fill both -expand yes  -pady 5p -padx 5p
    
    ttk::label $wvers(f1).txt -text $txt
    
    ttk::label $wvers(f1).oldVersTxt -text [mc "Old Version:"]
    ttk::label $wvers(f1).oldVersNum -text $cVersion(oldFullVersion)
    
    ttk::label $wvers(f1).newVersTxt -text [mc "New Version:"]
    ttk::label $wvers(f1).newVersNum -text $program(fullVersion)
    
    ttk::label $wvers(f1).expln -text $expln
    
    # Grid
    grid $wvers(f1).txt -column 0 -columnspan 2 -row 0 -pady 5p -padx 5p -sticky w
    
    grid $wvers(f1).oldVersTxt -column 0 -row 1 -sticky e
    grid $wvers(f1).oldVersNum -column 1 -row 1 -sticky w
    
    grid $wvers(f1).newVersTxt -column 0 -row 2 -sticky e
    grid $wvers(f1).newVersNum -column 1 -row 2 -sticky w
    
    grid $wvers(f1).expln -column 0 -columnspan 2 -row 3 -pady 5p -padx 5p -sticky w
    
    
    # ----- Button Frame
    set wvers(btn) [ttk::frame $win.btns]
    pack $wvers(btn) -pady 5p -padx 5p -anchor se
    
    ttk::button $wvers(btn).chnglog -text [mc "View Release Notes"] -command {BlueSquared_About::aboutWindow 2; destroy .newVers}
    ttk::button $wvers(btn).ok -text [mc "OK"] -command {lib::savePreferences; destroy .newVers}
    
    grid $wvers(btn).chnglog -column 0 -row 0 -sticky e -pady 5p -padx 5p -ipadx 3p
    grid $wvers(btn).ok -column 1 -row 0 -sticky e -pady 5p -padx 5p
    
    
} ;#newVersion