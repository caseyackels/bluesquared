# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 02 16,2015
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
# Contains reports for Jobs (Batchmaker module)

namespace eval job::reports {}

proc job::reports::Viewer {} {
    #****f* Viewer/job::reports
    # CREATION DATE
    #   02/16/2015 (Monday Feb 16)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   job::reports::Viewer  
    #
    # FUNCTION
    #	Displays a text widget, for the results of the report proc to dump data into.
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

    if {[winfo exists .rv]} {destroy .rv}

    toplevel .rv
    wm transient .rv .
    wm title .rv [mc "Report Viewer"]
    
    set locX [expr {[winfo screenwidth . ] / 4 + [winfo x .]}]
    set locY [expr {[winfo screenheight . ] / 5 + [winfo y .]}]
    wm geometry .rv +${locX}+${locY}

    set f1 [ttk::frame .rv.f1 -padding 10]
    pack $f1 -fill both -expand yes -padx 5p -pady 5p
    
    set disttypes ""
    #ttk::entry $f1.entry1 -textvariable disttypes
    #ttk::combobox $f1.cbox1 -values {Version}
    
    text $f1.txt \
                -wrap word \
                -xscrollcommand [list $f1.scrollx set] \
                -yscrollcommand [list $f1.scrolly set]
        
        # setup the autoscroll bars
    ttk::scrollbar $f1.scrollx -orient h -command [list $f1.txt xview]
    ttk::scrollbar $f1.scrolly -orient v -command [list $f1.txt yview]
    
    grid $f1.txt -column 0 -row 1 -sticky news
    grid columnconfigure $f1 0 -weight 2
    grid rowconfigure $f1 1 -weight 2
    
    grid $f1.scrolly -column 1 -row 1 -sticky nse
    grid $f1.scrollx -column 0 -row 2 -sticky ews
    
    ::autoscroll::autoscroll $f1.scrollx ;# Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $f1.scrolly ;# Enable the 'autoscrollbar'
    
    $f1.txt delete 0.0 end

    #job::reports::Detailed $f1.txt
    job::reports::generic $f1.txt
} ;# job::reports::Viewer

