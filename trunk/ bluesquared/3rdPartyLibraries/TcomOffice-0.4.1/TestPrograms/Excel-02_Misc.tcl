# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

set auto_path [linsert $auto_path 0 [file join [pwd] ".."]]

package require tcomexcel

# Number of test rows and columns being generated.
set numRows  100
set numCols  10 

# Generate row list with test data
for { set i 1 } { $i <= $numCols } { incr i } {
    lappend rowList "$i"
}

# Open Excel, show the application window and create a workbook.
set appId [::Excel::Open true]
set workbookId [::Excel::AddWorkbook $appId]

# Delete Excel file from previous test run.
file mkdir testOut
set xlsFile [file join [pwd] "testOut" "ExcelMisc"]
append xlsFile [::Excel::GetExtString $appId]
file delete -force $xlsFile

# Select the first - already existing - worksheet, 
# set its name and fill it with data.
set worksheetId [::Excel::GetWorksheetIdByIndex $workbookId 1]
::Excel::SetWorksheetName $worksheetId "ExcelMisc"
set cellsId [::Excel::GetCellsId $worksheetId]

for { set row 1 } { $row <= $numRows } { incr row } {
    ::Excel::SetRowValues  $cellsId $row 1 $rowList
}

# Use different range selection procedures and test various
# formatting and color procedures.
set rangeId [::Excel::SelectCellByIndex $cellsId 2 1 true]
::Excel::SetRangeFillColor $rangeId 255 0 0
::Excel::SetRangeTextColor $rangeId 0 255 0

set rangeId [::Excel::SelectCellByIndex $cellsId 3 1 true]
::Excel::SetRangeFillColor $rangeId 0 255 0
::Excel::SetRangeTextColor $rangeId 0 0 255

set rangeId [::Excel::SelectCellByIndex $cellsId 4 1 true]
::Excel::SetRangeFillColor $rangeId 0 0 255
::Excel::SetRangeTextColor $rangeId 255 0 0

set rangeId [::Excel::SelectRangeByIndex $cellsId 5 1 6 3 true]
::Excel::SetRangeFillColor $rangeId 255 255 0
::Excel::SetRangeTextColor $rangeId 0 255 255

set rangeId [::Excel::SelectRangeByStr $cellsId "A7:C8" true]
::Excel::SetRangeFillColor $rangeId 255 0 0
::Excel::SetRangeTextColor $rangeId 0 255 0

$rangeId NumberFormat [::Excel::GetLangNumberFormat "0" "0000000"]

::Excel::FormatHeaderLine $cellsId 2 7 11

# Test setting a formula.
set cell [::Excel::SelectCellByIndex $cellsId 1 1 true]
set funcName [::Excel::GetLangFuncName "TODAY" "()"]
$cell Formula "=$funcName"
puts "Formula:      [$cell Formula]"
puts "FormulaLocal: [$cell FormulaLocal]"

# Test different ways of setting column width.
::Excel::SetColumnsWidth $cellsId 1 $numCols 0
::Excel::SetColumnWidth $cellsId 1 20
::Excel::SetColumnWidth $cellsId 5 10

# Generate a text file for testing the hyperlink capabilities.
set fileName [file join [pwd] "testOut" "ExcelMisc.txt"]
set fp [open $fileName "w"]
puts $fp "This is the linked text file."
close $fp

::Excel::SetHyperlink $worksheetId 1 [expr $numCols + 1] \
                      [format "file://%s" $fileName] "Hyperlink"

# Test the search capabilities.
::Excel::SetCellValue $cellsId 2 [expr $numCols + 1] "Hallo"
::Excel::SetCellValue $cellsId 3 [expr $numCols + 1] "Holla"

set rangeId [::Excel::SelectCellByIndex $cellsId 2 [expr $numCols + 1] true]
::Excel::SetRangeFontBold $rangeId true
set rangeId [::Excel::SelectCellByIndex $cellsId 3 [expr $numCols + 1] true]
::Excel::SetRangeFontItalic $rangeId true

# Search only first 20 rows and columns.
set cell [::Excel::FindCell $cellsId "Hallo" 1 20 1 20]
set rowNum [lindex $cell 0]
set colNum [lindex $cell 1]
puts "Found string \"Hallo\" at cell [::Excel::ColumnIntToChar $colNum]$rowNum"

# Search whole worksheet.
set cell [::Excel::FindCell $cellsId "Holla"]
set rowNum [lindex $cell 0]
set colNum [lindex $cell 1]
puts "Found string \"Holla\" at cell [::Excel::ColumnIntToChar $colNum]$rowNum"

# Test inserting and scaling an image into a worksheet.
set picId [::Excel::InsertImage $worksheetId [file join [pwd] "wish.gif"] 5 9]
::Excel::ScaleImage $picId 2 2.5

# Test copying a whole worksheet.
set newWorksheetId [::Excel::AddWorksheet $workbookId "WorksheetCopy"]
::Excel::CopyWorksheet $worksheetId $newWorksheetId

# Test inserting matrix data via the clipboard.
set testList {{1 2 3} {4.1 5.2 6.2} {7,1 8,2 9,3} {"Hello; world" "What's" "next"}}
set worksheetId [::Excel::AddWorksheet $workbookId "CsvSep"]
::Excel::SetMapFloatSeparator true
::Excel::SetMatrixValues $worksheetId $testList
::Excel::SetMapFloatSeparator false
::Excel::SetMatrixValues $worksheetId $testList [expr [llength $testList] + 2]

# Test large row and column numbers.
set worksheetId [::Excel::AddWorksheet $workbookId "LargeColumn"]
set cellsId [::Excel::GetCellsId $worksheetId]
set maxRows [::Excel::GetNumRows $worksheetId]
set maxCols [::Excel::GetNumColumns $worksheetId]
puts "Maximum number of rows   : $maxRows"
puts "Maximum number of columns: $maxCols"
# 256 and 65535 are the maximum number of columns and rows in Excel
# versions up to Excel 2003.
if { $maxCols > 256 } {
    set maxCols 500
}
if { $maxRows > 65536 } {
    set maxRows 70000
}
::Excel::SetCellValue $cellsId 1 1 "Cell-1-1"
::Excel::SetCellValue $cellsId 1 $maxCols "Cell-1-$maxCols"
::Excel::SetCellValue $cellsId $maxRows 1 "Cell-$maxRows-1"
::Excel::SetCellValue $cellsId $maxRows $maxCols "Cell-$maxRows-$maxCols"

puts "Saving as Excel file: $xlsFile"
::Excel::SaveAs $workbookId $xlsFile

if { [lindex $argv 0] eq "auto" } {
    ::Excel::Quit $appId
    exit 0
}
