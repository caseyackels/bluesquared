# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

set auto_path [linsert $auto_path 0 [file join [pwd] ".."]]

package require tcomexcel

# Number of test rows, columns and worksheets being generated.
set numRows  100
set numCols  10
set numWorksheets 3

# Generate list with test data.
for { set i 1 } { $i <= $numCols } { incr i } {
    lappend valList "$i"
}

# Utility to insert data with the SetRowValues procedure.
proc InsertWithSetRowValues { appId workbookId rowList testName hideApp } {
    global numRows numWorksheets

    set t1 [clock clicks -milliseconds]
    if { $hideApp } {
        ::Excel::Visible $appId false
    }
    set startRow 1
    set startCol 1
    for { set ws 0 } { $ws < $numWorksheets } { incr ws } {
        set worksheetId [::Excel::AddWorksheet $workbookId "$testName-$ws"]
        set cellsId [::Excel::GetCellsId $worksheetId]

        for { set row $startRow } { $row <= $numRows } { incr row } {
            ::Excel::SetRowValues $cellsId $row $startCol $rowList
        }
        incr startRow 2
        incr startCol 1
    }
    if { $hideApp } {
        ::Excel::Visible $appId true
    }
    set t2 [clock clicks -milliseconds]
    puts "[expr $t2 - $t1] ms to set row values in $testName mode."
}

# Utility to insert data with the SetMatrixValues procedure.
proc InsertWithSetMatrixValues { appId workbookId rowList testName hideApp } {
    global numRows numWorksheets

    set t1 [clock clicks -milliseconds]
    if { $hideApp } {
        ::Excel::Visible $appId false
    }
    for { set i 1 } { $i <= $numRows } { incr i } {
        lappend rangeList $rowList
    }
    set startRow 1
    set startCol 1
    for { set ws 0 } { $ws < $numWorksheets } { incr ws } {
        set worksheetId [::Excel::AddWorksheet $workbookId "$testName-$ws"]
        set cellsId [::Excel::GetCellsId $worksheetId]

        ::Excel::SetMatrixValues $worksheetId $rangeList $startRow $startCol
        incr startRow 2
        incr startCol 1
    }
    if { $hideApp } {
        ::Excel::Visible $appId true
    }
    set t2 [clock clicks -milliseconds]
    puts "[expr $t2 - $t1] ms to set row values in $testName mode."
}

# Open new instance of Excel and create a workbook.
set appId [::Excel::OpenNew]
set workbookId [::Excel::AddWorkbook $appId]

# Delete Excel file from previous test run.
file mkdir testOut
set xlsFile [file join [pwd] "testOut" "ExcelInsert"]
append xlsFile [::Excel::GetExtString $appId]
file delete -force $xlsFile

# Perform test 1: Insert rows with Excel window visible.
InsertWithSetRowValues $appId $workbookId $valList "RowVisible" false

# Perform test 2: Insert rows with Excel window hidden.
InsertWithSetRowValues $appId $workbookId $valList "RowHidden" true

# Perform test 3: Insert matrix with Excel window visible.
InsertWithSetMatrixValues $appId $workbookId $valList "MatrixVisible" false

# Perform test 4: Insert matrix with Excel window hidden.
InsertWithSetMatrixValues $appId $workbookId $valList "MatrixHidden" true

puts "Saving as Excel file: $xlsFile"
::Excel::SaveAs $workbookId $xlsFile

if { [lindex $argv 0] eq "auto" } {
    ::Excel::Quit $appId
    exit 0
}