proc job::reports::generic {txt} {
    #****if* generic/job::reports
    # CREATION DATE
    #   10/01/2015 (Thursday Oct 01)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   
    #   
    #***
    global log job user

    # Should be a user defined list ...
    set col "Company Notes Quantity PackageType ShipVia DistributionType"
    set colCount [llength $col]
    
    if {[info exists cols]} {unset cols}
    foreach item $col {
        lappend cols "$$item"
    }

    # Header - Job Name, Title, Num of Versions, Total Count
    $txt insert end "Job: $job(Number) $job(Title) / $job(Name)\n\n"
    #$txt insert end "Job Title/Name: $job(Title) / $job(Name)\n\n"
    $txt insert end "First Ship Date: [ea::date::formatDate -db -std [job::db::getShipDate -min ShipDate]]\n"
    
    # Set Variabls
    set numOfShipments [$job(db,Name) eval "SELECT count(JobInformationID) FROM ShippingOrders WHERE JobInformationID = '$job(Number)'"]
    set totalQtyOfShipments $job(TotalCopies)
    # Get unique versions
    set versionNames [job::db::getUsedVersions -active 1 -job $job(Number)]
    set numOfVersions [llength $versionNames]
    set dist_blacklist [ea::db::getDistSetup] ;# Disttypes that need special handling
    
    $txt insert end "$numOfVersions Versions, $numOfShipments Shipments, $totalQtyOfShipments Total Quantity\n"
    

    set jobNotes [job::db::getNotes -noteType Job -includeOnReports 1 -noteTypeActive 1 -notesActive 1]
        if {$jobNotes != ""} {
           $txt insert end "\nJob Notes: $jobNotes\n"
        }
        $txt insert end \n
    
    # Core Code
    foreach vers $versionNames {
    # Output Version Name
        set versNumOfShipments [job::db::getVersionCount -type NumOfVersions -job $job(Number) -version $vers -versActive 1 -addrActive 1]
        set versQuantity [job::db::getVersionCount -type CountQty -job $job(Number) -version $vers -versActive 1 -addrActive 1]
        
        # Get unique distribution types, for current version
        set DistTypes [job::db::getUsedDistributionTypes -version $vers -unique yes]
        
        $txt insert end "====================\n\n"
        $txt insert end "Version: $vers\n"
        $txt insert end "Shipments: $versNumOfShipments, Quantity: $versQuantity\n"
        
        # Create the matrix
        struct::matrix::matrix m
        ::job::reports::m add columns $colCount
        ::job::reports::m insert row end $col ;# Add the headers
        
        set gateway 0
        foreach dist $DistTypes {
            ${log}::debug cycling through dist: $dist
            # If the distribution type matches, UPS IMPORT, lets provide a grouped breakdown instead of the individual shipment
            # Handling the dist types that 'roll up' destinations into shipments.
            set clean_dist_blacklist [string map {' \"} $dist_blacklist]
            set clean_dist_blacklist [string map {"\"" ""} $clean_dist_blacklist]
            ${log}::debug clean blacklist: $clean_dist_blacklist
            if {[lsearch $clean_dist_blacklist $dist] != -1} {
                    # DistType associated with current version
                    # Output Summary for Distribution Type
                    # Output Carrier, Company and Quantity
                    # Get total count for current distribution type
                    ${log}::debug blacklist: Cycling through dist: $dist
                    set distTypeNumOfShipments [job::db::getDistTypeCounts -type numOfShipments -dist $dist -job $job(Number)]
                    set distTypeQty [job::db::getDistTypeCounts -type qtyInDistType -dist $dist -job $job(Number)]
                    set id [join [split $dist " "] ""]
                    
                    if {[info exists comboDistTypes($id,qty)]} {unset comboDistTypes($id,qty)}
                    lappend comboDistTypes(names) $dist

                    $job(db,Name) eval "SELECT Quantity FROM ShippingOrders
                            INNER JOIN Addresses ON Addresses.SysAddresses_ID = ShippingOrders.AddressID
                            INNER JOIN Versions ON ShippingOrders.Versions = Versions.Version_ID
                                WHERE ShippingOrders.JobInformationID = '$job(Number)'
                                    AND ShippingOrders.Hidden = 0
                                    AND Versions.VersionName = '$vers'
                                    AND DistributionType = '$dist'
                                    AND Addresses.SysActive = 1" {
                                lappend comboDistTypes($id,qty) $Quantity
                                set comboDistTypes($id,distTypeNumofShipments) $distTypeNumOfShipments
                                set comboDistTypes($id,distTypeQty) $distTypeQty
                            }
                
                } else {
                    set gateway 1
                    ${log}::debug dist: $dist - creating single shipments
                        # Output detailed shipment information
                        ${log}::debug col: $col
                        ${log}::debug cols: $cols
                        $job(db,Name) eval "SELECT [join $col ,] FROM ShippingOrders
                                                INNER JOIN Addresses on Addresses.SysAddresses_ID = ShippingOrders.AddressID
                                                INNER JOIN Versions on Versions.Version_ID = ShippingOrders.Versions
                                                    WHERE ShippingOrders.JobInformationID = '$job(Number)'
                                                        AND Versions.VersionName = '$vers'
                                                        AND DistributionType = '$dist'
                                                        AND Addresses.SysActive = 1
                                                        AND Versions.VersionActive = 1
                                                ORDER BY Addresses.DistributionType, ShippingOrders.Quantity" {
                                                    #${log}::debug Entering individual shipments...
                                                    # Error capturing: Set a default value if nothing was put into the db
                                                    if {$ShipVia eq ""} {set ShipVia [mc "CARRIER NOT ASSIGNED"]}
                                                    if {$Company eq ""} {set Company [mc "COMPANY NOT ASSIGNED"]}
                                                    if {$Quantity eq ""} {set Quantity [mc "QUANTITY NOT ASSIGNED"]}
                                                    
                                                    set ShipType [join [db eval "SELECT ShipmentType from ShipVia WHERE ShipViaName='[join $ShipVia]'"]]
                                                    set cols [string map {$ShipVia $ShipType} $cols]
                                                    
                                                    if {$Company eq "JG Mail"} {set ShipType "JG Mail"}
                                                    if {$Company eq "JG Inventory"} {set ShipType "JG Inventory"}
                                                    if {$Company eq "JG Bindery"} {set ShipType "JG Bindery"}
                                                    
                                                    ${log}::debug vals: [subst $cols]
                                                    ::job::reports::m insert row end [subst $cols]
                                                    
                                                    #$txt insert end "\t  $ShipVia, $Company - $Quantity\n"
                                                }
                }
        } ;# end of distribution type
        if {$gateway == 1} {
                ::report::report r $colCount style captionedtable 1
                $txt insert end [r printmatrix ::job::reports::m]
                ::job::reports::m destroy 
                r destroy
        } else {
                catch {::job::reports::m destroy}
                catch {r destroy}
        }
        
        if {[info exists comboDistTypes]} {
            foreach distType $comboDistTypes(names) {
                set id [join [split $distType " "] ""]
                $txt insert end "   <$distType> [mc "Shipments:"] $comboDistTypes($id,distTypeNumofShipments), [mc "Quantity:"] $comboDistTypes($id,distTypeQty)\n\n"
                
                foreach single [lindex [Shipping_Code::extractFromList $comboDistTypes($id,qty)] 0] {
                    #${log}::debug Singles: 1 Shipment of $single
                    $txt insert end "    1 Shipment of $single\n"
                }
                
                foreach groups [lrange [Shipping_Code::extractFromList $comboDistTypes($id,qty)] 1 end] {
                    #${log}::debug Groups: [llength $groups] shipments of [lindex $groups 0]
                    $txt insert end "    [llength $groups] Shipments of [lindex $groups 0]\n\n"
                }
            }
            unset comboDistTypes
        }

        $txt insert end "\n"
    } ;# end of versions
    
    # output the report
    set fd [open [file join $job(JobSaveFileLocation) [ea::tools::formatFileName]_report.txt] w+]
    puts $fd [$txt get 0.0 end]
    
    # Insert user and date/time stamp
    puts $fd [mc {Report Generated by: %1$s} $user(id)] ;# Should be $user(login)
    puts $fd [clock format [clock seconds] -format "%A %D %I:%M %p"]
    chan close $fd
    
} ;# job::reports::generic

