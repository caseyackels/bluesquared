# Creator: Casey Ackels
# Initial Date: April 8th, 2011

## Namespace
# ea::gui::pref

proc ea::gui::pref::bl_filepaths {args} {
    #****if* bl_filepaths/ea::gui::pref
    # CREATION DATE
    #   09/22/2015 (Tuesday Sep 22)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # PARENTS
    #   ea::gui::pref::display
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
    
    grid [ttk::label $f1.txt0 -text [mc "BarTender Path"]] -column 0 -row 0 -padx 2p -pady 2p -sticky e
    grid [ttk::entry $f1.entry0 -textvariable mySettings(path,bartender) -width 50] -column 1 -row 0 -sticky ew
    grid [ttk::button $f1.btn0 -text [mc "..."] -command {set mySettings(path,bartender) [eAssist_Global::OpenFile [eAssist_Global::OpenFile [mc "Bartender Path"] [pwd] file .exe]}] -column 2 -row 0
    
    grid [ttk::label $f1.txt1 -text [mc "Label Directory"]] -column 0 -row 1 -padx 2p -pady 2p -sticky e
    grid [ttk::entry $f1.entry1 -textvariable mySettings(path,labelDir)] -column 1 -row 1 -sticky ew
    grid [ttk::button $f1.btn1 -text [mc "..."] -command {set mySettings(path,labelDir) [eAssist_Global::OpenFile [mc "Choose Directory"] [pwd] dir]}] -column 2 -row 1
    
    grid [ttk::label $f1.txt2 -text [mc "Wordpad"]] -column 0 -row 2 -padx 2p -pady 2p -sticky e
    grid [ttk::entry $f1.entry2 -textvariable mySettings(path,wordpad)] -column 1 -row 2 -sticky ew
    grid [ttk::button $f1.btn2 -text [mc "..."] -command {set mySettings(path,wordpad) [eAssist_Global::OpenFile [mc "Wordpad Path"] [pwd] file .exe]}] -column 2 -row 1
    
    grid [ttk::label $f1.txt3 -text [mc "Printer Path"]] -column 0 -row 3 -padx 2p -pady 2p -sticky e
    grid [ttk::entry $f1.entry3 -textvariable mySettings(path,printer)] -column 1 -row 3 -sticky ew
        tooltip::tooltip $f1.entry3 [mc "i.e. \\vm-fileprint\\shipping-time"]
    
    grid [ttk::label $f1.txt4 -text [mc "Output File Path"]] -column 0 -row 4 -padx 2p -pady 2p -sticky e
    grid [ttk::entry $f1.entry4 -textvariable mySettings(path,labelDBfile) ] -column 1 -row 4 -sticky ew
        tooltip::tooltip $f1.entry4 [mc "The path to the DB that the Bartender Label is pointed to"]
    grid [ttk::button $f1.btn3 -text [mc "..."] -command {set mySettings(path,labelDBfile) [eAssist_Global::OpenFile [mc "Label DB Path"] [pwd] dir]}] -column 2 -row 4
    
    grid [ttk::label $f1.txt5 -text [mc "Output File Name"]] -column 0 -row 5 -padx 2p -pady 2p -sticky e
    grid [ttk::entry $f1.entry5 -textvariable mySettings(name,labelDBfile)] -column 1 -row 5 -sticky ew
        tooltip::tooltip $f1.entry5 [mc "The DB file name that the Bartender Label needs. Don't include an extension. We add '.csv' to the name."]
    
    grid [ttk::label $f1.txt6 -text [mc "Breakdown File Name"]] -column 0 -row 6 -padx 2p -pady 2p -sticky e
    grid [ttk::entry $f1.entry6 -textvariable mySettings(path,bdfile)] -column 1 -row 6 -sticky ew
        tooltip::tooltip $f1.entry6 [mc "Choose the name of your breakdown file. This file is used to send to the printer using WordPad."]
    
} ;# ea::gui::pref::bl_filepaths
