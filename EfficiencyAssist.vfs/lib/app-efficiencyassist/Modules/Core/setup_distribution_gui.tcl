# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 10/8/2013

proc eAssistSetup::distributionTypes_GUI {} {
    #****f* distributionTypes_GUI/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	
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
    global log G_setupFrame dist
    global GUI w

    eAssist_Global::resetSetupFrames ;# Reset all frames so we start clean
    
    ##
    ## Parent Frame
    ##

    set fd0 [ttk::labelframe $G_setupFrame.fd0 -text [mc "Distribution Types Setup"]]
    pack $fd0 -expand yes -fill both -ipadx 5p -ipady 5p
    
    # Button frame
    set fd0a [ttk::frame $fd0.fd0a]
    pack $fd0a -anchor w
    
    # Tablelist widget
    set fd0b [ttk::frame $fd0.fd0b]
    pack $fd0b -expand yes -fill both
    
    grid [ttk::button $fd0a.add -text [mc "Add"] -command [list eAssistSetup::modify_distType add $fd0b.tbl]] -column 0 -row 0 -padx 2p -sticky w
    grid [ttk::button $fd0a.del -text [mc "Delete"]] -column 1 -row 0 -padx 2p -sticky w
    grid [ttk::button $fd0a.edit -text [mc "Edit"]] -column 2 -row 0 -padx 2p -sticky w
    
    tablelist::tablelist $fd0b.tbl -columns {
                                            0 "..." center
                                            0 "Distribution Type" center
                                            0 "Default Shipping Type" center
                                            0 "Active" center
                                            } \
                                            -showlabels yes \
                                            -stripebackground yellow \
                                            -showseparators yes \
                                            -fullseparators yes
                                            
    $fd0b.tbl columnconfigure 0 -showlinenumbers yes
    $fd0b.tbl columnconfigure 1 -width 20
    $fd0b.tbl columnconfigure 2 -stretch yes
    
    grid $fd0b.tbl -column 0 -row 0 -padx 2p -pady 2p -sticky news

    grid columnconfigure $fd0b 0 -weight 1
    grid rowconfigure $fd0b 0 -weight 1
    


    #ttk::scrollbar $w(dist_frame1).scrolly -orient v -command [list $w(dist_frame1).listbox yview]
    #ttk::scrollbar $w(dist_frame1).scrollx -orient h -command [list $w(dist_frame1).listbox xview]
    #
    #grid $w(dist_frame1).scrolly -column 1 -row 0 -sticky nse
    #grid $w(dist_frame1).scrollx -column 0 -row 1 -sticky ews
    #
    ## Enable the 'autoscrollbar'
    #::autoscroll::autoscroll $w(dist_frame1).scrolly
    #::autoscroll::autoscroll $w(dist_frame1).scrollx

    
	
} ;# eAssistSetup::distributionTypes_GUI

