# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 09 26,2013
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 338 $
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


proc eAssistSetup::changeBoxLabel {} {
    #****f* addBoxLabel/eAssistSetup
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
    global log w boxLabelInfo GS_filePathSetup
    
    ${log}::debug --START-- changeBoxLabel
    ${log}::debug labelDirectory $GS_filePathSetup(labelDirectory)
    
    if {$boxLabelInfo(currentBoxLabel) == ""} {
        ${log}::notice No label name has been specified. Exiting.
        return
    }
    
    $w(bxFR2).ok_1 configure -text [mc "OK"] -command {eAssistSetup::saveBoxLabel}
    
    eAssistSetup::configStateBoxLabel enable enable
    $w(bxFR2).add_1 configure -state disabled
    $w(bxFR2).del_1 configure -state disabled
    
    if {[info exists GS_filePathSetup(lookInDirectory)] == 1 && $GS_filePathSetup(lookInDirectory) ne "" } {
        if {$GS_filePathSetup(labelDirectory) eq "" } {
            # Lets make sure that we have a default setup, before we try to enable this option.
            $w(bxFR2).checkbutton1 configure -state enable
        }
    }
    
    ${log}::debug --END-- changeBoxLabel
} ;#eAssistSetup::changeBoxLabel


proc eAssistSetup::saveBoxLabel {} {
    #****f* saveBoxLabel/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	This is labeled as "OK" in the GUI; when active.
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
    global log w boxLabelInfo GS_label GS_filePathSetup
    ${log}::debug --START-- saveBoxLabel
    
    ${log}::debug Label should change to: Change
    ${log}::debug Saving box label ....
    
    # Return the button to the original state
    $w(bxFR2).ok_1 configure -text [mc "Change"] -command {eAssistSetup::changeBoxLabel}
    
    # Update the values in the combobox
    $w(bxFR2).cbox1_4 configure -values $boxLabelInfo(labelNames)
    
    # Enable the add button, since we are no longer in the 'change mode' state.
    $w(bxFR2).add_1 configure -state enable
    $w(bxFR2).del_1 configure -state enable

    eAssistSetup::configStateBoxLabel disabled readonly
    ${log}::debug file path: $GS_filePathSetup(labelDirectory)
    

    eAssistSetup::saveBoxLabels
    
    ${log}::debug --END-- saveBoxLabel
} ;# eAssistSetup::saveBoxLabel


proc eAssistSetup::addBoxLabel {} {
    #****f* addBoxLabel/eAssistSetup
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
    global log w boxLabelInfo GS_label GS_filePathSetup
    
    ${log}::debug --START-- addBoxLabel
    
    # Be kind to the user and put the focus into the combobox
    focus $w(bxFR2).cbox1_4
    
    $w(bxFR2).ok_1 configure -text [mc "OK"] -command {eAssistSetup::saveBoxLabel}
    $w(bxFR2).add_1 configure -state disable
    $w(bxFR2).del_1 configure -state disable
    
    eAssistSetup::configStateBoxLabel enable enable
    
    set boxLabelInfo(currentBoxLabel) ""
    set GS_label(numberOfFields) ""
    set GS_filePathSetup(labelDirectory) ""
    
    ${log}::debug --END-- addBoxLabel

} ;#eAssistSetup::addBoxLabel


proc eAssistSetup::viewBoxLabel {currentLabel} {
    #****f* viewBoxLabel/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	View the currently selected label and it's associated information
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
    global log boxLabelInfo GS_label GS_filePathSetup
    ${log}::debug --START-- viewBoxLabel
    

    ${log}::debug currentLabel - $currentLabel
    if {$currentLabel == ""} {
        ${log}::notice No label has been set yet. Exiting.
        return
    }
    ${log}::debug NumberoFfields - [lrange $boxLabelInfo($currentLabel,labelSetup) 0 0]
    ${log}::debug labelDirectory - [lrange $boxLabelInfo($currentLabel,labelSetup) 1 1]

    if {[lrange $boxLabelInfo($currentLabel,labelSetup) 0 0] == "{}" } {
        set GS_label(numberOfFields) ""
        ${log}::debug NumberoFfields - No Data, not inserting anything. Resetting Variable.
    } else {
        set GS_label(numberOfFields) [lrange $boxLabelInfo($currentLabel,labelSetup) 0 0]
        ${log}::debug NumberoFfields - Data found, inserting $GS_label(numberOfFields)
    }
    
    
    if {[lrange $boxLabelInfo($currentLabel,labelSetup) 1 1] == "{}" } {
        set GS_filePathSetup(labelDirectory) ""
        ${log}::debug labelDirectory - No Data, not inserting anything. Resetting Variable.
    } else {
        set GS_filePathSetup(labelDirectory) [lrange $boxLabelInfo($currentLabel,labelSetup) 1 1]
        ${log}::debug labelDirectory - Data found, inserting $GS_filePathSetup(labelDirectory)
    }

    
    
    ${log}::debug --END-- viewBoxLabel
	
} ;# eAssistSetup::viewBoxLabel


