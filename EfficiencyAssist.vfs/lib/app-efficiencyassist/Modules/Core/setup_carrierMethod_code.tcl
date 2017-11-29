# Creator: Casey Ackels
# Initial Date: February 2, 2014]
# File Initial Date: Feb 2,2014
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 169 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2015-03-06 09:25:48 -0800 (Fri, 06 Mar 2015) $
#
########################################################################################

##
## - Overview
# Overview

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

proc eAssistSetup::controlCarrierSetup {{modify add} {entryPath ""} {lboxPath ""} args} {
    #****f* controlCarrierSetup/eAssistSetup
    # CREATION DATE
    #   10/28/2014 (Tuesday Oct 28)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::controlCarrierSetup <add|delete> <widgetPath> -columnNames <value> -table <value> 
    #
    # FUNCTION
    #	This is a wrapper around a few other procs; that can control/edit the entries in the CarrierSetup window
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
    global log
    
    if {$entryPath eq "" || $lboxPath eq ""} {return -errorcode 1 "Must have path to widget"}

    foreach {key value} $args {
        switch -- $key {
            -columnNames    {set cols $value}
            -table          {set dbTable $value}
        }
    }
    
    
    switch -- $modify {
        add     { if {[$entryPath get] eq ""} {return}
                    set data [list [$entryPath get]]; $entryPath delete 0 end
                    #ADD/MODIFY to db
                    #${log}::debug dbInsert -columnNames $cols -table $dbTable -data $data
                    eAssist_db::dbInsert -columnNames $cols -table $dbTable -data $data
        }
        delete  { if {[$lboxPath curselection] eq ""} {return}
                    set data [$lboxPath get [$lboxPath curselection]]
                    #DELETE from DB
                    #${log}::debug delete $dbTable $cols $data
                    eAssist_db::delete $dbTable $cols $data
                }
        query  {}
        default {${log}::debug [info level 1] $modify is unknown}
    }
    



    #READ from DB
    $lboxPath delete 0 end
    #${log}::debug $lboxPath insert end [eAssist_db::dbSelectQuery -columnNames $cols -table $dbTable]
    #$lboxPath insert end [set list [eAssist_db::dbSelectQuery -columnNames $cols -table $dbTable]]
    foreach record [eAssist_db::dbSelectQuery -columnNames $cols -table $dbTable] {
        $lboxPath insert end $record
    }
     

    
} ;# eAssistSetup::controlCarrierSetup


proc eAssistSetup::addCarrierSetup {varType entryField listBox} {
    #****f* addCarrierSetup/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Add values to listbox
    #	entryField = Path to widget
    #   listBox = Path to widget
    #   Type = what it is, for the switch to work correctly
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
    #   THis could be refactored into [eAssistSetup::addToIntlListbox] and [eAssistSetup::removeFromIntlListbox]
    #
    # SEE ALSO
    #
    #***
    global log carrierSetup
    ${log}::debug --START-- [info level 1]
    
    ${log}::debug Adding $varType, $entryField, $listBox
    
    if {[$entryField get] == ""} {return}

    switch -- $varType {
            PAYMENT     {
                        set entryValue $carrierSetup(enterPaymentType)
                        set newVarType PaymentType
                        ${log}::debug PAYMENT - $entryField
            }
            SHIPMENT    {
                        set entryValue $carrierSetup(enterShipmentType)
                        set newVarType ShipmentType
                        ${log}::debug SHIPMENT - $entryField
            }
            CARRIERS    {
                        set entryValue $carrierSetup(enterCarrier)
                        set newVarType CarrierList
                        ${log}::debug CARRIERS - $entryField
            }
            RATES       {
                        set entryValue $carrierSetup(enterRateType)
                        set newVarType RateType
                        ${log}::debug RATES - $entryField
            }
            SHIPPINGCLASS {
                        set entryValue $carrierSetup(enterShippingClass)
                        set newVarType ShippingClass
                        ${log}::debug SHIPPINGCLASS - $entryField
            }
            default     {
                        ${log}::debug Nothing set for this SWITCH command
            }
    }

    ${log}::debug Adding _ $entryField _ to $newVarType Listbox
    
    $listBox insert end $entryValue
    $entryField delete 0 end
    
    
    
    set carrierSetup($newVarType) [$listBox get 0 end]
    ${log}::debug $newVarType _ADD: [$listBox get 0 end]
    
	
    ${log}::debug --END-- [info level 1]
} ;# eAssistSetup::addCarrierSetup


