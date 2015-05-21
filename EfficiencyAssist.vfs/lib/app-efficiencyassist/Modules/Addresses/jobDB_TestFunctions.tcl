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

proc job::db::testSetupDB {} {
    global log job
## CREATE DB    
    job::db::createDB SAGMED {Meredith Hunter} TEST001 Febraury 303603 {c:/tmp}
    
## INSERT TITLE AND GET ID
    set titleID [job::db::insertTitleInfo -title {Test Title} -csr {Lyn Lovell} -saveLocation {c:/tmp} -custcode {TEMCUS} -histnote {Initialize the Title DB}]
    
## INSERT JOB
    job::db::insertJobInfo -jNumber 304503 -jName {March 2015} -jSaveLocation {C:/tmp/job} -jDateShipStart 2015-05-20 -jDateShipBalance 2015-05-29 -titleid $titleID -histnote {Inserting a new Job}
}

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
