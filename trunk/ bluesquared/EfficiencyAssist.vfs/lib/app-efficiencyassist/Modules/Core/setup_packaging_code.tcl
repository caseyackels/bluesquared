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
# $LastChangedDate$
#
########################################################################################

##
## - Overview
# Overview

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

proc eAssistSetup::addPackagingSetup {dbTable entryField listBox} {
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
    #   dbTable = what it is, for the switch to work correctly
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
    
    ${log}::debug Adding $dbTable, $entryField, $listBox
    
    if {[$entryField get] == ""} {return}

    switch -- $dbTable {
            PACKAGES     {
                        set entryValue $packagingSetup(enterPackageType)
                        set newVarType Packages
                        set dbCol Package
                        ${log}::debug PACKAGES - $entryField
            }
            CONTAINERS    {
                        set entryValue $packagingSetup(enterContainerType)
                        set newVarType Containers
                        set dbCol Container
                        ${log}::debug CONTAINERS - $entryField
            }
            default     {
                        ${log}::debug Nothing set for this SWITCH command
            }
    }

    ${log}::debug Adding _ $entryField _ to $newVarType Listbox
    
    $listBox insert end $entryValue
    
    # Insert into DB; must use quotes instead of curly braces to allow variable substituition
    db eval "insert into ${dbTable}($dbCol) values('$entryValue')"
    
    $entryField delete 0 end
    
    
    
    set packagingSetup($newVarType) [$listBox get 0 end]
    ${log}::debug $newVarType _ADD: [$listBox get 0 end]
    
	
    ${log}::debug --END-- [info level 1]
} ;# eAssistSetup::addCarrierSetup


proc eAssistSetup::delPackagingSetup {dbTable listBox} {
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
    
    switch -- $dbTable {
            PACKAGES     {
                        #set newVarType PackageType
                        set newVarType Package
                        set dbCol Package
            }
            CONTAINERS    {
                        #set newVarType ContainerType
                        set newVarType Container
                        set dbCol Package
            }
            default     {
                        ${log}::debug Nothing set for this SWITCH command
            }
    }
    
    # Delete the entry, then set the var to all values remaining values.
    eAssist_db::delete $dbTable $newVarType [$listBox get [$listBox curselection]]
    
    $listBox delete [$listBox curselection]
    eAssist_db::initContainers
    
    #set packagingSetup($newVarType) [$listBox get 0 end]
    
	
    ${log}::debug --END-- [info level 1]
} ;# eAssistSetup::delCarrierSetup
