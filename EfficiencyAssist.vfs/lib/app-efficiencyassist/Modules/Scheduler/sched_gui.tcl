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

set sched(avoid_weekend) 0
set sched(avoid_holiday) 0
set sched(avoid_USPSHoliday) 0

proc ea::sched::gui::schedGUI {} {

# Clear the frames before continuing
eAssist_Global::resetFrames parent

# Setup the Filter array
# eAssist_Global::launchFilters

# Set the vars
#importFiles::initVars

##
## Job Info
##
    set f0 [ttk::labelframe .container.frame0 -text [mc "Job Info"] -padding 10]
    pack $f0 -expand yes -fill x -pady 5p -padx 5p
    
    grid [ttk::label $f0.txtEstimate -text [mc "Estimate"]] -column 0 -row 0 -pady 2p -padx 2p -sticky e
    grid [ttk::entry $f0.entEstimate] -column 1 -row 0 -pady 2p -padx 2p
    
    grid [ttk::label $f0.txtCustomer -text [mc "Customer"]] -column 0 -row 1 -pady 2p -padx 2p -sticky e
    grid [ttk::entry $f0.entCustomer] -column 1 -row 1 -pady 2p -padx 2p
    
    grid [ttk::label $f0.txtTitle -text [mc "Title"]] -column 0 -row 2 -pady 2p -padx 2p -sticky e
    grid [ttk::entry $f0.entTitle] -column 1 -row 2 -pady 2p -padx 2p
    
    grid [ttk::label $f0.txtFreq -text [mc "Frequency"]] -column 2 -row 0 -pady 2p -padx 2p -sticky e
    grid [ttk::combobox $f0.cbxFreq -state disable] -column 3 -row 0 -pady 2p -padx 2p
    
    grid [ttk::label $f0.txtNum -text [mc "Num. Schedules"]] -column 2 -row 1 -pady 2p -padx 2p -sticky e
    grid [ttk::entry $f0.entNum -width 5] -column 3 -row 1 -pady 2p -padx 2p -sticky w
    
    grid [ttk::label $f0.txtWorkflow -text [mc "Workflow"]] -column 2 -row 2 -pady 2p -padx 2p -sticky e
    grid [ttk::combobox $f0.cbxWorkflow -state disable] -column 3 -row 2 -pady 2p -padx 2p
    
    grid [ttk::label $f0.txtDisc -text [mc "Disclaimer"]] -column 2 -row 3 -pady 2p -padx 2p -sticky e
    grid [ttk::combobox $f0.cbxDisc -values {disclaimer1 disclaimer2}] -column 3 -row 3 -pady 2p -padx 2p
    
##
## Options
##
    #set f1 [ttk::labelframe .container.frame1 -text [mc "Options"] -padding 10]
    #pack $f1 -fill x -pady 5p -padx 5p
    


##
## Dates
##
    set f2 [ttk::labelframe .container.frame2 -text [mc "Dates"] -padding 10]
    pack $f2 -expand yes -fill both -pady 5p -padx 5p
    
    set dateTypes [list "Print Order" \
                   "Files In" \
                   "Distribution" \
                   "Mail List" \
                   "Files Out to Vendor" \
                   "Proof Out" \
                   "Final Portal Approval" \
                   "Proof at Customer" \
                   "Customer Sends Back" \
                   "Proof Back" \
                   "OK To Plate" \
                   "Postage Due" \
                   "Ship"]
    
    for {set x 0} {$x < 9} {incr x} {
        
        set col 0
        grid [ttk::combobox $f2.cbox$x -values $dateTypes] -column $col -row $x
        incr col
        grid [ttk::entry $f2.ent$x] -column $col -row $x
        incr col
        grid [ttk::button $f2.btn$x -text "btn" -width 3] -column $col -row $x
        incr col
        grid [ttk::checkbutton $f2.ckbtn$x] -column $col -row $x
    
        }
        
##
## Buttons
##
    set f3 [ttk::frame .container.frame3 -padding 10]
    pack $f3 -expand yes -fill x -pady 5p -padx 5p
    
    grid [ttk::button $f3.gen -text [mc "Generate"]] -column 0 -row 0 -pady 5p -padx 5p
}