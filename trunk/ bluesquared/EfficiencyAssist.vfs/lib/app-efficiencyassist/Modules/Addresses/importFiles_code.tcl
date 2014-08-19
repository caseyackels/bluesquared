# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 10 07,2013 
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
# Code for Batch Addresss

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


proc importFiles::readFile {fileName lbox} {
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
    global log process files headerParent headerAddress options w
    ${log}::debug --START-- [info level 1]
    ${log}::debug file name: $fileName
    ${log}::debug file tail: [file tail $fileName]
    
    # Reset variables because we might be importing a 2nd file
    eAssistHelper::resetImportInterface 1
    
    if {$fileName eq ""} {return}
    
    set process(fileName) [file tail $fileName] ;# retrieve just the file name, so we can display it in a friendly matter
    
    # Open the file
    set process(fd) [open "$fileName" RDONLY]

    # Make the data useful, and put it into lists
    # We don't change the case here, in case the user wants it left alone.
    #while {-1 != [gets $fp line]}
    set gateway 0
    while { [gets $process(fd) line] >= 0 } {
        # Guard against lines of comma's, this will not be viewable in excel. Only in a text editor.
        if {[string is punc [join [split [string trim $line] " "] ""]] eq 1} {
            ${log}::notice Found some punc data, skipping ...
            continue
        }
        
        # Cycle through the rows until we find something that resembles a header row. Once we find it, start appending the data to a variable.
        # The imported files may have several rows of information before getting to the header row.
        if {$gateway == 0} {
            
            set Tmphdr [split $line ,]
            set hdr_lines 0
            foreach temp $Tmphdr {
                #${log}::debug Header $temp
                if {$gateway == 1} {
                    #${log}::debug Setting gateway to 1
                    break
                    }
                
                foreach hdr $headerParent(headerList) {
                    if {[lsearch -nocase $headerAddress($hdr) $temp] != -1} {
                        #${log}::debug Found a Header Match: [lsearch -nocase $headerAddress($hdr) $temp]
                        #${log}::debug Number of matched headers: $hdr_lines
                        incr hdr_lines
                
                        # Once we reach 4 matches lets stop looping
                        if {$hdr_lines >= 4} {
                            ${log}::notice Found the Header row - $line
                            ${log}::notice Stopping the loop ...
                            lappend process(dataList) $line
                            set gateway 1
                            break
                        } else {
                            ${log}::notice Searching for the header row ...
                            ${log}::notice Headers found: $hdr_lines - $temp
                            continue
                        }
                    }
                }
            }
            
            
            # ** This should be a user settable option! **
            # While 'city' should be universal, a requirement no less, it is still possible to not have a column named 'city'.
            #if {[string match -nocase *city* $line] || [string match -nocase *address* $line] || [string match -nocase *state* $line] || [string match -nocase *zip* $line]} {}
            #            ${log}::notice Found the Header row - $line
            #            lappend process(dataList) $line
            #            set gateway 1
            #    {} else {}
            #        ${log}::notice Searching for the header row ...
            #        continue
            #{}
        } else {
            lappend process(dataList) $line
        }

    }
    
    ${log}::debug *Header RECORDS*: [expr [llength $process(dataList)]-1]
    set process(numOfRecords) [expr [llength $process(dataList)]-1]

    chan close $process(fd)

    # Only retrieve the first record. We use this as the 'header' row.
    set process(Header) [string toupper [csv::split [lindex $process(dataList) 0]]]
    ${log}::debug process(Header): $process(Header)
    
    set process(dataList) [lrange $process(dataList) 1 end] ;#we don't want the header, so lets capture everything but.

    # headerList contains user set Master Header names
    # process(Header) contains headers listed in the file
    foreach header $process(Header) {
        # Insert all headers, regardless if they match or not.
        $lbox insert end $header
        
        foreach headerName $headerParent(headerList) {
            if {$process(Header) != ""} {
                    # headerAddress($headername) = various spellings of the headername.
                    # Now we check to see if we can auto-map the headers with the information that we are already aware of.
                    if {[lsearch -nocase $headerAddress($headerName) $header] != -1} {
                        if {$options(AutoAssignHeader) == 1} {
                            eAssistHelper::autoMap $headerName $header
                        }
                    }
            }
        }
    }
    
    importFiles::enableButtons $w(wi).top.btn2 $w(wi).btns.btn1 $w(wi).btns.btn2
    ${log}::debug --END-- [info level 1]
} ;# importFiles::readFile



