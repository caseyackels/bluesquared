# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 7/27/2015

proc eAssistSetup::populateDistTypeAddresses {wid} {
    set values [db eval "SELECT MasterAddr_Company FROM MasterAddresses
                            WHERE MasterAddr_Active = 1
                            AND MasterAddr_Internal = 1"]
    $wid configure -values $values
}


proc eAssistSetup::populateShipViaDistType {wid} {
    #****if* populateShipViaDistType/eAssistSetup
    # CREATION DATE
    #   09/09/2015 (Wednesday Sep 09)
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
    global log disttype

    if {$disttype(shipType) ne ""} {
        set shipViaList [db eval "SELECT ShipViaName FROM ShipVia WHERE ShipmentType = '$disttype(shipType)' ORDER BY ShipViaName"]
    } else {
        set shipViaList [db eval "SELECT ShipViaName FROM ShipVia ORDER BY ShipViaName"]
    }
    ${log}::debug dropdown: $wid
    $wid configure -values $shipViaList
} ;# eAssistSetup::populateShipViaDistType


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
    #   * ShipmentTypes - Contains the "Small Package, Truck, -All-" values. Currently this is not user editable (8/6/2015)
    #
    # SEE ALSO
    #   ea::db::writeRptConfig
    #***
    global log disttype
    
    set disttype(carriers) [$lbox get 0 end]
    #${log}::debug Carriers: $lbox - [$lbox get 0 end]
    
    #set addrID [db eval "SELECT MasterAddr_ID from MasterAddresses WHERE MasterAddr_Company='$disttype(useAddrName)'"]
    #if {$addrID == ""} {
    #    set addrID ''
    #}
    set shipTypeID [db eval "SELECT ShipmentType_ID FROM ShipmentTypes WHERE ShipmentType='$disttype(shipType)'"]
    
    
    if {$disttype(id) == ""} {
        ##
        ## - Inserting new data
        ## 
        ${log}::notice $disttype(distName) doesn't exist in db, adding...
    
        # TABLE: DistributionTypes
        db eval "INSERT INTO DistributionTypes (DistTypeName, DistType_Status, DistType_ShipTypeID)
                    VALUES ('$disttype(distName)', '$disttype(status)', '$shipTypeID')"
        
        set disttype(id) [db last_insert_rowid]
        if {$disttype(carriers) != ""} {
            foreach carrier $disttype(carriers) {
                    lappend carrierList '$carrier'
            }
            #${log}::debug carrierList: $carrierList
            #set carrier_id [db eval "SELECT Carrier_ID FROM Carriers WHERE Name IN ([join $carrierList ,])"]
            db eval "SELECT ShipViaName, ShipVia_ID, CarrierID FROM ShipVia 
                                        INNER JOIN Carriers ON Carrier_ID = CarrierID
                                    WHERE Carriers.Name IN ([join $carrierList ,])" {
                                        lappend insertCarrierID "($disttype(id), $CarrierID, $ShipVia_ID)"
                                    }
            
            #foreach id $carrier_id {
            #    lappend insertCarrierID "($disttype(id), $id)"
            #}
            db eval "INSERT INTO DistributionTypeCarriers (DistributionTypeID, CarrierID, ShipViaID)
                                VALUES [join $insertCarrierID ,]"
            ${log}::notice [mc "SETUP:DistributionTypes - Reassigned Carriers to $disttype(distName)"]
            
            # Clean up
            unset carrierList
            unset insertCarrierID
        }
        
    } else {
        ##
        ## Updating existing data
        ##
        
        ## -- Table DistributionTypes
        ${log}::notice $disttype(distName) exists in db, updating...
        db eval "UPDATE DistributionTypes SET DistTypeName='$disttype(distName)',
                                                DistType_Status=$disttype(status),
                                                DistType_ShipTypeID=$shipTypeID
                                        WHERE DistributionType_ID=$disttype(id)"
       
        ## -- Table DistributionTypeCarriers
        # Remove all carriers from the DB, and re-add them. This prevents us from having to keep track.
        db eval "DELETE FROM DistributionTypeCarriers WHERE DistributionTypeID=$disttype(id)"
        ${log}::notice [mc "SETUP:DistributionTypes - Removed carriers associated with $disttype(distName)"]
        
        if {$disttype(carriers) != ""} {
            foreach carrier $disttype(carriers) {
                    lappend carrierList '$carrier'
            }
            #${log}::debug carrierList: $carrierList
            #set carrier_id [db eval "SELECT Carrier_ID FROM Carriers WHERE Name IN ([join $carrierList ,])"]
            db eval "SELECT ShipViaName, ShipVia_ID, CarrierID FROM ShipVia 
                                        INNER JOIN Carriers ON Carrier_ID = CarrierID
                                    WHERE Carriers.Name IN ([join $carrierList ,])" {
                                        lappend insertCarrierID "($disttype(id), $CarrierID, $ShipVia_ID)"
                                    }
            
            #foreach id $carrier_id {
            #    lappend insertCarrierID "($disttype(id), $id)"
            #}
            db eval "INSERT INTO DistributionTypeCarriers (DistributionTypeID, CarrierID, ShipViaID)
                                VALUES [join $insertCarrierID ,]"
            ${log}::notice [mc "SETUP:DistributionTypes - Reassigned Carriers to $disttype(distName)"]
            
            # Clean up
            unset carrierList
            unset insertCarrierID
        }
    }
    
    ## -- Table RptConfig
    # Add values
    ea::db::writeRptConfig
    
    # Delete all data in tablelist; then repopulate it.
    # 9.8.15 this should be removed and only the rowID should be deleted, then reinserted
    $tbl delete 0 end
    eAssistSetup::populateDistTypeWidget $tbl
    
    destroy $win
    
} ;# ea::db::writeDistTypeSetup

