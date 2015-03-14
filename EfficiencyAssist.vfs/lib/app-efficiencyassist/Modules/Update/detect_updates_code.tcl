# Creator: Casey Ackels
# Initial Date: January 18, 2014]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 384 $
# $LastChangedBy: casey.ackels@gmail.com $
# $LastChangedDate: 2015-03-04 19:02:39 -0800 (Wed, 04 Mar 2015) $
#
########################################################################################

##
## - Overview
# Detect if there is a new version; if so launch the required fields if needed. At minimum, display a window that says that the program has been updated.


package provide vUpdate 1.0

namespace eval vUpdate {}

proc vUpdate::saveCurrentVersion {} {
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
    #	vUpdate::whatVersion vUpdate::getLatestRev
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
    global log cVersion program job
    
    if {![info exists program(dbVersion)]} {set program(dbVersion) ""}
    
    set firstRun 0
    ${log}::debug Entering SaveCurrentVersion
    
    # Check to see if we've ran this before ...
    if {[info exists program(Version)] == 0} {
        set firstRun 1
        ${log}::debug firstRun: $firstRun
    }
    
    if {$firstRun == 0} {
        # We've loaded all the saved variables, so we know what the 'old' version is.
        set cVersion(oldFullVersion) "$program(Version).$program(PatchLevel) $program(beta)"
        
        set cVersion(oldVersion) $program(Version)
        set cVersion(oldPatchLevel) $program(PatchLevel)
        set cVersion(oldbeta) $program(beta)
        set cVersion(olddbVersion) $program(dbVersion)
    }
    
    set program(Version) 4
    set program(PatchLevel) 0.0 ;# Leading decimal is not needed
    set program(beta) "Beta 8"
    set program(Dev) 0
    set program(fullVersion) "$program(Version).$program(PatchLevel) $program(beta)"
    
    set program(dbVersion) "$program(Version).$program(PatchLevel)-1"
    set job(db,currentSchemaVers) 3
    
    set program(Name) "Efficiency Assist"
    set program(FullName) "$program(Name) - $program(fullVersion)"
    

    
    tk appname $program(Name)

    if {$program(Dev) == 1} {
        # We're running a dev version, lets populate the latest code repo version
        set program(FullName) "$program(FullName) Rev: [vUpdate::getLatestRev]"
    }
    
    
    if {$firstRun == 1} {
        vUpdate::whatVersion
        ${log}::debug Launching window firstrun: $firstRun = 0
    } else {
        return
    }
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
    #	vUpdate::newVersion
    #
    # PARENTS
    #	vUpdate::saveCurrentVersion
    #
    # NOTES
    #   Using Arrays: cVersion, program
    #
    # SEE ALSO
    #
    #
    #***
    global log cVersion program
    
    if {![info exists cVersion(oldbeta)]} {return}
    # cVersion is read from the code
    # program array is read from the config file
    
    set launchGui 0
    
    # Check the versioning from the bottom up
    if {$cVersion(oldbeta) ne $program(beta)} {
        ${log}::debug New Beta Detected, was $cVersion(oldbeta), now $program(beta)!
        ${log}::debug Minor Update, launching 'New Update' dialog ...
        set vers [mc "beta"]
        set newVersionExpln [mc "Definition of beta: This version is in flux and may not operate the way it was intended."]
        set launchGui 1
    } else {
        ${log}::debug Beta: Nothing new detected
    }
    
    if {$cVersion(oldPatchLevel) ne $program(PatchLevel)} {
        ${log}::debug New Patch Detected, was $cVersion(oldPatchLevel), now $program(PatchLevel)!
        ${log}::debug Minor Update, launching 'New Update' dialog ...
        set vers [mc "minor"]
        set newVersionExpln [mc "Definition of minor: This will typically have minor new features added and bugs that are fixed. A maintenance release."]
        set launchGui 1
    } else {
        ${log}::debug PatchLevel: Nothing new detected
    }
    
    if {$cVersion(oldVersion) ne $program(Version)} {
        ${log}::debug New Major Version detected, was $cVersion(oldVersion), now $program(Version)!
        ${log}::debug Major Update, launching 'New Update' dialog ...
        set vers [mc "major"]
        set newVersionExpln [mc "Definition of major: This has numerous new features that are big or small. All of the updates that the previous minor releases had. This may contain more bugs."]
        set launchGui 1
    } else {
        ${log}::debug Major Version: Nothing new detected
    }
    
    if {$launchGui == 1} {
        # Check the db schema
        vUpdate::checkDBVers $program(Version).$program(PatchLevel)
        
        set newVersionTxt [mc "A new $vers version has been detected"]
        vUpdate::newVersion $newVersionTxt $newVersionExpln
    }
} ;#whatVersion


