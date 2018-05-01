# Creator: Casey Ackels (C) 2017

package provide eAssist_ModLabelDesigner 1.0

# Quick widget re-creation
# use designerGUI as a launcher, put the frames in their own proc. So we can call resetFrames then $frameCreator when we want to clear out all widgets.

proc ea::gui::designerGUI {} {
    global log tmplID numLines job tplLabel

    # Clear the frames before continuing
    eAssist_Global::resetFrames parent
    

###
### Job Info
###
    set f0 [ttk::labelframe .container.frame0 -text [mc "Job Info"] -padding 10]
    pack $f0 -fill x -pady 5p -padx 5p -anchor n
       
       set custNameList [db eval "SELECT CustName FROM Customer WHERE Status='1'"]
       
    # Customer Code/Name
    grid [ttk::label $f0.custCodeTxt -text [mc "Customer Code/Name"]] -column 0 -row 0
    grid [ttk::entry $f0.custCodeEntry -width 10 -textvariable job(CustID) \
                            -validate all \
                            -validatecommand [list AutoComplete::AutoComplete %W %d %v %P [customer::validateCustomer id $f0]] ] -column 1 -row 0 -pady 2p -padx 2p
    
    grid [ttk::combobox $f0.custNameCbox -width 35 -textvariable job(CustName) \
                            -values [db eval "SELECT CustName FROM Customer WHERE Status='1'"] \
                            -validate all \
                            -validatecommand [list AutoComplete::AutoComplete %W %d %v %P [customer::validateCustomer name $f0]] ] -column 2 -row 0 -pady 2p -padx 2p
    
    grid [ttk::button $f0.resetWidgets -text [mc "Reset"] -command {ea::code::lb::resetWidgets all}] -column 3 -row 0 -pady 2p -padx 2p -sticky w
    
    # Job Title
    grid [ttk::label $f0.tplNameTxt -text [mc "Job Title"]] -column 0 -row 1 -pady 2p -padx 2p -sticky e
    grid [ttk::combobox $f0.tplNameCbox -textvariable job(Title)] -column 1 -columnspan 2 -row 1 -pady 2p -padx 2p -sticky ew
    
    # CSR Name
    grid [ttk::label $f0.csrNameTxt -text [mc "CSR Name"]] -column 0 -row 2 -pady 2p -padx 2p -sticky e
    grid [ttk::combobox $f0.csrNameCbox -postcommand "dbCSR::getCSRID $f0.csrNameCbox {FirstName LastName}" \
                                        -textvariable job(CSRName) -validate all \
                                        -validatecommand {AutoComplete::AutoComplete %W %d %v %P [dbCSR::getCSRID "" {FirstName LastName}]}] -column 1 -columnspan 2 -row 2 -pady 2p -padx 2p -sticky ew
    grid [ttk::button $f0.csrRequestBtn -text [mc "Request to Add CSR"] -state disable] -column 3 -row 2 -pady 2p -padx 2p -sticky w


##
## Label Setup
##

    set f1 [ttk::labelframe .container.frame1 -text [mc "Label Properties"] -padding 10]
    pack $f1 -fill x -pady 5p -padx 5p -anchor n
    
    # Template ID
    grid [ttk::label $f1.tplIDtxt -text [mc "Template ID"]] -column 0 -row 0 -pady 2p -padx 2p -sticky e
    grid [ttk::label $f1.tplID -text sample -textvariable tplLabel(ID)] -column 1 -row 0 -pady 2p -padx 2p -sticky w
    #set tmplID 001
    
    # Label Name
    grid [ttk::label $f1.versionNameTxt -text [mc "Template Name"]] -column 0 -row 1 -pady 2p -padx 2p -sticky e
    grid [ttk::combobox $f1.versionNameCbox -textvariable tplLabel(Name) -postcommand "ea::db::lb::getLabelNames $f1.versionNameCbox"] -column 1 -row 1 -pady 2p -padx 2p -sticky ew
    
    # Label file
    grid [ttk::label $f1.browsetxt -text [mc "Label File"]] -column 0 -row 2 -pady 2p -padx 2p -sticky e
    grid [ttk::entry $f1.fileentry -width 75 -textvariable tplLabel(LabelPath) ] -column 1 -row 2 -pady 2p -padx 2p -sticky w
    grid [ttk::button $f1.browsebtn -text [mc "Browse..."] -command [list ea::code::lb::getOpenFile $f1.fileentry]] -column 2 -row 2 -pady 2p -padx 2p -sticky w
    
    # Label Profile
    grid [ttk::label $f1.labelProfile -text [mc "Header Profile"]] -column 0 -row 3 -pady 2p -padx 2p -sticky e
    grid [ttk::combobox $f1.labelProfileCbox -textvariable tplLabel(LabelProfileDesc) -state readonly -postcommand "ea::db::lb::getProfile $f1.labelProfileCbox"] -column 1 -row 3 -pady 2p -padx 2p -sticky ew
    #grid [ttk::combobox $f1.labelProfileCbox -textvariable tplLabel(LabelProfileDesc) -postcommand "ea::db::lb::setProfileVars"] -column 1 -row 3 -pady 2p -padx 2p -sticky ew
    grid [ttk::button $f1.labelProfileBtn -text [mc "Add Profile"] -command {ea::gui::lb::profiles}] -column 2 -row 3 -pady 2p -padx 2p -sticky w
    grid [ttk::button $f1.headerFileBtn -text [mc "Create dummy file"] -state disabled -command {ea::code::lb::createDummyFile}] -column 3 -row 3 -pady 2p -padx 2p -sticky w
   
    # Label Dimensions (this is informational only)
    grid [ttk::label $f1.labelSizeTxt -text [mc "Label Size"]] -column 0 -row 4 -pady 2p -padx 2p -sticky e
    grid [ttk::combobox $f1.labelSizecBox -width 25 -textvariable tplLabel(Size) -postcommand "ea::db::lb::getSizes $f1.labelSizecBox"] -column 1 -row 4 -pady 2p -padx 2p -sticky w

    
    # Fixed qty / box
    grid [ttk::label $f1.fixedBoxQtyTxt -text [mc "Fixed Box Qty"]] -column 0 -row 6 -pady 2p -padx 2p -sticky e
    grid [ttk::entry $f1.fixedBoxQtyEntry -textvariable tplLabel(FixedBoxQty) -width 5] -column 1 -row 6 -pady 2p -padx 2p -sticky w
        tooltip::tooltip $f1.fixedBoxQtyEntry [mc "Leave blank if unknown"]
    
    # Fixed row information
    # 4-17-18 commented out. I don't think we'll need this chec
    #grid [ttk::checkbutton $f1.fixedLineInfoCkbtn -text [mc "Label contains fixed row info"] -variable tplLabel(FixedLabelInfo)] -column 1 -columnspan 3 -row 7 -pady 2p -padx 2p -sticky w
    
    # Serialize Label
    grid [ttk::checkbutton $f1.serializeLabelCkbtn -text [mc "Serialize Label"] -variable tplLabel(SerializeLabel)] -column 1 -columnspan 3 -row 8 -pady 2p -padx 2p -sticky w
    
    bind $f1.versionNameCbox <<ComboboxSelected>> {
        ea::db::lb::getLabelSpecs %W
        .container.frame1.headerFileBtn configure -state normal
    }
    
    bind $f1.labelSizecBox <<ComboboxSelected>> {
        set tplLabel(LabelSizeID) [db eval "SELECT labelSizeID FROM LabelSizes WHERE labelSizeDesc = '[%W get]'"]
    }
    
    bind $f1.labelProfileCbox <<ComboboxSelected>> {
 
        if {[%W get] ne ""} {
            ${log}::debug Profile loaded: [%W get] - Activating Dummy File Button
            .container.frame1.headerFileBtn configure -state normal
            ea::db::lb::setProfileVars
        } else {
            .container.frame1.headerFileBtn configure -state disable
        }
    }
    
    bind $f1.labelProfileCbox <FocusOut> {
        if {[%W get] eq ""} {
            ${log}::debug Profile not selected. Disabling Dummy File Button
            .container.frame1.headerFileBtn configure -state disable
        }
    }

##
## Save buttons
##
    set btnBar [ttk::frame .container.frame3]
    pack $btnBar -pady 5p -padx 5p -anchor e
    
    grid [ttk::button $btnBar.save -text [mc "Save"] -command {ea::code::lb::saveLabel}] -column 0 -row 0
    #grid [ttk::button $btnBar.cncl -text [mc "Cancel"]] -column 2 -row 0 -padx 2

    
    # Bindings
    bind $f0.custCodeEntry <FocusOut> {
        set id [%W get]
        if {$id != ""} {
            #$::customer::f1.entry0b insert end [db eval "SELECT CustName FROM Customer WHERE Cust_ID='$id'"
            set tmpCustName [join [db eval "SELECT CustName FROM Customer WHERE Cust_ID='$id'"]]
            if {$tmpCustName ne ""} {
                set job(CustName) $tmpCustName

                ${log}::debug Customer exists...
            }
            #${log}::debug Populating TITLE
            .container.frame0.tplNameCbox configure -values [db eval "SELECT TitleName FROM PubTitle WHERE CUSTID = '$id'"]
        }
    }
    
    bind $f0.custNameCbox <FocusOut> {
        set custName [%W get]
        if {$custName != ""} {
            set tmpCustID [join [db eval "SELECT Cust_ID FROM Customer WHERE CustName='$custName'"]]
                if {$tmpCustID != ""} {
                    set job(CustID) $tmpCustID
                }
            
            if {$job(CustID) == "" && $tmpCustID == ""} {
                    ${log}::notice Warning, no data was found in the Customer ID field. Clearing widgets...
                    ea::code::lb::resetWidgets
                    set job(NewCustomer) 1
                    #return
                } else {
                    if {[db eval "SELECT CustName from Customer WHERE CustName = '$custName'"] eq ""} {
                        ${log}::debug Customer not found in database, resetting global vars.
                        ea::code::lb::resetWidgets
                        set job(NewCustomer) 1
                        #return
                    }
                }
                
            if {$job(NewCustomer) == ""} {
                ${log}::debug Populating Title Name dropdown
                .container.frame0.tplNameCbox configure -values [db eval "SELECT TitleName FROM PubTitle WHERE CUSTID = '$job(CustID)'"]
            } else {
                .container.frame0.tplNameCbox configure -values ""
            }
        }
        
    }
    
    # Get CSR name
    bind $f0.tplNameCbox <FocusOut> {
        db eval "SELECT FirstName, LastName FROM CSRs
                    INNER JOIN PubTitle ON CSRs.CSR_ID = PubTitle.CSRID
                    WHERE PubTitle.TitleName = '$job(Title)'
                        AND PubTitle.CustID = '$job(CustID)'" {
                            set job(CSRName) "$FirstName $LastName"
                        }
    }
}

