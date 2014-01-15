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
    global log headerParent files mySettings
    ${log}::debug --START-- [info level 1]
    
    
    set myFile(data) [open [file join $mySettings(outFilePath) Test_file.csv] w]
    ${log}::debug Writing to file [file join $mySettings(outFilePath) Test_file.csv]
    
    
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
