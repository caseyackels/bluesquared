# Creator: Casey Ackels (C) 2017

package provide eAssist_ModLoadFlags 1.0

proc ea::gui::lf::loadFlagGUI {} {
#    global log
#    
#    # Clear the frames before continuing
    eAssist_Global::resetFrames parent

###
### Job Info
###
    # Job Number, Shipment ID
    # Job Desc (get from Db)
    set f0 [ttk::labelframe .container.frame0 -text [mc "Job Info"] -padding 10]
    pack $f0 -fill x -pady 5p -padx 5p ;#-anchor n
    
    grid [ttk::label $f0.jobNum -text [mc "Job Number/Ship ID"]] -column 0 -row 0 -pady 2p -padx 2p -sticky e
    grid [ttk::entry $f0.jobNumEntry] -column 1 -row 0 -pady 2p -padx 2p -sticky w
    grid [ttk::entry $f0.jobIDEntry] -column 2 -row 0 -pady 2p -padx 2p -sticky w
    grid [ttk::button $f0.getData -text [mc "Get Data..."]] -column 3 -row 0 -pady 2p -padx 2p -sticky w
    
    grid [ttk::label $f0.jobDesc1 -text [mc "Job Description"]] -column 0 -row 1 -pady 2p -padx 2p -sticky e
    grid [ttk::label $f0.jobDesc2] -column 1 -row 1 -pady 2p -padx 2p -sticky w
    
###
### Shipment Info
###
    
    set f1 [ttk::labelframe .container.frame1 -text [mc "Shipment Info"] -padding 10]
    pack $f1 -fill x -pady 5p -padx 5p ;#-anchor n
    
    grid [ttk::label $f1.destName -text [mc "Destination Name"]] -column 0 -row 0 -pady 2p -padx 2p -sticky e
    grid [ttk::label $f1.destNameTxt] -column 1 -row 0 -pady 2p -padx 2p -sticky w
    
    grid [ttk::label $f1.version -text [mc "Version"]] -column 0 -row 1 -pady 2p -padx 2p -sticky e
    grid [ttk::label $f1.versionTxt] -column 1 -row 1 -pady 2p -padx 2p -sticky w
    
    grid [ttk::label $f1.shipQty -text [mc "Shipment Qty"]] -column 0 -row 2 -pady 2p -padx 2p -sticky e
    grid [ttk::label $f1.shipQtyTxt] -column 1 -row 2 -pady 2p -padx 2p -sticky w
    
    grid [ttk::label $f1.boxQty -text [mc "Box/Bundle Qty"]] -column 0 -row 3 -pady 2p -padx 2p -sticky e
    grid [ttk::entry $f1.boxQtyEntry] -column 1 -row 3 -pady 2p -padx 2p -sticky w
    
    grid [ttk::label $f1.boxLayer -text [mc "Box/Bundle per Layer"]] -column 0 -row 4 -pady 2p -padx 2p -sticky e
    grid [ttk::entry $f1.boxLayerEntry] -column 1 -row 4 -pady 2p -padx 2p -sticky w
    
    grid [ttk::label $f1.layers -text [mc "Num. of Layers"]] -column 0 -row 5 -pady 2p -padx 2p -sticky e
    grid [ttk::entry $f1.layerEntry] -column 1 -row 5 -pady 2p -padx 2p -sticky w

###
### Options
###
    
    set f2 [ttk::labelframe .container.frame2 -text [mc "Options"] -padding 10]
    pack $f2 -fill x -pady 5p -padx 5p ;#-anchor n
    
    grid [ttk::checkbutton $f2.combinePallet -text [mc "Combine last pallet"]] -column 0 -row 0 -pady 2p -padx 2p -sticky w
    grid [ttk::checkbutton $f2.blindShip -text [mc "Blind Shipment"]] -column 0 -row 1 -pady 2p -padx 2p -sticky w
    # Combine last pallet with last full pallet
    
}