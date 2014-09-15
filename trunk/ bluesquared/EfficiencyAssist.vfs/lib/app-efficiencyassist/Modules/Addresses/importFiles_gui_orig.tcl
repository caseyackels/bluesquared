# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 338 $
# $LastChangedBy: casey.ackels $
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

package provide eAssist_importFiles 1.0


namespace eval eAssist_GUI {

proc eAssistGUI {} {
    #****f* eAssistGUI/eAssist_GUI
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
    #	eAssist::parentGUI
    #
    # NOTES
    #	Global Array
    #   GS_job / Number, Name, pieceWeight, fullBoxQty, Date, Version
    #   GS_ship / shipVia
    #   GS_address / Consignee, Company, addrThree, addrTwo, deliveryAddr, City, State, Zip, Phone
    #   GS_file / Name
    #
    # SEE ALSO
    #	TODO: List the other *GUI procs.
    #
    #***
    global GS_job GS_ship GS_address GS_file program customer3P settings currentModule program
    
    set program(currentModule) Addresses
    set currentModule Addresses
    
    # Clear the frames before continuing
    eAssist_Global::resetFrames parent



    
# Frame 1 - Listbox only
    set frame1 [ttk::labelframe .container.frame1 -text [mc "Unassigned File Headers"]]
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
## Frame2 (This is a container for four frames: Job, Address, Custonmer, Shipment)
#
    set frame2 [ttk::frame .container.frame2]
    pack $frame2 -expand yes -fill both -padx 5p -pady 5p -ipady 2p -anchor n -side top

#
## Frame2a (Label frame for Job Info)
#
    set frame2a [ttk::labelframe $frame2.frame2a -text [mc "Job Information"]]
    pack $frame2a -expand yes -fill both -anchor n ;#-padx 5p -pady 5p


    ttk::label $frame2a.jobNameField -text [mc "File Name"]
    ttk::label $frame2a.jobNameEntry -textvariable GS_file(Name)
        set GS_file(Name) "" ;# Initialize variable with dummy data, until we import a file.

    ttk::label $frame2a.jobNumberField -text [mc "Job Number"]
    ttk::entry $frame2a.jobNumberEntry -textvariable GS_job(Number)
        dropDest $frame2a.jobNumberEntry GS_job(Number)
        set GS_job(Number) ""
        
    ttk::label $frame2a.jobDescField -text [mc "Job Description"]
    ttk::entry $frame2a.jobDescEntry -textvariable GS_job(Description) \
                                        -validate key \
                                        -validatecommand {Disthelper_Helper::filterKeys %S %W %P}
        set GS_job(Description) ""
    ttk::label $frame2a.jobDescLengt -textvariable GS_job(DescLength)


    ttk::button $frame2a.jobNumberButton -text [mc "Import File"] -state active -command { eAssist_Helper::getAutoOpenFile $GS_job(Number) }



#
## Grid Frame2a
#
    grid $frame2a.jobNameField -column 0 -row 0 -sticky nse -padx 3p -pady 3p
    grid $frame2a.jobNameEntry -column 1 -row 0 -sticky news -padx 3p -pady 3p

    grid $frame2a.jobNumberField -column 0 -row 1 -sticky nse -padx 3p -pady 3p
    grid $frame2a.jobNumberEntry -column 1 -row 1 -sticky news -padx 3p -pady 3p
    
    grid $frame2a.jobDescField -column 0 -row 2 -sticky nse -padx 3p -pady 3p
    grid $frame2a.jobDescEntry -column 1 -row 2 -sticky news -padx 3p -pady 3p
    grid $frame2a.jobDescLengt -column 2 -row 2 -sticky news -padx 3p -pady 3p

    grid $frame2a.jobNumberButton -column 2 -row 1 -sticky news -padx 3p -ipadx 2p -pady 3p

    grid configure $frame2a.jobNameEntry -columnspan 2
    grid columnconfigure $frame2a 1 -weight 1


#
## Frame2b (Label frame for Address)
#
    set frame2b [ttk::labelframe $frame2.frame2b -text [mc "Address"]]
    pack $frame2b -expand yes -fill both -anchor n

    ttk::label $frame2b.addressCompanyField -text [mc "Company"]
    ttk::entry $frame2b.addressCompanyEntry -textvariable GS_address(Company) -state disabled
        dropDest $frame2b.addressCompanyEntry GS_address(Company)
        set GS_address(Company) ""

    ttk::label $frame2b.addressConsigneeField -text [mc "Attention"]
    ttk::entry $frame2b.addressConsigneeEntry -textvariable GS_address(Attention) -state disabled
        dropDest $frame2b.addressConsigneeEntry GS_address(Attention)
        set GS_address(Attention) ""

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
        
    ttk::label $frame2b.addressCountryField -text [mc "Country"]
    ttk::entry $frame2b.addressCountryEntry -textvariable GS_address(Country) -state disabled
        dropDest $frame2b.addressCountryEntry GS_address(Country)
        set GS_address(Country) ""


#
## Grid Frame2b
#
    grid $frame2b.addressCompanyField -column 0 -row 0 -sticky nse -padx 3p -pady 3p
    grid $frame2b.addressCompanyEntry -column 1 -row 0 -columnspan 5 -sticky news -padx 3p -pady 3p

    grid $frame2b.addressConsigneeField -column 0 -row 1 -sticky nse -padx 3p -pady 3p
    grid $frame2b.addressConsigneeEntry -column 1 -row 1 -columnspan 5 -sticky news -padx 3p -pady 3p

    grid $frame2b.addressDelAddrField -column 0 -row 2 -sticky nse -padx 3p -pady 3p
    grid $frame2b.addressDelAddrEntry -column 1 -row 2 -columnspan 5 -sticky news -padx 3p -pady 3p

    grid $frame2b.addressAddr2Field -column 0 -row 3 -sticky nse -padx 3p -pady 3p
    grid $frame2b.addressAddr2Entry -column 1 -row 3 -columnspan 5 -sticky news -padx 3p -pady 3p

    grid $frame2b.addressAddr3Field -column 0 -row 4 -sticky nse -padx 3p -pady 3p
    grid $frame2b.addressAddr3Entry -column 1 -row 4 -columnspan 5 -sticky news -padx 3p -pady 3p

    grid $frame2b.addressCityField -column 0 -row 5 -sticky nse -padx 3p -pady 3p
    grid $frame2b.addressCityEntry -column 1 -row 5 -sticky news -padx 2p -pady 3p

    grid $frame2b.addressStateField -column 2 -row 5 -sticky nse -padx 0p -pady 3p
    grid $frame2b.addressStateEntry -column 3 -row 5 -sticky news -padx 3p -pady 3p

    grid $frame2b.addressZipField -column 4 -row 5 -sticky nse -padx 0p -pady 3p
    grid $frame2b.addressZipEntry -column 5 -row 5 -sticky news -padx 3p -pady 3p

    grid $frame2b.addressPhoneField -column 0 -row 6 -sticky nse -padx 3p -pady 3p
    grid $frame2b.addressPhoneEntry -column 1 -row 6 -sticky news -padx 3p -pady 3p
    
    grid $frame2b.addressCountryField -column 2 -row 6 -sticky nse -padx 0p -pady 3p
    grid $frame2b.addressCountryEntry -column 3 -row 6 -columnspan 4 -sticky news -padx 3p -pady 3p

    grid columnconfigure $frame2b 1 -weight 1


#
## Frame2c (Label frame for Shipment)
#

    set frame2c [ttk::labelframe $frame2.frame2c -text [mc "Customer"]]
    pack $frame2c -expand yes -fill both -anchor n

    if {![info exists customer3P(name)]} {set customer3P(name) ""} ;# if we don't have any customers set up, just use a blank entry for the value.
    ttk::label $frame2c.thirdPartyCodeField -text [mc "3rd Party Code"]
    ttk::combobox $frame2c.thirdPartyCodeCombo -width 10 \
                            -values $customer3P(name) \
                            -state disabled \
                            -textvariable GS_job(3rdPartyName)
        #dropDest $frame2c.thirdPartyCodeCombo GS_job(3rdPartyCode)
        set GS_job(3rdPartyName) ""
        
        
    #ttk::label $frame2c.thirdPartyField -text [mc "3rd Party Acct."]
    #ttk::entry $frame2c.thirdPartyEntry -textvariable GS_job(3rdParty) -state disabled
    #    dropDest $frame2c.thirdPartyEntry GS_job(3rdParty)
    #    set GS_job(3rdParty) ""
        


    ttk::label $frame2c.emailField -text [mc "Email"]
    ttk::entry $frame2c.emailEntry -textvariable GS_job(Email) -state disabled
        dropDest $frame2c.emailEntry GS_job(Email)
        set GS_job(Email) ""


    grid $frame2c.emailField -column 0 -row 0 -sticky nse -padx 3p -pady 5p
    grid $frame2c.emailEntry -column 1 -row 0 -sticky ew -padx 3p

    grid $frame2c.thirdPartyCodeField -column 2 -row 0 -sticky nse -padx 3p -pady 3p
    grid $frame2c.thirdPartyCodeCombo -column 3 -row 0 -sticky ew -padx 3p

    grid columnconfigure $frame2c 1 -weight 1
    
    # ToolTips
    tooltip::tooltip $frame2c.thirdPartyCodeCombo "Customer ID Number from Process Shipper"
    #tooltip::tooltip $frame2c.thirdPartyField "Account Number"

#
## Frame2d (Label frame for Shipment)
#
    set frame2d [ttk::labelframe $frame2.frame2d -text [mc "Shipment"]]
    pack $frame2d -expand yes -fill both -anchor n

    ttk::label $frame2d.shipmentDateField -text [mc "Date"] -foreground red
    ttk::entry $frame2d.shipmentDateEntry -textvariable GS_job(Date) -state disabled
        dropDest $frame2d.shipmentDateEntry GS_job(Date)
        set GS_job(Date) ""

    ttk::label $frame2d.shipmentVersionField -text [mc "Version"]
    ttk::entry $frame2d.shipmentVersionEntry -textvariable GS_job(Version) -state disabled
        dropDest $frame2d.shipmentVersionEntry GS_job(Version)
        set GS_job(Version) ""

    ttk::label $frame2d.shipmentShipViaField -text [mc "Ship Via"] 
    ttk::entry $frame2d.shipmentShipViaEntry -textvariable GS_ship(shipVia) -state disabled
        dropDest $frame2d.shipmentShipViaEntry GS_ship(shipVia)
        set GS_ship(shipVia) ""

    ttk::label $frame2d.shipmentQuantityField -text [mc "Shipment Qty"]
    ttk::entry $frame2d.shipmentQuantityEntry -textvariable GS_job(Quantity) -state disabled
        dropDest $frame2d.shipmentQuantityEntry GS_job(Quantity)
        set GS_job(Quantity) ""

    ttk::label $frame2d.shipmentPieceWeightField -text [mc "Piece Weight"] -foreground red
    ttk::entry $frame2d.shipmentPieceWeightEntry -textvariable GS_job(pieceWeight) -state disabled
        dropDest $frame2d.shipmentPieceWeightEntry GS_job(pieceWeight)
        set GS_job(pieceWeight) ""

    ttk::label $frame2d.shipmentFullBoxField -text [mc "Full Box Qty"] -foreground red
    ttk::entry $frame2d.shipmentFullBoxEntry -textvariable GS_job(fullBoxQty) -state disabled
        dropDest $frame2d.shipmentFullBoxEntry GS_job(fullBoxQty)
        set GS_job(fullBoxQty) ""

#
## Grid Frame2b
#
    grid $frame2d.shipmentDateField -column 0 -row 0 -sticky nse -padx 3p -pady 3p
    grid $frame2d.shipmentDateEntry -column 1 -row 0 -sticky ew

    grid $frame2d.shipmentVersionField -column 2 -row 0 -sticky nse -padx 3p -pady 3p
    grid $frame2d.shipmentVersionEntry -column 3 -row 0 -sticky ew -padx 3p

    grid $frame2d.shipmentShipViaField -column 0 -row 1 -sticky nse -padx 3p -pady 5p
    grid $frame2d.shipmentShipViaEntry -column 1 -row 1 -sticky ew

    grid $frame2d.shipmentQuantityField -column 2 -row 1 -sticky nse -padx 3p -pady 5p
    grid $frame2d.shipmentQuantityEntry -column 3 -row 1 -sticky ew -padx 3p

    grid $frame2d.shipmentPieceWeightField -column 0 -row 2 -sticky nse -padx 3p -pady 5p
    grid $frame2d.shipmentPieceWeightEntry -column 1 -row 2 -sticky ew

    grid $frame2d.shipmentFullBoxField -column 2 -row 2 -sticky nse -padx 3p -pady 5p
    grid $frame2d.shipmentFullBoxEntry -column 3 -row 2 -sticky ew -padx 3p

    grid columnconfigure $frame2d 1 -weight 1


##
## - Bindings
##
#ttk::style configure TEntry -fieldbackground [list focus yellow]
#ttk::style map TEntry -fieldbackground [list focus yellow]

bind $frame2d.shipmentShipViaEntry <KeyRelease> "eAssist_Helper::detectData $frame2d.shipmentShipViaEntry $frame2d.shipmentShipViaField shipVia"
bind $frame2d.shipmentDateEntry <KeyRelease> "eAssist_Helper::detectData $frame2d.shipmentDateEntry $frame2d.shipmentDateField shipDate"
bind $frame2d.shipmentPieceWeightEntry <KeyRelease> "eAssist_Helper::detectData $frame2d.shipmentPieceWeightEntry $frame2d.shipmentPieceWeightField pieceWeight"
bind $frame2d.shipmentFullBoxEntry <KeyRelease> "eAssist_Helper::detectData $frame2d.shipmentFullBoxEntry $frame2d.shipmentFullBoxField fullBox"

#bind all <<ComboboxSelected>> {
#    Shipping_Code::readHistory [$frame1.entry1 current]
#}

#bind $frame1.listbox <Double-1> {puts "Selection: [$frame1.listbox curselection]"}
#bind $frame1.listbox <ButtonRelease-1> {
#    puts "Selection: [.container.frame1.listbox get [.container.frame1.listbox curselection]]"
#}


bind all <Escape> {exit}
bind all <F1> {console show}
bind all <F2> {console hide}

focus $frame2a.jobNumberEntry

bind $frame2a.jobNumberEntry <Return> "$frame2a.jobNumberButton invoke"
bind $frame2a.jobNumberButton <Return> "$frame2a.jobNumberButton invoke"

bind $frame2a.jobDescEntry <KeyPress> {
    if {[string length $GS_job(Description)] > 0} {
        if {[string length $GS_job(Description)] <= 35} {
            set GS_job(DescLength) [string length $GS_job(Description)]
        }
    }
}

#ttk::style map TEntry -fieldbackground [list focus yellow]


} ;# End of disthelperGUI

proc dropDest {window txtVar} {
    #****f* dropDest/eAssist_GUI
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
    #	eAssist_GUI::eAssistGUI
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
} ;# End of eAssist_GUI namespace