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
                -xscrollcommand [list $f1.scrollx set] \
                -yscrollcommand [list $f1.scrolly set]
        
        # setup the autoscroll bars
    ttk::scrollbar $f1.scrollx -orient h -command [list $f1.txt xview]
    ttk::scrollbar $f1.scrolly -orient v -command [list $f1.txt yview]
    
    
    #ttk::button $f1.btn1 -text "OK" -command {job::reports::DistributionType .rv.f1.txt [.rv.f1.cbox1 get]}
    
    #grid $f1.cbox1 -column 0 -row 0 -sticky nsw
    #grid $f1.entry1 -column 0 -row 0 -sticky nsw
    #grid $f1.btn1 -column 1 -row 0 -sticky ew
    
    grid $f1.txt -column 0 -row 1 -sticky news
    grid columnconfigure $f1 0 -weight 2
    grid rowconfigure $f1 1 -weight 2
    
    grid $f1.scrolly -column 1 -row 1 -sticky nse
    grid $f1.scrollx -column 0 -row 2 -sticky ews
    
    ::autoscroll::autoscroll $f1.scrollx ;# Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $f1.scrolly ;# Enable the 'autoscrollbar'
    
    $f1.txt delete 0.0 end

    job::reports::Detailed $f1.txt
} ;# job::reports::Viewer


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

    # Should be a user defined list ...
    set col "Company Quantity ShipVia Notes PackageType"
    
    
    set addID [$job(db,Name) eval "SELECT OrderNumber FROM Addresses"]
    set rowCount [llength $addID]
    
    set colCount [llength $col]
    
    set newCol $col
    # We don't want the shipvia code, we want the shipment type (freight, small package)
    set newCol [string map {ShipVia ShipType} $newCol]
    
    if {[info exists cols]} {unset cols}
    foreach item $newCol {
        lappend cols $$item
    }
    
    # Header - Job Name, Title, Num of Versions, Total Count
    $txt insert end "Job Number: $job(Number)\n"
    $txt insert end "Job Title/Name: $job(Title) / $job(Name)\n\n"
    
    set numOfVersions [$job(db,Name) eval "SELECT count(distinct(Version)) FROM Addresses"]
    $txt insert end "Number of Versions: $numOfVersions\n"

    set numOfShipments [$job(db,Name) eval "SELECT count(*) FROM Addresses"]
    $txt insert end "Number of Shipments: $numOfShipments\n"
    
    set totalQtyOfShipments [$job(db,Name) eval "SELECT sum(Quantity) FROM Addresses"]
    $txt insert end "Total Quantity: $totalQtyOfShipments\n"

    # Schema testing; this exists in version 3 and higher
    #set errStr "no such table:"
    if {[job::db::tableExists Notes] != ""} {
        set jobNotes [join [lindex [$job(db,Name) eval "SELECT max(Notes_ID), Notes_Notes FROM Notes"] 1]]
        if {$jobNotes != ""} {
           $txt insert end "\nJob Notes: $jobNotes\n"
        }
        $txt insert end \n
    }
    

    ## Create the matrices
    #struct::matrix::matrix m
    #::job::reports::m add columns $colCount
# -----------------------------
    #::job::reports::m insert row end $col ;# Add the headers
    #foreach row $addID {
    #    $job(db,Name) eval "SELECT [join $col ,] from Addresses WHERE OrderNumber = $row" {
    #        set ShipType [join [db eval "SELECT ShipmentType from ShipVia WHERE ShipViaName='[join $ShipVia]'"]]
    #
    #        if {$Company eq "JG Mail"} {set ShipType "JG Mail"}
    #        ::job::reports::m insert row end [subst $cols]
    #    }
    #}
#------------------------------
    
    # Get unique versions
    set versionNames [$job(db,Name) eval "SELECT distinct(Version) FROM Addresses ORDER BY Version ASC"]
    foreach vers $versionNames {
    # Output Version Name
        set versNumOfShipments [$job(db,Name) eval "SELECT count(*) FROM Addresses WHERE Version='$vers'"]
        set versQuantity [$job(db,Name) eval "SELECT sum(Quantity) FROM Addresses WHERE Version='$vers'"]
        $txt insert end "====================\n\n"
        $txt insert end "VERSION: $vers\n"
        $txt insert end "Shipments: $versNumOfShipments - Quantity: $versQuantity\n"
        
        #if {[job::db::tableExists VersNotes] != ""} {
        #    set versNotes [join [$job(db,Name) eval "SELECT VersNotes_Notes FROM VersNotes WHERE VersNotes_Version = '$vers'"]]
        #    if {$versNotes != ""} {
        #       $txt insert end "Version Notes: $versNotes\n\n" 
        #    }
        #}
        
        # Create the matrix
        struct::matrix::matrix m
        ::job::reports::m add columns $colCount
        ::job::reports::m insert row end $col ;# Add the headers
        
        # Get unique distribution types, for current version
        set DistTypes [$job(db,Name) eval "SELECT distinct(DistributionType) FROM addresses WHERE Version='$vers' ORDER BY DistributionType"]
        if {[info exists comboDistTypes]} {unset comboDistTypes}
        set gateway 0
        foreach dist $DistTypes {
                
            # DistType associated with current version
            # Output Summary for Distribution Type
            # Output Carrier, Company and Quantity
            # Get total count for current distribution type

            set distTypeNumOfShipments [$job(db,Name) eval "SELECT count(*) from Addresses WHERE Version='$vers' AND DistributionType='$dist'"]
            set distTypeQty [$job(db,Name) eval "SELECT sum(Quantity) FROM Addresses WHERE Version='$vers' AND DistributionType='$dist'"]
            
            # If the distribution type matches, UPS IMPORT, lets provide a grouped breakdown instead of the individual shipment
            # Handling the dist types that 'roll up' destinations into shipments.
            if {$dist eq "07. UPS Import" || $dist eq "09. USPS Import"} {
                set id [join [split $dist " "] ""]
                
                if {[info exists comboDistTypes($id,qty)]} {unset comboDistTypes($id,qty)}
                lappend comboDistTypes(names) $dist
                    
                $job(db,Name) eval "SELECT Quantity FROM Addresses WHERE Version='$vers' AND DistributionType='$dist'" {
                    #${log}::debug $Quantity $Version
                    lappend comboDistTypes($id,qty) $Quantity
                    set comboDistTypes($id,distTypeNumofShipments) $distTypeNumOfShipments
                    set comboDistTypes($id,distTypeQty) $distTypeQty
                }
            
            } else {
                set gateway 1
                    # Output detailed shipment information
                    $job(db,Name) eval "SELECT [join $col ,] FROM Addresses WHERE Version='$vers' AND DistributionType='$dist' ORDER BY Quantity" {
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
    puts $fd [mc {Report Generated by: %1$s} $env(USERNAME)]
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
