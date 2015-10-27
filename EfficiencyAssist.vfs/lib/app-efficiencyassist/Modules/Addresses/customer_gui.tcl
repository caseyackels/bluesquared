# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 12 22,2014
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 169 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2011-10-17 16:11:20 -0700 (Mon, 17 Oct 2011) $
#
########################################################################################

##
## - Overview
# Overview

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

namespace eval customer {}

proc customer::projSetup {{modify newTitle} args} {
    #****f* projSetup/customer
    # CREATION DATE
    #   09/08/2014 (Monday Sep 08)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   customer::projSetup  
    #
    # FUNCTION
    #	The Project Setup window is where you can create or edit the Title or Job information.
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
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log CSR job

    if {[winfo exists .ps]} {destroy .ps}

    toplevel .ps
    wm transient .ps .
    wm title .ps [mc "Project Information - [string totitle $modify]"]
    
    set locX [expr {[winfo screenwidth . ] / 4 + [winfo x .]}]
    set locY [expr {[winfo screenheight . ] / 5 + [winfo y .]}]
    wm geometry .ps +${locX}+${locY}

    set f1 [ttk::labelframe .ps.f1 -text [mc "Title Information"] -padding 10]
    pack $f1 -fill both -expand yes -padx 5p -pady 5p   

    set custNameList [db eval "SELECT CustName FROM Customer WHERE Status='1'"]
    
    ttk::label $f1.txt0 -text [mc "Customer"]
	ttk::entry $f1.entry0a -width 12 -textvariable job(CustID) \
                            -validate all \
                            -validatecommand [list AutoComplete::AutoComplete %W %d %v %P [customer::validateCustomer id $f1]] \
							-state disabled
    focus $f1.entry0a
	
    ttk::combobox $f1.entry0b -width 45 -textvariable job(CustName) \
                            -values $custNameList \
                            -validate all \
                            -validatecommand [list AutoComplete::AutoComplete %W %d %v %P [customer::validateCustomer name $f1]] \
							-state disabled
	
    ttk::label $f1.txt1a -text [mc "Title"]
    ttk::entry $f1.entry1a -textvariable job(Title) -state disabled ;#-validate all \
                            -validatecommand {AutoComplete::AutoComplete %W %d %v %P [customer::returnTitle $job(CustID)]}
		tooltip::tooltip $f1.entry1a [mc "Publication Title"]
    
    ttk::label $f1.txt1 -text [mc "CSR"]
    ttk::combobox $f1.cbox1 -postcommand "dbCSR::getCSRID $f1.cbox1 {FirstName LastName}" \
                            -textvariable job(CSRName) -validate all \
                            -validatecommand {AutoComplete::AutoComplete %W %d %v %P [dbCSR::getCSRID "" {FirstName LastName}]} \
							-state disabled
	
	ttk::label $f1.txt2 -text [mc "Save Location"]
	ttk::entry $f1.entry2 -textvariable job(TitleSaveFileLocation) -width 45 -state disabled
	        tooltip::tooltip $f1.entry2 [mc "Location where you want to save this Title."]
    ttk::button $f1.btn1 -text [mc "..."] -width 3 -command {customer::getFileSaveLocation title} -state disabled

	grid $f1.txt0	   -column 0 -row 0 -sticky nes -padx 3p -pady 3p
	grid $f1.entry0a   -column 1 -row 0 -sticky w -padx 3p -pady 3p
	grid $f1.entry0b   -column 2 -row 0 -sticky ew -padx 3p -pady 3p
    grid $f1.txt1a     -column 0 -row 1 -sticky nes -padx 3p -pady 3p
    grid $f1.entry1a   -column 1 -columnspan 2 -row 1 -sticky news -padx 3p -pady 3p
    grid $f1.txt1      -column 0 -row 2 -sticky nes -padx 3p -pady 3p
    grid $f1.cbox1     -column 1 -columnspan 2 -row 2 -sticky news -padx 3p -pady 3p
    grid $f1.txt2      -column 0 -row 3 -sticky nes -padx 3p -pady 3p
    grid $f1.entry2    -column 1 -columnspan 2 -row 3 -sticky news -padx 3p -pady 3p
	grid $f1.btn1	   -column 3 -row 3 -sticky ew -padx 2p -pady 3p

    
    ## Frame 2 - Job Information
    ##
    set f2 [ttk::labelframe .ps.f2 -text [mc "Job Information"] -padding 10]
    pack $f2 -fill both -expand yes -padx 5p -pady 5p
	
    ttk::label $f2.txt0 -text [mc "Name"]
    ttk::entry $f2.entry0 -textvariable job(Name) -width 57 -state disabled
		tooltip::tooltip $f2.entry0 [mc "Job Name"] 
    
    ttk::label $f2.txt1 -text [mc "Number"]
    ttk::entry $f2.entry1 -textvariable job(Number) -state disabled
		tooltip::tooltip $f2.entry1 [mc "Job Number"]
    
    ttk::label $f2.txt1a -text [mc "Save Location"]
    ttk::entry $f2.entry1a -textvariable job(JobSaveFileLocation) -state disabled
        tooltip::tooltip $f2.entry1a [mc "Location where you want to save this Job."]
    ttk::button $f2.btn1 -text [mc "..."] -width 3 -command {customer::getFileSaveLocation job} -state disabled

	grid [ttk::label $f2.txt2 -text [mc "Forest Certification"]] -column 0 -row 3 -sticky nes
	grid [ttk::combobox $f2.cbox2 -textvariable job(ForestCert) -postcommand [list ea::db::customer::ForestCertification $f2.cbox2] -state disabled] -column 1 -row 3 -sticky ew
    
    grid $f2.txt0     -column 0 -row 0 -sticky nes -pady 3p -pady 3p
    grid $f2.entry0   -column 1 -row 0 -sticky ew -padx 3p -pady 3p
    grid $f2.txt1     -column 0 -row 1 -sticky nes -pady 3p -pady 3p
    grid $f2.entry1   -column 1 -row 1 -sticky ew -padx 3p -pady 3p
    grid $f2.txt1a    -column 0 -row 2 -sticky nes -pady 3p -pady 3p
    grid $f2.entry1a  -column 1 -row 2 -sticky ew -padx 3p -pady 3p
    grid $f2.btn1     -column 2 -row 2 -sticky ew -padx 2p -pady 3p
    
    ## Button Frame
    ##
    set btnBar [ttk::frame .ps.btnBar -padding 10]
    pack $btnBar -anchor se ;#-padx 5p -pady 5p
    
    ttk::button $btnBar.ok -text [mc "OK"] -command {destroy .ps} ;# Default command 
	ttk::button $btnBar.import -text [mc "Import File"] -state disable -command {customer::dbUpdateCustomer
																	job::db::createDB -tName $job(Title) -tCSR $job(CSRName) -tSaveLocation $job(TitleSaveFileLocation) -tCustCode $job(CustID) -tHistNote {Initial Entry} -jNumber $job(Number) -jName $job(Name) -jSaveLocation $job(JobSaveFileLocation) -jForestCert $job(ForestCert) -jHistNote {Initial Job Entry}
																	importFiles::fileImportGUI; destroy .ps}
    
    grid $btnBar.ok -column 0 -row 0 -sticky news
    grid $btnBar.import -column 1 -row 0 -sticky news
	
    # Re-configure buttons and commands depending on what parameter was passed: New, Edit
    switch -- $modify {
        newTitle     { 
					$btnBar.ok configure -command {customer::dbUpdateCustomer;
															job::db::createDB -tName $job(Title) -tCSR $job(CSRName) -tSaveLocation $job(TitleSaveFileLocation) -tCustCode $job(CustID) -tHistNote {Initial Entry} -jNumber $job(Number) -jName $job(Name) -jSaveLocation $job(JobSaveFileLocation) -jShipStart $job(JobFirstShipDate) -jShipBal $job(JobBalanceShipDate) -jForestCert $job(ForestCert) -jHistNote {Initial Job Entry} ;
													destroy .ps}
                    #${log}::debug NEW PROJECT - Clear all job text variables.
                    if {[info exists job(db,Name)]} {
                        catch {close $job(db,Name)} ;# Close the db connection
                        foreach name [array names job] {
                            set job($name) ""
                        }
                        #${log}::debug NEW PROJECT - Clear out tablelist widget
                        # Reset the inteface ...
                        eAssistHelper::resetImportInterface
                    }
					# Enable the widgets
					foreach child [winfo child $f1] {
						$child configure -state normal
					}
					
					$args entryconfigure 1 -state normal
					
                }
        editTitle    {
					$btnBar.ok configure -command {customer::dbUpdateCustomer
													job::db::insertTitleInfo -title $job(Title) -csr $job(CSRName) -tSaveLocation $job(TitleSaveFileLocation) -tCustCode $job(CustID) -histnote {Updated Title Info, new record added}
													destroy .ps}
					$btnBar.import configure -state disable
                    # Enable the widgets
					foreach child [winfo child $f1] {
						$child configure -state normal
					}
                }
		newJob		{
						# Enable the widgets
						foreach child [winfo child $f2] {
							$child configure -state normal
						}
						$btnBar.import configure -state normal
						focus $f2.entry0
						
						$f2.entry0 delete 0 end
						$f2.entry1 delete 0 end
						$f2.entry1a delete 0 end
						#$f2.entry2 delete 0 end
						#$f2.entry3 delete 0 end
						
						$btnBar.ok configure -command { eAssistHelper::resetImportInterface 1
													customer::dbUpdateJob -jNumber $job(Number) -jName $job(Name) -jSaveLocation $job(JobSaveFileLocation) -jShipStart $job(JobFirstShipDate) -jShipBal $job(JobBalanceShipDate) -jForestCert $job(ForestCert)
													destroy .ps
													}
													
						$btnBar.import configure -command { eAssistHelper::resetImportInterface 1
													customer::dbUpdateJob -jNumber $job(Number) -jName $job(Name) -jSaveLocation $job(JobSaveFileLocation) -jShipStart $job(JobFirstShipDate) -jShipBal $job(JobBalanceShipDate) -jForestCert $job(ForestCert)
													destroy .ps
													importFiles::fileImportGUI
													}

		}
		editJob		{
					$btnBar.ok configure -command {customer::dbUpdateJob -jNumber $job(Number) -jName $job(Name) -jSaveLocation $job(JobSaveFileLocation) -jShipStart $job(JobFirstShipDate) -jShipBal $job(JobBalanceShipDate) -jForestCert $job(ForestCert)
													destroy .ps}
						# Enable the widgets
						foreach child [winfo child $f2] {
							$child configure -state normal
						}
		}
        default {${log}::debug [info level 0] - Switch Arg not availabe: $modify for [info level 0]}       
    }
    
    
    ## BINDINGS
    bind $f1.entry0a <FocusOut> {
        set id [%W get]
        if {$id != ""} {
            #$::customer::f1.entry0b insert end [db eval "SELECT CustName FROM Customer WHERE Cust_ID='$id'"
            set tmpCustName [join [db eval "SELECT CustName FROM Customer WHERE Cust_ID='$id'"]]
            if {$tmpCustName != ""} {
                set job(CustName) $tmpCustName
                #${log}::debug $job(CustName)
            }
        }
    }
    
    bind $f1.entry0b <FocusOut> {
        set custName [%W get]
        if {$custName != ""} {
            #$::customer::f1.entry0b insert end [db eval "SELECT CustName FROM Customer WHERE Cust_ID='$id'"
            set tmpCustID [join [db eval "SELECT Cust_ID FROM Customer WHERE CustName='$custName'"]]
                if {$tmpCustID != ""} {
                    set job(CustID) $tmpCustID
                }
            
            if {$job(CustID) == "" && $tmpCustID == ""} {
                ${log}::debug No Data was found in the ID Field - Issuing warning notice.
            }
        }
    }
    

} ;# customer::projSetup


