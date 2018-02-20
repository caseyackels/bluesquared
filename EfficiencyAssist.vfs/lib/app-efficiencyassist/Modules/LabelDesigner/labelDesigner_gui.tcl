# Creator: Casey Ackels (C) 2017

package provide eAssist_ModLabelDesigner 1.0

proc ea::gui::designerGUI {} {
    global log tmplID numLines job tplLabel

#    # Clear the frames before continuing
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
    
    # CSR Name
    grid [ttk::label $f0.csrNameTxt -text [mc "CSR Name"]] -column 0 -row 1 -pady 2p -padx 2p -sticky e
    grid [ttk::combobox $f0.csrNameCbox -postcommand "dbCSR::getCSRID $f0.csrNameCbox {FirstName LastName}" \
                                        -textvariable job(CSRName) -validate all \
                                        -validatecommand {AutoComplete::AutoComplete %W %d %v %P [dbCSR::getCSRID "" {FirstName LastName}]}] -column 1 -columnspan 2 -row 1 -pady 2p -padx 2p -sticky ew
    grid [ttk::button $f0.csrRequestBtn -text [mc "Request to Add CSR"] -state disable] -column 3 -row 1 -pady 2p -padx 2p -sticky w
    
    # Job Title
    grid [ttk::label $f0.tplNameTxt -text [mc "Job Title"]] -column 0 -row 2 -pady 2p -padx 2p -sticky e
    grid [ttk::combobox $f0.tplNameCbox -textvariable job(Title)] -column 1 -columnspan 2 -row 2 -pady 2p -padx 2p -sticky ew

    
   
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
    grid [ttk::label $f1.versionNameTxt -text [mc "Label Name"]] -column 0 -row 1 -pady 2p -padx 2p -sticky e
    grid [ttk::combobox $f1.versionNameCbox -textvariable tplLabel(Name) -postcommand "ea::db::lb::getLabelNames $f1.versionNameCbox"] -column 1 -columnspan 4 -row 1 -pady 2p -padx 2p -sticky ew
    
    # Label file
    grid [ttk::label $f1.browsetxt -text [mc "Label File"]] -column 0 -row 2 -pady 2p -padx 2p -sticky e
    grid [ttk::entry $f1.fileentry -width 75 -textvariable tplLabel(LabelPath) ] -column 1 -columnspan 4 -row 2 -pady 2p -padx 2p -sticky w
    grid [ttk::button $f1.browsebtn -text [mc "Browse..."] -command [list ea::code::lb::getOpenFile $f1.fileentry]] -column 5 -row 2 -pady 2p -padx 2p -sticky w
    
    # Label Dimensions (this is informational only)
    grid [ttk::label $f1.labelWidthTxt -text [mc "Width x Height"]] -column 0 -row 3 -pady 2p -padx 2p -sticky e
    grid [ttk::entry $f1.labelWidthEntry -width 5 -textvariable tplLabel(Width)] -column 1 -row 3 -pady 2p -padx 0p -sticky w
    grid [ttk::entry $f1.labelHeightEntry -width 5 -textvariable tplLabel(Height)] -column 2 -row 3 -pady 2p -padx 0p -sticky w
    
    # Generate number of lines
    grid [ttk::label $f1.numLinesTxt -text [mc "Number of Rows"]] -column 0 -row 4 -pady 2p -padx 2p -sticky e
    grid [ttk::entry $f1.numLinesEntry -textvariable tplLabel(NumRows) -width 5] -column 1 -row 4 -pady 2p -padx 2p -sticky w
    grid [ttk::button $f1.numLinesBtn -text [mc "Generate"] -command "ea::code::lb::genLines"] -column 2 -row 4 -pady 2p -padx 2p -sticky w
    
    # Fixed qty / box
    grid [ttk::label $f1.fixedBoxQtyTxt -text [mc "Fixed Boxed Qty"]] -column 0 -row 5 -pady 2p -padx 2p -sticky e
    grid [ttk::entry $f1.fixedBoxQtyEntry -textvariable tplLabel(FixedBoxQty) -width 5] -column 1 -row 5 -pady 2p -padx 2p -sticky w
    
    # Fixed row information
    grid [ttk::checkbutton $f1.fixedLineInfoCkbtn -text [mc "Label contains fixed row info"] -variable tplLabel(FixedLabelInfo)] -column 1 -columnspan 3 -row 6 -pady 2p -padx 2p -sticky w
    
    bind $f1.versionNameCbox <<ComboboxSelected>> {
        ea::db::lb::getLabelSpecs %W
    }

##
## Save buttons
##
    set btnBar [ttk::frame .container.frame3]
    pack $btnBar -fill x -pady 5p -padx 5p
    
    grid [ttk::button $btnBar.save -text [mc "Save"] -command {ea::code::lb::saveLabel}] -column 0 -row 0
    grid [ttk::button $btnBar.cncl -text [mc "Cancel"]] -column 1 -row 0 -padx 2

    
    # Bindings
    bind $f0.custCodeEntry <FocusOut> {
        set id [%W get]
        if {$id != ""} {
            #$::customer::f1.entry0b insert end [db eval "SELECT CustName FROM Customer WHERE Cust_ID='$id'"
            set tmpCustName [join [db eval "SELECT CustName FROM Customer WHERE Cust_ID='$id'"]]
            if {$tmpCustName != ""} {
                set job(CustName) $tmpCustName
                #${log}::debug $job(CustName)
            } else {
                ${log}::debug Customer Doesn't Exist
            }
            #${log}::debug Populating TITLE
            .container.frame0.tplNameCbox configure -values [db eval "SELECT TitleName FROM PubTitle WHERE CUSTID = '$id'"]
        }
    }
    
    bind $f0.custNameCbox <FocusOut> {
        set custName [%W get]
        if {$custName != ""} {
            #$::customer::f1.entry0b insert end [db eval "SELECT CustName FROM Customer WHERE Cust_ID='$id'"
            set tmpCustID [join [db eval "SELECT Cust_ID FROM Customer WHERE CustName='$custName'"]]
                if {$tmpCustID != ""} {
                    set job(CustID) $tmpCustID
                }
            
            if {$job(CustID) == "" && $tmpCustID == ""} {
                ${log}::notice No Data was found in the ID Field - Issuing warning notice.
                ${log}::notice Warning, no data was found in the ID Field (Customer Name)
            } else {
                ${log}::debug Check to see if CUSTNAME is in DB. If not, reset all widgets except custid/custname
                ${log}::debug [db eval "SELECT CustName from Customer WHERE CustName = '$custName'"]
                if {[db eval "SELECT CustName from Customer WHERE CustName = '$custName'"] eq ""} {
                    ${log}::debug Reset global vars
                    ea::code::lb::resetWidgets
                    #set job(CSRName) ""
                    #set job(Title) ""
                    #set tplLabel(FixedBoxQty) ""
                    #set tplLabel(FixedLabelInfo) ""
                    #set tplLabel(Height) ""
                    #set tplLabel(Width) ""
                    #set tplLabel(LabelPath) ""
                    #set tplLabel(Name) ""
                    #set tplLabel(NotePriv) ""
                    #set tplLabel(NotePub) ""
                    #set tplLabel(NumRows) ""
                    #set tplLabel(tmpValues) ""
                    #
                    #set job(NewCustomer) 1
                }
            }
        }
    }
    
    #bind $f0.tplNameCbox <<ComboboxSelected>> {set job(Title) [.container.frame0.tplNameCbox get]}
    
}

