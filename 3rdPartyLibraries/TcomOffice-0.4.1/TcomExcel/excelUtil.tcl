# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

package provide tcomexcel 0.4.1

namespace eval ::Excel {

    # Find a string in a cell range. If endRow and/or endCol is negative,
    # all rows/columns are searched. The first cell matching the search
    # string is returned as a 2-element list {row, col}.
    proc FindCell { cellsId str { startRow 1 } { endRow -1 } \
                                { startCol 1 } { endCol -1 } } {
        if { $endRow < 0 } {
            set endRow [::Excel::GetNumRows $cellsId]
        }
        if { $endCol < 0 } {
            set endCol [::Excel::GetNumColumns $cellsId]
        }
        for { set row $startRow } { $row <= $endRow } { incr row } {
            for { set col $startCol } { $col <= $endCol } { incr col } {
                set cellValue [::Excel::GetCellValue $cellsId $row $col]
                if { $cellValue eq $str } {
                    return [list $row $col]
                }
            }
        }
        return [list -1 -1]
    }

    proc SetHeaderLine { cellsId headerList { row 1 } { startCol 1 } } {
        set len [llength $headerList]
        ::Excel::SetRowValues $cellsId $row $startCol $headerList $len
        ::Excel::FormatHeaderLine $cellsId $startCol [expr {$startCol + $len}] $row
    }

    proc FormatHeaderLine { cellsId startCol endCol { row 1 } } {
        set header [::Excel::SelectRangeByIndex $cellsId $row $startCol \
                                                         $row $endCol]
        ::Excel::SetRangeHorizontalAlignment $header $::Excel::xlCenter
        ::Excel::SetRangeVerticalAlignment   $header $::Excel::xlCenter
        ::Excel::SetRangeFontBold $header
    }

    proc CopyWorksheet { fromWorksheetId toWorksheetId } {
        $fromWorksheetId Activate
        set rangeId [::Excel::SelectAll $fromWorksheetId]
        $rangeId Copy

        $toWorksheetId Activate
        $toWorksheetId Paste
    }

    # Insert the matrix values contained in "matrixList" into the worksheet
    # identified by "worksheetId".
    # The insertion of the matrix data starts at cell "startRow,startCol".
    # The matrix data must be stored as a list of lists. Each sub-list contains
    # the values for the row values.
    # Note: This procedure uses the Twapi extension for fast insertion of large 
    #       data. If Twapi is not available, it uses the SetRowValues 
    #       procedure and is significantly slower then.
    proc SetMatrixValues { worksheetId matrixList { startRow 1 } { startCol 1 } } {
        variable useTwapi
        variable mapFloatPoint

        set cellsId [::Excel::GetCellsId $worksheetId]
        if { [::Excel::HavePkg "twapi"] && $useTwapi } {
            set csvFmt [twapi::register_clipboard_format "Csv"]

            twapi::open_clipboard
            twapi::empty_clipboard
            ::Csv::SetSeparatorChar ";"
            twapi::write_clipboard $csvFmt [::Csv::List2Csv $matrixList $mapFloatPoint]
            twapi::close_clipboard

            set cellId [::Excel::SelectRangeByIndex $cellsId \
                        $startRow $startCol $startRow $startCol true]

            # If not waiting at least a little while, 
            # on some computers the Paste method fails.
            after 10
            $worksheetId Paste
        } else {
            set curRow $startRow
            foreach rowList $matrixList {
                ::Excel::SetRowValues $cellsId $curRow $startCol $rowList
                incr curRow
            }
        }
    }

    proc GetMatrixValues { worksheetId row1 col1 row2 col2 } {
        variable useTwapi
        variable mapFloatPoint

        set cellsId [::Excel::GetCellsId $worksheetId]
        if { [::Excel::HavePkg "twapi"] && $useTwapi } {
            set rangeId [::Excel::SelectRangeByIndex $cellsId \
                         $row1 $col1 $row2 $col2 true]
            $rangeId Copy

            set csvFmt [twapi::register_clipboard_format "Csv"]
            while { ! [twapi::clipboard_format_available $csvFmt] } {
                after 10
            }
            twapi::open_clipboard
            set clipboardData [twapi::read_clipboard $csvFmt]
            twapi::close_clipboard

            ::Csv::SetSeparatorChar ";"
            set matrixList [::Csv::Csv2List $clipboardData $mapFloatPoint]
        } else {
            set numVals [expr {$col2-$col1+1}]
            for { set row $row1 } { $row <= $row2 } { incr row } {
                lappend matrixList [::Excel::GetRowValues $cellsId $row $col1 $numVals]
            }
        }
        return $matrixList
    }
}
