# Copyright: 2007-2018 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

namespace eval Word {

    namespace ensemble create

    namespace export AddBookmark
    namespace export AddContentControl
    namespace export AddDocument
    namespace export AddPageBreak
    namespace export AddParagraph
    namespace export AddRow
    namespace export AddTable
    namespace export AddText
    namespace export AppendParagraph
    namespace export AppendText
    namespace export Close
    namespace export ConfigureCaption
    namespace export CreateRange
    namespace export CreateRangeAfter
    namespace export CropImage
    namespace export DeleteRow
    namespace export ExtendRange
    namespace export FindString
    namespace export GetBookmarkName
    namespace export GetCellRange
    namespace export GetCellValue
    namespace export GetColumnRange
    namespace export GetColumnValues
    namespace export GetCompatibilityMode
    namespace export GetDocumentId
    namespace export GetDocumentIdByIndex
    namespace export GetDocumentName
    namespace export GetEndRange
    namespace export GetExtString
    namespace export GetImageId
    namespace export GetImageName
    namespace export GetListGalleryId
    namespace export GetListTemplateId
    namespace export GetNumCharacters
    namespace export GetNumColumns
    namespace export GetNumDocuments
    namespace export GetNumImages
    namespace export GetNumRows
    namespace export GetNumTables
    namespace export GetRangeEndIndex
    namespace export GetRangeInformation
    namespace export GetRangeStartIndex
    namespace export GetRowRange
    namespace export GetRowValues
    namespace export GetSelectionRange
    namespace export GetStartRange
    namespace export GetTableIdByIndex
    namespace export GetVersion
    namespace export InsertCaption
    namespace export InsertFile
    namespace export InsertImage
    namespace export InsertList
    namespace export InsertText
    namespace export IsValidCell
    namespace export Open
    namespace export OpenDocument
    namespace export OpenNew
    namespace export PrintRange
    namespace export Quit
    namespace export ReplaceByProc
    namespace export ReplaceImage
    namespace export ReplaceString
    namespace export SaveAs
    namespace export SaveAsPdf
    namespace export ScaleImage
    namespace export Search
    namespace export SelectRange
    namespace export SetCellValue
    namespace export SetColumnValues
    namespace export SetColumnWidth
    namespace export SetColumnsWidth
    namespace export SetCompatibilityMode
    namespace export SetContentControlDropdown
    namespace export SetContentControlText
    namespace export SetHyperlink
    namespace export SetHyperlinkToFile
    namespace export SetImageName
    namespace export SetInternalHyperlink
    namespace export SetLinkToBookmark
    namespace export SetRangeBackgroundColor
    namespace export SetRangeBackgroundColorByEnum
    namespace export SetRangeEndIndex
    namespace export SetRangeFontBold
    namespace export SetRangeFontItalic
    namespace export SetRangeFontName
    namespace export SetRangeFontSize
    namespace export SetRangeFontUnderline
    namespace export SetRangeFontBackgroundColor
    namespace export SetRangeHighlightColorByEnum
    namespace export SetRangeHorizontalAlignment
    namespace export SetRangeMergeCells
    namespace export SetRangeStartIndex
    namespace export SetRangeStyle
    namespace export SetRowValues
    namespace export SetTableBorderLineStyle
    namespace export SetTableBorderLineWidth
    namespace export ToggleSpellCheck
    namespace export TrimString
    namespace export UpdateFields
    namespace export Visible

    variable wordVersion "0.0"
    variable wordAppName "Word.Application"
    variable _ruffdoc

    lappend _ruffdoc Introduction {
        The Word namespace provides commands to control Microsoft Word.
    }

    proc TrimString { str } {
        # Trim a string.
        #
        # str - String to be trimmed.
        #
        # The string is trimmed from the left and right side.
        # Trimmed characters are whitespaces.
        # Additionally the following control characters are converted:
        # 0xD to \n, 0x7 to space.
        #
        # Returns the trimmed string.

        set str [string map [list [format %c 0xD] \n  [format %c 0x7] " "] $str]
        return [string trim $str]
    }

    proc _IsDocument { objId } {
        # ActiveTheme is a property of the Word Document class.
        set retVal [catch {$objId ActiveTheme} errMsg]
        if { $retVal == 0 } {
            return true
        } else {
            return false
        }
    }

    proc _FindOrReplace { objId paramDict } {
        # Execute([FindText], [MatchCase], [MatchWholeWord], [MatchWildcards],
        # [MatchSoundsLike], [MatchAllWordForms], [Forward], [Wrap], [Format],
        # [ReplaceWith], [Replace], [MatchKashida], [MatchDiacritics],
        # [MatchAlefHamza], [MatchControl]) As Boolean
        set myFind [$objId Find]
        set retVal [$myFind -callnamedargs Execute {*}$paramDict]
        Cawt Destroy $myFind
        return $retVal
    }

    proc _IterateDocument { rangeOrDocId paramDict } {
        if { [Word::_IsDocument $rangeOrDocId] } {
            set numFound 0
            set stories [$rangeOrDocId StoryRanges]
            $stories -iterate story {
                lappend storyList $story
                set retVal [Word::_FindOrReplace $story $paramDict]
                incr numFound
                set nextStory [$story NextStoryRange]
                while { [Cawt IsComObject $nextStory] } {
                    lappend storyList $nextStory
                    set retVal [Word::_FindOrReplace $nextStory $paramDict]
                    incr numFound
                    set nextStory [$nextStory NextStoryRange]
                }
            }
            foreach story $storyList {
                Cawt Destroy $story
            }
            Cawt Destroy $stories
            return $numFound
        } else {
            return [Word::_FindOrReplace $rangeOrDocId $paramDict]
        }
    }

    proc FindString { rangeOrDocId searchStr { matchCase true } { matchWildcards false } } {
        # Find a string in a text range or a document.
        #
        # rangeOrDocId   - Identifier of a text range or a document identifier.
        # searchStr      - Search string.
        # matchCase      - Flag indicating case sensitive search.
        # matchWildcards - Flag indicating wildcard search.
        #
        # Returns zero, if string could not be found. Otherwise a positive integer.
        # If the string was found, the selection is set to the found string.
        #
        # See also: ReplaceString ReplaceByProc Search GetSelectionRange

        return [Word::Search $rangeOrDocId $searchStr \
               -matchcase $matchCase -matchwildcards $matchWildcards \
               -wrap $Word::wdFindStop -forward true] 
    }

    proc ReplaceString { rangeOrDocId searchStr replaceStr \
                        { howMuch "one" } { matchCase true } { matchWildcards false } } {
        # Replace a string in a text range or a document. Simple case.
        #
        # rangeOrDocId   - Identifier of a text range or a document identifier.
        # searchStr      - Search string.
        # replaceStr     - Replacement string.
        # howMuch        - "one" to replace first occurence only. "all" to replace all occurences.
        # matchCase      - Flag indicating case sensitive search.
        # matchWildcards - Flag indicating wildcard search. 
        #
        # Returns zero, if string could not be found and replaced. Otherwise a positive integer.
        #
        # See also: FindString ReplaceByProc Search

        set howMuchEnum $Word::wdReplaceOne
        if { $howMuch ne "one" } {
            set howMuchEnum $Word::wdReplaceAll
        }
        return [Word::Search $rangeOrDocId $searchStr \
               -matchcase $matchCase -matchwildcards $matchWildcards \
               -wrap $Word::wdFindStop -forward true \
               -replacewith $replaceStr -replace $howMuchEnum]
    }