proc eAssistSetup::cancelBoxLabel {} {
    #****f* cancelBoxLabel/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Cancels the current 'edit/add' mode and discards changes
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
    global w log boxLabelInfo GS_label GS_filePathSetup
    
    ${log}::debug --START-- cancelBoxLabel
    
    $w(bxFR2).ok_1 configure -text [mc "Change"] -command {eAssistSetup::changeBoxLabel}
    $w(bxFR2).add_1 configure -state enable
    $w(bxFR2).del_1 configure -state enable
    
    eAssistSetup::configStateBoxLabel disable readonly
    
    #${log}::debug Current Label $boxLabelInfo(currentBoxLabel)
    #${log}::debug Does current label name match what we have? [lsearch $boxLabelInfo(labelNames) $boxLabelInfo(currentBoxLabel)]
    
    if {[lsearch $boxLabelInfo(labelNames) $boxLabelInfo(currentBoxLabel)] != -1} {
        eAssistSetup::viewBoxLabel $boxLabelInfo(currentBoxLabel)
    } else {
        eAssistSetup::viewBoxLabel [lrange $boxLabelInfo(labelNames) end end]
        set boxLabelInfo(currentBoxLabel) [lrange $boxLabelInfo(labelNames) end end]
    }
    
    
	${log}::debug --END-- cancelBoxLabel
} ;# eAssistSetup::cancelBoxLabel


proc eAssistSetup::deleteBoxLabel {deleteLabel} {
    #****f* deleteBoxLabel/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Delete the selected box label
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
    global log w boxLabelInfo
    ${log}::debug --START-- deleteBoxLabel
    
    if {$deleteLabel == ""} {
        ${log}::notice No label has been set. Exiting
        return
    }
    # $boxLabelInfo(labelNames)
     foreach value $boxLabelInfo(labelNames) {
        if {$value ne "$deleteLabel"} {
            lappend newLabelList $value
            #${log}::debug appending newLabelList $value
        }
    }
    
    array unset $boxLabelInfo($deleteLabel,labelSetup)
    set boxLabelInfo(labelNames) $newLabelList
    $w(bxFR2).cbox1_4 configure -values $boxLabelInfo(labelNames) ;#update the combobox after removing the label
    
    set boxLabelInfo(currentBoxLabel) [lrange $boxLabelInfo(labelNames) end end]
    eAssistSetup::viewBoxLabel $boxLabelInfo(currentBoxLabel)
    
    ${log}::debug New List $boxLabelInfo(labelNames)
    
    eAssistSetup::saveBoxLabels
    

	${log}::debug --END-- deleteboxLabel
} ;# eAssistSetup::deleteBoxLabel


proc eAssistSetup::configStateBoxLabel {key1 key2} {
    #****f* configStateBoxLabel/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Configure the state (enable/disable) in the box label frame
    #	key1 = any widget that isn't a combobox
    #   key2 = combobox
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
    #   Widgets that end with:
    #   _1 (state is always enabled)
    #   _2 (state can change between disabled/enabled)
    #   _3 (state is controlled by a separate method)
    #   _4 (state fluctuates between Readonly and Enabled)
    # SEE ALSO
    #
    #***
    global log w
    
    foreach child [winfo children $w(bxFR2)] {
        if {[string match *_2 $child] == 1} {
            $child configure -state $key1
            ${log}::debug child $child -state $key1
        }
        if {[string match *_4 $child] == 1} {
            # This is a combobox, so requires a different state
            $child configure -state $key2
        }
    }


} ;# eAssistSetup::configStateBoxLabel