proc job::reports::Detailed {txt args} {
    #****f* Detailed/job::reports
    # CREATION DATE
    #   02/23/2015 (Monday Feb 23)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   job::reports::Detailed txt args 
    #
    # FUNCTION
    #	
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
    global log job env comboDistTypes

#    # Should be a user defined list ...
#    set col "Company Notes Quantity PackageType ShipVia"
#    
#    
#    set addID [$job(db,Name) eval "SELECT OrderNumber FROM Addresses WHERE Status=1"]
#    set rowCount [llength $addID]
#    
#    set colCount [llength $col]
#    
#    set newCol $col
#    # We don't want the shipvia code, we want the shipment type (freight, small package)
#    set newCol [string map {ShipVia ShipType} $newCol]
#    
#    if {[info exists cols]} {unset cols}
#    foreach item $newCol {
#        lappend cols $$item
#    }
#    
#    # Header - Job Name, Title, Num of Versions, Total Count
#    $txt insert end "Job Number: $job(Number)\n"
#    $txt insert end "Job Title/Name: $job(Title) / $job(Name)\n\n"
#    
#    set numOfVersions [$job(db,Name) eval "SELECT count(distinct(Version)) FROM Addresses WHERE Status=1"]
#    set numOfShipments [$job(db,Name) eval "SELECT count(*) FROM Addresses WHERE Status=1"]
#    set totalQtyOfShipments [$job(db,Name) eval "SELECT sum(Quantity) FROM Addresses WHERE Status=1"]
#    
#    $txt insert end "$numOfVersions Versions, $numOfShipments Shipments, $totalQtyOfShipments Total Quantity\n"
#    #$txt insert end "Number of Versions: $numOfVersions\n"
#    #$txt insert end "Number of Shipments: $numOfShipments\n"    
#    #$txt insert end "Total Quantity: $totalQtyOfShipments\n"
#
#    # Schema testing; this exists in version 3 and higher
#    #set errStr "no such table:"
#    if {[job::db::tableExists Notes] != ""} {
#        set jobNotes [lindex [$job(db,Name) eval "SELECT max(Notes_ID), Notes_Notes FROM Notes"] 1]
#        if {$jobNotes != ""} {
#           $txt insert end "\nJob Notes: $jobNotes\n"
#        }
#        $txt insert end \n
#    }
#    
#
#    ## Create the matrices
#    #struct::matrix::matrix m
#    #::job::reports::m add columns $colCount
## -----------------------------
#    #::job::reports::m insert row end $col ;# Add the headers
#    #foreach row $addID {
#    #    $job(db,Name) eval "SELECT [join $col ,] from Addresses WHERE OrderNumber = $row" {
#    #        set ShipType [join [db eval "SELECT ShipmentType from ShipVia WHERE ShipViaName='[join $ShipVia]'"]]
#    #
#    #        if {$Company eq "JG Mail"} {set ShipType "JG Mail"}
#    #        ::job::reports::m insert row end [subst $cols]
#    #    }
#    #}
##------------------------------
#    
#    # Get unique versions
#    set versionNames [$job(db,Name) eval "SELECT distinct(Version) FROM Addresses WHERE Status=1 ORDER BY Version ASC"]
    #foreach vers $versionNames {
    ## Output Version Name
    #    set versNumOfShipments [$job(db,Name) eval "SELECT count(*) FROM Addresses WHERE Version='$vers' AND Status=1"]
    #    set versQuantity [$job(db,Name) eval "SELECT sum(Quantity) FROM Addresses WHERE Version='$vers' AND Status=1"]
    #    $txt insert end "====================\n\n"
    #    $txt insert end "Version: $vers\n"
    #    $txt insert end "Shipments: $versNumOfShipments - Quantity: $versQuantity\n"
        
        #if {[job::db::tableExists VersNotes] != ""} {
        #    set versNotes [join [$job(db,Name) eval "SELECT VersNotes_Notes FROM VersNotes WHERE VersNotes_Version = '$vers'"]]
        #    if {$versNotes != ""} {
        #       $txt insert end "Version Notes: $versNotes\n\n" 
        #    }
        #}
        
        # Create the matrix
        #struct::matrix::matrix m
        #::job::reports::m add columns $colCount
        #::job::reports::m insert row end $col ;# Add the headers
        #
        ## Get unique distribution types, for current version
        #set DistTypes [$job(db,Name) eval "SELECT distinct(DistributionType) FROM addresses WHERE Version='$vers' AND Status=1 ORDER BY DistributionType"]
        #if {[info exists comboDistTypes]} {unset comboDistTypes}
        #set gateway 0
        #foreach dist $DistTypes {
        #        
        #    # DistType associated with current version
        #    # Output Summary for Distribution Type
        #    # Output Carrier, Company and Quantity
        #    # Get total count for current distribution type
        #
        #    set distTypeNumOfShipments [$job(db,Name) eval "SELECT count(*) from Addresses WHERE Version='$vers' AND DistributionType='$dist' AND Status=1"]
        #    set distTypeQty [$job(db,Name) eval "SELECT sum(Quantity) FROM Addresses WHERE Version='$vers' AND DistributionType='$dist' AND Status=1"]
            
            # If the distribution type matches, UPS IMPORT, lets provide a grouped breakdown instead of the individual shipment
            # Handling the dist types that 'roll up' destinations into shipments.
            if {$dist eq "07. UPS Import" || $dist eq "09. USPS Import"} {
                set id [join [split $dist " "] ""]
                
                if {[info exists comboDistTypes($id,qty)]} {unset comboDistTypes($id,qty)}
                lappend comboDistTypes(names) $dist
                    
                $job(db,Name) eval "SELECT Quantity FROM Addresses WHERE Version='$vers' AND DistributionType='$dist' AND Status=1" {
                    #${log}::debug $Quantity $Version
                    lappend comboDistTypes($id,qty) $Quantity
                    set comboDistTypes($id,distTypeNumofShipments) $distTypeNumOfShipments
                    set comboDistTypes($id,distTypeQty) $distTypeQty
                }
            
            } else {
                set gateway 1
                    # Output detailed shipment information
                    $job(db,Name) eval "SELECT [join $col ,] FROM Addresses WHERE Version='$vers' AND DistributionType='$dist' AND Status=1 ORDER BY Quantity" {
                    #$job(db,Name) eval "SELECT ShipVia, Company, Quantity FROM Addresses WHERE Version='$vers' AND DistributionType='$dist' ORDER BY Quantity" {}
                        # Error capturing: Set a default value if nothing was put into the db
                        if {$ShipVia eq ""} {set ShipVia [mc "CARRIER NOT ASSIGNED"]}
                        if {$Company eq ""} {set Company [mc "COMPANY NOT ASSIGNED"]}
                        if {$Quantity eq ""} {set Quantity [mc "QUANTITY NOT ASSIGNED"]}
                        set ShipType [join [db eval "SELECT ShipmentType from ShipVia WHERE ShipViaName='[join $ShipVia]'"]]
                        
                        if {$Company eq "JG Mail"} {set ShipType "JG Mail"}
                        if {$Company eq "JG Inventory"} {set ShipType "JG Inventory"}
                        if {$Company eq "JG Bindery"} {set ShipType "JG Bindery"}
                        
                        ::job::reports::m insert row end [subst $cols]
                        
                        #$txt insert end "\t  $ShipVia, $Company - $Quantity\n"
                    }
            }
            # End of the Distribution Type
            #$txt insert end "-\n"
        }
        
        if {$gateway == 1} {
                ::report::report r $colCount style captionedtable 1
                $txt insert end [r printmatrix ::job::reports::m]
                ::job::reports::m destroy 
                r destroy
            } else {
                catch {::job::reports::m destroy}
                catch {r destroy}
            }
            
        if {[info exists comboDistTypes]} {
            foreach distType $comboDistTypes(names) {
                set id [join [split $distType " "] ""]
                $txt insert end "   <$distType> $comboDistTypes($id,distTypeNumofShipments) Shipments - $comboDistTypes($id,distTypeQty)\n\n"
                
                foreach single [lindex [Shipping_Code::extractFromList $comboDistTypes($id,qty)] 0] {
                    #${log}::debug Singles: 1 Shipment of $single
                    $txt insert end "    1 Shipment of $single\n"
                }
                
                foreach groups [lrange [Shipping_Code::extractFromList $comboDistTypes($id,qty)] 1 end] {
                    #${log}::debug Groups: [llength $groups] shipments of [lindex $groups 0]
                    $txt insert end "    [llength $groups] Shipments of [lindex $groups 0]\n\n"
                }
            }
        }
        
        # End of the Version
        $txt insert end "\n"
    }

    # Create the report
    #::report::report r $colCount style captionedtable 1
    #$txt insert end [r printmatrix ::job::reports::m]
    set fd [open [file join $job(SaveFileLocation) [ea::tools::formatFileName]_report.txt] w+]
    puts $fd [$txt get 0.0 end]
    
    # Insert user and date/time stamp
    puts $fd [mc {Report Generated by: %1$s} $env(USERNAME)] ;# Should be $user(login)
    puts $fd [clock format [clock seconds] -format "%A %D %I:%M %p"]
    chan close $fd

    #destroy ::job::reports::m
    #destroy r

} ;# job::reports::Detailed


