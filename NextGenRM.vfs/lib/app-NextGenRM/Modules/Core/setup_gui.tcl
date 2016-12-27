# Initial Date: June 20, 2016


proc rmGUI::prefGUI {} {
    #****f* prefGUI/rmGUI
    # FUNCTION
    #
    #
    # SYNOPSIS
    #	GUI for the preferences window
    #
    # CHILDREN
    #	
    #
    # PARENTS
    #
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global log prefs gui tmp

    toplevel .preferences
    wm transient .preferences .
    wm title .preferences [mc "Preferences"]

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    wm geometry .preferences +${locX}+${locY}

    focus .preferences

    ##
    ## Parent Frame
    ##
    set f0 [ttk::frame .preferences.f0]
    pack $f0 -expand yes -fill both -pady 5p -padx 5p
    
    ##
    ## Button Bar
    ##
    set btnBar [ttk::frame .preferences.f1]
    pack $btnBar -anchor se -pady 5p -padx 5p
    
    grid [ttk::button $btnBar.ok -text [mc "OK"] -command {}] -column 0 -row 0
    grid [ttk::button $btnBar.cncl -text [mc "Cancel"] -command {destroy .preferences}] -column 1 -row 0

    ##
    ## Notebook
    ##
    set nb [ttk::notebook $f0.nb]
    pack $nb -expand yes -fill both
    


    $nb add [ttk::frame $nb.f1] -text [mc "States"]
    $nb add [ttk::frame $nb.f2] -text [mc "Tax/Item Type"]
    $nb add [ttk::frame $nb.f3] -text [mc "Tax Rates"]
    $nb add [ttk::frame $nb.f3a] -text [mc "Purchased Items"]
    $nb add [ttk::frame $nb.f4] -text [mc "Stores"]
    $nb add [ttk::frame $nb.f5] -text [mc "Receipt"]
    $nb add [ttk::frame $nb.f6] -text [mc "Addresses"]
    $nb select $nb.f1

    ttk::notebook::enableTraversal $nb
    
    set states $nb.f1
    set taxes $nb.f2
    set taxrates $nb.f3
    set purch $nb.f3a
    set stores $nb.f4
    set receipt $nb.f5
    set addr $nb.f6
    
    ##
    ## States
    ##
    
    # Add the states
    grid [ttk::label $states.txt1 -text [mc "State Abbr."]] -column 0 -row 0 -padx 2p -pady 3p -sticky e
    grid [ttk::entry $states.entry1] -column 1 -row 0 -sticky ew
    
    grid [ttk::label $states.txt2 -text [mc "State Name"]] -column 0 -row 1 -padx 2p -pady 3p -sticky e
    grid [ttk::entry $states.entry2] -column 1 -row 1 -sticky ew
    
    grid [ttk::button $states.btn1 -text [mc "Add"] -command [list rmGUI::AddState $states.entry1 $states.entry2 $states.tbl]] -column 2 -row 0 -padx 2p -pady 3p -sticky w

    set scrolly $states.scrolly
    grid [tablelist::tablelist $states.tbl -columns {
                                            10 "Abbr." center
                                            40 "State" left} \
                                            -showlabels yes \
                                            -showlabels yes \
                                            -selectbackground lightblue \
                                            -selectforeground black \
                                            -stripebackground lightyellow \
                                            -exportselection yes \
                                            -showseparators yes \
                                            -fullseparators yes \
                                            -movablecolumns no \
                                            -movablerows no \
                                            -editselectedonly 1 \
                                            -selectmode extended \
                                            -labelcommand tablelist::sortByColumn \
                                            -labelcommand2 tablelist::addToSortColumns \
                                            -yscrollcommand [list $scrolly set]] -column 0 -row 3 -columnspan 3 -pady 5p -sticky news
    
    grid columnconfigure $states $states.tbl -weight 2
    grid rowconfigure $states $states.tbl -weight 2

    ttk::scrollbar $scrolly -orient v -command [list $states.tbl yview]
        
    grid $scrolly -column 2 -row 1 -sticky ns
        
    ::autoscroll::autoscroll $scrolly ;# Enable the 'autoscrollbar'

    
    set bodyTag [$states.tbl bodytag]
    set gui(pref,StateTbl) $states.tbl
    bind $bodyTag <Double-1> {
        # Retrieve the data to delete from the database, and the row in the tbl to delete from the table
        rmDB::DelState [$gui(pref,StateTbl) get [$gui(pref,StateTbl) curselection]] $gui(pref,StateTbl) [$gui(pref,StateTbl) curselection]
    }
    
    
    # Populate the state table from the db
    rmDB::ReadStates $gui(pref,StateTbl)

    ##
    ## Tax Type
    ##
    
    set taxtype [ttk::labelframe $taxes.type -text [mc "Tax Type"]]
    grid $taxtype -column 0 -row 0 -padx 5p -pady 5p -sticky new
    
    grid [ttk::entry $taxtype.entry1] -column 0 -row 0 -padx 2p -pady 2p
    grid [ttk::button $taxtype.btn1 -text [mc "Add"] -command [list rmDB::InsertTaxType $taxtype.entry1 $taxtype.lbox1]] -column 1 -row 0 -padx 2p -pady 2p -sticky nwe
    grid [listbox $taxtype.lbox1] -column 0 -row 1 -columnspan 2 -padx 2p -pady 2p -sticky news
    
    # Populate TaxType
    rmDB::ReadTaxType $taxtype.lbox1
    
    # Bindings to edit
    set gui(pref,TaxTypeEntry) $taxtype.entry1
    bind $taxtype.lbox1 <Double-1> {
        # Get DB id, populate entry widget with current selection
        set tmp(taxtype,id) [rmDB::GetTaxTypeID %W]
        $gui(pref,TaxTypeEntry) insert end [%W get [%W curselection]]
        
        ${log}::debug window: %W [%W get [%W curselection]]: id: $tmp(taxtype,id)
    }
    
    set liqtype [ttk::labelframe $taxes.liq -text [mc "Liquor Type"]]
    grid $liqtype -column 1 -row 0 -padx 5p -pady 5p -sticky new
    
    grid [ttk::entry $liqtype.entry1] -column 0 -row 0 -padx 2p -pady 2p
    grid [ttk::button $liqtype.btn1 -text [mc "Add"] -command [list rmDB::LiquorType $liqtype.entry1 $liqtype.lbox1]] -column 1 -row 0 -padx 2p -pady 2p -sticky nwe
    grid [listbox $liqtype.lbox1] -column 0 -row 1 -columnspan 2 -padx 2p -pady 2p -sticky news
    
    # Populate LiquorType
    rmDB::ReadLiquorType $liqtype.lbox1
    
    # Bindings to edit
    set gui(pref,LiquorTypeEntry) $liqtype.entry1
    bind $liqtype.lbox1 <Double-1> {
        # Get DB id, populate entry widget with current selection
        set tmp(liqtype,id) [rmDB::GetLiquorTypeID %W]
        $gui(pref,LiquorTypeEntry) insert end [%W get [%W curselection]]
        
        ${log}::debug window: %W [%W get [%W curselection]]: id: $tmp(liquortype,id)
    }
    
    ##
    ## Tax Rates
    ##
    
    set taxrate [ttk::labelframe $taxrates.rate -text [mc "Tax Rates"]]
    grid $taxrate -column 1 -row 0 -padx 5p -pady 5p -sticky news
    
    grid [ttk::label $taxrate.txt0 -text [mc "State"]] -column 0 -row 0 -padx 2p -pady 2p -sticky nse
    grid [ttk::combobox $taxrate.cbox0 -state readonly -postcommand [list $taxrate.cbox0 configure -values [rmDB::GetStateAbbr]]] -column 1 -row 0 -padx 2p -pady 2p -sticky ew
          
    grid [ttk::label $taxrate.txt1 -text [mc "Tax Type"]] -column 0 -row 1 -padx 2p -pady 2p -sticky nse
    grid [ttk::combobox $taxrate.cbox1 -state readonly -postcommand [list $taxrate.cbox1 configure -values [rmDB::GetTaxType]]] -column 1 -row 1 -padx 2p -pady 2p -sticky ew
    
    grid [ttk::label $taxrate.txt2 -text [mc "Tax %"]] -column 0 -row 2 -padx 2p -pady 2p -sticky nse
    grid [ttk::entry $taxrate.entry2] -column 1 -row 2 -padx 2p -pady 2p -sticky news
    
    grid [ttk::button $taxrate.btn1 -text [mc "Add"] -command [list rmDB::InsertTaxRate $taxrate.cbox0 $taxrate.cbox1 $taxrate.entry2 $taxrate.tbl]] -column 2 -row 0 -padx 2p -pady 2p -sticky ew
    
    set scrolly $taxrate.scrolly
    grid [tablelist::tablelist $taxrate.tbl -columns {
                                            15 "State" left
                                            12 "Tax Type" left
                                            0 "Tax %" center} \
                                            -stretch 2 \
                                            -showlabels yes \
                                            -showlabels yes \
                                            -selectbackground lightblue \
                                            -selectforeground black \
                                            -stripebackground lightyellow \
                                            -exportselection yes \
                                            -showseparators yes \
                                            -fullseparators yes \
                                            -movablecolumns no \
                                            -movablerows no \
                                            -editselectedonly 1 \
                                            -selectmode extended \
                                            -labelcommand tablelist::sortByColumn \
                                            -labelcommand2 tablelist::addToSortColumns \
                                            -yscrollcommand [list $scrolly set]] -column 0 -row 3 -columnspan 4 -pady 5p -padx 2p -sticky news
    
    grid columnconfigure $taxrate $taxrate.tbl -weight 2
    grid columnconfigure $taxrate 0 -weight 2
    grid rowconfigure $taxrate $taxrate.tbl -weight 2

    ttk::scrollbar $scrolly -orient v -command [list $taxrate.tbl yview]
        
    grid $scrolly -column 1 -row 2 -sticky ns
        
    ::autoscroll::autoscroll $scrolly ;# Enable the 'autoscrollbar'
    
    # Populate Taxrate table
    rmDB::PopulateTaxRate $taxrate.tbl
    
    ## BINDING
    set bodyTag1 [$taxrate.tbl bodytag]
    set gui(pref,TaxRateTbl) $taxrate.tbl
    bind $bodyTag1 <Double-1> {
        # Retrieve the data to delete from the database, and the row in the tbl to delete from the table
        #rmDB::DelTaxRate [$gui(pref,StateTbl) get [$gui(pref,StateTbl) curselection]] $gui(pref,StateTbl) [$gui(pref,StateTbl) curselection]
        rmDB::DelTaxRate [$gui(pref,TaxRateTbl) get [$gui(pref,TaxRateTbl) curselection]] $gui(pref,TaxRateTbl) [$gui(pref,TaxRateTbl) curselection]
        ${log}::debug [$gui(pref,TaxRateTbl) get [$gui(pref,TaxRateTbl) curselection]] $gui(pref,TaxRateTbl) [$gui(pref,TaxRateTbl) curselection]
    }

    ##
    ## Tab Purchased Items
    ##
    
    set pclf1 [ttk::frame $purch.f1]
    grid $pclf1 -column 0 -row 0 -pady 5p -padx 5p -sticky news
    
    #Initialize variable
    #set program(purchasedList) ""
    grid [ttk::label $pclf1.purchtxt -text [mc "Purchased Lists"]] -column 0 -row 0 -padx 3p -pady 2p -sticky w
    grid [ttk::combobox $pclf1.pclBox -state readonly \
                                    -textvariable purchased_list] -column 1 -row 0 -padx 2p -pady 2p -sticky ew
    
    grid [ttk::button $pclf1.pclNew -image add16x16 -command {rmGUI::editPCL}] -column 2 -row 0 -padx 2p -pady 2p
    grid [ttk::button $pclf1.pclRename -image rename16x16 -state disable -command ""] -column 3 -row 0 -padx 1p -pady 2p
    grid [ttk::button $pclf1.pclDelete -image del16x16 -state disable -command {Purchased List}] -column 4 -row 0 -padx 1p -pady 2p
    
    set pclf2 [ttk::frame $purch.f2]
    grid $pclf2 -column 0 -row 1 -pady 5p -padx 3p -sticky news
    
    grid columnconfigure $pclf2 0 -weight 2
    grid rowconfigure $pclf2 0 -weight 2
    
    set scrolly_pcl $pclf2.scrolly
    tablelist::tablelist $pclf2.tbl \
                -columns {
                        15  "Item"      left
                        5   "Price"     center
                        15  "Tax Type"  center} \
                -showlabels yes \
                -stretch 0 \
                -selectbackground yellow \
                -selectforeground black \
                -stripebackground lightblue \
                -exportselection yes \
                -showseparators yes \
                -fullseparators yes \
                -yscrollcommand [list $scrolly_pcl set]
                        
    ttk::scrollbar $scrolly_pcl -orient v -command [list $pclf2.tbl yview]
    
    grid $pclf2.tbl -column 0 -row 0 -sticky news
    grid $scrolly_pcl -column 1 -row 0 -sticky ns

    # This is needed so the scrollbar displays properly
    grid columnconfigure    $pclf2.tbl 0 -weight 1
    grid rowconfigure       $pclf2.tbl 0 -weight 1
    
    ::autoscroll::autoscroll $scrolly_pcl ;# Enable the 'autoscrollbar'
    
    bind $pclf1.pclBox <FocusIn> {
        %W configure -values [rmDB::GetPCLNames] 
    }
    
    set tmp(gui,pcllist) $pclf2.tbl
    bind $pclf1.pclBox <<ComboboxSelected>> {
        
        $tmp(gui,pcllist) delete 0 end
        rmDB::readPCLitems $tmp(gui,pcllist) %W
    }
    
    ##
    ## Tab Stores
    ##
      
    set store [ttk::frame $stores.f1]
    pack $store -fill x -anchor s -pady 0p -padx 5p
    
    grid [ttk::button $store.addBtn -text [mc "Add"] -command {rmGUI::editStore}] -column 0 -row 0 -pady 2p -padx 2p -sticky w
    grid [ttk::button $store.editBtn -text [mc "Edit"]] -column 1 -row 0 -pady 2p -padx 2p -sticky w
    
    ##
    ## Tablelist
    
    set slist [ttk::frame $stores.list] ;# slist = store list
    pack $slist -expand yes -fill both -anchor n -padx 5p
    #grid $slist -column 0 -columnspan 2 -row 1 -padx 5p -pady 2p -sticky news
    
    set scrolly_slist $slist.scrolly
    set scrollx_slist $slist.scrollx
    grid [tablelist::tablelist $slist.tbl -columns {
                                            25 "Store Name" left
                                            12 "City" left
                                            6 "State" center
                                            9 "Zip" center} \
                                            -showlabels yes \
                                            -selectbackground lightblue \
                                            -selectforeground black \
                                            -stripebackground lightyellow \
                                            -exportselection yes \
                                            -showseparators yes \
                                            -fullseparators yes \
                                            -movablecolumns no \
                                            -movablerows no \
                                            -editselectedonly 1 \
                                            -selectmode extended \
                                            -yscrollcommand [list $scrolly_slist set] \
                                            -xscrollcommand [list $scrollx_slist set]] -column 0 -row 0 -pady 3p -padx 2p -sticky news
    
    grid columnconfigure $slist $slist.tbl -weight 2
    grid rowconfigure $slist $slist.tbl -weight 2

    ttk::scrollbar $scrolly_slist -orient v -command [list $slist.tbl yview]
    ttk::scrollbar $scrollx_slist -orient h -command [list $slist.tbl xview]
        
    grid $scrolly_slist -column 1 -row 0 -sticky ns
    grid $scrollx_slist -column 0 -row 1 -sticky ew
        
    ::autoscroll::autoscroll $scrolly_slist ;# Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $scrollx_slist ;# Enable the 'autoscrollbar'
    
    ##
    ## Tab 5 Receipt Layout and Store Assignment
    ##
    
    set rec  [ttk::frame $receipt.f1]
    #grid $rec -column 0 -row 0 -padx 5p -pady 3p -sticky news
    pack $rec -fill x -anchor nw -padx 5p -pady 5p
    
    grid [ttk::button $rec.add -text [mc "Add"] -command {rmGUI::ReceiptLayout}] -column 0 -row 0 -sticky w
    grid [ttk::button $rec.edit -text [mc "Edit"] -state disabled] -column 1 -row 0 -sticky w
    grid [ttk::button $rec.del -text [mc "Delete"] -state disabled] -column 2 -row 0 -sticky w
    
    set rassign [ttk::frame $receipt.f2]
    #grid [ttk::frame $rassign] -column 0 -row 1 -columnspan 3 -pady 2p -padx 0p -sticky news
    pack $rassign -expand yes -fill both -anchor nw -padx 5p -pady 2p
    
    grid [tablelist::tablelist $rassign.tbl -columns {
                                            25 "Store Name" left
                                            0 "Header Line 1" left
                                            0 "Header Line 2" left} \
                                            -showlabels yes \
                                            -selectbackground lightblue \
                                            -selectforeground black \
                                            -stripebackground lightyellow \
                                            -exportselection yes \
                                            -showseparators yes \
                                            -fullseparators yes \
                                            -movablecolumns no \
                                            -movablerows no \
                                            -editselectedonly 1 \
                                            -selectmode extended] -column 0 -row 0 -sticky news
    grid columnconfigure $rassign 0 -weight 2
    grid rowconfigure $rassign 0 -weight 2

    
    ##
    ## Tab Addresses
    ##
    
    set addrs  [ttk::frame $addr.f1]
    grid $addrs -column 0 -row 0 -padx 5p -pady 3p -sticky news
    
    grid [ttk::label $addrs.desctxt -text [mc "Description"]] -column 0 -row 0 -sticky e -padx 2p -pady 2p
    grid [ttk::entry $addrs.descent -width 68] -column 1 -columnspan 2 -row 0 -sticky ew -padx 2p -pady 2p
    
    grid [ttk::label $addrs.addrstxt -text [mc "Address"]] -column 0 -row 1 -sticky e -padx 2p -pady 2p
    grid [ttk::entry $addrs.addrsent] -column 1 -columnspan 2 -row 1 -sticky ew -padx 2p -pady 2p
    
    grid [ttk::label $addrs.statetxt -text [mc "State"]] -column 0 -row 2 -sticky e -padx 2p -pady 2p
    grid [ttk::combobox $addrs.statecbox] -column 1 -columnspan 2 -row 2 -sticky ew -padx 2p -pady 2p
    
    grid [ttk::label $addrs.wttxt -text [mc "Weight"]] -column 0 -row 3 -sticky e -padx 2p -pady 2p
    grid [ttk::entry $addrs.wtent] -column 1 -row 3 -sticky ew -padx 2p -pady 2p
    
    grid [ttk::checkbutton $addrs.cbtn -text [mc "Active"]] -column 2 -row 3 -sticky w -padx 2p -pady 2p
    
    set btns_addr [ttk::frame $addr.btns]
    grid $btns_addr -column 0 -row 1 -sticky sw -padx 5p
    
    grid [ttk::button $btns_addr.add -text [mc "Add"]] -column 0 -row 0 -sticky w
    grid [ttk::button $btns_addr.edit -text [mc "Edit"]] -column 1 -row 0 -sticky w
    
    set addrstbl [ttk::frame $addr.f2]
    grid $addrstbl -column 0 -row 2 -padx 5p -pady 3p -sticky news
    grid [tablelist::tablelist $addrstbl.tbl -columns {
                                            8  "Weight" center
                                            25 "Description" left
                                            25 "Address" left
                                            6 "State" left
                                            8 "Active" center
                                            } \
                                            -showlabels yes \
                                            -selectbackground lightblue \
                                            -selectforeground black \
                                            -stripebackground lightyellow \
                                            -exportselection yes \
                                            -showseparators yes \
                                            -fullseparators yes \
                                            -movablecolumns no \
                                            -movablerows no \
                                            -editselectedonly 1 \
                                            -selectmode extended] -column 0 -columnspan 3 -row 1 -pady 3p -padx 2p -sticky news
    
    grid columnconfigure $addrstbl $addrstbl.tbl -weight 3
    grid rowconfigure $addrstbl $addrstbl.tbl -weight 3

    
}

