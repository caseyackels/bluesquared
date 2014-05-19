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
    
    
    if {[info exists mySettings(job,fileName)] != 1} {
        ${log}::debug Job number is not filled in!
        return
    }
    
    foreach val [list Number Name Title] {
        if {![info exists job($val)]} {
            ${log}::debug Aborting... job($val) doesn't exist. Please fill in the $val field.
            return
            }
    }
    
    ${log}::notice Default file name: $mySettings(job,fileName)
	
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
	
	${log}::debug Actual file name: $fileName
    
    #set myFile(data) [open [file join [eAssist_Global::SaveFile $fileName]] w]
    set myFile(data) [catch {[open [eAssist_Global::SaveFile $fileName] w]} err]
    #${log}::debug Writing to file [file join $mySettings(outFilePath) Test_file.csv]
    if {[info exists err]} {
        ${log}::notice Aborting... The Save As window was closed without a file name.
        ${log}::debug ERROR: $err
        return
    }
    
        
    # HEADER: Write output
    # OrderType is a hardcoded value, this should be moved to a user option.
    chan puts $myFile(data) [::csv::join "OrderNumber $headerParent(outPutHeader) OrderType"]
    ${log}::debug [::csv::join "OrderNumber $headerParent(outPutHeader) OrderType"]

    set rowCount [$files(tab3f2).tbl size]
    for {set x 0} {$rowCount > $x} {incr x} {
        # RECORDS: Write output one row at a time.
        # Version is a hardcoded value, this should be moved to a user option.
        chan puts $myFile(data) [::csv::join "[$files(tab3f2).tbl get $x] Version"]
        #chan puts $myFile(data) [::csv::join [join [$files(tab3f2).tbl get $x $x]]]
        ${log}::debug ROWS: [::csv::join "[$files(tab3f2).tbl get $x] Version"]
    }
    
	chan close $myFile(data)
    ${log}::debug --END-- [info level 1]
} ;# export::DataToExport


