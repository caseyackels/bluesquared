# Creator: Casey Ackels
# Initial Date: April 8th, 2011
# Dependencies: See Below
#-------------------------------------------------------------------------------


#
#
# - NOT BEING USED --- This is legacy code that needs to be updated for EA.
#
#

#package provide eAssist_Preferences 1.0

namespace eval eAssist_Preferences {}

proc eAssist_Preferences::prefGUI {} {
    #****f* prefGUI/eAssist_Preferences
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #
    #
    # SYNOPSIS
    #	GUI for the preferences window
    #
    # CHILDREN
    #	eAssist_Preferences::chooseDir, eAssist_Preferences::saveConfig
    #
    # PARENTS
    #
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global settings tab3 header header_sorted customer3P internal mySettings international company shipVia3P intlSetup

    toplevel .preferences
    wm transient .preferences .
    wm title .preferences [mc "Options"]

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    wm geometry .preferences +${locX}+${locY}

    focus .preferences

    set header_sorted [lsort -dictionary [array names header]]

    ##
    ## Parent Frame
    ##
    set frame0 [ttk::frame .preferences.frame0]
    pack $frame0 -expand yes -fill both -pady 5p -padx 5p

    ##
    ## Notebook
    ##
    set nb [ttk::notebook $frame0.nb]
    pack $nb -expand yes -fill both


    $nb add [ttk::frame $nb.f1] -text [mc "File Paths"]
    $nb add [ttk::frame $nb.f2] -text [mc "Miscellaneous"]
    #$nb add [ttk::frame $nb.f3] -text [mc "Header Names"]
    $nb add [ttk::frame $nb.f4] -text [mc "3P Accounts"]
    #$nb add [ttk::frame $nb.f5] -text [mc "Company"]
    $nb add [ttk::frame $nb.f6] -text [mc "Int'l Defaults"]
    $nb select $nb.f1

    ttk::notebook::enableTraversal $nb

    ##
    ## Tab 1 (File Paths)
    ##
    if {![info exists settings(job,fileName)]} {set settings(job,fileName) "%number %title %name"}

    ttk::label $nb.f1.sourceText -text [mc "Source Import Files"]
    ttk::entry $nb.f1.sourceEntry -textvariable mySettings(sourceFiles)
    ttk::button $nb.f1.sourceButton -text ... -command {eAssist_Preferences::chooseDir sourceFiles}

    ttk::label $nb.f1.outFilesText -text [mc "Formatted Import Files"]
    ttk::entry $nb.f1.outFilesEntry -textvariable mySettings(outFilePath)
    ttk::button $nb.f1.outFilesButton -text ... -command {eAssist_Preferences::chooseDir outFilePath}

    ttk::label $nb.f1.outFilesCopyText -text [mc "Archive Files"]
    ttk::entry $nb.f1.outFilesCopyEntry -textvariable mySettings(outFilePathCopy)
    ttk::button $nb.f1.outFilesCopyButton -text ... -command {eAssist_Preferences::chooseDir outFilePathCopy}
    
    ttk::label $nb.f1.txt -text [mc "Output File Name"]
    ttk::entry $nb.f1.entry -textvariable settings(job,fileName)
    ttk::label $nb.f1.txt2 -text "%number (Job Number), %title (Job Title), %name (Job Name)"
    

    grid $nb.f1.sourceText -column 0 -row 0 -sticky e -padx 5p -pady 5p
    grid $nb.f1.sourceEntry -column 1 -row 0 -sticky ew -padx 5p -pady 5p
    grid $nb.f1.sourceButton -column 2 -row 0 -sticky e -padx 5p -pady 5p

    grid $nb.f1.outFilesText -column 0 -row 1 -sticky e -padx 5p -pady 5p
    grid $nb.f1.outFilesEntry -column 1 -row 1 -sticky ew -padx 5p -pady 5p
    grid $nb.f1.outFilesButton -column 2 -row 1 -sticky e -padx 5p -pady 5p

    grid $nb.f1.outFilesCopyText -column 0 -row 2 -sticky e -padx 5p -pady 5p
    grid $nb.f1.outFilesCopyEntry -column 1 -row 2 -sticky ew -padx 5p -pady 5p
    grid $nb.f1.outFilesCopyButton -column 2 -row 2 -sticky e -padx 5p -pady 5p
    
    grid $nb.f1.txt -column 0 -row 3 -sticky e -padx 5p -pady 5p
    grid $nb.f1.entry -column 1 -row 3 -sticky ew -padx 5p -pady 5p
    grid $nb.f1.txt2 -column 2 -row 3 -sticky e -padx 5p -pady 5p

    grid columnconfigure $nb.f1 1 -weight 2


    ##
    ## Tab 2 (Miscellaneous)
    ##

    set tab2a [ttk::labelframe $nb.f2.misc -text [mc "Miscellaneous"]]
    #pack $tab2a -fill both -expand yes -padx 5p -pady 5p
    grid $tab2a -column 0 -row 0 -padx 3p -pady 5p -sticky news

    ttk::label $tab2a.boxTareText -text [mc "Box Tare"]
    ttk::entry $tab2a.boxTareEntry -textvariable settings(BoxTareWeight)

    grid $tab2a.boxTareText -column 0 -row 0 -sticky e -padx 5p -pady 5p
    grid $tab2a.boxTareEntry -column 1 -row 0 -sticky ew -padx 5p -pady 5p
    
    set tab2b [ttk::labelframe $nb.f2.customer3p -text [mc "Third Party Ship Via Information"]]
    #pack $tab2b -expand yes -fill both -pady 5p -padx 5p
    grid $tab2b -column 0 -row 1 -padx 3p -pady 5p -sticky news
    #grid $tab4 -column 0 -row 0 -padx 5p -pady 5p -sticky news
    
    #ttk::label $tab2b.txt -text [mc "The customer code MUST match what is in the Shipping System."]

    set scrolly2 $tab2b.scrolly
    tablelist::tablelist $tab2b.listbox \
                -columns {
                        30 "Carrier"    left
                        10 "Ship Via"   center
                        3  "..."        center
                        } \
                -showlabels yes \
                -stretch 0 \
                -height 15 \
                -width 70 \
                -selectbackground yellow \
                -selectforeground black \
                -stripebackground lightblue \
                -exportselection yes \
                -showseparators yes \
                -fullseparators yes \
                -editstartcommand {eAssist_Preferences::startCmd} \
                -editendcommand {eAssist_Preferences::endCmd} \
                -yscrollcommand [list $scrolly2 set]
        
        $tab2b.listbox columnconfigure 0 -name "Carrier" \
                                            -editable yes \
                                            -editwindow ttk::combobox
        
        $tab2b.listbox columnconfigure 1 -name "Ship Via" \
                                            -editable yes \
                                            -editwindow ttk::entry

        
        $tab2b.listbox columnconfigure 2 -name "Delete" \
                                        -editable no
        
        set internal(table2,currentRow) 0
        if {[info exists shipVia3P(table)]} {
            #'debug Populate listobx - data exists
                foreach ShipVia $shipVia3P(table) {
                    $tab2b.listbox insert end $ShipVia
                    incr internal(table2,currentRow)
                }
        }

        # Create the first line
        $tab2b.listbox insert end ""
        
        ttk::scrollbar $scrolly2 -orient v -command [list $tab2b.listbox yview]
        
        grid $scrolly2 -column 1 -row 0 -sticky ns
        
        ::autoscroll::autoscroll $scrolly2 ;# Enable the 'autoscrollbar'
    #grid $tab2b.txt -column 0 -row 0 -padx 5p -pady 5p
    
    grid $tab2b.listbox -column 0 -row 1 -sticky news -padx 5p -pady 5p
    grid rowconfigure $tab2b $tab2b.listbox -weight 1
    
    $tab2b.listbox selection set 0
    $tab2b.listbox activate 0
    $tab2b.listbox see 0
    focus $tab2b.listbox

    ##
    ## Tab 3 (Header Names)
    ##

    #set tab3 [ttk::labelframe $nb.f3.importOrder -text [mc "Header Names"]]
    #grid $tab3 -column 0 -row 0 -padx 5p -pady 5p
    #
    #ttk::combobox $tab3.combo -width 20 \
    #                        -values $header_sorted \
    #                        -state readonly \
    #                        -textvariable parentHeader
    #
    ## Start out with displaying a header
    #$tab3.combo set [lrange $header_sorted 0 0]
    #
    #ttk::entry $tab3.entry -textvariable subHeader
    #ttk::button $tab3.add -text [mc "Add"] -command {catch {eAssist_Preferences::addSubHeader $parentHeader $subHeader}}
    #
    #listbox $tab3.listbox \
    #            -width 18 \
    #            -height 10 \
    #            -selectbackground yellow \
    #            -selectforeground black \
    #            -exportselection yes \
    #            -selectmode single \
    #            -yscrollcommand [list $tab3.scrolly set] \
    #            -xscrollcommand [list $tab3.scrollx set]
    #
    #ttk::scrollbar $tab3.scrolly -orient v -command [list $tab3.listbox yview]
    #ttk::scrollbar $tab3.scrollx -orient h -command [list $tab3.listbox xview]
    #
    ## Put the default values in
    #eAssist_Preferences::displayHeader [$tab3.combo current]
    #
    #ttk::button $tab3.del -text [mc "Remove"] -command  {eAssist_Preferences::removeSubHeader $parentHeader}
    #
    #grid $tab3.combo -column 0 -row 0 -sticky news -padx 3p -pady 3p
    #
    #grid $tab3.entry -column 0 -row 1 -sticky news -padx 3p -pady 3p
    #grid $tab3.add -column 1 -row 1 -sticky news -padx 2p -pady 3p
    #
    #grid $tab3.listbox -column 0 -row 2 -rowspan 8 -padx 3p -pady 3p -sticky news ;#-padx 5p -pady 5p
    #grid $tab3.scrolly -column 0 -row 2 -rowspan 8 -sticky nse
    #grid $tab3.scrollx -column 0 -row 2 -rowspan 8 -sticky sew
    #
    #grid $tab3.del -column 1 -row 2 -sticky new -padx 2p -pady 3p
    #
    ## Enable the 'autoscrollbar'
    #::autoscroll::autoscroll $tab3.scrolly
    #::autoscroll::autoscroll $tab3.scrollx
    

    ##
    ## Tab 4 (Customer List, for 3rd Party Accounts)
    ##
    set tab4 [ttk::labelframe $nb.f4.customer -text [mc "Customer Information"]]
    pack $tab4 -expand yes -fill both -pady 5p -padx 5p
    #grid $tab4 -column 0 -row 0 -padx 5p -pady 5p -sticky news
    
    ttk::label $tab4.txt -text [mc "The customer code MUST match what is in the Shipping System."]
    

    set scrolly $tab4.scrolly
    tablelist::tablelist $tab4.listbox \
                -columns {
                        30  "Name"    left
                        10    "Code"    center
                        10   "Account"  center
                        3  "..."    center
                        } \
                -showlabels yes \
                -stretch 0 \
                -height 15 \
                -width 70 \
                -selectbackground yellow \
                -selectforeground black \
                -stripebackground lightblue \
                -exportselection yes \
                -showseparators yes \
                -fullseparators yes \
                -editstartcommand {eAssist_Preferences::startCmd} \
                -editendcommand {eAssist_Preferences::endCmd} \
                -yscrollcommand [list $scrolly set]
        
        $tab4.listbox columnconfigure 0 -name Name \
                                            -labelalign center \
                                            -editable yes \
                                            -editwindow ttk::entry
        
        $tab4.listbox columnconfigure 1 -name Code \
                                            -editable yes \
                                            -editwindow ttk::entry
        
        $tab4.listbox columnconfigure 2 -name Account \
                                            -editable yes \
                                            -editwindow ttk::entry
        
        $tab4.listbox columnconfigure 3 -name Delete \
                                        -editable no
        
        set internal(table,currentRow) 0
        
        if {[info exists customer3P(table)]} {
            #'debug Populate listobx - data exists
                foreach customer $customer3P(table) {
                    #'debug inserting $customer
                    $tab4.listbox insert end $customer
                    incr internal(table,currentRow)
                }
        }

        # Create the first line
        $tab4.listbox insert end ""
        
        ttk::scrollbar $scrolly -orient v -command [list $tab4.listbox yview]
        
        grid $scrolly -column 1 -row 0 -sticky ns
        
        ::autoscroll::autoscroll $scrolly ;# Enable the 'autoscrollbar'
    grid $tab4.txt -column 0 -row 0 -padx 5p -pady 5p
    
    grid $tab4.listbox -column 0 -row 1 -sticky news -padx 5p -pady 5p
    grid rowconfigure $tab4 $tab4.listbox -weight 1
    
    $tab4.listbox selection set 0
    $tab4.listbox activate 0
    $tab4.listbox see 0
    focus $tab4.listbox
    
    ##
    ## Tab 5 (Company Info)
    ##
    #set tab5 [ttk::labelframe $nb.f5.company -text [mc "Company Information"]]
    #pack $tab5 -expand yes -fill both -pady 5p -padx 5p
    #
    #ttk::label $tab5.companyText -text [mc "Company Name"]
    #ttk::entry $tab5.companyEntry -textvariable company(name)
    #
    #ttk::label $tab5.contactText -text [mc "Contact"]
    #ttk::entry $tab5.contactEntry -textvariable company(contact)
    #
    #ttk::label $tab5.addr1Text -text [mc "AddressLine1"]
    #ttk::entry $tab5.addr1Entry -textvariable company(addr1)
    #
    #set company(addr2) ""
    #ttk::label $tab5.addr2Text -text [mc "AddressLine2"]
    #ttk::entry $tab5.addr2Entry -textvariable company(addr2)
    #
    #set company(addr3) ""
    #ttk::label $tab5.addr3Text -text [mc "AddressLine3"]
    #ttk::entry $tab5.addr3Entry -textvariable company(addr3)
    #
    #ttk::label $tab5.cityText -text [mc "City"]
    #ttk::entry $tab5.cityEntry -textvariable company(city)
    #
    #ttk::label $tab5.stateText -text [mc "State"]
    #ttk::entry $tab5.stateEntry -textvariable company(state)
    #
    #ttk::label $tab5.zipText -text [mc "Zip"]
    #ttk::entry $tab5.zipEntry -textvariable company(zip)
    #
    #ttk::label $tab5.phoneText -text [mc "Phone"]
    #ttk::entry $tab5.phoneEntry -textvariable company(phone)
    #
    ##set company(country) "US"
    #ttk::label $tab5.countryText -text [mc "Country"]
    #ttk::entry $tab5.countryEntry -textvariable company(country)
    #
    #
    ## Grid
    #grid $tab5.companyText -column 0 -row 0 -sticky e -pady 3p -padx 5p
    #grid $tab5.companyEntry -column 1 -row 0 -sticky ew
    #
    #grid $tab5.contactText -column 0 -row 1 -sticky e -pady 3p -padx 5p
    #grid $tab5.contactEntry -column 1 -row 1 -sticky ew
    #
    #grid $tab5.addr1Text -column 0 -row 2 -sticky e -pady 3p -padx 5p
    #grid $tab5.addr1Entry -column 1 -row 2 -sticky ew
    #
    #grid $tab5.addr2Text -column 0 -row 3 -sticky e -pady 3p -padx 5p
    #grid $tab5.addr2Entry -column 1 -row 3 -sticky ew
    #
    #grid $tab5.addr3Text -column 0 -row 4 -sticky e -pady 3p -padx 5p
    #grid $tab5.addr3Entry -column 1 -row 4 -sticky ew
    #
    #grid $tab5.cityText -column 0 -row 5 -sticky e -pady 3p -padx 5p
    #grid $tab5.cityEntry -column 1 -row 5 -sticky ew
    #
    #grid $tab5.stateText -column 0 -row 6 -sticky e -pady 3p -padx 5p
    #grid $tab5.stateEntry -column 1 -row 6 -sticky ew
    #
    #grid $tab5.zipText -column 0 -row 7 -sticky e -pady 3p -padx 5p
    #grid $tab5.zipEntry -column 1 -row 7 -sticky ew
    #
    #grid $tab5.phoneText -column 0 -row 8 -sticky e -pady 3p -padx 5p
    #grid $tab5.phoneEntry -column 1 -row 8 -sticky ew
    #
    #grid $tab5.countryText -column 0 -row 9 -sticky e -pady 3p -padx 5p
    #grid $tab5.countryEntry -column 1 -row 9 -sticky ew

    
    ##
    ## Tab 6 (International Defaults)
    ##
    set tab6 [ttk::labelframe $nb.f6.company -text [mc "International Defaults"]]
    pack $tab6 -expand yes -fill both -pady 5p -padx 5p
    
    set tab6_left [ttk::frame $tab6.left -relief ridge]
    pack $tab6_left -expand yes -fill both -side left  -pady 5p -padx 5p -ipady 3p -ipadx 3p

    set tab6_right [ttk::frame $tab6.right -relief ridge]
    pack $tab6_right -expand yes -fill both -side right -pady 5p -padx 5p -ipady 3p -ipadx 3p
    
    ########################################################
    
    #ItemDescription
        set international(itemDesc,check) 1
    ttk::label $tab6_left.itemDescText -text [mc "Item Description"]
    ttk::entry $tab6_left.itemDescEntry -textvariable international(itemDesc)
    ttk::checkbutton $tab6_left.itemDescCheck -text [mc "Use Default"] -variable international(itemDesc,check) \
                                                                        -command "eAssist_Helper::setIntlVarDefault itemDesc,check $tab6_left.itemDescEntry"
    $tab6_left.itemDescEntry configure -state disable
    
    grid $tab6_left.itemDescText -column 0 -row 0 -sticky e -padx 2p -pady 5p
    grid $tab6_left.itemDescEntry -column 1 -row 0 -sticky ew 
    grid $tab6_left.itemDescCheck -column 2 -row 0 -sticky e
    
    #ItemNumber
        set international(itemNum,check) 1
    ttk::label $tab6_left.itemNumText -text [mc "Item Number"]
    ttk::entry $tab6_left.itemNumEntry -textvariable international(itemNum)
    ttk::checkbutton $tab6_left.itemNumCheck -text [mc "Use Default"] -variable international(itemNum,check) \
                                                                        -command "eAssist_Helper::setIntlVarDefault itemNum,check $tab6_left.itemNumEntry"
    $tab6_left.itemNumEntry configure -state disable
    
    grid $tab6_left.itemNumText -column 0 -row 1 -sticky e -padx 2p -pady 2p
    grid $tab6_left.itemNumEntry -column 1 -row 1 -sticky ew
    grid $tab6_left.itemNumCheck -column 2 -row 1 -sticky e
    
    #ItemQuantity
        set international(itemQty,check) 1
    ttk::label $tab6_left.itemQtyText -text [mc "Item Quantity"]
    ttk::entry $tab6_left.itemQtyEntry -textvariable international(itemQty)
    ttk::checkbutton $tab6_left.itemQtyCheck -text [mc "Use Default"] -variable international(itemQty,check) \
                                                                        -command "eAssist_Helper::setIntlVarDefault itemQty,check $tab6_left.itemQtyEntry"
    $tab6_left.itemQtyEntry configure -state disable
    
    grid $tab6_left.itemQtyText -column 0 -row 2 -sticky e -padx 2p -pady 2p
    grid $tab6_left.itemQtyEntry -column 1 -row 2 -sticky ew
    grid $tab6_left.itemQtyCheck -column 2 -row 2 -sticky e
    
    #UOM
    ttk::label $tab6_left.uomText -text [mc "Unit of Measure"]
        # Set default
        set international(uom) Each
    ttk::combobox $tab6_left.uomCombo -textvariable international(uom) \
                                        -values $intlSetup(UOMList)
    
    $tab6_left.uomCombo configure -state readonly


    grid $tab6_left.uomText -column 0 -row 3 -sticky e -padx 2p -pady 2p
    grid $tab6_left.uomCombo -column 1 -row 3 -sticky ew
    
    #DutiesPayer
    ttk::label $tab6_left.dutiesPayerText -text [mc "Duties Payer"]
    #ttk::entry $tab6_left.dutiesPayerEntry -textvariable international(dutiesPayer)
        # set default
        set international(dutiesPayer) SENDER
    ttk::combobox $tab6_left.dutiesPayerCombo -textvariable international(dutiesPayer) \
                                        -values $intlSetup(PAYERList)
    $tab6_left.dutiesPayerCombo configure -state readonly

    
    grid $tab6_left.dutiesPayerText -column 0 -row 4 -sticky e -padx 2p -pady 2p
    grid $tab6_left.dutiesPayerCombo -column 1 -row 4 -sticky ew
    
    #DutiesPayerAccountNumber
    ttk::label $tab6_left.dutiesPayerAcctText -text [mc "Duties Payer Account Number"] -state disable
    ttk::entry $tab6_left.dutiesPayerAcctEntry -textvariable international(dutiesPayerAcct) -state disable
    
    grid $tab6_left.dutiesPayerAcctText -column 0 -row 5 -sticky e -padx 2p -pady 2p
    grid $tab6_left.dutiesPayerAcctEntry -column 1 -row 5 -sticky ew
    
    #License
    ttk::label $tab6_right.licenseText -text [mc "License"]
    #ttk::entry $tab6_right.licenseEntry -textvariable international(license)
        # Set Default
        set international(license) "NLR"
    ttk::combobox $tab6_right.licenseCombo -width 10 \
                                        -textvariable international(license) \
                                        -values $intlSetup(LICENSEList)
    $tab6_right.licenseCombo configure -state readonly

    
    grid $tab6_right.licenseText -column 0 -row 0 -sticky e -padx 2p -pady 5p
    grid $tab6_right.licenseCombo -column 1 -row 0 -sticky ew
    
    #LicenseDate
        set international(licenseDate,check) 1
    ttk::label $tab6_right.licenseDateText -text [mc "License Date"]
    ttk::entry $tab6_right.licenseDateEntry -textvariable international(licenseDate)
    ttk::checkbutton $tab6_right.licenseDateCheck -text [mc "Use Default"] -variable international(licenseDate,check) \
                                                                        -command "eAssist_Helper::setIntlVarDefault licenseDate,check $tab6_right.licenseDateEntry"
    $tab6_right.licenseDateEntry configure -state disable
    
    grid $tab6_right.licenseDateText -column 0 -row 1 -sticky e -padx 2p -pady 2p
    grid $tab6_right.licenseDateEntry -column 1 -row 1 -sticky ew
    grid $tab6_right.licenseDateCheck -column 2 -row 1 -sticky e
    
    #CountryOfOrigin
        # Set Default
        set international(countryOfOrigin) US
    ttk::label $tab6_right.countryOfOriginText -text [mc "Country of Origin"]
    ttk::entry $tab6_right.countryOfOriginEntry -textvariable international(countryOfOrigin)
    
    grid $tab6_right.countryOfOriginText -column 0 -row 2 -sticky e -padx 2p -pady 2p
    grid $tab6_right.countryOfOriginEntry -column 1 -row 2 -sticky ew
    
    #TermsOfShipment
        set international(termsOfShipment) DDP
    ttk::label $tab6_right.termsOfShipmentText -text [mc "Terms of Shipment"]
    ttk::combobox $tab6_right.termsOfSHipmentEntry -width 10 \
                                                    -textvariable international(termsOfShipment) \
                                                    -values $intlSetup(TERMSList)
    $tab6_right.termsOfSHipmentEntry configure -state readonly
    
    grid $tab6_right.termsOfShipmentText -column 0 -row 3 -sticky e -padx 2p -pady 2p
    grid $tab6_right.termsOfSHipmentEntry -column 1 -row 3 -sticky ew
    
    #UnitValue
        set international(unitValue) 1
    ttk::label $tab6_right.unitValueText -text [mc "Unit Value $"]
    ttk::entry $tab6_right.unitValueEntry -textvariable international(unitValue)
    
    grid $tab6_right.unitValueText -column 0 -row 4 -sticky e -padx 2p -pady 2p
    grid $tab6_right.unitValueEntry -column 1 -row 4 -sticky ew
    
    #ItemWeight
        set international(itemWeight,check) 1
    ttk::label $tab6_right.itemWeightText -text [mc "Item Weight"]
    ttk::entry $tab6_right.itemWeightEntry -textvariable international(itemWeight)
    ttk::checkbutton $tab6_right.itemWeightCheck -text [mc "Use Default"] -variable international(itemWeight,check) \
                                                                        -command "eAssist_Helper::setIntlVarDefault itemWeight,check $tab6_right.itemWeightEntry"
    $tab6_right.itemWeightEntry configure -state disable
    
    grid $tab6_right.itemWeightText -column 0 -row 5 -sticky e -padx 2p -pady 2p
    grid $tab6_right.itemWeightEntry -column 1 -row 5 -sticky ew
    grid $tab6_right.itemWeightCheck -column 2 -row 5 -sticky e
    
    #PackingType
    #ttk::label $tab6_right.packingTypeText -text [mc "Packing Type"]
    #ttk::entry $tab6_right.packingTypeEntry -textvariable international(packingType)
    #
    #grid $tab6_right.packingTypeText -column 0 -row 6 -sticky e -padx 2p -pady 2p
    #grid $tab6_right.packingTypeEntry -column 1 -row 6 -sticky ew


    ##
    ## Button Bar
    ##

    set buttonbar [ttk::frame .preferences.buttonbar]
    ttk::button $buttonbar.ok -text [mc "Save & Close"] -command { eAssist_Preferences::saveConfig; destroy .preferences }
    ttk::button $buttonbar.close -text [mc "Close"] -command { destroy .preferences }

    grid $buttonbar.ok -column 0 -row 3 -sticky nse -padx 8p -ipadx 4p
    grid $buttonbar.close -column 1 -row 3 -sticky nse -ipadx 4p
    pack $buttonbar -side bottom -anchor e -pady 8p -padx 5p

##
## - Bindings
##

bind all <<ComboboxSelected>> {
    #'debug ComboBox - [$tab3.combo current]
    eAssist_Preferences::displayHeader [$tab3.combo current]
}

    
bind [$tab4.listbox bodytag] <Double-1> {
    if {$internal(table,currentRow) != 0} {
        .preferences.frame0.nb.f4.customer.listbox delete [.preferences.frame0.nb.f4.customer.listbox curselection]
        
        incr internal(table,currentRow) -1
    }
}

bind [$tab2b.listbox bodytag] <Double-1> {
    if {$internal(table2,currentRow) != 0} {
        .preferences.frame0.nb.f2.customer3p.listbox delete [.preferences.frame0.nb.f2.customer3p.listbox curselection]
        
        incr internal(table2,currentRow) -1
    }
}

} ;# end eAssist_Preferences::prefGUI