proc customer::manage {} {
    #****f* manage/customer
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	GUI for adding a new customer
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
    global log
    
    if {[winfo exists .manageCustomer]} {destroy .manageCustomer}
    
    set wid .manageCustomer

    toplevel $wid
    wm transient $wid .
    wm title $wid [mc "Manage Customers"]
    
    set locX [expr {[winfo screenwidth . ] / 4 + [winfo x .]}]
    set locY [expr {[winfo screenheight . ] / 5 + [winfo y .]}]
    wm geometry $wid 500x300+${locX}+${locY}

    set f1 [ttk::frame $wid.f1]
    pack $f1 -fill both -expand yes -padx 5p -pady 5p
    
    set f2 [ttk::frame $wid.f2 -padding 0]
    pack $f2 -fill x -expand yes -anchor n -padx 5p -pady 5p
    
    ## Frame 1
    ttk::button $f1.btn0 -text [mc "View"] -command "customer::Modify view $f2.tbl"
    ttk::button $f1.btn1 -text [mc "Modify"] -command "customer::Modify edit $f2.tbl"
    ttk::button $f1.btn2 -text [mc "Add"] -command {customer::Modify add}
    #ttk::button $f1.btn3 -text [mc "Delete"] -state disabled
    
    grid $f1.btn0 -column 0 -row 0 -sticky s
    grid $f1.btn1 -column 1 -row 0 -sticky s
    grid $f1.btn2 -column 2 -row 0 -sticky s
    #grid $f1.btn3 -column 3 -row 0 -sticky s
    

    ## Frame 2
    tablelist::tablelist $f2.tbl -columns {
                                10 "Code" center
                                40 "Name" left} \
                                -showlabels yes \
                                -selectbackground yellow \
                                -selectforeground black \
                                -stripebackground lightblue \
                                -exportselection yes \
                                -showseparators yes \
                                -fullseparators yes \
                                -selectmode extended \
                                -editselectedonly 1 \
                                -selecttype row \
                                -yscrollcommand [list $f2.scrolly set] \
                                -xscrollcommand [list $f2.scrollx set]


    $f2.tbl columnconfigure 1 -labelalign center -stretchable 1    
    
    ttk::scrollbar $f2.scrolly -orient v -command [list $f2.tbl yview]
    ttk::scrollbar $f2.scrollx -orient h -command [list $f2.tbl xview]

    grid $f2.tbl -column 0 -row 0 -sticky news
    grid columnconfigure $f2 0 -weight 2
    #grid rowconfigure $f2 $f2.tbl -weight 2
    
    grid $f2.scrolly -column 1 -row 0 -sticky nse
    grid $f2.scrollx -column 0 -row 1 -sticky ews
    
    ::autoscroll::autoscroll $f2.scrolly ;# Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $f2.scrollx
    
    set f3 [ttk::frame $wid.f3 -padding 10]
    pack $f3 -padx 5p -pady 5p -anchor se
    
    ttk::button $f3.btn0 -text [mc "Close"] -command [list destroy $wid]
    #ttk::button $f3.btn1 -text [mc "Cancel"] -command [list destroy $wid]
    
    grid $f3.btn0 -column 0 -row 0 -sticky ns
    #grid $f3.btn1 -column 1 -row 0 -sticky ns
    
    customer::populateCustomerLbox $f2.tbl

} ;# customer::manage