proc eAssistSetup::delCarrierSetup {varType listBox} {
    #****f* delCarrierSetup/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Delete selected items from listbox
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
    global log carrierSetup
    ${log}::debug --START-- [info level 1]
    
    if {[$listBox curselection] == ""} {return}   
    
    switch -- $varType {
            PAYMENT     {
                        set newVarType PaymentType
            }
            SHIPMENT    {
                        set newVarType ShipmentType
            }
            CARRIERS    {
                        #set newVarType CarrierList
                        set tbl Carriers
                        set col Name
            }
            RATES       {
                        set newVarType RateType
            }
            SHIPPINGCLASS {
                        set entryValue $carrierSetup(enterShippingClass)
                        set newVarType ShippingClass
                        ${log}::debug SHIPPINGCLASS - $entryField
            }
            default     {
                        ${log}::debug Nothing set for this SWITCH command
            }
    }
    
    # Remove the entry from the DB
    eAssist_db::delete $tbl $col [$listBox curselection]
    
    # ... then remove it from the list box
    $listBox delete [$listBox curselection]
    #set carrierSetup($newVarType) [$listBox get 0 end]
    
	
    ${log}::debug --END-- [info level 1]
} ;# eAssistSetup::delCarrierSetup


proc eAssistSetup::controlShipVia {{control add} args} {
    #****f* controlShipVia/eAssistSetup
    # CREATION DATE
    #   11/06/2014 (Thursday Nov 06)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::controlShipVia args 
    #
    # FUNCTION
    #	Adds/Modifies the ship via configurations
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
    global log
    
    foreach {key value} $args {
        switch -- $key {
            -wid    {set wid $value}
            -tbl    {set tbl $value}
            -dbtbl  {set dbTbl $value}
            -btn    {set btns $value}
        }
    }

    switch -- $control {
        add     {eAssistSetup::addShipVia $wid $tbl}
        delete  {eAssistSetup::deleteShipVia $wid $tbl}
        clear   {eAssistSetup::clearShipVia $wid}
    }
    
    
    # Refresh tbl and reread from db
    #$tbl delete 0 end
    ##set recordList [eAssist_db::dbSelectQuery -columnNames "ShipViaCode ShipViaName CarrierName FreightPayerType ShipmentType" -table ShipVia]
    #db eval "SELECT ShipViaCode, ShipViaName, Carriers.Name AS CarrierName, FreightPayerType, ShipmentType FROM ShipVia INNER JOIN Carriers WHERE ShipVia.CarrierID = Carriers.Carrier_ID ORDER BY ShipViaName" {
    #    #puts "$ShipViaCode $ShipViaName $CarrierName $FreightPayerType $ShipmentType"
    #    $tbl insert end "{} [list $ShipViaCode] [list $ShipViaName] [list $CarrierName] [list $FreightPayerType] [list $ShipmentType]"
    #}
    
    #$tbl insert end "{} $ShipViaCode $ShipViaName $Carriers.Name $FreightPayerType $ShipmentType"
    #$tbl insert end "{} $valueList"
    #foreach record $recordList {
    #    $tbl insert end "{} $record"
    #}
    
    # Make sure the button text says 'add'.
    ea::tools::modifyButton $btns.btn1 -text [mc "Add"]
    ea::tools::modifyButton $btns.btn2 -state disabled
    ea::tools::modifyButton $btns.btn3 -state disabled
    
} ;# eAssistSetup::controlShipVia

proc eAssistSetup::addShipVia {wid tbl} {
    #****f* addShipVia/eAssistSetup
    # CREATION DATE
    #   11/07/2014 (Friday Nov 07)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::addShipVia wid tbl
    #
    # FUNCTION
    #	Adds the values from the entry/comboboxes to the db
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
    global log
    
    foreach var {childList valueList_wid valueList_db} {
        if {[info exists $var]} {unset $var}
    }

    
    foreach child [winfo children $wid] {
        if {[string match -nocase *entry* $child] == 1 || [string match -nocase *cbox* $child] == 1} {
            lappend childList $child 
        }
    }
    
    set childList [lsort $childList]
    #${log}::debug childList: $childList
    

    foreach child $childList {
        if {[$child get] eq ""} {
            #${log}::debug $child is empty!
            #lappend valueList ""
            ${log}::critical Missing a value when adding a new ship via! Widget: $child
            return
        } else {
            #${log}::debug VALUES [$child get]
            if {[string match *01cbox1 $child] == 1} {
                lappend valueList_db '[db eval "SELECT Carrier_ID from Carriers where Name='[$child get]'"]'
                lappend valueList_wid [$child get]
                $child delete 0 end
            } else {
                    lappend valueList_db '[$child get]'
                    lappend valueList_wid [$child get]
                    $child delete 0 end
            }
        }
    }

    #${log}::debug values: $valueList_wid
    ${log}::debug values: $valueList_db
    
    db eval "INSERT OR ABORT INTO ShipVia (CarrierID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType) VALUES ([join $valueList_db ,])"
    
    db eval "SELECT ShipViaCode, ShipViaName, Carriers.Name AS CarrierName, FreightPayerType, ShipmentType
        FROM ShipVia
            INNER JOIN Carriers
        WHERE ShipVia.CarrierID = Carriers.Carrier_ID
            AND ShipViaCode = [lrange $valueList_db 1 1]" {
                ${log}::debug "$ShipViaCode $ShipViaName $CarrierName $FreightPayerType $ShipmentType"
                $tbl insert end "{} [list $ShipViaCode] [list $ShipViaName] [list $CarrierName] [list $FreightPayerType] [list $ShipmentType]"
        }
    
} ;# eAssistSetup::addShipVia

