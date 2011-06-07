# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision$
# $LastChangedBy$
# $LastChangedDate$
#
########################################################################################

##
## - Overview
# This file holds the parent GUI for Distribution Helper

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

## Coding Conventions
# - Namespaces: 

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

package provide disthelper_importFiles 1.0


namespace eval Disthelper_GUI {

proc disthelperGUI {} {
    #****f* disthelperGUI/Disthelper_Gui
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Builds the GUI of the Import Files Module, with bindings
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	disthelper::parentGUI
    #
    # NOTES
    #	Global Array
    #   GS_job / Number, Name, pieceWeight, fullBoxQty, Date, Version
    #   GS_ship / shipVia
    #   GS_address / Consignee, Company, addrThree, addrTwo, deliveryAddr, City, State, Zip, Phone
    #
    # SEE ALSO
    #	TODO: List the other *GUI procs.
    #
    #***
    global GS_job GS_ship GS_address

    wm title . [mc "Efficiency Assist"]
    focus -force .
    


# Frame 1 - Listbox only
    set frame1 [ttk::labelframe .container.frame1 -text [mc "File Headers"]]
    pack $frame1 -fill both -padx 5p -pady 5p -ipady 2p -anchor nw -side left
    
    listbox $frame1.listbox \
                -width 30 \
                -selectbackground yellow \
                -selectforeground black \
                -exportselection yes \
                -selectmode single \
                -yscrollcommand [list $frame1.scrolly set] \
                -xscrollcommand [list $frame1.scrollx set]
    
    ::tkdnd::drag_source register $frame1.listbox
    bind $frame1.listbox <<DragInitCmd>> \
      {list {copy move} DND_Text {[.container.frame1.listbox get [.container.frame1.listbox curselection]]}}
    

    ttk::scrollbar $frame1.scrolly -orient v -command [list $frame1.listbox yview]
    ttk::scrollbar $frame1.scrollx -orient h -command [list $frame1.listbox xview]
    
    grid $frame1.listbox -column 0 -row 0 -sticky news -padx 5p -pady 5p
    grid columnconfigure $frame1 $frame1.listbox -weight 1
    grid rowconfigure $frame1 $frame1.listbox -weight 1
    
    grid $frame1.scrolly -column 1 -row 0 -sticky nse
    grid $frame1.scrollx -column 0 -row 1 -sticky ews
    
    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $frame1.scrolly
    ::autoscroll::autoscroll $frame1.scrollx


#
## Frame 1a (Just a frame to hold some text for people who are new to DH)
#

    set frame1a [ttk::frame .container.frame1a]
    
    ttk::label $frame1a.tips1 -text [mc "Type a job number in the entry field then press 'Import File'."] -foreground red
    ttk::label $frame1a.tips2 -text [mc "If the fields aren't assigned automatically you may drag and drop the values,"] -foreground blue
    
    grid $frame1a.tips1 -column 0 -row 1 -sticky nsw
    grid $frame1a.tips2 -column 0 -row 2 -sticky nsw
    
    pack $frame1a -expand yes -fill both -padx 5p -ipady 2p -anchor n -side top


#    
## Frame2 (This is a container for three frames: Job, Address, Shipment)
#
    set frame2 [ttk::frame .container.frame2]
    pack $frame2 -expand yes -fill both -padx 5p -pady 5p -ipady 2p -anchor n -side top

#    
## Frame2a (Label frame for Job Info)
#
    set frame2a [ttk::labelframe $frame2.frame2a -text [mc "Job Information"]]
    pack $frame2a -expand yes -fill both -anchor n ;#-padx 5p -pady 5p
    
    
    ttk::label $frame2a.jobNumberField -text [mc "Job Number"]
    ttk::entry $frame2a.jobNumberEntry -textvariable GS_job(Number)
        dropDest $frame2a.jobNumberEntry GS_job(Number)
        set GS_job(Number) ""
    
    ttk::button $frame2a.jobNumberButton -text [mc "Import File"] -state active -command { Disthelper_Helper::getAutoOpenFile $GS_job(Number) }
    
   

#
## Grid Frame2a
#
    grid $frame2a.jobNumberField -column 0 -row 0 -sticky nse -padx 5p -pady 5p
    grid $frame2a.jobNumberEntry -column 1 -row 0 -sticky news -padx 5p -pady 5p
    
    grid $frame2a.jobNumberButton -column 2 -row 0 -sticky news -padx 5p -pady 5p
    
    grid columnconfigure $frame2a 1 -weight 1
    grid columnconfigure $frame2a 2 -weight 1

    
#    
## Frame2b (Label frame for Address)
#
    set frame2b [ttk::labelframe $frame2.frame2b -text [mc "Address"]]
    pack $frame2b -expand yes -fill both -anchor n
   
    ttk::label $frame2b.addressCompanyField -text [mc "Company"]
    ttk::entry $frame2b.addressCompanyEntry -textvariable GS_address(Company) -state disabled 
        dropDest $frame2b.addressCompanyEntry GS_address(Company)
        set GS_address(Company) ""
        
    ttk::label $frame2b.addressConsigneeField -text [mc "Consignee / Attn To:"]
    ttk::entry $frame2b.addressConsigneeEntry -textvariable GS_address(Consignee) -state disabled 
        dropDest $frame2b.addressConsigneeEntry GS_address(Consignee)
        set GS_address(Consignee) ""
        
    ttk::label $frame2b.addressDelAddrField -text [mc "Delivery Address"]
    ttk::entry $frame2b.addressDelAddrEntry -textvariable GS_address(deliveryAddr) -state disabled 
        dropDest $frame2b.addressDelAddrEntry GS_address(deliveryAddr)
        set GS_address(deliveryAddr) ""
        
    ttk::label $frame2b.addressAddr2Field -text [mc "Address 2"]
    ttk::entry $frame2b.addressAddr2Entry -textvariable GS_address(addrTwo) -state disabled 
        dropDest $frame2b.addressAddr2Entry GS_address(addrTwo)
        set GS_address(addrTwo) ""
        
    ttk::label $frame2b.addressAddr3Field -text [mc "Address 3"]
    ttk::entry $frame2b.addressAddr3Entry -textvariable GS_address(addrThree) -state disabled 
        dropDest $frame2b.addressAddr3Entry GS_address(addrThree)
        set GS_address(addrThree) ""
    
    
    ttk::label $frame2b.addressCityField -text [mc "City"]
    ttk::entry $frame2b.addressCityEntry -textvariable GS_address(City) -state disabled 
        dropDest $frame2b.addressCityEntry GS_address(City)
        set GS_address(City) ""
    
    ttk::label $frame2b.addressStateField -text [mc "State"] 
    ttk::entry $frame2b.addressStateEntry -textvariable GS_address(State) -width 5 -state disabled 
        dropDest $frame2b.addressStateEntry GS_address(State)
        set GS_address(State) ""
    
    ttk::label $frame2b.addressZipField -text [mc "Zip"] 
    ttk::entry $frame2b.addressZipEntry -textvariable GS_address(Zip) -width 9 -state disabled 
        dropDest $frame2b.addressZipEntry GS_address(Zip)
        set GS_address(Zip) ""
    
    ttk::label $frame2b.addressPhoneField -text [mc "Phone"]
    ttk::entry $frame2b.addressPhoneEntry -textvariable GS_address(Phone) -state disabled 
        dropDest $frame2b.addressPhoneEntry GS_address(Phone)
        set GS_address(Phone) ""
    
    
#
## Grid Frame2b
#
    grid $frame2b.addressCompanyField -column 0 -row 0 -sticky nse -padx 5p -pady 3p
    grid $frame2b.addressCompanyEntry -column 1 -row 0 -columnspan 5 -sticky news -padx 3p -pady 3p

    grid $frame2b.addressConsigneeField -column 0 -row 1 -sticky nse -padx 5p -pady 3p
    grid $frame2b.addressConsigneeEntry -column 1 -row 1 -columnspan 5 -sticky news -padx 3p -pady 3p
    
    grid $frame2b.addressDelAddrField -column 0 -row 2 -sticky nse -padx 5p -pady 3p
    grid $frame2b.addressDelAddrEntry -column 1 -row 2 -columnspan 5 -sticky news -padx 3p -pady 3p
    
    grid $frame2b.addressAddr2Field -column 0 -row 3 -sticky nse -padx 5p -pady 3p
    grid $frame2b.addressAddr2Entry -column 1 -row 3 -columnspan 5 -sticky news -padx 3p -pady 3p
    
    grid $frame2b.addressAddr3Field -column 0 -row 4 -sticky nse -padx 5p -pady 3p
    grid $frame2b.addressAddr3Entry -column 1 -row 4 -columnspan 5 -sticky news -padx 3p -pady 3p
    
    grid $frame2b.addressCityField -column 0 -row 5 -sticky nse -padx 5p -pady 3p
    grid $frame2b.addressCityEntry -column 1 -row 5 -sticky news -padx 2p -pady 3p
    
    grid $frame2b.addressStateField -column 2 -row 5 -sticky nse -padx 0p -pady 3p
    grid $frame2b.addressStateEntry -column 3 -row 5 -sticky news -padx 3p -pady 3p
    
    grid $frame2b.addressZipField -column 4 -row 5 -sticky nse -padx 0p -pady 3p
    grid $frame2b.addressZipEntry -column 5 -row 5 -sticky news -padx 3p -pady 3p
    
    grid $frame2b.addressPhoneField -column 0 -row 6 -sticky nse -padx 5p -pady 3p
    grid $frame2b.addressPhoneEntry -column 1 -row 6 -columnspan 5 -sticky news -padx 3p -pady 3p
    
    grid columnconfigure $frame2b 1 -weight 1


#    
## Frame2c (Label frame for Shipment)
#
    set frame2c [ttk::labelframe $frame2.frame2c -text [mc "Shipment"]]
    pack $frame2c -expand yes -fill both -anchor n
    
    ttk::label $frame2c.shipmentDateField -text [mc "Date"]
    ttk::entry $frame2c.shipmentDateEntry -textvariable GS_job(Date) -state disabled 
        dropDest $frame2c.shipmentDateEntry GS_job(Date)
        set GS_job(Date) ""
    
    ttk::label $frame2c.shipmentVersionField -text [mc "Version"]
    ttk::entry $frame2c.shipmentVersionEntry -textvariable GS_job(Version) -state disabled 
        dropDest $frame2c.shipmentVersionEntry GS_job(Version)
        set GS_job(Version) ""

    ttk::label $frame2c.shipmentShipViaField -text [mc "Ship Via"]
    ttk::entry $frame2c.shipmentShipViaEntry -textvariable GS_ship(shipVia) -state disabled 
        dropDest $frame2c.shipmentShipViaEntry GS_ship(shipVia)
        set GS_ship(shipVia) ""
    
    ttk::label $frame2c.shipmentQuantityField -text [mc "Shipment Qty"]
    ttk::entry $frame2c.shipmentQuantityEntry -textvariable GS_job(Quantity) -state disabled 
        dropDest $frame2c.shipmentQuantityEntry GS_job(Quantity)
        set GS_job(Quantity) ""
    
    ttk::label $frame2c.shipmentPieceWeightField -text [mc "Piece Weight"] -foreground red
    ttk::entry $frame2c.shipmentPieceWeightEntry -textvariable GS_job(pieceWeight) -state disabled 
        dropDest $frame2c.shipmentPieceWeightEntry GS_job(pieceWeight)
        set GS_job(pieceWeight) ""
    
    ttk::label $frame2c.shipmentFullBoxField -text [mc "Full Box Qty"] -foreground red
    ttk::entry $frame2c.shipmentFullBoxEntry -textvariable GS_job(fullBoxQty) -state disabled 
        dropDest $frame2c.shipmentFullBoxEntry GS_job(fullBoxQty)
        set GS_job(fullBoxQty) ""
    
#
## Grid Frame2b
#
    grid $frame2c.shipmentDateField -column 0 -row 0 -sticky nse -padx 5p -pady 3p
    grid $frame2c.shipmentDateEntry -column 1 -row 0 -sticky ew
    
    grid $frame2c.shipmentVersionField -column 2 -row 0 -sticky nse -padx 5p -pady 3p
    grid $frame2c.shipmentVersionEntry -column 3 -row 0 -sticky ew -padx 5p
    
    grid $frame2c.shipmentShipViaField -column 0 -row 1 -sticky nse -padx 5p -pady 5p
    grid $frame2c.shipmentShipViaEntry -column 1 -row 1 -sticky ew
    
    grid $frame2c.shipmentQuantityField -column 2 -row 1 -sticky nse -padx 5p -pady 5p
    grid $frame2c.shipmentQuantityEntry -column 3 -row 1 -sticky ew -padx 5p
    
    grid $frame2c.shipmentPieceWeightField -column 0 -row 2 -sticky nse -padx 5p -pady 5p
    grid $frame2c.shipmentPieceWeightEntry -column 1 -row 2 -sticky ew
    
    grid $frame2c.shipmentFullBoxField -column 2 -row 2 -sticky nse -padx 5p -pady 5p
    grid $frame2c.shipmentFullBoxEntry -column 3 -row 2 -sticky ew -padx 5p
    
    grid columnconfigure $frame2c 1 -weight 1


##
## - Bindings
##
#ttk::style configure TEntry -fieldbackground [list focus yellow]
#ttk::style map TEntry -fieldbackground [list focus yellow]

#bind $frame2c.shipmentShipViaEntry <KeyRelease> "Disthelper_Helper::detectData $frame2c.shipmentShipViaEntry $frame2c.shipmentShipViaField shipVia"
bind $frame2c.shipmentPieceWeightEntry <KeyRelease> "Disthelper_Helper::detectData $frame2c.shipmentPieceWeightEntry $frame2c.shipmentPieceWeightField pieceWeight"
bind $frame2c.shipmentFullBoxEntry <KeyRelease> "Disthelper_Helper::detectData $frame2c.shipmentFullBoxEntry $frame2c.shipmentFullBoxField fullBox"

#bind all <<ComboboxSelected>> {
#    Shipping_Code::readHistory [$frame1.entry1 current]
#}

#bind $frame1.listbox <Double-1> {puts "Selection: [$frame1.listbox curselection]"}
#bind $frame1.listbox <ButtonRelease-1> {
#    puts "Selection: [.container.frame1.listbox get [.container.frame1.listbox curselection]]"
#}

editPopup

bind all <Escape> {exit}
bind all <F1> {console show}
bind all <F2> {console hide}

focus $frame2a.jobNumberEntry

bind $frame2a.jobNumberEntry <Return> "$frame2a.jobNumberButton invoke"
bind $frame2a.jobNumberButton <Return> "$frame2a.jobNumberButton invoke"

ttk::style map TEntry -fieldbackground [list focus yellow]


} ;# End of disthelperGUI

proc dropDest {window txtVar} {
    #****f* dropDest/Disthelper_GUI
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Operates the bindings for Drag N Drop
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	Disthelper_GUI::disthelperGUI
    #
    # NOTES
    #
    # SEE ALSO
    #	
    #
    #***
    global gui_Entry
    
    tkdnd::drop_target register $window DND_Text
    bind $window <<DragEnter>> {list copy} 
    bind $window <<Drop>> {%W insert end [.container.frame1.listbox get [.container.frame1.listbox curselection]]}
    
    
    bind $window <ButtonPress-3> {tk_popup .editPopup %X %Y}

}
} ;# End of Disthelper_GUI namespace