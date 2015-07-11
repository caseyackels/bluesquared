# Creator: Casey Ackels
# File Initial Date: 07 09,2015

proc ea::db::init_vars {} {
    #****f* init_vars/ea::db
    # CREATION DATE
    #   07/09/2015 (Thursday Jul 09)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # USAGE
    #   ea::db::init_vars  
    #
    # FUNCTION
    #	Initializes program wide variables on startup
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # EXAMPLE
    #   ea::db::init_vars 
    #
    # NOTES
    #   
    #  
    # SEE ALSO
    #   
    #   
    #***
    global log             

    ${log}::debug Initializing Array: masterAddr()
    ea::db::init_masterAddr
    
} ;# ea::db::init_vars

proc ea::db::init_masterAddr {} {
    #****f* init_masterAddr/ea::db
    # CREATION DATE
    #   07/09/2015 (Thursday Jul 09)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # USAGE
    #   ea::db::init_masterAddr  
    #
    # FUNCTION
    #	Initializes the masterAddr array and sets the defaults. Will additionally populate the company() array.
    #	The company() array is currently used as the 'plant' address, the masterAddr() array serves as showing just the active record in Table: MasterAddresses
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # EXAMPLE
    #   ea::db::init_masterAddr 
    #
    # NOTES
    #   
    #  
    # SEE ALSO
    #   
    #   
    #***
    global log masterAddr company

        # [ARRAY] masterAddr, Plant and Active are set values, because those are also the defaults in the DB
	array set masterAddr {
			ID          ""
			Company     ""
			Plant       0
			Attn        ""
			Addr1       ""
			Addr2       ""
			Addr3       ""
			City        ""
			StateAbbr   ""
			CtryCode    ""
			Active      1
	}
    
    # Query db to see if we have a plant setup. If we don't, the defaults that we set above will be used.
    db eval "SELECT MasterAddr_ID, MasterAddr_Company, MasterAddr_Phone, MasterAddr_Plant, MasterAddr_Attn, MasterAddr_Addr1, MasterAddr_Addr2, MasterAddr_Addr3, MasterAddr_City, MasterAddr_StateAbbr, MasterAddr_Zip, MasterAddr_CtryCode, MasterAddr_Active
                FROM MasterAddresses
                    WHERE MasterAddr_Plant = 1
                AND MasterAddr_Active = 1" {
                    ${log}::debug Plant address found, populating Array masterAddr()...
                    set masterAddr(ID) $MasterAddr_ID
                    set masterAddr(Company) $MasterAddr_Company
                    set masterAddr(Phone) $MasterAddr_Phone
                    set masterAddr(Plant) $MasterAddr_Plant
                    set masterAddr(Attn) $MasterAddr_Attn
                    set masterAddr(Addr1) $MasterAddr_Addr1
                    set masterAddr(Addr2) $MasterAddr_Addr2
                    set masterAddr(Addr3) $MasterAddr_Addr3
                    set masterAddr(City) $MasterAddr_City
                    set masterAddr(StateAbbr) $MasterAddr_StateAbbr
                    set masterAddr(CtryCode) $MasterAddr_CtryCode
                    set masterAddr(Zip) $MasterAddr_Zip
                    set masterAddr(Active) $MasterAddr_Active
                }
                
    # Remove old config file settings
    array unset company
    
    # Temp note Re-init the company() array from the values in the db.
    # Init Array: company()
    array set company {
        ${log}::debug Initializing Array: company()
        address1 $masterAddr(Addr1)
        address2 $masterAddr(Addr2)
        address3 $masterAddr(Addr3)
        city     $masterAddr(City)
        company  $masterAddr(Company)
        contact  $masterAddr(Attn)
        country  $masterAddr(CtryCode)
        name     $masterAddr(Company)
        phone    $masterAddr(Phone)
        state    $masterAddr(StateAbbr)
        zip      $masterAddr(Zip)
    }
} ;# ea::db::init_masterAddr