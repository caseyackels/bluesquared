# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

proc __TcomWordSourcePkgs { dir } {
    source [file join $dir wordConst.tcl]
    source [file join $dir wordBasic.tcl]
    source [file join $dir wordUtil.tcl]
    rename ::__TcomWordSourcePkgs {}
}

# All modules are exported as package tcomword
package ifneeded tcomword 0.4.1 "[list __TcomWordSourcePkgs $dir]"
