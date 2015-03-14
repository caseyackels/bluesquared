# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 01 12,2014
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 479 $
# $LastChangedBy: casey.ackels@gmail.com $
# $LastChangedDate: 2015-03-11 17:33:06 -0700 (Wed, 11 Mar 2015) $
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

    #if {[info exists mySettings(job,fileName)] != 1} {
    #    # Set the default format for the file name.
    #    set mySettings(job,fileName) "%number %title %name"
    #}
    
    foreach val [list Title Name Number] {
        if {![info exists job($val)]} {
            ${log}::debug Aborting... job($val) doesn't exist. Please fill in the $val field.
                set answer [tk_messageBox -message "Please put in a Job $val" \
                        -icon question -type yesno \
                        -detail "Select \"Yes\" to open the Project Setup window."]
                switch -- $answer {
                        yes {customer::projSetup}
                        no {exit}
                }
            return
            }
    }
    # Check to see if we need to output multiple files
    # What dist types do we have
    set distTypes [$job(db,Name) eval "SELECT distinct(DistributionType) from Addresses"]
    
    # Any on our black list?
    set dist_blacklist [list {07. UPS Import} {09. USPS Import} {13. FedEx Import}]

    if {[info exists newDist]} {unset newDist}
    foreach dist_ $dist_blacklist {
        if {[lsearch $distTypes $dist_] != -1} {
            lappend newDist '$dist_'
            #puts "total count: [$job(db,Name) eval "SELECT sum(Quantity) from Addresses WHERE DistributionType='$dist_'"]"
            ${log}::debug We need to create a separate file ...
        }
    }
    if {[info exists newDist]} {
        set newDist [join $newDist " OR "]
        
    } else {
        # Just in case we don't have any of the blacklist dist types in use
        set newDist ''
    }

    

    # Assemble the file names, and issue any warnings
    set fName [ea::tools::formatFileName]
    #set fileName $mySettings(job,fileName)
    #foreach item {Title Name Number} {
    #    set item2 [string tolower $item]
    #    #puts [string map [list %$item2 $job($item)] $mySettings(job,fileName)]
    #    set fileName [string map [list %$item2 [join $job($item) -]] $fileName]
    #    #${log}::debug FILENAME: [join $fileName]
    #}
    #set fName [join $fileName _]
            
    if {$newDist != {''} } {
        set fileNameList [list planner batch]
    } else {
        set fileNameList [list planner]
        
    }
        
    foreach file_Name $fileNameList {
        set fileName [join "$fName $file_Name" _]
        
        # don't open the file yet, because we may have canceled the Save As dialog...
        set myFile(data) [file join [eAssist_Global::SaveFile $fileName $job(SaveFileLocation)]]
        
            #${log}::debug myFile(data): $myFile(data)

        if {$myFile(data) eq {}} {
            ${log}::notice Aborting... The Save As window was closed without a file name.
            return
        } else {
            if {[file exists $myFile(data)] && ![file writable $myFile(data)]} {
                tk_messageBox -message "The file is open in another program, please close before exporting." \
                                -icon warning -type ok \
                                -detail "$myFile(data)"
                return
            } else {
                set fd [open $myFile(data) w]
            }
        }
        if {$file_Name eq "planner"} {
            set id [$job(db,Name) eval "SELECT OrderNumber FROM Addresses WHERE DistributionType != $newDist"]
        } else {
            set id [$job(db,Name) eval "SELECT OrderNumber FROM Addresses WHERE DistributionType == $newDist"]
        }
        export::toFile $id $fd
        chan close $fd
    }

} ;# export::DataToExport


proc export::toFile {id fd} {
    #****f* batchFile/export
    # CREATION DATE
    #   02/27/2015 (Friday Feb 27)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   export::batchFile id fname
    #
    # FUNCTION
    #	Outputs the batch files for *imports*
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
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log files job
    
    set tmpHdr [job::db::retrieveHeaderNames $job(db,Name) Addresses]
    set tmpHdr [string map {ShipVia ShipViaCode} $tmpHdr]
    catch {$job(db,Name) eval "ATTACH 'EA_setup.edb' as db1"}

    # HEADER: Write output
    # OrderType is a hardcoded value, this should be moved to a user option.
    #   OrderType is the Column name, Version is the value.
    if {[info exists colNames]} {unset colNames}
    set colCount [$files(tab3f2).tbl columncount]
    for {set x 0} {$colCount > $x} {incr x} {
        set tblName [$files(tab3f2).tbl columncget $x -name]
        # Just in case the header doesn't exist in the db; but we have it in the tablelist...
        set outputColNames [db eval "SELECT OutputHeaderName FROM Headers where InternalHeaderName='$tblName'"]
        
        if {$outputColNames eq ""} {
            lappend colNames [$files(tab3f2).tbl columncget $x -name]
        } else {
            lappend colNames $outputColNames
        }
    }
    # Write the headers
    chan puts $fd [::csv::join "$colNames OrderType"]
    

    # Write the data
    foreach item $id {
            set record [$job(db,Name) eval "select [join $tmpHdr ,] from Addresses INNER JOIN db1.ShipVia ON Addresses.ShipVia = db1.ShipVia.ShipViaName WHERE OrderNumber='$item'"]
            #${log}::debug $record
            chan puts $fd [::csv::join "$record Version"]
    }

    
    
} ;# export::toFile


