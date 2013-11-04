# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 10 07,2013
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
# Code for Batch Addresss

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


proc importFiles::readFile {fileName} {
    #****f* readFile/importFiles
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Description
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
    global log process files
    ${log}::debug --START-- [info level 1]
    ${log}::debug file name: $fileName
    ${log}::debug file tail: [file tail $fileName]
    
    if {$fileName eq ""} {return}
    
    set process(fileName) [file tail $fileName] ;# retrieve just the file name, so we can display it in a friendly matter
    
    # Open the file
    set process(fd) [open "$fileName" RDONLY]

    # Make the data useful, and put it into lists
    # While we are at it, make everything UPPER CASE
    #while {-1 != [gets $fp line]}
    while { [gets $process(fd) line] >= 0 } {
        # Guard against lines of comma's, this will not be viewable in excel. Only in a text editor.
        if {[string is punc [join [split [string trim $line] " "] ""]] eq 1} {continue}

        lappend process(dataList) [string toupper $line]
    }
    
    ${log}::debug *RECORDS*: [expr [llength $process(dataList)]-1]
    set process(numOfRecords) [expr [llength $process(dataList)]-1]

    chan close $process(fd)

    # Only retrieve the first record. We use this as the 'header' row.
    set process(Header) [string toupper [csv::split [lindex $process(dataList) 0]]]
    ${log}::debug process(Header): $process(Header)
    
    set process(dataList) [lrange $process(dataList) 1 end] ;#we don't want the header, so lets capture everything but.

    
    foreach header $process(Header) {
        if {$process(Header) != ""} {
            ${log}::debug header: $header
            $files(tab1f1).listbox insert end $header
        } else {
            # In the future we may want to alert on empty header names.
            $files(tab1f1).listbox insert end $header
        }
    }
    ${log}::debug --END [info level 1]
} ;# importFiles::readFile


