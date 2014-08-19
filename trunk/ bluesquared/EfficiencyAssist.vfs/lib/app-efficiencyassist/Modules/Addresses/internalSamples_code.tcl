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
    global log csmpls
    ${log}::debug --START-- [info level 1]

	# This table only contains columns which require integers only. So, we can make this a global requirement.
	
	if {![string is integer $text]} {
		bell
		tk_messageBox -title "Error" -icon error -message \
									[mc "Only numbers are allowed"]
		$tbl rejectinput
		return
	}
	
	eAssistHelper::detectColumn $tbl $row $col $text
   
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
	# This table only contains columns which require integers only. So, we can make this a global requirement.
	
	if {![string is integer $text]} {
		bell
		tk_messageBox -title "Error" -icon error -message \
									[mc "Only numbers are allowed"]
		$tbl rejectinput
		return
	}
	
	
	eAssistHelper::detectColumn $tbl $row $col $text
    
    return $text

    ${log}::debug --END-- [info level 1]
} ;# eAssistHelper::editEndSmpl


proc eAssistHelper::detectColumn {tbl row {col 0} {text 0}} {
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
	# 	eAssistHelper::detectColumn <tbl> <row> ?column? ?text?
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
	
	# Update the internal list with the current text so that we can run calculations on it.
	if {$row != ""} {
		$tbl cellconfigure $row,$col -text $text
	}

	switch -glob [string tolower [$tbl columncget $col -name]] {
            "ticket"		{ set csmpls(TicketTotal)	[eAssistHelper::calcSamples $tbl $col] }
            "csr"			{ set csmpls(CSRTotal)		[eAssistHelper::calcSamples $tbl $col] }
            "sampleroom"	{ set csmpls(SmplRoomTotal) [eAssistHelper::calcSamples $tbl $col] }
			"sales"			{ set csmpls(SalesTotal)	[eAssistHelper::calcSamples $tbl $col] }
			default			{ ${log}::notice -[info level 1]- Column -[$tbl columncget $col -name]- not found! }
    }
	
    ${log}::debug --END-- [info level 1]
} ;# eAssistHelper::detectColumn


proc eAssistHelper::calcSamples {tbl col} {
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
    #	eAssistHelper::calcSamples <tbl> <col>
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

	set myList [string map [list \{\} 0] [$tbl getcolumn $col]]
	set returnCount [catch {expr [join $myList +]} err]
	#${log}::debug Column Count: $returnCount
	
	if {$returnCount == 1} {
		Error_Message::errorMsg BM001
		#${log}::debug Cannot sum quantity, Alpha-Numerics!
		#${log}::debug Error: $err
		#${log}::debug myList: $myList
		#${log}::debug Return: $returnCount
		return
	} else {
		# err, will contain the total count.
		set returnCount $err
		#${log}::debug ColumnCount(returnCount): $returnCount
	}
	

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
    global log csmpls w
    ${log}::debug --START-- [info level 1]
    
	for {set x 0} {[$win columncount] > $x} {incr x} {
		#${log}::debug Column Names [$win columncget $x -name]
		set currentColumn [$win columncget $x -name]
		
		foreach value [array names csmpls] {
			if {[string match $value $currentColumn] == 1} {
				if {$csmpls($value) == 1} {
					$win fillcolumn $x $entryTxt
					eAssistHelper::detectColumn $win "" $x
					# Reset the checkbutton
					set csmpls($value) 0

				}
			}
		}
	}
	
	# Clear the entry widget
	$w(csmpls.f2).addEntry delete 0 end

    ${log}::debug --END-- [info level 1]
} ;# eAssistHelper::quickAddSmpls


proc eAssistHelper::saveCSMPLS {tblFrom tblTo} {
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
    #	eAssistHelper::saveCSMPLS <tbl>
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
	
	set columnCount [$tblTo columncount]
	set rowCount [$tblFrom size]
	
	for {set x 0} {$rowCount > $x} {incr x} {
		set vers [lindex $process(versionList) $x]
		# add up all listed quantities
		set tmpList [string map [list \{\} 0] [lrange [$tblFrom get $x] 2 end]]
		set returnCount [expr [join $tmpList +]]
		
		# Reset for each row
		if {[info exists insertCompany]} {unset insertCompany}
		
		for {set i 0} {$columnCount > $i} {incr i} {
			set col [string tolower [$files(tab3f2).tbl columncget $i -name]]
			${log}::debug Column: $col
			#puts [lsearch [array names company] $col]

			set companyIndex [lsearch [array names company] $col]
			if {$companyIndex ne -1} {
				lappend insertCompany $company([lindex [array names company] $companyIndex])
			
			} else {
				switch -nocase $col {
					version				{lappend insertCompany $vers}
					quantity			{lappend insertCompany $returnCount}
					distributiontype	{lappend insertCompany $csmpls(distributionType)}
					packagetype			{lappend insertCompany $csmpls(packageType)}
					default				{lappend insertCompany ""}
				}
			}
		}
		

		# .. finally, we'll insert the compiled data
		if {$returnCount != 0} {
			# If we received any counts, other than 0, lets insert a row for it.
			${log}::debug INSERT: $tblTo $insertCompany
			$tblTo insert end $insertCompany
			#puts "tblTo $insertCompany"
		}
	}  
	
    ${log}::debug --END-- [info level 1]
} ;# eAssistHelper::saveCSMPLS