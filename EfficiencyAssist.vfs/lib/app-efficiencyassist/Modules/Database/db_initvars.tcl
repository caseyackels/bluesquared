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
    global log program sec intlSetup sysdb monarch_db

    ${log}::debug Initilizing list of modules
    set program(moduleNames) [eAssist_db::getDBModules]

    ${log}::debug Initializing Array: masterAddr()
    ea::db::init_masterAddr

    ${log}::debug Initilizing Array: disttype()
    ea::db::reset_disttype

    ${log}::debug Initilizing Array: sec()
    ea::db::init_secArray

    ${log}::debug Initilizing Array: intlSetup()
    ea::db::reset_intlSetup

    ${log}::debug Initilizing Array: mod()
    ea::db::init_mod

    ${log}::debug Initilizing Array: sysdb()
    ea::db::init_sysdb

    set monarch_db [tdbc::odbc::connection create db2 "$sysdb(dbLoginString)"]

    # Populate individual vars
    ${log}::debug Initilizing list of security groups
    set sec(groupNames) [ea::db::getGroupNames]
    set sec(UserLogins) [ea::db::getUserList -login]

    set program(BM,groups) [list Filepaths Reports Exports Misc]
    set program(SU,groups) [list Filepaths]
    set program(BL,groups) [list Filepaths]
    set program(BF,groups) ""
    set program(SC,groups) ""
    set program(LD,groups) ""
    set program(LF,groups) ""

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

    array set disttype [list rpt,summarize 0 \
                 rpt,singleEntry 0 \
                 expt,singleEntry 0 \
                 rpt,AddrName "" \
                 expt,AddrName "" \
                 expt,shipVia "" \
                 distName "" \
                 shipType "" \
                 carriers "" \
                 id "" \
                 status 1]
}

proc ea::db::reset_intlSetup {} {
    global intlSetup

    if {[info exists intlSetup]} {unset intlSetup}

    set intlSetup(UOMList) [db eval "SELECT UOM FROM UOM"]
    set intlSetup(TERMSList) [db eval "SELECT TermsAbbr FROM IntlShipTerms"]
    set intlSetup(PAYERList) ""
    set intlSetup(LICENSEList) [db eval "SELECT LicenseAbbr FROM IntlLicense"]
}


proc ea::db::init_secArray {} {
    #****if* init_secArray/ea::db
    # CREATION DATE
    #   09/17/2015 (Thursday Sep 17)
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
    global log sec

    array set sec { groupNames "" \
                    UserLogins ""}


} ;# ea::db::init_secArray

proc ea::db::init_intlSetupArray {} {
    global log intlSetup

    #set intlSetup(UOMList) [db eval "SELECT UOM from UOM"]
    #set intlSetup(TERMSList) [db eval "SELECT "]
    #set intlSetup(PAYERList)
    #set intlSetup(LICENSEList)
}

proc  ea::db::init_mod {} {
    # See file: boxlabels_code.tcl / ea::code::bl::transformToVar
    global log mod
    set mod(Box_Labels,uservars) [list #JobName \
                                        #TitleName \
                                        #CustomerName \
                                        #CurrentMonth \
                                        #NextMonth \
                                        #CurrentYear \
                                        #NextYear \
                                        #JobNumber]
} ;# ea::tools::user_vars


proc ea::db::init_sysdb {} {
    global sysdb
    array set sysdb { serverName "" \
                        database "" \
                        userid "" \
                        userpwd "" \
                    }

    db eval "SELECT db_ServerName, db_dbName, db_userid, db_pwd FROM db_integration" {
        set sysdb(serverName) $db_ServerName
        set sysdb(database) $db_dbName
        set sysdb(userid) $db_userid
        set sysdb(userpwd) $db_pwd
    }

    set sysdb(dbLoginString) "Driver={SQL Server};Server=$sysdb(serverName);Database=$sysdb(database);UID=$sysdb(userid);PWD=$sysdb(userpwd)"
} ;# ea::db::init_sysdb
