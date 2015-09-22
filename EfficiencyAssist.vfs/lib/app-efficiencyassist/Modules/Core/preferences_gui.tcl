# Creator: Casey Ackels
# Initial Date: April 8th, 2011

## Namespace
# ea::gui::pref

proc ea::gui::pref::startPref {} {
    #****if* startPref/ea::gui::pref
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
    #   Launches the Preferences - Only displays preferences for the modules the user is allowed to view. If they can't modify/delete, then the widgets will be greyed out.
    #   
    #***
    global log user gui program
    
    # Setup window
    set w [toplevel .pref]
    wm transient $w .
    wm title $w [mc "User Preferences"]

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    wm geometry $w 680x400+${locX}+${locY}

    focus $w
    
    # Create navigation tree
    set gui(pref,nav) [ttk::frame $w.nav]
    pack $gui(pref,nav) -fill both -side left -anchor nw -padx 5p -pady 5p -ipady 2p
    
    # Create main frame for all child widgets
    # This will be populated by the respective functions
    set gui(pref,container) [ttk::frame $w.frame]
    pack $gui(pref,container) -expand yes -fill both -anchor n -padx 5p -pady 5p -ipady 2p
    
    # Button Bar
    set gui(pref,btnBar) [ttk::frame .pref.btnBar]
    pack $gui(pref,btnBar) -side bottom -anchor e -pady 8p -padx 5p
    
    grid [ttk::button $gui(pref,btnBar).ok -text [mc "OK"] -command {lib::savePreferences; destroy .pref} -state disable] -column 1 -row 3 -sticky nse -padx 8p
    grid [ttk::button $gui(pref,btnBar).cancel -text [mc "Cancel"] -command {destroy .pref}] -column 2 -row 3 -sticky nse
    
    
    # Populate the nav frame
    tablelist::tablelist $gui(pref,nav).tbl -columns {18 ""} \
                                                        -background white \
                                                        -exportselection yes \
                                                        -showlabels no \
                                                        -yscrollcommand [list $gui(pref,nav).scrolly set] \
                                                        -xscrollcommand [list $gui(pref,nav).scrollx set]   

    grid $gui(pref,nav).tbl -column 0 -row 0 -sticky news
    grid columnconfigure $gui(pref,nav) $gui(pref,nav).tbl -weight 1
    grid rowconfigure $gui(pref,nav) $gui(pref,nav).tbl -weight 1
    
    ttk::scrollbar $gui(pref,nav).scrolly -orient v -command [list $gui(pref,nav).tbl yview]
    ttk::scrollbar $gui(pref,nav).scrollx -orient h -command [list $gui(pref,nav).tbl xview]
    
    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $gui(pref,nav).scrolly
    ::autoscroll::autoscroll $gui(pref,nav).scrollx
    

    # Insert Groups
    set userMods [ea::db::getUserAccess r]
    ${log}::debug userMods: $userMods
    
    foreach mod $userMods {
        set modCode [db eval "SELECT ModuleCode FROM Modules WHERE ModuleName = '$mod'"]
        set mod [join $mod ""]
        # Inserting the main group name here
        $gui(pref,nav).tbl insertchildlist root end [list $mod]

        if {$program($modCode,groups) ne ""} {
            ${log}::debug Making submenus: $mod / $modCode
            ea::gui::pref::nav $modCode $program($modCode,groups)
        }
    }
    
    bind $gui(pref,nav).tbl <<TablelistSelect>> {ea::gui::pref::display %W}
    
    # MAYBE? This should be set to remember the last position that the user was on?
    $gui(pref,nav).tbl selection clear 0 end
    $gui(pref,nav).tbl selection set 1
    ea::gui::pref::[string tolower [$gui(pref,nav).tbl rowcget [$gui(pref,nav).tbl curselection] -name]]

} ;# ea::gui::pref::startPref