proc eAssist_Preferences::removeSubHeader {parentHeader} {
    #****f* removeSubheader/eAssist_Preferences
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Supply the parentHeader name (from the textvariable)
    #	removeSubHeader $parentHeader
    #
    # SYNOPSIS
    #	Removes the selected SubHeader and updates the list of values for that particular parentHeader variable
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	eAssist_Preferences::prefGUI
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global tab3 header
    if {[$tab3.listbox curselection] == "" } {return}

    $tab3.listbox delete [$tab3.listbox curselection]

    # Set the new list of values to the array variable.
    set header($parentHeader) [$tab3.listbox get 0 end]
} ;# end eAssist_Preferences::removeSubHeader


proc eAssist_Preferences::displayHeader {args} {
    #****f* displayHeader/eAssist_Preferences
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Called with the indice of the value of the combobox; and returns the associated array with values, of that array variable.
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	eAssist_Preferences::prefGUI
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global header header_sorted tab3
    puts "displayHeader - Started"

    # Names listed in the header array, that matches what was selected in the combobox.
    set headerCategory [lindex $header_sorted $args]

    $tab3.listbox delete 0 end

    foreach headerName $header($headerCategory) {
        $tab3.listbox insert end [string totitle $headerName]
    }
    puts "header category: $headerCategory"

} ;# End eAssist_Preferences::displayHeader


