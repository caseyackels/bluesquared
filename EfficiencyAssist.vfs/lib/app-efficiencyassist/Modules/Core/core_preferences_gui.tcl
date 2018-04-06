# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 09 30,2013
# Dependencies: 
#-------------------------------------------------------------------------------
#} ;# eAssistPref::launchPrefbox_labels

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
    #ea::gui::pref::[string tolower [$gui(pref,nav).tbl rowcget [$gui(pref,nav).tbl curselection] -name]]
    ea::gui::pref::display $gui(pref,nav).tbl

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
        bm_exports      {${log}::debug Launching bm:Exports}
        bm_misc         {${log}::debug Launching bm:Misc}
        bf_misc         {${log}::debug Launching bf:misc}
        lf_filepaths    {${log}::debug Luanching LF:filepaths}
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