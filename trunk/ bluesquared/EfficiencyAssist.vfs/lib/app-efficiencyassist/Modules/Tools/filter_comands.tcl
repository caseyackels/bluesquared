# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 01/05/2014
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

proc eAssist_tools::stripASCII_CC {args} {
    #****f* stripASCII_CC/eAssist_tools
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Strip ASCII and Control Characters
    #
    # SYNOPSIS
    #
    #
    # CHILDREN
    #	eAssist_tools::stripExtraSpaces
    #
    # PARENTS
    #	
    #
    # NOTES
    #   Found on rosettacode.org
    #
    # SEE ALSO
    #
    #***
    global log
    ${log}::debug --START-- [info level 1]
    
    eAssist_tools::stripExtraSpaces [regsub -all {[\u0000-\u001f\u007f]+} $args ""]
	
    ${log}::debug --END-- [info level 1]
} ;# eAssist_tools::stripASCII_CC


proc eAssist_tools::stripCC {args} {
    #****f* stripCC/eAssist_tools
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Only strip Control Characters
    #
    # SYNOPSIS
    #
    #
    # CHILDREN
    #	eAssist_tools::stripExtraSpaces
    #
    # PARENTS
    #	
    #
    # NOTES
    #   Found on: rosettacode.org
    #
    # SEE ALSO
    #
    #***
    global log
    ${log}::debug --START-- [info level 1]
    
    eAssist_tools::stripExtraSpaces [regsub -all {[^\u0020-\u007e]+} $args ""]

	
    ${log}::debug --END-- [info level 1]
} ;# eAssist_tools::stripCC


proc eAssist_tools::stripQuotes {args} {
    #****f* stripQuotes/eAssist_tools
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Strip Quotes from string
    #
    # SYNOPSIS
    #
    #
    # CHILDREN
    #	eAssist_tools::stripExtraSpaces
    #
    # PARENTS
    #	
    #
    # NOTES
    #   
    #
    # SEE ALSO
    #
    #***
    global log
    ${log}::debug --START-- [info level 1]
    
    eAssist_tools::stripExtraSpaces [string map [list \" ""] $args]
	
    ${log}::debug --END-- [info level 1]
} ;# eAssist_tools::stripQuotes


proc eAssist_tools::stripExtraSpaces {args} {
    #****f* stripExtraSpaces/eAssist_tools
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Strip additional spaces in a string
    #
    # SYNOPSIS
    #
    #
    # CHILDREN
    #	eAssist_tools::stripExtraSpaces
    #
    # PARENTS
    #	
    #
    # NOTES
    #   
    #
    # SEE ALSO
    #
    #***
    global log
    ${log}::debug --START-- [info level 1]
    
    # ... ensure newString doesn't exist, or else we'll add to it in the next step
    if {[info exists newString]} {unset newString}
    
    # ... strip extra spaces
    foreach value [split $args { }] {
        if {$value != {}} {
            lappend newString [string trim $value]
            }
    }
	
    ${log}::debug --END-- [info level 1]
} ;# eAssist_tools::stripExtraSpaces


proc eAssist_tools::stripUDL {args} {
    #****f* stripUDL/eAssist_tools
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Using a "User Defined List (UDL)", strip characters from string
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
    global log
    ${log}::debug --START-- [info level 1]
    
	# This will need to reference a saved List from the users profile/preferences file.
    set StripChars [list . ? ! _ , : | $ ! + =]
    
    set newString $args

    foreach value $StripChars {
        set newString [eAssist_tools::stripExtraSpaces [string map [list [concat \ $value] ""] $newString]]
    }
    ${log}::debug --END-- [info level 1]
} ;# eAssist_tools::stripUDL