    proc Search { rangeOrDocId searchStr args } {
        # Search or replace a string in a text range or a document. Generic case.
        #
        # rangeOrDocId - Identifier of a text range or a document identifier.
        # searchStr    - Search string.
        # args         - List of key value pairs specifying the search options
        #                and its values.
        #
        # Option keys:
        #
        # See the Word reference documentation regarding Find.Execute at
        # https://msdn.microsoft.com/en-us/library/office/ff193977.aspx for more details.
        #
        # -matchcase
        #     Search in case sensitive mode. Value is of type bool.
        #
        # -matchwholeword
        #     Search entire words only. Value is of type bool.
        #
        # -matchwildcards
        #     Search with wild cards. Value is of type bool.
        #
        # -matchsoundslike
        #     Search for strings that sound similar. Value is of type bool.
        #
        # -matchallwordforms
        #     Search all forms of the search string. Value is of type bool.
        #
        # -forward
        #     Search towards end of document. Value is of type bool. 
        #
        # -wrap
        #     Search wrap mode. Value is of type WdFindWrap (wdFindAsk, wdFindContinue, wdFindStop).
        #
        # -format
        #     Search operation uses formatting in addition to the search string. Value is of type bool.
        #
        # -replacewith
        #     Replacement text. Value is of type string.
        #
        # -replace
        #     Number of replacements. Value is of type WdReplace(wdReplaceNone, wdReplaceOne, wdReplaceAll). 
        #
        # -matchkashida
        #     Match text with matching kashidas in an Arabic-language document. Value is of type bool.
        #
        # -matchdiacritics
        #     Match text with matching diacritics in a right-to-left language document. Value is of type bool.
        #
        # -matchalefhamza
        #     Match text with matching alef hamzas in an Arabic-language document. Value is of type bool.
        #
        # -matchcontrol
        #     Match text with matching bidirectional control characters in a right-to-left language document.
        #     Value is of type bool.
        #
        # -matchprefix
        #     Match words beginning with the search string. Value is of type bool.
        #
        # -matchsuffix
        #     Match words ending with the search string. Value is of type bool.
        #
        # -matchphrase
        #     Ignores all white space and control characters between words. Value is of type bool.
        #
        # -ignorespace
        #      Ignore all white space between words. Value is of type bool.
        #
        # -ignorepunct
        #      Ignore all punctuation characters between words. Value is of type bool.
        #
        # Returns zero, if string could not be found and replaced. Otherwise a positive integer.
        #
        # See also: FindString ReplaceString ReplaceByProc

        set params [dict create FindText $searchStr]

        foreach { key value } $args {
            switch -exact $key {
                "-matchcase"         { dict append params MatchCase         [Cawt TclBool $value] }
                "-matchwholeword"    { dict append params MatchWholeWord    [Cawt TclBool $value] }
                "-matchwildcards"    { dict append params MatchWildcards    [Cawt TclBool $value] }
                "-matchsoundslike"   { dict append params MatchSoundsLike   [Cawt TclBool $value] }
                "-matchallwordforms" { dict append params MatchAllWordForms [Cawt TclBool $value] }
                "-forward"           { dict append params Forward           [Cawt TclBool $value] }
                "-wrap"              { dict append params Wrap              [Word GetEnum $value] }
                "-format"            { dict append params Format            [Cawt TclBool $value] }
                "-replacewith"       { dict append params ReplaceWith       $value }
                "-replace"           { dict append params Replace           [Word GetEnum $value] }
                "-matchkashida"      { dict append params MatchKashida      [Cawt TclBool $value] }
                "-matchdiacritics"   { dict append params MatchDiacritics   [Cawt TclBool $value] }
                "-matchalefhamza"    { dict append params MatchAlefHamza    [Cawt TclBool $value] }
                "-matchcontrol"      { dict append params MatchControl      [Cawt TclBool $value] }
                "-matchprefix"       { dict append params MatchPrefix       [Cawt TclBool $value] }
                "-matchsuffix"       { dict append params MatchSuffix       [Cawt TclBool $value] }
                "-matchphrase"       { dict append params MatchPhrase       [Cawt TclBool $value] }
                "-ignorespace"       { dict append params IgnoreSpace       [Cawt TclBool $value] }
                "-ignorepunct"       { dict append params IgnorePunct       [Cawt TclBool $value] }
                default              { error "Search: Unknown key \"$key\" specified" }
            }
        }
        return [Word::_IterateDocument $rangeOrDocId $params]
    }

    proc ReplaceByProc { rangeId str func args } {
        # Replace a string in a text range. Procedural case.
        #
        # rangeId - Identifier of the text range.
        # str     - Search string.
        # func    - Replacement procedure.
        # args    - Arguments for replacement procedure.
        #
        # Search for string "str" in the range "rangeId". For each
        # occurence found, call procedure "func" with the range of
        # the found occurence and additional parameters specified in
        # "args". The procedures which can be used for "func" must
        # therefore have the following signature:
        # proc SetRangeXYZ rangeId param1 param2 ...
        #
        # See test script Word-04-Find.tcl for an example.
        #
        # Returns no value.
        #
        # See also: FindString ReplaceString

        set myFind [$rangeId Find]
        set count 0
        while { 1 } {
            # See proc _FindOrReplace for a parameter list of the Execute command.
            set retVal [$myFind -callnamedargs Execute \
                                FindText $str \
                                MatchCase True \
                                Forward True]
            if { ! $retVal } {
                break
            }
            eval $func $rangeId $args
            incr count
        }
        Cawt Destroy $myFind
    }

    proc GetNumCharacters { docId } {
        # Return the number of characters in a Word document.
        #
        # docId - Identifier of the document.
        #
        # Returns the number of characters in a Word document.
        #
        # See also: GetNumDocuments GetNumTables GetNumCharacters

        return [$docId -with { Characters } Count]
    }

    proc CreateRange { docId startIndex endIndex } {
        # Create a new text range.
        #
        # docId      - Identifier of the document.
        # startIndex - The start index of the range in characters.
        # endIndex   - The end index of the range in characters.
        #
        # Returns the identifier of the new text range.
        #
        # See also: CreateRangeAfter SelectRange GetSelectionRange

        return [$docId Range $startIndex $endIndex]
    }

    proc CreateRangeAfter { rangeId } {
        # Create a new text range after specified range.
        #
        # rangeId - Identifier of the text range.
        #
        # Returns the identifier of the new text range.
        #
        # See also: CreateRange SelectRange GetSelectionRange

        set docId [Word GetDocumentId $rangeId]
        set index [Word GetRangeEndIndex $rangeId]
        set rangeId [Word CreateRange $docId $index $index]
        Cawt Destroy $docId
        return $rangeId
    }

    proc SelectRange { rangeId } {
        # Select a text range.
        #
        # rangeId - Identifier of the text range.
        #
        # Returns no value.
        #
        # See also: GetSelectionRange

        $rangeId Select
    }

    proc GetSelectionRange { docId } {
        # Return the text range representing the current selection.
        #
        # docId - Identifier of the document.
        #
        # Returns the text range representing the current selection.
        #
        # See also: GetStartRange GetEndRange SelectRange

        return [$docId -with { ActiveWindow } Selection]
    }

    proc GetStartRange { docId } {
        # Return a text range representing the start of the document.
        #
        # docId - Identifier of the document.
        #
        # Returns a text range representing the start of the document.
        #
        # See also: CreateRange GetSelectionRange GetEndRange

        return [Word CreateRange $docId 0 0]
    }

    proc GetEndRange { docId } {
        # Return the text range representing the end of the document.
        #
        # docId - Identifier of the document.
        #
        # Returns the text range representing the end of the document.
        #
        # Note: This corresponds to the built-in bookmark \endofdoc.
        #       The end range of an empty document is (0, 0), although
        #       GetNumCharacters returns 1.
        #
        # See also: GetSelectionRange GetStartRange GetNumCharacters

        set bookMarks [$docId Bookmarks]
        set endOfDoc  [$bookMarks Item "\\endofdoc"]
        set endRange  [$endOfDoc Range]
        Cawt Destroy $endOfDoc
        Cawt Destroy $bookMarks
        set endIndex [Word GetRangeEndIndex $endRange]
        Cawt Destroy $endRange
        return [Word CreateRange $docId $endIndex $endIndex]
    }

    proc GetRangeInformation { rangeId type } {
        # Get information about a text range.
        #
        # rangeId - Identifier of the text range.
        # type    - Value of enumeration type WdInformation (see wordConst.tcl).
        #
        # Returns the range information associated with the supplied type.
        #
        # See also: GetStartRange GetEndRange PrintRange

        return [$rangeId Information [Word GetEnum $type]]
    }

    proc PrintRange { rangeId { msg "Range: " } } {
        # Print the indices of a text range.
        #
        # rangeId - Identifier of the text range.
        # msg     - String printed in front of the indices.
        #
        # The range identifiers are printed onto standard output.
        #
        # Returns no value.
        #
        # See also: GetRangeStartIndex GetRangeEndIndex

        puts [format "%s %d %d" $msg \
              [Word GetRangeStartIndex $rangeId] [Word GetRangeEndIndex $rangeId]]
    }

    proc GetRangeStartIndex { rangeId } {
        # Return the start index of a text range.
        #
        # rangeId - Identifier of the text range.
        #
        # Returns the start index of a text range.
        #
        # See also: GetRangeEndIndex PrintRange

        return [$rangeId Start]
    }

    proc GetRangeEndIndex { rangeId } {
        # Return the end index of a text range.
        #
        # rangeId - Identifier of the text range.
        #
        # Returns the end index of a text range.
        #
        # See also: GetRangeStartIndex PrintRange

        return [$rangeId End]
    }

    proc SetRangeStartIndex { rangeId index } {
        # Set the start index of a text range.
        #
        # rangeId - Identifier of the text range.
        # index   - Index for the range start.
        #
        # Index is either an integer value or string "begin" to
        # use the start of the document.
        #
        # Returns no value.
        #
        # See also: SetRangeEndIndex GetRangeStartIndex

        if { $index eq "begin" } {
            set index 0
        }
        $rangeId Start $index
    }

    proc SetRangeEndIndex { rangeId index } {
        # Set the end index of a text range.
        #
        # rangeId - Identifier of the text range.
        # index   - Index for the range end.
        #
        # Index is either an integer value or string "end" to
        # use the end of the document.
        #
        # Returns no value.
        #
        # See also: SetRangeStartIndex GetRangeEndIndex

        if { $index eq "end" } {
            set docId [Word GetDocumentId $rangeId]
            set index [GetRangeEndIndex [GetEndRange $docId]]
            Cawt Destroy $docId
        }
        $rangeId End $index
    }

