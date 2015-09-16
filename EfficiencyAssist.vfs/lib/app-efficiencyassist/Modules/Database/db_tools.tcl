# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 07 16,2014
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 169 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2015-03-06 13:29:36 -0800 (Fri, 06 Mar 2015) $
#
########################################################################################

##
## - Overview
# Holds all DB related Procs

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

proc ea::db::populateTablelist {args} {
	#****if* populateTablelist/ea::db
	# CREATION DATE
	#   08/26/2015 (Wednesday Aug 26)
	#
	# AUTHOR
	#	Casey Ackels
	#
	# COPYRIGHT
	#	(c) 2015 Casey Ackels
	#   
	# NOTES
	#   Inserts data from the DB which was just added, to the tablelist widget
	#	-record new|existing
	#   ?-db_id? = id of address that we want to display in the tablelist.
	#   ?-widRow = Row that we want to update
	#   ea::db::populateTablelist -record new|existing -db_id <id> -widRow <rowID>
	#   
	#***
	global log job files title
	
	foreach {key value} $args {
		switch -- $key {
				-record		{
					set record $value
				}
				-id			{
					set db_id $value
				}
				-widRow		{
					set widRow $value
				}
				default		{
					${log}::notice [info level 0] parameter $key isn't recognized
			}
		}
	}
	
	# New Record
	if {$record eq "new"} {
		set db_id $title(db_address,lastid)
		set widPosition end
	}
	
	# Existing Record
	if {$record eq "existing" && $db_id eq ""} {
		return {[info level 0] need an database id}
	} else {
		set widPosition $widRow
		# Remove existing row of data
		$files(tab3f2).tbl delete $widPosition
	}
	

	
	# Get number of columns
	set colCount [$files(tab3f2).tbl columncount]
	
	# Create header list
	# Start at 1, since we don't want to include the 'OrderNumber' column.
	set hdr_data 0
	for {set x 1} {$colCount > $x} {incr x} {
		set colName [$files(tab3f2).tbl columncget $x -name]
		if {[string match -nocase versions $colName] == 1} {
			lappend hdr_list {Versions.VersionName as Versions}
			#lappend hdr_data \$Versions.VersionName
		
		} else {
			lappend hdr_list $colName
		}
		
		lappend hdr_data $$colName	
	}


	$job(db,Name) eval "SELECT [join $hdr_list ,] FROM ShippingOrders
                            INNER JOIN Addresses
                                ON ShippingOrders.AddressID = Addresses.SysAddresses_ID
                            LEFT OUTER JOIN Versions
                                ON Addresses.Versions = Versions.Version_ID
                            WHERE ShippingOrders.JobInformationID in ('$job(Number)')
							AND ShippingOrders.AddressID = '$db_id'
                            AND Addresses.SysActive = 1" {
                                # Removal of the old row happens if we're editing (this occurs in the if-else statement above)
                                $files(tab3f2).tbl insert $widPosition [subst $hdr_data]
                            }
							
	# Clean up
	unset hdr_list
	unset hdr_data
} ;# ea::db::populateTablelist