proc ea::code::lb::genLines {} {
    global log tplLabel
    
    #${log}::debug Generating $tplLabel(NumRows) for Labels!
    ${log}::debug Generating row widgets: .container.frame2
    
    if {[winfo exists .container.frame2]} {
        ${log}::debug Label Lines frame already exists, destroying...
        destroy .container.frame2
    }
    
##
## Label Information
##
    set f2 [ttk::labelframe .container.frame2 -text [mc "Label Information"] -padding 10]
    pack $f2 -fill both -expand yes -pady 5p -padx 5p ;#-anchor ne
    
    grid [ttk::label $f2.versionDesc -text [mc "Version"]] -column 0 -row 0 -padx 2p -pady 5p -sticky e 
    grid [ttk::combobox $f2.versionDescCbox -values $tplLabel(LabelVersionDesc)] -column 1 -row 0 -padx 2p -pady 5p -sticky w
        $f2.versionDescCbox set $tplLabel(LabelVersionDesc,current)
        $f2.versionDescCbox state readonly
        
    
    bind $f2.versionDescCbox <<ComboboxSelected>> {
        set tplLabel(LabelVersionID,current) [db eval "SELECT labelVersionID FROM LabelVersions WHERE tplID = '$tplLabel(ID)' AND LabelVersionDesc = '[%W get]'"]
        
        if {$tplLabel(LabelVersionID,current) eq ""} {return}
        
        if {[winfo exists .container.frame2.frame2a]} {
            foreach item [winfo children .container.frame2.frame2a] {
                destroy $item
            }
            ea::db::lb::getVersionLabel
        }
    }

    ea::db::lb::getVersionLabel
}