    proc ExtendRange { rangeId { startIncr 0 } { endIncr 0 } } {
        # Extend the range indices of a text range.
        #
        # rangeId   - Identifier of the text range.
        # startIncr - Increment of the range start index.
        # endIncr   - Increment of the range end index.
        #
        # Increment is either an integer value or strings "begin" or "end" to
        # use the start or end of the document.
        #
        # Returns the new extended range.
        #
        # See also: SetRangeStartIndex SetRangeEndIndex

        set startIndex [Word GetRangeStartIndex $rangeId]
        set endIndex   [Word GetRangeEndIndex   $rangeId]
        if { [string is integer $startIncr] } {
            set startIndex [expr $startIndex + $startIncr]
        } elseif { $startIncr eq "begin" } {
            set startIndex 0
        }
        if { [string is integer $endIncr] } {
            set endIndex [expr $endIndex + $endIncr]
        } elseif { $endIncr eq "end" } {
            set docId [Word GetDocumentId $rangeId]
            set endRange [GetEndRange $docId]
            set endIndex [$endRange End]
            Cawt Destroy $endRange
            Cawt Destroy $docId
        }
        $rangeId Start $startIndex
        $rangeId End $endIndex
        return $rangeId
    }

    proc AddContentControl { rangeId type { title "" } } {
        # Add a content control to a text range.
        #
        # rangeId - Identifier of the text range.
        # type    - Value of enumeration type WdContentControlType (see wordConst.tcl).
        #           Often used values: wdContentControlCheckBox, wdContentControlText
        # title   - Title string for the control.
        #
        # Returns the content control identifier.
        #
        # See also: SetContentControlText SetContentControlDropdown

        variable wordVersion

        if { $wordVersion < 12.0 } {
            error "Content controls available only in Word 2007 or newer. Running [Word GetVersion $rangeId true]."
        }

        set controlId [$rangeId -with { ContentControls } Add [Word GetEnum $type]]
        if { $title ne "" } {
            $controlId Title $title
        }
        return $controlId
    }

    # TODO Selection.ParentContentControl.LockContents = True

    proc SetContentControlText { controlId placeholderText } {
        if { $placeholderText ne "" } {
            $controlId SetPlaceholderText NULL NULL $placeholderText
        }
    }

    proc SetContentControlDropdown { controlId placeholderText keyValueList } {
        if { $placeholderText ne "" } {
            $controlId SetPlaceholderText NULL NULL $placeholderText
        }
        $controlId -with { DropdownListEntries } Clear
        foreach { key val } $keyValueList {
            $controlId -with { DropdownListEntries } Add $key $val
        }
    }

    proc SetRangeStyle { rangeId style } {
        # Set the style of a text range.
        #
        # rangeId - Identifier of the text range.
        # style   - Value of enumeration type WdBuiltinStyle (see wordConst.tcl).
        #           Often used values: Word::wdStyleHeading1, Word::wdStyleNormal
        #
        # Returns no value. 
        #
        # See also: SetRangeFontSize SetRangeFontName

        set docId [Word GetDocumentId $rangeId]
        set styleId [$docId -with { Styles } Item [Word GetEnum $style]]
        $rangeId Style $styleId
        Cawt Destroy $styleId
        Cawt Destroy $docId
    }

    proc SetRangeFontName { rangeId fontName } {
        # Set the font name of a text range.
        #
        # rangeId  - Identifier of the text range.
        # fontName - Font name.
        #
        # Returns no value.
        #
        # See also: SetRangeFontSize SetRangeFontBold SetRangeFontItalic SetRangeFontUnderline

        $rangeId -with { Font } Name $fontName
    }

    proc SetRangeFontSize { rangeId fontSize } {
        # Set the font size of a text range.
        #
        # rangeId  - Identifier of the text range.
        # fontSize - Font size.
        #
        # The size value may be specified in a format acceptable by
        # procedure Cawt::ValueToPoints, i.e. centimeters, inches or points.
        #
        # Returns no value.
        #
        # See also: SetRangeFontName SetRangeFontBold SetRangeFontItalic SetRangeFontUnderline
        # ::Cawt::ValueToPoints

        $rangeId -with { Font } Size [Cawt ValueToPoints $fontSize]
    }

    proc SetRangeFontBold { rangeId { onOff true } } {
        # Toggle the bold font style of a text range.
        #
        # rangeId - Identifier of the text range.
        # onOff   - true: Set bold style on.
        #           false: Set bold style off.
        #
        # Returns no value.
        #
        # See also: SetRangeFontName SetRangeFontSize SetRangeFontItalic SetRangeFontUnderline

        $rangeId -with { Font } Bold [Cawt TclInt $onOff]
    }

    proc SetRangeFontItalic { rangeId { onOff true } } {
        # Toggle the italic font style of a text range.
        #
        # rangeId - Identifier of the text range.
        # onOff   - true: Set italic style on.
        #           false: Set italic style off.
        #
        # Returns no value.
        #
        # See also: SetRangeFontName SetRangeFontSize SetRangeFontBold SetRangeFontUnderline

        $rangeId -with { Font } Italic [Cawt TclInt $onOff]
    }

    proc SetRangeFontUnderline { rangeId { onOff true } { color wdColorAutomatic } } {
        # Toggle the underline font style of a text range.
        #
        # rangeId - Identifier of the text range.
        # onOff   - true: Set underline style on.
        #           false: Set underline style off.
        # color   - Value of enumeration type WdColor (see wordConst.tcl)
        #
        # Returns no value.
        #
        # See also: SetRangeFontName SetRangeFontSize SetRangeFontBold SetRangeFontItalic

        $rangeId -with { Font } Underline [Cawt TclInt $onOff]
        if { $onOff } {
            $rangeId -with { Font } UnderlineColor [Word GetEnum $color]
        }
    }

    proc SetRangeFontBackgroundColor { rangeId args } {
        # Set the background color of a text range.
        #
        # rangeId - Identifier of the text range.
        # args    - Text color.
        #
        # Color value may be specified in a format acceptable by procedure ::Cawt::GetColor,
        # i.e. color name, hexadecimal string, Office color number or a list of 3 integer RGB values.
        #
        # Returns no value.
        #
        # See also: SetRangeBackgroundColor SetRangeHighlightColorByEnum ::Cawt::GetColor

        $rangeId -with { Font Shading } BackgroundPatternColor [Cawt GetColor {*}$args]
    }

    proc SetRangeHorizontalAlignment { rangeId align } {
        # Set the horizontal alignment of a text range.
        #
        # rangeId - Identifier of the text range.
        # align   - Value of enumeration type WdParagraphAlignment (see wordConst.tcl)
        #           or any of the following strings: left, right, center.
        #
        # Returns no value.
        #
        # See also: SetRangeHighlightColorByEnum

        if { $align eq "center" } {
            set alignEnum $Word::wdAlignParagraphCenter
        } elseif { $align eq "left" } {
            set alignEnum $Word::wdAlignParagraphLeft
        } elseif { $align eq "right" } {
            set alignEnum $Word::wdAlignParagraphRight
        } else {
            set alignEnum [Word GetEnum $align]
        }

        $rangeId -with { ParagraphFormat } Alignment $alignEnum
    }

    proc SetRangeHighlightColorByEnum { rangeId colorEnum } {
        # Set the highlight color of a text range.
        #
        # rangeId   - Identifier of the text range.
        # colorEnum - Value of enumeration type WdColorIndex (see wordConst.tcl).
        #
        # Returns no value.
        #
        # See also: SetRangeBackgroundColorByEnum

        $rangeId HighlightColorIndex [Word GetEnum $colorEnum]
    }

    proc SetRangeBackgroundColorByEnum { rangeId colorEnum } {
        # Set the background color of a table cell range.
        #
        # rangeId   - Identifier of the cell range.
        # colorEnum - Value of enumeration type WdColor (see wordConst.tcl).
        #
        # Returns no value.
        #
        # See also: SetRangeBackgroundColor SetRangeHighlightColorByEnum

        $rangeId -with { Cells Shading } BackgroundPatternColor [Word GetEnum $colorEnum]
    }

    proc SetRangeBackgroundColor { rangeId args } {
        # Set the background color of a table cell range.
        #
        # rangeId - Identifier of the cell range.
        # args    - Text color.
        #
        # Color value may be specified in a format acceptable by procedure ::Cawt::GetColor,
        # i.e. color name, hexadecimal string, Office color number or a list of 3 integer RGB values.
        #
        # Returns no value.
        #
        # See also: SetRangeBackgroundColorByEnum SetRangeHighlightColorByEnum ::Cawt::GetColor

        $rangeId -with { Cells Shading } BackgroundPatternColor [Cawt GetColor {*}$args]
    }

    proc SetRangeMergeCells { rangeId } {
        # Merge a range of cells.
        #
        # rangeId - Identifier of the cell range.
        #
        # No return value.
        #
        # See also: SetRangeHorizontalAlignment SelectRange

        set appId [Office GetApplicationId $rangeId]
        Office ShowAlerts $appId false
        $rangeId -with { Cells } Merge
        Office ShowAlerts $appId true
        Cawt Destroy $appId
    }

    proc AddPageBreak { rangeId } {
        # Add a page break to a text range.
        #
        # rangeId - Identifier of the text range.
        #
        # Returns no value.
        #
        # See also: AddParagraph

        $rangeId Collapse $Word::wdCollapseEnd
        $rangeId InsertBreak [expr { int ($Word::wdPageBreak) }]
        $rangeId Collapse $Word::wdCollapseEnd
    }

    proc AddBookmark { rangeId name } {
        # Add a bookmark to a text range.
        #
        # rangeId - Identifier of the text range.
        # name    - Name of the bookmark.
        #
        # Returns the bookmark identifier.
        #
        # See also: SetLinkToBookmark GetBookmarkName

        set docId [Word GetDocumentId $rangeId]
        set bookmarks [$docId Bookmarks]
        # Create valid bookmark names.
        set validName [regsub -all { } $name {_}]
        set validName [regsub -all -- {-} $validName {_}]
        set bookmarkId [$bookmarks Add $validName $rangeId]

        Cawt Destroy $bookmarks
        Cawt Destroy $docId
        return $bookmarkId
    }

