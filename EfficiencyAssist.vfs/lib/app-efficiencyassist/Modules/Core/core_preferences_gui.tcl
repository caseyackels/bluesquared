# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 09 30,2013
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 468 $
# $LastChangedBy: casey.ackels@gmail.com $
# $LastChangedDate: 2015-02-06 13:20:21 -0800 (Fri, 06 Feb 2015) $
#
########################################################################################

##
## - Overview
# core file for preferences to launch from

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

namespace eval eAssistPref {}

proc eAssistPref::launchPreferences {} {
    #****f* launchPreferences/eAssistPref
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Launch the gui for the preferences. This is just a skeleton to create the window.
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
    global log program pref settings
    
	set currentModule [lrange $settings(currentModule) 0 0]
	
    toplevel .preferences
    wm transient .preferences .
    wm title .preferences [mc "$currentModule Preferences"]

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    wm geometry .preferences +${locX}+${locY}

    focus .preferences
    ${log}::debug which Preferences : $currentModule
    
    
    ##
    ## Parent Frame
    ##
    set pref(frame0) [ttk::frame .preferences.frame0]
    pack $pref(frame0) -expand yes -fill both -pady 5p -padx 5p

    
    switch -- [string tolower $currentModule] {
        batchmaker   {${log}::debug Launching $currentModule; eAssistPref::launchBatchMakerPref} ;#eAssist_Global::resetFrames pref
        boxlabels   {${log}::debug Launching $currentModule ; eAssistPref::launchBoxMakerPref} ;#eAssist_Global::resetFrames pref
        setup       {${log}::debug Launching $currentModule} ;#eAssist_Global::resetFrames pref
		default		{${log}::debug $currentModule isn't setup yet}
    }

    
    set btnBar [ttk::frame .preferences.btnBar]
    pack $btnBar -side bottom -anchor e -pady 8p -padx 5p
    
	ttk::button $btnBar.change -text [mc "Change"] -command {lib::showPwordWindow .preferences.frame0}
    ttk::button $btnBar.ok -text [mc "OK"] -command {lib::savePreferences; destroy .preferences}
    ttk::button $btnBar.cancel -text [mc "Cancel"] -command {destroy .preferences}
    
	grid $btnBar.change -column 0 -row 3 -sticky nse -padx 20p
	grid $btnBar.ok -column 1 -row 3 -sticky nse -padx 8p
    grid $btnBar.cancel -column 2 -row 3 -sticky nse 

} ;#eAssistPref::launchPreferences


proc eAssistPref::launchBatchMakerPref {} {
    #****f* launchBatchMakerPref/eAssistPref
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	display the address preferences
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
    #   These are set per computer. So we cannot save these values to the same file that we save the Setup config to.
    #
    # SEE ALSO
    #
    #***
    global log pref internal mySettings setup settings
    # Reset Frames

    ##
    ## Notebook
    ##
    set pref(nb) [ttk::notebook $pref(frame0).nb]
    pack $pref(nb) -expand yes -fill both

    # Tab setup is in the corresponding proc
    ttk::notebook::enableTraversal $pref(nb)
	
    # Setup the tabs
    $pref(nb) add [ttk::frame $pref(nb).f1] -text [mc "File Paths"]
	$pref(nb) add [ttk::frame $pref(nb).f2] -text [mc "Logging"]

    $pref(nb) select $pref(nb).f1
    
    ##
    ## - Tab1
    ##
	if {![info exists mySettings(job,fileName)]} {set mySettings(job,fileName) "%number %title %name"}
    
    set tab1 [ttk::labelframe $pref(nb).f1.tab1 -text [mc "File Paths"]]
    pack $tab1 -expand yes -fill both -padx 5p -pady 5p
    
    ttk::label $tab1.sourceText -text [mc "Source Import Files"]
    ttk::entry $tab1.sourceEntry -textvariable mySettings(sourceFiles)
    ttk::button $tab1.sourceButton -text ... -command {set mySettings(sourceFiles) [eAssist_Global::OpenFile [mc "Choose Directory"] [pwd] dir]; ${log}::debug OpenFile: $mySettings(sourceFiles)}

    ttk::label $tab1.outFilesText -text [mc "Formatted Import Files"]
    ttk::entry $tab1.outFilesEntry -textvariable mySettings(outFilePath)
    ttk::button $tab1.outFilesButton -text ... -command {set mySettings(outFilePath) [eAssist_Global::OpenFile [mc "Choose Directory"] [pwd] dir]; ${log}::debug OpenFile: $mySettings(outFilePath)} 

    ttk::label $tab1.txt -text [mc "Output File Name"]
    ttk::entry $tab1.entry -textvariable mySettings(job,fileName)
    ttk::label $tab1.txt2 -text "Job Number: %number\nJob Title: %title\nJob Name: %name"
	
	
    #---- Grid
    grid $tab1.sourceText -column 0 -row 0 -sticky e -padx 5p -pady 5p
    grid $tab1.sourceEntry -column 1 -row 0 -sticky ew -padx 5p -pady 5p
    grid $tab1.sourceButton -column 2 -row 0 -sticky e -padx 5p -pady 5p

    grid $tab1.outFilesText -column 0 -row 1 -sticky e -padx 5p -pady 5p
    grid $tab1.outFilesEntry -column 1 -row 1 -sticky ew -padx 5p -pady 5p
    grid $tab1.outFilesButton -column 2 -row 1 -sticky e -padx 5p -pady 5p
	
	grid $tab1.txt -column 0 -row 2 -sticky e -padx 5p -pady 5p
	grid $tab1.entry -column 1 -row 2 -sticky ew -padx 5p -pady 5p
	grid $tab1.txt2 -column 0 -columnspan 3 -row 3 -sticky ew -padx 5p -pady 5p

    grid columnconfigure $tab1 1 -weight 2
    
    ##
    ## - Tab2
    ##
	set tab2 [ttk::labelframe $pref(nb).f2.tab2 -text [mc "Logging"]]
    pack $tab2 -expand yes -fill both -pady 5p -padx 5p
	
	





} ;# eAssistPref::launchBatchMakerPref

proc eAssistPref::launchBoxMakerPref {} {
    #****f* launchBoxMakerPref/eAssistPref
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Preferences for creating box labels
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
    global log pref mySettings
    ${log}::debug --START-- [info level 1]
	
	wm geometry .preferences 450x275
	
	ttk::label $pref(frame0).txt1 -text [mc "Bartender Path"]
	ttk::entry $pref(frame0).entry1 -width 15 -textvariable mySettings(path,bartender)
	ttk::button $pref(frame0).btn1 -text "..." -command {set mySettings(path,bartender) [eAssist_Global::OpenFile [mc "Bartender Path"] [pwd] file .exe]}
	
	grid $pref(frame0).txt1 -column 0 -row 0 -pady 5p -padx 5p -sticky e
	grid $pref(frame0).entry1 -column 1 -row 0 -sticky ew
	grid $pref(frame0).btn1 -column 2 -row 0
	
	ttk::label $pref(frame0).txt2 -text [mc "Label Directory"] 
	ttk::entry $pref(frame0).entry2 -width 15 -textvariable mySettings(path,labelDir)
	ttk::button $pref(frame0).btn2 -text "..." -command {set mySettings(path,labelDir) [eAssist_Global::OpenFile [mc "Choose Directory"] [pwd] dir]}
	
	grid $pref(frame0).txt2 -column 0 -row 1 -sticky e
	grid $pref(frame0).entry2 -column 1 -row 1 -sticky ew
	grid $pref(frame0).btn2 -column 2 -row 1
	
	ttk::label $pref(frame0).txt3 -text [mc "Wordpad"]
	ttk::entry $pref(frame0).entry3 -width 15 -textvariable mySettings(path,wordpad)
	ttk::button $pref(frame0).btn3 -text "..." -command {set mySettings(path,wordpad) [eAssist_Global::OpenFile [mc "Wordpad Path"] [pwd] file .exe]}
	
	grid $pref(frame0).txt3 -column 0 -row 2 -sticky e
	grid $pref(frame0).entry3 -column 1 -row 2 -sticky ew
	grid $pref(frame0).btn3 -column 2 -row 2
	
	ttk::label $pref(frame0).txt4 -text [mc "Printer Path"]
	ttk::entry $pref(frame0).entry4 -width 15 -textvariable mySettings(path,printer)
	#ttk::button $pref(frame0).btn4 -text "..." -command {set mySettings(path,printer) [eAssist_Global::OpenFile [mc "Choose Directory"] [pwd] dir]}
		tooltip::tooltip $pref(frame0).entry4 [mc "i.e. \\vm-fileprint\\shipping-time"]
	
	grid $pref(frame0).txt4 -column 0 -row 3 -sticky e
	grid $pref(frame0).entry4 -column 1 -row 3 -sticky ew
	#grid $pref(frame0).btn4 -column 2 -row 3
	
	ttk::label $pref(frame0).txt5 -text [mc "Output file Path"]
	ttk::entry $pref(frame0).entry5 -width 15 -textvariable mySettings(path,labelDBfile)
		tooltip::tooltip $pref(frame0).entry5 [mc "The path to the DB that the Bartender Label is pointed to"]
	ttk::button $pref(frame0).btn5 -text "..." -command {set mySettings(path,labelDBfile) [eAssist_Global::OpenFile [mc "Label DB Path"] [pwd] dir]}
	
	grid $pref(frame0).txt5 -column 0 -row 4 -sticky e
	grid $pref(frame0).entry5 -column 1 -row 4 -sticky ew
	grid $pref(frame0).btn5 -column 2 -row 4
	
	ttk::label $pref(frame0).txt6 -text [mc "Output file Name"]
	ttk::entry $pref(frame0).entry6 -width 15 -textvariable mySettings(name,labelDBfile)
		tooltip::tooltip $pref(frame0).entry6 [mc "The DB file name that the Bartender Label needs. Don't include an extension. We add '.csv' to the name."]
	
	grid $pref(frame0).txt6 -column 0 -row 5 -sticky e
	grid $pref(frame0).entry6 -column 1 -row 5 -sticky ew
	
	ttk::label $pref(frame0).txt7 -text [mc "Break down File"]
	ttk::entry $pref(frame0).entry7 -width 15 -textvariable mySettings(path,bdfile)
		tooltip::tooltip $pref(frame0).entry7 [mc "Choose the name of your breakdown file. This file is used to send to the printer using WordPad."]
		
	grid $pref(frame0).txt7 -column 0 -row 6 -sticky e
	grid $pref(frame0).entry7 -column 1 -row 6 -sticky ew

	
	
	
	grid columnconfigure $pref(frame0) 1 -weight 1
	
	eAssist_Global::widgetState disabled $pref(frame0)
	
    ${log}::debug --END-- [info level 1]
} ;# eAssistPref::launchBoxMakerPref
