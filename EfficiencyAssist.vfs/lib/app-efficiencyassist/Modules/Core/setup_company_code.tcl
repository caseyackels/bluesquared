# Creator: Casey Ackels
# File Initial Date: 07 13,2015


proc eAssistSetup::populateCompanyArray {} {
    #****f* populateCompanyArray/eAssistSetup
    # CREATION DATE
    #   07/13/2015 (Monday Jul 13)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # USAGE
    #   eAssistSetup::populateCompanyArray  
    #
    # FUNCTION
    #	Sets the masterAddr() array values to the company() array values. This is only used when editing the company in Setup.
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # EXAMPLE
    #   eAssistSetup::populateCompanyArray  
    #
    # NOTES
    #   
    #  
    # SEE ALSO
    #   masterAddr() and company() are set in file db_initvars.tcl
    #   
    #   
    #***
    global log masterAddr company
    
    #${log}::debug masterAddr()\n
    #[parray masterAddr]
    
    #${log}::debug company()\n
    #[parray company]
    
    set masterAddr(Addr1) $company(address1)
    set masterAddr(Addr2) $company(address2) 
    set masterAddr(Addr3) $company(address3)
    set masterAddr(City) $company(city) 
    set masterAddr(Company) $company(company) 
    set masterAddr(Attn) $company(contact) 
    set masterAddr(CtryCode) $company(country) 
    set masterAddr(Company) $company(name) 
    set masterAddr(Phone) $company(phone) 
    set masterAddr(StateAbbr) $company(state) 
    set masterAddr(Zip) $company(zip) 


} ;# eAssistSetup::populateCompanyArray


proc eAssistSetup::editCompany {f editMode btn} {
    #****f* editCompany/eAssistSetup
    # CREATION DATE
    #   07/22/2015 (Wednesday Jul 22)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # USAGE
    #   eAssistSetup::editCompany f 
    #
    # FUNCTION
    #	Makes the Company fields editable/readonly submits changes to the DB
    #   edit mode: changes state to normal, changes button text to 'Update'
    #   readonly mode: changes state to readonly; submits data to database; changes button text to 'Change'
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # EXAMPLE
    #   eAssistSetup::editCompany $f1 normal|readonly
    #
    # NOTES
    #   
    #  
    # SEE ALSO
    #   
    #   
    #***
    global log masterAddr

    ${log}::debug State $editMode
    
    foreach child [winfo child $f] {
        $child configure -state $editMode
    }
    
    if {$editMode eq "readonly"} {
        # We are making a change (adding/updating company info)
        # Update DB
        ${log}::debug Update DB with masterAddr() array
        # Reconfigure Button
        #${log}::debug $btn configure -command editCompany $f normal $btn
        $btn configure -text [mc "Change"] -command [list eAssistSetup::editCompany $f normal $btn]
        
        ${log}::debug Check DB for Company Address
        set companyExists [db eval "SELECT MasterAddr_ID, MasterAddr_Plant FROM MasterAddresses"]
        if {$companyExists eq ""} {
            ${log}::debug Company doesn't exist, adding to the database...
            set masterAddr(Plant) 1
            
            if {[info exists colList]} {unset colList}
            if {[info exists varList]} {unset varList}
            foreach dbCol [lsort [array names masterAddr]] {
                if {$dbCol eq "ID"} {continue}; #skip, this is only used when we pull data out, not putting it in.
                lappend colList MasterAddr_$dbCol
            }
            
            set masterAddrArrayNames [lsort [array names masterAddr]]
            foreach var $masterAddrArrayNames {
                if {$var eq "ID"} {continue}; #skip, this is only used when we pull data out, not putting it in.
                lappend varList '$masterAddr($var)'
            }
            #${log}::debug INSERT INTO MasterAddresses ([join $colList ,]) VALUES ([join $varList ,])
            db eval "INSERT INTO MasterAddresses ([join $colList ,]) VALUES ([join $varList ,])"
            
            #parray masterAddr
        } else {
            ${log}::debug Company exists in the database, updating address...
            if {[info exists colList]} {unset colList}
            if {[info exists dbValues]} {unset dbValues}
                
            foreach dbCol [lsort [array names masterAddr]] {
                if {$dbCol eq "ID"} {continue}; #skip, this is only used when we pull data out, not putting it in.
                lappend colList MasterAddr_$dbCol
            }
            
            foreach val $colList {
                set arrayName [lrange [split $val _] 1 1]
                lappend dbValues $val='$masterAddr($arrayName)'
            }
            
            #${log}::debug db eval "UPDATE MasterAddresses SET [join $dbValues ,] WHERE MasterAddr_ID=$masterAddr(ID)"
            db eval "UPDATE MasterAddresses SET [join $dbValues ,] WHERE MasterAddr_ID=$masterAddr(ID)"
        }
                
        
    } else {
        #${log}::debug $btn configure -command editCompany $f readonly $btn
        
        # setting window to readonly - just need to update the button command
        $btn configure -text [mc "Save"] -command [list eAssistSetup::editCompany $f readonly $btn]
    }
 
} ;# eAssistSetup::editCompany


