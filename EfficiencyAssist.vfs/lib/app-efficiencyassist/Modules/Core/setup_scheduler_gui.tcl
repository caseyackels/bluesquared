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
    pack $f1 -fill both -anchor n -pady 5p -padx 5p

    grid [listbox $f1.lbox] -column 0 -row 0 -rowspan 8 -pady 2p -padx 2p -sticky news
    grid [ttk::button $f1.add -text [mc "Add"] -command ea::sched::gui::addDateType] -column 1 -row 0 -pady 0p -padx 2p -sticky new
    grid [ttk::button $f1.edit -text [mc "Edit"]] -column 1 -row 2 -pady 0p -padx 2p -sticky new
    grid [ttk::button $f1.del -text [mc "Delete"]] -column 1 -row 3 -pady 0p -padx 2p -sticky new
    
    
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

proc ea::sched::gui::addDateType {} {
    global log sched
    
    if {[winfo exists .d]} {destroy .d}
    set d [toplevel .d -class Dialog]
    wm title $d [mc "Setup Date Types"]
    wm transient $d .
    catch {wm attributes $d -type dialog}
    
    update idletasks
        
    set f1 [ttk::frame $d.f1 -padding 10]
    pack $f1 -expand yes -fill both

    grid [ttk::label $f1.txt0 -text [mc "Date Type Name"]] -column 0 -row 0 -sticky e
    grid [ttk::entry $f1.ent0] -column 1 -row 0 -sticky ew
        focus $f1.ent0
        
    grid [ttk::label $f1.txt1 -text [mc "Avoid"]] -column 0 -row 1 -sticky e
    grid [ttk::checkbutton $f1.ckbtn0 -text [mc "Weekend"] -variable sched(avoid_weekend)] -column 1 -row 2 -sticky w
    grid [ttk::checkbutton $f1.ckbtn1 -text [mc "Freight Holiday"] -variable sched(avoid_holiday)] -column 1 -row 3 -sticky w
    grid [ttk::checkbutton $f1.ckbtn2 -text [mc "USPS Holiday"] -variable sched(avoid_USPSHoliday)] -column 1 -row 4 -sticky w
    
    set f2 [ttk::frame $d.f2 -padding 5]
    pack $f2 -anchor se
    
    grid [ttk::button $f2.btn1 -text [mc "Cancel"]] -column 0 -row 0 -padx 3p
    grid [ttk::button $f2.btn2 -text [mc "OK"]] -column 1 -row 0 -padx 3p
   
}