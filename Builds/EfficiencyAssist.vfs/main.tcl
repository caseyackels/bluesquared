#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 339 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2013-12-22 21:39:11 -0800 (Sun, 22 Dec 2013) $
#
########################################################################################

package require starkit
starkit::startup

starkit::autoextend [file join $starkit::topdir lib tcllib]
starkit::autoextend [file join $starkit::topdir lib tklib]

package require app-efficiencyassist