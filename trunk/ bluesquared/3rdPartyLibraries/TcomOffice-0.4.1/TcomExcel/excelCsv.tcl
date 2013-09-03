# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

package provide tcomexcel 0.4.1

namespace eval ::Csv {

    variable sepChar
    variable numHeadLines

    proc _matchList { l exp { caseSensitive 0 } { useWildCard 1 } } {
        # Quote all regexp special chars: "*+.?()|[]\"
        # if useWildCard is set, we use * as a wildcard for 
        # 0 and more characters, like Unix shell's do.
        if { $useWildCard } {
            regsub -all {\+|\.|\?|\(|\)|\||\[|\]|\\} $exp {\\&} tmpExp1
            regsub -all {\*} $tmpExp1 {.*} tmpExp
        } else {
            regsub -all {\*|\+|\.|\?|\(|\)|\||\[|\]|\\} $exp {\\&} tmpExp
        }

        set elemNo 0
        foreach elem $l {
            if { $caseSensitive } {
                set found [regexp $tmpExp $elem]
            } else {
                set found [regexp -nocase $tmpExp $elem]
            }
            if { $found } {
                return $elemNo
            }
            incr elemNo
        }
        return -1
    }

    proc GetSeparatorChar {} {
        variable sepChar
    
        return $sepChar
    }

    proc SetSeparatorChar { { separatorChar ";" } } {
        variable sepChar

        set sepChar $separatorChar
    }

    proc GetNumHeaderLines {} {
        variable numHeadLines

        return $numHeadLines
    }

    proc SetNumHeaderLines { { numHeaderLines 0 } } {
        variable numHeadLines

        set numHeadLines $numHeaderLines
    }

    proc _Init {} {
        ::Csv::SetSeparatorChar
        ::Csv::SetNumHeaderLines
    }

    proc Line2List { lineStr { mapFloatPoint false } } {
        variable sepChar

        set tmpList {}
        set wordCount 1
        set combine 0

        set wordList [split $lineStr $sepChar]

        foreach word $wordList {
            if { $mapFloatPoint } {
                set word [string map {"," "."} $word]
            }
            set len [string length $word]
            if { [string compare [string index $word end] "\""] == 0 } {
                set endQuote 1
            } else {
                set endQuote 0
            }
            if { [string compare [string index $word 0] "\""] == 0 } {
                set begQuote 1
            } else {
                set begQuote 0
            }
        
            # puts "Word=<$word> (Combine=$combine / Length=[string length $word])"
            if { $begQuote && $endQuote && ($len % 2 == 1) } {
                set onlyQuotes [regexp {^[\"]+$} $word]
                # puts "Odd: Len = $len onlyQuotes=$onlyQuotes"
                if { $onlyQuotes } {
                    if { $combine } {
                        set begQuote 0
                    } else {
                        set endQuote 0
                    }
                }
            }
            if { $begQuote && $endQuote && ($len == 2) } {
                set begQuote 0
                set endQuote 0
            }

            if { $begQuote && $endQuote } {
                lappend tmpList [string map {\"\" \"} [string range $word 1 end-1]]
                set combine 0
                incr wordCount
            } elseif { !$begQuote && $endQuote } {
                append tmpWord [string range $word 0 end-1]
                lappend tmpList [string map {\"\" \"} $tmpWord]
                set combine 0
                incr wordCount
            } elseif { $begQuote && !$endQuote } {
                set tmpWord [string range $word 1 end]
                append tmpWord $sepChar
                set combine 1
            } else {
                if { $combine } {
                    append tmpWord  [string map {\"\" \"} $word]
                    append tmpWord $sepChar
                } else {
                   lappend tmpList [string map {\"\" \"} $word]
                   set combine 0
                   incr wordCount
                }
            }
        }
        return $tmpList
    }

    proc List2Line { lineList { mapFloatPoint false } } {
        variable sepChar

        set lineStr ""
        set len1 [expr [llength $lineList] -1]
        set curVal 0
        foreach val $lineList {
            set tmp [string map {\n\r \ } $val]
            if { [string first $sepChar $tmp] >= 0 || \
                 [string first "\"" $tmp] >= 0 } {
                regsub -all {"} $tmp {""} tmp
                set tmp [format "\"%s\"" $tmp]
            }
            if { $mapFloatPoint } {
                set tmp [string map {"." ","} $tmp]
            }
            if { $curVal < $len1 } {
                append lineStr $tmp $sepChar
            } else {
                append lineStr $tmp
            }
            incr curVal
        }
        return $lineStr
    }

    proc List2Csv { matrixList { mapFloatPoint false } } {
        foreach rowList $matrixList {
            append str [::Csv::List2Line $rowList $mapFloatPoint ]
            append str "\n"
        }
        return [string range $str 0 end-1]
    }

    proc Csv2List { csvString { mapFloatPoint false } } {
        foreach line [split [string trim $csvString '\0'] "\n"] {
            set line [string trim $line "\r"]
            if { $line eq "" } {
                break
            }
            lappend matrixList [::Csv::Line2List $line $mapFloatPoint]
        }
        return $matrixList
    }

    # The representation of the CSV file as a list of lists.
    proc Read { csvFile { exp "" } { caseSensitive 0 } { useWildCard 1 } } {
        variable sepChar
        variable numHeadLines

        set csvList {}
        set lineCount 1
    
        set catchVal [catch {open $csvFile r} fp] 
        if { $catchVal != 0 } {  
            error "Could not open file \"$csvFile\" for reading."
        }
    
        while { [gets $fp line] >= 0 } {
            if { $lineCount <= $numHeadLines } {
                # We are still reading a header line
                incr lineCount
                continue
            }
    
            set tmpList [::Csv::Line2List $line]
    
            if { [string compare $exp ""] != 0 && \
                [::Csv::_matchList $tmpList $exp $caseSensitive $useWildCard] < 0 } {
                continue
            }
            lappend csvList $tmpList
        }
    
        close $fp
        return $csvList
    }

    proc Write { csvList csvFile } {

        set catchVal [catch {open $csvFile w} fp] 
        if { $catchVal != 0 } {  
            error "Could not open file \"$csvFile\" for writing."
        }
    
        foreach line $csvList {
            puts $fp [::Csv::List2Line $line]
        }
        close $fp
    }
}

::Csv::_Init
