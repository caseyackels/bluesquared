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
# $LastChangedDate: 2011-10-17 16:11:20 -0700 (Mon, 17 Oct 2011) $
#
########################################################################################

##
## - Overview
# Overview

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

proc eAssist_tools::stripASCII_CC {args} {
    #****f* stripASCII_CC/eAssist_tools
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Strip ASCII and Control Characters
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
    #   Found on rosettacode.org
    #
    # SEE ALSO
    #
    #***
    global log
    ${log}::debug --START-- [info level 1]
    
    eAssist_tools::stripExtraSpaces [regsub -all {[\u0000-\u001f\u007f]+} $args ""]
	
    ${log}::debug --END-- [info level 1]
} ;# eAssist_tools::stripASCII_CC


proc eAssist_tools::stripCC {args} {
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
    #	eAssist_tools::stripExtraSpaces
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
    global log
    ${log}::debug --START-- [info level 1]
    
    eAssist_tools::stripExtraSpaces [regsub -all {[^\u0020-\u007e]+} $args ""]

	
    ${log}::debug --END-- [info level 1]
} ;# eAssist_tools::stripCC


proc eAssist_tools::stripQuotes {args} {
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
    global log
    ${log}::debug --START-- [info level 1]
    
    eAssist_tools::stripExtraSpaces [string map [list \" ""] $args]
	
    ${log}::debug --END-- [info level 1]
} ;# eAssist_tools::stripQuotes


proc eAssist_tools::stripExtraSpaces {args} {
    #****f* stripExtraSpaces/eAssist_tools
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
    global log
    ${log}::debug --START-- [info level 1]
    
    # ... ensure newString doesn't exist, or else we'll add to it in the next step
    if {[info exists newString]} {unset newString}
    
    # ... strip extra spaces
    foreach value [split $args { }] {
        if {$value != {}} {
            lappend newString [string trim $value]
            }
    }
	
    ${log}::debug --END-- [info level 1]
} ;# eAssist_tools::stripExtraSpaces


proc eAssist_tools::stripUDL {args} {
    #****f* stripUDL/eAssist_tools
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
    ${log}::debug --START-- [info level 1]
    
	# This will need to reference a saved List from the users profile/preferences file.
    set StripChars [list . ? ! _ , : | $ ! + =]
    
    set newString $args

    foreach value $StripChars {
        set newString [eAssist_tools::stripExtraSpaces [string map [list [concat \ $value] ""] $newString]]
    }
    ${log}::debug --END-- [info level 1]
} ;# eAssist_tools::stripUDL


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
    global log files headerParams filter
    ${log}::debug --START -- [info level 1]
    
	#${log}::debug Addresses: [$files(tab3f2).tbl getcells 0,end]
	set ColumnCount [$files(tab3f2).tbl columncount]
	set RowCount [llength [$files(tab3f2).tbl getcells 0,0 end,0]]
	
	${log}::debug ColumnCount: $ColumnCount
	${log}::debug RowCount: $RowCount
	
	# Retrieve the column names, so we know if we have a second or third address field.
	# Columns
	for {set y 0} {$ColumnCount > $y} {incr y} {
		lappend ColumnName1 [$files(tab3f2).tbl columncget $y -name]
	}
	
	${log}::debug ColumnNames: $ColumnName1
	set haveAddress2 [lsearch $ColumnName1 Address2]
	set haveAddress3 [lsearch $ColumnName1 Address3]

	
	set byPass ""
	set cellNumber ""
	
	# List the qualified filters
    # This should be a user option.
	set filter(Address1) ""
	set filter(Address2) ""
	set filter(State) ""
	
	# Rows
	for {set x 0} {$RowCount > $x} {incr x} {
		# Columns
		for {set y 0} {$ColumnCount > $y} {incr y} {
			set ColumnName [$files(tab3f2).tbl columncget $y -name]
			
			# If we haven't set up any params for the header, lets make sure we skip it.
			if {[lsearch [array names headerParams] $ColumnName] != -1} {
				set maxChar [lindex $headerParams($ColumnName) 0]
				} else {
					set byPass 1
				}

			set cellData [string tolower [join [$files(tab3f2).tbl getcells $x,$y $x,$y] ""]]
			
            
            # Start Filters

			# Keep track of the cells which contain more data than they should
			if {$byPass != 1} {
				#${log}::debug Bypass is not activated - $cellData
				if {[string length $cellData] > $maxChar} {
					lappend cellNumber $y
				}
			}
			lappend newRow [string toupper $cellData]
		}
		# We must first delete the existing row, then insert the new row.
		$files(tab3f2).tbl delete $x
		$files(tab3f2).tbl insert $x $newRow
		
		# Now we can highlight the appropriate cells if the data still exceeds the MaxChar requirements
		if {$cellNumber != ""} {
			#${log}::debug cellNumber contains: $cellNumber
			foreach column $cellNumber {
					#set column [expr $column -1] ;# Columns start at 0
					set hdName [$files(tab3f2).tbl columncget $column -name]
					
					if {[lindex $headerParams($hdName) 3] != ""} {
						set backGround [lindex $headerParams($hdName) 3]
					} else {
						set backGround yellow
					}
					$files(tab3f2).tbl cellconfigure $x,$column -bg $backGround
			}
		}
		
		unset newRow
		set cellNumber ""
		set byPass ""
	}

    ${log}::debug --END -- [info level 1]
} ;# eAssistHelper::runFilters


proc eAssist_tools::abbrvAddrState {cellData ColumnName} {
    #****f* abbrvAddrState/eAssist_tools
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Setup the frame work, and run the filters.
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
    global log filter
    ${log}::debug --START-- [info level 1]
    # Run the data through the filters only if it exists for the corresponding column name  
    # Address 1 and 2, need multiple passes.
    if {$ColumnName eq "Address1"} {
        ${log}::debug Before changes: $cellData
        
        # Cycle through our list of suffices to match against our cellData; if they do then lets map the words to our abbreviations
        foreach item $filter(addrStreetSuffix) {
            set newItem [lsearch $cellData $item]
            
            if {$newItem != -1} {
                set prefix [lrange $cellData 0 [expr {$newItem} -1]]
                #${log}::debug Prefix: $prefix
                
                set suffix [lrange $cellData $newItem end]
                #${log}::debug Suffix: $suffix
                
                #set suffix [join [string map $filter(addrStreetSuffix) $suffix]]
                set suffix [string map $filter(addrStreetSuffix) $suffix]
                
                set suffix [string map $filter(secondaryUnits) $suffix]
                #${log}::debug Changed Suffix: $suffix
                
                set cellData "$prefix $suffix"
                #${log}::debug New Cell Data: $cellData
            }
        }
        ${log}::debug Street Suffix Changes: $cellData
    }
    
    # No need to cycle over lists that probably would never apply....
    if {$ColumnName eq "Address2"} {
        set cellData [string map $filter(secondaryUnits) $cellData]
    }
    
    if {$ColumnName eq "State"} {
        #if {[lsearch $filter(State) $cellData] == -1} {${log}::debug State doesn't exist $cellData}
        ${log}::debug State Before: $cellData
        set cellData [string map $filter(StateList) $cellData]
        ${log}::debug State After: $cellData
    }
    ${log}::debug --END-- [info level 1]
} ;# eAssist_tools::abbrvAddrState


Execute Filters
            set cellData [eAssistHelper::filters $ColumnName $filter(sanitizeColumns)] ;# uses the filter array to figure out which columns to execute on
            set cellData [eAssist_tools::stripASCII_CC $cellData]
            set cellData [eAssist_tools::stripCC $cellData]
            set cellData [eAssist_tools::stripUDL $cellData]
            
proc eAssist_tools::executeFilters {args} {
    #****f* executeFilters/eAssist_tools
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Assemble variable's that contain the name of the filters; that way the setupFilter command can execute them.
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
    global log filter
    ${log}::debug --START-- [info level 1]
    
    
    
    lappend filter(RunList) $args
	
    
    ${log}::debug --END-- [info level 1]
} ;# eAssist_tools::executeFilters
