# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

package provide tcomword 0.4.1

namespace eval ::Word {

    variable pkgInfo

    variable wordVersion  ""

    proc _Init {} {
        variable pkgInfo

        set retVal [catch {package require tcom} version]
        set pkgInfo(tcom,avail)   [expr !$retVal]
        set pkgInfo(tcom,version) $version

        set retVal [catch {package require twapi} version]
        set pkgInfo(twapi,avail)   [expr !$retVal]
        set pkgInfo(twapi,version) $version
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
        if { [::Word::HavePkg $pkgName] } {
            set retVal $pkgInfo($pkgName,version)
        }
        return $retVal
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

    proc TrimText { str } {
        set str [string trim $str]
        set str [string trim $str [format "%c" 0x7]]
        set str [string trim $str [format "%c" 0xD]]
        return $str
    }

    proc FindString { rangeId str } {
        set myFind [$rangeId Find]
        set retVal [$myFind -namedarg Execute \
                            FindText $str \
                            MatchCase True \
                            Wrap $::Word::wdFindStop \
                            Forward True]
        if { $retVal } {
            return true
        }
        return false
    }

    proc ReplaceString { rangeId searchStr replaceStr \
                        { howMuch "one" } { matchCase true } } {
        set howMuchEnum $::Word::wdReplaceOne
        if { $howMuch ne "one" } {
            set howMuchEnum $::Word::wdReplaceAll
        }
        set myFind [$rangeId Find]
        set retVal [$myFind -namedarg Execute \
                            FindText $searchStr \
                            ReplaceWith $replaceStr \
                            Replace $howMuchEnum \
                            Wrap $::Word::wdFindStop \
                            MatchCase [::Word::TclBool $matchCase] \
                            Forward True]
        if { $retVal } {
            return true
        }
        return false
    }

    # Search for string "str" in the range "rangeId". For each
    # occurence found, call procedure "func" with the range of
    # the found occurence and additional parameters specified in
    # "args". The procedures which  can be used for "func" must
    # therefore have the following signature:
    # proc SetRangeXYZ rangeId param1 param2 ...
    # See example Word-04-Find.tcl for an example.
    proc RecursiveChange { rangeId str func args } {
        set myFind [$rangeId Find]
        set count 0
        while { 1 } {
            set retVal [$myFind -namedarg Execute \
                                FindText $str \
                                MatchCase True \
                                Forward True]
            if { ! $retVal } {
                break
            }
            eval $func $rangeId $args
            incr count
        }
    }

    proc GetStartRange { docId } {
        set rangeId [[$docId ActiveWindow] Selection]
        $rangeId Start 0
        $rangeId End 0
        return $rangeId
    }

    # Get the built-in bookmark \endofdoc, i.e. the end of the document.
    proc GetEndRange { docId } {
        set bookMarks [$docId Bookmarks]
        set endOfDoc  [$bookMarks Item "\\endofdoc"]
        set endRange  [$endOfDoc Range]
        return $endRange
    }

    proc PrintRange { rangeId { msg "Range: " } } {
        puts [format "%s %d %d" $msg \
              [::Word::GetRangeStart $rangeId] [::Word::GetRangeEnd $rangeId]]
    }

    proc GetRangeStart { rangeId } {
        return [$rangeId Start]
    }

    proc GetRangeEnd { rangeId } {
        return [$rangeId End]
    }

    proc SetRangeStart { docId rangeId index } {
        if { $index eq "begin" } {
            set index 0
        }
        $rangeId Start $index
    }

    proc SetRangeEnd { docId rangeId index } {
        if { $index eq "end" } {
            set index [[GetEndRange $docId] End]
        }
        $rangeId End $index
    }

    proc ExtendRange { docId rangeId { startIncr 0 } { endIncr 0 } } {
        set startIndex [::Word::GetRangeStart $rangeId]
        set endIndex   [::Word::GetRangeEnd $rangeId]
        if { [string is integer $startIncr] } {
            set startIndex [expr $startIndex + $startIncr]
        } elseif { $startIncr eq "begin" } {
            set startIndex 0
        }
        if { [string is integer $endIncr] } {
            set endIndex [expr $endIndex + $endIncr]
        } elseif { $endIncr eq "end" } {
            set endIndex [[GetEndRange $docId] End]
        }
        $rangeId Start $startIndex
        $rangeId End $endIndex
        return $rangeId
    }

    proc SetRangeFontBold { rangeId { onOff true } } {
        set fontId [$rangeId Font]
        $fontId Bold [::Word::TclBool $onOff]
    }

    proc SetRangeFontItalic { rangeId { onOff true } } {
        set fontId [$rangeId Font]
        $fontId Italic [::Word::TclBool $onOff]
    }

    # Set the horizontal alignment of a cell range.
    # "align" must be a value of enumeration WdParagraphAlignment 
    # (see wordConst.tcl).
    proc SetRangeHorizontalAlignment { rangeId align } {
        [$rangeId ParagraphFormat] Alignment $align
    }

    # Set the highlight color of a range by using a symbolic color name.
    # "colorEnum" must be a value of enumeration WdColor (see wordConst.tcl).
    proc SetRangeHighlightColorByEnum { rangeId colorEnum } {
        $rangeId HighlightColorIndex $colorEnum
    }

    # Get the version of an Word application.
    # By default the version is returned as version number (ex. 9.0).
    # If useString is set to true, the version name is returned (ex. Word 2000). 
    proc GetVersion { appId { useString false } } {
        array set map {
            "7.0"  "Word 95"
            "8.0"  "Word 97"
            "9.0"  "Word 2000"
            "10.0" "Word 2002"
            "11.0" "Word 2003"
            "12.0" "Word 2007"
            "14.0" "Word 2010"
        }
        set version [$appId Version]
        if { $useString } {
            if { [info exists map($version)] } {
                return $map($version) 
            } else {
                return "Unknown Word version"
            }
        } else {
            return $version
        }
    }

    # Return the active printer as a string.
    proc GetActivePrinter { appId } {
        return [$appId ActivePrinter]
    }

    # Return the default extension of a Word file.
    # Starting with Word 12 (2007) this is the string ".docx".
    # In previous versions it was ".doc".
    proc GetExtString { appId } {
        if { [GetVersion $appId] >= 12.0 } {
            return ".docx"
        } else {
            return ".doc"
        }
    }

    # Return the current Word user as a string.
    proc GetUserName { appId } {
        return [$appId UserName]
    }

    # Return the startup pathname.
    proc GetStartupPath { appId } {
        return [$appId StartupPath]
    }

    # Return the installation pathname.
    proc GetInstallationPath { appId } {
        return [$appId Path]
    }

    proc ShowAlerts { appId onOff } {
        $appId DisplayAlerts [::Word::TclBool $onOff]
    }

    proc GetApplicationId { componentId } {
        return [$componentId Application]
    }

    proc GetApplicationName { applId } {
        return [$applId Name]
    }

    proc InchesToPoints { inches } {
        return [expr {$inches * 72.0}]
    }

    proc _getOrCreateWord { useExistingFirst } {
        if { ! [HavePkg "tcom"] } {
            error "Cannot get or create Word application object. No Tcom extension available."
        }
        if { $useExistingFirst } {
            set retVal [catch {::tcom::ref getactiveobject "Word.Application"} appId]
            if { $retVal == 0 } {
                return $appId
            }
        }
        set retVal [catch {::tcom::ref createobject "Word.Application"} appId]
        if { $retVal == 0 } {
            return $appId
        }
        error "Cannot get or create Word application object."
    }

    # Open a new Word application.
    # If "visible" is set to false, the application starts in detached mode.
    # Return the identifier for the Word application.
    proc OpenNew { { visible true } { width -1 } { height -1 } } {
        variable wordVersion

        set appId [::Word::_getOrCreateWord false]
        $appId Visible [::Word::TclBool $visible]
        if { $width >= 0 } {
            $appId Width [expr $width]
        }
        if { $height >= 0 } {
            $appId Height [expr $height]
        }
        set wordVersion [::Word::GetVersion $appId]
        return $appId
    }

    # Open an Word application. Use an already open Word, if available.
    # If "visible" is set to false, the application starts in detached mode.
    # Return the identifier for the Word application.
    proc Open { { visible true } { width -1 } { height -1 } } {
        variable wordVersion

        set appId [::Word::_getOrCreateWord true]
        $appId Visible [::Word::TclBool $visible]
        if { $width >= 0 } {
            $appId Width [expr $width]
        }
        if { $height >= 0 } {
            $appId Height [expr $height]
        }
        set wordVersion [::Word::GetVersion $appId]
        return $appId
    }

    # Quit the Word application identified by "appId".
    # If saveChanges is set to false, the application quits without
    # saving any changes.
    proc Quit { appId { saveChanges true } } {
        if { ! $saveChanges } {
            ::Word::ShowAlerts $appId false
        }
        $appId Quit
    }

    # Close a document without saving possible changes.
    # Use the SaveAs method before closing, if you want to save changes.
    proc Close { docId } {
        $docId Close [::Word::TclBool false]
    }

    #
    # Methods related to document management in Word.
    #

    # Save the document in DOC format in file "fileName".
    proc SaveAs { docId fileName { fmt "" } } {
        set fileName [file nativename $fileName]
        if { $fmt eq "" } {
            $docId SaveAs $fileName
        } else {
            set appId [GetApplicationId $docId]
            ::Word::ShowAlerts $appId false
            $docId -namedarg SaveAs FileName $fileName FileFormat $fmt CreateBackup 0
            ::Word::ShowAlerts $appId true
        }
    }

    # This function adds a new empty document.
    # "type" must be of enumeration WdNewDocumentType.
    # Return the new document identifier.
    proc AddDocument { appId { type "" } { visible true } } {
        set visibleInt [::Word::TclBool $visible]
        if { $type eq "" } {
            set type $::Word::wdNewBlankDocument
        }
        set docs [$appId Documents]
        set docId [$docs -namedarg Add DocumentType $type \
                                       Visible $visibleInt]
        return $docId
    }

    # Return the number of documents in a workbook identified by "workbookId".
    proc GetNumDocuments { appId } {
        set docs [$appId Documents]
        set count [$docs Count]
        return $count
    }

    proc OpenDocument { appId fileName { readOnly false } } {
        set readOnlyInt [::Word::TclBool $readOnly]
        set nativeName  [file nativename $fileName]
        set docs [$appId Documents]
        set retVal [catch {[$docs Item [file tail $fileName]] Activate} d]
        if { $retVal == 0 } {
            puts "$nativeName already open"
            set docId [$docs Item [file tail $fileName]]
        } else {
            set docId [$docs -namedarg Open FileName $nativeName \
                                            ReadOnly $readOnlyInt]
        }
        return $docId
    }

    proc GetDocumentId { appId index } {
        set docs [$appId Documents]
        return [$docs Item $index]
    }

    proc GetDocumentName { docId } {
        return [$docId FullName]
    }

    #
    # Methods related to text management in Word.
    #

    # Append a paragraph at the end of the document.
    # This also selects a range, which is returned and can
    # be used for further processing.
    proc AppendParagraph { docId { text "" } { spaceAfter -1 } } {
        set endRange [GetEndRange $docId]
        $endRange InsertParagraphAfter
        if { $text ne "" } {
            $endRange InsertAfter $text
        }
        if { $spaceAfter >= 0 } {
            [$endRange ParagraphFormat] SpaceAfter $spaceAfter
        }
        return [GetEndRange $docId]
    }

    proc AddParagraph { rangeId { where "after" } } {
        if { $where eq "after" } {
            $rangeId InsertParagraphAfter
        } else {
            $rangeId InsertParagraphBefore
        }
    }

    proc AppendText { docId text } {
        set endRange [::Word::GetEndRange $docId]
        set para [[[$docId Content] Paragraphs] Add $endRange]
        set range [$para Range]
        $range InsertAfter $text
        return $range
    }

    #
    # Methods related to table management in Word.
    #

    # Return the table identifier of a new table created in range "rangeId".
    # The table has "numRows" rows and "numCols" columns.
    proc AddTable { docId rangeId numRows numCols { spaceAfter -1 } } {
        set tableId [[$docId Tables] Add $rangeId $numRows $numCols]
        if { $spaceAfter >= 0 } {
            [[$tableId Range] ParagraphFormat] SpaceAfter $spaceAfter
        }
        return $tableId
    }

    # Set the outside and inside border line style of table "tableId".
    # The values of "outsideLineStyle" and "insideLineStyle" must
    # be from the enumeration WdLineStyle.
    proc SetTableBorderLineStyle { tableId \
              { outsideLineStyle -1 } \
              { insideLineStyle  -1 } } {
        if { $outsideLineStyle < 0 } {
            set outsideLineStyle $::Word::wdLineStyleSingle
        }
        if { $insideLineStyle < 0 } {
            set insideLineStyle $::Word::wdLineStyleSingle
        }
        set border [$tableId Borders]
        $border OutsideLineStyle $outsideLineStyle
        $border InsideLineStyle  $insideLineStyle
    }

    # Set the outside and inside border line width of table "tableId".
    # The values of "outsideLineWidth" and "insideLineWidth" must
    # be from the enumeration WdLineWidth.
    proc SetTableBorderLineWidth { tableId \
              { outsideLineWidth -1 } \
              { insideLineWidth  -1 } } {
        if { $outsideLineWidth < 0 } {
            set outsideLineWidth $::Word::wdLineWidth050pt
        }
        if { $insideLineWidth < 0 } {
            set insideLineWidth $::Word::wdLineWidth050pt
        }
        set border [$tableId Borders]
        $border OutsideLineWidth $outsideLineWidth
        $border InsideLineWidth  $insideLineWidth
    }
 
    # Set the background color of a cell range by using a symbolic color name.
    # "colorEnum" must be a value of enumeration WdColor (see wordConst.tcl).
    proc SetRangeBackgroundColorByEnum { rangeId colorEnum } {
        [[$rangeId Cells] Shading] BackgroundPatternColor $colorEnum
    }

    # Set the background color of a cell range by using r,g,b values.
    # Color values must be in the range 0..255.
    proc SetRangeBackgroundColor { rangeId r g b } {
        [[$rangeId Cells] Shading] BackgroundPatternColor \
                                   [::Word::RgbToColor $r $g $b]
    }

    proc GetNumRows { tableId } {
        return [[$tableId Rows] Count]
    }

    proc GetNumColumns { tableId } {
        return [[$tableId Columns] Count]
    }

    proc GetCellRange { tableId row col } {
        set cellId [$tableId Cell $row $col]
        return [$cellId Range]
    }

    # Return a range consisting of all cells of
    # row "row" in table "tableId".
    proc GetRowRange { tableId row } {
        set rowId [[$tableId Rows] Item $row]
        return [$rowId Range]
    }

    # Return a selection consisting of all cells of
    # column "col" in table "tableId".
    # Note, that a selection is returned and not a range,
    # because columns do not have a range property.
    proc GetColumnRange { tableId col } {
        set colId [[$tableId Columns] Item $col]
        $colId Select
        set selectId [[$tableId Application] Selection]
        $selectId SelectColumn
        return $selectId
    }

    # Set the (text) value of cell indexed by (row, col) to "val".
    # The cell is contained in the table object identified by "tableId".
    # The range of the cell is returned for further processing.
    proc SetCellValue { tableId row col val } {
        set rangeId [::Word::GetCellRange $tableId $row $col]
        $rangeId Text $val
        return $rangeId
    }

    proc GetCellValue { tableId row col } {
        set rangeId [::Word::GetCellRange $tableId $row $col]
        set val [::Word::TrimText [$rangeId Text]]
        return $val
    }

    # Insert the values contained in valList into row row of the
    # table identified by tableId.
    # The insertion is started in column startCol.
    # By default all the list values are inserted. If the optional
    # parameter numVals is specified and greater than zero, then only
    # numVals are filled with the list values starting at list index 0.
    proc SetRowValues { tableId row startCol valList { numVals 0 } } {
        set len [llength $valList]
        if { $numVals > 0 } {
            if { $numVals < $len } {
                set len $numVals
            }
        }
        set ind 0
        for { set c $startCol } { $c < [expr {$startCol + $len}] } { incr c } {
            SetCellValue $tableId $row $c [lindex $valList $ind]
            incr ind
        }
    }

    proc GetRowValues { tableId row startCol { numVals 0 } } {
        if { $numVals <= 0 } {
            set len [::Word::GetNumColumns $tableId]
        } else {
            set len $numVals
        }
        set valList [list]
        set col $startCol
        set ind 0
        while { $ind < $len } {
            set val [::Word::GetCellValue $tableId $row $col]
            lappend valList $val
            incr ind
            incr col
        }
        return $valList
    }

    # Set the width of a table column in points.
    # There are utility methods InchesToPoints for conversion.
    proc SetColumnWidth { tableId col width } {
        set colId [[$tableId Columns] Item $col]
        $colId Width $width
    }

    proc SetColumnsWidth { tableId startCol endColNum width } {
        for { set c $startCol } { $c <= $endColNum } { incr c } {
            SetColumnWidth $tableId $c $width
        }
    }

    proc SetColumnValues { tableId col startRow valList { numVals 0 } } {
        set len [llength $valList]
        if { $numVals > 0 } {
            if { $numVals < $len } {
                set len $numVals
            }
        }
        set ind 0
        for { set r $startRow } { $r < [expr {$startRow + $len}] } { incr r } {
            SetCellValue $tableId $r $col [lindex $valList $ind]
            incr ind
        }
    }

    proc GetColumnValues { tableId col startRow { numVals 0 } } {
        if { $numVals <= 0 } {
            set len [GetNumRows $tableId]
        } else {
            set len $numVals 
        }
        set valList [list]
        set row $startRow
        set ind 0
        while { $ind < $len } {
            set val [GetCellValue $tableId $row $col]
            if { $val eq "" } {
                set val2 [GetCellValue $tableId [expr {$row+1}] $col]
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

::Word::_Init
