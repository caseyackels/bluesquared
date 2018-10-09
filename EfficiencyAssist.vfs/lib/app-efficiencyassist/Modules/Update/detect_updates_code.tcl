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
        ${log}::debug First time starting Efficiency Assist. Skipping the version check.
		return
    }


    # We've loaded all the saved variables, so we know what the 'old' version is.
    set cVersion(oldVersion) $program(Version)
    set program(Version) [package versions app-efficiencyassist]

    #set program(PatchLevel) 0.1 ;# Leading decimal is not needed
    set program(beta) "RC 6.3"

    #set program(fullVersion) "$program(Version).$program(PatchLevel) $program(beta)"
	set program(fullVersion) "$program(Version) $program(beta)"

    set program(Name) "Efficiency Assist"
    set program(FullName) "$program(Name) - $program(fullVersion)"

	# Cleanup old versions
	if {[info exists program(PatchLevel)]} {unset program(PatchLevel)}


    tk appname $program(Name)
	${log}::debug Current program version: [package versions app-efficiencyassist]
	${log}::debug vcompare: [package vcompare $cVersion(oldVersion) $program(Version)]

	if {[package vcompare $cVersion(oldVersion) $program(Version)] == -1} {
		# We are running a new version; display an alert window
		vUpdate::newVersion "new version" "explanation"
	}

} ;#saveCurrentVersion

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
