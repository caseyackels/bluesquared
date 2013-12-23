# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 10 24,2013
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision$
# $LastChangedBy$
# $LastChangedDate$
#
########################################################################################

##
## - Overview
# Split addresses code

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


proc eAssistHelper::editStartSmpl {tbl row col text} {
    #****f* editStartSmpl/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Start Command for editing the Company Sample table
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
    global log csmpls
    ${log}::debug --START-- [info level 1]
        
		set w [$tbl editwinpath]

        switch -glob [string tolower [$tbl columncget $col -name]] {
            "ticket"		{ set csmpls(startTicket) $text}
            "csr"			{ set csmpls(startCSR) $text}
            "sampleroom"	{ set csmpls(startSmpl) $text}
			"sales"			{ set csmpls(startSales) $text}
			default	{}
        }

        return $text

    ${log}::debug --END-- [info level 1]
} ;# eAssistHelper::editStartSmpl


proc eAssistHelper::editEndSmpl {tbl row col text} {
    #****f* editEndSmpl/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	End Command for editing the Company Sample table
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
    global log csmpls
    ${log}::debug --START-- [info level 1]
        
	set w [$tbl editwinpath]

    #${log}::debug Column Name: [$tbl columncget $col -name]
    switch -glob [string tolower [$tbl columncget $col -name]] {
            "ticket"		{ set csmpls(TicketTotal) [eAssistHelper::calcSamples $csmpls(startTicket) $text $csmpls(TicketTotal)] }
            "csr"			{ set csmpls(CSRTotal) [eAssistHelper::calcSamples $csmpls(startCSR) $text $csmpls(CSRTotal)] }
            "sampleroom"	{ set csmpls(SmplRoomTotal) [eAssistHelper::calcSamples $csmpls(startSmpl) $text $csmpls(SmplRoomTotal)] }
			"sales"			{ set csmpls(SalesTotal) [eAssistHelper::calcSamples $csmpls(startSales) $text $csmpls(SalesTotal)]}
			default	{}
    }
    
    
    return $text

    ${log}::debug --END-- [info level 1]
} ;# eAssistHelper::editEndSmpl


proc eAssistHelper::calcSamples {startCount endCount totalVar} {
    #****f* calcSamples/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Calculate the sample totals
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
    global log
    ${log}::debug --START -- [info level 1]
	if {$startCount == ""} {set startCount 0}
	if {$endCount == ""} {set endCount $startCount}
    if {$totalVar == ""} {set totalVar 0}
	
    # guard against the user removing the value completely, so lets subtract it, if they both equal themselves.
	if {$startCount >= $endCount} {
		set returnCount [ expr {$totalVar - $endCount}]
		} else {
			set returnCount [ expr {$totalVar + $endCount}]
		}

	return $returnCount
    ${log}::debug --END -- [info level 1]
} ;# eAssistHelper::calcSamples


proc eAssistHelper::saveCSMPLS {} {
    #****f* saveCSMPLS/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Process the allocated samples.
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
    global log csmpls w process files company
    ${log}::debug --START-- [info level 1]
    
    set ColumnCount [$w(csmpls.f1).tbl columncount]
    set RowCount [llength [$w(csmpls.f1).tbl getcells 0,0 end,0]]

    # Rows
	for {set x 0} {$RowCount > $x} {incr x} {
        set vers [lindex $process(versionList) $x]
		# Columns
		for {set y 0} {$ColumnCount > $y} {incr y} {
			set ColumnName [$w(csmpls.f1).tbl columncget $y -name]
            
            switch -nocase $ColumnName {
                ticket          { eAssistHelper::insertSmpls $vers [$w(csmpls.f1).tbl getcells $x,$y] }
                sales           { eAssistHelper::insertSmpls $vers [$w(csmpls.f1).tbl getcells $x,$y] }
                sampleroom      { eAssistHelper::insertSmpls $vers [$w(csmpls.f1).tbl getcells $x,$y] }
                csr             { eAssistHelper::insertSmpls $vers [$w(csmpls.f1).tbl getcells $x,$y] }
                default         {}
            }
        }
    }
    
	
    ${log}::debug --END-- [info level 1]
} ;# eAssistHelper::saveCSMPLS


proc eAssistHelper::insertSmpls {vers args} {
    #****f* insertSmpls/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Insert samples into the main table.
    #   args = qty of samples (ticket, sales, sampleroom, csr)
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
    global log company files process
    ${log}::debug --START-- [info level 1]
    
    set args [join $args]
    if {$args == ""} {return}
    
    set companyAddr [array names company]
    set ColumnCount [$files(tab3f2).tbl columncount]
    set RowCount [llength [$files(tab3f2).tbl getcells 0,0 end,0]]

		# Columns
		for {set y 0} {$ColumnCount > $y} {incr y} {
            set ColumnName [$files(tab3f2).tbl columncget $y -name]
            set columnExists [lsearch -nocase $companyAddr $ColumnName]
            if {$columnExists != -1} {
                #${log}::debug Inserting into existing destination column: $ColumnName
                lappend insertCompany [string toupper $company([lindex $companyAddr $columnExists])]
            } else {
                switch -nocase $ColumnName {
                    version     {${log}::debug Inserting into column: $ColumnName - Vers: $vers; lappend insertCompany $vers}
                    quantity    {${log}::debug Inserting into column: $ColumnName - Vers: $args; lappend insertCompany $args}
                    default     {lappend insertCompany ""}
                }
            }
        }
    ${log}::debug INSERTING COMPANY $insertCompany
    #$files(tab3f2).tbl insert end $insertCompany


    ${log}::debug --END-- [info level 1]
} ;# eAssistHelper::insertSmpls