    proc GetBookmarkName { bookmarkId } {
        # Get the name of a bookmark.
        #
        # bookmarkId - Identifier of the boormark.
        #
        # Returns the name of the bookmark.
        #
        # See also: AddBookmark SetLinkToBookmark

        return [$bookmarkId Name]
    }

    proc GetListGalleryId { appId galleryType } {
        # Get one of the 3 predefined list galleries.
        #
        # appId       - Identifier of the Word instance.
        # galleryType - Value of enumeration type WdListGalleryType (see wordConst.tcl).
        #
        # Returns the identifier of the specified list gallery.
        #
        # See also: GetListTemplateId InsertList

        return [$appId -with { ListGalleries } Item [Word GetEnum $galleryType]]
    }

    proc GetListTemplateId { galleryId listType } {
        # Get one of the 7 predefined list templates.
        #
        # galleryId - Identifier of the Word gallery.
        # listType  - Value of enumeration type WdListType (see wordConst.tcl)
        #
        # Returns the identifier of the specified list template.
        #
        # See also: GetListGalleryId InsertList

        return [$galleryId -with { ListTemplates } Item [Word GetEnum $listType]]
    }

    proc InsertList { rangeId stringList \
                      { galleryType wdBulletGallery } \
                      { listType wdListListNumOnly } } {
        # Insert a Word list.
        #
        # rangeId     - Identifier of the text range.
        # stringList  - List of text strings building up the Word list.
        # galleryType - Value of enumeration type WdListGalleryType (see wordConst.tcl).
        # listType    - Value of enumeration type WdListType (see wordConst.tcl)
        #
        # Returns the range of the Word list.
        #
        # See also: GetListGalleryId GetListTemplateId InsertCaption InsertFile InsertImage InsertText

        foreach line $stringList {
            append listStr "$line\n"
        }
        set appId [Office GetApplicationId $rangeId]
        set listRangeId [Word AddText $rangeId $listStr]
        set listGalleryId  [Word GetListGalleryId $appId $galleryType]
        set listTemplateId [Word GetListTemplateId $listGalleryId $listType]
        $listRangeId -with { ListFormat } ApplyListTemplate $listTemplateId
        Cawt Destroy $listTemplateId
        Cawt Destroy $listGalleryId
        Cawt Destroy $appId
        return $listRangeId
    }

    proc GetVersion { objId { useString false } } {
        # Return the version of a Word application.
        #
        # objId     - Identifier of a Word object instance.
        # useString - true: Return the version name (ex. "Word 2000").
        #             false: Return the version number (ex. "9.0").
        #
        # Both version name and version number are returned as strings.
        # Version number is in a format, so that it can be evaluated as a
        # floating point number.
        #
        # Returns the version of a Word application.
        #
        # See also: GetCompatibilityMode GetExtString

        array set map {
            "7.0"  "Word 95"
            "8.0"  "Word 97"
            "9.0"  "Word 2000"
            "10.0" "Word 2002"
            "11.0" "Word 2003"
            "12.0" "Word 2007"
            "14.0" "Word 2010"
            "15.0" "Word 2013"
            "16.0" "Word 2016"
        }
        set version [Office GetApplicationVersion $objId]
        if { $useString } {
            if { [info exists map($version)] } {
                return $map($version)
            } else {
                return "Unknown Word version $version"
            }
        } else {
            return $version
        }
    }

    proc GetCompatibilityMode { appId { version "" } } {
        # Return the compatibility version of a Word application.
        #
        # appId   - Identifier of the Word instance.
        # version - Word version number.
        #
        # Returns the compatibility mode of the current Word application, if
        # version is not specified or the empty string.
        # If version is a valid Word version as returned by GetVersion, the
        # corresponding compatibility mode is returned.
        #
        # Note: The compatibility mode is a value of enumeration WdCompatibilityMode.
        #
        # See also: GetVersion GetExtString

        if { $version eq "" } {
            return $Word::wdCurrent
        } else {
            array set map {
                "11.0" $Word::wdWord2003
                "12.0" $Word::wdWord2007
                "14.0" $Word::wdWord2010
                "15.0" $Word::wdWord2013
            }
            if { [info exists map($version)] } {
                return $map($version)
            } else {
                error "Unknown Word version $version"
            }
        }
    }

    proc GetExtString { appId } {
        # Return the default extension of a Word file.
        #
        # appId - Identifier of the Word instance.
        #
        # Starting with Word 12 (2007) this is the string ".docx".
        # In previous versions it was ".doc".
        #
        # Returns the default extension of a Word file.
        #
        # See also: GetCompatibilityMode GetVersion

        # appId is only needed, so we are sure, that wordVersion is initialized.

        variable wordVersion

        if { $wordVersion >= 12.0 } {
            return ".docx"
        } else {
            return ".doc"
        }
    }

    proc ToggleSpellCheck { appId onOff } {
        # Toggle checking of grammatical and spelling errors.
        #
        # appId - Identifier of the Word instance.
        #
        # Returns no value.
        #
        # See also: Open

        $appId -with { ActiveDocument } ShowGrammaticalErrors [Cawt TclBool $onOff]
        $appId -with { ActiveDocument } ShowSpellingErrors    [Cawt TclBool $onOff]
    }

    proc OpenNew { { visible true } { width -1 } { height -1 } } {
        # Open a new Word instance.
        #
        # visible - true: Show the application window.
        #           false: Hide the application window.
        # width   - Width of the application window. If negative, open with last used width.
        # height  - Height of the application window. If negative, open with last used height.
        #
        # Returns the identifier of the new Word application instance.
        #
        # See also: Open Quit Visible

        variable wordAppName
	variable wordVersion

        set appId [Cawt GetOrCreateApp $wordAppName false]
        set wordVersion [Word GetVersion $appId]
        Word Visible $appId $visible
        if { $width >= 0 } {
            $appId Width [expr $width]
        }
        if { $height >= 0 } {
            $appId Height [expr $height]
        }
        return $appId
    }

    proc Open { { visible true } { width -1 } { height -1 } } {
        # Open a Word instance. Use an already running instance, if available.
        #
        # visible - true: Show the application window.
        #           false: Hide the application window.
        # width   - Width of the application window. If negative, open with last used width.
        # height  - Height of the application window. If negative, open with last used height.
        #
        # Returns the identifier of the Word application instance.
        #
        # See also: OpenNew Quit Visible

        variable wordAppName
	variable wordVersion

        set appId [Cawt GetOrCreateApp $wordAppName true]
        set wordVersion [Word GetVersion $appId]
        Word Visible $appId $visible
        if { $width >= 0 } {
            $appId Width [expr $width]
        }
        if { $height >= 0 } {
            $appId Height [expr $height]
        }
        return $appId
    }

    proc Quit { appId { showAlert true } } {
        # Quit a Word instance.
        #
        # appId     - Identifier of the Word instance.
        # showAlert - true: Show an alert window, if there are unsaved changes.
        #             false: Quit without saving any changes.
        #
        # Returns no value.
        #
        # See also: Open OpenNew

        if { ! $showAlert } {
            Office ShowAlerts $appId false
        }
        $appId Quit
    }

    proc Visible { appId visible } {
        # Toggle the visibility of a Word application window.
        #
        # appId   - Identifier of the Word instance.
        # visible - true: Show the application window.
        #           false: Hide the application window.
        #
        # Returns no value.
        #
        # See also: Open OpenNew

        $appId Visible [Cawt TclInt $visible]
    }

    proc Close { docId } {
        # Close a document without saving changes.
        #
        # docId - Identifier of the document.
        #
        # Use the SaveAs method before closing, if you want to save changes.
        #
        # Returns no value.
        #
        # See also: SaveAs

        $docId Close [Cawt TclBool false]
    }

    proc UpdateFields { docId } {
        # Update all fields as well as tables of content and figures of a document.
        #
        # docId - Identifier of the document.
        #
        # Returns no value.
        #
        # See also: SaveAs

        set stories [$docId StoryRanges]
        $stories -iterate story {
            lappend storyList $story
            $story -with { Fields } Update
            set nextStory [$story NextStoryRange]
            while { [Cawt IsComObject $nextStory] } {
                lappend storyList $nextStory
                $nextStory -with { Fields } Update
                set nextStory [$nextStory NextStoryRange]
            }
        }
        foreach story $storyList {
            Cawt Destroy $story
        }
        Cawt Destroy $stories

        set tocs [$docId TablesOfContents]
        $tocs -iterate toc {
            $toc Update
            Cawt Destroy $toc
        }
        Cawt Destroy $tocs

        set tofs [$docId TablesOfFigures]
        $tofs -iterate tof {
            $tof Update
            Cawt Destroy $tof
        }
        Cawt Destroy $tofs
    }

