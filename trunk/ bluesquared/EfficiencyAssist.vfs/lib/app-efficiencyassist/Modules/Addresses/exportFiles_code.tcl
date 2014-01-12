# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 01 12,2014
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision$
# $LastChangedBy$
# $LastChangedDate$
#
########################################################################################

proc importFiles::exportFiles {} {
    #****f* exportFiles/importFiles
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Export the data into a CSV file (eventually should allow the user to select the filetype that they want.)
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
    # Requirements
        # List of desired column headers
            # Which order that they should be in
            # ANSWER: Use all columns that were put into Setup; and in the order that they appear in Setup. (Future: should allow re-arranging)
        # Desired output data format
        # Preferences - path to save to
        # Setup - the filepath parameters should be set, such as:
            # <Title> <Edition> <date and time generated> <job #> 
        # 
    
	
    ${log}::debug --END-- [info level 1]
} ;# importFiles::exportFiles
