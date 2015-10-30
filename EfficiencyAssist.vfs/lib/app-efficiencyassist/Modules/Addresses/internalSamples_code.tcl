# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 10 24,2013
##
## - Overview
# Assign Internal (Company) samples.

proc ea::code::samples::quickAddSmpls {win entryWid} {
    #****f* quickAddSmpls/ea::code::samples
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Quickly add sample quantities into the selected columns
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
	# 	This relies on the textvariable (of the samples (CSR, Sales, Ticket, SampleRoom) to be the same as the column name
    #
    # SEE ALSO
    #
    #***
    global log csmpls
    
    set entryTxt [$entryWid get]

    if {$csmpls(assignAllVersions) == 1} {
        ${log}::debug Assigning quantity to all versions
        set cmd {$win fillcolumn $x $entryTxt}
    
    } else {
        ${log}::debug Assigning quantity to a specific version
        ${log}::debug Looking for Version $csmpls(activeVersion)
        
        # Guard against the user not selecting a version, and not selecting 'all versions' checkbutton
        if {$csmpls(activeVersion) eq ""} {return}
        
        # Find out which row our version is on
        set versRow [$win searchcolumn Version $csmpls(activeVersion)]
        ${log}::debug $versRow

        set cmd {$win cellconfigure $versRow,$x -text $entryTxt}
    }
    
	for {set x 0} {[$win columncount] > $x} {incr x} {
		set currentColumn [$win columncget $x -name]
        #${log}::debug Column Names: $currentColumn
        #
        #if {$currentColumn eq "Version"} {
        #    ${log}::debug Version Column
        #    ${log}::debug Current Version: [$win getcells end,Version]
        #}
		
		foreach value [array names csmpls] {
			if {[string match $value $currentColumn] == 1} {
				if {$csmpls($value) == 1} {
					#$win fillcolumn $x $entryTxt
                    eval $cmd
					#eAssistHelper::detectColumn $win "" $x
					# Reset the checkbutton
					set csmpls($value) 0
				}
			}
		}
	}
	
	# Clear the entry widget
	$entryWid delete 0 end
} ;# ea::code::samples::quickAddSmpls

proc ea::code::samples::setVersState {cbox} {
    #****if* setVersState/ea::code::samples
    # CREATION DATE
    #   10/29/2015 (Thursday Oct 29)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   Clears out the version combobox and sets the state.
    #   
    #***
    global log csmpls
    
    set cstate [$cbox cget -state]
    
    if {$cstate eq "readonly"} {
        # Issue disabling commands
        $cbox configure -state normal
        $cbox delete 0 end
        $cbox configure -state disabled
    } else {
        # Issue enabling commands
        $cbox configure -state readonly
        # clear the 'all versions' checkbutton
        set csmpls(assignAllVersions) 0
    }
    
} ;# ea::code::samples::setVersState

proc ea::code::samples::writeToDB {widTbl} {
    #****if* writeToDB/ea::db::samples
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
    #   
    #   
    #***
    global log shipOrder csmpls job
    
    # Reset the shipOrder array
    importFiles::setShipOrderArray
    
    # Check to see if an address was entered for this distribution type
    set disttype_addr [ea::db::getDistTypeConfig -method Report -action Single -disttype "$csmpls(distributionType)"]
    if {$disttype_addr eq ""} {${log}::critical [info level 0] There is not a company setup for this distribution type; return}
    
    # Populate the shipOrder array
    set shipOrder(Company) [lindex $disttype_addr 0]
    set shipOrder(Attention) [lindex $disttype_addr 1]
    set shipOrder(Address1) [lindex $disttype_addr 2]
    set shipOrder(Address2) [lindex $disttype_addr 3]
    set shipOrder(Address3) [lindex $disttype_addr 4]
    set shipOrder(City) [lindex $disttype_addr 5]
    set shipOrder(State) [lindex $disttype_addr 6]
    set shipOrder(Zip) [lindex $disttype_addr 7]
    set shipOrder(Country) [lindex $disttype_addr 8]
    set shipOrder(Phone) [lindex $disttype_addr 9]
    set shipOrder(ShipVia) [lindex $disttype_addr 10]
    
    # Variables that don't exist in the disttype_addr var
    set shipOrder(DistributionType) "$csmpls(distributionType)"
    
    # write out the records per version
    foreach record [$widTbl get 0 end] {
        set qtys [join [join [lrange $record 2 end]] +]
        if {$qtys ne ""} {
            ${log}::debug Set the Quantity to: [expr $qtys]
        }
        #${log}::debug catch var: $err
        set vers [join [lindex $record 1]]
        ${log}::debug Set the Version to: $vers - [job::db::getVersionCount -type id -job $job(Number) -version "$vers" -versActive 1 -addrActive 1]
        ${log}::debug Inserting shipOrder() into tbl:Addresses and tbl:ShippingOrders
        ${log}::debug Insert Sample data into tbl:InternalSamples
        ${log}::debug [join "ShippingOrders_ID [lrange $record 2 end]" ,]
    }
    
} ;# ea::db::samples::writeToDB