proc importFiles::processFile {win} {
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
    #   IFMenus::tblPopup
    #
    #***
    global log files headerAddress position process headerParams headerParent dist w job L_states options
    #${log}::debug --START-- [info level 1]
    
    # Close the file importer window
    destroy $win
    
    # This will allow us to append, or reset the interface depending on the user's selection in the File Importer window
    if {$options(ClearExistingData) == 1} {
        # Reset the entire interface
        eAssistHelper::resetImportInterface 2
    }

    
    # Whitelist for required columns, so that they won't be hidden.   
    ## Dynamically query the header setup params, to know which columns should be whitelisted.
    if {[info exists headerParent(whiteList)]} {unset headerParent(whiteList)}
    foreach item $headerParent(headerList) {
        if {[lindex $headerParams($item) 4] eq "Yes"} {
            lappend headerParent(whiteList) $item
        }
    }
    # Ensure the 'count' column is whitelisted
    if {[lsearch $headerParent(whiteList) count] == -1} {lappend headerParent(whiteList) count}
      
    set process(versionList) ""
    
    set ColumnCount [$files(tab3f2).tbl columncount]
    # Index (i.e. 01, from 01_HeaderName)
    set FileHeaders [lsort [array names position]]
    #${log}::debug FileHeaders: $FileHeaders
    
    foreach record $process(dataList) {
        # .. Skip over any 'blank' lines in Excel
        if {[string is punc $record] == 1} {continue}
            
        ## Ensure we have good data; if we don't, lets try to fix it
        if {[csv::iscomplete $record] == 0} {
                lappend badString $record
                ${log}::notice Bad Record - Found on line [lsearch $process(dataList) $record] - $record
                # Stop looping and go to the next record
                continue
        } else {
            if {[info exists badString]} {
                set l_line [csv::split [join $badString]]
                unset badString
            } else {
                set l_line [csv::split $record]
            }
        }
        
        set l_line [join [split $l_line ,] ""] ;# remove all comma's
        
        #l_line = entire row of records
        # [lindex $l_line $index] = Individual record
        #${log}::debug Raw Record: $l_line

        for {set x 0} {$ColumnCount > $x} {incr x} {
            set ColumnName [$files(tab3f2).tbl columncget $x -name]

            set tmpHeader [lindex $FileHeaders [lsearch -nocase $FileHeaders *$ColumnName]]

            set index [lrange [split $tmpHeader _] 0 0]
            #set indexHdr [lrange [split $tmpHeader _] 1 1]
         
            #${log}::debug Current Column: $ColumnName
            #${log}::debug tmpHeader: $tmpHeader

            if {[string compare $index 00] == 0} {
                # This is the first record so we only want to strip the leading 0, not both.
                set index 0
            } else {
                set index [string trimleft $index 0]
            }
            
            ## Set the default if no data for versions exist.
            if {[string match -nocase *version $tmpHeader]} {
                if {[string trim [lindex $l_line $index]] == {}} {
                    ${log}::notice No version was found, inserting default...
                    set l_line [lreplace $l_line $index $index "Version 1"]
                }
            }

            if {$index == ""} {                    
                #${log}::debug Index: $index
                
                lappend newRow ""
                
                if {[lsearch -nocase $headerParent(whiteList) $ColumnName] == -1} {
                    # If we dont have an index for it, then lets hide the column aswell.
                    # This will not hide columns that have no data in it, just columns that were not in the original file.
                
                    ${log}::notice $ColumnName is not on the white list
                    ${log}::notice $ColumnName doesn't contain any data
                    ${log}::notice Hiding $ColumnName ...
                    $files(tab3f2).tbl columnconfigure $x -hide yes
                }

            } else {
                set listData [string trim [lindex $l_line $index]]

                # Figure out if the listData contains more chars than allowed; at the same time set the highlight configuration if it does exceed the limits
                if {[string length $listData] > [lindex $headerParams($ColumnName) 0]} {
                    #${log}::debug List: $listData - Length: [string length $listData]
                    lappend maxCharColumn $x
                    
                    set bgColor [lindex $headerParams($ColumnName) 3]
                    
                    if {$bgColor != ""} {
                        set backGround $bgColor
                    } else {
                        set backGround yellow ;# default
                    }
                }
                
                # Dynamically build the list of versions
                switch -glob [string tolower $ColumnName] {
                    *version    {
                                if {[lsearch $process(versionList) $listData] == -1} {
                                        lappend process(versionList) $listData
                                    }
                    }
                    state       {
                        set getZip [lindex $FileHeaders [lsearch -nocase $FileHeaders *zip]]
                        set idxZip [string trimleft [lrange [split $getZip _] 0 0] 0]
                        
                        importFiles::detectCountry $l_line $listData $idxZip                        
                    }
                    *zip        {
                        ${log}::debug Zip code: $listData
                    }
                    default     {}
                }
                
                
                # Create the list of values
                lappend newRow $listData
                #${log}::debug Position: [llength $newRow]
                    
                }
            #${log}::debug NewRow: $newRow

        }
        $files(tab3f2).tbl insert end $newRow
        #${log}::debug Final Record: $newRow
        
        if {[info exists maxCharColumn] == 1} {
            foreach column $maxCharColumn {
                $files(tab3f2).tbl cellconfigure end,$column -bg $backGround
            }
        unset maxCharColumn
        }
        
        unset newRow
        set x 0
    }
    
    # save the original version list as origVersionList, so we can keep the process(versionList) variable updated with user changed versions
    if {[info exists process(versionList)]} {
        set process(origVersionList) $process(versionList)
    }
    
    # Initialize popup menus
    IFMenus::tblPopup $files(tab3f2).tbl browse .tblMenu
    IFMenus::createToggleMenu $files(tab3f2).tbl
    
    # Get total copies
    set job(TotalCopies) [eAssistHelper::calcSamples $files(tab3f2).tbl [$files(tab3f2).tbl columncget Quantity -name]]
    
    # Insert columns that we should always see, and make sure that we don't create it multiple times if it already exists
    if {[$files(tab3f2).tbl findcolumnname count] == -1} {
        $files(tab3f2).tbl insertcolumns 0 0 "..."
        $files(tab3f2).tbl columnconfigure 0 -name "count" -showlinenumbers 1 -labelalign center
    }
    
    # Enable menu items
    importFiles::enableMenuItems
    
    #${log}::debug --END-- [info level 1]
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
    global log dist carrierSetup job process packagingSetup
    ${log}::debug --START-- [info level 1]
    set w [$tbl editwinpath]
    
    set colName [$tbl columncget $col -name]
    
    switch -nocase $colName {
            "distributiontype"  {
                                $w configure -values $dist(distributionTypes) -state readonly
            }
            version              {
                                $w configure -values $process(versionList)
                                set process(startTblText) $text
                                ${log}::debug StartCmd: $process(startTblText)
            }
            "carriermethod"     {
                                $w configure -values $carrierSetup(CarrierList) -state readonly
            }
            "quantity"          {
                                    if {![string is integer $text]} {
                                            bell
                                            tk_messageBox -title "Error" -icon error -message \
                                                [mc "Only numbers are allowed"]
                                        $tbl rejectinput
                                        return
                                    }
                                set job(TotalCopies) [eAssistHelper::calcSamples $tbl $col]
            }
            "containertype"     {
                                $w configure -values $packagingSetup(ContainerType) -state readonly
            }
            "packagetype"       {
                                $w configure -values $packagingSetup(PackageType) -state readonly
            }
            default {
                #${log}::debug Column Name: [string tolower [$tbl columncget $col -name]]
            }
        }
        
        $tbl cellconfigure $row,$col -text $text

    set idx [lsearch -nocase [array names headerParams] $colName]

    if {$idx != -1} {
        if {[string length $text] > [lindex $headerParams($colName) 0]} {
            ${log}::debug length [string length $text]
                
            set bgColor [lindex $headerParams($colName) 3]
            if {$bgColor != ""} {
                set backGround $bgColor
            } else {
                set backGround yellow
            }
        } else {
            set backGround SystemWindow
        }
    # Update the internal list with the current text so that we can run calculations on it.
    $tbl cellconfigure $row,$col -background $backGround
    }

        
    return $text
    
    ${log}::debug --END-- [info level 1]
} ;#importFiles::startCmd