proc eAssistSetup::editCarrier {widTbl carrierWid acctWid} {
    #****f* editCarrier/eAssistSetup
    # CREATION DATE
    #   07/24/2015 (Friday Jul 24)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # USAGE
    #   eAssistSetup::editCarrier widTbl carrierWid acctWid 
    #
    # FUNCTION
    #	Takes the values from the Carrier and Account entry field, and insert them into the DB/Table.
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # EXAMPLE
    #   eAssistSetup::editCarrier $widTbl $carrierWid $accountWid
    #
    # NOTES
    #   
    #  
    # SEE ALSO
    #   
    #   
    #***
    global log masterAddr tmp

    # Do we have a masterID?
    if {$masterAddr(ID) == "" } {${log}::debug Master Addr is not set...; return}
    
    # Get carrier Name
    set carrierName [$carrierWid get]
    if {$carrierName == "" } {${log}::debug Please choose a carrier...; return}
    
    # Get carrier ID
    set carrierID [db eval "SELECT Carrier_ID FROM Carriers WHERE Name = '$carrierName'"]
    
    # Get carrier Account
    set carrierAcct [$acctWid get]
    if {$carrierAcct == "" } {${log}::debug Please enter an account...; return}
    
    # Clear data from widgets
    $carrierWid delete 0 end
    $acctWid delete 0 end
    
    
    ## Updating or Inserting?
    ##
    if {![info exists tmp(db,id)]} {set tmp(db,id) ""}
    if {$tmp(db,id) == ""} {
        # Insert data into DB
        #${log}::debug db eval "INSERT INTO CarrierAccts (CarrierAccts_Acct, MasterAddrID, CarrierID) VALUES ('$carrierAcct', '$masterAddr(ID)', '$carrierID')"
        db eval "INSERT INTO CarrierAccts (CarrierAccts_Acct, MasterAddrID, CarrierID) VALUES ('$carrierAcct', '$masterAddr(ID)', '$carrierID')"
    
    } else {
        # Updating data
        db eval "UPDATE CarrierAccts SET CarrierAccts_Acct='$carrierAcct', CarrierID=$carrierID
                    WHERE CarrierAccts_ID=$tmp(db,id)"
                    
        set tmp(db,id) "";# remove this since we just used it and updated info in the db.
    }

    
    # Populate tablelist widget
    #${log}::debug eAssistSetup::populateCarrierTbl $widTbl
    eAssistSetup::populateCarrierTbl $widTbl
    
} ;# eAssistSetup::editCarrier