proc rmGUI::editPCL {args} {
    global tmp
    
    if {[winfo exists .pclwindow]} {destroy .pclwindow}
 
    toplevel .pclwindow
    wm title .pclwindow [mc "Purchased List Editor"]
    wm transient .pclwindow .preferences
    focus -force .pclwindow

    # x = horizontal
    # y = vertical
    # Put the window in the center of the parent window
    set locX [expr {[winfo width .preferences ] / 15 + [winfo x .preferences]}]
    set locY [expr {[winfo height .preferences ] / 6 + [winfo y .preferences]}]

    wm geometry .pclwindow 400x350+$locX+$locY
    
    set purch [ttk::frame .pclwindow.f1]
    #grid $purch -column 0 -row 0 -sticky news -pady 5p -padx 5p
    pack $purch -fill both -expand yes -pady 5p -padx 5p -anchor ne
    
    grid [ttk::label $purch.nametxt -text [mc "List Name"]] -column 0 -row 0 -padx 2p -pady 2p -sticky e
    grid [ttk::entry $purch.nameent] -column 1 -row 0 -padx 2p -pady 2p -sticky ew
    
    set pur [ttk::frame .pclwindow.f0]
    pack $pur -fill both -expand yes
    
    grid [ttk::label $pur.itemtxt -text [mc "Item Name"]] -column 0 -row 1 -padx 2p -pady 2p -sticky e
    grid [ttk::entry $pur.itement] -column 1 -row 1 -padx 2p -pady 2p -sticky ew
    
    grid [ttk::label $pur.pricetxt -text [mc "Price"]] -column 0 -row 2 -padx 2p -pady 2p -sticky e
    grid [ttk::entry $pur.priceent] -column 1 -row 2 -padx 2p -pady 2p -sticky ew
    
    grid [ttk::label $pur.ttypetxt -text [mc "Tax Type"]] -column 0 -row 3 -padx 2p -pady 2p -sticky e
    grid [ttk::combobox $pur.ttypecbox] -column 1 -row 3 -padx 2p -pady 2p -sticky ew
    
    set tblcont [ttk::frame .pclwindow.f1a]
    pack $tblcont -expand yes -fill both
    
    #grid [listbox $purch.list] -column 1 -columnspan 2 -row 4 -rowspan 10 -padx 2p -pady 2p -sticky news
    set tbl [ttk::frame $tblcont.tbl]
    pack $tbl -expand yes -fill both -side left
    
    grid [tablelist::tablelist $tbl.list -columns {
                                            25 "Item Name" left
                                            8 "Price" left
                                            15 "Tax Type" left
                                            } \
                                            -showlabels yes \
                                            -selectbackground lightblue \
                                            -selectforeground black \
                                            -stripebackground lightyellow \
                                            -exportselection yes \
                                            -showseparators yes \
                                            -fullseparators yes \
                                            -movablecolumns no \
                                            -movablerows no \
                                            -editselectedonly 1 \
                                            -selectmode extended] -column 0 -row 0 -pady 2p -padx 2p -sticky news
    grid columnconfigure $tbl $tbl.list -weight 2
                                            
    set editBtns [ttk::frame $tblcont.btn]
    pack $editBtns
    
    grid [ttk::button $editBtns.addbtn -text [mc "Add"] -command [list rmDB::InsertPCLitems $purch.nameent $pur.itement $pur.priceent $pur.ttypecbox]] -column 0 -row 0 -padx 2p -pady 2p -sticky new
    grid [ttk::button $editBtns.delbtn -text [mc "Delete"]] -column 0 -row 1 -padx 2p -pady 2p -sticky new
    
    set btns [ttk::frame .pclwindow.f2]
    #grid $btns -column 1 -row 2 -padx 3p -pady 3p -sticky nes
    pack $btns -anchor se -padx 3p -pady 3p
    
    grid [ttk::button $btns.ok -text [mc "OK"]] -column 0 -row 0 -pady 2p -padx 4p
    grid [ttk::button $btns.cncl -text [mc "Cancel"] -command {destroy .pclwindow}] -column 1 -row 0 -pady 2p -padx 4p
    
    
    set tmp(gui,taxtypelist) $pur.ttypecbox
    bind $pur.ttypecbox <<ComboboxSelected>> {
        
        $tmp(gui,pcllist) delete 0 end
        rmDB::readPCLitems $tmp(gui,pcllist) %W
    }
    #rmDB::GetTaxRateNames
} ;# rmGUI::editPCL