    proc SaveAs { docId fileName { fmt "" } } {
        # Save a document to a Word file.
        #
        # docId    - Identifier of the document to save.
        # fileName - Name of the Word file.
        # fmt      - Value of enumeration type WdSaveFormat (see wordConst.tcl).
        #            If not given or the empty string, the file is stored in the native
        #            format corresponding to the used Word version.
        #
        # Returns no value.
        #
        # See also: SaveAsPdf

        variable wordVersion

        set fileName [file nativename $fileName]
        set appId [Office GetApplicationId $docId]
        Office ShowAlerts $appId false
        if { $fmt eq "" } {
            if { $wordVersion >= 14.0 } {
                $docId SaveAs $fileName [expr $Word::wdFormatDocumentDefault]
            } else {
                $docId SaveAs $fileName
            }
        } else {
            $docId SaveAs $fileName [Word GetEnum $fmt]
        }
        Office ShowAlerts $appId true
    }

    proc SaveAsPdf { docId fileName } {
        # Save a document to a PDF file.
        #
        # docId    - Identifier of the document to export.
        # fileName - Name of the PDF file.
        #
        # PDF export is supported since Word 2007.
        # If your Word version is older an error is thrown.
        #
        # Note, that for Word 2007 you need the Microsoft Office Add-in
        # "Microsoft Save as PDF or XPS" available from
        # http://www.microsoft.com/en-us/download/details.aspx?id=7
        #
        # Returns no value.
        #
        # See also: SaveAs

        variable wordVersion

        if { $wordVersion < 12.0 } {
            error "PDF export available only in Word 2007 or newer. Running [Word GetVersion $docId true]."
        }

        set fileName [file nativename $fileName]
        set appId [Office GetApplicationId $docId]

        Office ShowAlerts $appId false
        $docId -callnamedargs ExportAsFixedFormat \
               OutputFileName $fileName \
               ExportFormat $Word::wdExportFormatPDF \
               OpenAfterExport [Cawt TclBool false] \
               OptimizeFor $Word::wdExportOptimizeForPrint \
               Range $Word::wdExportAllDocument \
               From [expr 1] \
               To [expr 1] \
               Item $Word::wdExportDocumentContent \
               IncludeDocProps [Cawt TclBool true] \
               KeepIRM [Cawt TclBool true] \
               CreateBookmarks $Word::wdExportCreateHeadingBookmarks \
               DocStructureTags [Cawt TclBool true] \
               BitmapMissingFonts [Cawt TclBool true] \
               UseISO19005_1 [Cawt TclBool false]
        Office ShowAlerts $appId true
    }

    proc SetCompatibilityMode { docId { mode wdWord2010 } } {
        # Set the compatibility mode of a document.
        #
        # docId - Identifier of the document.
        # mode  - Compatibility mode of the document.
        #         Value of enumeration type WdCompatibilityMode (see wordConst.tcl).
        #
        # Available only for Word 2010 and up.
        #
        # Returns no value.
        #
        # See also: GetCompatibilityMode

        variable wordVersion

        if { $wordVersion >= 14.0 } {
            $docId SetCompatibilityMode [Word GetEnum $mode]
        }
    }

    proc AddDocument { appId { type "" } { visible true } } {
        # Add a new empty document to a Word instance.
        #
        # appId   - Identifier of the Word instance.
        # type    - Value of enumeration type WdNewDocumentType (see wordConst.tcl).
        # visible - true: Show the application window.
        #           false: Hide the application window.
        #
        # Returns the identifier of the new document.
        #
        # See also: OpenDocument

        if { $type eq "" } {
            set type $Word::wdNewBlankDocument
        }
        set docs [$appId Documents]
        # Add([Template], [NewTemplate], [DocumentType], [Visible]) As Document
        set docId [$docs -callnamedargs Add \
                         DocumentType [Word GetEnum $type] \
                         Visible [Cawt TclInt $visible]]
        Cawt Destroy $docs
        return $docId
    }

    proc GetNumDocuments { appId } {
        # Return the number of documents in a Word application.
        #
        # appId - Identifier of the Word instance.
        #
        # Returns the number of documents in a Word application.
        #
        # See also: AddDocument OpenDocument

        return [$appId -with { Documents } Count]
    }

    proc OpenDocument { appId fileName { readOnly false } } {
        # Open a document, i.e. load a Word file.
        #
        # appId    - Identifier of the Word instance.
        # fileName - Name of the Word file.
        # readOnly - true: Open the document in read-only mode.
        #            false: Open the document in read-write mode.
        #
        # Returns the identifier of the opened document. If the document was already open,
        # activate that document and return the identifier to that document.
        #
        # See also: AddDocument

        set nativeName  [file nativename $fileName]
        set docs [$appId Documents]
        set retVal [catch {[$docs Item [file tail $fileName]] Activate} d]
        if { $retVal == 0 } {
            # puts "$nativeName already open"
            set docId [$docs Item [file tail $fileName]]
        } else {
            # Open(FileName, [ConfirmConversions], [ReadOnly],
            # [AddToRecentFiles], [PasswordDocument], [PasswordTemplate],
            # [Revert], [WritePasswordDocument], [WritePasswordTemplate],
            # [Format], [Encoding], [Visible], [OpenAndRepair],
            # [DocumentDirection], [NoEncodingDialog], [XMLTransform])
            # As Document
            set docId [$docs -callnamedargs Open \
                             FileName $nativeName \
                             ConfirmConversions [Cawt TclBool false] \
                             ReadOnly [Cawt TclInt $readOnly]]
        }
        Cawt Destroy $docs
        return $docId
    }

    proc GetDocumentIdByIndex { appId index } {
        # Find a document by its index.
        #
        # appId - Identifier of the Word instance.
        # index - Index of the document to find.
        #
        # Returns the identifier of the found document.
        # If the index is out of bounds an error is thrown.
        #
        # See also: GetNumDocuments GetDocumentName

        set count [Word GetNumDocuments $appId]

        if { $index < 1 || $index > $count } {
            error "GetDocumentIdByIndex: Invalid index $index given."
        }
        return [$appId -with { Documents } Item $index]
    }

    proc GetDocumentId { componentId } {
        # Get the document identifier of a Word component.
        #
        # componentId - The identifier of a Word component.
        #
        # Word components having the Document property are ex. ranges, panes.

        return [$componentId Document]
    }

    proc GetDocumentName { docId } {
        # Get the name of a document.
        #
        # docId - Identifier of the document.
        #
        # Returns the name of the document (i.e. the full path name of the
        # corresponding Word file) as a string.

        return [$docId FullName]
    }

    proc AppendParagraph { docId { spaceAfter -1 } } {
        # Append a paragraph at the end of the document.
        #
        # docId      - Identifier of the document.
        # spaceAfter - Spacing after the range.
        #
        # The spacing value may be specified in a format acceptable by
        # procedure Cawt::ValueToPoints, i.e. centimeters, inches or points.
        #
        # Returns no value.
        #
        # See also: GetEndRange AddParagraph ::Cawt::ValueToPoints

        set endRange [Word GetEndRange $docId]
        $endRange InsertParagraphAfter
        set spaceAfter [Cawt ValueToPoints $spaceAfter]
        if { $spaceAfter >= 0 } {
            $endRange -with { ParagraphFormat } SpaceAfter $spaceAfter
        }
        return $endRange
    }

    proc AddParagraph { rangeId { spaceAfter -1 } } {
        # Add a new paragraph to a document.
        #
        # rangeId    - Identifier of the text range.
        # spaceAfter - Spacing after the range.
        #
        # The spacing value may be specified in a format acceptable by
        # procedure Cawt::ValueToPoints, i.e. centimeters, inches or points.
        #
        # Returns the new extended range.
        #
        # See also: AppendParagraph ::Cawt::ValueToPoints

        $rangeId InsertParagraphAfter
        set spaceAfter [Cawt ValueToPoints $spaceAfter]
        if { $spaceAfter >= 0 } {
            $rangeId -with { ParagraphFormat } SpaceAfter $spaceAfter
        }
        return $rangeId
    }

    proc InsertText { docId text { addParagraph false } { style wdStyleNormal } } {
        # Insert text in a Word document.
        #
        # docId        - Identifier of the document.
        # text         - Text string to be inserted.
        # addParagraph - Add a paragraph after the text.
        # style        - Value of enumeration type WdBuiltinStyle (see wordConst.tcl).
        #
        # The text string is inserted at the start of the document with given style.
        #
        # Returns the new text range.
        #
        # See also: AddText AppendText AddParagraph SetRangeStyle
        # InsertCaption InsertFile InsertImage InsertList

        set newRange [Word CreateRange $docId 0 0]
        $newRange InsertAfter $text
        if { $addParagraph } {
            $newRange InsertParagraphAfter
        }
        Word SetRangeStyle $newRange $style
        return $newRange
    }

    proc AppendText { docId text { addParagraph false } { style wdStyleNormal } } {
        # Append text to a Word document.
        #
        # docId        - Identifier of the document.
        # text         - Text string to be appended.
        # addParagraph - Add a paragraph after the text.
        # style        - Value of enumeration type WdBuiltinStyle (see wordConst.tcl).
        #
        # The text string is appended at the end of the document with given style.
        #
        # Returns the new text range.
        #
        # See also: GetEndRange AddText InsertText AppendParagraph SetRangeStyle

        set newRange [Word GetEndRange $docId]
        $newRange InsertAfter $text
        if { $addParagraph } {
            $newRange InsertParagraphAfter
        }
        Word SetRangeStyle $newRange $style
        return $newRange
    }

