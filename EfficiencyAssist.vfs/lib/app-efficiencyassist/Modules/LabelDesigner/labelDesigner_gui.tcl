# Creator: Casey Ackels (C) 2017

package provide eAssist_ModLabelDesigner 1.0

# Label designer
# This mod is meant to be used in the front office to create/assign data to label documents. When a template is created
# the template number must be placed on the ticket, so that Shipping can enter in the template id #, which will pull up our associated data and label document
# this is useful for labels that must contain certain data and/or certain label formatting.

proc ea::gui::ld::designerUI {} {
    global log ldWid

    # Clear the frames before continuing
    eAssist_Global::resetFrames parent

    set ldWid(f0) [ttk::labelframe .container.f0 -text [mc "Search Info"] -padding 10]
    pack $ldWid(f0) -fill x -pady 5p -padx 5p -anchor n

    grid [ttk::label $ldWid(f0).text1 -text [mc "Customer Name"]] -column 0 -row 0 -pady 2p -padx 2p -sticky e
    grid [ttk::entry $ldWid(f0).entry1 -width 35] -column 1 -row 0 -pady 2p -padx 2p -sticky w

    grid [ttk::button $ldWid(f0).btn1 -text [mc "Search"]] -column 2 -row 0 -pady 2p -padx 2p

    grid [ttk::label $ldWid(f0).text2 -text [mc "Title Name"]] -column 0 -row 1 -pady 2p -padx 2p  -sticky e
    grid [ttk::entry $ldWid(f0).entry2 -width 35] -column 1 -row 1 -pady 2p -padx 2p  -sticky w

    ##
    ## Table
    ##
	set ldWid(f1) [ttk::labelframe .container.f1 -text [mc "Templates"] -padding 5]
	pack $ldWid(f1) -fill both -expand yes -pady 3p -padx 5p

    # Add / Modify Buttons
    set ldWid(f1a) [ttk::frame $ldWid(f1).f1]
    pack $ldWid(f1a) -fill both -pady 3p -padx 5p

    grid [ttk::button $ldWid(f1a).btn1 -text [mc "Add"] -command {ea::gui::ld::addTemplate -add}] -column 0 -row 0 -pady 2p -padx 2p -sticky w
    grid [ttk::button $ldWid(f1a).btn2 -text [mc "Modify"] -command {ea::gui::ld::addTemplate -modify}] -column 1 -row 0 -pady 2p -padx 2p -sticky w

    # Table widget
    set ldWid(f1b) [ttk::frame $ldWid(f1).f2]
    pack $ldWid(f1b) -fill both -expand yes -pady 3p -padx 5p

	tablelist::tablelist $ldWid(f1b).listbox -columns {
                                                    3 "..." center
													0 "Customer Name"
                                                    0 "Title Name"
													0 "Status" center
                                                    } \
                                        -showlabels yes \
                                        -selectbackground yellow \
                                        -selectforeground black \
                                        -stripebackground lightblue \
                                        -exportselection yes \
                                        -showseparators yes \
                                        -fullseparators yes \
                                        -yscrollcommand [list $ldWid(f1b).scrolly set]

        $ldWid(f1b).listbox columnconfigure 0 -showlinenumbers 1 -name count
		$ldWid(f1b).listbox columnconfigure 1 -name customerName -labelalign center
        $ldWid(f1b).listbox columnconfigure 2 -name titleName -labelalign center
		$ldWid(f1b).listbox columnconfigure 3 -name status

    ttk::scrollbar $ldWid(f1b).scrolly -orient v -command [list $ldWid(f1b).listbox yview]

    grid $ldWid(f1b).listbox -column 0 -row 1 -sticky news
    grid columnconfigure $ldWid(f1b) $ldWid(f1b).listbox -weight 2
    grid rowconfigure $ldWid(f1b) $ldWid(f1b).listbox -weight 2

    grid $ldWid(f1b).scrolly -column 1 -row 0 -sticky nse

    ::autoscroll::autoscroll $ldWid(f1b).scrolly ;# Enable the 'autoscrollbar'

    # Populate table list
    ea::db::ld::getTemplateData
} ;# ea::gui::ld::designerUI

