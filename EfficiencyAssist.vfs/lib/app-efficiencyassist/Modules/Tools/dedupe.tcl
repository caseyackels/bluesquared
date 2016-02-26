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
        #set Attention [lindex $item 1]
        #set Address1 [lindex $item 2]
        $job(db,Name) eval "SELECT Company, Attention, Address1, SysAddresses_ID, [join "$mode (History.HistDate)" ""] as hdate, [join "$mode (History.HistTime)" ""] as htime FROM Addresses
                                INNER JOIN History ON History.History_ID = Addresses.HistoryID
                                WHERE Company='$Company'
                                    AND SysActive=1" {
                                        lappend results '$SysAddresses_ID'
                                        #${log}::debug ID: $hdate, $SysAddresses_ID, $Company, $Attention, $Address1
                                    }
    }
    return $results
} ;# ea::dedupe::getExistingAddresses

proc ea::dedupe::exactMatch {args} {
    #****if* exactMatch/ea::dedupe
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
    #   accepts a list of columns from table:Addresses to do exact matching on
    #   
    #***
    global log job

    # The column names here are what we are looking at to tell if we have dupes or not.
    #  *CAUTION* if an address is a near dupe, but has additional data in a column that isn't looked at, we will not know it!
    #foreach var $args {
    #    lappend varList \$$var
    #}
    
    # Capture distinct entries that occur more than once.
    ##set args {Company Attention Address1 City State Zip}
    $job(db,Name) eval "SELECT DISTINCT [join "$args count(*)" ,] FROM Addresses
                            INNER JOIN History on History.History_ID = Addresses.HistoryID
                            GROUP BY Company
                            HAVING COUNT(*) > 1" {
                                lappend allAddresses $Company
                            }
                            
    if {![info exists allAddresses]} {return} ;# We don't have any records that occured more than once
                            
    foreach co $allAddresses {
        set remove_records [list [$job(db,Name) eval "SELECT SysAddresses_ID FROM Addresses
                                INNER JOIN History on History.History_ID = Addresses.HistoryID
                                WHERE Company = [join '$co']
                                ORDER BY History.HistDate, History.HistTime"]]

        set removeRecord [lrange [join $remove_records] 1 end]
        if {$removeRecord ne ""} {
           ${log}::debug "Remove Record: $removeRecord"
           lappend remove_SysAddresses $removeRecord
        }
        
        set keepRecord [lrange [join $remove_records] 0 0]
        if {$keepRecord ne ""} {
            ${log}::debug "Keep Record: $keepRecord"
            lappend keep_SysAddresses $keepRecord
        }
    }
    
    # Surround all entries with single quotes
    foreach id [join $remove_SysAddresses] {
        lappend new_remove_SysAddresses '$id'
    }
    
    foreach id [join $keep_SysAddresses] {
        lappend new_keep_SysAddresses '$id'
    }
    
    # We didn't detect any dupes (probably 1st import)
    if {[string match $remove_SysAddresses $keep_SysAddresses] == 1} {return}

    # Get list of ShippingOrder id's where the dupes are listed
    set shipOrderID [join [$job(db,Name) eval "SELECT ShippingOrder_ID FROM ShippingOrders
                                                WHERE AddressID IN ([join $new_remove_SysAddresses ,])
                                                AND JobInformationID = '$job(Number)'"] ,]
    
    foreach ins $new_keep_SysAddresses del $new_remove_SysAddresses {
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
    #${log}::debug Deleting record: DELETE FROM Addresses WHERE SysAddresses_ID IN ([join $new_remove_SysAddresses ,])
    $job(db,Name) eval "DELETE FROM Addresses WHERE SysAddresses_ID IN ([join $new_remove_SysAddresses ,])"
    
    # Copy default fields ...
    # Create 'default column names' and place in HeaderParent array
    
    unset remove_SysAddresses
    unset new_remove_SysAddresses
    unset keep_SysAddresses
    unset new_keep_SysAddresses
    
    unset allAddresses
    unset caseStatement
    
    #ea::code::bm::writeHiddenShipment $shipOrder(DistributionType)
} ;# ea::dedupe::exactMatch Company Attention Address1 Address2 City State Zip