proc ea::db::writeSingleAddressToDB {} {
	#****if* writeSingleAddressToDB/ea::db
	# CREATION DATE
	#   08/26/2015 (Wednesday Aug 26)
	#
	# AUTHOR
	#	Casey Ackels
	#
	# COPYRIGHT
	#	(c) 2015 Casey Ackels
	#   
	# NOTES
	#   Inserts data from the shipOrder() array into the title db.
	#   
	#***
	global log headerParent job shipOrder title

	# Figure out what table to put the data into.
	#${log}::debug Starting Loop
	foreach hdr_ [array name shipOrder] {
		#${log}::debug Checking which table the data should go into.... consignee
		if {[lsearch $headerParent(headerList,consignee) $hdr_ ] != -1} {
				# Process the Versions column/data. Insert data and retrieve Version ID.
				if {[string match -nocase *vers* $hdr_]} {
					if {$shipOrder($hdr_) == ""} {
						#${log}::debug Set the default if the user didn't supply a version
						set data [$job(db,Name) eval "SELECT Version_ID FROM Versions WHERE VersionName='Version 1' AND VersionActive=1"]
					} else {
						#${log}::debug Check DB to see if the version has already been entered
						set vers [join [$job(db,Name) eval "SELECT VersionName FROM Versions WHERE VersionName='$shipOrder(Versions)' AND VersionActive=1"]]
						if {$vers == ""} {
							#${log}::debug Version doesn't exist in the db yet, insert and return the ID
							$job(db,Name) eval "INSERT INTO Versions (VersionName) values('$shipOrder(Versions)')"
							set data [$job(db,Name) eval "SELECT max(Version_ID) FROM Versions WHERE VersionActive=1"]
						} else {
							#${log}::debug Version exists in db, assigning to address...
							set data [$job(db,Name) eval "SELECT Version_ID FROM Versions WHERE VersionName='$shipOrder(Versions)' AND VersionActive=1"]
							#${log}::debug Version Data in DB: $data
						}
					}
					set shipOrder($hdr_) $data
					#${log}::debug shipOrder($hdr_) $shipOrder($hdr_)
				}
			
			# Table: Addresses
			lappend newRow_consignee '$shipOrder($hdr_)'
			lappend header_order_consignee $hdr_
				
		} elseif {[lsearch $headerParent(headerList,shippingorder) $hdr_ ] != -1} {
			#${log}::debug Checking which table the data should go into.... ShippingOrder
				# Table: Shipping Orders
				lappend newRow_shiporder '$shipOrder($hdr_)'
				lappend header_order_shiporder $hdr_
		}
	}
	#${log}::debug Loop Complete, getting SysGUID and histNote
	#${log}::debug header_orderconsignee: $header_order_consignee
	
	set sysGUID [ea::tools::getGUID]
	set histNote [job::db::insertHistory [mc "Sys: Manual Addition - Addresses"]]
	
	#${log}::debug Creating Header and data for Addresses		
	
	set header_order_consignee "SysAddresses_ID SysAddressParentID HistoryID $header_order_consignee"
	set newRow_consignee "'$sysGUID' '$sysGUID' '$histNote' $newRow_consignee"
	
	#${log}::debug Creating Header and data for ShippingOrders
	set header_order_shiporder "JobInformationID AddressID $header_order_shiporder"
	set newRow_shiporder "'$job(Number)' '$sysGUID' $newRow_shiporder"

	$job(db,Name) eval "INSERT INTO Addresses ([join $header_order_consignee ,]) VALUES ([join $newRow_consignee ,])"
	$job(db,Name) eval "INSERT INTO ShippingOrders ([join $header_order_shiporder ,]) VALUES ([join $newRow_shiporder ,])"
	
	set title(db_address,lastid) $sysGUID
	
	# Clear variables
	unset header_order_consignee
	unset newRow_consignee
	unset header_order_shiporder
	unset newRow_shiporder
	
} ;# ea::db::writeSingleAddressToDB

proc ea::db::updateSingleAddressToDB {} {
	#****if* updateSingleAddressToDB/ea::db
	# CREATION DATE
	#   08/28/2015 (Friday Aug 28)
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
	global log job shipOrder headerParent title

	## Versions require special handling since, it is in another db table. We display the name to the user, but use the ID internally.
	## Update/Insert versions first
	# Does the version exist in the db?
	set versionExists [$job(db,Name) eval "SELECT VersionName FROM Versions WHERE VersionName = '$shipOrder(Versions)'"]
	
	if {$versionExists == ""} {
		# We have a new entry, insert and retrieve the id
		$job(db,Name) eval "INSERT INTO Versions (VersionName) VALUES ('$shipOrder(Versions)')"
		set shipOrder(Versions) [$job(db,Name) eval "SELECT max(Version_ID) from Versions"]
	} else {
		set shipOrder(Versions) [$job(db,Name) eval "SELECT Version_ID FROM Versions WHERE VersionName = '$shipOrder(Versions)'"]
	}
	
	
	# Set value of version to the id
	#set shipOrder(Versions) $versID
	
	
	# loop through the values that are for the Addresses table, then issue an update statement
	#unset address_update
	foreach val $headerParent(headerList,consignee) {
		lappend address_update "$val='$shipOrder($val)'"
	}
	
	# loop through the values that are for the ShippingOrders table, then issue an update statement
	foreach val $headerParent(headerList,shippingorder) {
		lappend shiporder_update "$val='$shipOrder($val)'"
	}
	
	# Update Addresses Table
	#${log}::debug $job(db,Name) eval UPDATE Addresses SET [join $address_update ,] WHERE SysAddresses_ID = '$shipOrder(id)'
	#$job(db,Name) tran
	$job(db,Name) eval "UPDATE Addresses SET [join $address_update ,] WHERE SysAddresses_ID = '$title(shipOrder_id)'"
	
	
	# Update ShippingOrders table
	#${log}::debug $job(db,Name) eval UPDATE ShippingOrders SET [join $shiporder_update ,] WHERE AddressID = '$shipOrder(id)' AND JobInformationID = '$job(Number)'
	$job(db,Name) eval "UPDATE ShippingOrders SET [join $shiporder_update ,] WHERE AddressID = '$title(shipOrder_id)' AND JobInformationID = '$job(Number)'"
	

	# clean up
	unset address_update
	unset shiporder_update
	
} ;# ea::db::updateSingleAddressToDB