proc eAssist_Preferences::addSubHeader {parentHeader subHeader} {
    #****f* addSubHeader/eAssist_Preferences
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Pass the parentHeader name and the new subHeader.
    #
    # SYNOPSIS
    #	Allows the user to add a new subHeader to the list with the parentHeader
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	eAssist_Preferences::prefGUI
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global tab3 header
    'debug addSubHeader

    # Cycle through all header arrays to check for duplicates
    #  We must allow only one instance of a word for all SubHeaders
    foreach name [array names header] {
        if {[lsearch $header($name) $subHeader] != -1} {
            'debug Found duplicate in $name
            Error_Message::errorMsg header1 $name
            return
        }
    }

    # Now add the new subheader
    $tab3.listbox insert end [string totitle $subHeader]

    set header($parentHeader) [$tab3.listbox get 0 end]
} ;# End eAssist_Preferences::addSubHeader


proc eAssist_Preferences::chooseDir {target} {
    #****f* chooseDir/eAssist_Preferences
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	eAssist_Preferences::prefGUI
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global mySettings


    set settingsTMP($target) [tk_chooseDirectory \
        -parent .preferences \
        -title [mc "Choose a Directory"] \
	-initialdir $mySettings($target)
    ]

    'debug "(folderName) $settingsTMP($target)"

    # If we do not select a file name, and cancel out of the dialog, do not produce an error.
    # The usage of settingsTMP prevents us from over writing our original value; which we may want to keep if the user does not select a directory.
    if {$mySettings($target) eq ""} {
        'debug "No directory was selected"
        return
        } else {
            set mySettings($target) $settingsTMP($target)
        }

} ;# end eAssist_Preferences::chooseDir


