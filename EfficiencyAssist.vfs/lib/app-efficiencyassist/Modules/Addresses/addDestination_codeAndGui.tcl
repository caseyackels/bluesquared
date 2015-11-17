# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 11 07,2013
# Dependencies:  
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 421 $
# $LastChangedBy: casey.ackels@gmail.com $
# $LastChangedDate: 2015-03-04 19:02:39 -0800 (Wed, 04 Mar 2015) $
#
########################################################################################

##
## - Overview
# Creates a window to add a new destination, instead of reimporting the source file.
# ---- This file contains GUI and BACKEND code


#proc eAssistHelper::addDestination {tblPath modifier {widRow -1}} {
#    #****f* addDestination/eAssistHelper
#    # AUTHOR
#    #	Casey Ackels
#    #
#    # COPYRIGHT
#    #	(c) 2011-2013 Casey Ackels
#    #
#    # FUNCTION
#    #	eAssistHelper::addDestination <tblPath> <-add|-combine|-edit> ?widRow?
#    #	tblPath is the path where you want the address inserted.
#    #
#    # SYNOPSIS
#    #	Adds a destination to the master list, so it can easily be added to the file instead of reimporting the file
#    #	This will probably only be helpful for internal "addresses", as you would want to re-import the customers source file, if they made any changes.
#    #
#    #	If an address is typed in, clicking the save button will insert it into the table, and save it to the master destination table.
#    #   If an address is selected, it is only inserted into the table, unless it is modified; then the original address is removed from the  
#    #
#    # CHILDREN
#    #	eAssistHelper::detectData
#    #
#    # PARENTS
#    #	
#    #
#    # NOTES
#    #
#    # SEE ALSO
#    #
#    #***
#    global log dist w carrierSetup packagingSetup shipOrder job
#	#ttk::style map TCombobox -fieldbackground {!focus yellow}
#	#ttk::style configure TEntry -fieldbackground {!focus yellow}
#	#ttk::style map TEntry -fieldbackground {focus yellow}
#	#ttk::style configure Highlight.TEntry -fieldbackground {focus yellow}
#	#ttk::style map Highlight.TEntry -fieldbackground {focus yellow}
##	
##	ttk::style element create highlight.field from default
##	
###	ttk::style layout Highlight.Entry {
###        Highlight.Entry.highlight.field -sticky nswe -border 0 -children {
###             Highlight.Entry.padding -sticky nswe -children {
###                 Highlight.Entry.textarea -sticky nswe
###             }
###         }
###     }
##	ttk::style layout Highlight.Entry {
##        Highlight.Entry.highlight.field -sticky nswe -border 0 -children {
##             Highlight.Entry.padding -sticky nswe -children {
##                 Highlight.Entry.textarea -sticky nswe
##             }
##         }
##     }
##	#Entry.field -sticky nswe -children {Entry.background -sticky nswe -children {Entry.padding -sticky nswe -children {Entry.textarea -sticky nswe}}}
##	# Configure the colour and padding for our new style.
##    ttk::style configure Highlight.Entry -background \
##		{*}[ttk::style configure TEntry -fieldbackground]
##     
##	ttk::style map Highlight.Entry {*}[ttk::style map TEntry] \
##         -fieldbackground {focus yellow}
#
##	image create photo border -width 20 -height 20
##	#border put red -to 0 0 19 19
##	#border put white -to 2 2 17 17
##	border put red -to 0 0 19 19
##	border put white -to 2 2 17 17
##	
##	ttk::style element create Redborder image border -border 3
##	
##	ttk::style layout test.TEntry {
##	  Redborder -sticky nswe -border 0 -children {
##		Entry.padding -sticky nswe -children {
##		  Entry.textarea -sticky nswe
##		}
##	  }
##	}
##	
##	image create photo border2 -width 20 -height 20
##	#border put red -to 0 0 19 19
##	#border put white -to 2 2 17 17
##	border put blue -to 0 0 19 19
##	border put white -to 2 2 17 17
##	
##	ttk::style element create Whiteborder image border2 -border 3
##	#
##	#ttk::style layout wBorder.TEntry {
##	#  Whiteborder -sticky nswe -border 1 -children {
##	#	Entry.padding -sticky nswe -children {
##	#	  Entry.textarea -sticky nswe
##	#	}
##	#  }
##	#}
##	
###	ttk::style map TEntry {*}[ttk::style map TEntry] \
###         -fieldbackground {focus yellow}
##    
##	ttk::style map test.TEntry {
##	  Whiteborder -sticky nswe -border 1 -children {
##		Entry.padding -sticky nswe -children {
##		  Entry.textarea -sticky nswe
##		}
##	  }
##	}
##	
##	ttk::style map test.TEntry {
##	  Redborder -sticky nswe -border 0 -children {
##		Entry.padding -sticky nswe -children {
##		  Entry.textarea -sticky nswe
##		}
##	  }
##	}

