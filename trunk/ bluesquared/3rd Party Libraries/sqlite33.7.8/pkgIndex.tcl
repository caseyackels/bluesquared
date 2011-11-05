#
# Tcl package index file
#
# Note sqlite*3* init specifically
#
package ifneeded sqlite3 3.7.8 \
    [list load [file join $dir sqlite378.dll] Sqlite3]