proc {rmGUI::editStore} {} {
    if {[winfo exists .stores]} {destroy .stores}
 
    toplevel .stores
    wm title .stores [mc "Store Editor"]
    wm transient .stores .preferences
    focus -force .stores

    # x = horizontal
    # y = vertical
    # Put the window in the center of the parent window
    set locX [expr {[winfo width .preferences ] / 15 + [winfo x .preferences]}]
    set locY [expr {[winfo height .preferences ] / 6 + [winfo y .preferences]}]

    wm geometry .stores +$locX+$locY
    
    set stores [ttk::frame .stores.f1]
    pack $stores -expand yes -fill both
    
    set store [ttk::labelframe $stores.addr -text [mc "Stores"] -padding 10]
    grid $store -column 0 -row 0 -padx 5p -pady 5p -sticky news
    
    # Name
    grid [ttk::label $store.nametxt -text [mc "Store Name"]] -column 0 -row 0 -pady 2p -padx 2p -sticky nse
    grid [ttk::entry $store.nameent] -column 1 -columnspan 3 -row 0 -pady 2p -padx 2p -sticky ew
    
    # Address
    grid [ttk::label $store.addrtxt -text [mc "Address"]] -column 0 -row 1 -pady 2p -padx 2p -sticky nse
    grid [ttk::entry $store.addrent] -column 1 -columnspan 3 -row 1 -pady 2p -padx 2p -sticky ew
    
    # City
    grid [ttk::label $store.citytxt -text [mc "City"]] -column 0 -row 2 -pady 2p -padx 2p -sticky nse
    grid [ttk::entry $store.cityent] -column 1 -row 2 -pady 2p -padx 2p -sticky ew
    
    # State (drop down)
    grid [ttk::label $store.statetxt -text [mc "State"]] -column 2 -row 2 -pady 2p -padx 2p -sticky nse
    grid [ttk::combobox $store.statedd -width 4 -values "WA OR"] -column 3 -row 2 -pady 2p -padx 2p -sticky ew
    
    # Zip
    grid [ttk::label $store.ziptxt -text [mc "Zip"]] -column 4 -row 2
    grid [ttk::entry $store.zipent -width 10] -column 5 -row 2 -padx 2p
    
    # Phone
    grid [ttk::label $store.phonetxt -text [mc "Phone"]] -column 0 -row 4 -pady 2p -padx 2p -sticky nse
    grid [ttk::entry $store.phoneent] -column 1 -row 4 -pady 2p -padx 2p -sticky ew
    
    # Active
    grid [ttk::label $store.active -text [mc "Active"]] -column 1 -row 5 -sticky w -pady 2p -padx 2p
    
    # FRAME Misc items
    set misc [ttk::labelframe $stores.misc -text [mc "Misc"] -padding 10]
    grid $misc -column 1 -row 0 -padx 5p -pady 5p -sticky new
    
    # Purchased Items
    grid [ttk::label $misc.purtxt -text [mc "Purchased List"]] -column 0 -row 0 -pady 2p -padx 2p -sticky e
    grid [ttk::combobox $misc.purcbox -values "ListA ListB ListC"] -column 1 -row 0 -pady 2p -padx 2p -sticky ew
    
    grid [ttk::label $misc.hourOpentxt -text [mc "Open (hrs)"]] -column 0 -row 1 -pady 2p -padx 2p -sticky e
    grid [ttk::entry $misc.hourOpenent] -column 1 -row 1 -pady 2p -padx 2p -sticky ew
    
    grid [ttk::label $misc.hourClosetxt -text [mc "Close (hrs)"]] -column 0 -row 2 -pady 2p -padx 2p -sticky e
    grid [ttk::entry $misc.hourCloseent] -column 1 -row 2 -pady 2p -padx 2p -sticky ew
    
    grid [ttk::label $misc.hourFormattxt -text [mc "Hour Formatting"]] -column 0 -row 3 -pady 2p -padx 2p -sticky e
    grid [ttk::combobox $misc.hourFormatent] -column 1 -row 3 -pady 2p -padx 2p -sticky ew
    
    # FRAME Liquor Type Association
    set liq [ttk::labelframe $stores.liq -text [mc "Liquor Type Association"] -padding 10]
    grid $liq -column 0 -row 1 -columnspan 1 -padx 5p -pady 5p -sticky news
    
    grid [ttk::label $liq.liqtypetxt -text [mc "Liquor Type"]] -column 0 -row 0
    grid [ttk::combobox $liq.liqtypeent] -column 1 -row 0
    grid [ttk::button $liq.add -text [mc "Add"] -command {}] -column 2 -row 0
    grid [ttk::button $liq.del -text [mc "Delete"] -command {}] -column 3 -row 0
    
    grid [listbox $liq.list] -column 1 -columnspan 3 -pady 2p -sticky news
    
    
    ##
    ## Button Bar
    
    set btnBar [ttk::frame .stores.btn]
    pack $btnBar -anchor se -pady 5p -padx 5p
    
    grid [ttk::button $btnBar.ok -text [mc "OK"] -command {}] -column 0 -row 0
    grid [ttk::button $btnBar.cncl -text [mc "Cancel"] -command {destroy .stores}] -column 1 -row 0
}

