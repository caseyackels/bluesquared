# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 10 07,2013 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 479 $
# $LastChangedBy: casey.ackels@gmail.com $
# $LastChangedDate: 2015-03-12 09:13:54 -0700 (Thu, 12 Mar 2015) $
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
    #${log}::debug --START-- [info level 1]
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
                        # Searching the subheaders for a match ...
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
        } else {
            lappend process(dataList) $line
        }

    }
    
    #${log}::debug *Header RECORDS*: [expr [llength $process(dataList)]-1]
    set process(numOfRecords) [expr [llength $process(dataList)]-1]

    chan close $process(fd)

    # Only retrieve the first record. We use this as the 'header' row.
    set process(Header) [string toupper [csv::split [lindex $process(dataList) 0]]]
    ${log}::debug process(Header): $process(Header)
    
    set process(dataList) [lrange $process(dataList) 1 end] ;#we don't want the header, so lets trim it down.

    # headerList contains headers that are in SETUP:Headers
    # process(Header) contains headers listed in the file
    foreach header $process(Header) {
        # Insert all headers, regardless if they match or not.
        $lbox insert end $header
        
        if {$options(AutoAssignHeader) == 1} {
            foreach headerName $headerParent(headerList) {
                # Get the HeaderID
               set subheaders [db eval "SELECT SubHeaderName FROM SubHeaders LEFT OUTER JOIN HeadersConfig
                        WHERE HeaderConfigID=HeaderConfig_ID
                    AND HeaderConfigID=(SELECT HeaderConfig_ID FROM HeadersConfig WHERE dbColName='$headerName')"]
                
                if {$process(Header) != ""} {
                    if {[lsearch -nocase $subheaders $header] != -1} {
                        eAssistHelper::autoMap $headerName $header
                        #${log}::debug MAPPING - $headerName TO $header
                    }
                }
            }
        }
    }
    
    importFiles::enableButtons $w(wi).top.btn2 $w(wi).btns.btn1 $w(wi).btns.btn2
    #${log}::debug --END-- [info level 1]
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
    #   headerParent(headerList) - List of InternalHeaderName
    #   headerParent(outPutHeader) - List of Output Headers
    #   headerParent(whiteList) - List of headers that should always be displayed
    #   headerAddress() - Contains the subheaders associated with the listed master header
    #   headerParams() - Contains the setup params for the specified header
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
 
    set process(versionList) ""
    
    # Index (i.e. 01, from 01_HeaderName)
    set FileHeaders [lsort [array names position]]
    #${log}::debug FileHeaders: $FileHeaders

    
    # launch progress bar window
    eAssistHelper::importProgBar
    #${log}::debug Launching Progress Bar
    
    # configure value of progress bar (number of total records)
    set max [expr {$process(numOfRecords) + 1}]
    $::gwin(importpbar) configure -maximum $max
    ${log}::debug configuring Progress Bar with -maximum $max

    # This must be a balanced list
    # Only replace known 'bad' values. Commas, Apostrophe, and Quotes. Further filtering will be done by the user.
    set replaceBadChars [list ' "" , " " \" " "]
    
    foreach record $process(dataList) {
        if {[info exists newRow]} {unset newRow}
        if {[info exists header_order]} {unset header_order}
        # .. Skip over any 'blank' lines in found in the file
        if {[string is punc $record] == 1} {continue}
            
        ## Ensure we have good data; if we don't, lets try to fix it.
        ## This typically occurs when there is a hard return in the data. Excel does not fix it when the file is exported to .csv format
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
        
        # Check to see if we have a versions column in the user file.
        if {[lsearch $FileHeaders *Versions] == -1} {
            lappend FileHeaders 99_Versions
        }
        
        # FileHeader = 00_Company
        foreach hdr $FileHeaders {
            set pos [lrange [split $hdr _] 0 0]
            if {[string compare $pos 00] == 0} {
                           # This is the first record so we only want to strip the leading 0, not both.
                           set pos 0
                       } else {
                           set pos [string trimleft $pos 0]
                       }
            set hdr_ [lrange [split $hdr _] 1 end]
            set data [lrange $l_line $pos $pos]
            
            # Cleanse data
            set data [string map $replaceBadChars $data]
            # Remove leading/trailing spaces
            set data [string trim [join $data]]
            
            # manipulate data; we know what column we are in, and we have the data.
            switch -glob $hdr_ {
                *Versions    {
                                ${log}::debug VERSION: Insert into Version table, and return the ID
                                if {$data == ""} {
                                    # Set the default version; this should probably be a GUI default option, so we aren't hard-coding.
                                    set data [$job(db,Name) eval "SELECT Version_ID FROM Versions WHERE VersionName='Version 1' AND VersionActive=1"]
                                    ${log}::debug No version detected, using the default.
                                } else {
                                    ${log}::debug Checking to see if the (version [join $data]) exists in the db ...
                                    set vers [join [$job(db,Name) eval "SELECT VersionName FROM Versions WHERE VersionName='$data' AND VersionActive=1"]]
                                    if {$vers == ""} {
                                        # Version doesn't exist in the db yet; insert and return the ID
                                        $job(db,Name) eval "INSERT INTO Versions (VersionName) values('$data')"
                                        ${log}::debug Version doesn't exist, inserting into db...
                                        set data [$job(db,Name) eval "SELECT max(Version_ID) FROM Versions WHERE VersionActive=1"]
                                    } else {
                                        ${log}::debug Version exists in db, assigning to address...
                                        set data [$job(db,Name) eval "SELECT Version_ID FROM Versions WHERE VersionName='[join $vers]' AND VersionActive=1"]
                                        ${log}::debug Version Data in DB: $data
                                    }
                                }
                }
                ship*date   {
                    
                }
                default     {}
            }
            
            # Figure out what table to put the data into.
            if {[lsearch $headerParent(headerList,consignee) $hdr_ ] != -1} {
                    # Table: Addresses
                    lappend newRow_consignee '$data'
                    lappend header_order_consignee $hdr_
            } elseif {[lsearch $headerParent(headerList,shippingorder) $hdr_ ] != -1} {
                    # Table: Shipping Orders
                    lappend newRow_shiporder '$data'
                    lappend header_order_shiporder $hdr_
            }

            ${log}::debug hdr_ $hdr_
        }
        
        set sysGUID [ea::tools::getGUID]
        set histNote [job::db::insertHistory [mc "Sys: Import - Addresses"]]
        
        set header_order_consignee "SysAddresses_ID SysAddressParentID HistoryID $header_order_consignee"
        set newRow_consignee "'$sysGUID' '$sysGUID' '$histNote' $newRow_consignee"
        
        set header_order_shiporder "JobInformationID AddressID $header_order_shiporder"
        set newRow_shiporder "'$job(Number)' '$sysGUID' $newRow_shiporder"
        
        # Insert data into the DB
        #${log}::debug HEADER: [join $header_order_consignee ,]
        #${log}::debug CONSIGNEE: [join $newRow_consignee ,]
        

        $job(db,Name) eval "INSERT INTO Addresses ([join $header_order_consignee ,]) VALUES ([join $newRow_consignee ,])"
        
        ##
        ## DE DUPING
        ## Inserting into Shipping Orders should happen in the dedupe window  
        ##
        $job(db,Name) eval "INSERT INTO ShippingOrders ([join $header_order_shiporder ,]) VALUES ([join $newRow_shiporder ,])"
        
        # Clear variables
        unset header_order_consignee
        unset newRow_consignee
        unset header_order_shiporder
        unset newRow_shiporder
        
        $::gwin(importpbar) step 1
        ${log}::debug Updating Progress Bar - [$::gwin(importpbar) cget -value]
        update
    }
    
    ## Ensure the progress bar is at the max, by the time we are done with the loop
    $::gwin(importpbar) configure -value $max
    
    ## Destroy the progress bar window
    eAssistHelper::importProgBar destroy
    
    # Insert the data into the widget
    importFiles::insertIntoGUI $files(tab3f2).tbl -dedupe
    

    ## Enable menu items
    importFiles::enableMenuItems

    ## Get total copies
    job::db::getTotalCopies

    importFiles::highlightAllRecords $files(tab3f2).tbl
    
    ## Destroy the progress bar window
    #eAssistHelper::importProgBar destroy

    ### Initialize popup menus
    IFMenus::createToggleMenu $files(tab3f2).tbl
} ;# importFiles::processFile


proc importFiles::insertIntoGUI {wid args} {
    #****f* insertIntoGUI/importFiles
    # CREATION DATE
    #   06/02/2015 (Tuesday Jun 02)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # USAGE
    #   importFiles::insertIntoGUI <wid> 
    #
    # FUNCTION
    #	Creates the required columns in the tablelist widget; then inserts the data.
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # EXAMPLE
    #   importFiles::insertIntoGUI 
    #
    # NOTES
    #   This is called when importing a new file AND when opening an existing database
    #  
    # SEE ALSO
    #   
    #   
    #***
    global log headerParent job files
    
    if {$args eq "-dedupe"} {
        # Run basic deduping
        ea::dedupe::exactMatch Company Attention Address1 Address2 City State Zip
    }

    if {[info exists hdrs_show]} {unset hdrs_show}
        
    # make sure we are starting new. Clear the columns and clear the table
    if {[$wid columncount] != 0} {$wid deletecolumns 0 end}
    #${log}::debug Row Count 1: [$files(tab3f2).tbl size]
        
    # Insert the columns into the widget
    # The tablelist widget is initialized in importFiles_gui.tcl [importFiles::eAssistGUI]
    # get the config values
    db eval "SELECT widStartColWidth,
                                widLabelName,
                                widLabelAlignment,
                                widColAlignment,
                                widWidget,
                                widDataType,
                                widMaxWidth,
                                widRequired,
                                widResizeToLongestEntry,
                                widFormat,
                                widDisplayType,
                                widUIGroup,
                                dbColName FROM HeadersConfig WHERE dbActive = 1" {
                                    
            # Check to see if we need to configure the column (Always, Dynamic (with data), or Never)
            switch -- $widDisplayType {
                "Dynamic"   {
                                # Only show columns if data exists.
                                # Exit the loop if data doesn't exist.
                                if {$widUIGroup eq "Consignee"} {set tbl Addresses} else {set tbl ShippingOrders}
                                set values [$job(db,Name) eval "SELECT $dbColName from $tbl WHERE ifnull($dbColName, '') != ''"]
                                if {$values == ""} {continue}
                }
                "Never"     {continue}
                "Always"    {}
                default     {${log}::critical insertIntoGUI - $widDisplayType is not a valid switch option!}
            }
            

            if {$widUIGroup eq "Consignee"} {set tbl Addresses} else {set tbl ShippingOrders}
                ${log}::debug Table/Columns: $tbl.$dbColName
                lappend hdrs_show "$tbl.$dbColName"

            
            set lenWidLabelName [string length $widLabelName]
            
            if {$lenWidLabelName >= $widStartColWidth} {
                    set colWidth $lenWidLabelName
                } else {
                    set colWidth $widStartColWidth
            }
            
            # Make sure we don't mistakenly set a dynamic width column shorter than the label text.
            # If we are in a dynamic width column, and the strings are less than the text label, we do not honor the dynamic setting.
            if {$widResizeToLongestEntry == 1 && $lenWidLabelName != $colWidth} {
                set colWidth 0
            } else {
                # Increase colWidth by 1 to make the column a bit wider
                incr colWidth
            }
            
            
            $wid insertcolumns end $colWidth $widLabelName
            $wid columnconfigure end -name $dbColName \
                                    -labelalign [string tolower $widLabelAlignment] \
                                    -align [string tolower $widColAlignment] \
                                    -maxwidth $widMaxWidth \
                                    -sortmode [string tolower $widDataType]
            
            # If this is a required column; colorize the label text
            if {$widRequired == 1} {
                $wid columnconfigure end -labelforeground red
            }
        } ;# End query for column configuration
        
    #${log}::debug Row Count 2: [$files(tab3f2).tbl size]

    #${log}::debug hdrs_show: $hdrs_show
    # insert the data into the widget
    # first manipulate the column names; we need two lists. One for the 'select' args, and one for the variables.
    if {[info exists hdr_list]} {unset hdr_list}
    if {[info exists hdr_data]} {unset hdr_data}
    
    foreach hdr $hdrs_show {
        # look for a header that contains 'vers', because we need to append .VersionNames (Table: Versions, column VersionNames) so we can display the version name vs the version id
        if {[string match -nocase *vers* $hdr]} {
            #${log}::debug Found a vers match! $hdr
    
            lappend hdr_list "Versions.VersionName as VersionName"
            lappend hdr_data \$VersionName
        } else {
            lappend hdr_list $hdr
            lappend hdr_data $[lindex [split $hdr .] 1]
        }
    }
    ${log}::debug hdr_list: $hdr_list
    ${log}::debug hdr_data: $hdr_data

    $job(db,Name) eval "SELECT [join $hdr_list ,] FROM ShippingOrders
                            INNER JOIN Addresses
                                ON ShippingOrders.AddressID = Addresses.SysAddresses_ID
                            LEFT OUTER JOIN Versions
                                ON ShippingOrders.Versions = Versions.Version_ID
                            WHERE ShippingOrders.JobInformationID in ('$job(Number)')
                            AND Addresses.SysActive = 1
                            AND ShippingOrders.Hidden = 0" {
                                #$wid insert end [subst $hdr_data]
                                #${log}::debug hdr_list: $hdr_list
                                #${log}::debug data: [subst $hdr_data]
                                $files(tab3f2).tbl insert end [subst $hdr_data]
                            }
                            
    ## Insert columns that we should always see, and make sure that we don't create it multiple times if it already exists
    if {[$files(tab3f2).tbl findcolumnname OrderNumber] == -1} {
        $files(tab3f2).tbl insertcolumns 0 0 "..."
        $files(tab3f2).tbl columnconfigure 0 -name "OrderNumber" -labelalign center -showlinenumbers 1
    }
    
} ;# importFiles::insertIntoGUI $files(tab3f2).tbl


