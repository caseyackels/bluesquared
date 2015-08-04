# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 7/27/2015

proc eAssistSetup::populateDistTypeAddresses {wid} {
    set values [db eval "SELECT MasterAddr_Company FROM MasterAddresses
            WHERE MasterAddr_Active = 1
            AND MasterAddr_Internal = 1"]
    $wid configure -values $values
    
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
    
    if {![info exists carrierValues]} {return}
    $wid.cbox_addCarriers configure -values $carrierValues
} ;# eAssistSetup::populateDistTypeCarrierList


proc ea::db::writeDistTypeSetup {lbox win tbl} {
    #****if* writeDistTypeSetup/ea::db
    # CREATION DATE
    #   07/29/2015 (Wednesday Jul 29)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   DB Tables:
    #   * DistributionTypes - Holds configuration for each dist type
    #   * DistributionTypeCarriers - Holds which carriers are assigned to that dist type
    #   
    #***
    global log disttype
    
    set disttype(carriers) [$lbox get 0 end]
    
    set addrID [db eval "SELECT MasterAddr_ID from MasterAddresses WHERE MasterAddr_Company='$disttype(useAddrName)'"]
    if {$addrID == ""} {
        set addrID ''
    }
    set shipTypeID [db eval "SELECT ShipmentType_ID FROM ShipmentTypes WHERE ShipmentType='$disttype(shipType)'"]
    
    
    if {$disttype(id) == ""} {
        ${log}::notice $disttype(distName) doesn't exist in db, adding...
        #db eval "INSERT INTO DistributionTypes (DistTypeName, DistType_Status, DistType_Summarize, DistType_SingleEntry, DistType_AddrNameID, DistType_ShipTypeID)
        #            VALUES ('$disttype(distName)', '$disttype(status)', '$disttype(summarize)', '$disttype(singleEntry)', '$addrID', '$shipTypeID')"
    
        # TABLE: DistributionTypes
        db eval "INSERT INTO DistributionTypes (DistTypeName, DistType_Status, DistType_ShipTypeID)
                    VALUES ('$disttype(distName)', '$disttype(status)', '$shipTypeID')"
                    
        # TABLE: RptActions
        foreach val {export report} {
            foreach entry {AddrName singleEntry}
                if {$val eq "export"} {
                    db eval "INSERT INTO RptActions (RptAction, RptMethod, DistributionTypeID, MasterAddrID)
                       VALUES ('$)"
                } else {
                    db eval "INSERT INTO RptActions (RptAction, RptMethod, DistributionTypeID, MasterAddrID)
                       VALUES ('$)"
                }
        }        
        
    } else {
        ${log}::notice $disttype(distName) exists in db, updating...
        db eval "UPDATE DistributionTypes SET DistTypeName='$disttype(distName)', DistType_Status=$disttype(status), DistType_Summarize=$disttype(summarize), DistType_SingleEntry=$disttype(singleEntry), DistType_AddrNameID=$addrID, DistType_ShipTypeID=$shipTypeID
                                        WHERE DistributionType_ID=$disttype(id)"
       
        # Update the DistributionTypeCarriers
        db eval "DELETE FROM DistributionTypeCarriers WHERE DistributionTypeID=$disttype(id)"
        
        if {[info exists carrierList]} {unset carrierList}
        if {$disttype(carriers) != ""} {
            foreach carrier $disttype(carriers) {
                    lappend carrierList '$carrier'
            }
            ${log}::debug carrierList: $carrierList
            
            set carrier_id [db eval "SELECT Carrier_ID FROM Carriers WHERE Name IN ([join $carrierList ,])"]
            
            foreach id $carrier_id {
                lappend insertCarrierID "($disttype(id), $id)"
            }
            db eval "INSERT INTO DistributionTypeCarriers (DistributionTypeID, CarrierID)
                                VALUES [join $insertCarrierID ,]"
        }
    }
    
    # Delete all data in tablelist; then repopulate it.

    $tbl delete 0 end
    eAssistSetup::populateDistTypeWidget $tbl
    
    destroy $win
    
} ;# ea::db::writeDistTypeSetup


proc eAssistSetup::populateDistTypeWidget {wid} {
    #****if* populateDistTypeWidget/eAssistSetup
    # CREATION DATE
    #   07/29/2015 (Wednesday Jul 29)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   Populates the main tablelist widget with the Distribution Type information
    #   
    #***
    global log
    
    # Make sure table is empty
    $wid delete 0 end
    
    # Query db, and populate table
    db eval "SELECT DistTypeName, DistType_Status, ShipmentTypes.ShipmentType AS ShipTypeName FROM DistributionTypes 
                LEFT JOIN ShipmentTypes
                    ON DistributionTypes.DistType_ShipTypeID = ShipmentTypes.ShipmentType_ID" {
                        $wid insert end [list "" $DistTypeName $ShipTypeName $DistType_Status]
    }
    
} ;# eAssistSetup::populateDistTypeWidget <wid>

proc eAssist::getDistributionTypeID {tbl lbox} {
    #****if* getDistributionTypeID/eAssist
    # CREATION DATE
    #   07/29/2015 (Wednesday Jul 29)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   Retrieves the db ID of the current selection; then populates the widgets
    #   
    #***
    global log disttype

    # Get id
    set row_id [$tbl curselection]
    set row_data [$tbl get [$tbl curselection]]
    set distName [join [lindex $row_data 1]]
    set disttype(distName) $distName
    
    #${log}::debug row_id: $row_id
    #${log}::debug row_data: $row_data
    #${log}::debug distName: $distName
    #${log}::debug DB DistName: [db eval "SELECT * FROM DistributionTypes WHERE DistTypeName = '$distName'"]
    
    catch {db eval "SELECT DistributionTypes.DistributionType_ID as DistributionType_ID,
                            DistributionTypes.DistTypeName as DistTypeName,
                            DistributionTypes.DistType_Status as DistType_Status,
                            RptActions.RptAction as RptAction, 
                            RptMethod.RptMethod as RptMethod,
                            ShipmentTypes.ShipmentType as ShipmentType,
                            MasterAddresses.MasterAddr_Company as Company FROM RptConfig
                        INNER JOIN DistributionTypes ON DistributionTypeID = DistributionType_ID
                        INNER JOIN ShipmentTypes ON ShipmentTypes.ShipmentType_ID = DistributionTypes.DistType_ShipTypeID
                        INNER JOIN RptActions ON RptActionID = RptAction_ID
                        INNER JOIN RptMethod ON RptMethodID = RptMethod_ID
                        LEFT JOIN RptAddresses ON RptConfig_ID = RptConfigID
                        LEFT JOIN MasterAddresses ON RptAddresses.MasterAddrID = MasterAddresses.MasterAddr_ID
                    WHERE DistTypeName = '$distName'" {
                                        set disttype(id) $DistributionType_ID
                                        set disttype(distName) $DistTypeName
                                        set disttype(status) $DistType_Status
                                        set disttype(shipType) $ShipmentType
                                        
                                        switch -nocase $RptAction {
                                                "Summarize" {
                                                    set disttype(rpt,summarize) 1
                                                }
                                                "Single Entry" {
                                                    if {$RptMethod eq "Report"} {
                                                        set disttype(rpt,singleEntry) 1
                                                    } else {
                                                        set disttype(expt,singleEntry) 1
                                                    }
                                                }
                                                "Address" {
                                                    if {$RptMethod eq "Report"} {
                                                        set disttype(rpt,AddrName) $Company
                                                        } else {
                                                            set disttype(expt,AddrName) $Company
                                                        }
                                                }
                                                default {
                                                    ${log}::critical [info level 1] Invalid argument for switch. $RptAction
                                                }
                                        }
                        set gateway 1
                    }
    }
        if {[info exists gateway]} {
            # Get the assigned carrier names and insert into the listbox ...
            db eval "SELECT Carriers.Name as Name FROM DistributionTypeCarriers
                INNER JOIN Carriers ON CarrierID = Carriers.Carrier_ID
                WHERE DistributionTypeID = $disttype(id)" {
                    $lbox insert end $Name
                }
        }


} ;# eAssist::getDistributionTypeID

proc eAssist::deleteDistributionTypeCarrier {lbox} {
    #****if* deleteDistributionTypeCarrier/eAssist
    # CREATION DATE
    #   07/29/2015 (Wednesday Jul 29)
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
    global log

    #$lbox delete 0 end
    ${log}::debug selection: [$lbox curselection]
    $lbox delete [$lbox curselection]
} ;# eAssist::deleteDistributionTypeCarrier
