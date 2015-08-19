# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 08 18,2015
# Dependencies: 
#-------------------------------------------------------------------------------

namespace eval ea::dedupe {}

proc ea::dedupe::getExistingAddresses {mode addresses} {
    #****if* getExistingAddresses/ea::dedupe
    # CREATION DATE
    #   08/18/2015 (Tuesday Aug 18)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   Helper Proc / Returns records that match min/max from the history table
    #   Tables:
    #       # History
    #       # Addresses
    #   
    #   
    #***
    global log job

    # Retrieve ID's to remove (update) from the ShippingOrders table
    foreach item $addresses {
        set Company [lindex $item 0]
        set Attention [lindex $item 1]
        set Address1 [lindex $item 2]
        $job(db,Name) eval "SELECT Company, Attention, Address1, SysAddresses_ID, [join "$mode (History.HistDate)" ""] as hdate FROM Addresses
                                INNER JOIN History ON History.History_ID = Addresses.HistoryID
                                WHERE Company='$Company'
                                    AND Attention='$Attention'
                                    AND Address1='$Address1'
                                    AND SysActive=1" {
                                        lappend results '$SysAddresses_ID'
                                        #${log}::debug ID: $hdate, $SysAddresses_ID, $Company, $Attention, $Address1
                                    }
    }
    return $results
} ;# ea::dedupe::getExistingAddresses

proc ea::dedupe::updateAddressIDs {} {
    #****if* updateAddressIDs/ea::dedupe
    # CREATION DATE
    #   08/18/2015 (Tuesday Aug 18)
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

    # The column names here are what we are looking at to tell if we have dupes or not.
    #  *CAUTION* if an address is a near dupe, but has additional data in a column that isn't looked at, we will not know it!
    $job(db,Name) eval "SELECT DISTINCT Company, Attention, Address1 FROM Addresses WHERE SysActive=1" {
        #${log}::debug FIRST $Company, $Attention, $Address1
        lappend allAddresses "[list $Company] [list $Attention] [list $Address1]"
    }
    
    set remove_SysAddresses [ea::dedupe::getExistingAddresses max $allAddresses]
    set insert_SysAddresses [ea::dedupe::getExistingAddresses min $allAddresses]
    unset allAddresses

    # Get list of ShippingOrder id's where the dupes are listed
    set shipOrderID [join [$job(db,Name) eval "SELECT ShippingOrder_ID FROM ShippingOrders
                                                WHERE AddressID IN ([join $remove_SysAddresses ,])
                                                AND JobInformationID = '$job(Number)'"] ,]
    
    foreach ins $insert_SysAddresses del $remove_SysAddresses {
        #${log}::debug Ins/Del: $ins - $del
        lappend caseStatement "WHEN $del THEN $ins"
    }

    # Update good address ID into the ShippingOrders table
    $job(db,Name) eval "UPDATE ShippingOrders
                            SET AddressID = CASE AddressID
                                [join $caseStatement]
                            END
                        WHERE ShippingOrder_ID IN ($shipOrderID)"

    # Delete the duplicates
    #${log}::debug Deleting record: DELETE FROM Addresses WHERE SysAddresses_ID IN ([join $remove_SysAddresses ,])
    $job(db,Name) eval "DELETE FROM Addresses WHERE SysAddresses_ID IN ([join $remove_SysAddresses ,])"
    

    unset remove_SysAddresses
    unset insert_SysAddresses
    unset caseStatement
    
} ;# ea::dedupe::updateAddressIDs