proc ea::gui::ld::addTemplate {args} {
    global log ldWid job tplLabel mod

    # SETUP
    # Retrieve list of Customers
    ea::db::ld::getCustomerList

    set ldWid(addTpl) .addTemplate

    if {[winfo exists $ldWid(addTpl)]} {${log}::notice addTemplate window already exists, aborting.; return}

    toplevel $ldWid(addTpl)
    wm transient $ldWid(addTpl) .
    wm title $ldWid(addTpl) [mc "Add/Edit Template"]

    ${log}::debug addTemplate: winfo geom: [winfo geometry $ldWid(addTpl)]
    set width [winfo reqwidth .]
    set height [winfo reqheight .]
    set x [expr {$width / 2}]
    set y [expr {$height / 2}]
    wm geometry $ldWid(addTpl) +$x+$y


    ${log}::debug addTemplate window Created...

    ##
    ## Header Info
    ##
    set ldWid(addTpl,f1) [ttk::labelframe $ldWid(addTpl).f1 -text [mc "Customer Info"] -padding 5]
    pack $ldWid(addTpl,f1) -fill both -expand yes -pady 2p -padx 2p

    grid [ttk::label $ldWid(addTpl,f1).text1 -text [mc "Customer"]] -column 0 -row 0 -padx 2p -pady 2p -sticky e
    grid [ttk::entry $ldWid(addTpl,f1).entry1 -textvariable job(CustName) \
                                                -validate all \
                                                -validatecommand {AutoComplete::AutoComplete %W %d %v %P $job(CustomerList)}] -column 1 -columnspan 2 -row 0 -padx 2p -pady 2p -sticky ew
        focus $ldWid(addTpl,f1).entry1
        bind $ldWid(addTpl,f1).entry1 <FocusOut> {
            if {[%W get] ne ""} {
                ${log}::notice Get Customer Titles
                ea::db::ld::getCustomerTitles

                ${log}::debug Get Customer Code
                ea::db::ld::getCustomerCode

                $ldWid(addTpl,f1).cbox0 configure -values $job(CustomerTitles)
            }
        }


    grid [ttk::label $ldWid(addTpl,f1).text2 -text [mc "Title"]] -column 3 -row 0 -padx 2p -pady 2p -sticky e
    grid [ttk::combobox $ldWid(addTpl,f1).cbox0 -textvariable job(Title) -width 30 \
                                                -state readonly] -column 4 -row 0 -padx 2p -pady 2p -sticky w
        bind $ldWid(addTpl,f1).cbox0 <FocusOut> {
            ea::db::ld::getCustomerTitleID
        }

    grid [ttk::label $ldWid(addTpl,f1).text2a -text [mc "Template Name"]] -column 0 -row 2 -padx 2p -pady 2p -sticky e

    grid [ttk::label $ldWid(addTpl,f1).text2b -text [mc "Match on"]] -column 0 -row 3 -padx 2p -pady 2p -sticky e
    grid [ttk::combobox $ldWid(addTpl,f1).cboxb -width 12 -state readonly -values [list "Job Number" "Job Name" ""] -textvariable tplLabel(MatchOn)] -column 1 -row 3 -padx 2p -pady 2p -sticky w

    grid [ttk::entry $ldWid(addTpl,f1).entryb -textvariable tplLabel(MatchBy)] -column 2 -row 3 -padx 2p -pady 2p -sticky ew
        tooltip::tooltip $ldWid(addTpl,f1).entryb [mc "Use % as a wildcard"]


    grid [ttk::checkbutton $ldWid(addTpl,f1).bkbtn1 -text [mc "Active?"] -variable tplLabel(Status)] -column 4 -row 2 -pady 2p -padx 2p -sticky w

    ##
	## Setup the Notebook
	##
    set nbk [ttk::notebook $ldWid(addTpl).f2 -padding 10]
    pack $nbk -fill both

    ttk::notebook::enableTraversal $nbk

    # Create the tabs
    #
    $nbk add [ttk::frame $nbk.labelData] -text [mc "Label Data"]
    $nbk add [ttk::frame $nbk.shipments] -text [mc "Shipments"]
    $nbk add [ttk::frame $nbk.defaults] -text [mc "Defaults"]

    ##
    ## Body / Label Data
    ## This is automatically created based on the profile selected, and ea::gui::ld::genLines

    set ldWid(addTpl,ldf0) [ttk::labelframe $nbk.labelData.ldf0 -text [mc "Label Information"] -padding 2]
    pack $ldWid(addTpl,ldf0) -expand yes -fill x -pady 5p -padx 5p

    grid [ttk::checkbutton $ldWid(addTpl,ldf0).ckbtnStatus -text [mc "Active?"] -variable tplLabel(LabelVersionStatus)] -column 1 -row 0 -sticky w -padx 2p -pady 2p

    grid [ttk::label $ldWid(addTpl,ldf0).versionTxt -text [mc "Label Version"]] -column 0 -row 1 -padx 2p -pady 2p -sticky e
    grid [ttk::combobox $ldWid(addTpl,ldf0).versionDescCbox -width 35 \
                                                            -state readonly \
                                                            -textvariable tplLabel(LabelVersionDesc,current) \
                                                            -postcommand {ea::db::ld::getLabelVersionList $ldWid(addTpl,ldf0).versionDescCbox}] -column 1 -row 1 -padx 2p -pady 5p -sticky ew

        # <FocusOut>
        bind $ldWid(addTpl,ldf0).versionDescCbox <<ComboboxSelected>> {
             #${log}::debug Is this an unknown version (new?) $tplLabel(LabelVersionDesc,current)
             ea::code::ld::resetLabelVersion -keepVersion

             if {$tplLabel(LabelVersionDesc,current) eq ""} {return}
             ea::db::ld::setLabelVersionVars
        }

    grid [ttk::button $ldWid(addTpl,ldf0).addBtn -image addItem16x16 -command {ea::gui::ld::version -new}] -column 2 -row 1 -sticky w
        tooltip::tooltip $ldWid(addTpl,ldf0).addBtn [mc "Add"]

    grid [ttk::button $ldWid(addTpl,ldf0).delBtn -image delItem16x16 -command {ea::db::ld::deleteVersion $tplLabel(LabelVersionDesc,current) $ldWid(f2b).listbox}] -column 3 -row 1 -sticky w
        tooltip::tooltip $ldWid(addTpl,ldf0).delBtn [mc "Delete"]

    grid [ttk::button $ldWid(addTpl,ldf0).copyBtn -image copyPage16x16 -command {ea::gui::ld::version -copy} -state disable] -column 4 -row 1 -sticky w
        tooltip::tooltip $ldWid(addTpl,ldf0).copyBtn [mc "Copy"]



    #grid [ttk::checkbutton $ldWid(addTpl,ldf0).ckbtnSerialize -text [mc "Serialize?"] -variable tplLabel(SerializeLabel)] -column 2 -row 1 -sticky w -padx 2p -pady 2p

    grid [ttk::label $ldWid(addTpl,ldf0).text3 -text [mc "Label Size"]] -column 0 -row 3 -pady 2p -padx 2p -sticky e
    grid [ttk::combobox $ldWid(addTpl,ldf0).cbox1 -textvariable tplLabel(LabelSize) \
                                                -state readonly \
                                                -postcommand {ea::db::ld::getSizes $ldWid(addTpl,ldf0).cbox1}] -column 1 -row 3 -pady 2p -padx 2p -sticky ew

        bind $ldWid(addTpl,ldf0).cbox1 <<ComboboxSelected>> {
            ea::db::ld::getLabelSizeID  %W
        }

    grid [ttk::label $ldWid(addTpl,ldf0).text4 -text [mc "Label Document"]] -column 0 -row 4 -pady 2p -padx 2p -sticky e
    grid [ttk::entry $ldWid(addTpl,ldf0).entry3 -textvariable tplLabel(LabelPath) -width 30] -column 1 -row 4 -pady 2p -padx 2p -sticky ew
    grid [ttk::button $ldWid(addTpl,ldf0).btn1 -text [mc "Browse..."] \
                                                -command {ea::code::ld::getOpenFile $ldWid(addTpl,ldf0).entry3}] -column 2 -columnspan 3 -row 4 -pady 2p -padx 2p -sticky w




    # Tablelist goes here
    set ldWid(f2b) [ttk::frame $ldWid(addTpl,ldf0).f2b]
    grid $ldWid(f2b) -column 0 -columnspan 5 -row 5 -pady 3p -padx 5p -sticky news

    tablelist::tablelist $ldWid(f2b).listbox -columns {
                                                    3 "..." center
                                                    8 "Row" center
                                                    35 "Label Text"
                                                    10 "Editable" center
                                                    } \
                                        -showlabels yes \
                                        -selectbackground yellow \
                                        -selectforeground black \
                                        -stripebackground lightblue \
                                        -exportselection yes \
                                        -showseparators yes \
                                        -fullseparators yes \
                                        -forceeditendcommand no \
                                        -yscrollcommand [list $ldWid(f2b).scrolly set] \
                                        -editstartcommand ea::code::ld::editStartCmd \
                                        -editendcommand ea::code::ld::editEndCmd

        $ldWid(f2b).listbox columnconfigure 0 -showlinenumbers 1 -name count
        $ldWid(f2b).listbox columnconfigure 1 -name row -editable yes -editwindow ttk::combobox
        $ldWid(f2b).listbox columnconfigure 2 -name labelText -editable yes -editwindow ttk::combobox -labelalign center -stretch yes
        $ldWid(f2b).listbox columnconfigure 3 -name editable -editable yes -editwindow ttk::combobox -labelalign center -hide yes

    ttk::scrollbar $ldWid(f2b).scrolly -orient v -command [list $ldWid(f2b).listbox yview]

    grid $ldWid(f2b).listbox -column 0 -row 1 -sticky news
    grid columnconfigure $ldWid(f2b) $ldWid(f2b).listbox -weight 2
    grid rowconfigure $ldWid(f2b) $ldWid(f2b).listbox -weight 2

    grid $ldWid(f2b).scrolly -column 1 -row 0 -sticky nse

    ::autoscroll::autoscroll $ldWid(f2b).scrolly ;# Enable the 'autoscrollbar'

    ##
    ## Tab 2 / Shipments
    ##
    set ldWid(addTpl,f2b) [ttk::labelframe $nbk.shipments.shf0 -text [mc "Shipment Quantities"] -padding 2]
    pack $ldWid(addTpl,f2b) -expand no -fill x -pady 5p -padx 5p

    grid [ttk::label $ldWid(addTpl,f2b).versionTxt -text [mc "Label Version"]] -column 0 -row 0 -padx 2p -pady 2p -sticky e
    grid [ttk::combobox $ldWid(addTpl,f2b).versionDescCbox -width 35 -state readonly \
                                                            -textvariable tplLabel(LabelVersionDesc,current) \
                                                            -postcommand {ea::db::ld::getLabelVersionList $ldWid(addTpl,f2b).versionDescCbox}] -column 1 -columnspan 2 -row 0 -padx 2p -pady 5p -sticky ew
        bind $ldWid(addTpl,f2b).versionDescCbox <<ComboboxSelected>> {
             ${log}::debug Changing versions for Shipment Quantities
             ea::code::ld::resetLabelVersion -keepVersion

             if {$tplLabel(LabelVersionDesc,current) eq ""} {return}
             ea::db::ld::setLabelVersionVars
        }

    grid [ttk::label $ldWid(addTpl,f2b).boxQtyTxt -text [mc "Max. Box Qty"]] -column 0 -row 1 -padx 2p -sticky e
        tooltip::tooltip $ldWid(addTpl,f2b).boxQtyTxt [mc "This is optional, leave blank if unknown"]

    grid [ttk::entry $ldWid(addTpl,f2b).boxQtyEntry -textvariable tplLabel(MaxBoxQty)] -column 1 -row 1 -padx 2p -sticky ew
        tooltip::tooltip $ldWid(addTpl,f2b).boxQtyEntry [mc "This is optional, leave blank if unknown"]

    grid [ttk::label $ldWid(addTpl,f2b).shipQtyTxt -text [mc "Ship. Qty"]] -column 0 -row 2 -padx 2p -sticky e

    grid [ttk::entry $ldWid(addTpl,f2b).shipQtyEntry] -column 1 -row 2 -padx 2p -sticky ew
        bind $ldWid(addTpl,f2b).shipQtyEntry <Return> {
            ea::code::ld::AddShipQty $ldWid(addTpl,f2b).shipQtyEntry $ldWid(addTpl,f2b).lbox
        }

    grid [ttk::button $ldWid(addTpl,f2b).addBtn  -image addItem16x16 -command {ea::code::ld::AddShipQty $ldWid(addTpl,f2b).shipQtyEntry $ldWid(addTpl,f2b).lbox}] -column 2 -row 2 -padx 2p -sticky w

    grid [listbox $ldWid(addTpl,f2b).lbox -selectmode extended] -column 1 -row 3 -pady 5p -sticky news
        bind $ldWid(addTpl,f2b).lbox <Double-1> {
            ea::code::ld::delShipQty %W
        }

        bind $ldWid(addTpl,f2b).lbox <Delete> {
            ea::code::ld::delShipQty %W
        }

        bind $ldWid(addTpl,f2b).lbox <BackSpace> {
            ea::code::ld::delShipQty %W
        }


    ##
    ## Body / Defaults
    ## This is to adjust the default behavior for the Box Labels module
    set ldWid(addTpl,df0) [ttk::labelframe $nbk.defaults.f0 -text [mc "Default Label Mapping"] -padding 2]
    pack $ldWid(addTpl,df0) -expand no -fill x -pady 5p -padx 5p

    grid [ttk::label $ldWid(addTpl,df0).row01 -text [mc "Row01"]] -column 0 -row 0 -padx 2p -pady 2p -sticky e
    grid [ttk::combobox $ldWid(addTpl,df0).row01Cbox -width 35 -state readonly \
                                                            -textvariable "" \
                                                            -values $mod(Box_Labels,uservars) \
                                                            -postcommand {}] -column 1 -row 0 -padx 2p -pady 2p -sticky ew

    grid [ttk::label $ldWid(addTpl,df0).row02 -text [mc "Row02"]] -column 0 -row 1 -padx 2p -pady 2p -sticky e
    grid [ttk::combobox $ldWid(addTpl,df0).row02Cbox -width 35 -state readonly \
                                                            -textvariable "" \
                                                            -values $mod(Box_Labels,uservars) \
                                                            -postcommand {}] -column 1 -row 1 -padx 2p -pady 2p -sticky ew

    grid [ttk::label $ldWid(addTpl,df0).row03 -text [mc "Row03"]] -column 0 -row 2 -padx 2p -pady 2p -sticky e
    grid [ttk::combobox $ldWid(addTpl,df0).row03Cbox -width 35 -state readonly \
                                                            -textvariable "" \
                                                            -values $mod(Box_Labels,uservars) \
                                                            -postcommand {}] -column 1 -row 2 -padx 2p -pady 2p -sticky ew

    set ldWid(addTpl,df1) [ttk::labelframe $nbk.defaults.f1 -text [mc "Misc. Options"] -padding 2]
    pack $ldWid(addTpl,df1) -expand no -fill x -pady 5p -padx 5p

    grid [ttk::checkbutton $ldWid(addTpl,df1).ckbtn -text [mc "Do not import quantities"]] -column 0 -row 0 -pady 2p -padx 2p


    ##
    ## Save buttons
    ##
    set btnBar [ttk::frame $ldWid(addTpl).f3]
    pack $btnBar -pady 5p -padx 5p -anchor se

    grid [ttk::button $btnBar.save -text [mc "Save"] -command {ea::code::ld::saveTemplateHeader}] -column 0 -row 0 -pady 2p -padx 2p
    grid [ttk::button $btnBar.cncl -text [mc "Close"] -command {destroy $ldWid(addTpl); ea::db::ld::getTemplateData; ea::code::ld::resetWidgets}] -column 1 -row 0 -pady 2p -padx 2p

    # Context Menu
    if {[winfo exists .popupMenu]} {destroy .popupMenu}
    set m [menu .popupMenu]
    $m add command -label [mc "Paste"] -command {ea::gui::ld::menuPasteQty $ldWid(addTpl,f2b).lbox}
    bind $ldWid(addTpl,f2b).lbox <<Button3>> {tk_popup .popupMenu %X %Y}

    ##
    ## MODIFY
    ##
    # If we are modifying then populate the widgets, and disable Customer and Title fields
    if {$args eq "-modify"} {
        grid [ttk::combobox $ldWid(addTpl,f1).cbox0a -width 30 -textvariable tplLabel(Name) -state readonly] -column 1 -row 2 -columnspan 2 -padx 2p -pady 2p -sticky ew

        ea::code::ld::modifyTemplate $ldWid(f1b).listbox
        bind $ldWid(addTpl,f1).cbox0a <<FocusOut>> {
            ${log}::debug Retrieve template ID for template: [%w get]
            ${log}::debug [db eval "SELECT tplID from LabelTPL WHERE PubTitleID = $job(TitleID) AND tplLabelName = '[%W get]'"]
        }

        bind $ldWid(addTpl,f1).cbox0 <FocusOut> {
            ea::db::ld::getTemplates
        }

        $ldWid(addTpl,f1).entry1 configure -state disabled
        $ldWid(addTpl,f1).cbox0 configure -state disabled
    } else {
        ea::code::ld::resetWidgets
        ## Default value for status should be 1, and only changed by end user, or by setting on previously entered customer/title entry
        set tplLabel(Status) 1
        set tplLabel(LabelVersionStatus) 1

        grid [ttk::entry $ldWid(addTpl,f1).cbox0a -width 30 -textvariable tplLabel(Name)] -column 1 -row 2 -columnspan 2 -padx 2p -pady 2p -sticky ew
        # insert some blank lines to start with
        for {set x 1} {10 >= $x} {incr x} {
            $ldWid(f2b).listbox insert end ""
        }
    }
} ;# ea::gui::ld::addTemplate

