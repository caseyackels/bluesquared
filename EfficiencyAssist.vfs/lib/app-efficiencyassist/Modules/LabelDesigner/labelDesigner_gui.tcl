# Creator: Casey Ackels (C) 2017

package provide eAssist_ModLabelDesigner 1.0

proc ea::gui::designerGUI {} {
#    global log
#    
#    # Clear the frames before continuing
    eAssist_Global::resetFrames parent

###
### Job Info
###
    set f0 [ttk::labelframe .container.frame0 -text [mc "Job Info"] -padding 10]
    pack $f0 -expand yes -fill x -pady 5p -padx 5p
    
    grid [ttk::label $f0.browsetxt -text [mc "File"]] -column 0 -row 0 -pady 2p -padx 2p -sticky e
    grid [ttk::entry $f0.fileentry] -column 1 -row 0 -pady 2p -padx 2p -sticky ew
    grid [ttk::button $f0.browsebtn -text [mc "Browse..."]] -column 2 -row 0 -pady 2p -padx 2p -sticky w
}