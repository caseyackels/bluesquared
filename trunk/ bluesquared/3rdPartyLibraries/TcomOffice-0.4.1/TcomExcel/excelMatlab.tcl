# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

package provide tcomexcel 0.4.1

namespace eval ::Excel {

    proc _PutMatlabHeader { matFp width height matrixName } {
        puts -nonewline $matFp [binary format iiiii \
        0 $height $width 0 [string length $matrixName]]
        puts -nonewline $matFp [binary format a* $matrixName]
    }

    proc _GetMatlabHeader { matFp } {
        # Check for Level 4 MAT-File.
        set mat4Header [read $matFp 20]
        binary scan $mat4Header iiiii matType height width \
                                      matImaginary matNameLen

        if { $matType == 0    || $matNumRows == 0 || \
             $matNumCols == 0 || $matImaginary == 0 } {
            set matVersion 4
            set matName [read $matFp $matNameLen]
        } else {
            set matVersion 5
            seek $matFp 0
            error "Matlab Level 5 files not yet supported"
        }
        if { $matType != 0 } {
            error "Currently only Intel double-precision numeric matrices are supported."
        }
        return [list $matVersion $width $height]
    }

    proc ReadMatlabHeader { matFileName } {
        set retVal [catch {open $matFileName "r"} matFp]
        if { $retVal != 0 } {
            error "Cannot open file $matFileName"
        }
        fconfigure $matFp -translation binary
        set headerList [::Excel::_GetMatlabHeader $matFp]
        close $matFp
        return $headerList
    }

    proc ReadMatlab { matFileName } {
        set retVal [catch {open $matFileName "r"} matFp]
        if { $retVal != 0 } {
            error "Cannot open file $matFileName"
        }
        fconfigure $matFp -translation binary

        set headerList [::Excel::_GetMatlabHeader $matFp]
        lassign $headerList version width height

        # Parse a Level 4 MAT-File
        if { $version == 4 } {
            set bytesPerPixel 8
            for { set col 0 } { $col < $width } { incr col } {
                for { set row 0 } { $row < $height } { incr row } {
                    set valBytes [read $matFp $bytesPerPixel]
                    binary scan $valBytes d val
                    lappend rowList($row) $val
                }
            }
        }

        for { set row 0 } { $row < $height } { incr row } {
            lappend matrixList $rowList($row)
        }

        close $matFp
        return $matrixList
    }

    proc WriteMatlab { matFileName matrixList } {
        set retVal [catch {open $matFileName "w"} matFp]
        if { $retVal != 0 } {
            error "Cannot open file $matFileName"
        }
        fconfigure $matFp -translation binary

        set height [llength $matrixList]
        set width  [llength [lindex $matrixList 0]]
        ::Excel::_PutMatlabHeader $matFp $width $height [file rootname $matFileName]
        for { set col 0 } { $col < $width } { incr col } {
            for { set row 0 } { $row < $height } { incr row } {
                set pix [lindex [lindex $matrixList $row] $col]
                puts -nonewline $matFp [binary format d $pix]
            }
        }
    }

    proc MatlabToWorksheet { matFileName worksheetId { useHeader true } } {
        set cellsId [::Excel::GetCellsId $worksheetId]
        set startRow 1
        if { $useHeader } {
            set headerList [::Excel::ReadMatlabHeader $matFileName]
            ::Excel::SetHeaderLine $cellsId $headerList
            incr startRow
        }
        set matrixList [::Excel::ReadMatlab $matFileName]
        ::Excel::SetMatrixValues $worksheetId $matrixList $startRow 1
    }

    proc WorksheetToMatlab { worksheetId matFileName { useHeader true } } {
        set cellsId [::Excel::GetCellsId $worksheetId]
        set numRows [::Excel::GetNumUsedRows $worksheetId]
        set numCols [::Excel::GetNumUsedColumns $worksheetId]
        set startRow 1
        if { $useHeader } {
            incr startRow
        }
        set excelList [::Excel::GetMatrixValues $worksheetId $startRow 1 $numRows $numCols]
        WriteMatlab $matFileName $excelList
    }
}
