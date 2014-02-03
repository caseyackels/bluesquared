# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 01 12,2014
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

namespace eval export {}

proc export::DataToExport {} {
    #****f* DataToExport/export
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Gather, and assemble the data to export. For Distribution.
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
    global log headerParent files mySettings job
    ${log}::debug --START-- [info level 1]
    
    
    ${log}::debug File Name: $mySettings(job,fileName)
	
	if {[info exists fileName]} {unset fileName}
	
	foreach value $mySettings(job,fileName) {
		switch -- $value {
			%number	{lappend fileName $job(Number)}
			%name	{lappend fileName $job(Name)}
			%title	{lappend fileName $job(Title)}
			default	{$log::notice Mapping for $value does not exist}
		}
	}
	set fileName [join $fileName]
	
	${log}::debug File Name: $fileName
    
    #set myFile(data) [open [file join [eAssist_Global::SaveFile $fileName]] w]
    set myFile(data) [catch {[open [eAssist_Global::SaveFile $fileName] w]} err]
    #${log}::debug Writing to file [file join $mySettings(outFilePath) Test_file.csv]
    if {[info exists err]} {return}
    
    # HEADER: Write output
    chan puts $myFile(data) [::csv::join $headerParent(outPutHeader)]
    ${log}::debug [::csv::join $headerParent(outPutHeader)]

    set rowCount [$files(tab3f2).tbl size]
    for {set x 0} {$rowCount > $x} {incr x} {
        # RECORDS: Write output one row at a time.
        chan puts $myFile(data) [::csv::join [join [$files(tab3f2).tbl get $x $x]]]
        ${log}::debug ROWS: [::csv::join [join [$files(tab3f2).tbl get $x $x]]]
    }
    
	chan close $myFile(data)
    ${log}::debug --END-- [info level 1]
} ;# export::DataToExport


proc export::ExportToPath {} {
    #****f* ExportToPath/export
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	What path do we want to save too
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
    
	
    ${log}::debug --END-- [info level 1]
} ;# export::ExportToPath
proc export::BatchToCSV {} {
    #****f* BatchToCSV/export
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Export the data into a CSV file
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
    
    
    
	
    ${log}::debug --END-- [info level 1]
} ;# export::BatchToCSV
