# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

set auto_path [linsert $auto_path 0 [file join [pwd] ".."]]

package require tcomword

# Open new Word instance and show the application window.
set appId [::Word::OpenNew true]

# Delete Word file from previous test run.
file mkdir testOut
set wordFile [file join [pwd] "testOut" "WordText"]
append wordFile [::Word::GetExtString $appId]
file delete -force $wordFile

set msg1 "This is a italic line of text in italic."
for { set i 0 } { $i < 20 } { incr i } {
    append msg2 "This is a large paragraph in bold. "
}

# Create a new document.
set docId [::Word::AddDocument $appId]

# Insert a short piece of text as one paragraph.
set range1 [::Word::AppendText $docId $msg1]
::Word::SetRangeFontItalic $range1 true
::Word::SetRangeHighlightColorByEnum $range1 $::Word::wdYellow
::Word::AppendParagraph $docId

# Insert a longer piece of text as one paragraph.
set range2 [::Word::AppendText $docId $msg2]
::Word::SetRangeFontBold $range2 true
::Word::AppendParagraph $docId

# Insert lines of text. When we get to 7 inches from top of the
# document, insert a hard page break.
# It demonstrates the ability to mix TcomWord and Tcom freely.
set pos [::Word::InchesToPoints 7]
while { true } {
    ::Word::AppendText $docId "More lines of text."
    ::Word::AppendParagraph $docId
    set endRange [::Word::GetEndRange $docId]
    if { $pos < [$endRange Information $::Word::wdVerticalPositionRelativeToPage] } {
        break
    }
}
$endRange Collapse $::Word::wdCollapseEnd
$endRange InsertBreak [expr int($::Word::wdPageBreak)]
$endRange Collapse $::Word::wdCollapseEnd
set rangeId [::Word::AppendText $docId "This is page 2."]
::Word::AddParagraph $rangeId "after"
set rangeId [::Word::AppendText $docId "There must be two paragraphs before this line."]
::Word::AddParagraph $rangeId "before"

::Word::SetRangeStart $docId $rangeId "begin"
::Word::SetRangeEnd $docId $rangeId 5
$rangeId Select
::Word::PrintRange $rangeId "SetRange and selection: "

# Save document as Word file.
puts "Saving as Word file: $wordFile"
::Word::SaveAs $docId $wordFile

if { [lindex $argv 0] eq "auto" } {
    ::Word::Quit $appId
    exit 0
}
