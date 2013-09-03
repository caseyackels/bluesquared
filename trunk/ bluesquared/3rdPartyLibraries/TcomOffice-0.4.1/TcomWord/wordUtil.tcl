# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

package provide tcomword 0.4.1

namespace eval ::Word {

    proc SetHeaderLine { tableId headerList { row 1 } { startCol 1 } } {
        set len [llength $headerList]
        ::Word::SetRowValues $tableId $row $startCol $headerList $len
        ::Word::FormatHeaderLine $tableId $startCol [expr {$startCol + $len}] $row
    }

    proc FormatHeaderLine { tableId startCol endCol { row 1 } } {
        set header [::Word::GetRowRange $tableId $row]
        ::Word::SetRangeHorizontalAlignment $header $::Word::wdAlignParagraphCenter
        ::Word::SetRangeBackgroundColorByEnum $header $::Word::wdColorGray25
        ::Word::SetRangeFontBold $header
    }

    # Insert the matrix values contained in "matrixList" into the table
    # identified by "tableId".
    # The insertion of the matrix data starts at cell "startRow,startCol".
    # The matrix data must be stored as a list of lists. Each sub-list contains
    # the values for the row values.
    # TODO: Support copying data via the clipboard
    proc SetMatrixValues { tableId matrixList { startRow 1 } { startCol 1 } } {
        set curRow $startRow
        foreach rowList $matrixList {
            ::Word::SetRowValues $tableId $curRow $startCol $rowList
            incr curRow
        }
    }

    proc GetMatrixValues { tableId row1 col1 row2 col2 } {
        set numVals [expr {$col2-$col1+1}]
        for { set row $row1 } { $row <= $row2 } { incr row } {
            lappend matrixList [::Word::GetRowValues $tableId $row $col1 $numVals]
        }
        return $matrixList
    }
}