proc eAssistSetup::editShipVia {wid tbl args} {
    #****f* editShipVia/eAssistSetup
    # CREATION DATE
    #   11/07/2014 (Friday Nov 07)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::editShipVia args 
    #
    # FUNCTION
    #	Populates the pertinent comboboxes and entry fields so that we can edit the data
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
    global log tmp
    
    # Make sure all the widgets are cleared out
    eAssistSetup::clearShipVia $wid

    if {[info exists childList]} {unset childList}
    
    foreach child [winfo children $wid] {
        if {[string match -nocase *entry* $child] == 1 || [string match -nocase *cbox* $child] == 1} {
            lappend childList $child 
        }
    }
    
    set childList [lsort $childList]
    set data [lrange [$tbl get [$tbl curselection]] 1 end]
    
    foreach wid $childList value $data {
        $wid insert end $value
    }
    set shipViaCode [lrange $data 0 0]
    
    set tmp(db,rowID) [eAssist_db::getRowID ShipVia ShipViaCode='$shipViaCode']
    
    ${log}::debug shipVia: $shipViaCode
    ${log}::debug rowID: $tmp(db,rowID)
} ;# eAssistSetup::editShipVia


proc eAssistSetup::deleteShipVia {wid tbl} {
    #****f* deleteShipVia/eAssistSetup
    # CREATION DATE
    #   11/07/2014 (Friday Nov 07)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::deleteShipVia args 
    #
    # FUNCTION
    #	Delets the ship via, resets buttons, and clears out the widgets
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
    global log

    set shipViaCode [lrange [$tbl get [$tbl curselection]] 1 1]
    
    eAssist_db::delete ShipVia ShipViaCode $shipViaCode
    
    eAssistSetup::clearShipVia $wid
    
} ;# eAssistSetup::deleteShipVia

proc eAssistSetup::clearShipVia {wid} {
    #****f* clearShipVia/eAssistSetup
    # CREATION DATE
    #   11/07/2014 (Friday Nov 07)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::clearShipVia wid 
    #
    # FUNCTION
    #	Clears the data from the widgets
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
    global log

    foreach child [winfo children $wid] {
        if {[string match -nocase *entry* $child] == 1 || [string match -nocase *cbox* $child] == 1} {
            $child delete 0 end
        }
    }

    
} ;# eAssistSetup::clearShipVia

proc eAssist::addCarrierPkg {carrierListWid packageDescWid tblWid} {
    global log
    
    set carrierName [$carrierListWid get]
    set carrierID [db eval "SELECT Carrier_ID FROM Carriers WHERE Name = '$carrierName'"]
    
    set packageDesc [$packageDescWid get]
    
    
    #${log}::debug UPDATE Carriers SET PackageType = '$packageDesc' WHERE Name = '$carrier'
    ${log}::debug Update record with PackageType
    db eval "UPDATE CarrierPkg SET CarrierPkgDesc = '$packageDesc' WHERE Name = '$carrier'"
    
    ${log}::debug re-populate widget
    eAssist::populateCarrierPkg $carrierListWid $tblWid
}

proc eAssist::populateCarrierPkg {carrierListWid tblWid} {
    global log
    
    #db eval "SELECT Name, PackageType FROM Carriers ORDER BY Name ASC" {
    #    lappend values "{} [list $Name] [list $PackageType]"
    #}
    #
    #foreach item $values {
    #    lappend newVals $item
    #}
    #
    #set newVals [list {"" Advantage ""} {"" "Atam Trucking" ""}]
    
    # Populate the dropdown
    #$carrierListWid configure -values [list [db eval "SELECT Name FROM Carriers"]]
    set carrierName [$carrierListWid get]
    
    set carrierID [db eval "SELECT Carrier_ID FROM Carriers WHERE Name = '$carrierName'"]
    set values [db eval "SELECT CarrierPkgDesc FROM CarrierPkg WHERE CarrierID = $carrierID"]
    
    if {$values ne ""} {
        $carrierListWid delete 0 end
        $carrierListWid insert end $values
    } else {
        ${log}::notice $carrierName currently does not have any packages associated with it
    }
    
    
}