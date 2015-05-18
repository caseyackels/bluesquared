# Creator: Casey Ackels
# File Initial Date: 05 18,2015

##
## - Overview
# Job DB test procs

proc populate {} {
    global job program user
    job::db::setupSysTables
    job::db::insertAddresses
}

proc job::db::setupSysTables {} {
    #****f* setupSysTables/job::db
    # CREATION DATE
    #   05/18/2015 (Monday May 18)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   job::db::setupSysTables  
    #
    # FUNCTION
    #	Setups the system tables
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
    global log job program user

    set currentDate [ea::date::getTodaysDate -db]
    set histGUID [ea::tools::getGUID]
    set currentTime [ea::date::currentTime]
    # job::db::HistoryID -msg "Log Message, system generated"; returns ID
    ## History Table
    $job(db,Name) eval "INSERT INTO History (History_ID, HistUser, HistDate, HistTime) VALUES ('$histGUID', '$user(id)', '$currentDate', '$currentTime')"
    
    
    ## Title Information Table
    set CustCode TEMCUS
    set CSRName "TEST CSR"
    set TitleName "Test Title"
    $job(db,Name) eval "INSERT INTO TitleInformation (HistoryID, CustCode, CSRName, TitleName) VALUES ('$histGUID', '$CustCode', '$CSRName', '$TitleName')"
    set titleInformationID [$job(db,Name) eval "SELECT seq FROM sqlite_sequence WHERE name='TitleInformation'"]
    
    ## Job Information Table
    set tmp_title(JobInformation_ID) 304553
    set tmp_title(JobName) "May 2015"
    set tmp_title(JobSaveLocation) $program(Home)
    set tmp_title(JobFirstShipDate) 2015-26-05
    set tmp_title(JobBalanceShipDate) 2015-28-05
    $job(db,Name) eval "INSERT INTO JobInformation (JobInformation_ID, JobName, JobSaveLocation, JobFirstShipDate, JobBalanceShipDate, TitleInformationID)
                            VALUES ('$tmp_title(JobInformation_ID)',
                                    '$tmp_title(JobName)',
                                    '$tmp_title(JobSaveLocation)',
                                    '$tmp_title(JobFirstShipDate)',
                                    '$tmp_title(JobBalanceShipDate)',
                                    '$titleInformationID')"
                            
    # Versions table
    # default value
    $job(db,Name) eval "INSERT INTO Versions (VersionName) VALUES ('Version 1')"
    set versionID [$job(db,Name) eval "SELECT seq FROM sqlite_sequence WHERE name='Versions'"]
    
} ;# job::db::setupSysTables

proc job::db::insertAddresses {} {
    #****f* insertAddresses/job::db
    # CREATION DATE
    #   05/18/2015 (Monday May 18)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   job::db::insertAddresses  
    #
    # FUNCTION
    #	Inserts addresses
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
    global log job

    for {set x 0} {$x < 10} {incr x} {
        set id [ea::tools::getGUID]
        $job(db,Name) eval "INSERT INTO Addresses (Addresses_ID, AddressParentID, AddressChildID, VersionID,
                            usr_Company,
                            usr_Attention,
                            usr_Address1,
                            usr_Address2,
                            usr_Address3,
                            usr_City,
                            usr_State,
                            usr_Zip,
                            usr_Country,
                            usr_Phone,
                            usr_Quantity,
                            usr_Notes,
                            usr_ShipDate,
                            usr_DistributionType,
                            usr_ShipVia,
                            usr_ArriveDate,
                            usr_ContainerType,
                            usr_PackageType,
                            usr_ShippingClass)
                            VALUES ('$id', '$id','','1','SomeCo_$x','Manager','420$x Oak Tree Lane','','','Vancouver','WA','98661','US','5037909100','50$x','notes_$x','','','','','','','')"
                            
        $job(db,Name) eval "INSERT INTO ShippingOrders (JobInformationID, AddressID) VALUES ('304553','$id')"
    }

    
} ;# job::db::insertAddresses
