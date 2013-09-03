proc runTest { testFile } {
    if { $::tcl_platform(platform) eq "windows" } {
        set tclsh "tclsh.exe"
    } else {
        set tclsh "tclsh"
    }
    puts "Running test $testFile ..."
    exec $tclsh $testFile auto
}


file delete -force testOut
file mkdir testOut

runTest Word-01_Basic.tcl
runTest Word-02_Table.tcl
runTest Word-03_Text.tcl
runTest Word-04_Find.tcl

puts ""
puts "Checking Word test coverage ..."
source WordCheckCoverage.tcl
