# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 02 02,2014
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


proc eAssistSetup::addCSR {listBox entryField} {
    #****f* addCSR/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Add CSR to Listbox
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
    global log setupCSR CSR
    ${log}::debug --START-- [info level 1]
    
    if {[$entryField get] == ""} {return}
        
    $listBox insert end $setupCSR(entryName)
    $entryField delete 0 end
    
    set CSR(Names) [$listBox get 0 end]
	
    ${log}::debug --END-- [info level 1]
} ;# eAssistSetup::addCSR


proc eAssistSetup::deleteCSR {listBox} {
    #****f* deleteCSR/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Delete the CSR Name
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
    global log CSR
    ${log}::debug --START-- [info level 1]
    
    if {[$listBox curselection] == ""} {return}
    # Delete the entry, then set the var to all values remaining values.
    $listBox delete [$listBox curselection]
    set CSR(Names) [$listBox get 0 end]
	
    ${log}::debug --END-- [info level 1]
} ;# eAssistSetup::deleteCSR