proc vUpdate::checkDBVers {version} {
    #****f* checkDBVers/vUpdate
    # CREATION DATE
    #   02/08/2015 (Sunday Feb 08)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   vUpdate::checkDB version 
    #
    # FUNCTION
    #	Ensures the DB has been updated; if it hasn't. Exit gracefully.
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
    global log program

    # Current schema compat version
    set getCompatVersion [eAssist_db::dbWhereQuery -columnNames ProgramVers -table Schema -where ProgramVers='$version']
    
    if {$getCompatVersion eq ""} {
        ${log}::critical DB schema is not compatible with this version. Please update the database, before running $program(Name)!
        } else {
            ${log}::info DB Schema is compatible with this version of $program(Name)
        }

    
} ;# vUpdate::checkDBVers


#proc vUpdate::checkForUpdates {} {
#    #****f* checkForUpdates/vUpdate
#    # AUTHOR
#    #	Casey Ackels
#    #
#    # COPYRIGHT
#    #	(c) 2011-2014 Casey Ackels
#    #
#    # FUNCTION
#    #	Periodically check to see if we can install a new update
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
#    #   This is executed in 'eAssist_initVariables (startup.tcl)
#    #
#    # SEE ALSO
#    #
#    #***
#    global log
#    ${log}::debug --START-- [info level 1]
#    
#    ${log}::notice FOUND AN UPDATE!
#    
#    # file mtime <installerFile> ;# get time the installer was last accessed
#    # clock seconds ;# Get current time
#    # compare with our saved last access time $program(LastAccessedInstaller)
#    # If file is new, display a window telling user to relaunch program
#    
#    set directory [file join Z: EfficiencyAssist]
#    
#    set dirContents [glob eaInst* $directory]
#    
#    foreach item $dirContents {
#        set itemM [string trim eaInst.ex]
#    }
#
#	
#    ${log}::debug --END-- [info level 1]
#} ;# vUpdate::checkForUpdates


proc vUpdate::getLatestRev {} {
    #****f* getLatestRev/vUpdate
    # CREATION DATE
    #   09/21/2014 (Sunday Sep 21)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   vUpdate::getLatestRev 
    #
    # FUNCTION
    #	Retrieves the latest revision number, if svn.exe is installed and puts it into the program(FullName) variable
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   vUpdate::saveCurrentVersion
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log

    set RepoPath "https://bluesquared.googlecode.com/svn/trunk/%20bluesquared"

    # Returns 0 if 'svn' was found on the system.
    set values [catch {exec svn info $RepoPath} msg]

    if {$values} {
        ${log}::notice "svn.exe was not found on this system. Install TortoiseSVN and try again."
        return {N/A}
        #return -code 1 "svn.exe was not found on this system. Install TortoiseSVN and try again."
    }
    
    set nmsg [split $msg \n]
    set lastChangedRev [lindex $nmsg [lsearch $nmsg "Last Changed Rev*"]]
    set lastChangedRevNumber [lrange [split $lastChangedRev] end end]
    
    return $lastChangedRevNumber

} ;# vUpdate::getLatestRev
