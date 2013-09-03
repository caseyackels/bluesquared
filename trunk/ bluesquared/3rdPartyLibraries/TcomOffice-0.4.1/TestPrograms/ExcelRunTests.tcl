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

runTest Excel-01_Basic.tcl
runTest Excel-02_Misc.tcl
runTest Excel-03_Add.tcl
runTest Excel-05_Csv.tcl
runTest Excel-06_Insert.tcl
runTest Excel-07_Tablelist.tcl
runTest Excel-08_WordTable.tcl
runTest Excel-09_Matrix.tcl
runTest Excel-10_RawImage.tcl
runTest Excel-11_Matlab.tcl
runTest Excel-04_Chart.tcl

puts ""
puts "Checking Excel test coverage ..."
source ExcelCheckCoverage.tcl
