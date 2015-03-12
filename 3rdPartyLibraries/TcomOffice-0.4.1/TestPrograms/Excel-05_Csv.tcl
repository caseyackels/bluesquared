# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

set auto_path [linsert $auto_path 0 [file join [pwd] ".."]]

package require tcomexcel

set path [file join [pwd] "testOut"]

# Names of CSV files being generated.
set outFileExcel [file join $path ExcelMiscExcel.csv]
set outFileCsv   [file join $path ExcelMiscCsv.csv]

# Open an existing Excel file, select a worksheet and save it in CSV format.
set appId [::Excel::Open true]
set xlsFile "ExcelMisc[::Excel::GetExtString $appId]"
set workbookId  [::Excel::OpenWorkbook $appId [file join $path $xlsFile]]
set worksheetId [::Excel::GetWorksheetIdByName $workbookId "CsvSep"]
puts "Saving CSV file $outFileExcel with Excel"
::Excel::SaveAsCsv $workbookId $worksheetId $outFileExcel
::Excel::Close $workbookId
::Excel::Quit $appId false

# Read the generated CSV file with the TcomExcel specific procedures
# and write it out into a new CSV file.
::Csv::SetSeparatorChar ";"
puts "Reading CSV file $outFileExcel"
set csvList [::Csv::Read $outFileExcel]
puts "Writing CSV file $outFileCsv"
::Csv::Write $csvList $outFileCsv

if { [lindex $argv 0] eq "auto" } {
    exit 0
}
