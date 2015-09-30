# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 01 12,2014
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 479 $
# $LastChangedBy: casey.ackels@gmail.com $
# $LastChangedDate: 2015-03-11 17:33:06 -0700 (Wed, 11 Mar 2015) $
#
########################################################################################
# ea::code::export

namespace eval export {}

proc export::DataToExport {} {
    #****f* DataToExport/export
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Gather, and assemble the data to export. For Distribution.
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
    global log headerParent files mySettings job

    #if {[info exists mySettings(job,fileName)] != 1} {
    #    # Set the default format for the file name.
    #    set mySettings(job,fileName) "%number %title %name"
    #}
    
    foreach val [list Title Name Number] {
        if {![info exists job($val)]} {
            ${log}::debug Aborting... job($val) doesn't exist. Please fill in the $val field.
                set answer [tk_messageBox -message "Please put in a Job $val" \
                        -icon question -type yesno \
                        -detail "Select \"Yes\" to open the Project Setup window."]
                switch -- $answer {
                        yes {customer::projSetup}
                        no {exit}
                }
            return
            }
    }
    # Check to see if we need to output multiple files
    # What dist types do we have
    set distTypes [$job(db,Name) eval "SELECT distinct(DistributionType) from Addresses"]
    
    # Any on our black list?
    set dist_blacklist [list {07. UPS Import} {09. USPS Import} {13. FedEx Import}]

    if {[info exists newDist]} {unset newDist}
    foreach dist_ $dist_blacklist {
        if {[lsearch $distTypes $dist_] != -1} {
            lappend newDist '$dist_'
            #puts "total count: [$job(db,Name) eval "SELECT sum(Quantity) from Addresses WHERE DistributionType='$dist_'"]"
            ${log}::debug We need to create a separate file ...
        }
    }
    if {[info exists newDist]} {
        set newDist [join $newDist " OR "]
        
    } else {
        # Just in case we don't have any of the blacklist dist types in use
        set newDist ''
    }

    

    # Assemble the file names, and issue any warnings
    set fName [ea::tools::formatFileName]
    #set fileName $mySettings(job,fileName)
    #foreach item {Title Name Number} {
    #    set item2 [string tolower $item]
    #    #puts [string map [list %$item2 $job($item)] $mySettings(job,fileName)]
    #    set fileName [string map [list %$item2 [join $job($item) -]] $fileName]
    #    #${log}::debug FILENAME: [join $fileName]
    #}
    #set fName [join $fileName _]
            
    if {$newDist != {''} } {
        set fileNameList [list planner batch]
    } else {
        set fileNameList [list planner]
        
    }
        
    foreach file_Name $fileNameList {
        set fileName [join "$fName $file_Name" _]
        
        # don't open the file yet, because we may have canceled the Save As dialog...
        set myFile(data) [file join [eAssist_Global::SaveFile $fileName $job(SaveFileLocation)]]
        
            #${log}::debug myFile(data): $myFile(data)

        if {$myFile(data) eq {}} {
            ${log}::notice Aborting... The Save As window was closed without a file name.
            return
        } else {
            if {[file exists $myFile(data)] && ![file writable $myFile(data)]} {
                tk_messageBox -message "The file is open in another program, please close before exporting." \
                                -icon warning -type ok \
                                -detail "$myFile(data)"
                return
            } else {
                set fd [open $myFile(data) w]
            }
        }
        if {$file_Name eq "planner"} {
            set id [$job(db,Name) eval "SELECT OrderNumber FROM Addresses WHERE DistributionType != $newDist"]
        } else {
            set id [$job(db,Name) eval "SELECT OrderNumber FROM Addresses WHERE DistributionType == $newDist"]
        }
        export::toFile $id $fd
        chan close $fd
    }

} ;# export::DataToExport


