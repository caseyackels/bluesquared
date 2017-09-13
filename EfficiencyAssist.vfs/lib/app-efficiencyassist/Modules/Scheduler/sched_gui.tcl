# Scheduler Module
# a tool that assists in creating schedules, and responding to clients prior to the work entering the facility.
# essentially a prescheduler.

# Namespaces (app, module, categroy)
#   ea::sched::code {}
#   ea::sched::gui {}
#   ea::sched::db {}

package provide eAssist_ModScheduler 1.0

# Register with the DB
ea::sched::db::regWithDB

proc ea::sched::code::initvars_sched {} {
    global sched schedr schedr_setup
    
    if {[array exists schedr]} {
        unset schedr
    }
    
    #set schedr(machines,press) [list {12 M130} {13 M500} {14 S2000 Side 1} {16 S2000 Tandem}]
    set schedr_setup(machines,press) [list 12 13 14 16]
    #set schedr(machines,postpress) [list {9 "Polybag Bind"} {18 "MBO Folder"} {19 "UV Coater"} {34 "Handwork"} {17 "ITOH Cutter"} {22 "Offline Mail"} {33 "Outside Service"}]
    set schedr_setup(machines,postpress) [list 9 18 19 34 17 22 33]
    #set schedr(machines,bindery) [list {5 "Harris H2"} {6 SP2200} {3 "Stitcher 41"} {7 "UB"} {4 "Harris 1"}]
    set schedr_setup(machines,bindery) [list 5 6 3 7 4]
    
    ## This array is temporary and is reset frequently.
    # Required for report layout
    set schedr(machine,cccode) ""
    set schedr(machine,name) ""
    set schedr(day) ""
    set schedr(time) ""
    set schedr(taskcount) ""
    set schedr(cc_type) ""
    set schedr(pjnumber) ""
    
    # data on report
    set schedr(customer) ""
    set schedr(title) ""
    set schedr(name) ""
    set schedr(issueid) ""
    set schedr(number) ""
    set schedr(qty) ""
    set schedr(colors) ""
    set schedr(specialop) ""

    




}   
#    # This is the order that they exist in the database (Table: sched_DateType)
#    array set sched [list avoid_weekend 0 \
#                    avoid_plantHoliday 0 \
#                    avoid_freightHoliday 0 \
#                    avoid_USPSHoliday 0]


ea::sched::code::initvars_sched
#
proc ea::sched::gui::schedGUI {} {
#    global log
#    
#    # Clear the frames before continuing
#    eAssist_Global::resetFrames parent

###
### Job Info
###
    set f0 [ttk::labelframe .container.frame0 -text [mc "Job Info"] -padding 10]
    pack $f0 -expand yes -fill x -pady 5p -padx 5p
    
    grid [ttk::label $f0.browsetxt -text [mc "File"]] -column 0 -row 0 -pady 2p -padx 2p -sticky e
    grid [ttk::entry $f0.fileentry] -column 1 -row 0 -pady 2p -padx 2p -sticky ew
    grid [ttk::button $f0.browsebtn -text [mc "Browse..."]] -column 2 -row 0 -pady 2p -padx 2p -sticky w
}

#    
#    grid [ttk::label $f0.txtEstimate -text [mc "Estimate"]] -column 0 -row 0 -pady 2p -padx 2p -sticky e
#    grid [ttk::entry $f0.entEstimate] -column 1 -row 0 -pady 2p -padx 2p
#    
#    grid [ttk::label $f0.txtCustomer -text [mc "Customer"]] -column 0 -row 1 -pady 2p -padx 2p -sticky e
#    grid [ttk::entry $f0.entCustomer] -column 1 -row 1 -pady 2p -padx 2p
#    
#    grid [ttk::label $f0.txtTitle -text [mc "Title"]] -column 0 -row 2 -pady 2p -padx 2p -sticky e
#    grid [ttk::entry $f0.entTitle] -column 1 -row 2 -pady 2p -padx 2p
#    
#    grid [ttk::label $f0.txtFreq -text [mc "Frequency"]] -column 2 -row 0 -pady 2p -padx 2p -sticky e
#    grid [ttk::combobox $f0.cbxFreq -state disable] -column 3 -row 0 -pady 2p -padx 2p
#    
#    grid [ttk::label $f0.txtNum -text [mc "Num. Schedules"]] -column 2 -row 1 -pady 2p -padx 2p -sticky e
#    grid [ttk::entry $f0.entNum -width 5] -column 3 -row 1 -pady 2p -padx 2p -sticky w
#    
#    grid [ttk::label $f0.txtWorkflow -text [mc "Workflow"]] -column 2 -row 2 -pady 2p -padx 2p -sticky e
#    grid [ttk::combobox $f0.cbxWorkflow -state disable] -column 3 -row 2 -pady 2p -padx 2p
#    
#    grid [ttk::label $f0.txtDisc -text [mc "Disclaimer"]] -column 2 -row 3 -pady 2p -padx 2p -sticky e
#    grid [ttk::combobox $f0.cbxDisc -values {disclaimer1 disclaimer2}] -column 3 -row 3 -pady 2p -padx 2p
#    
###
### Options
###
#    #set f1 [ttk::labelframe .container.frame1 -text [mc "Options"] -padding 10]
#    #pack $f1 -fill x -pady 5p -padx 5p
#    
#
#
###
### Dates
###
#    set f2 [ttk::labelframe .container.frame2 -text [mc "Dates"] -padding 10]
#    pack $f2 -expand yes -fill both -pady 5p -padx 5p
#    
#    set dateTypes [ea::sched::db::getAllGroupNames -n]
#    
#    for {set x 0} {$x < 9} {incr x} {
#        
#        set col 0
#        grid [ttk::combobox $f2.cbox$x -values $dateTypes] -column $col -row $x
#        
#        incr col
#        grid [ttk::button $f2.btn$x -text "Cal" -width 3 -command "ea::sched::code::showDateChooser . $f2.ent$x"] -column $col -row $x
#        
#        incr col
#        grid [ttk::entry $f2.ent$x -width 10 -state readonly] -column $col -row $x
#        
#        incr col
#        grid [ttk::checkbutton $f2.ckbtn$x] -column $col -row $x
#        }
#        
###
### Buttons
###
#    set f3 [ttk::frame .container.frame3 -padding 10]
#    pack $f3 -expand yes -fill x -pady 5p -padx 5p
#    
#    grid [ttk::button $f3.gen -text [mc "Generate"]] -column 0 -row 0 -pady 5p -padx 5p
#
#
#
###
### - Code
###
###
#proc ea::sched::code::showDateChooser {w wid_entry} {
#    global log
#
#    set date [date::choose $w]
#    
#    # Set widget to editable
#    $wid_entry configure -state normal
#    $wid_entry insert end $date
#    ${log}::debug Inserting into widget: $date
#    
#    #set widget to non-editable
#    $wid_entry configure -state readonly
#    
#    #insert into db
#    set day [lindex [split $date /] 0]
#    if {[string length $day] == 1} {
#        set day 0$day
#    }
#    
#    set month [lindex [split $date /] 1]
#    if {[string length $month] == 1} {
#        set month 0$month
#    }
#    
#    set year [lindex [split $date /] 2]
#    
#    ${log}::debug Inserting into DB: $year-$day-$month
#}
