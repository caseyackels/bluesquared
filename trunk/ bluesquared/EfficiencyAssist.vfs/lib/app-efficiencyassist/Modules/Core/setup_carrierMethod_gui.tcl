# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 01 19,2014
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 169 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2011-10-17 16:11:20 -0700 (Mon, 17 Oct 2011) $
#
########################################################################################

##
## - Overview
# Setup Carrier Methods

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


proc eAssistSetup::carrierMethod_GUI {} {
    #****f* carrierMethod_GUI/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Add/Remove and Configure Carrier Methods
    #
    # SYNOPSIS
    #
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global G_setupFrame log carrierSetup
    
    eAssist_Global::resetSetupFrames ;# Reset all frames so we start clean
    
    #-------- Container Frame
    set frame0 [ttk::label $G_setupFrame.frame0]
    pack $frame0 -expand yes -fill both -pady 5p -padx 5p
    
    ##
    ## Notebook
    ##
    
    set w(carrier) [ttk::notebook $frame0.carrierNotebook]
    pack $w(carrier) -expand yes -fill both
    
    ttk::notebook::enableTraversal $w(carrier)
    
    #
    # Setup the notebook
    #
    $w(carrier) add [ttk::frame $w(carrier).ctbl] -text [mc "Build Carrier Tables"]
    $w(carrier) add [ttk::frame $w(carrier).bcarrier] -text [mc "Build Carrier"] -state disabled
    $w(carrier) add [ttk::frame $w(carrier).bshipvia] -text [mc "Build Ship Via"] -state disabled
    $w(carrier) add [ttk::frame $w(carrier).frtrates] -text [mc "Freight Rates"] -state disabled
    $w(carrier) add [ttk::frame $w(carrier).upsrates] -text [mc "UPS Rates"] -state disabled
    $w(carrier) add [ttk::frame $w(carrier).fedexrates] -text [mc "FedEx Rates"] -state disabled
    
    $w(carrier) select $w(carrier).ctbl
    ##
    ## Tab 1 (Build Carrier Tables)
    ##
    
    # --- Frame 1 Payment Types
    set f1 [ttk::labelframe $w(carrier).ctbl.f1 -text [mc "Payment Types"]]
    grid $f1 -column 0 -row 0 -pady 5p -padx 5p
    
    ttk::entry $f1.entry -textvariable carrierSetup(enterPaymentType)
    ttk::button $f1.add -text [mc "Add"] -command "eAssistSetup::addCarrierSetup PAYMENT $f1.entry $f1.lbox"
    
    listbox $f1.lbox
    ttk::button $f1.del -text [mc "Delete"] -command "eAssistSetup::delCarrierSetup PAYMENT $f1.lbox"
    
    grid $f1.entry -column 0 -row 0
    grid $f1.add -column 1 -row 0 -sticky new
    grid $f1.lbox -column 0 -row 1 -sticky news
    grid $f1.del -column 1 -row 1 -sticky new
    
    # Populate the listbox if we have existing data
    if {[info exists carrierSetup(PaymentType)] == 1} {
        foreach item $carrierSetup(PaymentType) {
            $f1.lbox insert end $item
        }
    }
    
    # --- Frame 2, Shipment Type
    set f2 [ttk::labelframe $w(carrier).ctbl.f2 -text [mc "Shipment Type"]]
    grid $f2 -column 1 -row 0 -pady 5p -padx 5p
    
    ttk::entry $f2.entry -textvariable carrierSetup(enterShipmentType)
    ttk::button $f2.add -text [mc "Add"] -command "eAssistSetup::addCarrierSetup SHIPMENT $f2.entry $f2.lbox"
    
    listbox $f2.lbox
    ttk::button $f2.del -text [mc "Delete"] -command "eAssistSetup::delCarrierSetup SHIPMENT $f2.lbox"
    
    grid $f2.entry -column 0 -row 0
    grid $f2.add -column 1 -row 0 -sticky new
    grid $f2.lbox -column 0 -row 1 -sticky news
    grid $f2.del -column 1 -row 1 -sticky new
    
    # Populate the listbox if we have existing data
    if {[info exists carrierSetup(ShipmentType)] == 1} {
        foreach item $carrierSetup(ShipmentType) {
            $f2.lbox insert end $item
        }
    }
    
    # --- Frame 3, Carriers
    set f3 [ttk::labelframe $w(carrier).ctbl.f3 -text [mc "Carriers"]]
    grid $f3 -column 0 -row 1 -pady 5p -padx 5p
    
    ttk::entry $f3.entry -textvariable carrierSetup(enterCarrier)
    ttk::button $f3.add -text [mc "Add"] -command "eAssistSetup::addCarrierSetup CARRIERS $f3.entry $f3.lbox"
    
    listbox $f3.lbox
    ttk::button $f3.del -text [mc "Delete"] -command "eAssistSetup::delCarrierSetup CARRIERS $f3.lbox"
    
    grid $f3.entry -column 0 -row 0
    grid $f3.add -column 1 -row 0 -sticky new
    grid $f3.lbox -column 0 -row 1 -sticky news
    grid $f3.del -column 1 -row 1 -sticky new
    

    # Populate the listbox if we have existing data
    if {[info exists carrierSetup(CarrierList)] == 1} {
        foreach item $carrierSetup(CarrierList) {
            $f3.lbox insert end $item
        }
    }
    
    # --- Frame 4, Rate Types
    set f4 [ttk::labelframe $w(carrier).ctbl.f4 -text [mc "Rate Types"]]
    grid $f4 -column 1 -row 1 -pady 5p -padx 5p
    
    ttk::entry $f4.entry -textvariable carrierSetup(enterRateType)
    ttk::button $f4.add -text [mc "Add"] -command "eAssistSetup::addCarrierSetup RATES $f4.entry $f4.lbox"
    
    listbox $f4.lbox
    ttk::button $f4.del -text [mc "Delete"] -command "eAssistSetup::delCarrierSetup RATES $f4.lbox"
    
    grid $f4.entry -column 0 -row 0
    grid $f4.add -column 1 -row 0 -sticky new
    grid $f4.lbox -column 0 -row 1 -sticky news
    grid $f4.del -column 1 -row 1 -sticky new

    # Populate the listbox if we have existing data
    if {[info exists carrierSetup(RateType)] == 1} {
        foreach item $carrierSetup(RateType) {
            $f4.lbox insert end $item
        }
    }
    
} ;# eAssistSetup::carrierMethod_GUI