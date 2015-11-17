# Creator: Casey Ackels
# File Initial Date: 11 04,2015

proc ea::code::publish::Publish {args} {
    #****if* Publish/ea::code::publish
    # CREATION DATE
    #   11/04/2015 (Wednesday Nov 04)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   Master proc for publishing
    #   1. Populates the Published table
    #   2. Exports Planner and Process Shipper Files into Job's Folder and Smartlink UPS Files folder
    #   3. Creates Excel Report into Job's Folder
    #   4. Issues any email events
    #***
    global log job
    
    # 0.0 Insert the hidden 'rolled up' entries (this is set on the Distribution Type Setup page)
    ea::code::publish::addHiddenShipments

    # 1.0 Populate Published table in the title database
    set rev [ea::db::publish::addToPublishedTbl]
    
    # 2.0 Export Planner file
    ea::code::export::toPlanner
    
    # 2.1 Export 'import' distribution types. This can be any number of files; determined by date, and distribution type.
    ea::code::export::toProcessShipper
    
    # 3. Create Excel Report
    ea::code::reports::writeExcel $rev
    
    # 4. email events

} ;# ea::code::publish::Publish

proc ea::db::publish::addToPublishedTbl {{PublishNote ""}} {
    #****if* addToPublishedTbl/ea::code::publish
    # CREATION DATE
    #   11/04/2015 (Wednesday Nov 04)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   ea::db::publish::addToPublishedTbl ?<notes>?
    #   Returns the Publish ID
    #   
    #***
    global log job

    set id [job::db::SetNotes -HistNote Publishing -NoteType Publish -Note $PublishNote]
    
    # Get max published id; if blank we start at 1, if not we increment by 1
    set publish_id [join [$job(db,Name) eval "SELECT max(PublishedRev) from Published
                                                WHERE JobInformationID = '$job(Number)'"]]
    
    if {$publish_id ne ""} {
        incr publish_id
    } else {
        set publish_id 1
    }
    
    # Insert into Published table
    $job(db,Name) eval "INSERT INTO Published (NotesID, JobInformationID, PublishedRev)
                            VALUES ($id, '$job(Number)', $publish_id)"
    

    return $publish_id
    
} ;# ea::code::publish::addToPublishedTbl

proc ea::code::publish::addHiddenShipments {} {
    #****if* addHiddenShipments/ea::code::publish
    # CREATION DATE
    #   11/16/2015 (Monday Nov 16)
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
    
    # Retrieve all used distribution types
    set distTypes [$job(db,Name) eval "SELECT DISTINCT Addresses.DistributionType FROM ShippingOrders
                                            INNER JOIN Addresses on Addresses.SysAddresses_ID = ShippingOrders.AddressID
                                            WHERE Addresses.SysActive = 1
                                            AND ShippingOrders.Hidden = 0
                                            AND JobInformationID IN ('$job(Number)')"]

    if {$distTypes ne ""} {
        foreach item $distTypes {
            ${log}::debug Writing to $item
            ea::code::bm::writeHiddenShipment $item
        }
    }

    
} ;# ea::code::publish::addHiddenShipments
