# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

package provide tcomexcel 0.4.1

namespace eval ::Excel {

    proc TablelistToWorksheet { tableId worksheetId { useHeader true } } {
        set cellsId [::Excel::GetCellsId $worksheetId]
        set startRow 1
        if { $useHeader } {
            # -align -labelalign
            # -width -1 pixel 0 dynamic
            # -title
            set numCols [$tableId columncount]
            for { set col 0 } { $col < $numCols } { incr col } {
                lappend headerList [$tableId columncget $col -title]
            }
            ::Excel::SetHeaderLine $cellsId $headerList
            incr startRow
        }
        set matrixList [$tableId get 0 end]
        ::Excel::SetMatrixValues $worksheetId $matrixList $startRow 1
    }

    proc WorksheetToTablelist { worksheetId tableId { useHeader true } } {
        set cellsId [::Excel::GetCellsId $worksheetId]
        set numRows [::Excel::GetNumUsedRows $worksheetId]
        set numCols [::Excel::GetNumUsedColumns $worksheetId]
        set startRow 1
        if { $useHeader } {
            set headerList [::Excel::GetRowValues $cellsId 1 1 $numCols]
            foreach title $headerList {
                $tableId insertcolumns end 0 $title left
            }
            incr startRow
        } else {
            for { set col 1 } { $col <= $numCols } { incr col } {
                $tableId insertcolumns end 0 "NN" left
            }
        }
        set excelList [::Excel::GetMatrixValues $worksheetId $startRow 1 $numRows $numCols]
        foreach rowList $excelList {
            $tableId insert end $rowList
        }
    }
}
