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
    wm geometry $w +${locX}+${locY}

    focus $w
    
    # Create navigation tree
    set gui(pref,nav) [ttk::frame $w.nav]
    pack $gui(pref,nav) -fill both -side left -anchor nw -padx 5p -pady 5p -ipady 2p
    
    # Create main frame for all child widgets
    set gui(pref,container) [ttk::frame $w.frame]
    pack $gui(pref,container) -expand yes -fill both -anchor n -padx 5p -pady 5p -ipady 2p
    
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
    foreach mod $userMods {
        set modCode [db eval "SELECT ModuleCode FROM Modules WHERE ModuleName = '$mod'"]
        set mod [join $mod ""]
        $gui(pref,nav).tbl insertchildlist root end [list $mod]

        if {$program($modCode,groups) ne ""} {
            ea::gui::pref::nav $modCode $program($modCode,groups)
        }
    }
    
    bind $gui(pref,nav).tbl <<TablelistSelect>> {ea::gui::pref::display %W}

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
    
    switch -- $group {
        bm_reports  {${log}::debug Launching Reports; ea::gui::pref::bm_reports $modAccess}
        bm_exports  {${log}::debug Launching Exports}
        bm_misc     {${log}::debug Launching Misc}
        default     {}
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
    
    set args [join $args]
    
    $gui(pref,nav).tbl insertchildlist [incr [llength $args]] end $args

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
    
    # Setup defaults
    set saveBtnState disable
    set deleteBtnState disable
    
    # Set permissions
    set readAccess [lindex $args 0] ;# Allow access to view (shouldn't be needed, since if we have perms to view the mod, we were able to see it in the nav window)
    set writeAccess [lindex $args 1] ;# Enable save button
    if {$writeAccess == 1} {set saveBtnState normal}
    
    set deleteAccess [lindex $args 2] ;# Enable delete button
    if {$deleteAccess == 1} {set deleteBtnState normal}

    ######
    # GUI
    set f1 [ttk::labelframe $gui(pref,container).f1 -text [mc Testing] -padding 10]
    grid $f1 -column 0 -row 0 -sticky news
    
    grid [ttk::label $f1.txt0 -text [mc "Just a test"]] -column 0 -row 0
    
} ;# ea::gui::pref::bm_reports
