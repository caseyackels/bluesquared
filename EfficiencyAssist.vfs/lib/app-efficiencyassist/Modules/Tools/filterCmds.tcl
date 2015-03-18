# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 01/05/2014
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 169 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2014-09-14 21:48:00 -0700 (Sun, 14 Sep 2014) $
#
########################################################################################

##
## - Overview
# Overview

namespace eval ea::filter {}

proc ea::filter::runFilters {widTbl columns} {
    #****f* runFilters/ea::filter
    # CREATION DATE
    #   03/18/2015 (Wednesday Mar 18)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::filter::runFilters <tablelist widget path> <list of columns> 
    #
    # FUNCTION
    #	Cycles through the given columns and strips high-ascii from the data
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
    global log job
	set filters [list ea::filter::stripASCII_CC ea::filter::stripExtraSpaces ea::filter::stripUDL ea::filter::abbrvAddrState]
	
	${log}::debug Running [llength $filters] filters, on [llength $columns] Columns!

	# Cycling through the columns
    foreach col $columns {
		# Retrieve column data
		${log}::debug Column: $col
        set colData [$widTbl getcolumns $col]
        set i_row 0
		# Cycling through the data
        foreach item $colData {
			# Running the filters
			#${log}::debug row/item: $i_row / $item
			if {$item == ""} {continue} ;# Don't try to process if there isn't data
			foreach current_filter $filters {
				${log}::debug Running $current_filter ...
				set data [$current_filter $item $col]
			}
			if {![string match $item $data]} {
				# Only write the data and update the widget if data has changed ...
				job::db::write $job(db,Name) Addresses $data $widTbl $i_row,$col
				${log}::debug CLEAN DATA: $data
			}
            incr i_row
        }
	}
	${log}::debug Finished!
} ;# ea::filter::runFilters $files(tab3f2).tbl {Company Attention Address1 Address2 City State}


proc ea::filter::stripASCII_CC {cellData args} {
    #****f* stripASCII_CC/ea::filter
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Strip Hi-Bit ASCII and Control Characters
    #
    # SYNOPSIS
    #
    #
    # CHILDREN
    #	
    #
    # PARENTS
    #	
    #
    # NOTES
    #   Found on rosettacode.org; modified from original finding.
    #   http://www.unicode.org/charts/PDF/U0000.pdf
    #
    # SEE ALSO
    #
    #***
    global log filter counter
    
    #set newString [eAssist_tools::stripExtraSpaces [regsub -all {[^\u0020-\u007e]+} $cellData ""]]
    set newString [regsub -all {[^\u0020-\u007e]+} $cellData ""]
    set newString [join $newString]

    return $newString
} ;# ea::filter::stripASCII_CC


proc eAssist_tools::stripCC {cellData} {
    #****f* stripCC/eAssist_tools
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Only strip Control Characters
    #
    # SYNOPSIS
    #
    #
    # CHILDREN
    #
    #
    # PARENTS
    #	
    #
    # NOTES
    #   Found on: rosettacode.org
    #
    # SEE ALSO
    #
    #***
    global log filter counter
    #${log}::debug --START-- [info level 1]
    #if {$filter(run,stripCC) != 1} {${log}::debug Filter not set; return}
    
    #set newString [eAssist_tools::stripExtraSpaces [regsub -all {[\u0000-\u001f][\u007f]+} $cellData ""]]
    set newString [regsub -all {[\u0000-\u001f][\u007f]+} $cellData ""]
    set newString [join $newString]

    #$filter(f2).progbar step
    incr filter(progbarProgress)
    incr counter
    update
	return $newString
    #${log}::debug --END-- [info level 1]
} ;# eAssist_tools::stripCC


