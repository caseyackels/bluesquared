# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 10 24,2013
##
## - Overview
# Assign Internal (Company) samples.

proc ea::code::samples::quickAddSmpls {win entryWid} {
    #****f* quickAddSmpls/ea::code::samples
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Quickly add sample quantities into the selected columns
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
	# 	This relies on the textvariable (of the samples (CSR, Sales, Ticket, SampleRoom) to be the same as the column name
    #
    # SEE ALSO
    #
    #***
    global log csmpls
    
    set entryTxt [$entryWid get]

    if {$csmpls(assignAllVersions) == 1} {
        ${log}::debug Assigning quantity to all versions
        set cmd {$win fillcolumn $x $entryTxt}
    
    } else {
        ${log}::debug Assigning quantity to a specific version
        ${log}::debug Looking for Version $csmpls(activeVersion)
        
        # Guard against the user not selecting a version, and not selecting 'all versions' checkbutton
        if {$csmpls(activeVersion) eq ""} {return}
        
        # Find out which row our version is on
        set versRow [$win searchcolumn Version $csmpls(activeVersion)]
        ${log}::debug $versRow

        set cmd {$win cellconfigure $versRow,$x -text $entryTxt}
    }
    
	for {set x 0} {[$win columncount] > $x} {incr x} {
		set currentColumn [$win columncget $x -name]
        #${log}::debug Column Names: $currentColumn
        #
        #if {$currentColumn eq "Version"} {
        #    ${log}::debug Version Column
        #    ${log}::debug Current Version: [$win getcells end,Version]
        #}
		
		foreach value [array names csmpls] {
			if {[string match $value $currentColumn] == 1} {
				if {$csmpls($value) == 1} {
					#$win fillcolumn $x $entryTxt
                    eval $cmd
					#eAssistHelper::detectColumn $win "" $x
					# Reset the checkbutton
					set csmpls($value) 0
				}
			}
		}
	}
	
	# Clear the entry widget
	$entryWid delete 0 end
} ;# ea::code::samples::quickAddSmpls

proc ea::code::samples::setVersState {cbox} {
    #****if* setVersState/ea::code::samples
    # CREATION DATE
    #   10/29/2015 (Thursday Oct 29)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   Clears out the version combobox and sets the state.
    #   
    #***
    global log csmpls
    
    set cstate [$cbox cget -state]
    
    if {$cstate eq "readonly"} {
        # Issue disabling commands
        $cbox configure -state normal
        $cbox delete 0 end
        $cbox configure -state disabled
    } else {
        # Issue enabling commands
        $cbox configure -state readonly
        # clear the 'all versions' checkbutton
        set csmpls(assignAllVersions) 0
    }
    
} ;# ea::code::samples::setVersState