proc export::toFile {id fd} {
    #****f* batchFile/export
    # CREATION DATE
    #   02/27/2015 (Friday Feb 27)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   export::batchFile id fname
    #
    # FUNCTION
    #	Outputs the batch files for *imports*
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
    global log files job
    
    set tmpHdr [job::db::retrieveHeaderNames $job(db,Name) Addresses]
    set tmpHdr [string map {ShipVia ShipViaCode} $tmpHdr]
    catch {$job(db,Name) eval "ATTACH 'EA_setup.edb' as db1"}

    # HEADER: Write output
    # OrderType is a hardcoded value, this should be moved to a user option.
    #   OrderType is the Column name, Version is the value.
    if {[info exists colNames]} {unset colNames}
    set colCount [$files(tab3f2).tbl columncount]
    for {set x 0} {$colCount > $x} {incr x} {
        set tblName [$files(tab3f2).tbl columncget $x -name]
        # Just in case the header doesn't exist in the db; but we have it in the tablelist...
        set outputColNames [db eval "SELECT OutputHeaderName FROM Headers where InternalHeaderName='$tblName'"]
        
        if {$outputColNames eq ""} {
            lappend colNames [$files(tab3f2).tbl columncget $x -name]
        } else {
            lappend colNames $outputColNames
        }
    }
    # Write the headers
    chan puts $fd [::csv::join "$colNames OrderType"]
    

    # Write the data
    foreach item $id {
            set record [$job(db,Name) eval "SELECT [join $tmpHdr ,] FROM Addresses
                                                INNER JOIN db1.ShipVia ON Addresses.ShipVia = db1.ShipVia.ShipViaName
                                            WHERE OrderNumber='$item'"]
            #${log}::debug $record
            chan puts $fd [::csv::join "$record Version"]
    }

    
    
} ;# export::toFile

proc test {} {
    set cols [db eval "SELECT dbColName FROM HeadersConfig WHERE widExportable = 1 ORDER BY widUIPositionWeight, dbColName DESC"]
    puts $cols
}

proc ea::code::export::toPlanner {args} {
    #****f* toPlanner/ea::code::export
    # CREATION DATE
    #   09/29/2015 (Tuesday Sep 29)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # USAGE
    #   ea::code::export::toPlanner args 
    #
    # FUNCTION
    #	Exports all valid shipments to a file, so it can be imported into Planner
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # EXAMPLE
    #   ea::code::export::toPlanner 
    #
    # NOTES
    #   REQUIREMENT: Distribution Type, Ship Via must be set in the database or else those shipments will not be exported (they don't show up in the query)
    #  
    # SEE ALSO
    #   
    #   
    #***
    global log job headerParent

    set dist_blacklist [ea::db::getDistSetup]
    #${log}::debug BlackList - Disttype: $dist_blacklist
    
    # Get list of addressid's that are part of the blacklisted distribution types
    # Report: requires the different address, PLUS all addresses (summarized)
    # Export: requires the different address (single entry)
    $job(db,Name) eval "SELECT AddressID FROM ShippingOrders
                            INNER JOIN Addresses on Addresses.SysAddresses_ID = ShippingOrders.AddressID
                            WHERE ShippingOrders.JobInformationID = '$job(Number)'
                        AND Addresses.DistributionType IN ([join $dist_blacklist ,])" {
                            lappend blacklist '$AddressID'
                        }
                        #${log}::debug Blacklist - AddressID: $blacklist
    
    #foreach cons $headerParent(headerList,consignee) {
    #    # Creating the list of columns to query
    #    lappend cols "Addresses.$cons as $cons"
    #    # Creating the list of header names
    #    lappend hdr $cons
    #    # Creating the list of variables to display the values
    #    lappend vals \$$cons
    #}
    #
    #foreach shiporder $headerParent(headerList,shippingorder) {
    #    lappend hdr $shiporder
    #    lappend cols "ShippingOrders.$shiporder as $shiporder"
    #    
    #    if {[string tolower $shiporder] eq "shipvia"} {
    #        # ShipVia and ShipViaCode are both required in the columns sent to the db. But we only want one "ShipViaCode" in the values.
    #        set shiporder ShipViaCode
    #        lappend cols "ShipVia.ShipViaCode as ShipViaCode"
    #        lappend vals \$ShipViaCode
    #    } else {
    #        lappend vals \$$shiporder
    #    }
    #}
    #
    #lappend cols "Versions.VersionName as Versions"
    #lappend hdr Versions
    #lappend vals "\$Versions"
    set headers [ea::tools::assembleHeaders]
        set cols [lindex $headers 0] 
        set hdr [lindex $headers 1] 
        set vals [lindex $headers 2] 

    #${log}::debug cols: $cols
    #${log}::debug vals: $vals
    
    catch {$job(db,Name) eval "ATTACH 'EA_setup.edb' as db1"}
    
    # Assemble the file names, and issue any warnings
    set fName [ea::tools::formatFileName]-planner
    set fd [open [file join $job(JobSaveFileLocation) $fName.csv] w]
    
    # Write the headers
    chan puts $fd [::csv::join "$hdr OrderType"] 
    
    # *** Basic Shipments
    $job(db,Name) eval "SELECT [join $cols ,]
                        FROM ShippingOrders
                            INNER JOIN Addresses ON Addresses.SysAddresses_ID = ShippingOrders.AddressID
                            INNER JOIN Versions ON Addresses.Versions = Versions.Version_ID
                            INNER JOIN db1.ShipVia ON ShippingOrders.ShipVia = ShipVia.ShipViaName
                        WHERE ShippingOrders.JobInformationID = $job(Number)
                            AND ShippingOrders.AddressID NOT IN ([join $blacklist ,])" {
                                #${log}::debug Record - [subst $vals] Version
                                set record "[subst $vals] Version"
                                #${log}::debug [::csv::join $record]
                                chan puts $fd [::csv::join $record]
                            }
                            
    # *** Blacklisted shipments
    $job(db,Name) eval "SELECT [join $cols ,]
                        FROM ShippingOrders
                            INNER JOIN Addresses ON Addresses.SysAddresses_ID = ShippingOrders.AddressID
                            INNER JOIN Versions ON Addresses.Versions = Versions.Version_ID
                            INNER JOIN db1.ShipVia ON ShippingOrders.ShipVia = ShipVia.ShipViaName
                        WHERE ShippingOrders.JobInformationID = $job(Number)
                            AND ShippingOrders.Hidden = 1
                            AND Addresses.DistributionType IN ([join $dist_blacklist ,])" {
                                set record "[subst $vals] Version"
                                #${log}::debug [::csv::join $record]
                                chan puts $fd [::csv::join $record]
                            }
                        
    chan close $fd
    catch {$job(db,Name) eval "DETACH 'db1'"}
} ;# ea::code::export::toPlanner