proc eAssistSetup::populateCarrierTbl {widTbl} {
    #****f* populateCarrierTbl/eAssistSetup
    # CREATION DATE
    #   07/24/2015 (Friday Jul 24)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # USAGE
    #   eAssistSetup::populateCarrierTbl widTbl 
    #
    # FUNCTION
    #	Populates the table widget for the carrier accounts
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # EXAMPLE
    #   eAssistSetup::populateCarrierTbl 
    #
    # NOTES
    #   
    #  
    # SEE ALSO
    #   
    #   
    #***
    global log masterAddr
    
    # remove data from the widget first; if we don't data will be duplicated
    $widTbl delete 0 end

    # Retrieve data from DB
    db eval "SELECT CarrierID, CarrierAccts_Acct, Active, Carriers.Name as Name from CarrierAccts
                INNER JOIN Carriers ON
                Carrier_ID = CarrierID
                WHERE Active = 1
                AND MasterAddrID = $masterAddr(ID)" {
                    $widTbl insert end [list "" $Name $CarrierAccts_Acct]
                }

    
} ;# eAssistSetup::populateCarrierTbl .container.setup.fc0.fc2.tbl


proc eAssistSetup::modifyCarrier {tbl carrier account} {
    #****f* modifyCarrier/eAssistSetup
    # CREATION DATE
    #   07/24/2015 (Friday Jul 24)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # USAGE
    #   eAssistSetup::modifyCarrier tbl carrier account 
    #
    # FUNCTION
    #	Removes any data in the Carrier and Account entry fields, then populates the Carrier and Account field from the data that was double clicked on
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # EXAMPLE
    #   eAssistSetup::modifyCarrier tbl carrier account
    #
    # NOTES
    #   
    #  
    # SEE ALSO
    #   
    #   
    #***
    global log masterAddr tmp

    ${log}::debug [$tbl get [$tbl curselection]]
    set getData [$tbl get [$tbl curselection]]
    $carrier delete 0 end
    $carrier insert end [lrange $getData 1 1]
    
    $account delete 0 end
    $account insert end [lrange $getData 2 2]
    
    set carrierID [db eval "SELECT Carrier_ID FROM Carriers WHERE Name = '[lrange $getData 1 1]'"]
    set tmp(db,id) [db eval "SELECT CarrierAccts_ID FROM CarrierAccts
                                WHERE MasterAddrID = $masterAddr(ID)
                                AND CarrierID = $carrierID
                                AND CarrierAccts_Acct = '[lrange $getData 2 2]'"]

    
} ;# eAssistSetup::modifyCarrier

proc eAssistSetup::deleteCarrier {tbl} {
    #****f* deleteCarrier/eAssistSetup
    # CREATION DATE
    #   07/27/2015 (Monday Jul 27)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # USAGE
    #   eAssistSetup::deleteCarrier tbl 
    #
    # FUNCTION
    #	Removes the selected entry from the database, then calls [eAssistSetup::populateCarrierTbl] to update the widget
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # EXAMPLE
    #   eAssistSetup::deleteCarrier 
    #
    # NOTES
    #   
    #  
    # SEE ALSO
    #   
    #   
    #***
    global log

    #${log}::debug selection: [$tbl get [$tbl curselection]]
    
    set carrierName [lindex [$tbl get [$tbl curselection]] 1]
    set carrierAcct [lindex [$tbl get [$tbl curselection]] 2]
    
    #${log}::debug carrierName: $carrierName
    #${log}::debug carrierAcct: $carrierAcct
    
    set carrierID [db eval "SELECT Carrier_ID FROM Carriers WHERE Name = '$carrierName'"]
    
    #set dbCheck ""
    
    # Check the db - Unneeded?? (7/2015)
    #set dbCheck [db eval "SELECT CarrierAccts_Acct, CarrierID FROM CarrierAccts
    #                        WHERE CarrierAccts_Acct = '$carrierAcct'
    #                        AND CarrierID = $carrierID"]
    
    #${log}::debug dbCheck: $dbCheck
    
    
    db eval "DELETE FROM CarrierAccts
                    WHERE CarrierAccts_Acct = '$carrierAcct'
                            AND CarrierID = $carrierID"
    
    
    ${log}::notice [mc "Company Setup, Deleted Account: $carrierAcct"]

    eAssistSetup::populateCarrierTbl $tbl
    
} ;# eAssistSetup::deleteCarrier