    proc AddText { rangeId text { addParagraph false } { style wdStyleNormal } } {
        # Add text to a Word document.
        #
        # rangeId      - Identifier of the text range.
        # text         - Text string to be added.
        # addParagraph - Add a paragraph after the text.
        # style        - Value of enumeration type WdBuiltinStyle (see wordConst.tcl).
        #
        # The text string is appended to the supplied text range with given style.
        #
        # Returns the new text range.
        #
        # See also: AddText InsertText AppendParagraph SetRangeStyle

        set newStartIndex [$rangeId End]
        set docId [Word GetDocumentId $rangeId]
        set newRange [Word CreateRange $docId $newStartIndex $newStartIndex]
        $newRange InsertAfter $text
        if { $addParagraph } {
            $newRange InsertParagraphAfter
        }
        Word SetRangeStyle $newRange $style
        Cawt Destroy $docId
        return $newRange
    }

    proc SetHyperlink { rangeId link { textDisplay "" } } {
        # Insert an external hyperlink into a Word document.
        #
        # rangeId     - Identifier of the text range.
        # link        - URL of the hyperlink.
        # textDisplay - Text to be displayed instead of the URL.
        #
        # # URL's are specified as strings:
        # file://myLinkedFile specifies a link to a local file.
        # http://myLinkedWebpage specifies a link to a web address.
        #
        # Returns no value.
        #
        # See also: SetHyperlinkToFile SetLinkToBookmark SetInternalHyperlink

        if { $textDisplay eq "" } {
            set textDisplay $link
        }

        set docId [Word GetDocumentId $rangeId]
        set hyperlinks [$docId Hyperlinks]
        # Add(Anchor As Object, [Address], [SubAddress], [ScreenTip],
        # [TextToDisplay], [Target]) As Hyperlink
        set hyperlink [$hyperlinks -callnamedargs Add \
                 Anchor  $rangeId \
                 Address $link \
                 TextToDisplay $textDisplay]
        Cawt Destroy $hyperlink
        Cawt Destroy $hyperlinks
        Cawt Destroy $docId
    }

    proc SetHyperlinkToFile { rangeId fileName { textDisplay "" } } {
        # Insert a hyperlink to a file into a Word document.
        #
        # rangeId     - Identifier of the text range.
        # fileName    - Path name of the linked file.
        # textDisplay - Text to be displayed instead of the file name.
        #
        # Returns no value.
        #
        # See also: SetHyperlink SetLinkToBookmark SetInternalHyperlink

        if { [file pathtype $fileName] eq "relative" } {
            set address [format "file:./%s" [file nativename $fileName]]
        } else {
            set address [format "file://%s" [file nativename $fileName]]
            set appId [Office GetApplicationId $rangeId]
            $appId -with { DefaultWebOptions } UpdateLinksOnSave [Cawt TclBool false]
            Cawt Destroy $appId
        }
        SetHyperlink $rangeId $address $textDisplay
    }

    proc SetInternalHyperlink { rangeId subAddress { textDisplay "" } } {
        # Insert an internal hyperlink into a Word document.
        #
        # rangeId     - Identifier of the text range.
        # subAddress  - Internal reference.
        # textDisplay - Text to be displayed instead of the URL.
        #
        # Returns no value.
        #
        # See also: SetLinkToBookmark SetHyperlink SetHyperlinkToFile

        if { $textDisplay eq "" } {
            set textDisplay $subAddress
        }

        set docId [Word GetDocumentId $rangeId]
        set hyperlinks [$docId Hyperlinks]
        # Add(Anchor As Object, [Address], [SubAddress], [ScreenTip],
        # [TextToDisplay], [Target]) As Hyperlink
        $hyperlinks -callnamedargs Add \
                 Anchor  $rangeId \
                 SubAddress $subAddress \
                 TextToDisplay $textDisplay
        Cawt Destroy $hyperlinks
        Cawt Destroy $docId
    }

    proc SetLinkToBookmark { rangeId bookmarkId { textDisplay "" } } {
        # Insert an internal link to a bookmark into a Word document.
        #
        # rangeId     - Identifier of the text range.
        # bookmarkId  - Identifier of the bookmark to link to.
        # textDisplay - Text to be displayed instead of the bookmark name.
        #
        # Returns no value.
        #
        # See also: AddBookmark GetBookmarkName SetHyperlink SetInternalHyperlink

        set bookmarkName [Word GetBookmarkName $bookmarkId]
        if { $textDisplay eq "" } {
            set textDisplay $bookmarkName
        }

        set docId [Word GetDocumentId $rangeId]
        set hyperlinks [$docId Hyperlinks]
        # Add(Anchor As Object, [Address], [SubAddress], [ScreenTip],
        # [TextToDisplay], [Target]) As Hyperlink
        $hyperlinks -callnamedargs Add \
                 Anchor        $rangeId \
                 Address       "" \
                 SubAddress    $bookmarkName \
                 TextToDisplay $textDisplay
        Cawt Destroy $hyperlinks
        Cawt Destroy $docId
    }

    proc InsertFile { rangeId fileName { pasteFormat "" } } {
        # Insert a file into a Word document.
        #
        # rangeId     - Identifier of the text range.
        # fileName    - Name of the file to insert.
        # pasteFormat - Value of enumeration type WdRecoveryType (see wordConst.tcl).
        #
        # Insert an external file a the text range identified by rangeId. If pasteFormat is
        # not specified or an empty string, the method InsertFile is used.
        # Otherwise the external file is opened in a new Word document, copied to the clipboard
        # and pasted into the text range. For pasting the PasteAndFormat method is used, so it is
        # possible to merge the new text from the external file into the Word document in different ways.
        #
        # Returns no value.
        #
        # See also: SetHyperlink InsertCaption InsertImage InsertList InsertText

        if { $pasteFormat ne "" } {
            set tmpAppId [Office GetApplicationId $rangeId]
            set tmpDocId [Word OpenDocument $tmpAppId [file nativename $fileName] false]
            set tmpRangeId [Word GetStartRange $tmpDocId]
            $tmpRangeId WholeStory
            $tmpRangeId Copy

            $rangeId PasteAndFormat [Word GetEnum $pasteFormat]

            # Workaround: Select a small portion of text and copy it to clipboard
            # to avoid an alert message regarding lots of data in clipboard.
            # Setting DisplayAlerts to false does not help here.
            set dummyRange [Word CreateRange $tmpDocId 0 1]
            $dummyRange Copy
            Cawt Destroy $dummyRange

            Word Close $tmpDocId
            Cawt Destroy $tmpRangeId
            Cawt Destroy $tmpDocId
            Cawt Destroy $tmpAppId
        } else {
            # InsertFile(FileName, Range, ConfirmConversions, Link, Attachment)
            $rangeId InsertFile [file nativename $fileName] \
                                "" \
                                [Cawt TclBool false] \
                                [Cawt TclBool false] \
                                [Cawt TclBool false]
        }
    }

    proc GetNumImages { docId } {
        # Return the number of images of a Word document.
        #
        # docId - Identifier of the document.
        #
        # Returns the number of images of a Word document.
        #
        # See also: InsertImage ReplaceImage GetImageId SetImageName

        return [$docId -with { InlineShapes } Count]
    }

    proc InsertImage { rangeId imgFileName { linkToFile false } { saveWithDoc true } } {
        # Insert an image into a range of a document.
        #
        # rangeId     - Identifier of the text range.
        # imgFileName - File name of the image (as absolute path).
        # linkToFile  - Insert a link to the image file.
        # saveWithDoc - Embed the image into the document.
        #
        # The file name of the image must be an absolute pathname. Use a
        # construct like [file join [pwd] "myImage.gif"] to insert
        # images from the current directory.
        #
        # Returns the identifier of the inserted image as an inline shape.
        #
        # See also: ScaleImage CropImage InsertFile InsertCaption InsertList InsertText

        if { ! $linkToFile && ! $saveWithDoc } {
            error "InsertImage: linkToFile and saveWithDoc are both set to false."
        }

	set fileName [file nativename $imgFileName]
        set shapeId [$rangeId -with { InlineShapes } AddPicture $fileName \
                  [Cawt TclInt $linkToFile] \
                  [Cawt TclInt $saveWithDoc]]
        return $shapeId
    }

    proc GetImageId { docId indexOrName } {
        # Find an image by its index or name.
        #
        # docId       - Identifier of the document.
        # indexOrName - Index or name of the image to find.
        #
        # Returns the identifier of the found image inline shape.
        #
        # Image names are supported since Word 2010.
        # If your Word version is older, an error is thrown.
        #
        # If the index is out of bounds or the specified name
        # does not exists, an error is thrown.
        #
        # See also: GetNumImages InsertImage ReplaceImage SetImageName

        variable wordVersion

        set count [Word::GetNumImages $docId]

        if { [string is integer -strict $indexOrName] } {
            set index [expr int($indexOrName)]
            if { $index < 1 || $index > $count } {
                error "GetImageId: Invalid index $index given."
            }
            return [$docId -with { InlineShapes } Item $index]
        } else {
            if { $wordVersion < 14.0 } {
                error "Image names available only in Word 2010 or newer. Running [Word GetVersion $docId true]."
            }
            for { set i 1 } { $i <= $count } { incr i } {
                set imgId [$docId -with { InlineShapes } Item $i]
                if { [Word::GetImageName $imgId] eq $indexOrName } {
                    return $imgId
                }
                Cawt Destroy $imgId
            }
            error "GetImageId: No image with name \"$indexOrName\" found."
        }
    }

