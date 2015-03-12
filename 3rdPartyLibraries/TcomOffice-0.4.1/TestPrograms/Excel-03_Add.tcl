# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

set auto_path [linsert $auto_path 0 [file join [pwd] ".."]]

package require tcomexcel

# Name of Excel file being generated.
# Number of rows, columns and worksheets being generated.
set xlsFile [file join [pwd] "testOut" "ExcelAdd"]
set numRows   20
set numCols   10
set numSheets  3

# Generate row list with test data
for { set i 1 } { $i <= $numCols } { incr i } {
    lappend rowList "E-$i"
}

# Generate worksheets and fill them with the test data.
# We use the Open procedure, which should re-use an already
# open Excel instance.
for { set s 1 } { $s <= $numSheets } { incr s } {
    set appId [::Excel::Open]
    set workbookId [::Excel::GetActiveWorkbook $appId]
    if { $workbookId eq "" } {
        puts "Creating new workbook"
        set workbookId [::Excel::AddWorkbook $appId]
    }

    set worksheetId [::Excel::AddWorksheet $workbookId "Sheet-$s"]
    set cellsId [::Excel::GetCellsId $worksheetId]

    for { set i 1 } { $i <= $numRows } { incr i } {
        ::Excel::SetRowValues $cellsId $i 1 $rowList
    }
}
puts "Number of used rows in Sheet-$s   : [::Excel::GetNumUsedRows    $worksheetId]"
puts "Number of used columns in Sheet-$s: [::Excel::GetNumUsedColumns $worksheetId]"

# Add another worksheet and fill it with header lines.
set worksheetId [::Excel::AddWorksheet $workbookId "HeaderLines"]
set cellsId [::Excel::GetCellsId $worksheetId]
set startColumn 1
for { set i 1 } { $i <= $numRows } { incr i } {
    ::Excel::SetHeaderLine $cellsId $rowList $i $startColumn
    incr startColumn
}
set wsName [::Excel::GetWorksheetName $worksheetId]
puts "Number of used rows    in $wsName: [::Excel::GetNumUsedRows    $worksheetId]"
puts "Number of used columns in $wsName: [::Excel::GetNumUsedColumns $worksheetId]"

# Test retrieving parts of a row or column.
set rowList [::Excel::GetRowValues $cellsId 1 5]
puts "Values of row 1 (starting at column 5): $rowList"
if { [llength $rowList] != 6 } {
    puts "Error: Number of list elements not correct ([llength $rowList] vs. 6)"
}

set colList [::Excel::GetColumnValues $cellsId 7 2]
puts "Values of column 7 (starting at row 2): $colList"
if { [llength $colList] != 6 } {
    puts "Error: Number of list elements not correct ([llength $colList] vs. 6)"
}

# Test different ways to delete a worksheet.
set num [::Excel::GetNumWorksheets $workbookId]
puts "Number of worksheets before deletion of Sheet-1: $num"
after 500

set sheetId [::Excel::GetWorksheetIdByName $workbookId "Sheet-1"]
::Excel::DeleteWorksheet $workbookId $sheetId

set num [::Excel::GetNumWorksheets $workbookId]
puts "Number of worksheets before deletion of last sheet: $num"
after 500

::Excel::DeleteWorksheetByIndex $workbookId $num

set num [::Excel::GetNumWorksheets $workbookId]
puts "Number of worksheets finally: $num"

# Append the default Excel filename extension.
append xlsFile [::Excel::GetExtString $appId]

# # Delete Excel file from previous test run.
catch { file delete -force $xlsFile }

puts "Saving as Excel file: $xlsFile"
::Excel::SaveAs $workbookId $xlsFile

if { [lindex $argv 0] eq "auto" } {
    ::Excel::Quit $appId
    exit 0
}