proc ea::code::export::toProcessShipper {args} {
    #****f* toProcessShipper/ea::code::export
    # CREATION DATE
    #   09/29/2015 (Tuesday Sep 29)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # USAGE
    #   ea::code::export::toProcessShipper args 
    #
    # FUNCTION
    #	Exports all shipments associated with 'import' distribution types.
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # EXAMPLE
    #   ea::code::export::toProcessShipper 
    #
    # NOTES
    #   
    #  
    # SEE ALSO
    #   
    #   
    #***
    global log job headerParent

    set dist_blacklist [ea::db::getDistSetup]

    $job(db,Name) eval "SELECT AddressID FROM ShippingOrders
                            INNER JOIN Addresses on Addresses.SysAddresses_ID = ShippingOrders.AddressID
                            WHERE ShippingOrders.JobInformationID = '$job(Number)'
                        AND Addresses.DistributionType IN ([join $dist_blacklist ,])" {
                            lappend blacklist '$AddressID'
                        }
                        
    set headers [ea::tools::assembleHeaders]
        set cols [lindex $headers 0] 
        set hdr [lindex $headers 1] 
        set vals [lindex $headers 2] 

    #${log}::debug cols: $cols
    #${log}::debug vals: $vals
    
    catch {$job(db,Name) eval "ATTACH 'EA_setup.edb' as db1"}

    foreach disttype $dist_blacklist {
        # Assemble the file names, and issue any warnings
        ${log}::debug disttype: $disttype
        set hasData [$job(db,Name) eval "SELECT COUNT(Address1) FROM Addresses WHERE DistributionType = $disttype"]
        if {1 <= $hasData} {
            set fName [ea::tools::formatFileName]-[join $disttype ""]
            set fd [open [file join $job(JobSaveFileLocation) $fName.csv] w]
            # Write the headers
            chan puts $fd [::csv::join "$hdr OrderType"]
            
            $job(db,Name) eval "SELECT [join $cols ,]
                                FROM ShippingOrders
                                    INNER JOIN Addresses ON Addresses.SysAddresses_ID = ShippingOrders.AddressID
                                    INNER JOIN Versions ON Addresses.Versions = Versions.Version_ID
                                    INNER JOIN db1.ShipVia ON ShippingOrders.ShipVia = ShipVia.ShipViaName
                                WHERE ShippingOrders.JobInformationID = $job(Number)
                                    AND ShippingOrders.Hidden = 0
                                    AND Addresses.DistributionType IN ($disttype)" {
                                        set record "[subst $vals] Version"
                                        #${log}::debug [::csv::join $record]
                                        chan puts $fd [::csv::join $record]
                                    }
            chan close $fd
        }
    }
    catch {$job(db,Name) eval "DETACH 'db1'"}
} ;# ea::code::export::toProcessShipper
