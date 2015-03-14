# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 03 04,2015
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
# Date formatting procs

namespace eval ea::date {}

proc ea::date::formatDate {dateType str} {
    #****f* formatDate/ea::date
    # CREATION DATE
    #   03/04/2015 (Wednesday Mar 04)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::date::formatDate str ?date format?
    #   ea::date:formatDate 2/3/2015 
    #
    # FUNCTION
    #	Formats the user entered string into a date suitable for the DB
    #	e.g. 2015-03-04 (March 3rd, 2015)
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   This assumes the user entered format is: Month/Day/Year
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log
    
    switch -- $dateType {
        -std    {set dateFormat "%d-%m-%Y"}
        -euro   {set dateFormat "%m-%d-%Y"}
        default {set dateFormat "$value"}
    }

    # Guard against the user, using slashes (/), instead of hyphens (-)
    set str [string map {/ -} $str]
    
    set validDate [llength [split $str -]]
    if {$validDate != 3} {
        ${log}::notice Date is malformed
        return
    }
    
    
    clock format [clock scan $str -format $dateFormat] -format %Y-%d-%m
 
} ;# ea::date::formatDate

proc ea::date::getTodaysDate {} {
    #****f* getTodaysDate/ea::date
    # CREATION DATE
    #   03/11/2015 (Wednesday Mar 11)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::date::getTodaysDate  
    #
    # FUNCTION
    #	Returns today's date in the format: yyy-dd-mm
    #   2015-11-03
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
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log

    #set currentDate [clock format [clock seconds] -format %T]
    
    ea::date::formatDate -std [clock format [clock seconds] -format %D]

    
} ;# ea::date::getTodaysDate

proc ea::date::currentTime {} {
    #****f* currentTime/ea::date
    # CREATION DATE
    #   03/11/2015 (Wednesday Mar 11)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::date::currentTime  
    #
    # FUNCTION
    #	Returns the current time HH:MM:SS
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
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log

    clock format [clock seconds] -format %T
    
} ;# ea::date::currentTime
