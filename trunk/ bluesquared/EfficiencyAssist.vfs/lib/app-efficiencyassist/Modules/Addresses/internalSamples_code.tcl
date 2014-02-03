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
# Assign Internal (Company) samples.

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
    global log
    ${log}::debug --START-- [info level 1]

	eAssistHelper::detectColumn $tbl $col

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
    global log
    ${log}::debug --START-- [info level 1]

	eAssistHelper::detectColumn $tbl $col 
    
    return $text

    ${log}::debug --END-- [info level 1]
} ;# eAssistHelper::editEndSmpl


proc eAssistHelper::detectColumn {tbl col} {
    #****f* detectColumn/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Figure out which column are are in, and [switch] accordingly
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
    
	switch -glob [string tolower [$tbl columncget $col -name]] {
            "ticket"		{ set csmpls(TicketTotal)	[eAssistHelper::calcSamples [$tbl columnindex Ticket] $tbl] }
            "csr"			{ set csmpls(CSRTotal)		[eAssistHelper::calcSamples [$tbl columnindex CSR] $tbl] }
            "sampleroom"	{ set csmpls(SmplRoomTotal) [eAssistHelper::calcSamples [$tbl columnindex SampleRoom] $tbl] }
			"sales"			{ set csmpls(SalesTotal)	[eAssistHelper::calcSamples [$tbl columnindex Sales] $tbl]}
			default			{ ${log}::notice -[info level 1]- Column -[$tbl columncget $col -name]- not found! }
    }
	
    ${log}::debug --END-- [info level 1]
} ;# eAssistHelper::detectColumn


proc eAssistHelper::calcSamples {columnIndex winpath} {
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

	set myList [string map [list \{\} 0] [$winpath getcolumn $columnIndex]]
	set returnCount [expr [join $myList +]]
	

	return $returnCount
    ${log}::debug --END -- [info level 1]
} ;# eAssistHelper::calcSamples


proc eAssistHelper::quickAddSmpls {win entryTxt} {
    #****f* quickAddSmpls/eAssistHelper
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
    ${log}::debug --START-- [info level 1]
    
	for {set x 0} {[$win columncount] > $x} {incr x} {
		#${log}::debug Column Names [$win columncget $x -name]
		set currentColumn [$win columncget $x -name]
		
		foreach value [array names csmpls] {
			if {[string match $value $currentColumn] == 1} {
				if {$csmpls($value) == 1} {
					$win fillcolumn $x $entryTxt
					eAssistHelper::detectColumn $win $x
					#set csmpls($value) [eAssistHelper::calcSamples $x $win]
				}
			}
		}
		
		
	}

    ${log}::debug --END-- [info level 1]
} ;# eAssistHelper::quickAddSmpls


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
	
	#${log}::debug Vers: $vers, Args: $args
	#return
    
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