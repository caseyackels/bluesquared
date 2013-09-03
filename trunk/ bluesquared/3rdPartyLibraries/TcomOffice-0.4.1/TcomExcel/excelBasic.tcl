# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

package provide tcomexcel 0.4.1

namespace eval ::Excel {

    # Only available in Excel 2003 and up.
    # TODO: Use these values instead of the mapFloatPoint variable.
    # $appId DecimalSeparator "."
    # $appId ThousandsSeparator ","
    # $appId UseSystemSeparators 0

    # The default settings for English Excel applications.
    variable language      "English" 
    variable mapFloatPoint 0

    # The default settings for German Excel applications.
    # Note, that if mapFloatPoint is set, ALL cell contents (independent of
    # the cell type) have the "," mapped to a "." when reading, and vice versa
    # when writing.
    # variable language      "German" 
    # variable mapFloatPoint 1

    variable excelVersion  ""

    variable errorValue    "UNKNOWN"

    variable pkgInfo

    # Variable for testing the fallback solution of SetMatrixValues
    # and GetMatrixValues.
    variable useTwapi true

    proc _Init {} {
        variable pkgInfo

        set retVal [catch {package require tcom} version]
        set pkgInfo(tcom,avail)   [expr !$retVal]
        set pkgInfo(tcom,version) $version

        set retVal [catch {package require twapi} version]
        set pkgInfo(twapi,avail)   [expr !$retVal]
        set pkgInfo(twapi,version) $version

        set retVal [catch {package require tcomword} version]
        set pkgInfo(tcomword,avail)   [expr !$retVal]
        set pkgInfo(tcomword,version) $version
    }

    proc HavePkg { pkgName } {
        variable pkgInfo

        if { [info exists pkgInfo($pkgName,avail)] } {
            return $pkgInfo($pkgName,avail)
        }
        return false
    }

    proc GetPkgVersion { pkgName } {
        variable pkgInfo

        set retVal ""
        if { [HavePkg $pkgName] } {
            set retVal $pkgInfo($pkgName,version)
        }
        return $retVal
    }

    proc _getOrCreateExcel { useExistingFirst } {
        if { ! [HavePkg "tcom"] } {
            error "Cannot get or create Excel application object. No Tcom extension available."
        }
        if { $useExistingFirst } {
            set retVal [catch {::tcom::ref getactiveobject "Excel.Application"} appId]
            if { $retVal == 0 } {
                return $appId
            }
        }
        set retVal [catch {::tcom::ref createobject "Excel.Application"} appId]
        if { $retVal == 0 } {
            return $appId
        }
        error "Cannot get or create Excel application object."
    }

    proc GetErrorValue {} {
        variable errorValue

        return $errorValue
    }

    proc SetErrorValue { val } {
        variable errorValue

        set errorValue $val
    }

    proc SetMapFloatSeparator { onOff } {
        variable mapFloatPoint

        set mapFloatPoint $onOff
    }

    proc GetFloatSeparator {} {
        variable mapFloatPoint

        if { $mapFloatPoint } {
           return ","
        } else {
           return "."
        }
    }

    proc SetLanguage { lang } {
        variable language

        set language $lang
    }

    proc GetLangFuncName { funcName { addStr "" } } {
        variable language

        array set map {
            "MIN"     "MIN"
            "MAX"     "MAX"
            "AVERAGE" "MITTELWERT" 
            "STDEV"   "STABWN" 
            "TODAY"   "HEUTE" 
        }

        if { [lsearch [array names map] $funcName] < 0 } {
            error "Function name $funcName not in map"
        }

        switch $language {
            "German" {
                set langFuncName $map($funcName)
            }
            default {
                set langFuncName $funcName
            }
        }
        if { $addStr ne "" } {
            append langFuncName $addStr
        }
        return $langFuncName
    }

    proc GetLangNumberFormat { pre post } {
        set floatSep [::Excel::GetFloatSeparator]
        return [format "%s%s%s" $pre $floatSep $post]
    }

    proc TclBool { val } {
        set boolInt 0
        if { $val } {
            set boolInt 1
        }
        return $boolInt
    }

    proc RgbToColor { r g b } {
        return [expr {$b << 16 | $g << 8 | $r}]
    }

