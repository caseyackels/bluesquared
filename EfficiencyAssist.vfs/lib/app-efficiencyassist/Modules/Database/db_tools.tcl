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

proc ea::db::populateTablelist {} {
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
	#   
	#***
	global log job files title
	
	# Get number of columns
	set colCount [$files(tab3f2).tbl columncount]
	
	# Create header list
	# Start at 1, since we don't want to include the 'OrderNumber' column.
	set hdr_data 0
	for {set x 1} {16 > $x} {incr x} {
		set colName [$files(tab3f2).tbl columncget $x -name]
		if {[string match -nocase versions $colName] == 1} {
			lappend hdr_list Versions.VersionName
			lappend hdr_data $Versions.VersionName
		
		} else {
			lappend hdr_list $colName
			lappend hdr_data $$colName	
		}
	}


	$job(db,Name) eval "SELECT [join $hdr_list ,] FROM ShippingOrders
                            INNER JOIN Addresses
                                ON ShippingOrders.AddressID = Addresses.SysAddresses_ID
                            LEFT OUTER JOIN Versions
                                ON Addresses.Versions = Versions.Version_ID
                            WHERE ShippingOrders.JobInformationID in ('$job(Number)')
							AND ShippingOrders.AddressID = '$title(db_address,lastid)'
                            AND Addresses.SysActive = 1" {
                                #$wid insert end [subst $hdr_data]
                                $files(tab3f2).tbl insert end [subst $hdr_data]
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
	${log}::debug Starting Loop
	foreach hdr_ [array name shipOrder] {
		${log}::debug Checking which table the data should go into.... consignee
		if {[lsearch $headerParent(headerList,consignee) $hdr_ ] != -1} {
				# Process the Versions column/data. Insert data and retrieve Version ID.
				if {[string match -nocase *vers* $hdr_]} {
					if {$shipOrder($hdr_) == ""} {
						${log}::debug Set the default if the user didn't supply a version
						set data [$job(db,Name) eval "SELECT Version_ID FROM Versions WHERE VersionName='Version 1' AND VersionActive=1"]
					} else {
						${log}::debug Check DB to see if the version has already been entered
						set vers [join [$job(db,Name) eval "SELECT VersionName FROM Versions WHERE VersionName='$shipOrder(Versions)' AND VersionActive=1"]]
						if {$vers == ""} {
							${log}::debug Version doesn't exist in the db yet, insert and return the ID
							$job(db,Name) eval "INSERT INTO Versions (VersionName) values('$shipOrder(Versions)')"
							set data [$job(db,Name) eval "SELECT max(Version_ID) FROM Versions WHERE VersionActive=1"]
						} else {
							${log}::debug Version exists in db, assigning to address...
							set data [$job(db,Name) eval "SELECT Version_ID FROM Versions WHERE VersionName='$shipOrder(Versions)' AND VersionActive=1"]
							${log}::debug Version Data in DB: $data
						}
					}
					set shipOrder($hdr_) $data
					${log}::debug shipOrder($hdr_) $shipOrder($hdr_)
				}
			
			# Table: Addresses
			lappend newRow_consignee '$shipOrder($hdr_)'
			lappend header_order_consignee $hdr_
				
		} elseif {[lsearch $headerParent(headerList,shippingorder) $hdr_ ] != -1} {
			${log}::debug Checking which table the data should go into.... ShippingOrder
				# Table: Shipping Orders
				lappend newRow_shiporder '$shipOrder($hdr_)'
				lappend header_order_shiporder $hdr_
		}
	}
	${log}::debug Loop Complete, getting SysGUID and histNote
	${log}::debug header_orderconsignee: $header_order_consignee
	
	set sysGUID [ea::tools::getGUID]
	set histNote [job::db::insertHistory [mc "Sys: Manual Addition - Addresses"]]
	
	${log}::debug Creating Header and data for Addresses		
	
	set header_order_consignee "SysAddresses_ID SysAddressParentID HistoryID $header_order_consignee"
	set newRow_consignee "'$sysGUID' '$sysGUID' '$histNote' $newRow_consignee"
	
	${log}::debug Creating Header and data for ShippingOrders
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