proc importFiles::highlightAllRecords {tbl} {
    #****f* highlightAllRecords/importFiles
    # CREATION DATE
    #   02/11/2015 (Wednesday Feb 11)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   importFiles::highlightAllRecords tbl 
    #
    # FUNCTION
    #	Cycles through the tablelist widget, and highlights all records that exceed our max string length. See Setup/Headers
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
    global log

    ## increments through the Columns
    # Retrieve total number of columns
    set columnCount [$tbl columncount]
    for {set x 0} {$columnCount > $x} {incr x} {
        #puts $x
        set colName [$tbl columncget $x -name]
        set maxLength [db eval "SELECT widMaxStringLength FROM HeadersConfig where widLabelName='$colName'"]
        set backGround [join [db eval "SELECT widHighlightColor FROM HeadersConfig where widLabelName='$colName'"]]
        if {$backGround eq ""} {set backGround yellow} ;# Default to yellow if nothing was customized.
        
        if {$maxLength eq ""} {continue} ;# Skip if we haven't set a value
        
        # Retrieve column data, and apply color if needed
        set colData [$tbl getcolumns $x]
        set i_row 0
        foreach item $colData {
            if {[string length $item] > $maxLength} {
                $tbl cellconfigure $i_row,$x -bg $backGround

            } else {
                $tbl cellconfigure $i_row,$x -bg ""
            }
            incr i_row
        }
    }

    
} ;# importFiles::highlightAllRecords $files(tab3f2).tbl


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
    #   dist() - Contains all distribution types
    #
    # SEE ALSO
    #
    #***
    global log dist carrierSetup job process packagingSetup
    #${log}::debug --START-- [info level 1]
    set w [$tbl editwinpath]
    
    set colName [$tbl columncget $col -name]
    
    switch -nocase $colName {
            "distributiontype"  {
                                $w configure -values $dist(distributionTypes) -state readonly
            }
            version              {
                                $w configure -values $process(versionList)
                                set process(startTblText) $text
                                #${log}::debug StartCmd: $process(startTblText)
            }
            ShipVia             {
                                $w configure -values $carrierSetup(ShipViaName) -state readonly
            }
            "quantity"          {
                                    if {![string is integer $text]} {
                                            bell
                                            tk_messageBox -title "Error" -icon error -message \
                                                [mc "Only numbers are allowed"]
                                        $tbl rejectinput
                                        return
                                    }
                                #set job(TotalCopies) [eAssistHelper::calcSamples $tbl $col]
                                job::db::getTotalCopies
            }
            "containertype"     {
                                $w configure -values $packagingSetup(ContainerType) -state readonly
            }
            "packagetype"       {
                                $w configure -values $packagingSetup(PackageType) -state readonly
            }
            shippingclass       {
                                $w configure -values $carrierSetup(ShippingClass) -state readonly
            }
            default {
                #${log}::debug Column Name: [string tolower [$tbl columncget $col -name]]
            }
        }
        
        $tbl cellconfigure $row,$col -text $text

    #set idx [lsearch -nocase [array names headerParams] $colName]
    set stringLength [eAssist_db::dbWhereQuery -columnNames HeaderMaxLength -table Headers -where InternalHeaderName='$colName']
    set bgColor [join [eAssist_db::dbWhereQuery -columnNames Highlight -table Headers -where InternalHeaderName='$colName']]

    #if {$idx != -1} {}
    if {[string length $text] > $stringLength} {
        #${log}::debug length [string length $text]
            
        if {$bgColor != ""} {
            set backGround $bgColor
        } else {
            # Default color
            set backGround yellow
        }
    } else {
        set backGround ""
    }
    # Update the internal list with the current text so that we can run calculations on it.
    $tbl cellconfigure $row,$col -background $backGround
    
    return $text
    
    #${log}::debug --END-- [info level 1]
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
    #${log}::debug --START-- [info level 1]
    
    set colName [$tbl columncget $col -name]
    #set updateCount 0
    
    switch -nocase $colName {
        version  {# Add $text to list of versions if that version doesn't exist (i.e. user created a new version)
                    if {$text == ""} {
                        set newItem [lsearch $process(versionList) $process(startTblText)]
                        set process(versionList) [lreplace $process(versionList) $newItem $newItem]
                        #${log}::debug Text is: $text
                        #${log}::debug $process(startTblText) should be removed from the list: $process(versionList)
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
                    #set updateCount 1                    
        }
    }
    
    #$tbl cellconfigure $row,$col -text $text
    # Update the widget and DB
    job::db::write $job(db,Name) Addresses $text $tbl $row,$col $colName

    
    set stringLength [eAssist_db::dbWhereQuery -columnNames HeaderMaxLength -table Headers -where InternalHeaderName='$colName']
    set bgColor [join [eAssist_db::dbWhereQuery -columnNames Highlight -table Headers -where InternalHeaderName='$colName']]

    if {[string length $text] > $stringLength} { 
        if {$bgColor != ""} {
            set backGround $bgColor
        } else {
            # Default color
            set backGround yellow
        }
    } else {
        # Resets the bg to the correct striping if the length is equal or less than max value.
        set backGround ""
    }

    $tbl cellconfigure $row,$col -background $backGround

    #set job(TotalCopies) [ea::db::countQuantity $job(db,Name) Addresses]
    job::db::getTotalCopies
    
	return $text
    #${log}::debug --END-- [info level 1]
} ;# importFiles::endCmd



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
    #${log}::debug --START-- [info level 1]
    
    set menuCount [$mb.modMenu index end]
    
     # Enable/Disable the menu items depending on which one is active.
    for {set x 0} {$menuCount >= $x} {incr x} {
        catch {$mb.modMenu entryconfigure $x -state normal}
    }
	
    #${log}::debug --END-- [info level 1]
} ;# importFiles::enableMenuItems


