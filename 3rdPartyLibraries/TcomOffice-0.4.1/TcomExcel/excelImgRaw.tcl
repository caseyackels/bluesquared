# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

package provide tcomexcel 0.4.1

namespace eval ::Excel {

    proc _GetRawImageHeader { rawFp } {
        gets $rawFp line
        scan $line "Magic=%s" magic
        gets $rawFp line
        scan $line "Width=%d" width
        gets $rawFp line
        scan $line "Height=%d" height
        gets $rawFp line
        scan $line "NumChan=%d" numChans
        gets $rawFp line
        scan $line "ByteOrder=%s" byteOrder
        gets $rawFp line
        scan $line "ScanOrder=%s" scanOrder
        gets $rawFp line
        scan $line "PixelType=%s" pixelType
        return [list $magic $width $height $numChans $byteOrder $scanOrder $pixelType]
    }

    proc _PrintHeaderLine { fp msg } {
        set HEADLEN 20
        while { [string length $msg] < [expr {$HEADLEN -1}] } {
            append msg " "
        }
        puts $fp $msg
    }

    proc _PutRawImageHeader { rawFp width height } {
        ::Excel::_PrintHeaderLine $rawFp [format "Magic=%s" "RAW"]
        ::Excel::_PrintHeaderLine $rawFp [format "Width=%d"  $width]
        ::Excel::_PrintHeaderLine $rawFp [format "Height=%d" $height]
        ::Excel::_PrintHeaderLine $rawFp [format "NumChan=%d" 1]
        ::Excel::_PrintHeaderLine $rawFp [format "ByteOrder=%s" "Intel"]
        ::Excel::_PrintHeaderLine $rawFp [format "ScanOrder=%s" "TopDown"]
        ::Excel::_PrintHeaderLine $rawFp [format "PixelType=%s" "float"]
    }

    proc ReadRawImageHeader { rawImgFile } {
        set retVal [catch {open $rawImgFile "r"} rawFp]
        if { $retVal != 0 } {
            error "Cannot open file $rawImgFile"
        }
        fconfigure $rawFp -translation binary
        set headerList [::Excel::_GetRawImageHeader $rawFp]
        close $rawFp
        return $headerList
    }

    proc ReadRawImage { rawImgFile } {
        set retVal [catch {open $rawImgFile "r"} rawFp]
        if { $retVal != 0 } {
            error "Cannot open file $rawImgFile"
        }
        fconfigure $rawFp -translation binary

        set headerList [::Excel::_GetRawImageHeader $rawFp]
        lassign $headerList magic width height numChans byteOrder scanOrder pixelType

        if { $numChans != 1 && $pixelType ne "float" && $byteOrder ne "Intel" } {
            error "Only 1-channel floating point images in Little-Endian supported"
        }

        set numVals [expr {$width*$height}]
        for { set row 0 } { $row < $height } { incr row } {
            for { set col 0 } { $col < $width } { incr col } {
                set valBytes [read $rawFp 4]
                binary scan $valBytes f val
                lappend rowList($row) $val 
            }
        }

        if { $scanOrder eq "TopDown" } {
            for { set row 0 } { $row < $height } { incr row } {
                lappend matrixList $rowList($row)
            }
        } else {
            for { set row [expr $height-1] } { $row >= 0 } { incr row -1 } {
                lappend matrixList $rowList($row)
            }
        }

        close $rawFp
        return $matrixList
    }

    proc WriteRawImage { rawImgFile matrixList } {
        set retVal [catch {open $rawImgFile "w"} rawFp]
        if { $retVal != 0 } {
            error "Cannot open file $rawImgFile"
        }
        fconfigure $rawFp -translation binary

        set height [llength $matrixList]
        set width  [llength [lindex $matrixList 0]]
        ::Excel::_PutRawImageHeader $rawFp $width $height
        foreach rowList $matrixList {
            foreach pix $rowList {
                puts -nonewline $rawFp [binary format f $pix]
            }
        }
    }

    proc RawImageToWorksheet { rawFileName worksheetId { useHeader true } } {
        set cellsId [::Excel::GetCellsId $worksheetId]
        set startRow 1
        if { $useHeader } {
            set headerList [::Excel::ReadRawImageHeader $rawFileName]
            ::Excel::SetHeaderLine $cellsId $headerList
            incr startRow
        }
        set matrixList [::Excel::ReadRawImage $rawFileName]
        ::Excel::SetMatrixValues $worksheetId $matrixList $startRow 1
    }

    proc WorksheetToRawImage { worksheetId rawFileName { useHeader true } } {
        set cellsId [::Excel::GetCellsId $worksheetId]
        set numRows [::Excel::GetNumUsedRows $worksheetId]
        set numCols [::Excel::GetNumUsedColumns $worksheetId]
        set startRow 1
        if { $useHeader } {
            incr startRow
        }
        set excelList [::Excel::GetMatrixValues $worksheetId $startRow 1 $numRows $numCols]
        WriteRawImage $rawFileName $excelList
    }
}