#proc eAssistHelper::setBGColor {labelPath btn parentWid} {
#    #****f* setBGColor/eAssistHelper
#    # AUTHOR
#    #	Casey Ackels
#    #
#    # COPYRIGHT
#    #	(c) 2011-2013 Casey Ackels
#    #
#    # FUNCTION
#    #	eAssistHelper::setBGColor <win>
#    #
#    # SYNOPSIS
#    #   Set the foreground color on the text for the required fields
#    #
#    # CHILDREN
#    #	N/A
#    #
#    # PARENTS
#    #	eAssistHelper::detectData
#    #
#    # NOTES
#    #
#    # SEE ALSO
#    #
#    #***
#    global log w
#
#	#set parentWid [list $w(dest,1) $w(dest,2)]
#	if {[info exists fail]} {unset fail}
#	foreach wid $parentWid {
#		foreach child [winfo children $wid] {
#			#${log}::debug Looking at $child
#			if {[winfo class $child] eq "TLabel"} {
#				#puts $child
#				if {[string match *.req* $child] && [$child cget -foreground] eq "red"} {
#					#${log}::debug $child is RED
#					lappend fail yes
#				} elseif {[string match *.req* $child] && [$child cget -foreground] eq "black"} {
#					#${log}::debug $child [$child cget -foreground]
#					lappend fail no
#				}
#			}
#		}
#	}
#    
#    if {[lsearch $fail yes] == -1} {
#		#${log}::debug FAIL = $fail
#		$btn configure -state normal
#	} else {
#		$btn configure -state disabled
#	}
#} ;# eAssistHelper::setBGColor
#
#proc eAssistHelper::initFGTextColor {args} {
#    #****f* initFGTextColor/eAssistHelper
#    # CREATION DATE
#    #   03/01/2015 (Sunday Mar 01)
#    #
#    # AUTHOR
#    #	Casey Ackels
#    #
#    # COPYRIGHT
#    #	(c) 2015 Casey Ackels
#    #   
#    #
#    # SYNOPSIS
#    #   eAssistHelper::initBGTextColor args 
#    #
#    # FUNCTION
#    #	Init the text color on required widgets
#    #   
#    #   
#    # CHILDREN
#    #	N/A
#    #   
#    # PARENTS
#    #   
#    #   
#    # NOTES
#    #   
#    #   
#    # SEE ALSO
#    #   
#    #   
#    #***
#    global log
#
#	# Cycle through each parent
#    foreach wid $args {
#		#${log}::debug Looking at $wid
#		# Cycle through the children per parent
#		foreach child [winfo children $wid] {
#			# Only look at children that have TLabel as their class
#			if {[winfo class $child] eq "TLabel"} {
#				# Ensure it is a label that we deem 'required' with 'req' in the name.
#				if {[string match *.req* $child]} {
#					# It's required, now lets see if the entry widget has any data. If it doesn't, set it to Red.
#					if {[[string map {req get} $child] get] == ""} {
#						$child configure -foreground red
#					}
#				}
#			}
#		}
#	}
#
#    
#} ;# eAssistHelper::initFGTextColor