proc eAssist_tools::stripQuotes {cellData} {
    #****f* stripQuotes/eAssist_tools
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Strip Quotes from string
    #
    # SYNOPSIS
    #
    #
    # CHILDREN
    #	eAssist_tools::stripExtraSpaces
    #
    # PARENTS
    #	
    #
    # NOTES
    #   
    #
    # SEE ALSO
    #
    #***
    global log filter counter
    #${log}::debug --START-- [info level 1]
    
    #set newString [eAssist_tools::stripExtraSpaces [string map [list \" ""] $cellData]]
    set newString [string map [list \" ""] $cellData]
	set newString [join $newString]
    
    #$filter(f2).progbar step
    incr filter(progbarProgress)
    incr counter
    update
    return $newString
    #${log}::debug --END-- [info level 1]
} ;# eAssist_tools::stripQuotes


proc ea::filter::stripExtraSpaces {cellData args} {
    #****f* stripExtraSpaces/ea::filter
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Strip additional spaces in a string
    #
    # SYNOPSIS
    #
    #
    # CHILDREN
    #	
    #
    # PARENTS
    #
    #
    # NOTES
    #   
    #
    # SEE ALSO
    #
    #***
    global log filter
   
    # ... strip extra spaces
    if {$cellData == {} } {
        return
    }
    
    foreach value [split $cellData { }] {
        if {$value != {}} {
            lappend newString [string trim $value]
        }
        #lappend newString [join [string trim $value]]
    }
	
    set newString [join $newString]

    return $newString
} ;# ea::filter::stripExtraSpaces 


proc ea::filter::stripUDL {cellData args} {
    #****f* stripUDL/ea::filter
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Using a "User Defined List (UDL)", strip characters from string
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

	# This will need to reference a saved list from the users profile/preferences file.
    set StripChars [list ' ` ~ . ? ! _ , : | $ ! + = ( ) ~]
    
    set newString $cellData

    foreach value $StripChars {
        #set newString [join [eAssist_tools::stripExtraSpaces [string map [list [concat \ $value] ""] $newString]]]
        set newString [join [string map [list [concat \ $value] ""] $newString]]
    }
} ;# ea::filter::stripUDL


proc eAssistHelper::runFilters {} {
    #****f* runFilters/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Setups the loop before executing the filters
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
    global log files headerParams filter counter
    #${log}::debug --START-- [info level 1]
    
    set filter(progbarProgess) 0 ;# reset the progressbar before continuing
	# Grab the list of columns that we want to execute on, then get a count of how many. This will allow us to only execute on desired columns, and bypass certain columns.
    set ColumnCount [$files(tab3f2).tbl columncount]
    
	set RowCount [llength [$files(tab3f2).tbl getcells 0,0 end,0]]
    
    # build the runlist to determine which filters to run
    if {[info exists filter(runList)]} {unset filter(runList)}
    if {[info exists counter]} {unset counter}
    
    # ... get the values from the checkbuttons in the Filter Editor
    foreach value [array names filter] {
        if {[string match run,* $value] eq 1} {
            if {$filter($value) eq 1} {
                lappend filter(runList) [string trimleft $value run,]
            }
        }
    }
    # Check to make sure we have data in the runList, if we don't, set to 0.
    if {![info exists filter(runList)]} {
        set filter(runList) 0
    }
    
    # filter(runList) could have the list of selected filters; or a single '0'. Regardless if we have a single filter, or '0'; lets specify the length as 2.
    if {[llength $filter(runList)] == 1} {
        if {![string is integer $filter(runList)]} {
            set filterLength 2
            ${log}::debug filterLength-1a: $filterLength
        } else {
            set filterLength 1
            ${log}::debug filterLength-1b: $filterLength
        }
    } else {
        set filterLength [expr [llength $filter(runList)] + 1]
        ${log}::debug filterLength-2: $filterLength
    }
    
    #return
    
    set data [$files(tab3f2).tbl getcells 0,0 end,end]
    # .. add 1 for the 'always run' filter
    foreach val $data {
        if {$val != {} } {incr counter1}
    }

    
    set progressBarMax [expr $filterLength * $counter1]
    ${log}::debug progressBarMax: $progressBarMax

    # Set the max length for the progress bar
    set progMax $progressBarMax ;# number of filters plus 2 for before and after the filters run.
    #${log}::debug ProgBar: $progMax
    $filter(f2).progbar configure -maximum $progMax
    

    set filter(progbarFilterName) [mc "Starting the filters"]
    
    # This allows us to only filter on certain columns. The only column that we may want, is Notes, but we will want a special Punctuation filter for it.
    set colBlackList [list Company Attention Address1 Address2 Address3 City State Zip Phone Quantity]
    foreach col $colBlackList {
        lappend idxCols [$files(tab3f2).tbl columnindex $col]
    }
	
    #foreach value $filter(runList) {}      
        # Master loop to cycle through each cell.
        # Rows
        for {set x 0} {$RowCount > $x} {incr x} {
            if {$filter(stopRunning) == 1} {return}
            set filter(progbarFilterName) [mc "Running $filterLength Filters..."]
            update
            
            # Columns
            #for {set y 0} {$ColumnCount > $y} {incr y} {}
            foreach y $idxCols {

                set ColumnName [$files(tab3f2).tbl columncget $y -name]
                #${log}::debug Column Name: $ColumnName
                
                set cellData [eAssist_tools::stripExtraSpaces [$files(tab3f2).tbl getcell $x,$y]]
                if {$cellData == {}} {incr filter(progbarProgress); update; continue} ;# Skip the empty cells
                
                # This filter should always run
                set cellData [eAssist_tools::stripQuotes $cellData]
                incr counter2
                
                
                # Start Filters
                if {$filter(runList) != 0} {
                    foreach val $filter(runList) {
                        set cellData [join [eAssist_tools::$val $cellData $ColumnName]]
                    }
                }
    
                if {[string length $cellData] > [lindex $headerParams($ColumnName) 0]} {
                    # Set the background color
                    ${log}::debug CellData greater than set parameter: $cellData
                    if {[lindex $headerParams($ColumnName) 3] != ""} {
                        set backGround [lindex $headerParams($ColumnName) 3]
                        ${log}::debug Background color set for: $ColumnName
                    } else {
                        # default to yellow
                        set backGround yellow
                        ${log}::debug No Background color set, Defaulting: $ColumnName
                    }
                } else {
                    set backGround ""
                    #${log}::debug Passed the min. parameter: $ColumnName-$cellData
                }
                
                if {$cellData != ""} {$files(tab3f2).tbl cellconfigure $x,$y -text $cellData -bg $backGround}
                      
            }
        } ;# End masterloop

    set filter(progbarFilterName) "Filters ... Complete"
    update
    
    ${log}::debug Number of cells: $data
    ${log}::debug Length of ProgressBar: $progressBarMax
    ${log}::debug First Counter Total: $counter1
    ${log}::debug Second Counter Total: $counter2
    ${log}::debug Filter Counter Total: $counter
    ${log}::debug Run List Length: [llength $filter(runList)]
    #${log}::debug --END-- [info level 1]
} ;# eAssistHelper::runFilters


proc ea::filter::abbrvAddrState {cellData args} {
    #****f* abbrvAddrState/ea::filter
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Abbreviate the addresses and states from most likely words to known abbreviations.
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
    global log filter counter
    #${log}::debug --START-- [info level 1]
    #if {$filter(run,abbrvAddrState) != 1} {${log}::debug Filter not set; return}
    
    # Keep source cellData and output cellData separate
    set cellDataWorking [string tolower $cellData]
    set cellDataOrig $cellData
    set newString ""
    set whatChanged "Nothing Changed:"
    
    ## Stop processing if we aren't on a column that we want to process
    switch -- $args {
        Address1    {}
        Address2    {}
        State       {}
        default     {return $cellData}
    }
    
    # Run the data through the filters only if it exists for the corresponding column name  
    # Address 1 and 2, need multiple passes.
    if {$args eq "Address1"} {
        #${log}::debug Before changes: $cellData
        
        # Cycle through our list of suffices to match against our cellData; if they do then lets map the words to our abbreviations
        foreach item [string tolower $filter(addrStreetSuffix)] {
            set newItem [lsearch $cellDataWorking $item]
            
            if {$newItem != -1} {
                set prefix [lrange $cellDataWorking 0 [expr {$newItem} -1]]
                ${log}::debug Prefix: $prefix
                
                set suffix [lrange $cellDataWorking $newItem end]
                ${log}::debug Suffix: $suffix
                
                #set suffix [join [string map $filter(addrStreetSuffix) $suffix]]
                set suffix [string map [string tolower $filter(addrStreetSuffix)] $suffix]
                
                set suffix [string map [string tolower $filter(secondaryUnits)] $suffix]
                ${log}::debug Changed Suffix: $suffix
                
                set cellData [string totitle "$prefix $suffix"]
                ${log}::debug New Cell Data: $cellData
            }
        }
        if {[string compare $cellDataWorking [string tolower $cellData]] != 0} {
            set whatChanged "Address1 Changed:"
        }
    }
    
    # No need to cycle over lists that probably would never apply....
    if {$args eq "Address2"} {
        set cellData [string map $filter(secondaryUnits) $cellDataWorking]
        
        if {[string compare $cellDataWorking [string tolower $cellData]] != 0} {
            set whatChanged "Address2 Changed:"
        }
    }
    
    if {$args eq "State"} {
        #set cellData [string map $filter(StateList) $cellDataWorking]
        
        if {[string compare $cellDataWorking [string tolower $cellData]] != 0} {
            set whatChanged "State Changed:"
        }
    }
    
    # Set Title Case
    set cellData [list {*}$cellData]
    if {[info exists newString]} {unset newString}
    foreach word $cellData {
        # Ensure that we set items with only one list item to all upper case.
        if {[llength $cellData] == 1} {
            set Case toupper
        } else {
            set Case totitle
        }
        
        lappend newString [string $Case $word]
    }
    
    if {![info exists newString]} {set newString $cellData}
    ${log}::notice $whatChanged $cellDataOrig -to- $newString
    
    #$filter(f2).progbar step
    #return $cellData
    #incr filter(progbarProgress)
    #update
    return $newString
    #${log}::debug --END-- [info level 1]
} ;# ea::filter::abbrvAddrState