proc ea::gui::lb::profiles {} {
    # Add/modify profiles for the Label Designer module
    global log tplLabel profile_id
    
    # Setup window
    set w [toplevel .profile]
    wm transient $w .
    wm title $w [mc "Add/Modify Label Profiles"]

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    wm geometry $w 680x400+${locX}+${locY}

    focus $w
    
    set profile_id ""
    
    set f1 [ttk::labelframe $w.f1 -text [mc "Profiles"] -padding 10]
    pack $f1 -fill both -expand yes -pady 5p -padx 5p ;#-anchor ne
    
    grid [ttk::label $f1.txt0a -text [mc "ID"]] -column 0 -row 0 -padx 2p -pady 2p -sticky e
    grid [ttk::label $f1.txt0b -textvariable profile_id] -column 1 -row 0 -padx 2p -pady 2p -sticky w
    
    grid [ttk::label $f1.txt1 -text [mc "Profile"]] -column 0 -row 1 -padx 2p -pady 2p -sticky e
    grid [ttk::combobox $f1.cbox1 -state readonly -textvariable tplLabel(tmp,profile) -postcommand "ea::db::lb::getProfile $f1.cbox1" -width 45] -column 1 -row 1 -padx 2p -pady 2p -sticky ew
    
    grid [ttk::button $f1.btn1 -text [mc "Add"] -command {ea::code::lb::addProfile save .profile.f1.btn1 .profile.f1.btn2 .profile.f2.b.btn1 .profile.f2.b.btn2 .profile.f1.cbox1 .profile.f2.a.lbox1 .profile.f2.c.lbox2}] -column 2 -row 1 -padx 2p -pady 2p
    grid [ttk::button $f1.btn2 -text [mc "Edit"] -state disable -command {ea::code::lb::editProfile edit .profile.f1.btn1 .profile.f1.btn2 .profile.f2.b.btn1 .profile.f2.b.btn2 .profile.f1.cbox1 .profile.f2.c.lbox2}] -column 3 -row 1 -padx 2p -pady 2p
    
    
    # Container frame for listboxes of headers
    set f2 [ttk::frame $w.f2]
    pack $f2 -fill both -expand yes -pady 5p -padx 5p
    
    # Available headers to choose
    set f2a [ttk::labelframe $f2.a -text [mc "Available"] -padding 10]
    grid $f2a -column 0 -row 0 ;#-ipady 5p -padx 5p
    
    grid [listbox $f2a.lbox1 -selectmode extended -width 35 -yscrollcommand [list $f2a.scrolly set]] -column 0 -row 0 -sticky news
        #ea::code::lb::populateProfileCbox $f2a.lbox1
        
        ttk::scrollbar $f2a.scrolly -orient v -command [list $f2a.lbox1 yview]
        grid $f2a.scrolly -column 1 -row 0 -sticky nse
        #::autoscroll::autoscroll $f2a.scrolly
    
    # Buttons
    set f2b [ttk::frame $f2.b]
    grid $f2b -column 1 -row 0 -pady 5p -padx 5p
    
    # Start out in disable mode; once we select a profile or are creating a new (Pressing "add" button), then we enable these buttons
    grid [ttk::button $f2b.btn1 -text [mc >>] -state disable -command {ea::code::lb::assignProfileHeaders add .profile.f2.a.lbox1 .profile.f2.c.lbox2}] -column 0 -row 0 -pady 2p -padx 2p -sticky ew
    grid [ttk::button $f2b.btn2 -text [mc <<] -state disable -command {ea::code::lb::assignProfileHeaders del .profile.f2.a.lbox1 .profile.f2.c.lbox2}] -column 0 -row 1 -pady 2p -padx 2p -sticky ew
    
    # Selected Headers
    set f2c [ttk::labelframe $f2.c -text [mc "Assigned"] -padding 10]
    grid $f2c -column 2 -row 0 -pady 5p -padx 5p
    
    grid [listbox $f2c.lbox2 -selectmode extended -width 35 -yscrollcommand [list $f2a.scrolly set]] -column 0 -row 0 -sticky news
        ttk::scrollbar $f2c.scrolly -orient v -command [list $f2c.lbox1 yview]
        grid $f2c.scrolly -column 1 -row 0 -sticky nse
    
## Bindings
    bind $f1.cbox1 <<ComboboxSelected>> {
        if {[.profile.f1.btn2 cget -state] eq "normal"} {
            ttk::combobox::Unpost %W
        }
            
        ${log}::notice Profile Selected: $tplLabel(tmp,profile)
        set profile_id [ea::db::lb::getProfileID $tplLabel(tmp,profile)]
        
        # Populate listboxes based on existing profile configuration
        ea::code::lb::getAllHeaders $profile_id .profile.f2.a.lbox1 .profile.f2.c.lbox2
        
        # disable add button
        #.profile.f1.btn1 configure -state disable
        # enable edit button
        .profile.f1.btn2 configure -state normal
    }
    
}