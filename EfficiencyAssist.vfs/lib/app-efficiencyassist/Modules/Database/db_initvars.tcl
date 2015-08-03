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
    
    ${log}::debug Initilizing Array: disttype()
    ea::db::reset_disttype
    
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
    #   'eAssist_initVariables file: startup.tcl
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

    # Init the array
    ea::db::reset_masterAddr
    
    # Query db to see if we have a plant setup. If we don't, the defaults that we set above will be used.
    db eval "SELECT MasterAddr_ID, MasterAddr_Company, MasterAddr_Phone, MasterAddr_Plant, MasterAddr_Attn, MasterAddr_Addr1, MasterAddr_Addr2, MasterAddr_Addr3, MasterAddr_City, MasterAddr_StateAbbr, MasterAddr_Zip, MasterAddr_CtryCode, MasterAddr_Active, MasterAddr_Internal
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
                    set masterAddr(Internal) $MasterAddr_Internal
                }
                
    # Remove old config file settings
    array unset company
    
    # Init Array: company()
    ${log}::debug Initializing Array: company()
    set company(address1) $masterAddr(Addr1)
    set company(address2) $masterAddr(Addr2)
    set company(address3) $masterAddr(Addr3)
    set company(city) $masterAddr(City)
    set company(company) $masterAddr(Company)
    set company(contact) $masterAddr(Attn)
    set company(country) $masterAddr(CtryCode)
    set company(name) $masterAddr(Company)
    set company(phone) $masterAddr(Phone)
    set company(state) $masterAddr(StateAbbr)
    set company(zip) $masterAddr(Zip)
} ;# ea::db::init_masterAddr

proc ea::db::reset_masterAddr {} {
    global masterAddr
    # Set the masterAddr to empty values
    if {[info exists masterAddr]} {unset masterAddr}
        
    array set masterAddr {
			ID          ""
			Company     ""
            Phone       ""
			Plant       0
			Attn        ""
			Addr1       ""
			Addr2       ""
			Addr3       ""
			City        ""
			StateAbbr   ""
			CtryCode    ""
            Zip         ""
			Active      1
            Internal    0
	}
}

proc ea::db::reset_disttype {} {
    global disttype
    
    if {[info exists disttype]} {unset disttype}
        
    array set disttype [list summarize "" \
                 rpt,singleEntry "" \
                 expt,singleEntry "" \
                 rpt,AddrName "" \
                 expt,AddrName "" \
                 distName "" \
                 shipType "" \
                 carriers "" \
                 id "" \
                 status 1]
}
