# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

set auto_path [linsert $auto_path 0 [file join [pwd] ".."]]

package require tcomword

# Open new Word instance and show the application window.
set appId [::Word::Open true]

# Delete Word file from previous test run.
file mkdir testOut
set wordFile [file join [pwd] "testOut" "WordFind"]
append wordFile [::Word::GetExtString $appId]
file delete -force $wordFile

set inFile [file join [pwd] "testOut" "WordText"]
append inFile [::Word::GetExtString $appId]

# Open an existing document.
set inDocId  [::Word::OpenDocument $appId $inFile]
# Open same document a second time. Should return same identifier.
set inDocId2 [::Word::OpenDocument $appId $inFile]
# TODO
#if { $inDocId != $inDocId2 } {
#    puts "Error: Document Identifiers not identical ($inDocId vs. $inDocId2)"
#}

set range [::Word::GetStartRange $inDocId]
if { [::Word::GetRangeStart $range] != 0 || \
     [::Word::GetRangeEnd   $range] != 0 } {
    puts "Error: Start range not correct"
    ::Word::PrintRange $range
}
if { ! [::Word::FindString $range "italic"] } {
    puts "Error: Word \"italic\" not listed in Word-Document"
}

set range [::Word::ExtendRange $inDocId $range 0 500]
::Word::PrintRange $range "Extended range:"
::Word::ReplaceString $range "italic" "yellow" "one"

set range [::Word::ExtendRange $inDocId $range 0 end]
::Word::PrintRange $range "Extended range:"
::Word::ReplaceString $range "lines" "rows" "all"

::Word::RecursiveChange [::Word::GetStartRange $inDocId] "paragraph" \
                        ::Word::SetRangeFontItalic true
# TODO This does not work
#::Word::RecursiveChange [::Word::GetStartRange $inDocId] "paragraph" \
#                        ::Word::SetRangeHighlightColorByEnum $::Word::wdYellow

# Save document as Word file.
puts "Saving as Word file: $wordFile"
::Word::SaveAs $inDocId $wordFile

# Get number of open documents.
set numDocs [::Word::GetNumDocuments $appId]
puts "Number of open documents: $numDocs"

set newDocId [::Word::OpenDocument $appId $inFile]
set numDocs [::Word::GetNumDocuments $appId]
puts "Number of open documents: $numDocs"
for { set i 1 } { $i <= $numDocs } { incr i } {
    set docId [::Word::GetDocumentId $appId $i]
    puts "File-$i: [::Word::GetDocumentName $docId]"
}
::Word::Close $newDocId

if { [lindex $argv 0] eq "auto" } {
    ::Word::Quit $appId
    exit 0
}