proc eAssistHelper::saveDest {modifier widRow tblPath} {
    #****f* saveDest/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Gateway function - Issues functions based on the passed modifier
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
    global log program shipOrder job headerParent title
    
    if {$shipOrder(ShipDate) != ""} {
        set shipOrder(ShipDate) [ea::date::formatDate -std -db $shipOrder(ShipDate)]
    }
    
    if {$shipOrder(ArriveDate) != ""} {
        set shipOrder(ArriveDate) [ea::date::formatDate -std -db $shipOrder(ArriveDate)]
    }
    
    switch -- $modifier {
        -add        {
                    # Add new record to db
                    #ea::db::writeSingleAddressToDB
                    ea::code::bm::writeShipment normal
                    
                    # Populate table
                    ea::db::populateTablelist -record new -widRow $widRow
                    
                    # Reset the array
                    eAssistHelper::initShipOrderArray
        }
        -edit       {
            		## -- We are updating a record
                    ## # Delete ShippingOrder record first; then re-add it.
                    #ea::db::updateSingleAddressToDB
                    ea::code::bm::writeShipment normal
                    
                    # Guard against the user selecting multiple rows when editing...
                    set widRow [lindex $widRow 0]
                        
                    # Update the table
                    ea::db::populateTablelist -record edit -widRow $widRow -id $title(shipOrder_id)
                    
        }
        -combine    {
                    ## -- Combine selected rows into one record
                    #${log}::debug Remove rows ($widRow) from tablelist
                    
                    # Delete rows from tablelist, bottom up so row id's don't change.
                    foreach row [lsort -decreasing $widRow] {
                        #${log}::debug Removing Row: $row
                        $tblPath delete $row
                    }
                    #${log}::debug Inserting into row [lindex $widRow 0]
                    #return
                    
                    #${log}::debug Removing id's from ShippingOrders: $title(db_id,mult)
                    $job(db,Name) eval "DELETE FROM ShippingOrders WHERE AddressID IN ([join $title(db_id,mult) ,])"
                    
                    #${log}::debug Inserting new address, and ShippingOrder
                    # Add new record to db
                    ea::db::writeSingleAddressToDB
                    
                    # Populate table, inserting new record into the first selection of the combined rows.
                    ${log}::debug Inserting into row [lindex $widRow 0] id $title(shipOrder_id)
                    ea::db::populateTablelist -record combine -widRow [lindex $widRow 0] -id $title(shipOrder_id)

        }
        default     {${log}::debug Not a valid option for eAssistHelper::saveDest, used $modifier}
    }
	
	# Apply the highlights ... Technically we should also prevent the user from entering too much data into each field.
	importFiles::highlightAllRecords $tblPath
	
    # Get total copies
    job::db::getTotalCopies
    
    # Check to see if we just added a distribution type that uses a specific address in the exported batch files
    #ea::code::bm::writeHiddenShipment $shipOrder(DistributionType)
} ;# eAssistHelper::saveDest