proc ea::gui::pref::display {nav} {
    #****if* display/ea::gui::pref
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
    #   Populate the menu in  ea::db::init_vars
    #   
    #***
    global log user

    #${log}::debug Selection: [$nav curselection] [$nav get [$nav curselection]] [$nav rowcget [$nav curselection] -name ]

    set group [string tolower [$nav rowcget [$nav curselection] -name ]]
    ${log}::debug Group: $group
    
    set mod [ea::db::getModInfo -name [lindex [split $group _] 0]]
    ${log}::debug mod: $mod
    
    set modAccess [ea::db::getModAccess $user(id) $mod]
    ${log}::debug modAccess: $modAccess
    
    # Add a new entry below, then  make sure the 'menu' item is also listed. look at notes above.
    switch -- $group {
        bl_filepaths    {ea::gui::pref::bl_filepaths $modAccess}
        bm_filepaths    {ea::gui::pref::bm_filepaths $modAccess}
        bm_reports      {${log}::debug Launching Reports; ea::gui::pref::bm_reports $modAccess}
        bm_exports      {${log}::debug Launching Exports}
        bm_misc         {${log}::debug Launching Misc}
        default         {}
    }

} ;# ea::gui::pref::display

proc ea::gui::pref::nav {mod args} {
    #****if* BatchMaker/ea::gui::pref
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
    #   Add's items to the navigation tree
    #   mod - module
    #   args = list of subgroups
    #***
    global log gui
    
    set rowCount [$gui(pref,nav).tbl size]
    #${log}::debug rowcount: $rowCount
    
    set args [join $args]
    #${log}::debug args: $args [llength $args]
    
    set node [expr {[$gui(pref,nav).tbl size] - 1}]
    $gui(pref,nav).tbl insertchildlist $node end $args

    foreach group $args {
        $gui(pref,nav).tbl configrows $rowCount -name [join "$mod $group" _]
        incr rowCount
    }

} ;# ea::gui::pref::nav


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
    #set readAccess [lindex $args 0] ;# Allow access to view (shouldn't be needed, since if we have perms to view the mod, we were able to see it in the nav window)
    set writeAccess [lindex [join $args] 1]  ;# Enable save button
    if {$writeAccess == 1} {set saveBtnState normal}
    
    #set deleteAccess [lindex $args 2] ;# Enable delete button
    #if {$deleteAccess == 1} {set deleteBtnState normal}

    ######
    # GUI
    set f1 [ttk::labelframe $gui(pref,container).f1 -text [mc Testing] -padding 10]
    grid $f1 -column 0 -row 0 -sticky news
    
    grid [ttk::label $f1.txt0 -text [mc "Just a test"]] -column 0 -row 0
    
} ;# ea::gui::pref::bm_reports

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
    #set readAccess [lindex $args 0] ;# Allow access to view (shouldn't be needed, since if we have perms to view the mod, we were able to see it in the nav window)
    set writeAccess [lindex [join $args] 1]  ;# Enable save button
    if {$writeAccess == 1} {$gui(pref,btnBar).ok configure -state normal}
    
    #set deleteAccess [lindex $args 2] ;# Enable delete button
    #if {$deleteAccess == 1} {set deleteBtnState normal}
    
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
    #set readAccess [lindex $args 0] ;# Allow access to view (shouldn't be needed, since if we have perms to view the mod, we were able to see it in the nav window)
    set writeAccess [lindex [join $args] 1] ;# Enable save button
    if {$writeAccess == 1} {$gui(pref,btnBar).ok configure -state normal}
    
    
    #set deleteAccess [lindex $args 2] ;# Enable delete button
    #if {$deleteAccess == 1} {set deleteBtnState normal}
    
    ######
    # GUI
    set f1 [ttk::labelframe $gui(pref,container).f1 -text [mc "File Paths"] -padding 10]
    grid $f1 -column 0 -row 0 -sticky news
    
    grid [ttk::label $f1.txt0 -text [mc "Just a test"]] -column 0 -row 0
    
    

    
} ;# ea::gui::pref::bm_filepaths

