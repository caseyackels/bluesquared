# Creator: Casey Ackels
# Initial Date: July 9th, 2012]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 338 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate$
#
########################################################################################

##
## - Overview
# This file holds the parent GUI frame, buttons and menu for Distribution Helper

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

## Coding Conventions
# - Namespaces:

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

proc eAssist_Code::processAddresses {name args} {
    #****f* processAddresses/eAssist_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2012 - Casey Ackels
    #
    # FUNCTION
    #	Process each part of the address, making sure they pass verifications
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #
    #
    # PARENTS
    #	eAssist_Code::writeOutPut
    #
    # NOTES
    #
    # SEE ALSO
    #
    #
    #***
    set addrItem ""

    switch -- [lindex $name] {
        Company {
            set addrItem [eAssist_Code::StringLength $args]
            #puts "company: $addrItem"
        }
        Attention {
            set addrItem [eAssist_Code::StringLength $args]
        }
        delAddr {
            # Addresses must be specially handled, see [eAssist_Code::cleanse]
            set returnItem [eAssist_Code::cleanse $args]
           return $returnItem
        }
        delAddr2    {}
        delAddr3    {}
        City        {
            #et addrItem [eAssist_Code::StringLength $args]
        }
        State       {
            set state [eAssist_Code::ListToString [join [split $args " "] ""]]
            lappend addrItem pass $state
        }
        Country     {}
        Phone       {
            set addrItem [eAssist_Code::CleansePhone $args]
        }
        Zip         {
            set newZip [join [split $args -] ""]
            set newZip [eAssist_Code::ListToString [join [split $newZip " "] ""]] ;# Get rid of any spaces (notably canadian zips)
            lappend addrItem pass $newZip ;# Basic parsing, so we don't need any other checks
        }
        Email       {}
        Version     {}
    }
    
    if {[lindex $addrItem 0] eq "fail"} {
        # Failed; truncate down to 35 characters.
        set returnItem [lindex $addrItem 2]
    } else {
        # We passed, so we don't need any modifications
        set returnItem [lindex $addrItem 1]
    }
    
    #puts "return: $returnItem"
    return $returnItem
} ;# End eAssist_Code::processAddresses


proc eAssist_Code::CleansePhone {args} {
    #****f* CleansePhone/eAssist_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2012 - Casey Ackels
    #
    # FUNCTION
    #	Clean all extra characters from the phone number
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #
    #
    # PARENTS
    #	
    #
    # NOTES
    #   This should probably be a GUI listbox option, so we can configure it on the fly
    #
    # SEE ALSO
    #
    #
    #***
    set phoneChars [list EX EXT - . X " " ( ) { } +]
    set newPhone $args
    
    foreach char $phoneChars {
        set newPhone [join [split $newPhone $char] ""]
    }
    
    set newPhone [eAssist_Code::ListToString $newPhone]
    
    # If we don't have a phone number, lets insert a default.
    # THIS SHOULD BE A GUI CONFIG OPTION.
    #if {$newPhone == ""} {
    #    set newPhone 5037909100
    #}
    
    if {[string length $newPhone] <= 15} {
        set newPhoneTmp [list pass $newPhone]
    } else {
        tk_messageBox -message "Phone number is longer than 15 chars!\n$newPhone"
        return 
    }
    
    return $newPhoneTmp
}
    
proc eAssist_Code::ListToString {args} {
    #****f* ListToString/eAssist_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2012 - Casey Ackels
    #
    # FUNCTION
    #	Convert List to String, and remove curly braces
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #
    #
    # PARENTS
    #	
    #
    # NOTES
    #
    # SEE ALSO
    #
    #
    #***
    
    set args [join $args] ;# convert to strings
    set args [string trim $args \{]
    set args [string trim $args \}]
    
    return $args
}

proc eAssist_Code::StringLength {args} {
    #****f* StringLength/eAssist_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2012 - Casey Ackels
    #
    # FUNCTION
    #	find the length of the string.
    #	Returns [fail|pass] args ?args_fixed?
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #
    #
    # PARENTS
    #	
    #
    # NOTES
    #
    # SEE ALSO
    #
    #
    #***
    
    set args [eAssist_Code::ListToString $args]
    

    if {[string length $args] >= 35} {
            #puts "FAILED - LENGTH: [string length $args]"
            #puts "$name $args"
        set args_fixed [string replace $args 34 end]
            #puts "FIXED - $name $args_fixed"
        return [list fail $args $args_fixed]
    } else {
            #puts "PASSED - LENGTH: [string length $args]"
            #puts "$name $args"
        return [list pass $args]
    }
}