proc ea::db::writeRptConfig {} {
    #****if* writeRptConfig/ea::db
    # CREATION DATE
    #   08/06/2015 (Thursday Aug 06)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   DB Tables:
    #   * RptMethod -
    #   * RptActions -
    #   * RptConfig
    #   
    #***
    global log disttype

    set addRptAddress 0
    set addExptAddress 0
    
        # Get Action id's
        db eval "SELECT RptAction_ID, RptMethod.RptMethod as RptMethod, RptActions.RptAction as RptAction FROM RptActions
            INNER JOIN RptMethod ON RptMethod.RptMethod_ID = RptActions.RptMethodID" {
                # RptMethod, RptAction
                # Report, Summarize
                # Report, Single Entry
                # Export, Single Entry
                # Export, Default
                # Report, Default

                # Set the exports
                if {[string tolower $RptMethod] eq "export" && [string tolower $RptAction] eq "single entry"} {
                    set exptSingleEntryID $RptAction_ID
                }
                
                if {[string tolower $RptMethod] eq "export" && [string tolower $RptAction] eq "default"} {
                    set exptDefaultID $RptAction_ID
                }
                
                # Set the reports
                if {[string tolower $RptMethod] eq "report" && [string tolower $RptAction] eq "single entry"} {
                    set rptSingleEntryID $RptAction_ID
                }
                
                if {[string tolower $RptMethod] eq "report" && [string tolower $RptAction] eq "summarize"} {
                    set rptSummarizeID $RptAction_ID   
                }
                
                if {[string tolower $RptMethod] eq "report" && [string tolower $RptAction] eq "default"} {
                    set rptDefaultID $RptAction_ID
                }
        }
        
        # Check constraints ...
        ## Exports
        # AddrName = Name of internal company (JG Mailing, JG Bindery, etc)
        # singleEntry = 1 or 0
        
        # AddrName and singleEntry contain data
        if {$disttype(expt,AddrName) != "" && $disttype(expt,singleEntry) != 0 && $disttype(expt,shipVia) != ""} {
            lappend RptActionValue "($disttype(id), $exptSingleEntryID)"
            set addExptAddress 1
            ${log}::debug EXPORTS: Address and Checkbutton contain data: $disttype(expt,AddrName), $disttype(expt,singleEntry) $disttype(expt,shipVia)
        }
        
        # AddrName and singleEntry are both blank
        if {$disttype(expt,AddrName) == "" && $disttype(expt,singleEntry) == 0 && $disttype(expt,shipVia) == ""} {
            #lappend RptActionValue "($disttype(id), $exptSingleEntryID)"
            lappend RptActionValue "($disttype(id), $exptDefaultID)"
            ${log}::debug EXPORTS: Address and Checkbutton are blank: $disttype(expt,AddrName), $disttype(expt,singleEntry)
        }
        
        ## Reporting
        # contain data
        if {$disttype(rpt,AddrName) != "" && $disttype(rpt,singleEntry) != 0} {
            lappend RptActionValue "($disttype(id), $rptSingleEntryID)"
            set addRptAddress 1
            ${log}::debug REPORTS: Address and Checkbutton contain data: $disttype(rpt,AddrName), $disttype(rpt,singleEntry)
        }
        
        # blank
        if {$disttype(rpt,AddrName) == "" && $disttype(rpt,singleEntry) == 0} {
            #lappend RptActionValue "($disttype(id), $rptSingleEntryID)"
            lappend RptActionValue "($disttype(id), $rptDefaultID)"
            ${log}::debug REPORTS: Address and Checkbutton are blank: $disttype(rpt,AddrName), $disttype(rpt,singleEntry)
        }
        
        if {$disttype(rpt,summarize) == 1} {
            lappend RptActionValue "($disttype(id), $rptSummarizeID)"
            ${log}::debug REPORTS: Summarize is enabled: $disttype(rpt,summarize)
        }

        # TABLE: RptConfig
        # Remove data, if it doesn't exist the db won't complain.
        db eval "DELETE FROM RptConfig WHERE DistributionTypeID=$disttype(id)"
        ${log}::notice [mc "SETUP:DistributionTypes - Removed Distribution Type configurations associated with $disttype(distName)"]
        
        # Make sure the RptActionValue exists; if it doesn't, we don't issue an INSERT statement
        # 9/9/2015 RptActionValue should now always be filled out.
        if {[info exists RptActionValue]} {
            db eval "INSERT INTO RptConfig (DistributionTypeID, RptActionsID) VALUES [join $RptActionValue ,]"
            ${log}::notice [mc "SETUP:DistributionTypes - Reassigned configurations to $disttype(distName)"]
            
            # Add Report Address
            if {$addRptAddress == 1} {
                # Get RptConfig ID
                set rptConfigID [db eval "SELECT RptConfig_ID FROM RptConfig
                                            WHERE DistributionTypeID = $disttype(id)
                                                AND RptActionsID = $rptSingleEntryID"]
                # Get Address ID
                set masterAddrID [db eval "SELECT MasterAddr_ID FROM MasterAddresses
                                                WHERE MasterAddr_Company = '$disttype(rpt,AddrName)'"]
                
                
                # Delete existing entries
                db eval "DELETE FROM RptAddresses WHERE RptConfigID = (SELECT RptConfigID FROM RptAddresses
                                                                        INNER JOIN RptConfig on RptConfigID = RptConfig.RptConfig_ID
                                                                            WHERE RptConfig.DistributionTypeID = $disttype(id))"
                # Insert into RptAddresses
                db eval "INSERT INTO RptAddresses (RptConfigID, MasterAddrID) VALUES ($rptConfigID, $masterAddrID)"
            }
            
            # Add Export Address
            if {$addExptAddress == 1} {
                # Get RptConfig id
                set rptConfigID [db eval "SELECT RptConfig_ID FROM RptConfig
                                            WHERE DistributionTypeID = $disttype(id)
                                                AND RptActionsID = $exptSingleEntryID"]
                # Get Address ID
                set masterAddrID [db eval "SELECT MasterAddr_ID FROM MasterAddresses
                                                WHERE MasterAddr_Company = '$disttype(expt,AddrName)'"]
                # Get shipvia ID
                set shipviaID [db eval "SELECT ShipVia_ID FROM ShipVia WHERE ShipViaName = '$disttype(expt,shipVia)'"]
                
                # Delete existing entries
                db eval "DELETE FROM RptAddresses WHERE RptConfigID = (SELECT RptConfigID FROM RptAddresses
                                                                        INNER JOIN RptConfig on RptConfigID = RptConfig.RptConfig_ID
                                                                            WHERE RptConfig.DistributionTypeID = $disttype(id))"
                # Insert into RptAddresses
                db eval "INSERT INTO RptAddresses (RptConfigID, MasterAddrID, ShipViaID) VALUES ($rptConfigID, $masterAddrID, $shipviaID)"
            }
            # Clean up
            unset RptActionValue
        }
        

} ;# ea::db::writeRptConfig


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

proc eAssistSetup::getDistributionTypeID {tbl lbox} {
    #****if* getDistributionTypeID/eAssistSetup
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
    ${log}::debug Launched getDistributionTypeID

    # Get id
    set row_id [$tbl curselection]
    set row_data [$tbl get [$tbl curselection]]
    set distName [join [lindex $row_data 1]]
    set disttype(distName) $distName
    
    ${log}::debug row_id: $row_id
    ${log}::debug row_data: $row_data
    ${log}::debug distName: $distName
    #${log}::debug DistType Name: [db eval "SELECT DistTypeName FROM DistributionTypes WHERE DistTypeName = '$distName'"]
    set disttype(id) [db eval "SELECT DistributionType_ID FROM DistributionTypes WHERE DistTypeName = '$disttype(distName)'"]
    ${log}::debug DistType ID: $disttype(id)
    
    set disttype(status) [db eval "SELECT DistType_Status FROM DistributionTypes WHERE DistTypeName = '$disttype(distName)'"]
    ${log}::debug DistType Status: $disttype(status)
    
    set disttype(shipType) [join [db eval "SELECT ShipmentTypes.ShipmentType FROM DistributionTypes 
                                                    INNER JOIN ShipmentTypes on ShipmentTypes.ShipmentType_ID = DistributionTypes.DistType_ShipTypeID
                                                WHERE DistTypeName = '$disttype(distName)'"]]
    ${log}::debug DistType ShipType: $disttype(shipType)
    
    #set disttype(RptActions) [db eval "SELECT RptMethod.RptMethod, RptActions.RptAction FROM RptConfig
    #                                        INNER JOIN DistributionTypes on DistributionTypes.DistributionType_ID = RptConfig.DistributionTypeID
    #                                        INNER JOIN RptActions on RptActions.RptAction_ID = RptConfig.RptActionsID
    #                                        INNER JOIN RptMethod on RptMethod.RptMethod_ID = RptActions.RptMethodID
    #                                            WHERE DistributionTypes.DistTypeName = '$distName'"]
    
    set disttype(RptActions) [db eval "SELECT RptMethod.RptMethod, RptActions.RptAction FROM RptConfig
                                        INNER JOIN DistributionTypes ON DistributionTypeID = DistributionType_ID
                                        INNER JOIN ShipmentTypes ON ShipmentTypes.ShipmentType_ID = DistributionTypes.DistType_ShipTypeID
                                        INNER JOIN RptActions ON RptActionsID = RptAction_ID
                                        INNER JOIN RptMethod ON RptMethodID = RptMethod_ID
                                        --LEFT JOIN ShipVia ON RptAddresses.ShipViaID = ShipVia.ShipVia_ID
                                        --LEFT JOIN RptAddresses ON RptConfig_ID = RptConfigID
                                        --LEFT JOIN MasterAddresses ON RptAddresses.MasterAddrID = MasterAddresses.MasterAddr_ID
                                                WHERE DistributionTypes.DistTypeName = '$disttype(distName)'"]
    
    set disttype(CompanyShipVia) [db eval "SELECT MasterAddresses.MasterAddr_Company, ShipVia.ShipViaName FROM RptConfig
                                            INNER JOIN DistributionTypes ON DistributionTypeID = DistributionType_ID
                                            INNER JOIN ShipmentTypes ON ShipmentTypes.ShipmentType_ID = DistributionTypes.DistType_ShipTypeID
                                            INNER JOIN RptActions ON RptActionsID = RptAction_ID
                                            INNER JOIN RptMethod ON RptMethodID = RptMethod_ID
                                            INNER JOIN ShipVia ON RptAddresses.ShipViaID = ShipVia.ShipVia_ID
                                            LEFT JOIN RptAddresses ON RptConfig_ID = RptConfigID
                                            LEFT JOIN MasterAddresses ON RptAddresses.MasterAddrID = MasterAddresses.MasterAddr_ID
                                                    WHERE DistributionTypes.DistTypeName = '$disttype(distName)'"]
    
    ${log}::debug RptActions: $disttype(RptActions)
    
    foreach {RptMethod RptAction} $disttype(RptActions) {
        switch -nocase $RptAction {
            "Summarize" {set disttype(rpt,summarize) 1}
            "Single Entry" {
                set Company [lindex $disttype(CompanyShipVia) 0]
                set ShipViaName [lindex $disttype(CompanyShipVia) 1]
                
                if {[string tolower $RptMethod] eq "report"} {
                    set disttype(rpt,singleEntry) 1
                    set disttype(rpt,AddrName) $Company
                } else {
                    set disttype(expt,singleEntry) 1
                    set disttype(expt,AddrName) $Company
                    set disttype(expt,shipVia) $ShipViaName
                }
            }
            default {
                ${log}::notice [info level 1] RptAction isn't setup, default is 'default': $RptAction}
        }
    }
    # If we don't have an entry in the Table: RptConfig, but we do in DistributionTypes, we will receive an error.
    # Get the assigned carrier names and insert into the listbox ...
        db eval "SELECT distinct(Carriers.Name) as Name FROM DistributionTypeCarriers
            INNER JOIN Carriers ON CarrierID = Carriers.Carrier_ID
            WHERE DistributionTypeID = $disttype(id)" {
                $lbox insert end $Name
            }


} ;# eAssistSetup::getDistributionTypeID

proc eAssistSetup::deleteDistributionTypeCarrier {lbox} {
    #****if* deleteDistributionTypeCarrier/eAssistSetup
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
} ;# eAssistSetup::deleteDistributionTypeCarrier