proc job::reports::initReportTables {} {
    #****f* initReportTables/job::reports
    # CREATION DATE
    #   02/23/2015 (Monday Feb 23)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   job::reports::initReportTables  
    #
    # FUNCTION
    #	Initilizes the report tables
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

    ::report::defstyle simpletable {} {
        data	set [split "[string repeat "| "   [columns]]|"]
        top     set [split "[string repeat "+ - " [columns]]+"]
        bottom	set [top get]
        top	enable
        bottom	enable
    }

    ::report::defstyle captionedtable {{n 1}} {
        simpletable
        topdata   set [data get]
        topcapsep set [top get]
        topcapsep enable
        tcaption $n
    }
} ;# job::reports::initReportTables

proc ea::code::reports::writeExcel {args} {
    #****if* writeExcel/ea::code::reports
    # CREATION DATE
    #   11/02/2015 (Monday Nov 02)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   args - revision number
    #   
    #***
    global log job user
    
    if {$args eq ""} {set args 1}
    ${log}::debug Revision: $args

    # Setup workbook/worksheet
    set excel_id [Excel::Open]
    set workbook_id [Excel::AddWorkbook $excel_id]
    set worksheet_id [Excel::GetWorksheetIdByIndex $workbook_id 1]
    
    # Turn off screen updating
    Excel::ScreenUpdate $excel_id off

    
    set dist_blacklist [ea::db::getDistSetup]
    # These are the Columns of data that we want to put on the report
    set col [list {Company DistributionType PackageType ShipVia Notes Quantity ShipDate}]
    
    if {[info exists cols]} {unset cols}
    foreach item [join $col] {
        lappend cols "$$item"
    }
    
    # --- HEADER
    # JOB DESCRIPTION / NUMBER
    # Format: Job Description
    set id [Excel::SelectCellByIndex $worksheet_id 1 1]
        Excel::SetRangeHorizontalAlignment $id xlHAlignRight
    set id [Excel::SelectCellByIndex $worksheet_id 1 2]
        Excel::SetRangeFontBold $id
        Excel::SetRangeFontSize $id 14
        
    # INSERT: Job Description and data
    Excel::SetMatrixValues $worksheet_id [subst [list {"Job Title/Name" "$job(Title) $job(Name)"}]] 1 1
    
    # Format: Job Number
    set id [Excel::SelectCellByIndex $worksheet_id 1 4]
        Excel::SetRangeHorizontalAlignment $id xlHAlignRight
    set id [Excel::SelectCellByIndex $worksheet_id 1 5]
        Excel::SetRangeHorizontalAlignment $id xlHAlignLeft
        Excel::SetRangeFontBold $id
        Excel::SetRangeFontSize $id 14
        
    # INSERT: Job Number (data)
    Excel::SetMatrixValues $worksheet_id [subst [list {"Job Number" "$job(Number)"}]] 1 4
    
    # DATE
    set getDate [job::db::getShipDate -min ShipDate]
    if {[join $getDate] ne ""} {
        set shipDate [ea::date::formatDate -db -std $getDate]
        # Format: Ship Date (txt)
        set id [Excel::SelectCellByIndex $worksheet_id 1 7]
            Excel::SetRangeHorizontalAlignment $id xlHAlignRight
        # Format: Ship Date (data)
        set id [Excel::SelectCellByIndex $worksheet_id 1 8]
            Excel::SetRangeFontBold $id
            Excel::SetRangeFontSize $id 14
            Excel::SetRangeHorizontalAlignment $id xlHAlignLeft
        
        # INSERT: Ship Date (txt) and (data)
        Excel::SetMatrixValues $worksheet_id [subst [list {"1st Ship Date" "$shipDate"}]] 1 7
    }

    # JOB NOTES
    set jobNotes [job::db::getNotes -noteType Job -includeOnReports 1 -noteTypeActive 1 -notesActive 1]
        if {$jobNotes ne ""} {
            # Format: Job Notes (txt)
            set id [Excel::SelectCellByIndex $worksheet_id 2 1]
                Excel::SetRangeHorizontalAlignment $id xlHAlignRight
            # Format: Job Notes (data)
            set id [Excel::SelectRangeByIndex $worksheet_id 2 2 2 8]
                Excel::SetRangeMergeCells $id
                Excel::SetRangeHorizontalAlignment $id xlHAlignLeft
                Excel::SetRangeFontBold $id
                Excel::SetRangeFontSize $id 14
            # INSERT: Job Notes txt and data
           Excel::SetMatrixValues $worksheet_id [subst [list {"Job Notes" "$jobNotes"}]] 2 1
    }
    
    # TOTALS
    Excel::SetMatrixValues $worksheet_id [subst [list {"Totals"}]] 3 1
        set id [Excel::SelectRangeByIndex $worksheet_id 3 1 3 8]
        Excel::SetRangeMergeCells $id
        Excel::SetRangeHorizontalAlignment $id xlHAlignCenter
        Excel::SetRangeFontBold $id
        Excel::SetRangeFillColor $id 255 255 0
        Excel::SetRangeBorders $id
        
    ## Total Copies
    # Format: Copies (txt)
    set id [Excel::SelectCellByIndex $worksheet_id 4 1]
        Excel::SetRangeHorizontalAlignment $id xlHAlignRight
        Excel::SetRangeFontSize $id 14
    # Format: Copies (data)
    set id [Excel::SelectCellByIndex $worksheet_id 4 2]
        Excel::SetRangeHorizontalAlignment $id xlHAlignLeft
        Excel::SetRangeFontSize $id 14
        Excel::SetRangeFontBold $id
    # Insert: Copies txt and data
    Excel::SetMatrixValues $worksheet_id [subst [list {"Copies (Does not include overs)" "$job(TotalCopies)"}]] 4 1
        
    
    ## Total Versions
    set versionNames [job::db::getUsedVersions -active 1 -job $job(Number)]
    set numOfVersions [llength $versionNames]
    # Format: Versions (txt)
    set id [Excel::SelectCellByIndex $worksheet_id 4 4]
        Excel::SetRangeHorizontalAlignment $id xlHAlignRight
        Excel::SetRangeFontSize $id 14
    # Format: Versions (data)
    set id [Excel::SelectCellByIndex $worksheet_id 4 5]
        Excel::SetRangeHorizontalAlignment $id xlHAlignLeft
        Excel::SetRangeFontSize $id 14
        Excel::SetRangeFontBold $id
    # Insert: Versions txt and data
    Excel::SetMatrixValues $worksheet_id [subst [list {"Versions" "$numOfVersions"}]] 4 4

    
    ## Total Shipments
    set numOfShipments [$job(db,Name) eval "SELECT count(JobInformationID) FROM ShippingOrders WHERE JobInformationID = '$job(Number)'"]
    # Format: Shipments (txt)
    set id [Excel::SelectCellByIndex $worksheet_id 4 7]
        Excel::SetRangeHorizontalAlignment $id xlHAlignRight
        Excel::SetRangeFontSize $id 14
    # Format: Shipments (data)
    set id [Excel::SelectCellByIndex $worksheet_id 4 8]
        Excel::SetRangeHorizontalAlignment $id xlHAlignLeft
        Excel::SetRangeFontSize $id 14
        Excel::SetRangeFontBold $id
    # Insert: Shipments txt and data
    Excel::SetMatrixValues $worksheet_id [subst [list {"Shipments" "$numOfShipments"}]] 4 7

        
    # --- END HEADER
    set row 6
    foreach vers $versionNames {
        # HEADER for Versions
        set versNumOfShipments [job::db::getVersionCount -type NumOfVersions -job $job(Number) -version $vers -versActive 1 -addrActive 1]
        set versQuantity [job::db::getVersionCount -type CountQty -job $job(Number) -version $vers -versActive 1 -addrActive 1]
        # Get unique distribution types, for current version
        set DistTypes [job::db::getUsedDistributionTypes -version $vers -unique yes]
        
        # Format: Version
        set id [Excel::SelectCellByIndex $worksheet_id $row 1]
            Excel::SetRangeHorizontalAlignment $id xlHAlignRight
        # Format: Version data (name)
        set id [Excel::SelectCellByIndex $worksheet_id $row 2]  
            Excel::SetRangeFontBold $id
            Excel::SetRangeHorizontalAlignment $id xlHAlignLeft
            Excel::SetRangeFontSize $id 14
        # INSERT: Version, and Version Name
            Excel::SetMatrixValues $worksheet_id [subst [list {"Version" "$vers"}]] $row 1
        
        # Format: Shipments
        set id [Excel::SelectCellByIndex $worksheet_id $row 4]
            Excel::SetRangeHorizontalAlignment $id xlHAlignRight
        # Format: Shipment data
        set id [Excel::SelectCellByIndex $worksheet_id $row 5]
            Excel::SetRangeFontBold $id
            Excel::SetRangeHorizontalAlignment $id xlHAlignLeft
            Excel::SetRangeFontSize $id 14
        # INSERT: Shipments and Shipment data
            Excel::SetMatrixValues $worksheet_id [subst [list {"Shipments" "$versNumOfShipments"}]] $row 4    
        
        # Format: Quantity
        set id [Excel::SelectCellByIndex $worksheet_id $row 7]
            Excel::SetRangeHorizontalAlignment $id xlHAlignRight
        # Format: Quantity data
        set id [Excel::SelectCellByIndex $worksheet_id $row 8]
            Excel::SetRangeFontBold $id
            Excel::SetRangeHorizontalAlignment $id xlHAlignLeft
            Excel::SetRangeFontSize $id 14
        # INSERT: Quantity and Quantity data
            Excel::SetMatrixValues $worksheet_id [subst [list {"Quantity" "$versQuantity"}]] $row 7    
        
        # Range: Entire row settings
        set id [Excel::SelectRangeByIndex $worksheet_id $row 1 $row 8]
            Excel::SetRangeFillColor $id 255 255 0
            Excel::SetRangeBorders $id
        
        incr row
        # Format: Header row
        set xlID [Excel::SelectRangeByIndex $worksheet_id $row 1 $row 8]
            Excel::SetRangeFontBold $xlID
            Excel::SetRangeHorizontalAlignment $xlID xlHAlignLeft
        # Insert: Header data
        Excel::SetMatrixValues $worksheet_id $col $row 1
        
        incr row
        foreach dist $DistTypes {
            #${log}::debug cycling through dist: $dist
            # If the distribution type matches, UPS IMPORT, lets provide a grouped breakdown instead of the individual shipment
            # Handling the dist types that 'roll up' destinations into shipments.
            set clean_dist_blacklist [string map {' \"} $dist_blacklist]
            set clean_dist_blacklist [string map {"\"" ""} $clean_dist_blacklist]
            #${log}::debug clean blacklist: $clean_dist_blacklist
            if {[lsearch $clean_dist_blacklist $dist] != -1} {
                    # DistType associated with current version
                    # Output Summary for Distribution Type
                    # Output Carrier, Company and Quantity
                    # Get total count for current distribution type
                    #${log}::debug blacklist: Cycling through dist: $dist
                    set distTypeNumOfShipments [job::db::getDistTypeCounts -type numOfShipments -dist $dist -job $job(Number)]
                    set distTypeQty [job::db::getDistTypeCounts -type qtyInDistType -dist $dist -job $job(Number)]
                    set id [join [split $dist " "] ""]
                    
                    if {[info exists comboDistTypes($id,qty)]} {unset comboDistTypes($id,qty)}
                    lappend comboDistTypes(names) $dist

                    $job(db,Name) eval "SELECT Quantity FROM ShippingOrders
                            INNER JOIN Addresses ON Addresses.SysAddresses_ID = ShippingOrders.AddressID
                            INNER JOIN Versions ON ShippingOrders.Versions = Versions.Version_ID
                                WHERE ShippingOrders.JobInformationID = '$job(Number)'
                                    AND ShippingOrders.Hidden = 0
                                    AND Versions.VersionName = '$vers'
                                    AND DistributionType = '$dist'
                                    AND Addresses.SysActive = 1" {
                                lappend comboDistTypes($id,qty) $Quantity
                                set comboDistTypes($id,distTypeNumofShipments) $distTypeNumOfShipments
                                set comboDistTypes($id,distTypeQty) $distTypeQty
                            }
                
                } else {
                    #${log}::debug dist: $dist - creating single shipments
                        # Output detailed shipment information
                        #${log}::debug col: [join [join [join $col]] ,]
                        #${log}::debug cols: $cols
                        $job(db,Name) eval "SELECT [join [join [join $col]] ,] FROM ShippingOrders
                                                INNER JOIN Addresses on Addresses.SysAddresses_ID = ShippingOrders.AddressID
                                                INNER JOIN Versions on Versions.Version_ID = ShippingOrders.Versions
                                                    WHERE ShippingOrders.JobInformationID = '$job(Number)'
                                                        AND Versions.VersionName = '$vers'
                                                        AND DistributionType = '$dist'
                                                        AND Addresses.SysActive = 1
                                                        AND Versions.VersionActive = 1
                                                ORDER BY Addresses.DistributionType, ShippingOrders.Quantity" {
                                                    #${log}::debug Entering individual shipments...
                                                    # Error capturing: Set a default value if nothing was put into the db
                                                    if {$ShipVia eq ""} {set ShipVia [mc "CARRIER NOT ASSIGNED"]}
                                                    if {$Company eq ""} {set Company [mc "COMPANY NOT ASSIGNED"]}
                                                    if {$Quantity eq ""} {set Quantity [mc "QUANTITY NOT ASSIGNED"]}
                                                    
                                                    set ShipType [join [db eval "SELECT ShipmentType from ShipVia WHERE ShipViaName='[join $ShipVia]'"]]
                                                    set cols [string map {$ShipVia $ShipType} $cols]
                                                    
                                                    if {$Company eq "JG Mail"} {set ShipType "JG Mail"}
                                                    if {$Company eq "JG Inventory"} {set ShipType "JG Inventory"}
                                                    if {$Company eq "JG Bindery"} {set ShipType "JG Bindery"}

                                                    # Insert: Data
                                                    Excel::SetMatrixValues $worksheet_id [subst [list $cols]] $row 1
                                                    incr row

                                                }
                }
        } ;# end of distribution type
        
        if {[info exists comboDistTypes]} {
            foreach distType $comboDistTypes(names) {
                set id [join [split $distType " "] ""]
                set xlID [Excel::SelectRangeByIndex $worksheet_id $row 2 $row 3]
                    Excel::SetRangeMergeCells $xlID
                    Excel::SetRangeHorizontalAlignment $xlID xlHAlignCenter
                    Excel::SetRangeFontBold $xlID
                    Excel::SetCellValue $worksheet_id $row 2 "<$distType> Shipments: $comboDistTypes($id,distTypeNumofShipments), Quantity: $comboDistTypes($id,distTypeQty)"

                incr row
                
                foreach single [lindex [Shipping_Code::extractFromList $comboDistTypes($id,qty)] 0] {
                    set xlID [Excel::SelectRangeByIndex $worksheet_id $row 2 $row 2]
                        Excel::SetRangeHorizontalAlignment $xlID xlHAlignRight
                        Excel::SetCellValue $worksheet_id $row 2 "1 Shipment of  "
                    
                    set xlID [Excel::SelectRangeByIndex $worksheet_id $row 3 $row 3]
                        Excel::SetRangeHorizontalAlignment $xlID xlHAlignLeft
                        Excel::SetMatrixValues $worksheet_id "  $single" $row 3
                    incr row
                }
                
                foreach groups [lrange [Shipping_Code::extractFromList $comboDistTypes($id,qty)] 1 end] {
                    set grp [llength $groups]
                    set idx_grp [lindex $groups 0]
                    set xlID [Excel::SelectRangeByIndex $worksheet_id $row 2 $row 2]
                        Excel::SetRangeHorizontalAlignment $xlID xlHAlignRight
                        Excel::SetCellValue $worksheet_id $row 2 "$grp Shipments of  "
                        
                    set xlID [Excel::SelectRangeByIndex $worksheet_id $row 3 $row 3]
                        Excel::SetRangeHorizontalAlignment $xlID xlHAlignLeft
                        Excel::SetMatrixValues $worksheet_id [list "  $idx_grp"] $row 3

                    incr row
                }
                incr row
            }
            unset comboDistTypes
            #incr row
        }
        incr row
    }
    set xlID [Excel::SelectRangeByIndex $worksheet_id $row 1 $row 1]
                        Excel::SetRangeHorizontalAlignment $xlID xlHAlignLeft
                        Excel::SetCellValue $worksheet_id $row 1 "Report Generated by: $user(id)  "
    incr row
    set xlID [Excel::SelectRangeByIndex $worksheet_id $row 1 $row 1]
                        Excel::SetRangeHorizontalAlignment $xlID xlHAlignLeft
                        Excel::SetCellValue $worksheet_id $row 1 "Revision: $args - [clock format [clock seconds] -format "%A %D %I:%M %p"]"
                        

    # Update the spreadsheet
    Excel::ScreenUpdate $excel_id on
    ## ** Page Setup
    Excel::SetWorksheetOrientation $worksheet_id xlLandscape
    ea::code::reports::SetGridLines $worksheet_id true

    # Autosize columns
    Excel::SetColumnsWidth $worksheet_id 1 8
    
    ea::code::reports::SetPaperSize $worksheet_id xlPaperLegal
    # These settings are what Excel considers 'Narrow' margins
    ea::code::reports::SetMargins $worksheet_id .25 .25 .75 .75 .3 .3
    
    ## ** Preferences
    Excel::SaveAs $workbook_id [file join $job(JobSaveFileLocation) [ea::tools::formatFileName]-rev_$args]
    Excel::SetWorksheetFitToPages $worksheet_id 1 0

} ;# ea::code::reports::writeExcel

