# Creator: Casey Ackels
# File Initial Date: 07 07,2015

proc eAssistSetup::company_GUI {{widType embed}} {
    #****f* company_GUI/eAssistSetup
    # CREATION DATE
    #   07/07/2015 (Tuesday Jul 07)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #
    #
    # USAGE
    #   eAssistSetup::company_GUI embed|standalone
    #
    # FUNCTION
    #	Creates the Company setup window in Setup
    #
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #
    #
    # EXAMPLE
    #   eAssistSetup::company_GUI
    #
    # NOTES
    #
    #
    # SEE ALSO
    #
    #
    #***
    global log G_setupFrame masterAddr company

    switch -- $widType {
        "embed"       {
                        eAssist_Global::resetSetupFrames ;# Reset all frames so we start clean
                        set win $G_setupFrame
                        eAssistSetup::populateCompanyArray ;# In this mode, we will be editing the Company not any other addresses
        }
        "standalone"  {
                        if {[winfo exists .companySetup] == 1} {destroy .companySetup}
                        set win .companySetup
                        toplevel $win
                        wm transient $win .
                        wm title $win [mc "Master Addresses"]
                        set locX [expr {[winfo screenwidth .] / 4}]
                        set locY [expr {[winfo screenheight .] / 4}]
                        wm geometry $win +${locX}+${locY}

                        # We are adding a new entry; clear out masterAddr array
                        ea::db::reset_masterAddr
        }
        default     {${log}::debug [info level 0] not a valid option for the switch statement: $widType}
    }

    ##
    ## Frame setup
    ##
    #-------- Container Address fields frame
    set fa0 [ttk::labelframe $win.fa0 -text [mc "Company Address"]]
    pack $fa0 -expand yes -fill both -pady 5p -padx 5p

    #-------- Address fields frame
    set fa1 [ttk::frame $fa0.fa1]
    grid $fa1 -column 0 -row 0 -sticky news -padx 2p -pady 2p

    #-------- Change/Update button
    set fa2 [ttk::frame $fa0.fa2]
    grid $fa2 -column 1 -row 1 -sticky se -padx 2p -pady 2p


    #-------- Carrier accounts main frame
    set fc0 [ttk::labelframe $win.fc0 -text [mc "Carrier Accounts"]]
    pack $fc0 -expand yes -fill both -pady 5p -padx 5p

    set fc1 [ttk::frame $fc0.fc1] ;# frame for the add/delete buttons
    grid $fc1 -column 0 -row 0 -sticky e

    set fc2 [ttk::frame $fc0.fc2] ;# Frame for the tablelist
    grid $fc2 -column 0 -row 1 -sticky news

    #-------- Button frame
    set fb0 [ttk::frame $win.fb0]
    pack $fb0 -anchor sw -pady 5p -padx 5p -anchor se

    ## Address fields
    ##
    grid [ttk::label $fa1.txt_company -text [mc "Company"]] -column 0 -row 0 -padx 2p -pady 2p -sticky nse
    grid [ttk::entry $fa1.entry_company -textvariable masterAddr(Company) -width 35] -column 1 -columnspan 3 -row 0 -padx 2p -pady 2p -sticky news

    if {$widType eq "standalone"} {
        grid [ttk::checkbutton $fa1.ckbtn_active -text [mc "Active"] -variable masterAddr(Active)] -column 4 -row 0 -padx 2p -pady 2p -sticky nsw
        grid [ttk::checkbutton $fa1.ckbtn_internal -text [mc "Internal"] -variable masterAddr(Internal)] -column 4 -row 1 -padx 2p -pady 2p -sticky nsw
    } else {
        # if we aren't standalone we are editing the 'ship from' address; and that will also be internal, so we need to set the var
        set masterAddr(Internal) 1
        set masterAddr(Active) 1
    }

    grid [ttk::label $fa1.txt_attention -text [mc "Attention/Phone"]] -column 0 -row 1 -padx 2p -pady 2p -sticky nse
    grid [ttk::entry $fa1.entry_attention -textvariable masterAddr(Attn)] -column 1 -columnspan 2  -row 1 -padx 2p -pady 2p -sticky news
    grid [ttk::entry $fa1.entry_phone -textvariable masterAddr(Phone)] -column 3 -row 1 -padx 2p -pady 2p -sticky news

    grid [ttk::label $fa1.txt_addr -text [mc "Address"]] -column 0 -row 2 -padx 2p -pady 2p -sticky nse
    grid [ttk::entry $fa1.entry_addr1 -textvariable masterAddr(Addr1)] -column 1 -columnspan 3  -row 2 -padx 2p -pady 2p -sticky news
    grid [ttk::entry $fa1.entry_addr2 -textvariable masterAddr(Addr2)] -column 1 -columnspan 3  -row 3 -padx 2p -pady 2p -sticky news
    grid [ttk::entry $fa1.entry_addr3 -textvariable masterAddr(Addr3)] -column 1 -columnspan 3  -row 4 -padx 2p -pady 2p -sticky news

    grid [ttk::label $fa1.txt_city -text [mc "City"]] -column 0 -row 5 -padx 2p -pady 2p -sticky nse
    grid [ttk::entry $fa1.entry_city -textvariable masterAddr(City)] -column 1 -columnspan 3 -row 5 -padx 2p -pady 2p -sticky news

    grid [ttk::label $fa1.txt_stateZip -text [mc "State/Zip"]] -column 0 -row 6 -padx 2p -pady 2p -sticky nse
    grid [ttk::entry $fa1.entry_state -textvariable masterAddr(StateAbbr) -width 4] -column 1 -row 6 -padx 2p -pady 2p -sticky nws
    grid [ttk::entry $fa1.entry_zip -textvariable masterAddr(Zip)] -column 2 -columnspan 2 -row 6 -padx 2p -pady 2p -sticky ew

    grid [ttk::label $fa1.txt_country -text [mc "Country Code"]] -column 0 -row 7 -padx 2p -pady 2p -sticky nse
    grid [ttk::entry $fa1.entry_country -textvariable masterAddr(CtryCode) -width 4] -column 1 -row 7 -padx 2p -pady 2p -sticky nws

    # Make all children read-only
    foreach child [winfo child $fa1] {
        ${log}::debug child winfo $child
        $child configure -state readonly
    }

    grid [ttk::button $fa2.btn -text [mc "Change"] -command [list eAssistSetup::editCompany $fa1 normal $fa2.btn]] -column 4



    ## Carrier Accounts
    ##

    grid [ttk::label $fc1.txtCarrier -text [mc "Carrier"]] -sticky e
    grid [ttk::label $fc1.txtAccount -text [mc "Account #"]] -sticky e
    grid [ttk::entry $fc1.carrier -validate all \
                                    -validatecommand [list AutoComplete::AutoComplete %W %d %v %P [db eval "SELECT Name from Carriers ORDER BY Name"]]
                                    ] -column 1 -row 0 -sticky ew
    grid [ttk::entry $fc1.account] -column 1 -row 1 -sticky ew
    grid [ttk::button $fc1.btnAdd -text [mc "Add"] -command [list eAssistSetup::editCarrier $fc2.tbl $fc1.carrier $fc1.account]] -column 2 -row 0 -sticky w
    grid [ttk::button $fc1.btnDel -text [mc "Delete"] -command [list eAssistSetup::deleteCarrier $fc2.tbl]] -column 2 -row 1 -sticky w

    grid columnconfigure $fc1 1 -weight 1

    tablelist::tablelist $fc2.tbl -columns {
                                            0 ... center
                                            0 Carrier center
                                            0 Account center
                                        } \
                                        -showlabels yes \
                                        -stripebackground yellow \
                                        -showseparators yes \
                                        -fullseparators yes
    $fc2.tbl columnconfigure 0 -showlinenumbers yes
    $fc2.tbl columnconfigure 1 -width 20
    $fc2.tbl columnconfigure 2 -stretch yes

    grid $fc2.tbl -column 0 -columnspan 2 -row 1 -padx 2p -pady 2p -sticky news
    grid columnconfigure $fc2 0 -weight 1
        set bodyTag [$fc2.tbl bodytag]
        bind $bodyTag <Double-1> "eAssistSetup::modifyCarrier $fc2.tbl $fc1.carrier $fc1.account"

    # Only create if we are in standalone mode
    if {$widType eq "standalone"} {
        # Buttons
        #grid [ttk::button $fb0.ok -text [mc "OK"] -command {}] -column 0 -row 0 -sticky w
        grid [ttk::button $fb0.cncl -text [mc "Close"] -command {destroy $win} ] -column 1 -row 0 -sticky e
    }

    # Populate tablelist widget
    eAssistSetup::populateCarrierTbl $fc2.tbl

} ;# eAssistSetup::company_GUI standalone
