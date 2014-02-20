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

proc eAssistSetup::addPackagingSetup {varType entryField listBox} {
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
    global log packagingSetup
    ${log}::debug --START-- [info level 1]
    
    ${log}::debug Adding $varType, $entryField, $listBox
    
    if {[$entryField get] == ""} {return}

    switch -- $varType {
            PACKAGE     {
                        set entryValue $packagingSetup(enterPackageType)
                        set newVarType PackageType
                        ${log}::debug PACKAGE - $entryField
            }
            CONTAINER    {
                        set entryValue $packagingSetup(enterContainerType)
                        set newVarType ContainerType
                        ${log}::debug CONTAINER - $entryField
            }
            default     {
                        ${log}::debug Nothing set for this SWITCH command
            }
    }

    ${log}::debug Adding _ $entryField _ to $newVarType Listbox
    
    $listBox insert end $entryValue
    $entryField delete 0 end
    
    
    
    set packagingSetup($newVarType) [$listBox get 0 end]
    ${log}::debug $newVarType _ADD: [$listBox get 0 end]
    
	
    ${log}::debug --END-- [info level 1]
} ;# eAssistSetup::addCarrierSetup


proc eAssistSetup::delPackagingSetup {varType listBox} {
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
    global log packagingSetup
    ${log}::debug --START-- [info level 1]
    
    if {[$listBox curselection] == ""} {return}
    
    # Delete the entry, then set the var to all values remaining values.
    $listBox delete [$listBox curselection]
    
    switch -- $varType {
            PACKAGE     {
                        set newVarType PackageType
            }
            CONTAINER    {
                        set newVarType ContainerType
            }
            default     {
                        ${log}::debug Nothing set for this SWITCH command
            }
    }
    
    set packagingSetup($newVarType) [$listBox get 0 end]
    
	
    ${log}::debug --END-- [info level 1]
} ;# eAssistSetup::delCarrierSetup