proc eAssist_Code::cleanse {args} {
    #****f* cleanse/eAssist_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2012 - Casey Ackels
    #
    # FUNCTION
    #	Cleanse the street address
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #
    #
    # PARENTS
    #	
    #
    # NOTES
    #
    # SEE ALSO
    #
    #
    #***
    global L_secondaryUnit
    set args [eAssist_Code::ListToString $args]
    set addr [eAssist_Code::StringLength $args]
    
    
    if {[lindex $addr 0] eq "fail"} {
        #puts "***FAILED***: $addr"
        set addr1 [eAssist_Code::ListToString [lindex $addr 1]]
        #puts "*** $addr1"
        
        foreach item $L_secondaryUnit {
            set has_secondary [lsearch $addr1 *$item*]
            if {$has_secondary != -1} {
                #puts "*** [lrange $addr1 0 [expr $has_secondary -1]]"
                set add1 [lrange $addr1 0 [expr $has_secondary -1]]
                #puts "*** [lrange $addr1 $has_secondary end]"
                set add2 [lrange $addr1 $has_secondary end]
            }
        }
        return [list fail $add1 $add2]
        #Error_Message::errorMsg deladdress1 [eAssist_Code::ListToString [lindex $addr 1]]
    } else {
        #puts "returning addr: $addr"
        return [lindex $addr 1]
    }
    
}


proc eAssist_Code::international {country pieceweight date boxqty} {
    #****f* international/eAssist_Code
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2012 - Casey Ackels
    #
    # FUNCTION
    #	Configure variables if we're doing an international shipment
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #
    #
    # PARENTS
    #	
    #
    # NOTES
    #
    # SEE ALSO
    #
    #
    #***
    global GS_job intl international company importFile ship
    
    # See startup.tcl file to see the what variables are being initialized in the array's.
    if {$country eq "US"} {
        # Clear out variables in case we are not shipping international.
        'debug COUNTRY_1 = $country
        set GS_job(country) US
        
        array set intl {
            01_ItemDescription $GS_job(Description)
            02_ItemNumber "1"
            03_ItemQuantity $boxqty
            04_UOM ""
            05_DutiesPayer ""
            06_DutiesPayerAccountNumber ""
            07_License ""
            08_LicenseDate ""
            09_CountryOfOrigin ""
            10_TermsOfShipment ""
            11_UnitValue ""
            12_ItemWeight ""
            13_PackingType ""
        }
        
        set intl(01_ItemDescription) $GS_job(Description)
        set intl(02_ItemNumber) 1
        set intl(03_ItemQuantity) $boxqty

        array set ship {
            01_ShipFromName ""
            02_ShipFromContact ""
            03_ShipFromAddressLine1 ""
            04_ShipFromAddressLine2 ""
            05_ShipFromCity ""
            06_ShipFromState ""
            07_ShipFromCountry ""
            08_ShipFromZipCode ""
            09_ShipFromPhoneNo ""
        }
    } else {
        'debug COUNTRY_2 = $country
        set GS_job(country) Other
            if {$international(itemDesc,check) == 1} {
                set intl(01_ItemDescription) $GS_job(Description)
                puts "DESC_1 $intl(01_ItemDescription)"
            } else {
                set intl(01_ItemDescription) $international(itemDesc)
                puts "DESC_2 $intl(01_ItemDescription)"
            }
        
        set intl(02_ItemNumber) 1
        set intl(03_ItemQuantity) $boxqty
        set intl(04_UOM) $international(uom)
        set intl(05_DutiesPayer) $international(dutiesPayer)
        set intl(06_DutiesPayerAccountNumber) $international(dutiesPayerAcct)
        set intl(07_License) $international(license)
        set intl(08_LicenseDate) $date
        set intl(09_CountryOfOrigin) $international(countryOfOrigin)
        set intl(10_TermsOfShipment) $international(termsOfShipment)
        set intl(11_UnitValue) $international(unitValue)
        set intl(12_ItemWeight) $pieceweight
        set intl(13_PackingType) "" ;#$international(packingType)
        
        set ship(01_ShipFromName) $company(name)
        set ship(02_ShipFromContact) $company(contact)
        set ship(03_ShipFromAddressLine1) $company(addr1)
        set ship(04_ShipFromAddressLine2) $company(addr2)
        set ship(05_ShipFromCity) $company(city)
        set ship(06_ShipFromState) $company(state)
        set ship(07_ShipFromCountry) $company(country)
        set ship(08_ShipFromZipCode) $company(zip)
        set ship(09_ShipFromPhoneNo) $company(phone)
    }


}