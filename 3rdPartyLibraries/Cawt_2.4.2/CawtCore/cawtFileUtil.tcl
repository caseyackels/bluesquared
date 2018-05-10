# Copyright: 2007-2018 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

namespace eval Cawt {

    namespace ensemble create

    namespace export IsUnicodeFile
    namespace export SplitFile ConcatFiles

    proc IsUnicodeFile { fileName } {
        # Check, if a file is encode in Unicode.
        #
        # fileName - File to check encoding.
        #
        # Unicode encoding is detected by checking the BOM.
        # If the first two bytes are FF FE, the file seems to be
        # a Unicode file.
        #
        # Returns true, if file is encode in Unicode, otherwise false.
        #
        # See also:

        set catchVal [catch {open $fileName r} fp]
        if { $catchVal != 0 } {
            error "Could not open file \"$fileName\" for reading."
        }
        fconfigure $fp -translation binary
        set bom [read $fp 2]
        close $fp
        binary scan $bom "cc" bom1 bom2
        set bom1 [expr {$bom1 & 0xFF}]
        set bom2 [expr {$bom2 & 0xFF}]
        if { [format "%02X%02X" $bom1 $bom2] eq "FFFE" } {
            return true
        }
        return false
    }

    proc SplitFile { inFile { maxFileSize 2048 } { outFilePrefix "" } } {
        set catchVal [catch {open $inFile r} inFp]
        if { $catchVal != 0 } {
            error "Could not open file \"$inFile\" for reading."
        }
        fconfigure $inFp -translation binary

        if { $outFilePrefix ne "" } {
            set outFileName $outFilePrefix
        } else {
            set outFileName $inFile
        }
        set count 1
        set fileList [list]
        while { 1 } {
            set str [read $inFp $maxFileSize]
            if { $str ne "" } {
                set fileName [format "%s-%05d" $outFileName $count]
                set catchVal [catch {open $fileName w} outFp]
                if { $catchVal != 0 } {
                    close $inFp
                    error "Could not open file \"$fileName\" for writing."
                }
                fconfigure $outFp -translation binary
                puts -nonewline $outFp $str
                close $outFp
                lappend fileList $fileName
                incr count
            }
            if { [eof $inFp] } {
                break
            }
        }
        close $inFp
        return $fileList
    }

    proc ConcatFiles { outFile args } {
        set catchVal [catch {open $outFile w} outFp]
        if { $catchVal != 0 } {
            close $inFp
            error "Could not open file \"$outFile\" for writing."
        }
        fconfigure $outFp -translation binary

        foreach fileName $args {
            set catchVal [catch {open $fileName r} fp]
            if { $catchVal != 0 } {
                close $outFp
                error "Could not open file \"$fileName\" for reading."
            }
            fconfigure $fp -translation binary
            fcopy $fp $outFp
            close $fp
        }
        close $outFp
    }
}
