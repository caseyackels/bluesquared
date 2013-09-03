# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

set auto_path [linsert $auto_path 0 [file join [pwd] ".."]]

package require tcomexcel

if { ! [::Excel::HavePkg "tcomword"] } {
    puts "Test not performed. TcomWord is not available."
    exit 0
}

# Transfer Word header information into Excel.
set useHeader true

# Number of header lines.
set numHeaders 1

# Number of test rows and columns being generated.
set numRows 10
set numCols  3

set totalRows [expr {$numRows + $numHeaders}]

# Generate header list with column names.
for { set c 1 } { $c <= $numCols } { incr c } {
    lappend headerList "Col-$c"
}

# Create 3 Word tables and fill the first with data.
set wordAppId [::Word::OpenNew true]
set docId [::Word::AddDocument $wordAppId]

set range [::Word::AppendParagraph $docId "Source table:" 10]
set tableIn [::Word::AddTable $docId $range $totalRows $numCols 1]

set range [::Word::AppendParagraph $docId "Twapi table:" 10]
set tableOut1 [::Word::AddTable $docId $range $totalRows $numCols 1]

set range [::Word::AppendParagraph $docId "Fallback table:" 10]
set tableOut2 [::Word::AddTable $docId $range $totalRows $numCols 1]

puts "Filling source table with data ..."
::Word::SetHeaderLine $tableIn $headerList 

for { set row 1 } { $row <= $numRows } { incr row } {
    set rowList [list]
    for { set col 1 } { $col <= $numCols } { incr col } {
        lappend rowList [format "Cell_%d_%d" $row $col]
    }
    ::Word::SetRowValues $tableIn [expr {$row + $numHeaders}] 1 $rowList 
}

# Open new instance of Excel and add a workbook.
set excelAppId [::Excel::OpenNew]
set workbookId [::Excel::AddWorkbook $excelAppId]

# Delete Excel and Word files from previous test run.
file mkdir testOut
set xlsFile [file join [pwd] "testOut" "ExcelWordTable"]
append xlsFile [::Excel::GetExtString $excelAppId]
file delete -force $xlsFile

set docFile [file join [pwd] "testOut" "ExcelWordTable"]
append docFile [::Word::GetExtString $wordAppId]
file delete -force $docFile

if { [::Excel::HavePkg "twapi"] } {
    # Use Twapi for copying data via the clipboard with 
    # SetMatrixValues and GetMatrixValues procedures.
    set ::Excel::useTwapi true

    set worksheetId [::Excel::AddWorksheet $workbookId "Twapi"]
    set cellsId [::Excel::GetCellsId $worksheetId]

    set t1 [clock clicks -milliseconds]
    ::Excel::WordTableToWorksheet $tableIn $worksheetId $useHeader
    set t2 [clock clicks -milliseconds]
    puts "[expr $t2 - $t1] ms to put Word table (using Twapi: $::Excel::useTwapi)."

    set t1 [clock clicks -milliseconds]
    ::Excel::WorksheetToWordTable $worksheetId $tableOut1 $useHeader
    set t2 [clock clicks -milliseconds]
    puts "[expr $t2 - $t1] ms to get Word table (using Twapi: $::Excel::useTwapi)."
} else {
    ::Word::SetCellValue $tableOut1 1 1 "No Twapi extension available"
}

# Use the fallback solution via SetRowValues and GetRowValues procedures.
set ::Excel::useTwapi false

set worksheetId [::Excel::AddWorksheet $workbookId "Fallback"]
set cellsId [::Excel::GetCellsId $worksheetId]

set t1 [clock clicks -milliseconds]
::Excel::WordTableToWorksheet $tableIn $worksheetId $useHeader
set t2 [clock clicks -milliseconds]
puts "[expr $t2 - $t1] ms to put Word table (using Twapi: $::Excel::useTwapi)."

set t1 [clock clicks -milliseconds]
::Excel::WorksheetToWordTable $worksheetId $tableOut2 $useHeader
set t2 [clock clicks -milliseconds]
puts "[expr $t2 - $t1] ms to get Word table (using Twapi: $::Excel::useTwapi)."

puts "Saving as Excel file: $xlsFile"
::Excel::SaveAs $workbookId $xlsFile

puts "Saving as Word file : $docFile"
::Word::SaveAs $docId $docFile

if { [lindex $argv 0] eq "auto" } {
    ::Excel::Quit $excelAppId
    ::Word::Quit  $wordAppId
    exit 0
}
