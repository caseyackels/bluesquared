# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 09 10,2013
# Dependencies: 
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
# Holds the code for the setting the international options in Setup

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


proc eAssistSetup::addToIntlListbox {Type lbox entryField} {
    #****f* addToIntlListbox/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Add items to the UOM listbox
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
    global log intlSetup
    
    ${log}::debug addToUOM $Type
    
        switch -- $Type {
            UOM     {
                    set entryValue $intlSetup(enterUOM)
                    set varType UOMList
                    ${log}::debug UOM - $entryField
            }
            TERMS   {
                    set entryValue $intlSetup(enterTerms)
                    set varType TERMSList
                    ${log}::debug TERMS - $entryField
            }
            PAYER   {
                    set entryValue $intlSetup(enterPayer)
                    set varType PAYERList
                    ${log}::debug TERMS - $entryField
            }
            LICENSE {
                    set entryValue $intlSetup(enterLicense)
                    set varType LICENSEList
                    ${log}::debug TERMS - $entryField
            }
        }

        ${log}::debug Adding _ $entryField _ to $Type Listbox
        
        $lbox insert end $entryValue
        $entryField delete 0 end
        
        
        
        set intlSetup($varType) [$lbox get 0 end]
        ${log}::debug $Type _ADD: [$lbox get 0 end]
	
} ;# eAssistSetup::addToIntlListbox


proc eAssistSetup::removeFromIntlListbox {Typelist win} {
    #****f* removeFromIntlListbox/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Remove selected item from the listboxes for the International Listboxes
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
    global log intlSetup
    
    
    ${log}::notice Removing _[$win curselection]_ from $Typelist Listbox
    
    $win delete [$win curselection]
    
    set intlSetup($Typelist) [$win get 0 end]
    ${log}::notice $Typelist _REMOVE: [$win get 0 end]
	
} ;# eAssistSetup::removeFromIntlListbox
