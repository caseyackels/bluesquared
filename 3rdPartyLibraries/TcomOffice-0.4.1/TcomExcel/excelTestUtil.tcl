# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

package provide tcomexcel 0.4.1

namespace eval ::Excel {

    proc InsertTestData { cellsId timeHeader timeList valsHeaderList valsList } {
        # Insert first row with header names.
        # First column contains the time header, next columns of row 1
        # contain the header of the data columns.
        SetCellValue $cellsId 1 1 $timeHeader

        set col 2
        foreach head $valsHeaderList {
            SetCellValue $cellsId 1 $col $head
            incr col
        }
        set lastDataCol [expr $col - 1]

        # Format the header lines.
        FormatHeaderLine $cellsId 1 [expr $col-1]

        # Now insert the data row by row.
        set row 2
        foreach t $timeList vals $valsList {
            set col 1
            SetCellValue $cellsId $row $col $t
            incr col
            foreach val $vals {
                SetCellValue $cellsId $row $col $val
                incr col
            }
            incr row
        }
        set lastDataRow [expr $row - 1]

        incr row
        set r $row
        set funcList [list \
            [::Excel::GetLangFuncName "MIN"] \
            [::Excel::GetLangFuncName "MAX"] \
            [::Excel::GetLangFuncName "AVERAGE"] \
            [::Excel::GetLangFuncName "STDEV"]]
        foreach labelStr $funcList {
            SetCellValue $cellsId $r 1 $labelStr
            SetRangeFontBold [::Excel::GetCellIdByIndex $cellsId $r 1] true
            incr r
        }

        for { set c 2 } { $c <= $lastDataCol } { incr c } {
            set dataRange [::Excel::GetCellRange 2 $c $lastDataRow $c]
            set r $row
            foreach func $funcList {
                set cell [SelectRangeByIndex $cellsId $r $c $r $c]
                set formula [format "=%s(%s)" $func $dataRange]
                $cell Formula $formula
                incr r
            }
        }
    }
}