#proc importFiles::detectCountry {l_line state idxZip} {
#    #****f* detectCountry/importFiles
#    # AUTHOR
#    #	Casey Ackels
#    #
#    # COPYRIGHT
#    #	(c) 2011-2014 Casey Ackels
#    #
#    # FUNCTION
#    #	Detect if the state exists in the US, if it doesn't look at the zip code. Ultimately, either inserting the country ISO code or highlighting the Country field
#    #
#    # SYNOPSIS
#    #
#    #
#    # CHILDREN
#    #	N/A
#    #
#    # PARENTS
#    #	
#    #
#    # NOTES
#    #   $l_line = the entire row of data being read in.
#    #
#    # SEE ALSO
#    #
#    #***
#    global log L_states L_countryCodes
#    ${log}::debug --START-- [info level 1]
#    
#    set domestic yes
#    set zip [string trim [lindex $l_line $idxZip]]
#    
#    ${log}::debug State-Zip: $state - $zip
#    ${log}::debug US State? [lsearch -nocase $L_states(US) $state]
#    
#    if {[lsearch -nocase $L_states(US) $state] == -1} {
#        ${log}::debug State not found - $state
#        set domestic no
#    }
#    
#    if {$domestic eq "no"} {
#        # Check for common abbreviations for canada, mexico and japan
#        if {[lsearch -nocase $L_countryCodes $state] == -1} {
#            ${log}::debug State/Country not found - $state - lets look at zip codes.
#        } else {
#            ${log}::debug State was found: $state
#            set domestic yes
#        }
#        
#        # Check the zip code
#        # USA Zip Codes [zip+4], each state starts with a 0-9.
#        for {set x 0} {$x < 10} {incr x} {
#            if {[string first $x $zip 0] == 0} {
#                ${log}::debug Zip code exists in the USA: $zip
#                set domestic yes
#                break
#            }
#        }
#    }
#    
#    # If it still isn't domestic, lets try to find the country
#    if {$domestic eq "no"} {
#        # Canadian format A1A 1A1
#        # Look at length - must be 6 chars
#        ${log}::debug length [llength $zip]
#        ${log}::debug alphanum? [string is alnum [string range $zip 0 2]]
#        ${log}::debug Non-US Zip code: $zip
#    }
#    
#	
#    ${log}::debug --END-- [info level 1]
#} ;# importFiles::detectCountry
