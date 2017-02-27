# Creator: Casey Ackels
# Initial Date: December 12, 2016]

proc eAssistSetup::scheduler_GUI {} {
    global log G_setupFrame
    set currentModule ""
    
    eAssist_Global::resetSetupFrames ;# Reset all frames so we start clean
	
    set frame0 [ttk::label $G_setupFrame.frame0 -padding 10]
    pack $frame0 -expand yes -fill both ;#-fill both ;#-pady 5p -padx 5p
    
    ##
    ## Notebook
    ##
    
    set nbk [ttk::notebook $frame0.nbk]
    pack $nbk -expand yes -fill both -anchor s -pady 3p

    ttk::notebook::enableTraversal $nbk
    
    # Setup the notebook tabs
    $nbk add [ttk::frame $nbk.dates] -text [mc "Date Types"]
    $nbk add [ttk::frame $nbk.misc] -text [mc "Misc Setup"]
    $nbk add [ttk::frame $nbk.workflow] -text [mc "Workflows"]

    $nbk select $nbk.dates
    
    
##
## Frame 1
##
    set f1 [ttk::labelframe $nbk.dates.f1 -text [mc "Date Types"] -padding 10]
    pack $f1 -fill both -anchor n -side left -pady 5p -padx 5p

    grid [listbox $f1.lbox] -column 0 -row 0 -rowspan 8 -pady 2p -padx 2p -sticky news
    grid [ttk::button $f1.add -text [mc "Add"] -command ea::sched::gui::addDateType] -column 1 -row 0 -pady 0p -padx 2p -sticky new
    grid [ttk::button $f1.edit -text [mc "Edit"] -command "ea::sched::db::getDateTypeSetup $f1.lbox; ea::sched::gui::addDateType -edit"] -column 1 -row 2 -pady 0p -padx 2p -sticky new
    grid [ttk::button $f1.del -text [mc "Delete"] -command "ea::sched::db::delDateType $f1.lbox"] -column 1 -row 3 -pady 0p -padx 2p -sticky new
    
    # Insert the group names
    #$f1.lbox delete 0 end
    foreach item [ea::sched::db::getAllGroupNames -n] {
        $f1.lbox insert end $item
    }
    
    
##
## Frame 2
##
    set f2 [ttk::labelframe $nbk.dates.f2 -text [mc "Workflow"] -padding 10]
    pack $f2 -fill both -anchor n -pady 5p -padx 5p

    
    grid [listbox $f2.lbox] -column 0 -row 0 -rowspan 8 -pady 2p -padx 2p -sticky news
    grid [ttk::button $f2.add -text [mc "Add"] -command "ea::sched::gui::workflow -add"] -column 1 -row 0 -pady 0p -padx 2p -sticky new
    grid [ttk::button $f2.edit -text [mc "Edit"] -command "ea::sched::gui::workflow -edit"] -column 1 -row 2 -pady 0p -padx 2p -sticky new
    grid [ttk::button $f2.del -text [mc "Delete"] -command ""] -column 1 -row 3 -pady 0p -padx 2p -sticky new
    
    # Insert the group names
    #$f1.lbox delete 0 end
    #foreach item [ea::sched::db::getAllGroupNames -n] {
    #    $f2.lbox insert end $item
    #}
    
##
## Frame 3
##
    set f3 [ttk::labelframe $nbk.dates.f3 -text [mc "Frequency"] -padding 10]
    pack $f3 -fill both -anchor n -pady 5p -padx 5p

    
    grid [listbox $f3.lbox] -column 0 -row 0 -rowspan 8 -pady 2p -padx 2p -sticky news
    grid [ttk::button $f3.add -text [mc "Add"] -command "ea::sched::gui::frequency -add"] -column 1 -row 0 -pady 0p -padx 2p -sticky new
    grid [ttk::button $f3.edit -text [mc "Edit"] -command "ea::sched::gui::frequency -edit"] -column 1 -row 2 -pady 0p -padx 2p -sticky new
    grid [ttk::button $f3.del -text [mc "Delete"] -command ""] -column 1 -row 3 -pady 0p -padx 2p -sticky new
    
    
#    ##
#    ## Notebook Tab 2 (Events)
#    ##
#    
#    
#    
#	
#    text $eF2.text -height 5 \
#		    -wrap word \
#		    -yscrollcommand [list $eF2.scrolly set] \
#		    -xscrollcommand [list $eF2.scrollx set]
#    
#    ttk::scrollbar $eF2.scrolly -orient v -command [list $eF2.text yview]
#    ttk::scrollbar $eF2.scrollx -orient h -command [list $eF2.text xview]
#    
#   
#    # Enable the 'autoscrollbar'
#    ::autoscroll::autoscroll $eF2.scrolly
#    ::autoscroll::autoscroll $eF2.scrollx
#    
#    grid columnconfigure $eF2 $eF2.text -weight 1
    
    
} ;# eAssistSetup::scheduler_GUI