proc ea::code::lb::genLines {} {
    global log tplLabel
    
    ${log}::debug Generating $tplLabel(NumRows) for Labels!
    ${log}::debug in widget .container.frame2
    
    if {[winfo exists .container.frame2]} {
        ${log}::debug Label Lines frame already exists, destroying...
        destroy .container.frame2}
    
##
## Label Information
##
    set f2 [ttk::labelframe .container.frame2 -text [mc "Label Information"] -padding 10]
    pack $f2 -fill x -pady 5p -padx 5p -anchor n
    
    grid [ttk::label $f2.headerDesc -text [mc "Line Description"]] -column 1 -row 0 -sticky ew
    grid [ttk::label $f2.headerUserEdit -text [mc "User Editable?"]] -column 2 -row 0 -sticky ew
    
    # If we try making more rows after the initial we encounter an error - REMOVE ALL WIDGETS IF CREATED, THEN CREATE MORE
    
    set col 0
    set rw 1
    
    for {set x 1} {$tplLabel(NumRows) >= $x} {incr x} {
        ${log}::debug Generating line $x
        
        # Create GUI
        grid [ttk::label $f2.description$x -text [mc "Row $x"]] -column $col -row $rw -pady 2p -padx 2p -sticky e
        incr col
        grid [ttk::entry $f2.labelData$x -width 35] -column $col -row $rw -pady 2p -padx 2p -sticky ew
        incr col
        grid [ttk::checkbutton $f2.userEditable$x] -column $col -row $rw -pady 2p -padx 2p -sticky ew
        
        # reset counters
        incr rw
        set col 0
    }
    
}