# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

set auto_path [linsert $auto_path 0 [file join [pwd] ".."]]

set retVal [catch {package require tcomexcel} pkgVersion]

set appId [::Excel::OpenNew false]

puts [format "%-25s: %s" "Tcl version" [info patchlevel]]
puts [format "%-25s: %s" "TcomExcel version" $pkgVersion]

puts [format "%-25s: %s" "Tcom version"  [::Excel::GetPkgVersion "tcom"]]
puts [format "%-25s: %s" "Twapi version" [::Excel::GetPkgVersion "twapi"]]

puts [format "%-25s: %s (%s)" "Excel Version" \
                             [::Excel::GetVersion $appId] \
                             [::Excel::GetVersion $appId true]]

puts [format "%-25s: %s" "Excel filename extension" \
                             [::Excel::GetExtString $appId]]

puts [format "%-25s: %s" "Active Printer" \
                        [::Excel::GetActivePrinter $appId]]

puts [format "%-25s: %s" "User Name" \
                        [::Excel::GetUserName $appId]]

puts [format "%-25s: %s" "Startup Pathname" \
                         [::Excel::GetStartupPath $appId]]
puts [format "%-25s: %s" "Templates Pathname" \
                         [::Excel::GetTemplatesPath $appId]]
puts [format "%-25s: %s" "Add-ins Pathname" \
                         [::Excel::GetUserLibraryPath $appId]]
puts [format "%-25s: %s" "Installation Pathname" \
                         [::Excel::GetInstallationPath $appId]]
puts [format "%-25s: %s" "User Folder Pathname" \
                         [::Excel::GetUserPath $appId]]

set workbookId [::Excel::AddWorkbook $appId]
set worksheetId [::Excel::GetWorksheetIdByIndex $workbookId 1]
set cellsId [::Excel::GetCellsId $worksheetId]

puts [format "%-30s: %s" "Appl. name (from Application)" \
         [::Excel::GetApplicationName $appId]]
puts [format "%-30s: %s" "Appl. name (from Workbook)" \
         [::Excel::GetApplicationName [::Excel::GetApplicationId $workbookId]]]
puts [format "%-30s: %s" "Appl. name (from Worksheet)" \
         [::Excel::GetApplicationName [::Excel::GetApplicationId $worksheetId]]]
puts [format "%-30s: %s" "Appl. name (from Cells)" \
         [::Excel::GetApplicationName [::Excel::GetApplicationId $cellsId]]]
                      
puts "Column A is number [::Excel::ColumnCharToInt A]"
puts "Column M is number [::Excel::ColumnCharToInt M]"
puts "Column Z is number [::Excel::ColumnCharToInt Z]"

puts "Column range 2-7 is [::Excel::GetColumnRange 2 7]"
puts "Cell range (1,2) (5,7) is [::Excel::GetCellRange 1 2  5 7]"

puts "Float Separator (Standard)   : [::Excel::GetFloatSeparator]"
::Excel::SetMapFloatSeparator false
puts "Float Separator (should be .): [::Excel::GetFloatSeparator]"

::Excel::Close $workbookId

if { [lindex $argv 0] eq "auto" } {
    ::Excel::Quit $appId
    exit 0
}
