# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 10/8/2013
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
# Overview

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


proc eAssistSetup::distributionTypes_GUI {} {
    #****f* distributionTypes_GUI/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	
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
    global log G_setupFrame currentModule dist
    global GUI w
    #variable GUI
    
    #set currentModule addressHeaders
    eAssist_Global::resetSetupFrames ;# Reset all frames so we start clean
    
    ##
    ## Parent Frame
    ##

    set w(dist_frame1) [ttk::labelframe $G_setupFrame.frame1 -text [mc "Distribution Types"]]
    pack $w(dist_frame1) -expand yes -fill both -ipadx 5p -ipady 5p
    

    ttk::label $w(dist_frame1).label1 -text [mc "Distribution Type Name"]
    ttk::entry $w(dist_frame1).entry1 -width 30 -textvariable insertDistributionType
    
    listbox $w(dist_frame1).lbox1 -height 20 \
                -width 30 \
                -selectbackground yellow \
                -selectforeground black \
                -exportselection no \
                -selectmode single \
                -yscrollcommand [list $w(dist_frame1).scrolly set] \
                -xscrollcommand [list $w(dist_frame1).scrollx set]

    ttk::scrollbar $w(dist_frame1).scrolly -orient v -command [list $w(dist_frame1).listbox yview]
    ttk::scrollbar $w(dist_frame1).scrollx -orient h -command [list $w(dist_frame1).listbox xview]
    
    grid $w(dist_frame1).scrolly -column 1 -row 0 -sticky nse
    grid $w(dist_frame1).scrollx -column 0 -row 1 -sticky ews

    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $w(dist_frame1).scrolly
    ::autoscroll::autoscroll $w(dist_frame1).scrollx
    
    ttk::button $w(dist_frame1).btn1 -text [mc "Add"] -command {eAssistSetup::addToDistTypes $w(hdr_frame1).lbox1 $w(hdr_frame1).entry1 $insertDistributionType}
    ttk::button $w(dist_frame1).btn2 -text [mc "Delete"] -command {eAssistSetup::removeDistTypes $w(hdr_frame1).lbox1}
    
    
    #${log}::debug headerParent exists? [info exists headerParent(headerList)]
    if {[info exists dist(distributionTypes)] != 0 } {
        foreach item $dist(distributionTypes) {
            $w(dist_frame1).lbox1 insert end $item
        }
        ${log}::debug Inserting Distribution Types into Listbox: $dist(distributionTypes)
    }
    
    #
    #-------- Grid Frame 1a
    #
    grid $w(dist_frame1).label1 -column 0 -row 0
    grid $w(dist_frame1).entry1 -column 1 -row 0
    grid $w(dist_frame1).btn1 -column 2 -row 0
    
    grid $w(dist_frame1).lbox1 -column 1 -row 1 -sticky news
    grid $w(dist_frame1).btn2 -column 2 -row 1 -sticky new
    
    
	
} ;# eAssistSetup::distributionTypes_GUI

proc eAssistSetup::addToDistTypes {lbox entryField distType} {
    #****f* addToDistTypes/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	
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
    global log dist
    
    $lbox insert end $distType
    set dist(distributionTypes) [$lbox get 0 end]
    
    $entryField delete 0 end
	
} ;# eAssistSetup::addToDistTypes


proc eAssistSetup::removeDistType {wListbox } {
    #****f* removeDistType/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	
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
    global log dist
     ${log}::debug --START-- removeDistType

    if {[$wListbox curselection] == "" } {return}
    $wListbox delete [$wListbox curselection]

    set dist(distributionTypes) [$wListbox get 0 end]
    
    ${log}::debug --END-- removeDistType
} ;# eAssistSetup::removeDistType