    proc ReplaceImage { shapeId imgFileName args } {
        # Replace an existing image.
        #
        # shapeId     - Identifier of the image inline shape.
        # imgFileName - File name of the new image (as absolute path).
        # args        - List of key value pairs specifying the replacement
        #               options and its values.
        #
        # Option keys:
        #
        # -keepsize true|false
        #     Keep original image size. Default value is false.
        #
        # The file name of the image must be an absolute pathname. Use a
        # construct like [file join [pwd] "myImage.gif"] to insert
        # images from the current directory.
        #
        # See also: InsertImage GetNumImages SetImageName

        set opts [dict create \
            -keepsize false \
        ]
        foreach { key value } $args {
            if { [dict exists $opts $key] } {
                dict set opts $key $value
            } else {
                error "ReplaceImage: Unknown option \"$key\" specified"
            }
        }

        set w [$shapeId Width]
        set h [$shapeId Height]

        set rangeId [$shapeId Range]
        $shapeId Delete
        Cawt Destroy $shapeId

        set fileName [file nativename $imgFileName]
        set newShapeId [$rangeId -with { InlineShapes } AddPicture $fileName]

        if { [dict get $opts "-keepsize"] } {
            $newShapeId Width  $w
            $newShapeId Height $h
        }
        return $newShapeId
    }

    proc GetImageName { shapeId } {
        # Return the name of an image.
        #
        # shapeId - Identifier of the image inline shape.
        #
        # Returns the name of an image.
        #
        # Image names are supported since Word 2010.
        # If your Word version is older, an error is thrown.
        #
        # See also: GetNumImages SetImageName InsertImage GetImageId

        variable wordVersion

        if { $wordVersion < 14.0 } {
            error "Image names available only in Word 2010 or newer. Running [Word GetVersion $shapeId true]."
        }
        return [$shapeId Title]
    }

    proc SetImageName { shapeId name } {
        # Set the name of an image.
        #
        # shapeId - Identifier of the image inline shape.
        #
        # No return value.
        #
        # Image names are supported since Word 2010.
        # If your Word version is older, an error is thrown.
        #
        # See also: GetNumImages GetImageName InsertImage GetImageId

        variable wordVersion

        if { $wordVersion < 14.0 } {
            error "Image names available only in Word 2010 or newer. Running [Word GetVersion $shapeId true]."
        }
        $shapeId Title $name
    }

    proc ScaleImage { shapeId scaleWidth scaleHeight } {
        # Scale an image.
        #
        # shapeId     - Identifier of the image inline shape.
        # scaleWidth  - Horizontal scale factor.
        # scaleHeight - Vertical scale factor.
        #
        # The scale factors are floating point values. 1.0 means no scaling.
        #
        # Returns no value.
        #
        # See also: GetNumImages InsertImage ReplaceImage CropImage

        $shapeId LockAspectRatio [Cawt TclInt false]
        $shapeId ScaleWidth  [expr { 100.0 * double($scaleWidth) }]
        $shapeId ScaleHeight [expr { 100.0 * double($scaleHeight) }]
    }

    proc CropImage { shapeId { cropBottom 0.0 } { cropTop 0.0 } { cropLeft 0.0 } { cropRight 0.0 } } {
        # Crop an image at the four borders.
        #
        # shapeId    - Identifier of the image inline shape.
        # cropBottom - Crop amount at the bottom border.
        # cropTop    - Crop amount at the top border.
        # cropLeft   - Crop amount at the left border.
        # cropRight  - Crop amount at the right border.
        #
        # The crop values may be specified in a format acceptable by
        # procedure Cawt::ValueToPoints, i.e. centimeters, inches or points.
        #
        # Returns no value.
        #
        # See also: GetNumImages InsertImage ScaleImage ::Cawt::ValueToPoints

        $shapeId -with { PictureFormat } CropBottom [Cawt ValueToPoints $cropBottom]
        $shapeId -with { PictureFormat } CropTop    [Cawt ValueToPoints $cropTop]
        $shapeId -with { PictureFormat } CropLeft   [Cawt ValueToPoints $cropLeft]
        $shapeId -with { PictureFormat } CropRight  [Cawt ValueToPoints $cropRight]
    }

    proc InsertCaption { rangeId labelId text { pos wdCaptionPositionBelow } } {
        # Insert a caption into a range of a document.
        #
        # rangeId - Identifier of the text range.
        # labelId - Value of enumeration type WdCaptionLabelID.
        #           Possible values: wdCaptionEquation, wdCaptionFigure, wdCaptionTable
        # text    - Text of the caption.
        # pos     - Value of enumeration type WdCaptionPosition (see wordConst.tcl).
        #
        # Returns the new extended range.
        #
        # See also: ConfigureCaption InsertFile InsertImage InsertList InsertText

        $rangeId InsertCaption [Word GetEnum $labelId] $text "" [Word GetEnum $pos] 0
        return $rangeId
    }

    proc ConfigureCaption { appId labelId chapterStyleLevel { includeChapterNumber true } \
                            { numberStyle wdCaptionNumberStyleArabic } \
                            { separator wdSeparatorHyphen } } {
        # Configure style of a caption type identified by its label identifier.
        #
        # appId                - Identifier of the Word instance.
        # labelId              - Value of enumeration type WdCaptionLabelID.
        #                        Possible values: wdCaptionEquation, wdCaptionFigure, wdCaptionTable
        # chapterStyleLevel    - 1 corresponds to Heading1, 2 corresponds to Heading2, ...
        # includeChapterNumber - Flag indicating whether to include the chapter number.
        # numberStyle          - Value of enumeration type WdCaptionNumberStyle (see wordConst.tcl).
        # separator            - Value of enumeration type WdSeparatorType (see wordConst.tcl).
        #
        # Returns no value.
        #
        # See also: InsertCaption

        set captionItem [$appId -with { CaptionLabels } Item [Word GetEnum $labelId]]
        $captionItem ChapterStyleLevel    [expr $chapterStyleLevel]
        $captionItem IncludeChapterNumber [Cawt TclBool $includeChapterNumber]
        $captionItem NumberStyle          [Word GetEnum $numberStyle]
        $captionItem Separator            [Word GetEnum $separator]
    }

    proc AddTable { rangeId numRows numCols { spaceAfter -1 } } {
        # Add a new table in a text range.
        #
        # rangeId    - Identifier of the text range.
        # numRows    - Number of rows of the new table.
        # numCols    - Number of columns of the new table.
        # spaceAfter - Spacing in points after the table.
        #
        # The spacing value may be specified in a format acceptable by
        # procedure Cawt::ValueToPoints, i.e. centimeters, inches or points.
        #
        # Returns the identifier of the new table.
        #
        # See also: GetNumRows GetNumColumns ::Cawt::ValueToPoints

        set docId [Word GetDocumentId $rangeId]
        set tableId [$docId -with { Tables } Add $rangeId $numRows $numCols]
        set spaceAfter [Cawt ValueToPoints $spaceAfter]
        if { $spaceAfter >= 0 } {
            $tableId -with { Range ParagraphFormat } SpaceAfter $spaceAfter
        }
        Cawt Destroy $docId
        return $tableId
    }

    proc GetNumTables { docId } {
        # Return the number of tables of a Word document.
        #
        # docId - Identifier of the document.
        #
        # Returns the number of tables of a Word document.
        #
        # See also: AddTable GetNumRows GetNumColumns

        return [$docId -with { Tables } Count]
    }

    proc GetTableIdByIndex { docId index } {
        # Find a table by its index.
        #
        # docId - Identifier of the document.
        # index - Index of the table to find.
        #
        # Returns the identifier of the found table.
        # If the index is out of bounds an error is thrown.
        #
        # See also: GetNumTables

        set count [Word GetNumTables $docId]

        if { $index < 1 || $index > $count } {
            error "GetTableIdByIndex: Invalid index $index given."
        }
        return [$docId -with { Tables } Item $index]
    }

    proc SetTableBorderLineStyle { tableId \
              { outsideLineStyle wdLineStyleSingle } \
              { insideLineStyle  wdLineStyleSingle } } {
        # Set the border line styles of a Word table.
        #
        # tableId          - Identifier of the Word table.
        # outsideLineStyle - Outside border style.
        # insideLineStyle  - Inside border style.
        #
        # The values of "outsideLineStyle" and "insideLineStyle" must
        # be of enumeration type WdLineStyle (see WordConst.tcl).
        #
        # See also: AddTable SetTableBorderLineWidth

        set border [$tableId Borders]
        $border OutsideLineStyle [Word GetEnum $outsideLineStyle]
        $border InsideLineStyle  [Word GetEnum $insideLineStyle]
        Cawt Destroy $border
    }

    proc SetTableBorderLineWidth { tableId \
              { outsideLineWidth wdLineWidth050pt } \
              { insideLineWidth  wdLineWidth050pt } } {
        # Set the border line widths of a Word table.
        #
        # tableId          - Identifier of the Word table.
        # outsideLineWidth - Outside border line width.
        # insideLineWidth  - Inside border line width.
        #
        # The values of "outsideLineWidth" and "insideLineWidth" must
        # be of enumeration type WdLineWidth (see WordConst.tcl).
        #
        # See also: AddTable SetTableBorderLineStyle

        set border [$tableId Borders]
        $border OutsideLineWidth [Word GetEnum $outsideLineWidth]
        $border InsideLineWidth  [Word GetEnum $insideLineWidth]
        Cawt Destroy $border
    }

