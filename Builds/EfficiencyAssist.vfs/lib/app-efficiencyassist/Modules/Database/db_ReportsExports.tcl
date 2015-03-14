# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 03 10,2015
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
# DB procs that insert data into Reports and GenerateReports and return report info.

proc ea::db::insertReports {name} {
    #****f* insertReports/ea::db
    # CREATION DATE
    #   03/10/2015 (Tuesday Mar 10)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::db::getReports args 
    #
    # FUNCTION
    #	Inserts or updates the report name
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

    db eval "INSERT INTO Reports (Reports_Name) VALUES ('$name')"

    
} ;# ea::db::insertReports


proc ea::db::getReport_DistTypes {reportName} {
    #****f* getReport_DistTypes/ea::db
    # CREATION DATE
    #   03/10/2015 (Tuesday Mar 10)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::db::getReport_DistTypes reportName 
    #
    # FUNCTION
    #	Retrieves the Dist Types associated with the report
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

    db eval "SELECT DistributionTypes.DistTypeName FROM GenerateReports
                INNER JOIN Reports ON Reports.Reports_ID = GenerateReports.ReportsID
                INNER JOIN DistributionTypes ON DistributionTypes.DistributionType_ID = GenerateReports.DistributionTypeID
                 WHERE Reports.Reports_Status = 1
                 AND
                 DistributionTypes.DistType_Status = 1
                 AND Reports.Reports_Name = '$reportName'"

    
} ;# ea::db::getReport_DistTypes