proc ea::code::reports::SetGridLines {worksheetId bool} {
    #****if* SetGridLines/ea::code::reports
    # CREATION DATE
    #   11/05/2015 (Thursday Nov 05)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   
    #   
    #***
    global log

    set pageSetup [$worksheetId PageSetup]
    $pageSetup PrintGridlines [Cawt TclBool $bool]

} ;# ea::code::reports::SetGridLines

proc ea::code::reports::SetPaperSize { worksheetId paperSize} {
    #****if* SetPaperSize/ea::code::reports
    # CREATION DATE
    #   11/05/2015 (Thursday Nov 05)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   
    #   
    #***
    set pageSetup [$worksheetId PageSetup]
    $pageSetup PaperSize [Excel GetEnum $paperSize]
    
} ;# ea::code::reports::SetPaperSize 

proc ea::code::reports::SetMargins {worksheetId lmargin rmargin tmargin bmargin hmargin fmargin} {
    #****if* SetMargins/ea::code::reports
    # CREATION DATE
    #   11/05/2015 (Thursday Nov 05)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   
    #   
    #***
    set pageSetup [$worksheetId PageSetup]
    $pageSetup LeftMargin [Cawt::InchesToPoints $lmargin]
    $pageSetup RightMargin [Cawt::InchesToPoints $rmargin]
    $pageSetup TopMargin [Cawt::InchesToPoints $tmargin]
    $pageSetup BottomMargin [Cawt::InchesToPoints $bmargin]
    $pageSetup FooterMargin [Cawt::InchesToPoints $fmargin]
    
} ;# ea::code::reports::SetMargins 

    #With ActiveSheet.PageSetup
    #    .LeftHeader = ""
    #    .CenterHeader = ""
    #    .RightHeader = ""
    #    .LeftFooter = ""
    #    .CenterFooter = ""
    #    .RightFooter = ""
    #    .LeftMargin = Application.InchesToPoints(0.25)
    #    .RightMargin = Application.InchesToPoints(0.25)
    #    .TopMargin = Application.InchesToPoints(0.75)
    #    .BottomMargin = Application.InchesToPoints(0.75)
    #    .HeaderMargin = Application.InchesToPoints(0.3)
    #    .FooterMargin = Application.InchesToPoints(0.3)
    #    .PrintHeadings = False
    #    .PrintGridlines = True
    #    .PrintComments = xlPrintNoComments
    #    .PrintQuality = 600
    #    .CenterHorizontally = False
    #    .CenterVertically = False
    #    .Orientation = xlLandscape
    #    .Draft = False
    #    .PaperSize = xlPaperLegal
    #    .FirstPageNumber = xlAutomatic
    #    .Order = xlDownThenOver
    #    .BlackAndWhite = False
    #    .Zoom = False
    #    .FitToPagesWide = 1
    #    .FitToPagesTall = 1
    #    .PrintErrors = xlPrintErrorsDisplayed
    #    .OddAndEvenPagesHeaderFooter = False
    #    .DifferentFirstPageHeaderFooter = False
    #    .ScaleWithDocHeaderFooter = True
    #    .AlignMarginsHeaderFooter = True
    #    .EvenPage.LeftHeader.Text = ""
    #    .EvenPage.CenterHeader.Text = ""
    #    .EvenPage.RightHeader.Text = ""
    #    .EvenPage.LeftFooter.Text = ""
    #    .EvenPage.CenterFooter.Text = ""
    #    .EvenPage.RightFooter.Text = ""
    #    .FirstPage.LeftHeader.Text = ""
    #    .FirstPage.CenterHeader.Text = ""
    #    .FirstPage.RightHeader.Text = ""
    #    .FirstPage.LeftFooter.Text = ""
    #    .FirstPage.CenterFooter.Text = ""
    #    .FirstPage.RightFooter.Text = ""