    # Convert an Excel column string to a column number.
    proc ColumnCharToInt { colChar } {
        set abc {- A B C D E F G H I J K L M N O P Q R S T U V W X Y Z}
        set int 0
        foreach char [split $colChar ""] {
            set int [expr {$int*26 + [lsearch $abc $char]}]
        }
        #incr int -1 ; # one-letter columns start from A
        return $int
    }

    # Convert a column number to an Excel column string.
    proc ColumnIntToChar { col } {
        if { $col <= 26 } {
            return [format "%c" [expr {$col+64}]]
        } elseif { $col <= 676 } {
            set c1 [expr {int($col/26)+64}]
            set c2 [expr {$col%26+64}]
            return [format "%c%c" $c1 $c2]
        } else {
            set c1 [expr {int($col/676)+64}]
            set c2 [expr {int(($col-676)/26)+64}]
            set c3 [expr {$col%26+64}]
            return [format "%c%c%c" $c1 $c2 $c3]
        }
    } 

    # Convert a numeric cell range to an Excel range string.
    # The numeric range is specified as upper left and lower right corner.
    proc GetCellRange { row1 col1 row2 col2 } {
        set range [format "%s%d:%s%d" \
                   [ColumnIntToChar $col1] $row1 \
                   [ColumnIntToChar $col2] $row2]  
        return $range
    }

    proc GetColumnRange { col1 col2 } {
        set range [format "%s:%s" \
                   [ColumnIntToChar $col1] \
                   [ColumnIntToChar $col2]]  
        return $range
    }

    # Get the number of rows of a range.
    # "rangeId" can be an object of type range, cells, worksheet.
    # If specifying a worksheetId or cellsId, the maximum number of rows
    # of a worksheet will be returned.
    proc GetNumRows { rangeId } {
        set range [$rangeId Rows]
        return [$range Count]
    }

    # Get the number of rows of a worksheet in use.
    proc GetNumUsedRows { worksheetId } {
        set range [$worksheetId UsedRange]
        return [[$range Rows] Count]
    }

    # Get the number of columns of a range.
    # "rangeId" can be an object of type range, cells, worksheet.
    # If specifying a worksheetId or cellsId, the maximum number of columns
    # of a worksheet will be returned.
    proc GetNumColumns { rangeId } {
        set range [$rangeId Columns]
        return [$range Count]
    }

    # Get the number of columns of a worksheet in use.
    # In some cases the number of columns returned may be 1 to high.
    proc GetNumUsedColumns { worksheetId } {
        set range [$worksheetId UsedRange]
        return [[$range Columns] Count]
    }

    # Select a range by specifying an Excel range string.
    # The range is selected in worksheet/cells specified by cellsId.
    # Set visSel to true, to see the selection in the user interface.
    proc SelectRangeByStr { cellsId rangeStr { visSel false } } {
        set rangeId [$cellsId Range $rangeStr]
        if { $visSel } {
            $rangeId Select
        }
        return $rangeId
    }

    # Select a range by specifying a numeric range.
    # The range is selected in worksheet/cells specified by cellsId.
    # The numeric range is specified as upper left and lower right corner.
    # Set visSel to true, to see the selection in the user interface.
    proc SelectRangeByIndex { cellsId row1 col1 row2 col2 { visSel false } } {
        set rangeStr [::Excel::GetCellRange $row1 $col1 $row2 $col2]
        set rangeId [$cellsId Range $rangeStr]
        if { $visSel } {
            $rangeId Select
        }
        return $rangeId
    }

    proc SelectAll { cellsId } {
        return [[GetApplicationId $cellsId] Cells]
    }

    proc SetRangeFontBold { rangeId { onOff true } } {
        set fontId [$rangeId Font]
        $fontId Bold [::Excel::TclBool $onOff]
    }

    proc SetRangeFontItalic { rangeId { onOff true } } {
        set fontId [$rangeId Font]
        $fontId Italic [::Excel::TclBool $onOff]
    }

    # Set the horizontal alignment of a cell range.
    # "align" must be a value of enumeration XlHAlign (see excelConst.tcl).
    proc SetRangeHorizontalAlignment { rangeId align } {
        $rangeId HorizontalAlignment [expr $align]
    }

