# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 09 10,2013
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
# Holds the GUI for the configuration of the Logging section

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


proc eAssistSetup::logging_GUI {} {
    #****f* eAssistSetup/logging_GUI
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2013 Casey Ackels
    #
    # FUNCTION
    #	Setup core program information
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	
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
    global G_setupFrame GS_program log logSettings s
    
    eAssist_Global::resetSetupFrames ;#logging_GUI ;# Reset all frames so we start clean
    
    set s(frame1) [ttk::labelframe $G_setupFrame.frame1 -text [mc "Log Settings"]]
    pack $s(frame1) -expand yes -fill both
    
    set logSettings(levels) [list Debug Info Notice Warn Error Critical Alert Emergency]
    
    ttk::label $s(frame1).text1 -text [mc "Log Level"]
    ttk::combobox $s(frame1).cbox1 -width 20 \
                            -values $logSettings(levels) \
                            -state readonly \
                            -textvariable logSettings(currentLogLevel)
    
        
    ttk::checkbutton $s(frame1).checkbutton1 -text [mc "Display Console"] -variable logSettings(displayConsole) -command {eAssistSetup::toggleConsole $logSettings(displayConsole)}
    
    #----------- Grid
    grid $s(frame1).text1 -column 0 -row 0 -padx 5p -pady 5p
    grid $s(frame1).cbox1 -column 1 -row 0 -padx 5p -pady 5p
    
    grid $s(frame1).checkbutton1 -column 0 -columnspan 2 -row 2 -padx 5p -pady 5p
    
    #---------- Bindings
    
    bind all <<ComboboxSelected>> { 
    ${log}::debug [$s(frame1).cbox1 current]
        eAssistSetup::changeLogLevel [$s(frame1).cbox1 current]
    }
    
} ;# eAssistSetup::setup_GUI