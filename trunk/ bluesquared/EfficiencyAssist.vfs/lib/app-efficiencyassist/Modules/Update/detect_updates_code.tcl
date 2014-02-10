# Creator: Casey Ackels
# Initial Date: January 18, 2014]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 384 $
# $LastChangedBy: casey.ackels@gmail.com $
# $LastChangedDate: 2014-01-17 07:17:52 -0800 (Fri, 17 Jan 2014) $
#
########################################################################################

##
## - Overview
# Detect if there is a new version; if so launch the required fields if needed. At minimum, display a window that says that the program has been updated.


package provide vUpdate 1.0

namespace eval vUpdate {}

proc vUpdate::saveCurrentVersion {version patchlevel beta} {
    #****f* saveCurrentVersion/vUpdate
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #
    # FUNCTION
    #	Set the current version numbers before we read in our saved versioning numbers from the config file.
    #
    # SYNOPSIS
    #	N/A
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
    #
    #***
    global log cVersion
    
    set cVersion(Version) $version
    set cVersion(PatchLevel) $patchlevel
    set cVersion(Beta) $beta
    
} ;#saveCurrentVersion


proc vUpdate::whatVersion {} {
    #****f* whatVersion/vUpdate
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #
    # FUNCTION
    #	Find out what version we are using compared to what is in the config file.
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	
    #
    # NOTES
    #   Using Arrays: cVersion, program
    #
    # SEE ALSO
    #
    #
    #***
    global log cVersion program
    
    # cVersion is read from the code
    # program array is read from the config file
    
    # Check the versioning from the bottom up
    if {$cVersion(Beta) ne $program(beta)} {
        ${log}::debug Beta levels do not match!
        ${log}::debug Minor Update, launching 'New Update' dialog ...
    }
    
    if {$cVersion(PatchLevel) ne $program(PatchLevel)} {
        ${log}::debug Patch Levels do not match!
        ${log}::debug Minor Update, launching 'New Update' dialog ...
    
    }
    
    if {$cVersion(Version) ne $program(Version)} {
        ${log}::debug Major Versions do not match!
        ${log}::debug Major Update, launching 'New Update' dialog ...
    }
    
    
    
} ;#whatVersion


proc vUpdate::newVersion {} {
    #****f* newVersion/vUpdate
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #
    # FUNCTION
    #	Find out if the version we are running is current, or if a newer one is available.
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	
    #
    # NOTES
    #   Using Arrays: cVersion, program
    #
    # SEE ALSO
    #
    #
    #***
    global log cVersion program
    
    # Connect to the code.google.com page and query a file ...
    # https://docs.google.com/document/d/1k-O1ZjObXcCMcVYE8oNXUnWEq5GcPsHMQTaHdFgAxwk/edit?usp=sharing
    
    
    
} ;#newVersion