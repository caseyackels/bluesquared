# Creator: Casey Ackels
# Initial Date: April 8th, 2011
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 50 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2011-03-13 17:09:18 -0700 (Sun, 13 Mar 2011) $
#
########################################################################################

##
## - Overview
# This file holds the parent GUI frame, buttons and menu for Distribution Helper

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

## Coding Conventions
# - Namespaces: 

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

namespace eval Disthelper_Preferences {}

proc Disthelper_Preferences::prefGUI {} {
    #****f* prefGUI/Disthelper_Preferences
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	
    #
    # SYNOPSIS
    #	GUI for the preferences window
    #
    # CHILDREN
    #	Disthelper_Preferences::chooseDir, Disthelper_Preferences::saveConfig
    #
    # PARENTS
    #	
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global settings
    
    toplevel .preferences
    wm transient .preferences .
    wm title .preferences [mc "Preferences"]
    wm geometry .preferences 640x300 ;# width X Height
    
    set locX [expr {([winfo screenwidth .] - [winfo width .]) / 2}]
    set locY [expr {([winfo screenheight .] - [winfo height .]) / 2}]
    wm geometry .preferences +${locX}+${locY}
    
    focus -force .preferences
    
    ##
    ## Parent Frame
    ##
    set frame0 [ttk::frame .preferences.frame0]
    pack $frame0 -expand yes -fill both -pady 5p -padx 5p
    
    ##
    ## Notebook
    ##
    set nb [ttk::notebook $frame0.nb]
    pack $nb -expand yes -fill both
    

    $nb add [ttk::frame $nb.f1] -text [mc "File Paths"]
    $nb add [ttk::frame $nb.f2] -text [mc "Miscellaneous"]
    $nb select $nb.f1

    ttk::notebook::enableTraversal $nb
    
    ##
    ## Tab 1 (File Paths)
    ##
    
    ttk::label $nb.f1.sourceText -text [mc "Source Import Files"]
    ttk::entry $nb.f1.sourceEntry -textvariable settings(sourceFiles)
    ttk::button $nb.f1.sourceButton -text ... -command {Disthelper_Preferences::chooseDir sourceFiles}
    
    ttk::label $nb.f1.outFilesText -text [mc "Formatted Import Files"]
    ttk::entry $nb.f1.outFilesEntry -textvariable settings(outFilePath)
    ttk::button $nb.f1.outFilesButton -text ... -command {Disthelper_Preferences::chooseDir outFilePath}
    
    ttk::label $nb.f1.outFilesCopyText -text [mc "Archive Files"]
    ttk::entry $nb.f1.outFilesCopyEntry -textvariable settings(outFilePathCopy)
    ttk::button $nb.f1.outFilesCopyButton -text ... -command {Disthelper_Preferences::chooseDir outFilePathCopy}
    
    grid $nb.f1.sourceText -column 0 -row 0 -sticky e -padx 5p -pady 5p
    grid $nb.f1.sourceEntry -column 1 -row 0 -sticky ew -padx 5p -pady 5p
    grid $nb.f1.sourceButton -column 2 -row 0 -sticky e -padx 5p -pady 5p
    
    grid $nb.f1.outFilesText -column 0 -row 1 -sticky e -padx 5p -pady 5p
    grid $nb.f1.outFilesEntry -column 1 -row 1 -sticky ew -padx 5p -pady 5p
    grid $nb.f1.outFilesButton -column 2 -row 1 -sticky e -padx 5p -pady 5p
    
    grid $nb.f1.outFilesCopyText -column 0 -row 2 -sticky e -padx 5p -pady 5p
    grid $nb.f1.outFilesCopyEntry -column 1 -row 2 -sticky ew -padx 5p -pady 5p
    grid $nb.f1.outFilesCopyButton -column 2 -row 2 -sticky e -padx 5p -pady 5p
    
    grid columnconfigure $nb.f1 1 -weight 2

    
    ##
    ## Tab 2 (Miscellaneous)
    ##
    
    ttk::label $nb.f2.boxTareText -text [mc "Box Tare"]
    ttk::entry $nb.f2.boxTareEntry -textvariable settings(BoxTareWeight)
    
    grid $nb.f2.boxTareText -column 0 -row 0 -sticky e -padx 5p -pady 5p
    grid $nb.f2.boxTareEntry -column 1 -row 0 -sticky ew -padx 5p -pady 5p

    
    
    ##
    ## Button Bar
    ##
    
    set buttonbar [ttk::frame .preferences.buttonbar]
    ttk::button $buttonbar.print -text [mc "Ok"] -command { Disthelper_Preferences::saveConfig; destroy .preferences }
    ttk::button $buttonbar.close -text [mc "Cancel"] -command { destroy .preferences }
    
    grid $buttonbar.print -column 0 -row 3 -sticky nse -padx 8p  
    grid $buttonbar.close -column 1 -row 3 -sticky nse
    pack $buttonbar -side bottom -anchor e -pady 8p -padx 5p
    
    
} ;# end Disthelper_Preferences::prefGUI


proc Disthelper_Preferences::chooseDir {target} { 
    #****f* chooseDir/Disthelper_Preferences
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	Disthelper_Preferences::prefGUI
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global settings
    
    
    set settingsTMP($target) [tk_chooseDirectory \
        -parent .preferences \
        -title [mc "Choose a Directory"] \
	-initialdir $settings($target)
    ]
    
    'debug "(folderName) $settingsTMP($target)"
    
    # If we do not select a file name, and cancel out of the dialog, do not produce an error.
    # The usage of settingsTMP prevents us from over writing our original value; which we may want to keep if the user does not select a directory.
    if {$settings($target) eq ""} {
        'debug "No directory was selected"
        return
        } else {
            set settings($target) $settingsTMP($target)
        }
    
} ;# end Disthelper_Preferences::chooseDir


proc Disthelper_Preferences::saveConfig {} { 
    #****f* saveConfig/Disthelper_Preferences
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	
    #
    # SYNOPSIS
    #	Write settings to config.txt file.
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	'distHelper_loadSettings, Disthelper_Preferences::prefGUI
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global settings
    
    
    set fd [open config.txt w]
        foreach value [array names settings] {
            # Creating application defaults.
            # Original installation, or the config.txt was deleted.
            puts $fd "settings($value) $settings($value)"
    }
    
    chan close $fd
}