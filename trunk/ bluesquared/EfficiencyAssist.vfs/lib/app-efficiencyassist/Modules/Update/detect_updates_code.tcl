# Creator: Casey Ackels
# Initial Date: January 18, 2014]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 384 $
# $LastChangedBy: casey.ackels@gmail.com $
# $LastChangedDate: 2014-01-17 07:17:52 -0800 (Fri, 17 Jan 2014) $
#
########################################################################################

##
## - Overview
# Detect if there is a new version; if so launch the required fields if needed. At minimum, display a window that says that the program has been updated.


package provide vUpdate 1.0

namespace eval vUpdate {}

proc vUpdate::saveCurrentVersion {} {
    #****f* saveCurrentVersion/vUpdate
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #
    # FUNCTION
    #	Set the current version numbers before we read in our saved versioning numbers from the config file.
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	vUpdate::whatVersion
    #
    # PARENTS
    #	
    #
    # NOTES
    #
    # SEE ALSO
    #
    #
    #***
    global log cVersion program
    
    set firstRun 0
    ${log}::debug Entering SaveCurrentVersion
    
    # Check to see if we've ran this before ...
    if {[info exists program(Version)] == 0} {
        set firstRun 1
        ${log}::debug firstRun: $firstRun
    }
    
    if {$firstRun == 0} {
        # We've loaded all the saved variables, so we know what the 'old' version is.
        set cVersion(oldFullVersion) "$program(Version).$program(PatchLevel) $program(beta)"
        
        set cVersion(oldVersion) $program(Version)
        set cVersion(oldPatchLevel) $program(PatchLevel)
        set cVersion(oldbeta) $program(beta)
    }
    
    set program(Version) 4
    set program(PatchLevel) 0.0 ;# Leading decimal is not needed
    set program(beta) "Beta 2"
    set program(fullVersion) "$program(Version).$program(PatchLevel) $program(beta)"
    
    set program(Name) "Efficiency Assist"
    set program(FullName) "$program(Name) - $program(fullVersion)"
    
    tk appname $program(Name)


    if {$firstRun == 0} {
        vUpdate::whatVersion
        ${log}::debug Launching window firstrun: $firstRun = 0
    } else {
        return
    }
} ;#saveCurrentVersion


proc vUpdate::whatVersion {} {
    #****f* whatVersion/vUpdate
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #
    # FUNCTION
    #	Find out what version we are using compared to what is in the config file.
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	vUpdate::newVersion
    #
    # PARENTS
    #	vUpdate::saveCurrentVersion
    #
    # NOTES
    #   Using Arrays: cVersion, program
    #
    # SEE ALSO
    #
    #
    #***
    global log cVersion program
    
    if {![info exists cVersion(oldbeta)]} {return}
    # cVersion is read from the code
    # program array is read from the config file
    
    set launchGui 0
    
    # Check the versioning from the bottom up
    if {$cVersion(oldbeta) ne $program(beta)} {
        ${log}::debug New Beta Detected, was $cVersion(oldbeta), now $program(beta)!
        ${log}::debug Minor Update, launching 'New Update' dialog ...
        set vers [mc "beta"]
        set newVersionExpln [mc "Definition of beta: This version is in flux and may not operate the way it was intended."]
        set launchGui 1
    } else {
        ${log}::debug Beta: Nothing new detected
    }
    
    if {$cVersion(oldPatchLevel) ne $program(PatchLevel)} {
        ${log}::debug New Patch Detected, was $cVersion(oldPatchLevel), now $program(PatchLevel)!
        ${log}::debug Minor Update, launching 'New Update' dialog ...
        set vers [mc "minor"]
        set newVersionExpln [mc "Definition of minor: This will typically have minor new features added and bugs that are fixed. A maintenance release."]
        set launchGui 1
    } else {
        ${log}::debug PatchLevel: Nothing new detected
    }
    
    if {$cVersion(oldVersion) ne $program(Version)} {
        ${log}::debug New Major Version detected, was $cVersion(oldVersion, now $program(Version)!
        ${log}::debug Major Update, launching 'New Update' dialog ...
        set vers [mc "major"]
        set newVersionExpln [mc "Definition of major: This has numerous new features that are big or small. All of the updates that the previous minor releases had. This may contain more bugs."]
        set launchGui 1
    } else {
        ${log}::debug Major Version: Nothing new detected
    }
    
    if {$launchGui == 1} {
        set newVersionTxt [mc "A new $vers version has been detected"]
        vUpdate::newVersion $newVersionTxt $newVersionExpln
    }
} ;#whatVersion


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