# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

set auto_path [linsert $auto_path 0 [file join [pwd] ".."]]

package require tcomexcel

set rawFile [file join "testOut" "ExcelMatrix.raw"]

set retVal [catch {package require img::raw} version]
if { $retVal == 0 } {
    set phImg1 [image create photo -file $rawFile \
                -format "RAW -useheader 1 -verbose 0 -nomap 0 -gamma 1"]
    pack [label .l1] -side left
    .l1 configure -image $phImg1
    wm title . "Original RAW image vs. generated RAW image \
               (Size: [image width $phImg1] x [image height $phImg1])"
    update
}

# Open new instance of Excel and add a workbook.
set excelAppId [::Excel::OpenNew]
set workbookId [::Excel::AddWorkbook $excelAppId]

# Delete Excel files from previous test run.
file mkdir testOut
set xlsFile [file join [pwd] "testOut" "ExcelRawImage"]
append xlsFile [::Excel::GetExtString $excelAppId]
file delete -force $xlsFile
set rawOutFile [file join [pwd] "testOut" "ExcelRawImage.raw"]
file delete -force $rawOutFile

set worksheetId [::Excel::AddWorksheet $workbookId \
                  [file tail [file rootname $rawFile]]]
set cellsId [::Excel::GetCellsId $worksheetId]

set t1 [clock clicks -milliseconds]
# Transfer image information into Excel as a header line.
::Excel::RawImageToWorksheet $rawFile $worksheetId true
set t2 [clock clicks -milliseconds]
puts "[expr $t2 - $t1] ms to put RAW image into Excel."

set t1 [clock clicks -milliseconds]
# Transfer Excel sheet into RAW image. Ignore first (header) row.
::Excel::WorksheetToRawImage $worksheetId $rawOutFile true
set t2 [clock clicks -milliseconds]
puts "[expr $t2 - $t1] ms to put Excel data into a RAW image."

if { $retVal == 0 } {
    set phImg2 [image create photo -file $rawOutFile \
                -format "RAW -useheader 1 -verbose 0 -nomap 0 -gamma 1"]
    pack [label .l2]
    .l2 configure -image $phImg2
}

puts "Saving as Excel file: $xlsFile"
::Excel::SaveAs $workbookId $xlsFile

if { [lindex $argv 0] eq "auto" } {
    ::Excel::Quit $excelAppId
    exit 0
}