    # Set the vertical alignment of a cell range.
    # "align" must be a value of enumeration XlVAlign (see excelConst.tcl).
    proc SetRangeVerticalAlignment { rangeId align } {
        $rangeId VerticalAlignment [expr $align]
    }

    # Toggle the AutoFilter switch of a cell range.
    proc ToggleAutoFilter { rangeId } {
        $rangeId AutoFilter
    }

    # Set the fill color of a cell range.
    # The red, green and blue components must be integers from 0 to 255.
    proc SetRangeFillColor { rangeId r g b } {
        set color [::Excel::RgbToColor \
                   [expr {int($r)}] [expr {int($g)}] [expr {int($b)}]]
        [$rangeId Interior] Color $color
        [$rangeId Interior] Pattern $::Excel::xlSolid
    }

    # Set the text color of a cell range.
    # The red, green and blue components must be integers from 0 to 255.
    proc SetRangeTextColor { rangeId r g b } {
        set color [::Excel::RgbToColor \
                   [expr {int($r)}] [expr {int($g)}] [expr {int($b)}]]
        [$rangeId Font] Color $color
    }

    # Get the version of an Excel application.
    # By default the version is returned as version number (ex. 9.0).
    # If useString is set to true, the version name is returned (ex. Excel 2000). 
    proc GetVersion { appId { useString false } } {
        array set map {
            "8.0"  "Excel 97"
            "9.0"  "Excel 2000"
            "10.0" "Excel 2002"
            "11.0" "Excel 2003"
            "12.0" "Excel 2007"
            "14.0" "Excel 2010"
        }
        set version [$appId Version]
        if { $useString } {
            if { [info exists map($version)] } {
                return $map($version) 
            }
        }
        return $version
    }

    # Return the default extension of an Excel file.
    # Starting with Excel 12 (2007) this is the string ".xlsx".
    # In previous versions it was ".xls".
    proc GetExtString { appId } {
        if { [GetVersion $appId] >= 12.0 } {
            return ".xlsx"
        } else {
            return ".xls"
        }
    }

    # Return the active printer as a string.
    proc GetActivePrinter { appId } {
        return [$appId ActivePrinter]
    }

    # Return the current Excel user as a string.
    proc GetUserName { appId } {
        return [$appId UserName]
    }

    # Return the startup pathname.
    proc GetStartupPath { appId } {
        return [$appId StartupPath]
    }

    # Return the templates pathname.
    proc GetTemplatesPath { appId } {
        return [$appId TemplatesPath]
    }

    # Return the add-ins pathname.
    proc GetUserLibraryPath { appId } {
        if { [GetVersion $appId] eq "8.0" } {
            return "Unsupported"
        } else {
            return [$appId UserLibraryPath]
        }
    }

    # Return the installation pathname.
    proc GetInstallationPath { appId } {
        return [$appId Path]
    }

    # Return the user folder's pathname.
    proc GetUserPath { appId } {
        return [$appId DefaultFilePath]
    }

    proc ShowAlerts { appId onOff } {
        $appId DisplayAlerts [::Excel::TclBool $onOff]
    }

    proc GetApplicationId { componentId } {
        return [$componentId Application]
    }

    proc GetApplicationName { applId } {
        return [$applId Name]
    }

    # Open a new Excel application.
    # If "visible" is set to false, the application starts in detached mode.
    # Return the identifier for the Excel application.
    proc OpenNew { { visible true } { width -1 } { height -1 } } {
        variable excelVersion

        set appId [::Excel::_getOrCreateExcel false]
        $appId Visible [::Excel::TclBool $visible]
        if { $width >= 0 } {
            $appId Width [expr $width]
        }
        if { $height >= 0 } {
            $appId Height [expr $height]
        }
        set excelVersion [::Excel::GetVersion $appId]
        return $appId
    }

    # Open an Excel application. Use an already open Excel, if available.
    # If "visible" is set to false, the application starts in detached mode.
    # Return the identifier for the Excel application.
    proc Open { { visible true } { width -1 } { height -1 } } {
        variable excelVersion

        set appId [::Excel::_getOrCreateExcel true]
        $appId Visible [::Excel::TclBool $visible]
        if { $width >= 0 } {
            $appId Width [expr $width]
        }
        if { $height >= 0 } {
            $appId Height [expr $height]
        }
        set excelVersion [::Excel::GetVersion $appId]
        return $appId
    }

