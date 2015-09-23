# Creator: Casey Ackels
# Initial Date: April 8th, 2011

## Namespace
# ea::gui::pref
package provide eAssist_Preferences 1.0

proc ea::gui::pref::bm_reports {args} {
    #****if* bm_reports/ea::gui::pref
    # CREATION DATE
    #   09/21/2015 (Monday Sep 21)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   
    #   
    #***
    global log gui

    # Clear out all child widgets ...
    eAssist_Global::resetFrames -pref

    # Set permissions
    $gui(pref,btnBar).ok configure -state [ea::sec::getAccessState -w $args]

    ######
    # GUI
    set f1 [ttk::labelframe $gui(pref,container).f1 -text [mc Testing] -padding 10]
    grid $f1 -column 0 -row 0 -sticky news
    
    grid [ttk::label $f1.txt0 -text [mc "Just a test"]] -column 0 -row 0
    
} ;# ea::gui::pref::bm_reports

proc ea::gui::pref::bm_filepaths {args} {
    #****if* bm_filepaths/ea::gui::pref
    # CREATION DATE
    #   09/22/2015 (Tuesday Sep 22)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   
    #   
    #***
    global log gui mySettings

    # Clear out all child widgets ...
    eAssist_Global::resetFrames -pref
    
    # Set permissions
    $gui(pref,btnBar).ok configure -state [ea::sec::getAccessState -w $args]

    ######
    # GUI
    set f1 [ttk::labelframe $gui(pref,container).f1 -text [mc "File Paths"] -padding 10]
    grid $f1 -column 0 -row 0 -sticky news
    
    grid [ttk::label $f1.txt0 -text [mc "Source Files"]] -column 0 -row 0 -sticky e
    grid [ttk::entry $f1.entry0 -textvariable mySettings(sourceFiles) -width 50] -column 1 -row 0 -sticky ew
    grid [ttk::button $f1.btn0 -text [mc "..."] -command {set mySettings(sourceFiles) [eAssist_Global::OpenFile [mc "Choose Directory"] [pwd] dir]}] -column 2 -row 0
    
    grid [ttk::label $f1.txt1 -text [mc "Output Files"]] -column 0 -row 1 -sticky e
    grid [ttk::entry $f1.entry1 -textvariable mySettings(outFilePath)] -column 1 -row 1 -sticky ew
    grid [ttk::button $f1.btn1 -text [mc "..."] -command {set mySettings(outFilePath) [eAssist_Global::OpenFile [mc "Choose Directory"] [pwd] dir]}] -column 2 -row 1
    
    grid [ttk::label $f1.txt2 -text [mc "File Name"]] -column 0 -row 2 -sticky e
    grid [ttk::entry $f1.entry2 -textvariable mySettings(job,fileName)] -column 1 -row 2 -sticky ew
    grid [ttk::label $f1.txt2a -text "Job Number: %number\nJob Title: %title\nJob Name: %name"] -column 0 -columnspan 3 -row 3 -sticky ew -padx 5p -pady 5p

    grid columnconfigure $f1 1 -weight 2
    
} ;# ea::gui::pref::bm_filepaths

