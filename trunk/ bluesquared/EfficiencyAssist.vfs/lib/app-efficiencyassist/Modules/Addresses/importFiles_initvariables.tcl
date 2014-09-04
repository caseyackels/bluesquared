# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 03 10,2014
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

proc importFiles::initModVariables {} {
    #****f* initModVariables/importFiles
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Initialize, and set defaults for variables within the Batch Maker module
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
    global log emailEvent desc
    
    # Name was changed, hence the inconsistency
    set desc(ModImportFiles) [mc "Batch Maker"]
    set emailEvent(ModBatchMaker) [list Export]

} ;# initModVariables/importFiles


importFiles::initModVariables