    proc GetNumRows { tableId } {
        # Return the number of rows of a Word table.
        #
        # tableId - Identifier of the Word table.
        #
        # Returns the number of rows of a Word table.
        #
        # See also: GetNumColumns GetNumTables

        return [$tableId -with { Rows } Count]
    }

    proc GetNumColumns { tableId } {
        # Return the number of columns of a Word table.
        #
        # tableId - Identifier of the Word table.
        #
        # Returns the number of columns of a Word table.
        #
        # See also: GetNumRows GetNumTables

        return [$tableId -with { Columns } Count]
    }

    proc AddRow { tableId { beforeRowNum end } { numRows 1 } } {
        # Add one or more rows to a table.
        #
        # tableId      - Identifier of the Word table.
        # beforeRowNum - Insertion row number. Row numbering starts with 1.
        #                The new row is inserted before the given row number.
        #                If not specified or "end", the new row is appended at
        #                the end.
        # numRows      - Number of rows to be inserted.
        #
        # Returns no value.
        #
        # See also: DeleteRow GetNumRows

        Cawt PushComObjects

        set rowsId [$tableId Rows]
        if { $beforeRowNum eq "end" } {
            for { set r 1 } { $r <= $numRows } {incr r } {
                $rowsId Add
            }
        } else {
            if { $beforeRowNum < 1 || $beforeRowNum > [Word GetNumRows $tableId] } {
                error "AddRow: Invalid row number $beforeRowNum given."
            }
            set rowId [$tableId -with { Rows } Item $beforeRowNum]
            for { set r 1 } { $r <= $numRows } {incr r } {
                $rowsId Add $rowId
            }
        }

        Cawt PopComObjects
    }

    proc DeleteRow { tableId { row end } } {
        # Delete a row of a table.
        #
        # tableId - Identifier of the Word table.
        # row     - Row number. Row numbering starts with 1.
        #           If not specified or "end", the last row
        #           is deleted.
        #
        # Returns no value.
        #
        # See also: AddRow GetNumRows

        if { $row eq "end" } {
            set row [Word GetNumRows $tableId]
        } else {
            if { $row < 1 || $row > [Word GetNumRows $tableId] } {
                error "DeleteRow: Invalid row number $row given."
            }
        }
        Cawt PushComObjects
        set rowsId [$tableId Rows]
        set rowId  [$tableId -with { Rows } Item $row]
        $rowId Delete
        Cawt PopComObjects
    }

    proc GetCellRange { tableId row col } {
        # Return a cell of a Word table as a range.
        #
        # tableId - Identifier of the Word table.
        # row     - Row number. Row numbering starts with 1.
        # col     - Column number. Column numbering starts with 1.
        #
        # Returns a range consisting of 1 cell of a Word table.
        #
        # See also: GetRowRange GetColumnRange

        set cellId  [$tableId Cell $row $col]
        set rangeId [$cellId Range]
        Cawt Destroy $cellId
        return $rangeId
    }

    proc GetRowRange { tableId row } {
        # Return a row of a Word table as a range.
        #
        # tableId - Identifier of the Word table.
        # row     - Row number. Row numbering starts with 1.
        #
        # Returns a range consisting of all cells of a row.
        #
        # See also: GetCellRange GetColumnRange

        set rowId [$tableId -with { Rows } Item $row]
        set rangeId [$rowId Range]
        Cawt Destroy $rowId
        return $rangeId
    }

    proc GetColumnRange { tableId col } {
        # Return a column of a Word table as a selection.
        #
        # tableId - Identifier of the Word table.
        # col     - Column number. Column numbering starts with 1.
        #
        # Returns a selection consisting of all cells of a column.
        # Note, that a selection is returned and not a range,
        # because columns do not have a range property.
        #
        # See also: GetCellRange GetRowRange

        set colId [$tableId -with { Columns } Item $col]
        $colId Select
        set selectId [$tableId -with { Application } Selection]
        $selectId SelectColumn
        Cawt Destroy $colId
        return $selectId
    }

    proc SetCellValue { tableId row col val } {
        # Set the value of a Word table cell.
        #
        # tableId - Identifier of the Word table.
        # row     - Row number. Row numbering starts with 1.
        # col     - Column number. Column numbering starts with 1.
        # val     - String value of the cell.
        #
        # Returns no value.
        #
        # See also: GetCellValue SetRowValues SetMatrixValues

        set rangeId [Word GetCellRange $tableId $row $col]
        $rangeId Text $val
        Cawt Destroy $rangeId
    }

    proc IsValidCell { tableId row col } {
        # Check, if a Word table cell is valid.
        #
        # tableId - Identifier of the Word table.
        # row     - Row number. Row numbering starts with 1.
        # col     - Column number. Column numbering starts with 1.
        #
        # Return true, if the cell is valid, otherwise false.
        #
        # See also: GetCellValue

        set retVal [catch { $tableId Cell $row $col } errMsg]
        if { $retVal == 0 } {
            return true
        } else {
            return false
        }
    }

    proc GetCellValue { tableId row col } {
        # Return the value of a Word table cell.
        #
        # tableId - Identifier of the Word table.
        # row     - Row number. Row numbering starts with 1.
        # col     - Column number. Column numbering starts with 1.
        #
        # Returns the value of the specified cell as a string.
        #
        # See also: SetCellValue IsValidCell

        set rangeId [Word GetCellRange $tableId $row $col]
        set val [Word TrimString [$rangeId Text]]
        Cawt Destroy $rangeId
        return $val
    }

    proc SetRowValues { tableId row valList { startCol 1 } { numVals 0 } } {
        # Insert row values from a Tcl list.
        #
        # tableId  - Identifier of the Word table.
        # row      - Row number. Row numbering starts with 1.
        # valList  - List of values to be inserted.
        # startCol - Column number of insertion start. Column numbering starts with 1.
        # numVals  - Negative or zero: All list values are inserted.
        #            Positive: numVals columns are filled with the list values
        #            (starting at list index 0).
        #
        # Returns no value. If valList is an empty list, an error is thrown.
        #
        # See also: GetRowValues SetColumnValues SetCellValue

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

    proc GetRowValues { tableId row { startCol 1 } { numVals 0 } } {
        # Return row values of a Word table as a Tcl list.
        #
        # tableId  - Identifier of the Word table.
        # row      - Row number. Row numbering starts with 1.
        # startCol - Column number of start. Column numbering starts with 1.
        # numVals  - Negative or zero: All available row values are returned.
        #            Positive: Only numVals values of the row are returned.
        #
        # Returns the values of the specified row or row range as a Tcl list.
        #
        # See also: SetRowValues GetColumnValues GetCellValue

        if { $numVals <= 0 } {
            set len [Word GetNumColumns $tableId]
        } else {
            set len $numVals
        }
        set valList [list]
        set col $startCol
        set ind 0
        while { $ind < $len } {
            set val [Word GetCellValue $tableId $row $col]
            lappend valList $val
            incr ind
            incr col
        }
        return $valList
    }

    proc SetColumnWidth { tableId col width } {
        # Set the width of a table column.
        #
        # tableId - Identifier of the Word table.
        # col     - Column number. Column numbering starts with 1.
        # width   - Column width.
        #
        # The size value may be specified in a format acceptable by
        # procedure Cawt::ValueToPoints, i.e. centimeters, inches or points.
        #
        # Returns no value.
        #
        # See also: SetColumnsWidth ::Cawt::ValueToPoints 

        set colId [$tableId -with { Columns } Item $col]
        $colId Width [Cawt ValueToPoints $width]
        Cawt Destroy $colId
    }

    proc SetColumnsWidth { tableId startCol endCol width } {
        # Set the width of a range of table columns.
        #
        # tableId  - Identifier of the Word table.
        # startCol - Range start column number. Column numbering starts with 1.
        # endCol   - Range end column number. Column numbering starts with 1.
        # width    - Column width.
        #
        # The size value may be specified in a format acceptable by
        # procedure Cawt::ValueToPoints, i.e. centimeters, inches or points.
        #
        # Returns no value.
        #
        # See also: SetColumnWidth ::Cawt::ValueToPoints

        for { set c $startCol } { $c <= $endCol } { incr c } {
            SetColumnWidth $tableId $c $width
        }
    }

    proc SetColumnValues { tableId col valList { startRow 1 } { numVals 0 } } {
        # Insert column values into a Word table.
        #
        # tableId  - Identifier of the Word table.
        # col      - Column number. Column numbering starts with 1.
        # valList  - List of values to be inserted.
        # startRow - Row number of insertion start. Row numbering starts with 1.
        # numVals  - Negative or zero: All list values are inserted.
        #            Positive: numVals rows are filled with the list values
        #            (starting at list index 0).
        #
        # Returns no value.
        #
        # See also: GetColumnValues SetRowValues SetCellValue

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

    proc GetColumnValues { tableId col { startRow 1 } { numVals 0 } } {
        # Return column values of a Word table as a Tcl list.
        #
        # tableId  - Identifier of the Word table.
        # col      - Column number. Column numbering starts with 1.
        # startRow - Row number of start. Row numbering starts with 1.
        # numVals  - Negative or zero: All available column values are returned.
        #            Positive: Only numVals values of the column are returned.
        #
        # Returns the values of the specified column or column range as a Tcl list.
        #
        # See also: SetColumnValues GetRowValues GetCellValue

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
