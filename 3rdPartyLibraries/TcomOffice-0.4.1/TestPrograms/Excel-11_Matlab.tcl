# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

set auto_path [linsert $auto_path 0 [file join [pwd] ".."]]

package require tcomexcel

set matFile [file join "testOut" "ExcelMatrix.mat"]

# Open new instance of Excel and add a workbook.
set excelAppId [::Excel::OpenNew]
set workbookId [::Excel::AddWorkbook $excelAppId]

# Delete Excel files from previous test run.
file mkdir testOut
set xlsFile [file join [pwd] "testOut" "ExcelMatlab"]
append xlsFile [::Excel::GetExtString $excelAppId]
file delete -force $xlsFile
set matOutFile [file join [pwd] "testOut" "ExcelMatlab.mat"]
file delete -force $matOutFile

set worksheetId [::Excel::AddWorksheet $workbookId \
                 [file tail [file rootname $matFile]]]
set cellsId [::Excel::GetCellsId $worksheetId]

set t1 [clock clicks -milliseconds]
# Transfer Matlab matrix information into Excel with a header line.
::Excel::MatlabToWorksheet $matFile $worksheetId true
set t2 [clock clicks -milliseconds]
puts "[expr $t2 - $t1] ms to put Matlab matrix into Excel."

set t1 [clock clicks -milliseconds]
# Transfer Excel sheet into a Matlab file. Ignore first (header) row.
::Excel::WorksheetToMatlab $worksheetId $matOutFile true
set t2 [clock clicks -milliseconds]
puts "[expr $t2 - $t1] ms to put Excel data into a Matlab file."

puts "Saving as Excel file: $xlsFile"
::Excel::SaveAs $workbookId $xlsFile

if { [lindex $argv 0] eq "auto" } {
    ::Excel::Quit $excelAppId
    exit 0
}