proc importFiles::processFile {} {
    #****f* processFile/importFiles
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Description
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
    global log files headerAddress position process headerParams dist
    ${log}::debug --START-- [info level 1]

    
    # Set the available headers
    ${log}::debug Remaining Available Headers : [$files(tab1f2).listbox get 0 end]
    
    foreach listItem [$files(tab1f2).listbox get 0 end] {
        set itemPosition [lsearch [$files(tab1f2).listbox get 0 end] $listItem]
        
        set itemColor [$files(tab1f2).listbox itemcget $itemPosition -foreground]
        
        if {[string compare $itemColor "lightgrey"] != 0} {
            $files(tab3f1a).lbox1 insert end $listItem
            ${log}::debug Remaining Available Headers : $listItem
        }
    }
    
    # Create the columns in the Table, using parameters assigned to each 'column type', from Setup. Located in the headerParams array.
    set x -1
    foreach header [lsort [array names position]] {
        incr x
        
        # Strips the leading 00_ from the header to make it look nicer.
        set newHeader [lrange [split $header _] 1 1]
        
        $files(tab3f2).tbl insertcolumns end 0 $newHeader
        
        # 2 = Widget (ttk::entry, or ttk::combobox) position
        set myWidget [lindex $headerParams($newHeader) 2]
        
        if {$myWidget == ""} {
            # Just in case an entry wasn't filled out, lets make a default.
            set myWidget ttk::entry
        }
                
        ## Default configuration for all other columns.
        $files(tab3f2).tbl columnconfigure $x \
                                        -name $newHeader \
                                        -labelalign center \
                                        -editable yes \
                                        -editwindow $myWidget
        
    }
    
    # Insert Required columns at the end
    #${log}::debug COLUMNCOUNT (Before Dist Type): [$files(tab3f2).tbl columncount]
    $files(tab3f2).tbl insertcolumns end 0 DistributionType
    #${log}::debug COLUMNCOUNT ('after Dist Type): [$files(tab3f2).tbl columncount]
    $files(tab3f2).tbl columnconfigure [expr [$files(tab3f2).tbl columncount] -1] -name DistType -labelalign center -editable yes -editwindow ttk::combobox 
    

    set process(versionList) ""
    set rowMaxChar ""
    set columnMaxChar ""
    
    foreach record $process(dataList) {
        if {[string is punc $record] == 1} {continue}

        set l_line [csv::split $record]
        set l_line [join [split $l_line ,] ""] ;# remove all comma's
        #l_line = entire row of records
        #name = (eg 00_Version) Header Name (will be used to create the column names in the Planner Tab)
        #[lindex $l_line $index] = Individual record
        #index = index/column position of record.
        foreach name [lsort [array names position]] {

            set index [lrange [split $name _] 0 0]
            set bareName [lrange [split $name _] 1 1]
            if {[string compare $index 00] == 0} {
                # This is the first record so we only want to strip the leading 0, not both.
                set index 0
            } else {
                set index [string trimleft $index 0]
            }

            # Build the list of versions, making sure to only capture unique entries
            switch -glob [string tolower $name] {
                                        *version {
                                                #${log}::debug ALL VERSIONS : [lindex $l_line $index]
                                                if {[lsearch $process(versionList) [lindex $l_line $index]] == -1} {
                                                    lappend process(versionList) [lindex $l_line $index]}
                                                    #${log}::debug UNIQUE VERSION : [lindex $l_line $index]
                                                }
                                        default {}
            }
            #${log}::debug Processing Name/Value: $name : [lindex $l_line $index]
            #${log}::debug Max Length: [lindex $headerParams($bareName) 0]
            
            lappend nextRow [string trim [lindex $l_line $index]]
            
            set dataList [string trim [join [split [lindex $l_line $index]]]]
            set maxChar [lindex $headerParams($bareName) 0]
            
            if {[string length $dataList] > $maxChar} {
                ${log}::debug **CRITICAL** $bareName / $dataList - Contains [string length $dataList] chars!!

                set myRow [catch {$files(tab3f2).tbl getcells 0,0 end,0} err]

                if {$myRow != 1} {
                    lappend rowMaxChar [llength [$files(tab3f2).tbl getcells 0,0 end,0]]
                } else {
                    lappend rowMaxChar 0
                }
                lappend columnMaxChar [llength $nextRow]
                
            }
        }

        $files(tab3f2).tbl insert end $nextRow

        #${log}::debug Total Rows/Columns: $rowMaxChar/$columnMaxChar

        foreach row $rowMaxChar {
            foreach column $columnMaxChar {
                set column [expr $column -1] ;# Columns start at 0
                set hdName [$files(tab3f2).tbl columncget $column -name]
                
                if {[lindex $headerParams($hdName) 3] != ""} {
                    set backGround [lindex $headerParams($hdName) 3]
                } else {
                    set backGround yellow
                }
                $files(tab3f2).tbl cellconfigure $row,$column -bg $backGround
                
                #${log}::debug Row: $row - Column: $column - [$files(tab3f2).tbl getcells $row,$column $row,$column]
                #${log}::debug Column Name: [$files(tab3f2).tbl columncget $column -name]
                ##${log}::debug Column Name: [lindex $headerParams($bareName) 3]
                #${log}::debug Bare Name: $hdName
            }
        }
        
        #clear out the vars
        unset nextRow
        set rowMaxChar ""
        set columnMaxChar ""
    }

    ${log}::debug --END-- [info level 1]
} ;# importFiles::processFile


proc importFiles::startCmd {tbl row col text} {
    #****f* startCmd/importFiles
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2013 - Casey Ackels
    #
    # FUNCTION
    #	Configuration options when the user enters the tablelist
    #
    # SYNOPSIS
    #	N/A
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
    global log dist process
    ${log}::debug --START-- [info level 1]
    #${log}::debug distTypes: $dist(distributionTypes)
    
        set w [$tbl editwinpath]
        
        #'debug index: [$w index bottom]
        #${log}::debug Column Name: [$tbl columncget $col -name]
        switch -glob [string tolower [$tbl columncget $col -name]] {
            "disttype" {
                        #${log}::debug Enter the Distribution Types
                        #$w configure -editable yes -editwindow ttk::entry
                        $w configure -values $dist(distributionTypes) -state readonly
                        }
            *vers* {
                        ${log}::debug Enter the Versions
                        $w configure -values $process(versionList) ;# Create a Versions list, as we read in the file, so we can populate this combobox.
                        }
            default {
                #${log}::debug Column Name: [string tolower [$tbl columncget $col -name]]
            }
        }

        return $text
    
    ${log}::debug --END-- [info level 1]
} ;#importFiles::startCmd