proc ea::db::getRecord {row_id} {
	#****if* getRecord/ea::db
	# CREATION DATE
	#   08/27/2015 (Thursday Aug 27)
	#
	# AUTHOR
	#	Casey Ackels
	#
	# COPYRIGHT
	#	(c) 2015 Casey Ackels
	#   
	# NOTES
	#   Returns the SysAddresses_ID based on row_id (tablelist)
	#   
	#***
	global log files headerParent job
	# testing
	#set row_id [$files(tab3f2).tbl curselection]
	
	# Get list of available headers; this could change based on data in the db. So we must figure out what is active, and compare that to the headerParent array
	set colCount [$files(tab3f2).tbl columncount]
	
	for {set x 1} {$colCount > $x} {incr x} {
		lappend hdr_gui [$files(tab3f2).tbl columncget $x -name]
	}
	
	set hdr_uniqueOnly [lsort -unique "$headerParent(headerList,consignee) $hdr_gui"]
	
	# Compare against the headers in the tablelist
	foreach hdr $hdr_uniqueOnly {
		if {[lsearch $hdr_gui $hdr] != -1} {
			lappend hdr_list $hdr
		}
	}
	
	# Compare above results against columns in the address table (headerParent() array)
	# Ignore the Versions column
	foreach hdr $hdr_list {
		if {[lsearch $headerParent(headerList,consignee) $hdr] != -1 && [string match -nocase *vers* $hdr] == 0} {
			lappend hdr_list_final $hdr
		}
	}
	
	# Now we can grab the data from the tablelist. Guard against nulls.
	foreach hdr $hdr_list_final {
			lappend data_ "ifnull($hdr,'')='[$files(tab3f2).tbl getcells $row_id,$hdr]'"
	}
	
	#${log}::debug [info level 0] data: $data_
	unset hdr_list
	unset hdr_gui
	unset hdr_list_final
		
	return [$job(db,Name) eval "SELECT SysAddresses_ID FROM Addresses WHERE [join $data_ " AND "]"]

} ;# ea::db::getRecord [$files(tab3f2).tbl curselection]


proc ea::db::populateShipOrder {db_id} {
	#****if* populateShipOrder/ea::db
	# CREATION DATE
	#   08/28/2015 (Friday Aug 28)
	#
	# AUTHOR
	#	Casey Ackels
	#
	# COPYRIGHT
	#	(c) 2015 Casey Ackels
	#   
	# NOTES
	#   Populates the shipOrder array based on given id (id from database)
	#
	# SEE ALSO
	#  ea::getRecord
	#  
	#***
	global log shipOrder job title
	
	# Setup vars
	eAssistHelper::initShipOrderArray
	
	# Testing only
	#set db_id 4B8545E7-424F-4A51-8261-9318AA15A53F
	
	# Build the header list
	foreach hdrs [array names shipOrder] {
		if {[string match -nocase *vers* $hdrs]} {
				set hdrs {Versions.VersionName as Versions}
		}
		lappend hdr_list $hdrs
	}
	
	${log}::debug hdr_list: $hdr_list
	
	$job(db,Name) eval "SELECT [join $hdr_list ,] FROM ShippingOrders
                            INNER JOIN Addresses
                                ON ShippingOrders.AddressID = Addresses.SysAddresses_ID
                            LEFT OUTER JOIN Versions
                                ON Addresses.Versions = Versions.Version_ID
                            WHERE ShippingOrders.JobInformationID in ('$job(Number)')
                            AND Addresses.SysAddresses_ID = '$db_id'" {
								foreach item [array names shipOrder] {
									set shipOrder($item) [subst $$item]
								}
							}
	set title(shipOrder_id) $db_id
	unset hdr_list
	
} ;# ea::db::populateShipOrder [ea::db::getRecord [$files(tab3f2).tbl curselection]]


