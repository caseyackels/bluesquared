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
    
    if {[winfo exists .distSetup] == 1} {destroy .companySetup}
    
    switch -- $mode {
        "add"   {}
        "view"  {}
        "edit"  {}
    }
    
    
    set win .distSetup
    toplevel $win
    wm transient $win .
    wm title $win [mc "[string toupper $mode] Distribution Types"] 
    set locX [expr {[winfo screenwidth .] / 4}]
    set locY [expr {[winfo screenheight .] / 4}]
    wm geometry $win 625x375+${locX}+${locY}
    focus $win
    
    ##
    ## Parent Frame
    ##
    set fd [ttk::frame $win.fd]
    pack $fd -expand yes -fill both -padx 2p -pady 2p

    set fd0 [ttk::labelframe $fd.fd0 -text [mc "Configuration"]]
    grid $fd0 -column 0 -row 0 -padx 2p -pady 2p -sticky news
    
    set fd1 [ttk::labelframe $fd.fd1 -text [mc "Assign Ship Methods"]]
    grid $fd1 -column 1 -row 0 -padx 2p -pady 2p -sticky news
    
    # Configuration frame
    grid [ttk::label $fd0.txt_distType -text [mc "Distribution Type"]] -column 0 -row 0 -padx 2p -sticky e
    grid [ttk::entry $fd0.entry_distType] -column 1 -row 0 -sticky ew
    
    grid [ttk::label $fd0.txt_reporting -text [mc "-Reporting-"]] -column 0 -row 1 -sticky w
    grid [ttk::checkbutton $fd0.summarize -text [mc "Summarize Shipments"]] -column 0 -row 2 -padx 2p -sticky w
    
    grid [ttk::label $fd0.txt_genFiles -text [mc "-Generated files for MIS-"]] -column 0 -row 3 -sticky w
    grid [ttk::checkbutton $fd0.singleEntry -text [mc "Create single entry"]] -column 0 -row 4 -padx 2p -sticky w
    grid [ttk::label $fd0.txt_useAddr -text [mc "Use address"]] -column 0 -row 5 -padx 2p -sticky e
    grid [ttk::combobox $fd0.cbox_useAddr] -column 1 -columnspan 2 -row 5 -padx 2p -sticky ew
    
    # Ship methods frame
    set shipType [eAssist_db::dbSelectQuery -columnNames ShipmentType -table ShipmentTypes]
    
    grid [ttk::label $fd1.txt_shipType -text [mc "Shipping Type"]] -column 0 -row 0 -sticky w
    grid [ttk::combobox $fd1.cbox_shipType -values $shipType -state readonly] -column 1 -row 0 -sticky ew
    
    grid [ttk::label $fd1.txt_addCarriers -text [mc "Assign Carriers"]] -column 0 -row 1 -sticky w
    grid [ttk::entry $fd1.entry_addCarriers] -column 1 -row 1 -sticky ew
    grid [ttk::button $fd1.btn_addCarriers -text [mc "Add"]] -column 2 -row 1 -sticky ew -padx 2p
    
    grid [listbox $fd1.lbox_addCarriers] -column 1 -row 2 -sticky news
    
    grid rowconfigure $fd1 2
    
    
    ## Button frame
    #set fd0a [ttk::frame $fd0.fd0a]
    #pack $fd0a -anchor w
    #
    ## Tablelist widget
    #set fd0b [ttk::frame $fd0.fd0b]
    #pack $fd0b -expand yes -fill both

    
} ;# eAssistSetup::modify_distType
