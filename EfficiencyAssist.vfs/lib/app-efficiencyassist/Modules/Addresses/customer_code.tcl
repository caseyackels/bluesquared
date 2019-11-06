# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 01 06,2015
# Dependencies:
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 169 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2011-10-17 16:11:20 -0700 (Mon, 17 Oct 2011) $
#
########################################################################################

##
## - Overview
# Code for the Customer namespace

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample
#ea::db::customer
proc ea::db::customer::getJobData {} {
    global log job monarch_db

    if {$job(Number) eq ""} {
        # Reset variables if they happen to have previously been filled in??? ??
        return
    }

    if {[string length $job(Number)] < 6} {
            ${log}::notice The job number is less than 5 numbers. Aborting.
            Error_Message::errorMsg BL006
            return
        }

    # set stmt [$monarch_db prepare "SELECT TOP 1 CUSTOMERNAME, TITLENAME, ISSUENAME
    #                                     FROM EA.dbo.Planner_Shipping_View
    #                                     WHERE JOBNAME='$jobNum'"]
    set stmt [$monarch_db prepare "SELECT COMPANYNAME, TITLENAME, ISSUENAME, HAGEN_ID, FIRSTNAME, LASTNAME, EMAILADDRESS
                                        FROM EA.dbo.Customer_Jobs_Issues_CSR
                                        WHERE JOBNAME='$job(Number)'"]

    set res [$stmt execute]

    while {[$res nextlist val]} {
        set job(CustName) [lindex $val 0]
        set job(Title) [string toupper [lindex $val 1]]
        set job(Name) [string toupper [lindex $val 2]]
        set job(CustID) [lindex $val 3]
        set job(CSR,FirstName) [lindex $val 4]
        set job(CSR,LastName) [lindex $val 5]
        set job(CSR,Email) [lindex $val 6]
    }
    set job(CSRName) "$job(CSR,FirstName) $job(CSR,LastName)"

    $stmt close
    set job(Description) "$job(Title) / $job(Name)"
} ;# ea::db::customer::getJobData


#####
##### EVERYTHING BELOW IS OLD OR MAY NOT WORK as of 9/23/2019
#####
proc customer::PopulateShipVia {lbox {custID 0}} {
    #****f* PopulateShipVia/customer
    # CREATION DATE
    #   01/06/2015 (Tuesday Jan 06)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #
    #
    # SYNOPSIS
    #   customer::PopulateShipVia <lbox> ?custID?
    #
    # FUNCTION
    #	Retrieves and displays the ship via codes in the available listbox. If custID is provided, it populates the assigned ship via listbox
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

    ${log}::debug Loading the shipvia's into $lbox
    if {$custID == 0} {
        set shipViaList [lsort [eAssist_db::dbSelectQuery -columnNames ShipViaName -table ShipVia]]
        foreach shipvia $shipViaList {
            $lbox insert end $shipvia
        }
    } elseif { $custID != ""} {
        set preferredShipVia [db eval "SELECT ShipVia.ShipViaName
                                                FROM CustomerShipVia
                                                     INNER JOIN
                                                     ShipVia ON ShipVia.ShipVia_ID = CustomerShipVia.ShipViaID
                                                     WHERE CustomerShipVia.custID = '$custID'"]
        foreach pShipVia $preferredShipVia {
            $lbox insert end $pShipVia
        }

    }
} ;# customer::PopulateShipVia

proc customer::transferToAssigned {lboxFrom lboxTo okBtn} {
    #****f* transferToAssigned/customer
    # CREATION DATE
    #   01/07/2015 (Wednesday Jan 07)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #
    #
    # SYNOPSIS
    #   customer::transferToAssigned lboxFrom lboxTo
    #
    # FUNCTION
    #	Transfer's the selected entries from the Available Ship Via lbox, to the Assigned Ship Via lbox
    #	Guards against duplicates, by using [lsort -unique]. Removes all data from the widget, and reinserts upon adding new ship via's.
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

    set selectedShipVia [$lboxFrom curselection] ;# this is only the index of the selections

    set assignedShipVia [$lboxTo get 0 end]

    # Compile list for selected ship via's
    if {[info exists selectedShipViaList]} {unset selectedShipViaList}
    foreach index $selectedShipVia {
        lappend selectedShipViaList [$lboxFrom get $index]
    }

    # Bypass the combining of lists if the second list is empty
    if {$assignedShipVia ne {} } {
        #${log}::debug Concating ...
        set selectedShipViaList [concat $selectedShipViaList $assignedShipVia]
    }

    # Only keep the unique entries
    set selectedShipViaList [lsort -unique $selectedShipViaList]

    $lboxTo delete 0 end

    # Insert
    foreach item $selectedShipViaList {
        $lboxTo insert end $item
    }



} ;# customer::transferToAssigned

proc customer::removeFromAssigned {lbox okBtn} {
    #****f* removeFromAssigned/customer
    # CREATION DATE
    #   01/07/2015 (Wednesday Jan 07)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #
    #
    # SYNOPSIS
    #   customer::removeFromAssigned lbox
    #
    # FUNCTION
    #	Removes the selected Ship Via's from the Assigned lbox
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

    # Sort it from large to small, this way we can delete them in the loop properly.
    set selectedShipVia [lsort -decreasing [$lbox curselection]]

    foreach item $selectedShipVia {
        #Add item to list, so we can remove it from the DB. This is initiated in the first startup of the customer window.
        lappend ::customer::shipViaDeleteList [$lbox get $item]

        ${log}::debug Removed Selected ShipVia: [$lbox get $item]
        $lbox delete $item


    }

} ;# customer::removeFromAssigned


proc customer::populateCustomerLbox {lbox} {
    #****f* populateCustomerLbox/customer
    # CREATION DATE
    #   01/07/2015 (Wednesday Jan 07)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #
    #
    # SYNOPSIS
    #   customer::populateCustomerLbox lbox
    #
    # FUNCTION
    #	Lists the customers that are loaded in the DB
    #
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #
    #
    # NOTES
    #   Currently we only show ACTIVE records.
    #
    # SEE ALSO
    #
    #
    #***
    global log

    set getCustomerList [db eval "SELECT Cust_ID, CustName FROM Customer WHERE Status='1'"]

    foreach {id name} $getCustomerList {
        $lbox insert end "$id [list $name]"
        #${log}::debug id: $id cust: $name
    }


} ;# customer::populateCustomerLbox

proc customer::deleteFromlbox {lbox custID} {
    #****f* deleteFromlbox/customer
    # CREATION DATE
    #   01/08/2015 (Thursday Jan 08)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #
    #
    # SYNOPSIS
    #   customer::deleteFromlbox lbox
    #
    # FUNCTION
    #	Deletes the currently selected customer in the lbox, and refreshes the data from the DB
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

    set selData [$lbox get [$lbox curselection]]
    set csrFname [lrange [join [lrange $selData 1 1]] 0 0]
    set csrLname [lrange [join [lrange $selData 1 1]] 1 1]
    set title [lrange [$lbox get [$lbox curselection]] 2 2]
    set CSRid [db eval "SELECT CSR_ID from CSRs where FirstName='$csrFname' and LastName='$csrLname'"]


    set rowID [eAssist_db::getRowID PubTitle "CUSTID='$custID' AND CSRID='$CSRid' AND TitleName='$title'"]
    eAssist_db::delete PubTitle "" $rowID

} ;# customer::deleteFromlbox

proc ea::db::customer::ForestCertification {win} {
    $win configure -values [db eval "SELECT ForestType.ForestTypeDesc || ' / ' || ForestOrg.ForestOrgNum FROM ForestType
												INNER JOIN ForestOrg on ForestOrg.ForestOrg_ID = ForestType.ForestType_ID
												WHERE ForestType.Active = 1"]
}

proc customer::dbAddShipVia {modify lbox custIDwid custNamewid} {
    #****f* dbAddShipVia/customer
    # CREATION DATE
    #   01/13/2015 (Tuesday Jan 13)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #
    #
    # SYNOPSIS
    #   customer::dbAddShipVia lbox
    #
    # FUNCTION
    #	Adds the selected shipvias from the listbox, and inserts/updates them in the DB
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
    global log cust tmp

    switch -- $modify {
        view    {return}
        default {}
    }

    set custID [$custIDwid get]
    set custName [list [$custNamewid get]]
    set shipViaList [$lbox get 0 end]
    set haveCustID ""

    #${log}::debug CustID: $custID
    #${log}::debug CustName: $custName
    #${log}::debug CustStatus: $cust(Status)
    #${log}::debug DATA: $shipViaList

    # Check to see if custid is in db, if it isn't add it.
    set haveCustID [db eval "SELECT cust_ID FROM Customer where cust_id = '$custID'"]
    if {$haveCustID == ""} {
        db eval "INSERT INTO Customer (Cust_ID, CustName, Status) VALUES ('$custID', '$CustName', $cust(Status))"
    }

    # Remove all assignments in the db; so we don't have to keep track; we will add everything that is in the 'assigned' listbox later.
    db eval "DELETE FROM CustomerShipVia WHERE CustID = '$custID'"

    set shipViaList [$lbox get 0 end]

    foreach shipvia $shipViaList {
        lappend shipViaNameList '$shipvia'
    }

    # Retrieve all shipvia id's
    set shipvia_idList [db eval "SELECT ShipVia_ID FROM ShipVia WHERE ShipViaName IN ([join $shipViaNameList ,])"]

    # Combine custid and shipvia id's into one list
    foreach db_values $shipvia_idList {
        lappend custid_shipvia "('$custID', $db_values)"
    }

    # Add assignments to CustomerShipVia
    db eval "INSERT INTO CustomerShipVia (CustID, ShipViaID) VALUES [join $custid_shipvia ,]"

   unset shipViaNameList
   unset custid_shipvia

} ;# customer::dbAddShipVia

proc customer::validateEntry {okBtn addBtn remBtn wid entryValue} {
    #****f* validateEntry/customer
    # CREATION DATE
    #   01/13/2015 (Tuesday Jan 13)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #
    #
    # SYNOPSIS
    #   customer::validateEntry okBtn wid entryValue
    #
    # FUNCTION
    #	Ensures that we have some data in the widget; if we don't the OK button stays disabled. If we do, then we enable the OK button.
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

    ${log}::debug ENTRY: $wid
    #set entryValue [join [concat $entryValuePre $entryValuePost] ""]
    #${log}::debug Value: $entryValue
    ${log}::debug VALUE: $entryValue

    if {[string length $entryValue] >= 3} {
        #${log}::debug Button State Normal - Value: $entryValue
        $okBtn configure -state normal
        $addBtn configure -state normal
        $remBtn configure -state normal
    } else {
        #${log}::debug Button State Disable
        $okBtn configure -state disable
        $addBtn configure -state disable
        $remBtn configure -state disable
    }


    return 1

} ;# customer::validateEntry

proc customer::validateCustomer {type wid} {
    #****f* validateCustomer/customer
    # CREATION DATE
    #   01/27/2015 (Tuesday Jan 27)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #
    #
    # SYNOPSIS
    #   customer::validateCustomer entryWid cboxWid
    #
    # FUNCTION
    #	Looks for matches and populates both customer id widget, and customer name combobox
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

    set custIDList [db eval "SELECT Cust_ID FROM Customer WHERE Status='1'"]
    set custNameList [db eval "SELECT CustName FROM Customer WHERE Status='1'"]


    switch -- $type {
        id      {return $custIDList}
        name    {return $custNameList}
    }
} ;# customer::validateCustomer

proc customer::returnTitle {custID} {
    #****f* returnTitle/customer
    # CREATION DATE
    #   01/27/2015 (Tuesday Jan 27)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #
    #
    # SYNOPSIS
    #   customer::returnTitle custID
    #
    # FUNCTION
    #	Returns the list of titles associated with the customer id
    #
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #
    #
    # NOTES
    #   Hardcoded to only show entries with a status of 1 (active)!
    #
    # SEE ALSO
    #   DB Tables: PubTitle
    #
    #
    #***
    global log

    set titleList [db eval "SELECT TitleName FROM PubTitle WHERE CustID='$custID' AND Status='1'"]
    #${log}::debug Title List: $titleList

    return $titleList
} ;# customer::returnTitle


proc customer::populateTitleWid {tbl custID} {
    #****f* populateTitleWid/customer
    # CREATION DATE
    #   01/28/2015 (Wednesday Jan 28)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #
    #
    # SYNOPSIS
    #   customer::populateTitleWid tbl custID
    #
    # FUNCTION
    #	Populates the Title table with the CSR name and titles associated to the currently selected customer
    #
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #
    #
    # NOTES
    #   Status is hardcoded to show only active records!
    #
    # SEE ALSO
    #
    #
    #***
    global log

    # Make sure the table is cleared
    $tbl delete 0 end

    db eval "SELECT PubTitle.TitleName as Title, PubTitle.SaveLocation as Location, CSRs.FirstName ||' '|| CSRs.LastName as Name FROM CSRs
                    INNER JOIN PubTitle on PubTitle.CSRID = CSRs.CSR_ID
                    WHERE PubTitle.CustID = '$custID'
                    AND PubTitle.Status = 1" {
                        ${log}::debug $Name $Title $Location
                        $tbl insert end [list "" $Name $Title $Location]
                    }

} ;# customer::populateTitleWid


proc customer::dbUpdateCustomer {} {
    #****f* dbUpdateCustomer/customer
    # CREATION DATE
    #   01/28/2015 (Wednesday Jan 28)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #
    #
    # SYNOPSIS
    #   customer::dbUpdateCustomer
    #
    # FUNCTION
    #	Inserts or Updates the Customer ID, Customer Name, Title and CSR (associated with the Title)
    #
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #
    #
    # NOTES
    #   DB Tables: Customer, PubTitle
    #
    # SEE ALSO
    #
    #
    #***
    global log job tmp

    set csrID [lindex [db eval "SELECT CSR_ID, FirstName || ' ' || LastName FROM CSRs WHERE FirstName || ' ' || LastName = '$job(CSRName)'"] 0]

    # Insert the customer, default status of '1'; so its active.
    set tmp(db,rowID) [eAssist_db::getRowID Customer Cust_ID='$job(CustID)']
    eAssist_db::dbInsert -columnNames {Cust_ID CustName Status} -table Customer -data [list $job(CustID) $job(CustName) 1]

    # Insert the title, default status of '1'; so its active.
    set tmp(db,rowID) [eAssist_db::getRowID PubTitle TitleName='$job(Title)' AND CustID='$job(CustID)']
    eAssist_db::dbInsert -columnNames {TitleName CustID CSRID Status} -table PubTitle -data [list $job(Title) $job(CustID) $csrID 1]
} ;# customer::dbUpdateCustomer

proc customer::dbUpdateJob {args} {
    #****f* dbUpdateJob/customer
    # CREATION DATE
    #   06/25/2015 (Thursday Jun 25)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #
    #
    # USAGE
    #   customer::dbUpdateJob args
    #
    # FUNCTION
    #	Inserts Job data into the database; this is used after the initial setup, i.e. when the user uses File > Open
    #
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #
    #
    # EXAMPLE
    #   customer::dbUpdateJob -jNumber <value>, -jName <value>, -jSaveLocation <value>, -jShipStart <value>, -jShipBal <value>, -jHistNote <value>
    #
    # NOTES
    #
    #
    # SEE ALSO
    #
    #
    #***
    global log job

    foreach {key value} $args {
        switch -nocase $key {
            -jNumber        {#${log}::debug -jNumber $value
                                set jNumber $value
            }
            -jName          {#${log}::debug -jName $value
                                set jName $value
            }
            -jSaveLocation  {#${log}::debug -jSaveLocation $value
                                set jSaveLocation $value
            }
            -jShipStart     {#${log}::debug -jShipStart $value
                                set jShipStart $value
            }
            -jShipBal       {#${log}::debug -jShipBal $value
                                set jShipBal $value
            }
            -jHistNote      {#${log}::debug -jHistNote $value
                                set jHistNote $value
            }
            -jForestCert    {
                                set jForestCert $value
            }
            default         {${log}::critical [info level 0] Passed invalid args $args; return}
        }
    }


    # Get titleID, set a HistNote if one wasn't passed and then issue the ::insertJobInfo command
    set titleID [$job(db,Name) eval "SELECT max(TitleInformation_ID) from TitleInformation"]

    if {![info exists jHistNote] || $jHistNote == ""} {
        set jHistNote [mc "Auto Generated: Job Information was updated by user"]
    }

    # This command will figure out if we need to update or insert data into the the database.
    job::db::insertJobInfo -jNumber $jNumber -jName $jName -jSaveLocation $jSaveLocation -jDateShipStart $jShipStart -jDateShipBalance $jShipBal -titleid $titleID -histnote $jHistNote -jForestCert $jForestCert

} ;# customer::dbUpdateJob


proc customer::getFileSaveLocation {type} {
    #****f* getFileSaveLocation/customer
    # CREATION DATE
    #   02/13/2015 (Friday Feb 13)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #
    #
    # SYNOPSIS
    #   customer::getFileSaveLocation <job|title>
    #
    # FUNCTION
    #	Wrapper for [eAssist_Global::OpenFile]; this will return our preferred save location for the selected title.
    #   When this is first launched we find out if we already have a file path entered; if we do we use it as the starting location; if not we default to user preferences.
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
    global log job mySettings

    switch -nocase $type {
        title   {set fileLocation $mySettings(sourceFiles) }
        job     {set fileLocation $job(TitleSaveFileLocation)}
        default {return -code error "Must pass a valid parameter - Title or Job"}
    }


    if {$fileLocation != ""} {
        ${log}::notice SaveFileLocation exists, using: $fileLocation
        set defaultLocation  $fileLocation

    } else {
        ${log}::debug SaveFileLocation doesn't exist, using: $mySettings(sourceFiles)
        set defaultLocation $mySettings(sourceFiles)
    }


    set newSaveFileLocation [eAssist_Global::OpenFile [mc "Select Directory"] $defaultLocation dir]

    if {[eAssist_Global::folderAccessibility $newSaveFileLocation] != 3} {
        ${log}::critical WARNING! Cannot write to $newSaveFileLocation
        set newSaveFileLocation ""
    }

    switch -nocase $type {
        title   {set job(TitleSaveFileLocation) $newSaveFileLocation}
        job     {set job(JobSaveFileLocation) $newSaveFileLocation}
        default {return -code error "Must pass a valid parameter - Title or Job"}
    }


} ;# customer::getFileSaveLocation