proc eAssistHelper::shippingOrder {widTbl modifier} {
    #****if* shippingOrder/eAssistHelper
    # CREATION DATE
    #   08/19/2015 (Wednesday Aug 19)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   widTbl = path to tablelist
    #   modifer = -add|-edit 
    #   
    #   
    #***
    global log job shipOrder files widgetPath
    
    set win [eAssist_Global::detectWin -k .dest]
    #${log}::debug Current Window: $win
    toplevel $win
    wm transient $win .
    wm title $win [mc "Add Destination"]

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    wm geometry $win +${locX}+${locY}
    
    # -----

    # Setup the vars
    set widUIGroups [db eval "SELECT DISTINCT widUIGroup FROM HeadersConfig WHERE dbActive = 1"] ;# TODO this should be set in a global array
    
    # -----

    # Create the frames - We know what the categories are; so we don't need to add them dynamically
    pack [set f3 [ttk::frame $win.f3]] -padx 5p -pady 5p -side bottom -anchor se
        ttk::button $f3.ok -text [mc "OK"]
        grid $f3.ok -column 0 -row 0 -padx 2p -pady 2p -sticky ew
    
        grid [ttk::button $f3.cncl -text [mc "Cancel"] -command [list destroy $win]] -column 1 -row 0 -padx 2p -pady 2p -sticky ew
    
    pack [set f1 [ttk::frame $win.f1]] -padx 5p -pady 5p -expand yes -fill both -side left
        pack [ttk::labelframe $f1.consignee -text [mc "Consignee"] -padding 10] -anchor n -padx 0p -pady 0p
    
    pack [set f2 [ttk::frame $win.f2]] -padx 5p -pady 5p -expand yes -fill both -side right
        pack [ttk::labelframe $f2.shippingOrder -text [mc "Shipping Order"] -padding 10] -fill x -anchor n -padx 0p -pady 0p
        pack [ttk::labelframe $f2.packaging -text [mc "Packaging"] -padding 10] -fill x -anchor n -padx 0p -pady 0p
        pack [ttk::labelframe $f2.miscellaneous -text [mc "Miscellaneous"] -padding 10] -fill x -anchor n -padx 0p -pady 0p
                           
    # Master loop to create the widgets
    foreach uiGroup $widUIGroups {
        # Map the groups to the preset frames
        switch -- $uiGroup {
            "Consignee"         {set widPath $f1.consignee}
            "Shipping Order"    {set widPath $f2.shippingOrder}
            "Packaging"         {set widPath $f2.packaging}
            "Miscellaneous"     {set widPath $f2.miscellaneous}
            default             { ${log}::debug [info level 0] invalid switch statement: $uiGroup }
        }
        
        set textCol 0
        set dataCol 1
        set row 0
        db eval "SELECT dbColName, widLabelName, widWidget, widValues, widRequired, widMaxWidth from HeadersConfig 
                                WHERE widUIGroup = '$uiGroup'
                                AND dbActive = 1
                                ORDER BY widUIPositionWeight ASC, widLabelName ASC" {
                                    # Label widget
                                    if {$widRequired == 1} {set fgcolor red} else {set fgcolor black}
                                    grid [ttk::label $widPath.txt$row -text $widLabelName -foreground $fgcolor] -column $textCol -row $row -sticky e
                                                                       
                                    # Entry/Combobox widgets
                                    switch -- $widWidget {
                                            ttk::entry      {
                                                #${log}::debug Entry widget found: $widWidget - $widLabelName
                                                set cmd "-textvariable shipOrder($dbColName) -width $widMaxWidth"
                                                }
                                            ttk::combobox   {
                                                #${log}::debug Combobox widget found: $widWidget - $widLabelName - $widValues
                                                # Get the values
                                                set tbl [db eval "SELECT TableName, DisplayColValues from UserDefinedValues where Description = '$widValues'"]
                                                
                                                    # All comboboxes except Versions
                                                    if {[lindex $tbl 0] ne "Versions"} {
                                                        set values [db eval "SELECT [lindex $tbl 1] FROM [lindex $tbl 0]"]
                                                        set cmd [list -textvariable shipOrder($dbColName) -width $widMaxWidth -values $values -state readonly]

                                                    } else {
                                                        # Versions info
                                                        set values [$job(db,Name) eval "SELECT VersionName FROM VERSIONS WHERE VersionActive = 1"]
                                                        set cmd [list -textvariable shipOrder($dbColName) -width $widMaxWidth -values $values -state readonly]
                                                    }
                                                    
                                                    
                                                }
                                            default         {
                                                ${log}::critical [info level 0] default widget found: $widWidget - $widLabelName
                                                }
                                    }
                                    set widgetPath($dbColName) $widPath.data$row
                                    
                                    
                                    
                                    grid [$widWidget $widPath.data$row {*}$cmd] -column $dataCol -row $row -sticky ew
                                    grid columnconfigure $widPath $dataCol -weight 2
                                                    
                                    incr row
                                }
                                incr textCol
                                incr dataCol
                                
                                
    }

    # Check to see if we're using all of the created frames, if not unpack it.
    foreach fr [winfo children $win.f2] {
        if {[winfo children $fr] == ""} {
            pack forget $fr
        }
    }
    
    # Create intelligence in the Company widget
    set companyList [db eval "SELECT MasterAddr_Company FROM MasterAddresses WHERE MasterAddr_Internal = 1"]
    $widgetPath(Company) configure -validate all -validatecommand [list AutoComplete::AutoComplete %W %d %v %P $companyList]
    AutoComplete::typeahead $widgetPath(ShipVia)
    AutoComplete::typeahead $widgetPath(DistributionType)
    AutoComplete::typeahead $widgetPath(Versions)
    AutoComplete::typeahead $widgetPath(ShippingClass)
    AutoComplete::typeahead $widgetPath(ContainerType)
    AutoComplete::typeahead $widgetPath(PackageType)
    
    tooltip::tooltip $widgetPath(ShipDate) [mc "Must use m/d/yyyy format"]
    tooltip::tooltip $widgetPath(ArriveDate) [mc "Must use m/d/yyyy format"]
    
    ##
    ## BINDINGS
    ##
    bind $widgetPath(Company)  <FocusOut> {
        ea::db::setConsigneeAutoComplete [%W get]
    }
    
    bind $widgetPath(DistributionType) <<ComboboxSelected>> {
        ${log}::debug Setting ShipVia Values for: [%W get]
        ea::db::setShipOrderValues [%W get]
    }
    

    ea::tools::bindings $widgetPath(ContainerType) {BackSpace Delete} {%W set ""}


    ##
    ## CONFIGURATION based on modifier
    ## 
    switch -- $modifier {
        -add        {
            eAssistHelper::initShipOrderArray
            $f3.ok configure -command "eAssistHelper::saveDest -add {} $widTbl; destroy .dest"
            
        }
        -edit       {
            #ea::db::populateShipOrder [ea::db::getRecord -addressID [$widTbl curselection]]
            ea::db::populateShipOrder [ea::db::getRecord -shippingOrderID [$widTbl curselection]]
            $f3.ok configure -command "eAssistHelper::saveDest -edit [$widTbl curselection] $widTbl; destroy .dest"
        }
        -combine    {
            eAssistHelper::initShipOrderArray
            # This will populate all fields; when combining only populate the fields that match on all selections.
            ea::db::populateShipOrderCombining $widTbl
            $f3.ok configure -command "eAssistHelper::saveDest -combine [list [$widTbl curselection]] $widTbl; destroy .dest"
        }
    }
    
} ;# eAssistHelper::shippingOrder