proc ea::gui::ld::version {args} {
    # args are -new, -modify -copy
    global log ldWid
    set ldWid(addVersion) .addVersion

    if {[winfo exists $ldWid(addVersion)]} {${log}::notice addVersion window already exists, aborting.; return}

    toplevel $ldWid(addVersion)
    wm transient $ldWid(addVersion) .addTemplate
    wm title $ldWid(addVersion) [mc "Add/Edit Version"]

    set width [winfo reqwidth .addTemplate]
    set height [winfo reqheight .addTemplate]
    set x [expr {$width / 2}]
    set y [expr {$height / 2}]
    wm geometry $ldWid(addVersion) +$x+$y

    ${log}::debug addVersion: winfo geom: [winfo geometry $ldWid(addVersion)]

    set f0 [ttk::frame $ldWid(addVersion).f0 -padding 5p]
    pack $f0 -expand yes -fill both

    grid [ttk::label $f0.txt1 -text [mc "Version Name"]] -column 0 -row 0 -pady 2p -padx 2p -sticky e
    grid [ttk::entry $f0.entry1] -column 1 -row 0 -pady 2p -padx 2p -sticky ew
        focus $f0.entry1
    grid [ttk::button $f0.btn1 -text [mc "OK"] -command {ea::db::ld::writeVersion $ldWid(addVersion).f0.entry1}] -column 2 -row 0 -padx 2p -pady 2p -sticky w
    grid [ttk::button $f0.btn2 -text [mc "Close"] -command {destroy $ldWid(addVersion)}] -column 3 -row 0 -padx 2p -pady 2p -sticky w

} ;# ea::gui::ld::addVersion

proc ea::gui::ld::menuPasteQty {widListbox} {
    global log
    foreach item [clipboard get] {
        set item [string trim [regsub -all {[a-zA-Z,]} "$item" "" ]]
        if {$item ne ""} {
            $widListbox insert end $item
        }
    }
} ;# ea::gui::ld::menuPasteQty
