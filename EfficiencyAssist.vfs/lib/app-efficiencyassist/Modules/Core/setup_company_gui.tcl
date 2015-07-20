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
                        wm geometry $win 625x375+${locX}+${locY}
                        focus $win
        }
        default     {${log}::debug [info level 0] not a valid option for the switch statement: $widType}
    }
    
    ##
    ## Frame setup
    ##
    #-------- Address fields frame
    set fa0 [ttk::labelframe $win.fa0 -text [mc "Company Address"]]
    pack $fa0 -expand yes -fill both -pady 5p -padx 5p
    
    
    #-------- Carrier accounts frame
    set fc0 [ttk::labelframe $win.fc0 -text [mc "Carrier Accounts"]]
    pack $fc0 -expand yes -fill both -pady 5p -padx 5p
    
    #-------- Button frame
    # Initially see the "change" button. Once clicked, it changes to "OK". All fields start out 'disabled'
    set fb0 [ttk::frame $win.fb0]
    pack $fb0 -anchor sw -pady 5p -padx 5p
    
    ## Address fields
    ## 
    grid [ttk::label $fa0.txt_company -text [mc "Company"]] -column 0 -row 0 -padx 2p -pady 2p -sticky nse
    grid [ttk::entry $fa0.entry_company -textvariable masterAddr(Company) -width 35] -column 1 -columnspan 3 -row 0 -padx 2p -pady 2p -sticky news
    #grid [ttk::checkbutton $fa0.ckbtn_plant -text [mc "Plant"] -variable masterAddr(Plant)] -column 4 -row 0 -padx 2p -pady 2p -sticky nsw
    
    grid [ttk::label $fa0.txt_attention -text [mc "Attention/Phone"]] -column 0 -row 1 -padx 2p -pady 2p -sticky nse
    grid [ttk::entry $fa0.entry_attention -textvariable masterAddr(Attn)] -column 1 -columnspan 2  -row 1 -padx 2p -pady 2p -sticky news
    grid [ttk::entry $fa0.entry_phone -textvariable masterAddr(Phone)] -column 3 -row 1 -padx 2p -pady 2p -sticky news
    
    grid [ttk::label $fa0.txt_addr -text [mc "Address"]] -column 0 -row 2 -padx 2p -pady 2p -sticky nse
    grid [ttk::entry $fa0.entry_addr1 -textvariable masterAddr(Addr1)] -column 1 -columnspan 3  -row 2 -padx 2p -pady 2p -sticky news
    grid [ttk::entry $fa0.entry_addr2 -textvariable masterAddr(Addr2)] -column 1 -columnspan 3  -row 3 -padx 2p -pady 2p -sticky news
    grid [ttk::entry $fa0.entry_addr3 -textvariable masterAddr(Addr3)] -column 1 -columnspan 3  -row 4 -padx 2p -pady 2p -sticky news
    
    grid [ttk::label $fa0.txt_city -text [mc "City"]] -column 0 -row 5 -padx 2p -pady 2p -sticky nse
    grid [ttk::entry $fa0.entry_city -textvariable masterAddr(City)] -column 1 -columnspan 3 -row 5 -padx 2p -pady 2p -sticky news
    
    grid [ttk::label $fa0.txt_stateZip -text [mc "State/Zip"]] -column 0 -row 6 -padx 2p -pady 2p -sticky nse
    grid [ttk::entry $fa0.entry_state -textvariable masterAddr(StateAbbr) -width 4] -column 1 -row 6 -padx 2p -pady 2p -sticky nws
    grid [ttk::entry $fa0.entry_zip -textvariable masterAddr(Zip)] -column 2 -columnspan 2 -row 6 -padx 2p -pady 2p -sticky ew
    
    grid [ttk::label $fa0.txt_country -text [mc "Country Code"]] -column 0 -row 7 -padx 2p -pady 2p -sticky nse
    grid [ttk::entry $fa0.entry_country -textvariable masterAddr(CtryCode) -width 4] -column 1 -row 7 -padx 2p -pady 2p -sticky nws
     
    grid [ttk::checkbutton $fa0.ckbtn_active -text [mc "Active"] -variable masterAddr(Active)] -column 1 -columnspan 3 -row 8 -padx 2p -pady 2p -sticky nsw
    
    ## Carrier Accounts
    ##
    ## Frame $fc0
    grid [tablelist::tablelist $fc0.tbl -columns {
                                            0 ... center
                                            0 Carrier center
                                            0 Account center
                                        } \
                                        -showlabels yes \
                                        -stripebackground yellow \
                                        -showseparators yes \
                                        -fullseparators yes
                                        ] -column 0 -row 0 -padx 2p -pady 2p -sticky news
    
    $fc0.tbl columnconfigure 0 -showlinenumbers yes
    $fc0.tbl columnconfigure 2 -stretch yes
    
    ## Button
    ## 

} ;# eAssistSetup::company_GUI standalone