proc eAssist_Preferences::saveConfig {} {
    #****f* saveConfig/eAssist_Preferences
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	saveConfig
    #
    # SYNOPSIS
    #	Write settings to config.txt file.
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	'eAssist_loadSettings, eAssist_Preferences::prefGUI
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global settings header internal customer3P mySettings env international company shipVia3P

    # Global Settings
    set fd [open [file join $settings(Home) config.txt] w]
    
    set shipVia3P(table) [.preferences.frame0.nb.f2.customer3p.listbox get 0 end]
    set shipVia3P(table) [lrange $shipVia3P(table) 0 end-1] ;# Get rid of the empty list generated by inserting an empty line in the listbox.
    #set settings(shipvia3P) $ShipVia3P(table)
    
    set settings(shipvia3P) ""
    foreach shipVia_3P $shipVia3P(table) {
        lappend settings(shipvia3P) [join [lrange $shipVia_3P 1 1]]
    }

    foreach value [array names settings] {
            puts $fd "settings($value) $settings($value)"
    }

    foreach value [array names header] {
            puts $fd "header($value) $header($value)"
    }
    
    foreach value [array names international] {
            puts $fd "international($value) $international($value)"
    }
    
    foreach value [array names company] {
            puts $fd "company($value) $company($value)"
    }
    
    set customer3P(table) [.preferences.frame0.nb.f4.customer.listbox get 0 end]
    set customer3P(table) [lrange $customer3P(table) 0 end-1] ;# Get rid of the empty list generated by inserting an empty line in the listbox.
    
    set customer3P(name) "" ;# Always generate a new list
    foreach customer $customer3P(table) {
        lappend customer3P(name) [join [lrange $customer 0 0] ]
    }
    
    puts $fd "customer3P(table) $customer3P(table)"
    puts $fd "customer3P(name)  $customer3P(name)"
    
    puts $fd "shipVia3P(table) $shipVia3P(table)"

    

    chan close $fd
    
    # Per computer settings
    set fd [open [file join $env(APPDATA) E_A settings.txt] w]
    
    foreach value [array names mySettings] {
        puts $fd "mySettings($value) $mySettings($value)"
        puts $mySettings($value)
    }
    chan close $fd
}
