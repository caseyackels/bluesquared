# Copyright: 2007-2018 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

namespace eval Word {

    namespace ensemble create

    namespace export AddImageTable
    namespace export CountWords
    namespace export DiffWordFiles
    namespace export FormatHeaderRow
    namespace export GetMatrixValues
    namespace export SetHeaderRow
    namespace export SetMatrixValues

    proc CountWords { docId args } {
        # Count words contained in a Word document.
        #
        # docId - Identifier of the document.
        # args  - List of key value pairs specifying the counting configure
        #         options and its values.
        #
        # Option keys:
        #
        # -sortmode <string>
        #        Sorting mode of output list.
        #        Default: length. Possible values: dictionary, length.
        # -minlength <int> 
        #        Only count words having more than minlength characters.
        #        Default: No limit.
        # -maxlength <int> 
        #        Only count words having less than maxlength characters.
        #        Default: No limit.
        # -shownumbers <bool>
        #        If set to false, only count words which are no numbers.
        #
        # This procedure is used in the CAWT application WordAbbrCheck
        # to get a list of words contained in a Word document.
        #
        # Returns a key-value list containing the found words and their
        # corresponding count.
        #
        # See also: ::Cawt::CountWords

        set rangeId [Word GetStartRange $docId]
        Word SetRangeStartIndex $rangeId "begin"
        Word SetRangeEndIndex   $rangeId "end"

        set docText [$rangeId Text]

        set wordCountList [Cawt CountWords $docText {*}$args]
        Cawt Destroy $rangeId
        return $wordCountList
    }

    proc SetHeaderRow { tableId headerList { row 1 } { startCol 1 } } {
        # Insert row values into a Word table and format as a header row.
        #
        # tableId    - Identifier of the Word table.
        # headerList - List of values to be inserted as header.
        # row        - Row number. Row numbering starts with 1.
        # startCol   - Column number of insertion start. Column numbering starts with 1.
        #
        # Returns no value. If headerList is an empty list, an error is thrown.
        #
        # See also: SetRowValues FormatHeaderRow

        set len [llength $headerList]
        Word SetRowValues $tableId $row $headerList $startCol $len
        Word FormatHeaderRow $tableId $row $startCol [expr {$startCol + $len -1}]
    }

    proc FormatHeaderRow { tableId row startCol endCol } {
        # Format a row as a header row.
        #
        # tableId  - Identifier of the Word table.
        # row      - Row number. Row numbering starts with 1.
        # startCol - Column number of formatting start. Column numbering starts with 1.
        # endCol   - Column number of formatting end. Column numbering starts with 1.
        #
        # The cell values of a header are formatted as bold text with both vertical and
        # horizontal centered alignment.
        #
        # Returns no value.
        #
        # See also: SetHeaderRow

        set header [Word GetRowRange $tableId $row]
        Word SetRangeHorizontalAlignment $header $Word::wdAlignParagraphCenter
        Word SetRangeBackgroundColorByEnum $header $Word::wdColorGray25
        Word SetRangeFontBold $header
    }

    proc SetMatrixValues { tableId matrixList { startRow 1 } { startCol 1 } } {
        # Insert matrix values into a Word table.
        #
        # tableId    - Identifier of the Word table.
        # matrixList - Matrix with table data.
        # startRow   - Row number of insertion start. Row numbering starts with 1.
        # startCol   - Column number of insertion start. Column numbering starts with 1.
        #
        # The matrix data must be stored as a list of lists. Each sub-list contains
        # the values for the row values.
        # The main (outer) list contains the rows of the matrix.
        #
        # Example:
        #     { { R1_C1 R1_C2 R1_C3 } { R2_C1 R2_C2 R2_C3 } }
        #
        # Returns no value.
        #
        # See also: GetMatrixValues

        set curRow $startRow
        foreach rowList $matrixList {
            Word SetRowValues $tableId $curRow $rowList $startCol
            incr curRow
        }
    }

    proc GetMatrixValues { tableId row1 col1 row2 col2 } {
        # Return table values as a matrix.
        #
        # tableId - Identifier of the Word table.
        # row1    - Row number of upper-left corner of the cell range.
        # col1    - Column number of upper-left corner of the cell range.
        # row2    - Row number of lower-right corner of the cell range.
        # col2    - Column number of lower-right corner of the cell range.
        #
        # Returns table values as a matrix.
        #
        # See also: SetMatrixValues

        set numVals [expr {$col2-$col1+1}]
        for { set row $row1 } { $row <= $row2 } { incr row } {
            lappend matrixList [Word GetRowValues $tableId $row $col1 $numVals]
        }
        return $matrixList
    }

    proc DiffWordFiles { wordBaseFile wordNewFile } {
        # Compare two Word files visually.
        #
        # wordBaseFile - Name of the base Word file.
        # wordNewFile  - Name of the new Word file.
        #
        # The two files are opened in Word's compare mode.
        #
        # Returns the identifier of the new Word application instance.
        #
        # See also: OpenNew

        variable wordVersion

        if { ! [file exists $wordBaseFile] } {
            error "Diff: Base file $wordBaseFile does not exists"
        }
        if { ! [file exists $wordNewFile] } {
            error "Diff: New file $wordNewFile does not exists"
        }
        if { [file normalize $wordBaseFile] eq [file normalize $wordNewFile] } {
            error "Diff: Base and new file are equal. Cannot compare."
        }

        set appId [Word OpenNew true]

        if { $wordVersion >= 12.0 } {
            # From Word 2007 and up, change order of files.
            set tmpFile $wordBaseFile
            set wordBaseFile $wordNewFile
            set wordNewFile $tmpFile
        }

        set newDocId [Word OpenDocument $appId [file nativename $wordNewFile] true]
        $newDocId -with { ActiveWindow View } Type $Word::wdNormalView

        $newDocId Compare [file nativename $wordBaseFile] "CawtDiff" $Word::wdCompareTargetNew true true

        $appId -with { ActiveDocument } Saved [Cawt TclBool true]
        Word Close $newDocId

        return $appId
    }

    proc AddImageTable { rangeId numCols imgList { captionList {} } } {
        # Add a new table and fill the cells with images.
        #
        # rangeId     - Identifier of the text range.
        # numCols     - Number of columns of the new table.
        # imgList     - List of image file names.  
        # captionList - List of caption texts.  
        # 
        # Returns the identifier of the new table.
        #
        # See also: AddTable InsertImage

        set numImgs  [llength $imgList]
        set numTexts [llength $captionList]

        if { $numCols <= 0 } {
            error "AddImageTable: Number of columns must be greater than zero."
        }

        set numRowsToAdd 1
        if { $numTexts > 0 } {
            incr numRowsToAdd
        }
        set tableId [Word AddTable $rangeId $numRowsToAdd $numCols]

        set curRow  1
        set curCol  1
        set curElem 0
        foreach img $imgList {
            set caption ""
            if { $curElem < $numTexts } {
                set caption [lindex $captionList $curElem]
            }
            if { $numTexts > 0 } {
                Word SetCellValue $tableId [expr { $curRow + 1}] $curCol $caption
            }
            set rangeId [Word GetCellRange $tableId $curRow $curCol]
            Word InsertImage $rangeId $img
            Cawt Destroy $rangeId
            incr curCol
            incr curElem
            if { $curCol > $numCols } {
                set curCol 1
                incr curRow $numRowsToAdd
                if { $curElem < $numImgs } {
                    Word AddRow $tableId end $numRowsToAdd
                }
            }
        }
        return $tableId
    }
}