    # Quit the Excel application identified by "appId".
    # If saveChanges is set to false, the application quits without
    # saving any changes.
    proc Quit { appId { saveChanges true } } {
        if { ! $saveChanges } {
            ::Excel::ShowAlerts $appId false
        }
        $appId Quit
    }

    proc Visible { appId visible } {
        $appId Visible [::Excel::TclBool $visible]
    }

    # Close a workbook without saving possible changes.
    # Use the SaveAs method before closing, if you want to save changes.
    proc Close { workbookId } {
        $workbookId Close [::Excel::TclBool false]
    }

    # Save a workbook in file "fileName".
    # If no "fmt" is given, the file is stored in native Excel format.
    # "fmt" must be a constant as defined by the xlFileFormat enumeration.
    # If "backup" is set to 1, a backup file is created before storing.
    proc SaveAs { workbookId fileName { fmt "" } { backup 0 } } {
        set fileName [file nativename $fileName]
        if { $fmt eq "" } {
            $workbookId SaveAs $fileName
        } else {
            set appId [GetApplicationId $workbookId]
            ::Excel::ShowAlerts $appId false
            $workbookId -namedarg SaveAs \
                        Filename $fileName \
                        FileFormat $fmt \
                        CreateBackup $backup
            ::Excel::ShowAlerts $appId true
        }
    }

    # Save a worksheet in CSV format in file "fileName".
    proc SaveAsCsv { workbookId worksheetId fileName } {
        set fileName [file nativename $fileName]
        set appId [GetApplicationId $workbookId]
        ::Excel::ShowAlerts $appId false
        $worksheetId -namedarg SaveAs \
                     Filename $fileName \
                     FileFormat $::Excel::xlCSV \
                     CreateBackup 0
        ::Excel::ShowAlerts $appId true
    }

    # This function adds a new workbook with 1 worksheet.
    # Valid enums for type are: 
    # xlChart
    # xlExcel4IntlMacroSheet
    # xlExcel4MacroSheet
    # xlWorksheet           (This is the default value)
    # Return the workbook identifier.
    proc AddWorkbook { appId { type "" } } {
        if { $type eq "" } {
            set type $::Excel::xlWorksheet
        }
        set workbooks [$appId Workbooks]
        set workbookId [$workbooks Add [expr $type]]
        return $workbookId
    }

    proc OpenWorkbook { appId fileName { readOnly false } } {
        set readOnlyInt [::Excel::TclBool $readOnly]
        set nativeName  [file nativename $fileName]
        set workbooks [$appId Workbooks]
        set retVal [catch {[$workbooks Item [file tail $fileName]] Activate} d]
        if { $retVal == 0 } {
            puts "$nativeName already open"
            set workbookId [$workbooks Item [file tail $fileName]]
        } else {
            set workbookId [$workbooks -namedarg Open Filename $nativeName \
                                                      ReadOnly $readOnlyInt]
        }
        return $workbookId
    }

    proc GetActiveWorkbook { appId } {
        return [$appId ActiveWorkbook]
    }

    # Add a new worksheet to workbook "workbookId" with name "name". 
    # If visibleType is not given, the worksheet is visible.
    # Possible values for visibleType are:
    # xlSheetVisible, xlSheetHidden, xlSheetVeryHidden
    # Return the worksheet identifier.
    proc AddWorksheet { workbookId name { visibleType "" } } {
        set worksheets [$workbookId Worksheets]
        set lastWorksheet [$worksheets Item [$worksheets Count]]
        # The next line will insert the worksheet at the end.
        # This gives problems with Excel 2000, when adding charts.
        # set worksheetId [$worksheets Add [::tcom::na] $lastWorksheet]
        # So we add worksheets always at the beginning.
        set worksheetId [$worksheets Add]
        $worksheetId Name $name
        if { $visibleType ne "" } {
            $worksheetId Visible $visibleType
        }
        return $worksheetId
    }

