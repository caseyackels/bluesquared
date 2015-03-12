# This is the main app, everything else is sourced under startup.tcl
package ifneeded app-disthelper 1.0 [list source [file join $dir startup.tcl]]