proc ea::db::populateShipOrderCombining {widTbl} {
	#****if* populateShipOrderCombining/ea::db
	# CREATION DATE
	#   09/03/2015 (Thursday Sep 03)
	#
	# AUTHOR
	#	Casey Ackels
	#
	# COPYRIGHT
	#	(c) 2015 Casey Ackels
	#   
	# NOTES
	#   Compare values from the selected rows, if they are the same display them in the form. If they are different, display empty values.
	#	Sum the quantity column.
	#   
	#***
	global log shipOrder title job

	foreach row [lsort [$widTbl curselection]] {
				${log}::debug Record Num: [ea::db::getRecord $row]
				lappend id '[ea::db::getRecord $row]'
			}
			
	# Retrieve the total quantity
	set shipOrder(Quantity) [$job(db,Name) eval "SELECT sum(Quantity) from ShippingOrders WHERE AddressID IN ([join $id ,])"]
	
	# Retrieve distinct values from the ShippingOrders table. Don't bother with the addresses table since most likely the data entered will be different.
	$job(db,Name) eval "SELECT DISTINCT ShipDate, ContainerType, PackageType, ShippingClass FROM ShippingOrders WHERE AddressID IN ([join $id ,])" {
		set shipOrder(ShipDate) $ShipDate
		set shipOrder(ContainerType) $ContainerType
		set shipOrder(PackageType) $PackageType
		set shipOrder(ShippingClass) $ShippingClass
	}

	set title(db_id,mult) $id
	unset id

} ;# ea::db::populateShipOrderCombining $files(tab3f2).tbl


proc ea::db::setConsigneeAutoComplete {data} {
	#****if* setConsigneeAutoComplete/ea::db
	# CREATION DATE
	#   09/03/2015 (Thursday Sep 03)
	#
	# AUTHOR
	#	Casey Ackels
	#
	# COPYRIGHT
	#	(c) 2015 Casey Ackels
	#   
	# NOTES
	#   Populates the consignee information of the shipOrder() array, based on the company name entered into the Company entry field
	#   This only looks at addresses that are active, and exist in the 'master address' table.
	#   
	#***
	global log shipOrder

	#${log}::debug widget value: $data
	db eval "SELECT MasterAddr_Attn,
						MasterAddr_Addr1, MasterAddr_Addr2, MasterAddr_Addr3,
                        MasterAddr_City, MasterAddr_StateAbbr, MasterAddr_Zip,
						MasterAddr_CtryCode, MasterAddr_Phone
                    FROM MasterAddresses
						WHERE MasterAddr_Company = '[join $data]'
						AND MasterAddr_Active = 1" {
						set shipOrder(Attention) $MasterAddr_Attn
						set shipOrder(Address1) $MasterAddr_Addr1
						set shipOrder(Address2) $MasterAddr_Addr2
						set shipOrder(Address3) $MasterAddr_Addr3
						set shipOrder(City) $MasterAddr_City
						set shipOrder(State) $MasterAddr_StateAbbr
						set shipOrder(Zip) $MasterAddr_Zip
						set shipOrder(Country) $MasterAddr_CtryCode
						set shipOrder(Phone) $MasterAddr_Phone
					}

} ;# ea::db::setConsigneeAutoComplete


