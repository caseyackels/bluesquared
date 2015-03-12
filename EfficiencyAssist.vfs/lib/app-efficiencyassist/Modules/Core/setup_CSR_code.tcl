# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 02 02,2014
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


proc eAssistSetup::clearCSR {f1 f2} {
    #****f* clearCSR/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Clear all entry and combobox widgets
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
    global log setupCSR CSR
    ${log}::debug --START-- [info level 1]

    # Get rid of possible data this would happen if we were looking at other csrs before adding a new one.
    # Remove values from combobox and entry fields while bypassing ttk::label widgets.
    # Enable all widgets, and show the save/cancel buttons
    foreach child [winfo children $f1] {
        ${log}::debug CLASS: [winfo class $child]
        if {[winfo class $child] eq "TLabel" || [winfo class $child] eq "TFrame"} {continue}
        if {[winfo class $child] eq "TCheckbutton"} {continue}
        
        #$child configure -state normal
        $child delete 0 end
        if {[lrange [split $child .] end end] eq "cbx1"} {focus $child; ${log}::debug put focus in $child}
    }
        #return
    
    # Display new buttons
    foreach child [winfo children $f2] {
        grid remove $child
    }
    

    grid $f2.cncl $f2.save 
	
    ${log}::debug --END-- [info level 1]
} ;# eAssistSetup::clearCSR


proc eAssistSetup::cancelCSR {f1 f2} {
    #****f* cancelCSR/eAssistSetup
    # CREATION DATE
    #   09/22/2014 (Monday Sep 22)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::cancelCSR f1 f2 
    #
    # FUNCTION
    #	Cancels the 'change' function for the CSR window
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
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log

    # Remove values from combobox and entry fields while bypassing ttk::label and checkbutton widgets.
    foreach child [winfo children $f1] {
        set class [winfo class $child]
        if {[winfo class $child] eq "TLabel" || [winfo class $child] eq "TFrame"} {continue}
        if {[winfo class $child] eq "TCheckbutton"} {continue}

        $child delete 0 end
        #$child configure -state readonly
    }

    foreach child [winfo children $f2] {
        grid remove $child
    }
    
    grid $f2.clr $f2.save
    
} ;# eAssistSetup::cancelCSR


proc eAssistSetup::saveCSR {f1 f2} {
    #****f* saveCSR/eAssistSetup
    # CREATION DATE
    #   09/22/2014 (Monday Sep 22)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::saveCSR f1 f2 csrStatus
    #
    # FUNCTION
    #	Calls the dbSaveCSR command to insert into the DB,  changes the buttons back to normal
    #   
    #   
    # CHILDREN
    #	dbCSR::saveCSR
    #   
    # PARENTS
    #   eAssistSetup::customerService_GUI
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log

    if {[info exists dbArgs]} {unset dbArgs}
    
    foreach child [winfo children $f1] {
        if {[winfo class $child] eq "TLabel" || [winfo class $child] eq "TCheckbutton" || [winfo class $child] eq "TFrame"} {continue} {
            #${log}::debug Values: [$child get]
            lappend dbArgs [$child get]
        }
    }

    dbCSR::saveCSR {*}$dbArgs

    # Set the state back to readonly, and display the ACD buttons
    #foreach child [winfo children $f1] {
    #    if {[winfo class $child] eq "TCheckbutton"} {$child configure -state disabled; continue}
    #    $child configure -state readonly
    #}
    
    foreach child [winfo children $f2] {
        grid remove $child
    }
    
    grid $f2.clr $f2.save
} ;# eAssistSetup::saveCSR


#proc eAssistSetup::changeCSR {f1 f2} {
#    #****f* changeCSR/eAssistSetup
#    # CREATION DATE
#    #   09/22/2014 (Monday Sep 22)
#    #
#    # AUTHOR
#    #	Casey Ackels
#    #
#    # COPYRIGHT
#    #	(c) 2014 Casey Ackels
#    #   
#    #
#    # SYNOPSIS
#    #   eAssistSetup::changeCSR f1 f2 
#    #
#    # FUNCTION
#    #	Enables the widgets, so that the user can change/modify the settings
#    #   
#    #   
#    # CHILDREN
#    #	N/A
#    #   
#    # PARENTS
#    #   
#    #   
#    # NOTES
#    #   
#    #   
#    # SEE ALSO
#    #   
#    #   
#    #***
#    global log
#
#    foreach child [winfo children $f1] {
#        ${log}::debug CLASS: [winfo class $child]
#        if {[winfo class $child] eq "TLabel" || [winfo class $child] eq "TFrame"} {continue}
#        #if {[winfo class $child] eq "TCheckbutton"} {$child configure -state normal; continue}
#        
#        ${log}::debug CHILD: $child
#        $child configure -state normal
#        if {[lrange [split $child .] end end] eq "cbx1"} {focus $child; ${log}::debug put focus in $child}
#    }
#    
#    # Display new buttons
#    foreach child [winfo children $f2] {
#        grid remove $child
#    }
#    
#
#    grid $f2.save $f2.cncl
#
#    
#} ;# eAssistSetup::changeCSR
