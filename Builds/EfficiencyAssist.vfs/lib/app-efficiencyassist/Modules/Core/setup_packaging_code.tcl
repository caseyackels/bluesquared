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
# $LastChangedDate: 2014-12-10 09:10:25 -0800 (Wed, 10 Dec 2014) $
#
########################################################################################

##
## - Overview
# Overview

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

#proc ea::tools::populateListbox {modify entryWid lBoxWid dbTable dbCol} {
#    #****f* populateListbox/ea::tools
#    # AUTHOR
#    #	Casey Ackels
#    #
#    # COPYRIGHT
#    #	(c) 2011-2014 Casey Ackels
#    #
#    # FUNCTION
#    #   ea::tools::populateListbox add $f2.entry $f2.lbox Containers Container
#    #	Add values to listbox
#    #	entryWid = Path to widget
#    #   lBoxWid = Path to widget
#    #   dbTable = what it is, for the switch to work correctly
#    #   modify = add|delete
#    #
#    # SYNOPSIS
#    #   Updates the data in a list box.
#    #   Remove data from an entry field, insert/delete the data in the listbox
#    #
#    #
#    # CHILDREN
#    #	N/A
#    #
#    # PARENTS
#    #	
#    #
#    # NOTES
#    #   
#    #
#    # SEE ALSO
#    #
#    #***
#    global log
#    ${log}::debug --START-- [info level 1]
#    
#    ${log}::debug Adding $dbTable, $entryWid, $lboxWid
#    
#    switch -- $modify {
#        add     {if {[$entryWid get] == ""} {return} else {set entryValue [$entryWid get]}; $entryWid delete 0 end
#                # Insert into DB; must use quotes instead of curly braces to allow variable substituition
#                db eval "insert into ${dbTable}($dbCol) values('$entryValue')"
#            }
#        delete  {if {[$lboxWid curselection] == ""} {return}
#                # Delete the entry, then set the var to all values remaining values.
#                eAssist_db::delete $dbTable $dbCol [$lboxWid get [$lboxWid curselection]]
#            }
#        default {${log}::debug Unknown switch option: $modify}
#    }
#    
#    # Update the widgets with the new data ...
#    eAssist_db::initContainers $dbTable $listBox
#
#    ${log}::debug --END-- [info level 1]
#} ;# ea::tools::populateListbox


#proc eAssistSetup::delPackagingSetup {dbTable listBox} {
#    #****f* delCarrierSetup/eAssistSetup
#    # AUTHOR
#    #	Casey Ackels
#    #
#    # COPYRIGHT
#    #	(c) 2011-2014 Casey Ackels
#    #
#    # FUNCTION
#    #	Delete selected items from listbox
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
#    #
#    # SEE ALSO
#    #
#    #***
#    global log packagingSetup
#    ${log}::debug --START-- [info level 1]
#    
#    if {[$listBox curselection] == ""} {return}
#    
#    switch -- $dbTable {
#            PACKAGES     {
#                        #set newVarType PackageType
#                        set newVarType Package
#                        set dbCol Package
#            }
#            CONTAINERS    {
#                        #set newVarType ContainerType
#                        set newVarType Container
#                        set dbCol Package
#            }
#            default     {
#                        ${log}::debug Nothing set for this SWITCH command
#            }
#    }
#    
#    # Delete the entry, then set the var to all values remaining values.
#    eAssist_db::delete $dbTable $newVarType [$listBox get [$listBox curselection]]
#    
#    $listBox delete [$listBox curselection]
#    eAssist_db::initContainers
#    
#    #set packagingSetup($newVarType) [$listBox get 0 end]
#    
#	
#    ${log}::debug --END-- [info level 1]
#} ;# eAssistSetup::delCarrierSetup
