# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

set auto_path [linsert $auto_path 0 [file join [pwd] ".."]]

# We need to explicitly load the tablelist package.
package require Tk

set retVal [catch {package require tablelist} version]
if { $retVal != 0 } {
    puts "Test not performed. Tablelist is not available."
    exit 0
}

package require tcomexcel

# Transfer tablelist header information into Excel.
set useHeader true

# Number of test rows and columns being generated.
set numRows  100
set numCols  10

# Generate header list with column names.
for { set c 1 } { $c <= $numCols } { incr c } {
    lappend headerList "Col-$c"
}

# Create 3 tablelist widgets and fill the first with data.
ttk::labelframe .frIn -text "Source tablelist"
pack .frIn -side top -fill both -expand 1
tablelist::tablelist .frIn.tl -width 100
pack .frIn.tl -side top -fill both -expand 1

ttk::labelframe .frOut1 -text "Twapi tablelist"
pack .frOut1 -side top -fill both -expand 1
tablelist::tablelist .frOut1.tl -width 100
pack .frOut1.tl -side top -fill both -expand 1

ttk::labelframe .frOut2 -text "Fallback tablelist"
pack .frOut2 -side top -fill both -expand 1
tablelist::tablelist .frOut2.tl -width 100
pack .frOut2.tl -side top -fill both -expand 1

puts "Filling source tablelist with data"
for { set col 0 } { $col < $numCols } { incr col } {
    .frIn.tl insertcolumns end 0 [lindex $headerList $col] left
}

for { set row 1 } { $row <= $numRows } { incr row } {
    set rowList [list]
    for { set col 1 } { $col <= $numCols } { incr col } {
        lappend rowList [format "Cell_%d_%d" $row $col]
    }
    .frIn.tl insert end $rowList
}
update

# Open new instance of Excel and add a workbook.
# Delete Excel file from previous test run.
set appId [::Excel::OpenNew]
set workbookId [::Excel::AddWorkbook $appId]

file mkdir testOut
set xlsFile [file join [pwd] "testOut" "ExcelTablelist"]
append xlsFile [::Excel::GetExtString $appId]
file delete -force $xlsFile

if { [::Excel::HavePkg "twapi"] } {
    # Use Twapi for copying data via the clipboard with 
    # SetMatrixValues and GetMatrixValues procedures.
    set ::Excel::useTwapi true

    set worksheetId [::Excel::AddWorksheet $workbookId "Twapi"]
    set cellsId [::Excel::GetCellsId $worksheetId]

    set t1 [clock clicks -milliseconds]
    ::Excel::TablelistToWorksheet .frIn.tl $worksheetId $useHeader
    set t2 [clock clicks -milliseconds]
    puts "[expr $t2 - $t1] ms to put tablelist data (using Twapi: $::Excel::useTwapi)."

    set t1 [clock clicks -milliseconds]
    ::Excel::WorksheetToTablelist $worksheetId .frOut1.tl $useHeader
    set t2 [clock clicks -milliseconds]
    puts "[expr $t2 - $t1] ms to get tablelist data (using Twapi: $::Excel::useTwapi)."
} else {
    .frOut1.tl insertcolumns end 0 "Error" left
    .frOut1.tl insert end [list "No Twapi extension available"]
}
update

# Use the fallback solution via SetRowValues and GetRowValues procedures.
set ::Excel::useTwapi false

set worksheetId [::Excel::AddWorksheet $workbookId "Fallback"]
set cellsId [::Excel::GetCellsId $worksheetId]

set t1 [clock clicks -milliseconds]
::Excel::TablelistToWorksheet .frIn.tl $worksheetId $useHeader
set t2 [clock clicks -milliseconds]
puts "[expr $t2 - $t1] ms to put tablelist data (using Twapi: $::Excel::useTwapi)."

set t1 [clock clicks -milliseconds]
::Excel::WorksheetToTablelist $worksheetId .frOut2.tl $useHeader
set t2 [clock clicks -milliseconds]
puts "[expr $t2 - $t1] ms to get tablelist data (using Twapi: $::Excel::useTwapi)."
update

puts "Saving as Excel file: $xlsFile"
::Excel::SaveAs $workbookId $xlsFile

if { [lindex $argv 0] eq "auto" } {
    ::Excel::Quit $appId
    exit 0
}