proc ea::db::setShipOrderValues {dist_type} {
	#****if* setShipOrderValues/ea::db
	# CREATION DATE
	#   09/03/2015 (Thursday Sep 03)
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
	global log shipOrder job widgetPath

	# disttype has a chance of being empty... lets quit if it is.
	if {$dist_type eq ""} {return}
	
	# Check if there are carriers setup on the customer level; use those if we do.
	# If nothing is returned, check the ShipmentType (Freight, Small Package)
	# 		--WHERE ShipmentTypes.ShipmentType = 'Freight'
	set shipViaValues [db eval "SELECT ShipVia.ShipViaName FROM DistributionTypes
		INNER JOIN DistributionTypeCarriers on DistributionTypeCarriers.DistributionTypeID = DistributionTypes.DistributionType_ID
		INNER JOIN ShipmentTypes on DistributionTypes.DistType_ShipTypeID = ShipmentTypes.ShipmentType_ID
		INNER JOIN ShipVia on DistributionTypeCarriers.ShipViaID = ShipVia.ShipVia_ID
		INNER JOIN CustomerShipVia on ShipVia.ShipVia_ID = CustomerShipVia.ShipViaID
		WHERE DistTypeName = '$dist_type'
		AND CustomerShipVia.CustID = '$job(CustID)'"]
	
	${log}::debug shipViaValues: Carriers match dist type on the Customer level? $shipViaValues
	# Compare shipment types from the shipvia's on the customer, to the shipment types set on the distribution type
	if {$shipViaValues eq ""} {
		set distShipType [join [db eval "SELECT ShipmentType from ShipmentTypes
										INNER JOIN DistributionTypes on DistributionTypes.DistType_ShipTypeID = ShipmentTypes.ShipmentType_ID
									WHERE DistributionTypes.DistTypeName = '$dist_type'"]]
		
		
		set shipViaValues [db eval "SELECT ShipVia.ShipViaName FROM ShipVia
										INNER JOIN CustomerShipVia on CustomerShipVia.ShipViaID = ShipVia.ShipVia_ID
									WHERE CustomerShipVia.CustID = '$job(CustID)'
									AND ShipVia.ShipmentType = '$distShipType'"]
		
		${log}::debug shipViaValues: Carriers match ship type on the Customer level? $shipViaValues
	}
	
	# Nothing was found for the customer, list what is setup on the distribution type if available
	if {$shipViaValues eq ""} {
		unset shipViaValues
		# Carrier hasn't been setup at the customer level, lets look at what was setup on the distribution type level
		# Retrieve the Carrier ID's assigned to the distribution type
		set carrierID [db eval "SELECT CarrierID FROM DistributionTypeCarriers
									LEFT JOIN Carriers ON CarrierID = Carrier_ID
									LEFT JOIN DistributionTypes ON DistributionTypeID = DistributionType_ID
								WHERE DistTypeName = '$dist_type'"]
		
		# Set Ship Via values
		db eval "SELECT ShipViaName FROM ShipVia WHERE CarrierID IN ([join $carrierID ,])" {
			lappend shipViaValues $ShipViaName
		}
		
		## No Carriers were assigned to the distribution type; filter out small package, or freight ship via's
		if {![info exists shipViaValues]} {
			#set shipViaValues ""
			db eval "SELECT ShipViaName from ShipVia WHERE ShipmentType = (
						SELECT ShipmentType from ShipmentTypes
							INNER JOIN DistributionTypes on ShipmentType_ID = DistType_ShipTypeID
						WHERE DistributionTypes.DistTypeName = '$dist_type')" {
							lappend shipViaValues $ShipViaName
			}
		}
	}

	#${log}::debug Ship Via Values: $shipViaValues
	
	# Configure Ship Via Widget
	$widgetPath(ShipVia) configure -values $shipViaValues
	
	# If we only have one value, lets insert it into the field. If we have multiple clear out the widget so the user must select a value. If we don't and the user has to select
	# a distribution type twice or more we could end up with incorrect data in the field.
	if {$shipViaValues ne "" && [llength $shipViaValues] == 1} {
		$widgetPath(ShipVia) set [join $shipViaValues]
	} else {
		$widgetPath(ShipVia) set ""
	}
	
	unset shipViaValues

} ;# ea::db::setShipOrderValues