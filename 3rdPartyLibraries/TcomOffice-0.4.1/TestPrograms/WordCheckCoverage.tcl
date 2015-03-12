# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

set auto_path [linsert $auto_path 0 [file join [pwd] ".."]]

package require tcomword

set procList [lsort [info commands Word::*]]

# We search the test scripts as well as the implementation files,
# as a procedure may be used by a higher-level procedure and thus 
# does not have to be tested seperately.
set testFileList [lsort [glob "Word-*.tcl" "../TcomWord/word*.tcl"]]

foreach testFile $testFileList {
    puts "Scanning testfile $testFile"
    set fp [open $testFile "r"]
    while { [gets $fp line] >= 0 } {
        foreach cmd $procList {
            if { [string match "*${cmd}*" $line] } {
                #puts "Found proc $cmd in file $testFile"
                set found($cmd) 1
            }
        }
    }
    close $fp
}

set foundList [lsort [array names found *]]
foreach cmd $procList {
    if { [lsearch $foundList $cmd] < 0 } {
        puts "$cmd not yet tested"
    }
}
exit 0