proc importFiles::endCmd {tbl row col text} {
    #****f* endCmd/importFiles
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
    global log headerParams headerParent files process job
    ${log}::debug --START-- [info level 1]
    
    set colName [$tbl columncget $col -name]
    set updateCount 0
    
    switch -nocase $colName {
        version  {# Add $text to list of versions if that version doesn't exist (i.e. user created a new version)
                    if {$text == ""} {
                        set newItem [lsearch $process(versionList) $process(startTblText)]
                        set process(versionList) [lreplace $process(versionList) $newItem $newItem]
                        ${log}::debug Text is: $text
                        ${log}::debug $process(startTblText) should be removed from the list: $process(versionList)
                    }
                    
                    if {[lsearch $process(versionList) $text] == -1} {
                        #${log}::debug Old Version List: $process(versionList)
                        set newItem [lsearch $process(versionList) $process(startTblText)]
                        set process(versionList) [lreplace $process(versionList) $newItem $newItem $text]
                        #${log}::debug New Version List: $process(versionList)
                    }
        }
        quantity    {
                    # We update the count's at the end of this proc
                    if {![string is integer $text]} {
                        bell
                        tk_messageBox -title "Error" -icon error -message \
                                        [mc "Only numbers are allowed"]
                        $tbl rejectinput
                        return
                    }
                    set updateCount 1                    
        }
    }
    
    $tbl cellconfigure $row,$col -text $text
    set idx [lsearch -nocase [array names headerParams] $colName]
    
    if {$idx != -1} {
        if {[string length $text] > [lindex $headerParams($colName) 0]} {
            ${log}::debug length [string length $text]
                
            set bgColor [lindex $headerParams($colName) 3]
            if {$bgColor != ""} {
                set backGround $bgColor
            } else {
                set backGround yellow
            }
        } else {
            set backGround SystemWindow
        }
    # Update the internal list with the current text so that we can run calculations on it.
    $tbl cellconfigure $row,$col -background $backGround
    }

    if {$updateCount == 1} {
        set job(TotalCopies) [eAssistHelper::calcSamples $tbl $col]
    }
    
	return $text
    ${log}::debug --END-- [info level 1]
} ;# importFiles::endCmd


