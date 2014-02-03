# Creator: Casey Ackels
# Initial Date: February 2, 2014]
# File Initial Date: Feb 2,2014
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

proc eAssistSetup::addCarrierSetup {varType entryField listBox} {
    #****f* addCarrierSetup/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Add values to listbox
    #	entryField = Path to widget
    #   listBox = Path to widget
    #   Type = what it is, for the switch to work correctly
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
    #   THis could be refactored into [eAssistSetup::addToIntlListbox] and [eAssistSetup::removeFromIntlListbox]
    #
    # SEE ALSO
    #
    #***
    global log carrierSetup
    ${log}::debug --START-- [info level 1]
    
    ${log}::debug Adding $varType, $entryField, $listBox
    
    if {[$entryField get] == ""} {return}

    switch -- $varType {
            PAYMENT     {
                        set entryValue $carrierSetup(enterPaymentType)
                        set newVarType PaymentType
                        ${log}::debug PAYMENT - $entryField
            }
            SHIPMENT    {
                        set entryValue $carrierSetup(enterShipmentType)
                        set newVarType ShipmentType
                        ${log}::debug SHIPMENT - $entryField
            }
            CARRIERS    {
                        set entryValue $carrierSetup(enterCarrier)
                        set newVarType CarrierList
                        ${log}::debug CARRIERS - $entryField
            }
            RATES       {
                        set entryValue $carrierSetup(enterRateType)
                        set newVarType RateType
                        ${log}::debug RATES - $entryField
            }
            default     {
                        ${log}::debug Nothing set for this SWITCH command
            }
    }

    ${log}::debug Adding _ $entryField _ to $newVarType Listbox
    
    $listBox insert end $entryValue
    $entryField delete 0 end
    
    
    
    set carrierSetup($newVarType) [$listBox get 0 end]
    ${log}::debug $newVarType _ADD: [$listBox get 0 end]
    
	
    ${log}::debug --END-- [info level 1]
} ;# eAssistSetup::addCarrierSetup


proc eAssistSetup::delCarrierSetup {varType listBox} {
    #****f* delCarrierSetup/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Delete selected items from listbox
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
    global log carrierSetup
    ${log}::debug --START-- [info level 1]
    
    if {[$listBox curselection] == ""} {return}
    # Delete the entry, then set the var to all values remaining values.
    $listBox delete [$listBox curselection]
    set carrierSetup($varType) [$listBox get 0 end]
	
    ${log}::debug --END-- [info level 1]
} ;# eAssistSetup::delCarrierSetup