    proc DeleteWorksheet { workbookId worksheetId } {
        set worksheets [$workbookId Worksheets]
        set count [$worksheets Count]

        if { $count == 1 } {
           return
        }

        # Delete the specified worksheet.
        # This will cause alert dialogs to be displayed unless they are turned off.
        set appId [GetApplicationId $workbookId]
        ::Excel::ShowAlerts $appId false
        $worksheetId Delete
        # Turn the alerts back on.
        ::Excel::ShowAlerts $appId true
    }

    proc DeleteWorksheetByIndex { workbookId index } {
        set worksheets [$workbookId Worksheets]
        set count [$worksheets Count]

        if { $count == 1 } {
           return
        }
        if { $index < 1 || $index > $count } {
            error "Invalid index $index given"
        }
        # Delete the specified worksheet.
        # This will cause alert dialogs to be displayed unless they are turned off.
        set appId [GetApplicationId $workbookId]
        ::Excel::ShowAlerts $appId false
        set worksheet [$worksheets Item $index]
        $worksheet Delete
        # Turn the alerts back on.
        ::Excel::ShowAlerts $appId true
    }

    # Return the worksheet identifier of worksheet "item" of
    # workbook "workbookId".
    proc GetWorksheetIdByIndex { workbookId item } {
        set worksheets [$workbookId Worksheets]
        set worksheetId [$worksheets Item [expr $item]]
        return $worksheetId
    }

    # Return the worksheet identifier of worksheet with name "worksheetName".
    proc GetWorksheetIdByName { workbookId worksheetName } {
        set worksheets [$workbookId Worksheets]
        set count [$worksheets Count]
        for { set i 1 } { $i <= $count } { incr i } {
            set worksheetId [$worksheets Item [expr $i]]
            if { $worksheetName eq [$worksheetId Name] } {
                return $worksheetId
            }
        }
        error "No worksheet with name $worksheetName"
    }

    # Set the worksheet name to "name".
    proc SetWorksheetName { worksheetId name } {
        $worksheetId Name $name
    }

    # Return the worksheet name of worksheet identified by "worksheetId".
    proc GetWorksheetName { worksheetId } {
        set name [$worksheetId Name]
        return $name
    }

    # Return the number of worksheets in a workbook identified by "workbookId".
    proc GetNumWorksheets { workbookId } {
        set worksheets [$workbookId Worksheets]
        set count [$worksheets Count]
        return $count
    }

    # Return the cells identifier of worksheet identified by "worksheetId".
    proc GetCellsId { worksheetId } {
        set cellsId [$worksheetId Cells]
        return $cellsId
    }

    # Return the cell identifier of the cell indexed by (row,col).
    # The cell is contained in cells object identified by "cellsId".
    proc GetCellIdByIndex { cellsId row col } {
        set colChar [ColumnIntToChar $col]
        set cell [$cellsId Item $row $col]
        return $cell
    }

    # Select a cell by specifying a numeric range.
    # The range is selected in worksheet/cells specified by cellsId.
    # The numeric range is specified as row and column number.
    # Set visSel to true, to see the selection in the user interface.
    proc SelectCellByIndex { cellsId row col { visSel false } } {
        set rangeStr [::Excel::GetCellRange $row $col $row $col]
        set rangeId [$cellsId Range $rangeStr]
        if { $visSel } {
            $rangeId Select
        }
        return $rangeId
    }

    proc SetHyperlink { worksheetId row col link { textDisplay "" } } {
        variable excelVersion

        if { $textDisplay eq "" } {
            set textDisplay $link
        }

        set cellsId [GetCellsId $worksheetId]
        set rangeId [SelectRangeByIndex $cellsId $row $col $row $col]
        set hyperId [$worksheetId Hyperlinks]
        if { $excelVersion eq "8.0" } {
            $hyperId -namedarg Add Anchor $rangeId \
                                   Address $link
        } else {
            $hyperId -namedarg Add Anchor $rangeId \
                                   Address $link \
                                   TextToDisplay $textDisplay
        }
    }

    proc InsertImage { worksheetId imgFileName { row 0 } { col 0 } } {
        set cellId [SelectCellByIndex $worksheetId $row $col true]
        set pictures [$worksheetId Pictures]
        set fileName [file nativename $imgFileName]
        set picId [$pictures Insert $fileName]
        return $picId
    }

