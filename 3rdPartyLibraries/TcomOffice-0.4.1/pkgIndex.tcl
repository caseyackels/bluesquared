# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

# Extend the auto_path to make TcomOffice subpackages available
if {[lsearch -exact $::auto_path $dir] == -1} {
    lappend ::auto_path $dir
}

proc __tcomOfficeSourcePkgs { dir } {
    set subPkgs [list tcomexcel tcomword]
    foreach pkg $subPkgs {
        set retVal [catch {package require $pkg} ::__tcomOfficePkgInfo($pkg,version)]
        set ::__tcomOfficePkgInfo($pkg,avail) [expr !$retVal]
    }
    package provide tcomoffice 0.4.1
}

package ifneeded tcomoffice 0.4.1 "[list __tcomOfficeSourcePkgs $dir]"