proc ea::code::samples::writeToDB {widTbl} {
    #****if* writeToDB/ea::db::samples
    # CREATION DATE
    #   10/30/2015 (Friday Oct 30)
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
    global log shipOrder csmpls job title program
    
    # Reset the shipOrder array
    eAssistHelper::initShipOrderArray
    
    # Check to see if an address was entered for this distribution type
    set disttype_addr [ea::db::getDistTypeConfig -method Report -action Single -disttype "$csmpls(distributionType)"]
    if {$disttype_addr eq ""} {${log}::critical [info level 0] There is not a company setup for this distribution type; return}
    
    # Populate the shipOrder array
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
    
    # Variables that don't exist in the disttype_addr var
    set shipOrder(DistributionType) "$csmpls(distributionType)"
    if {![info exists csmpls(packageType)]} {${log}::critical [info level 0] Please select a package type and try again.; return}
    set shipOrder(PackageType) "$csmpls(packageType)"
    
    # set ship and arrive dates based on the min(ShipDate) in ShippingOrders
    set shipOrder(ShipDate) [$job(db,Name) eval "SELECT MIN(ShipDate) FROM ShippingOrders
                                                    WHERE JobInformationID = '$job(Number)'
                                                    AND Hidden != 1"]
    set shipOrder(ArriveDate) $shipOrder(ShipDate)
    # This should come directly from the db; setup on dist type?
    set shipOrder(ShippingClass) "Finished Product"
    
    # write out the records per version
    foreach record [$widTbl get 0 end] {
        set qtys [join [join [lrange $record 2 end]] +]
        set qty [lrange $record 2 end]
        
        set vers [join [lindex $record 1]]
        # Returns the version id
        set program(id,Versions) [job::db::getVersionCount -type id -job $job(Number) -version "$vers" -versActive 1 -addrActive 1]
        # Populate with the name
        set shipOrder(Versions) $vers
               
        if {$qtys ne ""} {
            set shipOrder(Quantity) [expr $qtys]
        }

        
        ea::code::bm::writeShipment hidden
  
        # Insert data into tbl:InternalSamples
        if {[info exists title(shipOrder_id)] && $title(shipOrder_id) ne ""} {
            foreach entry $record {
                #${log}::debug  "ShippingOrders_ID $title(shipOrder_id) [lrange $entry $x $x] $notes"
                set id $title(shipOrder_id)
            }
        } elseif {[info exists title(db_address,lastid)] && $title(db_address,lastid) ne ""} {
            foreach entry $record {
                #${log}::debug  "ShippingOrders_ID $title(db_address,lastid) [lrange $entry $x $x] $notes"
                set id $title(db_address,lastid)
            }
        } else {
            # Neither variable was populated; lets look for the id
            set id [$job(db,Name) eval "SELECT SysAddresses_ID FROM Addresses WHERE Company LIKE '%JG Samples%'"]
        }
        
        ${log}::debug Sample ID: $id
        set shipOrderID [lindex [$job(db,Name) eval "SELECT DISTINCT ShippingOrder_ID, AddressID FROM ShippingOrders
                                                WHERE JobInformationID = '$job(Number)'
                                                AND AddressID = '$id'"] 0]
        
        # First delete entries if they exist
        $job(db,Name) eval "DELETE FROM InternalSamples WHERE ShippingOrderID = $shipOrderID"
        
        # Figure out what column contains what quantity. We create a 'note entry' on this data.
        set y 0
        for {set x 2} {$x < 6} {incr x} {
            set colName [$widTbl columncget $x -name]
            #${log}::debug Column: $colName
            
            set colQty [lindex $qty $y]
            #${log}::debug Quantity: $colQty
            
            if {$colQty != ""} {
                set notes "$colName $colQty"
                lappend smplNotes "$colName $colQty"
            }

            # Enter into DB
            #${log}::debug $shipOrderID $colName $colQty INSPECT
            $job(db,Name) eval "INSERT INTO InternalSamples (ShippingOrderID, Location, Quantity, Notes) VALUES ($shipOrderID, '$colName', '$colQty', 'INSPECT')"
            incr y
            
        }
        
        set shipOrder(Notes) "INSPECT [join $smplNotes ", "]"
        $job(db,Name) eval "UPDATE Addresses SET Notes='$shipOrder(Notes)'
                                WHERE SysAddresses_ID = '$id'"
        # Populate table
        #ea::db::populateTablelist -record new
    }
    
} ;# ea::db::samples::writeToDB

proc ea::db::samples::getSamples {args} {
    #****if* getSamples/ea::db::samples
    # CREATION DATE
    #   11/03/2015 (Tuesday Nov 03)
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
    global log job

    $job(db,Name) eval "SELECT JobInformationID, Versions.VersionName as name, InternalSamples.Location as loc, InternalSamples.Quantity as qty
                            FROM ShippingOrders
                            INNER JOIN InternalSamples on InternalSamples.ShippingOrderID = ShippingOrders.ShippingOrder_ID
                            INNER JOIN Versions on Versions.Version_ID = ShippingOrders.Versions
                            WHERE JobInformationID = '307180'
                            AND Versions.VersionName = '[join $args]'" {
                                lappend toEnter "$qty"
                            }
                            
    if {[info exists toEnter]} {
        ${log}::debug getSamples: $toEnter
        return $toEnter
    }
    
} ;# ea::db::samples::getSamples
