# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 03 11,2015
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
# This file contains code that pertains to data checks.

namespace eval ea::validate {}

proc ea::validate::checkCountryAgainstZip {} {
    #****f* checkCountryAgainstZip/ea::validate
    # CREATION DATE
    #   03/11/2015 (Wednesday Mar 11)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::validate::checkCountryAgainstZip  
    #
    # FUNCTION
    #   We assume the zip is correct.
    #	Ensures that the Country code is correct (or there is one), and populates the Country Column.
    #   If the province doesn't match the zip code, we also fix that.
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   We first compare the Province to the PostalCode's. If we don't receive a country, we then compare the postal code to the list of countries.
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log job ;#countryCode

    catch {$job(db,Name) eval "ATTACH 'EA_setup.edb' AS db1"}
    ${log}::info [mc "-- Starting validation checks on Country..."]
    if {[info exists countryCode]} {unset countryCode}
    
    $job(db,Name) eval "SELECT distinct(State), Zip, OrderNumber FROM Addresses" {
            set zipLength [string range $Zip 0 0]
            set cCode [$job(db,Name) eval "SELECT distinct(db1.Countries.CountryCode) as cCode from db1.Provinces 
                        INNER JOIN Countries ON Provinces.CountryID = Countries.Country_ID
                            WHERE ProvAbbr = '$State'
                        AND PostalCodeLowEnd LIKE '$zipLength%'"]
        
        # Ensure we have a value, if we don't its because the zip/province doesn't match
        if {$cCode eq ""} {
            #${log}::info "State and Zip do not match: $State $Zip"
            # Launch another proc to change BOTH State AND Country
            ${log}::info [mc "Found a mismatched Province/Zip ($State $Zip), attempting to correct..."]
            set byZip [$job(db,Name) eval "SELECT distinct(db1.Countries.CountryCode) as cCode, db1.Provinces.ProvAbbr as provAbbr from db1.Provinces 
                    INNER JOIN Countries ON Provinces.CountryID = Countries.Country_ID
                        WHERE PostalCodeLowEnd LIKE '$zipLength%'"]
            #${log}::debug "UPDATE Country AND State: $byZip ID: $OrderNumber"
            #lappend countryCode($byZip) $OrderNumber
            

        } else {
            lappend countryCode($cCode) $OrderNumber
            #puts "UPDATE $State = $cCode ID: $OrderNumber"
        }
    }
    #puts [array names countryCode]
    #parray countryCode
    foreach country [array names countryCode] {
        ${log}::info [mc "Found the correct country code ($country); inserting ..."]
        set nums [join $countryCode($country) ,]
        job::db::multiWrite $job(db,Name) Addresses Country $country OrderNumber $nums
        #${log}::debug UPDATE Addresses SET Country='$country' WHERE OrderNumber IN ($nums)
    }


    catch {$job(db,Name) eval "DETACH 'EA_setup.edb'"}
} ;# ea::validate::checkCountryAgainstZip

proc ea::validate::checkProvinceAgainstZip {} {
    #****f* checkProvinceAgainstZip/ea::validate
    # CREATION DATE
    #   03/12/2015 (Thursday Mar 12)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::validate::checkProvinceAgainstZip  
    #
    # FUNCTION
    #	Validates that the provinces and zip's match; if they don't we attempt to correct them.
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
    
    catch {$job(db,Name) eval "ATTACH 'EA_setup.edb' AS db1"}
    ${log}::info [mc "-- Starting validation checks on Province..."]
    
    if {[info exists prov_list]} {unset prov_abbr}
    $job(db,Name) eval "SELECT distinct(Zip), State, OrderNumber FROM Addresses" {
            set zipLength [string range $Zip 0 1]
            puts "State/Zip: $State $Zip"
            $job(db,Name) eval "SELECT distinct(db1.Countries.CountryCode) as cCode, db1.Provinces.ProvAbbr as provAbbr from db1.Provinces 
                    INNER JOIN Countries ON Provinces.CountryID = Countries.Country_ID
                        WHERE PostalCodeLowEnd LIKE '$zipLength%'"
            #puts [$job(db,Name) eval "SELECT db1.Provinces.ProvAbbr as provAbbr from db1.Provinces WHERE PostalCodeLowEnd LIKE '$zipLength%'"]
            #puts $prov_abbr
            #if {$prov_abbr != ""} {
            #    #lappend prov_list($prov_abbr) $OrderNumber
            #    puts $prov_abbr
            #}
    }
    
    foreach prov [array names prov_list] {
        #${log}::info [mc "Found the correct country code ($country); inserting ..."]
        set nums [join $prov_list($prov) ,]
        #job::db::multiWrite $job(db,Name) Addresses Country $country OrderNumber $nums
        ${log}::debug UPDATE Addresses SET State='$prov' WHERE OrderNumber IN ($nums)
    }
    

    
} ;# ea::validate::checkProvinceAgainstZip