proc eAssistSetup::modify_distType {{mode add} tbl} {
    #****f* modify_distType/eAssistSetup
    # CREATION DATE
    #   07/27/2015 (Monday Jul 27)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # USAGE
    #   eAssistSetup::modify_distType mode tbl 
    #
    # FUNCTION
    #	Add/View/Edit entries for Distribution Types
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # EXAMPLE
    #   eAssistSetup::modify_distType add $tbl_path
    #
    # NOTES
    #   Default is 'add' mode.
    #  
    # SEE ALSO
    #   
    #   
    #***
    global log
    #ttk::style configure TCombobox -background yellow
    #ttk::style map TCombobox -background \
    #[list disabled grey readonly grey]
    #option add *TCombobox*Listbox.background yellow
    
    
    if {[winfo exists .distSetup] == 1} {destroy .companySetup}
    
    switch -- $mode {
        "add"   {}
        "view"  {}
        "edit"  {}
    }
    
    
    set win .distSetup
    toplevel $win
    wm transient $win .
    wm title $win [mc "[string totitle $mode] Distribution Types"] 
    set locX [expr {[winfo screenwidth .] / 4}]
    set locY [expr {[winfo screenheight .] / 4}]
    #wm geometry $win 670x320+${locX}+${locY}
    wm geometry $win +${locX}+${locY}
    
    ##
    ## Parent Frame
    ##
    set fd [ttk::frame $win.fd]
    pack $fd -expand yes -fill both -padx 2p -pady 2p ;#-ipadx 3p -ipady 3p

    set fd0 [ttk::labelframe $fd.fd0 -text [mc "Configuration"] -padding 10]
    grid $fd0 -column 0 -row 0 -padx 3p -pady 3p -sticky news
    
    set fd1 [ttk::labelframe $fd.fd1 -text [mc "Assign Ship Methods"] -padding 10]
    grid $fd1 -column 1 -row 0 -padx 3p -pady 3p -sticky news
    
    # Configuration frame
    grid [ttk::label $fd0.txt_distType -text [mc "Distribution Type"]] -column 0 -row 0 -padx 2p -sticky e
    grid [ttk::entry $fd0.entry_distType] -column 1 -row 0 -sticky ew
        focus $fd0.entry_distType
    
    grid [ttk::label $fd0.txt_reporting -text [mc "-Reporting-"]] -column 0 -row 1 -sticky w
    grid [ttk::checkbutton $fd0.summarize -text [mc "Summarize Shipments"]] -column 0 -row 2 -padx 2p -pady 3p -sticky w
    
    grid [ttk::label $fd0.txt_genFiles -text [mc "-Generated files for MIS-"]] -column 0 -row 3 -sticky w
    grid [ttk::checkbutton $fd0.singleEntry -text [mc "Create single entry"]] -column 0 -row 4 -padx 2p -sticky w
    grid [ttk::label $fd0.txt_useAddr -text [mc "Use address"]] -column 0 -row 5 -padx 2p -sticky e
    grid [ttk::combobox $fd0.cbox_useAddr] -column 1 -columnspan 2 -row 5 -padx 2p -sticky ew
    
    # Ship methods frame
    set shipType [eAssist_db::dbSelectQuery -columnNames ShipmentType -table ShipmentTypes]
    
    grid [ttk::label $fd1.txt_shipType -text [mc "Shipping Type"]] -column 0 -row 0 -sticky w
    grid [ttk::combobox $fd1.cbox_shipType -textvariable shipTypeValue -values $shipType -state readonly] -column 1 -row 0 -sticky ew
        # Remove entries that could be in the 'addCarriers' cbox, this could happen if the user selects an option, then changes the 'ship type' filter.
        bind $fd1.cbox_shipType <<ComboboxSelected>> "$fd1.cbox_addCarriers set {}"
    
    grid [ttk::label $fd1.txt_addCarriers -text [mc "Assign Carriers"]] -column 0 -row 1 -sticky w
    grid [ttk::combobox $fd1.cbox_addCarriers -values test -postcommand [list eAssistSetup::populateDistTypeCarrierList $fd1]] -column 1 -row 1 -sticky ew
        # Enable type-ahead searching
        bind $fd1.cbox_addCarriers <FocusIn> [list eAssistSetup::populateDistTypeCarrierList $fd1]
        bind $fd1.cbox_addCarriers <KeyRelease> [list AutoComplete::AutoCompleteComboBox $fd1.cbox_addCarriers %K]
        #bind $fd1.cbox_addCarriers <Enter> [list eAssistSetup::addCarriertoListBox $fd1.cbox_addCarriers $fd1.lbox_addCarriers]
    
    grid [listbox $fd1.lbox_addCarriers -exportselection 1] -column 1 -row 2 -sticky news
    
    grid [ttk::button $fd1.btn_addCarriers -text [mc "Add"] -command [list eAssistSetup::addCarriertoListBox $fd1.cbox_addCarriers $fd1.lbox_addCarriers]] -column 2 -row 1 -sticky ew -padx 2p
        #bind $fd1.btn_addCarriers <Enter> [list eAssistSetup::addCarriertoListBox $fd1.cbox_addCarriers $fd1.lbox_addCarriers]

    grid [ttk::button $fd1.btn_delCarriers -text [mc "Delete"] -command [${log}::debug Delete [$fd1.lbox_addCarriers curselection] ]] -column 2 -row 2 -sticky new -padx 2p -pady 2p

    grid rowconfigure $fd1 2

    ## Button frame
    set fda [ttk::frame $win.fda]
    pack $fda -anchor e -padx 2p -pady 5p

    grid [ttk::button $fda.ok -text [mc "OK"]] -column 0 -row 0 -padx 3p
    grid [ttk::button $fda.cncl -text [mc "Cancel"]] -column 1 -row 0 -padx 3p
} ;# eAssistSetup::modify_distType


proc eAssistSetup::populateDistTypeAddresses {} {
    db eval "SELECT MasterAddr_Company FROM MasterAddresses
            WHERE MasterAddr_Active = 1
            AND MasterAddr_Internal = 1"
}

proc eAssistSetup::populateDistTypeCarrierList {wid} {
    ##
    ## This should be re-written so we create the first list from the DB (maybe when we open up this window?) then remove carriers from the list when we assign them.
    ##
    set shipTypeValue [$wid.cbox_shipType get]
    
    if {$shipTypeValue eq "-All-"} {
            set whereValue "WHERE ShipmentType != '-All-'"
    } else {
            set whereValue "WHERE ShipmentType = '$shipTypeValue'"
    }
   
    # issue db query
    db eval "SELECT distinct(CarrierID), ShipmentType, Carriers.Name as Name FROM ShipVia
                INNER JOIN Carriers
                ON CarrierID = Carrier_ID
                [subst $whereValue]
                ORDER BY Name " {
                    # append the result to a var that we can use to populate the cbox
                    lappend carrierValues $Name
    }
    
    $wid.cbox_addCarriers configure -values $carrierValues
} ;# eAssistSetup::populateDistTypeCarrierList

proc eAssistSetup::addCarriertoListBox {widEntry widLbox} {
    global log
    
    set newData [$widEntry get]
    set lboxData [$widLbox get 0 end]
    
    # check to make sure we aren't inserting existing data
    if {[lsearch $lboxData $newData] == -1} {
        # We didn't match any existing data, lets insert
        $widLbox insert end [$widEntry get]
        $widEntry delete 0 end
    } else {
        # Existing data found, lets just clear out the cbox widget
        $widEntry delete 0 end
    }
}


