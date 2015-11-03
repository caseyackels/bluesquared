# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 03 10,2014
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 169 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2014-09-14 21:48:00 -0700 (Sun, 14 Sep 2014) $
#
########################################################################################

##
## - Overview
# Overview

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

proc importFiles::initVars {args} {
    #****f* initVars/importFiles
    # CREATION DATE
    #   10/24/2014 (Friday Oct 24)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   importFiles::initVars args 
    #
    # FUNCTION
    #	Initilize variables
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   importFiles::eAssistGUI
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log headerParent headerAddress dist carrierSetup packagingSetup shipOrder gui

    set headerParent(headerList) [db eval "SELECT dbColName FROM HeadersConfig WHERE dbActive = 1"]
    
    set headerParent(headerList,consignee) [db eval "SELECT dbColName FROM HeadersConfig
                                                        WHERE widUIGroup = 'Consignee'
                                                        ORDER BY widUIPositionWeight ASC, dbColName ASC"]
    
    set headerParent(headerList,shippingorder) [db eval "SELECT dbColName FROM HeadersConfig
                                                        WHERE widUIGroup <> 'Consignee'
                                                        ORDER BY widUIPositionWeight ASC, dbColName ASC"]
    
    set headerParent(whiteList) [eAssist_db::dbWhereQuery -columnNames dbColName -table HeadersConfig -where widDisplayType='Always']
    #set headerParent(blackList) [list Status] ;# This is only for the columns that exist in the main table (addresses) that we never want to display
    set headerParent(ColumnCount) [llength $headerParent(headerList)]
    set headerParent(ColumnCount,consignee) [db eval "SELECT Count (HeaderConfig_ID) from HeadersConfig
                                                        WHERE widUIGroup = 'Consignee'"]
    
    # Setup header array with subheaders
    foreach hdr $headerParent(headerList) {
        # Get the subheaders for the current header
        set headerAddress($hdr) [db eval "SELECT SubHeaderName FROM HeadersConfig
                                            LEFT OUTER JOIN SubHeaders
                                            WHERE HeaderConfigID=HeaderConfig_ID
                                            AND dbColName='$hdr'
                                            AND dbActive=1"]
    }
    
    
    set dist(distributionTypes) [db eval "SELECT DistTypeName FROM DistributionTypes"]
    
    set carrierSetup(ShippingClass) [db eval "SELECT ShippingClass FROM ShippingClasses"]
    set carrierSetup(ShipViaName) [db eval "SELECT ShipViaName FROM ShipVia ORDER BY ShipViaName"]
    
    set packagingSetup(ContainerType) [db eval "SELECT Container FROM Containers"]
    set packagingSetup(PackageType) [db eval "SELECT Package FROM Packages"]
    
    # Initialize the shipOrder array; we give it the same names as what is in the Header List
    eAssistHelper::initShipOrderArray
    importFiles::initModVariables
    importFiles::setJobArray

} ;# importFiles::initVars

proc importFiles::initModVariables {} {
    #****f* initModVariables/importFiles
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Initialize, and set defaults for variables within the Batch Maker module
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
    global log emailEvent desc gui
    
    # Name was changed, hence the inconsistency
    set desc(ModImportFiles) [mc "Batch Maker"]
    set emailEvent(ModBatchMaker) [list Export]
    
    set gui(nav_batchmaker) [list Reports Exports Settings Misc]

} ;# initModVariables/importFiles

proc importFiles::setJobArray {} {
    #****if* setJobArray/importFiles
    # CREATION DATE
    #   08/12/2015 (Wednesday Aug 12)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   Call this proc when resetting the array to default values
    #   
    #***
    global log job

    	array set job [list CustName "" \
				   CustID "" \
				   CSRName "" \
				   Title "" \
				   Name "" \
				   Number "" \
				   JobSaveFileLocation "" \
				   TitleSaveFileLocation "" \
				   JobFirstShipDate "" \
				   JobBalanceShipDate "" \
                   ForestCert ""]
        
} ;# importFiles::setJobArray

proc eAssistHelper::initShipOrderArray {} {
    #****if* initShipOrderArray/eAssistHelper
    # CREATION DATE
    #   10/30/2015 (Friday Oct 30)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   Initializes the shipOrder array with default values
    #   
    #***
    global log shipOrder

    array set shipOrder [list Address1 "" \
                                Address2 "" \
                                Address3 "" \
                                ArriveDate "" \
                                Attention "" \
                                City "" \
                                Company "" \
                                ContainerType "" \
                                Country "" \
                                DistributionType "" \
                                Notes "" \
                                PackageType "" \
                                Phone "" \
                                Quantity "" \
                                ShipDate "" \
                                ShipVia "" \
                                ShippingClass "" \
                                State "" \
                                Versions "" \
                                Zip ""]

} ;# eAssistHelper::initShipOrderArray