    proc ScaleImage { picId scaleWidth scaleHeight } {
        set rangeId [$picId ShapeRange]
        $rangeId ScaleWidth  [expr $scaleWidth]  [::Excel::TclBool true]
        $rangeId ScaleHeight [expr $scaleHeight] [::Excel::TclBool true]
    }

    # Set the value of cell indexed by (row,col) to "val".
    # The cell is contained in cells object identified by "cellsId".
    proc SetCellValue { cellsId row col val } {
        variable mapFloatPoint

        if { $mapFloatPoint } {
            set val [string map {"." ","} $val]
        }
        set colChar [ColumnIntToChar $col]
        $cellsId Item $row $col $val
    }

    proc GetCellValue { cellsId row col } {
        variable mapFloatPoint
        variable errorValue

        set colChar [ColumnIntToChar $col]
        set cell [$cellsId Item $row $col]
        set retVal [catch {$cell Value} val]
        if { $retVal != 0 } {
            set val $errorValue
        }
        if { $mapFloatPoint } {
            set val [string map {"," "."} $val]
        }
        return $val
    }

    # Insert the values contained in valList into row "row" of the
    # worksheet cells identified by cellsId.
    # The insertion is started in column "startCol".
    # By default all the list values are inserted. If the optional
    # parameter numVals is specified and greater than zero, then only
    # numVals are filled with the list values starting at list index 0.
    proc SetRowValues { cellsId row startCol valList { numVals 0 } } {
        set len [llength $valList]
        if { $numVals > 0 } {
            if { $numVals < $len } {
                set len $numVals
            }
        }
        set ind 0
        for { set c $startCol } { $c < [expr {$startCol + $len}] } { incr c } {
            SetCellValue $cellsId $row $c [lindex $valList $ind]
            incr ind
        }
    }

    proc GetRowValues { cellsId row startCol { numVals 0 } } {
        if { $numVals <= 0 } {
            set len [::Excel::GetNumColumns $cellsId]
        } else {
            set len $numVals
        }
        set valList [list]
        set col $startCol
        set ind 0
        while { $ind < $len } {
            set val [::Excel::GetCellValue $cellsId $row $col]
            if { $val eq "" } {
                set val2 [::Excel::GetCellValue $cellsId $row [expr {$col+1}]]
                if { $val2 eq "" } {
                    break
                }
            }
            lappend valList $val
            incr ind
            incr col
        }
        return $valList
    }

    # Set the width of a column. 
    # A positive value specifies the column's width in average-size characters
    # of the widget's font. A value of zero specifies that the column's width
    # fits automatically the width of all elements in the column.
    proc SetColumnWidth { cellsId col width } {
        set cell [SelectRangeByIndex $cellsId 1 $col 1 $col]
        set curCol [$cell EntireColumn]
        if { $width == 0 } {
            [$curCol Columns] AutoFit
        } else {
            $curCol ColumnWidth $width
        }
    }

    proc SetColumnsWidth { cellsId startCol endCol width } {
        for { set c $startCol } { $c <= $endCol } { incr c } {
            SetColumnWidth $cellsId $c $width
        }
    }

    proc SetColumnValues { cellsId col startRow valList { numVals 0 } } {
        set len [llength $valList]
        if { $numVals > 0 } {
            if { $numVals < $len } {
                set len $numVals
            }
        }
        set ind 0
        for { set r $startRow } { $r < [expr {$startRow + $len}] } { incr r } {
            SetCellValue $cellsId $r $col [lindex $valList $ind]
            incr ind
        }
    }

    proc GetColumnValues { cellsId col startRow { numVals 0 } } {
        if { $numVals <= 0 } {
            set len [GetNumRows $cellsId]
        } else {
            set len $numVals 
        }
        set valList [list]
        set row $startRow
        set ind 0
        while { $ind < $len } {
            set val [GetCellValue $cellsId $row $col]
            if { $val eq "" } {
                set val2 [GetCellValue $cellsId [expr {$row+1}] $col]
                if { $val2 eq "" } {
                    break
                }
            }
            lappend valList $val
            incr ind
            incr row
        }
        return $valList
    }
}

::Excel::_Init