proc rmGUI::ReceiptLayout {} {
 if {[winfo exists .layout]} {destroy .layout}
 
    toplevel .layout
    wm title .layout [mc "Store Editor"]
    wm transient .layout .preferences
    focus -force .layout

    # x = horizontal
    # y = vertical
    # Put the window in the center of the parent window
    set locX [expr {[winfo width .preferences ] / 15 + [winfo x .preferences]}]
    set locY [expr {[winfo height .preferences ] / 6 + [winfo y .preferences]}]

    wm geometry .layout +$locX+$locY
    
    set layout [ttk::frame .layout.f1 -padding 10]
    pack $layout -expand yes -fill both
    
    set rassign $layout.f1
    grid [ttk::labelframe $rassign -text [mc "Assignment"]] -column 0 -row 1 -columnspan 3 -pady 2p -padx 0p -sticky news
    
    grid [ttk::label $rassign.storetxt -text [mc "Store"]] -column 0 -row 0 -pady 2p -padx 2p -sticky e
    grid [ttk::combobox $rassign.storeslist -values "StoreA StoreB StoreC"] -column 1 -row 0 -pady 2p -padx 2p -sticky ew
    
    set rsizes $layout.f2
    grid [ttk::labelframe $rsizes -text [mc "Sizes"]] -column 0 -row 2 -pady 2p -padx 0p -sticky news
    
    grid [ttk::label $rsizes.hdrtxt -text [mc "Header"]] -column 0 -row 0 -pady 2p -padx 2p -sticky e
    grid [ttk::combobox $rsizes.hdrsize -values "Large Medium Small"] -column 1 -row 0 -pady 2p -padx 2p -sticky ew
    
    grid [ttk::label $rsizes.fttxt -text [mc "Footer"]] -column 0 -row 1 -pady 2p -padx 2p -sticky e
    grid [ttk::combobox $rsizes.ftsize -values "Large Medium Small"] -column 1 -row 1 -pady 2p -padx 2p -sticky ew
    
    grid [ttk::label $rsizes.bdtxt -text [mc "Body"]] -column 0 -row 2 -pady 2p -padx 2p -sticky e
    grid [ttk::combobox $rsizes.bdsize -values "Large Medium Small"] -column 1 -row 2 -pady 2p -padx 2p -sticky ew
    
    set rdate $layout.f3
    grid [ttk::labelframe $rdate -text [mc "Date"]] -column 1 -row 2 -pady 2p -padx 0p -sticky news
    
    grid [ttk::label $rdate.postxt -text [mc "Position"]] -column 0 -row 0 -pady 2p -padx 2p -sticky e
    grid [ttk::combobox $rdate.poscbox -values "Header Footer"] -column 1 -row 0 -pady 2p -padx 2p -sticky ew
    
    grid [ttk::label $rdate.justtxt -text [mc "Justify"]] -column 0 -row 1 -pady 2p -padx 2p -sticky e
    grid [ttk::combobox $rdate.justcbox -values "Left Center Right"] -column 1 -row 1 -pady 2p -padx 2p -sticky ew
    
    grid [ttk::label $rdate.formattxt -text [mc "Format"]] -column 0 -row 2 -pady 2p -padx 2p -sticky e
    grid [ttk::combobox $rdate.formatcbox -values "Format_typeA FormatTypeB FormatTypeC"] -column 1 -row 2 -pady 2p -padx 2p -sticky ew
    
    set lst [ttk::labelframe .layout.f2 -text [mc "Data"] -padding 3]
    pack $lst -expand yes -fill both -anchor ne -pady 3p -padx 5p
    
    grid [listbox $lst.tbl] -column 0 -row 0 -rowspan 3 -padx 2p -pady 3p -sticky new
    grid [ttk::button $lst.add -text [mc "Add >>"] -command {}] -column 1 -row 0 -padx 5p -sticky n
    grid [ttk::button $lst.del -text [mc "<< Remove"] -command {}] -column 1 -row 1 -padx 5p -sticky n
    grid [listbox $lst.tbl1] -column 2 -row 0 -rowspan 3 -padx 2p -pady 3p -sticky new
    
    set btnBar [ttk::frame .layout.btns]
    pack $btnBar -anchor se -padx 5p -pady 3p
    
    grid [ttk::button $btnBar.ok -text [mc "OK"] -command {}] -column 0 -row 0
    grid [ttk::button $btnBar.cncl -text [mc "Cancel"] -command {destroy .layout}] -column 1 -row 0
} 