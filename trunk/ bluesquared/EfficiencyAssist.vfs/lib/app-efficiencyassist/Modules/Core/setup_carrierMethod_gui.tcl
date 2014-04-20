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
    global f1 f2 f3 f4 f5 ;# Used for bindings only
    
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
    
    #
    # --- Frame 1 Payment Types
    #
    set f1 [ttk::labelframe $w(carrier).ctbl.f1 -text [mc "Payment Types"] -padding 10]
    grid $f1 -column 0 -row 0 -pady 5p -padx 5p -sticky new
    
    #grid columnconfigure $w(carrier).ctbl $f1 -weight 1
    #grid rowconfigure $w(carrier).ctbl $f1 -weight 1
    
    ttk::entry $f1.entry -textvariable carrierSetup(enterPaymentType)
        tooltip::tooltip $f1.entry [mc "Use the Enter Key to add items"]
    
    listbox $f1.lbox \
                    -yscrollcommand [list $f1.yPayment set] \
                    -xscrollcommand [list $f1.xPayment set]
        tooltip::tooltip $f1.lbox [mc "Use the Backspace Key to remove items"]
    
    
    # setup the Autoscrollbars
    ttk::scrollbar $f1.xPayment -orient horizontal -command [list $f1.lbox xview]
    ttk::scrollbar $f1.yPayment -orient vertical -command [list $f1.lbox yview]
     
    ::autoscroll::autoscroll $f1.xPayment ;# Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $f1.yPayment
    
    
    grid $f1.entry      -column 0 -row 0 -sticky news
    grid $f1.lbox       -column 0 -row 1 -sticky news
    grid $f1.yPayment   -column 1 -row 1 -sticky ens
    grid $f1.xPayment   -column 0 -row 2 -sticky esw
    
    
    grid columnconfigure $f1 $f1.lbox -weight 1
    grid rowconfigure $f1 $f1.lbox -weight 1

    bind $f1.entry <Return> {
        eAssistSetup::addCarrierSetup PAYMENT $f1.entry $f1.lbox
        # Always display the last entry
        $f3.lbox see end
    }
    
    bind $f1.entry <KP_Enter> {
        eAssistSetup::addCarrierSetup PAYMENT $f1.entry $f1.lbox
        # Always display the last entry
        $f3.lbox see end
    } ;# So both enter key's work the same way
    
    bind $f1.lbox <Delete> {
        eAssistSetup::delCarrierSetup PAYMENT $f1.lbox
    }
    
    bind $f1.lbox <BackSpace> {
        eAssistSetup::delCarrierSetup PAYMENT $f1.lbox
    }


    
    # Populate the listbox if we have existing data
    if {[info exists carrierSetup(PaymentType)] == 1} {
        foreach item $carrierSetup(PaymentType) {
            $f1.lbox insert end $item
        }
    }
    
    #
    # --- Frame 2, Shipment Type
    #
    set f2 [ttk::labelframe $w(carrier).ctbl.f2 -text [mc "Shipment Type"] -padding 10]
    grid $f2 -column 1 -row 0 -pady 5p -padx 5p -sticky new
    
    #grid columnconfigure $w(carrier).ctbl $f2 -weight 1
    #grid rowconfigure $w(carrier).ctbl $f2 -weight 1
    
    ttk::entry $f2.entry -textvariable carrierSetup(enterShipmentType)    
    listbox $f2.lbox \
                    -xscrollcommand [list $f2.xShipment set] \
                    -yscrollcommand [list $f2.xShipment set]
    
    # setup the Autoscrollbars
    ttk::scrollbar $f2.xShipment -orient h -command [list $f2.lbox xview]
    ttk::scrollbar $f2.yShipment -orient v -command [list $f2.lbox yview]
    
    grid $f2.entry      -column 0 -row 0 -sticky swe
    grid $f2.lbox       -column 0 -row 1 -sticky news
    grid $f2.xShipment  -column 0 -row 2 -sticky ews
    grid $f2.yShipment  -column 1 -row 1 -sticky ens
    
    ::autoscroll::autoscroll $f2.xShipment ;# Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $f2.yShipment
    
    grid columnconfigure $f2 $f2.lbox -weight 1
    grid rowconfigure $f2 $f2.lbox -weight 1
    
    # Bindings
    bind $f2.entry <Return> {
        eAssistSetup::addCarrierSetup SHIPMENT $f2.entry $f2.lbox
    }
    
    bind $f2.entry <KP_Enter> {
        # Keypad Enter key
        eAssistSetup::addCarrierSetup SHIPMENT $f2.entry $f2.lbox
    }
    
    bind $f2.lbox <Delete> {
        eAssistSetup::delCarrierSetup SHIPMENT $f2.lbox
    }
    
    bind $f2.lbox <BackSpace> {
        eAssistSetup::delCarrierSetup SHIPMENT $f2.lbox
    }
    
    # Populate the listbox if we have existing data
    if {[info exists carrierSetup(ShipmentType)] == 1} {
        foreach item $carrierSetup(ShipmentType) {
            $f2.lbox insert end $item
        }
    }
    
    #
    # --- Frame 3, Carriers
    #
    set f3 [ttk::labelframe $w(carrier).ctbl.f3 -text [mc "Carriers"] -padding 10]
    grid $f3 -column 2 -row 0 -pady 5p -padx 5p -sticky news
    
    #grid columnconfigure $w(carrier).ctbl $f3 -weight 1
    #grid rowconfigure $w(carrier).ctbl $f3 -weight 1
    
    ttk::entry $f3.entry -textvariable carrierSetup(enterCarrier)   
    listbox $f3.lbox \
                    -width 25 \
                    -xscrollcommand [list $f3.xCarriers set] \
                    -yscrollcommand [list $f3.yCarriers set]

    
    # setup the Autoscrollbars
    ttk::scrollbar $f3.xCarriers -orient h -command [list $f3.lbox xview]
    ttk::scrollbar $f3.yCarriers -orient v -command [list $f3.lbox yview]
    
    grid $f3.entry      -column 0 -row 0 -sticky swe
    grid $f3.lbox       -column 0 -row 1 -sticky news
    grid $f3.xCarriers  -column 0 -row 2 -sticky ews
    grid $f3.yCarriers  -column 1 -row 1 -sticky ens
    
    ::autoscroll::autoscroll $f3.xCarriers ;# Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $f3.yCarriers

    
    # Bindings
    bind $f3.entry <Return> {
        eAssistSetup::addCarrierSetup CARRIERS $f3.entry $f3.lbox
        # Always display the last entry
        $f3.lbox see end
    }
    
    bind $f3.entry <KP_Enter> {
        eAssistSetup::addCarrierSetup CARRIERS $f3.entry $f3.lbox
        # Always display the last entry
        $f3.lbox see end
    } ;# So both enter key's work the same way
    
    bind $f3.lbox <Delete> {
        eAssistSetup::delCarrierSetup CARRIERS $f3.lbox
    }
    
    bind $f3.lbox <BackSpace> {
        eAssistSetup::delCarrierSetup CARRIERS $f3.lbox
    }
    
    
    # Populate the listbox if we have existing data
    if {[info exists carrierSetup(CarrierList)] == 1} {
        foreach item $carrierSetup(CarrierList) {
            $f3.lbox insert end $item
        }
    }
    
    #
    # --- Frame 4, Rate Types
    #
    set f4 [ttk::labelframe $w(carrier).ctbl.f4 -text [mc "Rate Types"] -padding 10]
    grid $f4 -column 0 -row 1 -pady 5p -padx 5p -sticky news
    
    #grid columnconfigure $w(carrier).ctbl $f3 -weight 1
    #grid rowconfigure $w(carrier).ctbl $f3 -weight 1
    
    ttk::entry $f4.entry -textvariable carrierSetup(enterRateType)    
    listbox $f4.lbox \
                    -xscrollcommand [list $f4.xRateType set] \
                    -yscrollcommand [list $f4.yRateType set]

    # setup the Autoscrollbars
    ttk::scrollbar $f4.xRateType  -orient h -command [list $f4.lbox xview]
    ttk::scrollbar $f4.yRateType  -orient v -command [list $f4.lbox yview]
    
    ::autoscroll::autoscroll $f4.xRateType  ;# Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $f4.yRateType 
    
    grid $f4.entry      -column 0 -row 0 -sticky swe
    grid $f4.lbox       -column 0 -row 1 -sticky news
    grid $f4.xRateType  -column 0 -row 2 -sticky ews
    grid $f4.yRateType  -column 1 -row 1 -sticky ens

    # Bindings
    bind $f4.entry <Return> {
        eAssistSetup::addCarrierSetup RATES $f4.entry $f4.lbox
        # Always display the last entry
        $f3.lbox see end
    }
    
    bind $f4.entry <KP_Enter> {
        eAssistSetup::addCarrierSetup RATES $f4.entry $f4.lbox
        # Always display the last entry
        $f3.lbox see end
    } ;# So both enter key's work the same way
    
    bind $f4.lbox <Delete> {
        eAssistSetup::delCarrierSetup RATES $f4.lbox
    }
    
    bind $f4.lbox <BackSpace> {
        eAssistSetup::delCarrierSetup RATES $f4.lbox
    }
    
    # Populate the listbox if we have existing data
    if {[info exists carrierSetup(RateType)] == 1} {
        foreach item $carrierSetup(RateType) {
            $f4.lbox insert end $item
        }
    }
    
    
    #
    # --- Frame 5, Shipping Class
    #
    set f5 [ttk::labelframe $w(carrier).ctbl.f5 -text [mc "Shipping Class"] -padding 10]
    grid $f5 -column 1 -row 1 -pady 5p -padx 5p -sticky news
    
    ttk::entry $f5.entry -textvariable carrierSetup(enterShippingClass)    
    listbox $f5.lbox \
                    -xscrollcommand [list $f5.xShippingClass set] \
                    -yscrollcommand [list $f5.yShippingClass set]

    # setup the Autoscrollbars
    ttk::scrollbar $f5.xShippingClass  -orient h -command [list $f5.lbox xview]
    ttk::scrollbar $f5.yShippingClass  -orient v -command [list $f5.lbox yview]
    
    ::autoscroll::autoscroll $f5.xShippingClass  ;# Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $f5.yShippingClass
    
    grid $f5.entry           -column 0 -row 0 -sticky swe
    grid $f5.lbox            -column 0 -row 1 -sticky news
    grid $f5.xShippingClass  -column 0 -row 2 -sticky ews
    grid $f5.yShippingClass  -column 1 -row 1 -sticky ens

    # Bindings
    bind $f5.entry <Return> {
        eAssistSetup::addCarrierSetup SHIPPINGCLASS $f5.entry $f5.lbox
        # Always display the last entry
        $f3.lbox see end
    }
    
    bind $f5.entry <KP_Enter> {
        eAssistSetup::addCarrierSetup SHIPPINGCLASS $f5.entry $f5.lbox
        # Always display the last entry
        $f3.lbox see end
    } ;# So both enter key's work the same way
    
    bind $f5.lbox <Delete> {
        eAssistSetup::delCarrierSetup SHIPPINGCLASS $f5.lbox
    }
    
    bind $f5.lbox <BackSpace> {
        eAssistSetup::delCarrierSetup SHIPPINGCLASS $f5.lbox
    }
    
    # Populate the listbox if we have existing data
    if {[info exists carrierSetup(ShippingClass)] == 1} {
        foreach item $carrierSetup(ShippingClass) {
            $f5.lbox insert end $item
        }
    }
} ;# eAssistSetup::carrierMethod_GUI


#Remove buttons, and create bindings to the <Enter> key; <Delete> key, and a <Double-1> to delete
