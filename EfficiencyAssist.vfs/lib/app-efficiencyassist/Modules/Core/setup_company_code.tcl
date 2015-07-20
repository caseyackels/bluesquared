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