proc ea::sched::gui::addDateType {args} {
    global log sched
    
    if {[winfo exists .d]} {destroy .d}
    set d [toplevel .d -class Dialog]
    wm title $d [mc "Setup Date Types"]
    wm transient $d .
    catch {wm attributes $d -type dialog}
    
    if {$args ne "-edit"} {
        # -edit must set the vars, so we don't want to over write it.
        ea::sched::code::initvars_sched
    }
    
    update idletasks
        
    set f1 [ttk::frame $d.f1 -padding 10]
    pack $f1 -expand yes -fill both

    grid [ttk::label $f1.txt0 -text [mc "Group"]] -column 0 -row 0 -sticky e
    grid [ttk::combobox $f1.cbx0 -postcommand "$f1.cbx0 configure -values [ea::sched::db::getAllGroupNames -g]"] -column 1 -row 0 -sticky ew
    grid [ttk::label $f1.txt1 -text [mc "Date Type Name"]] -column 0 -row 1 -sticky e
    grid [ttk::entry $f1.ent0] -column 1 -row 1 -sticky ew
        focus $f1.ent0
        
    grid [ttk::label $f1.txt2 -text [mc "Avoid"]] -column 0 -row 2 -sticky e
    grid [ttk::checkbutton $f1.ckbtn0 -text [mc "Weekend"] -variable sched(avoid_weekend)] -column 1 -row 3 -sticky w
    grid [ttk::checkbutton $f1.ckbtn1 -text [mc "Plant Holiday"] -variable sched(avoid_plantHoliday)] -column 1 -row 4 -sticky w
    grid [ttk::checkbutton $f1.ckbtn2 -text [mc "Freight Holiday"] -variable sched(avoid_freightHoliday)] -column 1 -row 5 -sticky w
    grid [ttk::checkbutton $f1.ckbtn3 -text [mc "USPS Holiday"] -variable sched(avoid_USPSHoliday)] -column 1 -row 6 -sticky w
    
    set f2 [ttk::frame $d.f2 -padding 5]
    pack $f2 -anchor se
    
    grid [ttk::button $f2.btn1 -text [mc "Cancel"] -command [list destroy $d]] -column 0 -row 0 -padx 3p
    grid [ttk::button $f2.btn2 -text [mc "OK"] -command "ea::sched::code::writeDateType $f1.cbx0 $f1.ent0; destroy $d"] -column 1 -row 0 -padx 3p
   
}

proc ea::sched::gui::workflow {args} {
    global log sched
    
    if {[winfo exists .wf]} {destroy .wf}
    set d [toplevel .wf -class Dialog]
    wm title $d [mc "Workflow"]
    wm transient $d .
    catch {wm attributes $d -type dialog}
    
    if {$args ne "-edit"} {
        # -edit must set the vars, so we don't want to over write it.
       # ea::sched::code::initvars_sched
    }
}

proc ea::sched::gui::frequency {args} {
    global log sched
    
    if {[winfo exists .fr]} {destroy .fr}
    set d [toplevel .fr -class Dialog]
    wm title $d [mc "Frequency"]
    wm transient $d .
    catch {wm attributes $d -type dialog}
    
    if {$args ne "-edit"} {
        # -edit must set the vars, so we don't want to over write it.
       # ea::sched::code::initvars_sched
    }
    
    set f1 [ttk::frame $d.f1 -padding 10]
    pack $f1 -expand yes -fill both
    
    grid [ttk::label $f1.txt0 -text [mc "Description"]] -column 0 -row 0 -pady 2p
    grid [ttk::entry $f1.ent0] -column 1 -columnspan 3 -row 0 -pady 2p
    grid [ttk::label $f1.txt1 -text [mc "Increment by"]] -column 0 -row 1 -pady 2p
    grid [ttk::entry $f1.ent1 -width 5] -column 1 -row 1 -sticky w -pady 2p
    grid [ttk::label $f1.txt1a -text [mc "days"]] -column 2 -row 1 -sticky w -pady 2p
    
    set f2 [ttk::frame $d.f2 -padding 5]
    pack $f2 -anchor se
    
    #ea::sched::code::writeDateType $f1.cbx0 $f1.ent0; destroy $d
    grid [ttk::button $f2.btn1 -text [mc "Cancel"] -command [list destroy $d]] -column 0 -row 0 -padx 3p
    grid [ttk::button $f2.btn2 -text [mc "OK"] -command "ea::sched::code::writeFrequency $f1.ent0 $f1.ent1; destroy $d"] -column 1 -row 0 -padx 3p
}

