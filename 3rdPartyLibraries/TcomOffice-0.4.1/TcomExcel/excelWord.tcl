# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

package provide tcomexcel 0.4.1

namespace eval ::Excel {

    # Copy the data contained in Word table "tableId" into Excel worksheet
    # identified by "worksheetId".
    proc WordTableToWorksheet { tableId worksheetId { useHeader true } } {
        set cellsId [::Excel::GetCellsId $worksheetId]
        set startRow 1
        if { $useHeader } {
            set numCols [::Word::GetNumColumns $tableId]
            for { set col 1 } { $col <= $numCols } { incr col } {
                lappend headerList [::Word::GetCellValue $tableId $startRow $col]
            }
            ::Excel::SetHeaderLine $cellsId $headerList
            incr startRow
        }
        set numRows [::Word::GetNumRows $tableId]
        if { $useHeader } {
            incr numRows -1
        }
        set tableList [::Word::GetMatrixValues $tableId \
                      $startRow 1 [expr {$startRow + $numRows-1}] $numCols]
        ::Excel::SetMatrixValues $worksheetId $tableList $startRow 1
    }

    proc WorksheetToWordTable { worksheetId tableId { useHeader true } } {
        set cellsId [::Excel::GetCellsId $worksheetId]
        set numRows [::Excel::GetNumUsedRows $worksheetId]
        set numCols [::Excel::GetNumUsedColumns $worksheetId]
        set startRow 1
        set headerList [::Excel::GetRowValues $cellsId 1 1 $numCols]
        if { [llength $headerList] < $numCols } {
            set numCols [llength $headerList]
        }
        if { $useHeader } {
            ::Word::SetHeaderLine $tableId $headerList
            incr startRow
        }
        set excelList [::Excel::GetMatrixValues $worksheetId $startRow 1 $numRows $numCols]
        ::Word::SetMatrixValues $tableId $excelList $startRow 1
    }
}