proc importFiles::insertColumns {tbl} {
    #****f* insertColumns/importFiles
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Insert columns before populating them with data
    #
    # SYNOPSIS
    #   importFiles::insertColumns <tbl>
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
    global log headerParent headerParams dist
    ${log}::debug --START-- [info level 1]
    
    # Get the length of the Distribution Types
    if {[info exists newList]} {unset newList}
    
    foreach val $dist(distributionTypes) {
            lappend newList [string length $val]
    }
    
    set distWidth [expr {[lrange [lsort -integer $newList] end end] + 4}]

    # Create the columns in the Table, using parameters assigned to each 'column type', from Setup. Located in the headerParams array.
    set x -1; #was -1
    foreach hdr $headerParent(headerList) {
        incr x
        $tbl insertcolumns end 0 $hdr
        
        set myWidget [lindex $headerParams($hdr) 2]
        if {$myWidget == ""} {
            # Just in case an entry wasn't filled out, lets make a default.
            set myWidget ttk::entry
        }
        
        if {[lindex $headerParams($hdr) 5] eq "Yes"} {
            set hdrFG red
            } else {
                set hdrFG black
        }

        $tbl columnconfigure $x \
                            -name $hdr \
                            -labelalign center \
                            -editable yes \
                            -editwindow $myWidget \
                            -labelforeground $hdrFG
        
        # Ensure that we don't have to manually expand this column ...
        if {$hdr eq "DistributionType"} {$tbl columnconfigure $x -width $distWidth}
        
    }
	
    ${log}::debug --END-- [info level 1]
} ;# ::insertColumns


proc importFiles::enableMenuItems {} {
    #****f* enableMenuItems/importFiles
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Enable menu items, now that we have imported a list.
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
    global log mb
    ${log}::debug --START-- [info level 1]
    
    set menuCount [$mb.modMenu index end]
    
     # Enable/Disable the menu items depending on which one is active.
    for {set x 0} {$menuCount >= $x} {incr x} {
        catch {$mb.modMenu entryconfigure $x -state normal}
    }
	
    ${log}::debug --END-- [info level 1]
} ;# importFiles::enableMenuItems


proc importFiles::detectCountry {l_line state idxZip} {
    #****f* detectCountry/importFiles
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Detect if the state exists in the US, if it doesn't look at the zip code. Ultimately, either inserting the country ISO code or highlighting the Country field
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
    #   $l_line = the entire row of data being read in.
    #
    # SEE ALSO
    #
    #***
    global log L_states L_countryCodes
    ${log}::debug --START-- [info level 1]
    
    set domestic yes
    set zip [string trim [lindex $l_line $idxZip]]
    
    ${log}::debug State-Zip: $state - $zip
    ${log}::debug US State? [lsearch -nocase $L_states(US) $state]
    
    if {[lsearch -nocase $L_states(US) $state] == -1} {
        ${log}::debug State not found - $state
        set domestic no
    }
    
    if {$domestic eq "no"} {
        # Check for common abbreviations for canada, mexico and japan
        if {[lsearch -nocase $L_countryCodes $state] == -1} {
            ${log}::debug State/Country not found - $state - lets look at zip codes.
        } else {
            ${log}::debug State was found: $state
            set domestic yes
        }
        
        # Check the zip code
        # USA Zip Codes [zip+4], each state starts with a 0-9.
        for {set x 0} {$x < 10} {incr x} {
            if {[string first $x $zip 0] == 0} {
                ${log}::debug Zip code exists in the USA: $zip
                set domestic yes
                break
            }
        }
    }
    
    # If it still isn't domestic, lets try to find the country
    if {$domestic eq "no"} {
        # Canadian format A1A 1A1
        # Look at length - must be 6 chars
        ${log}::debug length [llength $zip]
        ${log}::debug alphanum? [string is alnum [string range $zip 0 2]]
        ${log}::debug Non-US Zip code: $zip
    }
    
	
    ${log}::debug --END-- [info level 1]
} ;# importFiles::detectCountry
