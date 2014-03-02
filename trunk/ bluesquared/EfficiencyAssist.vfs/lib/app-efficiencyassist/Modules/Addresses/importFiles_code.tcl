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
    
    ${log}::debug RESET INTERFACE
    #eAssistHelper::resetImportInterface
    
    if {$fileName eq ""} {return}
    
    set process(fileName) [file tail $fileName] ;# retrieve just the file name, so we can display it in a friendly matter
    
    # Open the file
    set process(fd) [open "$fileName" RDONLY]

    # Make the data useful, and put it into lists
    # We don't change the case here, in case the user wants it left alone.
    #while {-1 != [gets $fp line]}
    while { [gets $process(fd) line] >= 0 } {
        # Guard against lines of comma's, this will not be viewable in excel. Only in a text editor.
        if {[string is punc [join [split [string trim $line] " "] ""]] eq 1} {continue}

        lappend process(dataList) $line
    }
    
    ${log}::debug *RECORDS*: [expr [llength $process(dataList)]-1]
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
    global log files headerAddress position process headerParams headerParent dist w job
    ${log}::debug --START-- [info level 1]
    
    # Close the file importer window
    destroy $win
    
    # Whitelist for required columns, so that they won't be hidden.
    # this should be user configurable
    set headerParent(whiteList) [list count DistributionType CarrierMethod]
      
    set process(versionList) ""
    
    set ColumnCount [$files(tab3f2).tbl columncount]
    # Index (i.e. 01, from 01_HeaderName)
    set FileHeaders [lsort [array names position]]
    
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

        for {set x 0} {$ColumnCount > $x} {incr x} {
            set ColumnName [$files(tab3f2).tbl columncget $x -name]

            set tmpHeader [lindex $FileHeaders [lsearch -nocase $FileHeaders *$ColumnName]]
            set index [lrange [split $tmpHeader _] 0 0]

            if {[string compare $index 00] == 0} {
                # This is the first record so we only want to strip the leading 0, not both.
                set index 0
            } else {
                set index [string trimleft $index 0]
            }

            # Ensure that we only use columns for processing when needed. Required columns should not go through the processing below.
            if {[lsearch -nocase $headerParent(whiteList) $ColumnName] == -1} {
                if {$index == ""} {
                    # If we dont have an index for it, then lets hide the column aswell.
                    # This will not hide columns that have no data in it, just columns that were not in the original file.
                    $files(tab3f2).tbl columnconfigure $x -hide yes
                    
                    lappend newRow ""
                } else {
                    set listData [string trim [lindex $l_line $index]]
    
                    
                    # Figure out if the listData contains more chars than allowed; at the same time set the highlight configuration if it does exceed the limits
                    if {[string length $listData] > [lindex $headerParams($ColumnName) 0]} {
                        ${log}::debug List: $listData - Length: [string length $listData]
                        lappend maxCharColumn $x
                        
                        set bgColor [lindex $headerParams($ColumnName) 3]
                        
                        if {$bgColor != ""} {
                            set backGround $bgColor
                        } else {
                            set backGround yellow
                        }
                    }
                    
                    switch -glob [string tolower $ColumnName] {
                        *version    { if {[lsearch $process(versionList) $listData] == -1} {
                                        lappend process(versionList) $listData}
                                    }
                        default     {}
                    }
                    
                    
                    # Create the list of values
                    lappend newRow $listData
                }
            }
            #${log}::debug NewRow: $newRow

        }
        $files(tab3f2).tbl insert end $newRow
        
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
    set process(origVersionList) $process(versionList)
    
    # Initialize popup menus
    IFMenus::tblPopup $files(tab3f2).tbl browse .tblMenu
    IFMenus::createToggleMenu $files(tab3f2).tbl
    
    # Get total copies
    set job(TotalCopies) [eAssistHelper::calcSamples $files(tab3f2).tbl [$files(tab3f2).tbl columncget Quantity -name]]
    
    # Insert columns that we should always see
    $files(tab3f2).tbl insertcolumns 0 0 "..."
    $files(tab3f2).tbl columnconfigure 0 -name "count" -showlinenumbers 1 -labelalign center
    
    # Enable menu items
    importFiles::enableMenuItems
    
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
    global log headerParams headerParent files process
    ${log}::debug --START-- [info level 1]
    
    set colName [$tbl columncget $col -name]
    
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

        $tbl columnconfigure $x \
                            -name $hdr \
                            -labelalign center \
                            -editable yes \
                            -editwindow $myWidget
        
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