proc ea::code::bm::writeHiddenShipment {distributionType} {
    #****if* writeHiddenShipment/ea::code::bm
    # CREATION DATE
    #   09/28/2015 (Monday Sep 28)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   Checks the current distribution types, if we have special requirements (single address) then we'll populate the shiporder() array, and issue a write statement
    #   title(shipOrder_id), is relied upon in ea::db::updateSingleAddressToDB
    #***
    global log job shipOrder title program

    # Reset the shipOrder array
    eAssistHelper::initShipOrderArray
    if {[info exists title]} {unset title}
    
    # Retrieve the address and shipvia name
    #set distributionType "07. UPS Import"
    set distributionType [join $distributionType]
    set disttype_addr [ea::db::getDistTypeConfig -method Export -action Single -disttype "$distributionType"]
    if {$disttype_addr eq ""} {${log}::debug [info level 0] No address was setup, we don't need a hidden record.; return}
    
    set shipOrder(Company) [lindex $disttype_addr 0]
    set shipOrder(Attention) [lindex $disttype_addr 1]
    set shipOrder(Address1) [lindex $disttype_addr 2]
    set shipOrder(Address2) [lindex $disttype_addr 3]
    set shipOrder(Address3) [lindex $disttype_addr 4]
    set shipOrder(City) [lindex $disttype_addr 5]
    set shipOrder(State) [lindex $disttype_addr 6]
    set shipOrder(Zip) [lindex $disttype_addr 7]
    set shipOrder(Country) [lindex $disttype_addr 8]
    set shipOrder(Phone) [lindex $disttype_addr 9]
    set shipOrder(ShipVia) [lindex $disttype_addr 10]
    set shipOrder(Notes) ""
    #set shipOrder(PackageType)
    #set shipOrder(ContainerType)
    set shipOrder(DistributionType) "$distributionType"
    
    $job(db,Name) eval "SELECT Versions.VersionName as VersionName, sum(Quantity) as Quantity, ShippingOrders.ShipDate as ShipDate FROM ShippingOrders
                            INNER JOIN Addresses on Addresses.SysAddresses_ID = ShippingOrders.AddressID
                            LEFT JOIN Versions on Versions.Version_ID = ShippingOrders.Versions
                                WHERE Addresses.DistributionType = '$distributionType'
                            AND Addresses.SysActive = 1
                            AND ShippingOrders.Hidden = 0
                            AND JobInformationID IN ('$job(Number)')
                                GROUP BY Versions.VersionName, ShippingOrders.ShipDate" {
                                    #${log}::debug Version Name: $VersionName
                                    set shipOrder(Versions) $VersionName
                                    
                                    ${log}::debug Distribution Type: $distributionType
                                    set shipOrder(Quantity) $Quantity
                                    set shipOrder(ShipDate) $ShipDate

                                    ${log}::debug Version Name: $shipOrder(Versions)
                                    #${log}::debug Version ID: $program(id,Versions)
                                    ${log}::debug ShipDate: $shipOrder(ShipDate)
                                    ${log}::debug Quantity: $Quantity
                                    
                                    ea::code::bm::writeShipment hidden
                                }

} ;# ea::code::bm::writeHiddenShipment "07. UPS Import"

proc ea::code::bm::checkVersionAssignment {args} {
    #****if* checkVersionAssignment/ea::code::bm
    # CREATION DATE
    #   11/13/2015 (Friday Nov 13)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   
    #   
    #***
    global log job shipOrder title
    
    

    

    
} ;# ea::code::bm::checkVersionAssignment