proc customer::Modify {modify {tbl ""}} {
    #****f* Modify/customer
    # CREATION DATE
    #   12/24/2014 (Wednesday Dec 24)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   customer::Modify <add|edit|view> ?Path to table widget?
    #
    # FUNCTION
    #	A Dialog which allows the user to, add, edit or view records for specific customers 
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
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log cust

    if {[winfo exists .viewCustomer]} {destroy .viewCustomer}
    if {[info exists ::customer::shipViaDeleteList]} {unset ::customer::shipViaDeleteList}
    
    set wid .viewCustomer

    toplevel $wid
    wm transient $wid .
    wm title $wid [mc "View/Edit Customers"]
    
    set locX [expr {[winfo screenwidth . ] / 4 + [winfo x .]}]
    set locY [expr {[winfo screenheight . ] / 5 + [winfo y .]}]
    wm geometry $wid +${locX}+${locY}
    
    

    switch -- $modify {
        add     {set entryState [list normal normal]; set btnState disabled
                        set custList [list "" ""]
                        set cust(Status) 1
                }
        edit    {set entryState [list readonly normal]; set btnState normal
                    set custList [$tbl get [$tbl curselection]]
                    set cust(Status) [eAssist_db::dbWhereQuery -columnNames Status -table Customer -where Cust_ID='[lindex $custList 0]']
                }
        view    {set entryState [list readonly readonly disabled]; set btnState disabled
                    set custList [$tbl get [$tbl curselection]]
                    set cust(Status) [eAssist_db::dbWhereQuery -columnNames Status -table Customer -where Cust_ID='[lindex $custList 0]']
                }
        default {}
    }
    
    
    # Enter Customer ID and Name 
    set f0a [ttk::frame $wid.f0a -padding 10]
    pack $f0a -fill x
    
    # Notebook container Frame
    set f0 [ttk::frame $wid.f0]
    pack $f0 -expand yes -fill both -pady 5p -padx 5p
    
    # Buttons Frame
    set btns [ttk::frame $wid.btns -padding 10]
    pack $btns -anchor se
    
    ttk::label $f0a.txt1 -text [mc "Customer ID"]
    ttk::entry $f0a.entry1 -width 10 ;# See below for the validation code
    focus $f0a.entry1
        $f0a.entry1 insert end [lindex $custList 0]
        $f0a.entry1 configure -state [lindex $entryState 0]
    
    ttk::label $f0a.txt2 -text [mc "Customer Name"]
    ttk::entry $f0a.entry2 -width 50
        $f0a.entry2 insert end [lindex $custList 1]
        $f0a.entry2 configure -state [lindex $entryState 1]
        
      
    ttk::label $f0a.txt3 -text [mc "Record Active"]
    ttk::checkbutton $f0a.ckbtn1 -variable cust(Status)
        $f0a.ckbtn1 configure -state [lindex $entryState 2]
    
    grid $f0a.txt1 -column 0 -row 0 -sticky nse
    grid $f0a.entry1 -column 1 -row 0 -sticky nsw -pady 2p
    
    grid $f0a.txt2 -column 0 -row 1 -sticky nse
    grid $f0a.entry2 -column 1 -row 1 -sticky nsw -pady 2p
    
    grid $f0a.txt3 -column 0 -row 2 -sticky nse
    grid $f0a.ckbtn1 -column 1 -row 2 -sticky nsw -pady 2p

    
    ##
    ## Notebook
    ##
    set nbk [ttk::notebook $f0.notebook]
    pack $nbk -expand yes -fill both -padx 5p -pady 5p
    
    ttk::notebook::enableTraversal $nbk
    
    #
    # Setup the notebook
    #
    $nbk add [ttk::frame $nbk.shipvia] -text [mc "Preferred Ship Via's"]
    $nbk add [ttk::frame $nbk.titles] -text [mc "Titles"]
    
    $nbk select $nbk.shipvia
    

    
    # -----
    # Tab 1, Notebook - Preferred Ship Via's
    
    # Frame 1 - Available Ship Via
    set f1a [ttk::labelframe $nbk.shipvia.f1a -text [mc "Available"] -padding 10]
    pack $f1a -expand yes -fill both -side left -pady 5p -padx 5p
    
    listbox $f1a.lbox -width 30 -height 15 -selectmode extended \
            -yscrollcommand [list $f1a.scrolly set] \
            -xscrollcommand [list $f1a.scrollx set]
    
    ttk::scrollbar $f1a.scrolly -orient v -command [list $f1a.lbox yview]
    ttk::scrollbar $f1a.scrollx -orient h -command [list $f1a.lbox xview]
    
    ::autoscroll::autoscroll $f1a.scrolly ;# Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $f1a.scrollx
    
    grid $f1a.lbox -column 0 -row 0 -sticky news
    grid $f1a.scrolly -column 1 -row 0 -sticky nse
    grid $f1a.scrollx -column 0 -row 1 -sticky ews
    
    # Frame 2 - Buttons
    set f2a [ttk::frame $nbk.shipvia.f2a -padding 10]
    pack $f2a -expand yes -fill both -side left -pady 5p -padx 5p
    
    # Frame 3 - Assigned Ship Via
    set f3a [ttk::labelframe $nbk.shipvia.f3a -text [mc "Assigned"] -padding 10]
    pack $f3a -expand yes -fill both -side left -pady 5p -padx 5p
    
    ## Frame 2 - Buttons
    ttk::button $f2a.btn1 -text [mc "Add >"] -state $btnState -command "customer::transferToAssigned $f1a.lbox $f3a.lbox $btns.btn0"
    ttk::button $f2a.btn2 -text [mc "< Remove"] -state $btnState -command "customer::removeFromAssigned $f3a.lbox $btns.btn0"
     
    grid $f2a.btn1 -column 0 -row 0 -sticky news
    grid $f2a.btn2 -column 0 -row 1 -sticky news
    

    ## Frame 3
    listbox $f3a.lbox -width 30 -height 15 -selectmode extended \
            -yscrollcommand [list $f3a.scrolly set] \
            -xscrollcommand [list $f3a.scrollx set]
    
    ttk::scrollbar $f3a.scrolly -orient v -command [list $f3a.lbox yview]
    ttk::scrollbar $f3a.scrollx -orient h -command [list $f3a.lbox xview]
    
    ::autoscroll::autoscroll $f3a.scrolly ;# Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $f3a.scrollx
    
    grid $f3a.lbox -column 0 -row 0 -sticky news
    grid $f3a.scrolly -column 1 -row 0 -sticky nse
    grid $f3a.scrollx -column 0 -row 1 -sticky ews
    
    # Populate the ship via listboxes
    customer::PopulateShipVia $f1a.lbox
    customer::PopulateShipVia $f3a.lbox [$f0a.entry1 get]

    
    # -----
    # Tab 2, Titles
    
    # Frame 1 - Message to User
    set ft1 [ttk::frame $nbk.titles.ft1 -padding 10]
    pack $ft1 -expand yes -fill both ;#-pady 5p -padx 5p
    
    # Frame 2 - List of Titles, and Delete button
    set ft2 [ttk::frame $nbk.titles.ft2 -padding 10]
    pack $ft2 -expand yes -fill both ;#-pady 5p -padx 5p
    
    
    # Frame 1
    ttk::label $ft1.txt -text [mc "Titles and associated CSRs are added automatically when creating a new Project"]
    
    grid $ft1.txt -column 0 -row 0 -sticky nw
    
    # Frame 2
    tablelist::tablelist $ft2.tbl -columns {
                                                0   "..." center
                                                0   "CSR" left
                                                0   "Title" left
												0	"Save Location" left} \
                                        -showlabels yes \
                                        -height 20 \
                                        -width 50 \
                                        -selectbackground yellow \
                                        -selectforeground black \
                                        -stripebackground lightblue \
                                        -exportselection yes \
                                        -showseparators yes \
                                        -fullseparators yes \
                                        -selectmode extended \
                                        -editselectedonly 1 \
                                        -selecttype row \
                                        -yscrollcommand [list $ft2.scrolly set] \
                                        -xscrollcommand [list $ft2.scrollx set]
                                                
    $ft2.tbl columnconfigure 0 -name "count" \
                                        -showlinenumbers 1 \
                                        -labelalign center
	
	$ft2.tbl columnconfigure 1 -labelalign center    
    $ft2.tbl columnconfigure 2 -labelalign center
	$ft2.tbl columnconfigure 3 -labelalign center -stretchable 1
    
    ttk::scrollbar $ft2.scrolly -orient v -command [list $ft2.tbl yview]
    ttk::scrollbar $ft2.scrollx -orient h -command [list $ft2.tbl xview]
    
    ::autoscroll::autoscroll $ft2.scrolly ;# Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $ft2.scrollx

    ttk::button $ft2.btn -text [mc "Delete"] -command "customer::deleteFromlbox $ft2.tbl [lindex $custList 0]; customer::populateTitleWid $ft2.tbl [lindex $custList 0]"
    
    grid $ft2.tbl -column 0 -row 0 -sticky news
    grid $ft2.scrolly -column 1 -row 0 -sticky nse
    grid $ft2.scrollx -column 0 -row 1 -sticky ews
    
    grid $ft2.btn -column 1 -row 0 -sticky ne -padx 2p
	
	grid columnconfigure $ft2 0 -weight 2
    
    # Populate the title listbox
    customer::populateTitleWid $ft2.tbl [lindex $custList 0]
    
    ##
    ## Control Buttons
    # After we close the customer ship via window; refresh the main customer list, so that if we added a customer or deactivated a customer, we will now see the results.
    ttk::button $btns.btn0 -text [mc "OK"] -command "customer::dbAddShipVia $modify $f3a.lbox $f0a.entry1 $f0a.entry2; destroy $wid; customer::manage" -state btnState
    ttk::button $btns.btn1 -text [mc "Cancel"] -command "destroy $wid"
    
    grid $btns.btn0 -column 0 -row 0
    grid $btns.btn1 -column 1 -row 0
    
    
    # Reconfigurations
    $f0a.entry1 configure -validate key -validatecommand "customer::validateEntry $btns.btn0 $f2a.btn1 $f2a.btn2 %W %P"


} ;# customer::Modify

