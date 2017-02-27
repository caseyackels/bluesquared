# From the wiki
# http://wiki.tcl.tk/1803

namespace eval date {
        #set defaultFont {Arial 10 normal}
        set defaultFont {Helvetica 12 bold}
        #option add *Button.padX 0
        #option add *Button.padY 0
        #option add *Button.font $defaultFont
        #option add *Entry.font $defaultFont
        variable canvasFont $defaultFont
        #variable canvasHighlight {Arial 11 bold}
        #variable canvasHeader {Arial 14 bold}
        variable canvasHighlight {Helvetica 11 bold}
        variable canvasHeader {Helvetica 14 bold}
        variable w .cal
    
 proc choose {bpath} {
        variable month; variable year; variable date
        variable canvas; variable res
        variable day
        set year [clock format [clock seconds] -format "%Y"]
        scan [clock format [clock seconds] -format "%m"] %d month
        scan [clock format [clock seconds] -format "%d"] %d day
                set w $date::w
        catch {destroy $w}
        toplevel $w -bg white
        wm transient $w $bpath
        
        set sx [expr [winfo rootx $bpath] + 15]
                set sy [expr [winfo rooty $bpath] + 5]
                wm geometry $w "+$sx+$sy"
        
        wm title $w "Choose Date:"
        
        frame $w.1
        entry $w.1.1 -textvar date::month -width 3 -just center
        button $w.1.2 -text "<" -command {date::adjust -1 0}
        button $w.1.3 -text ">" -command {date::adjust 1 0}
        entry $w.1.4 -textvar date::year -width 4 -just center
        button $w.1.5 -text "<" -command {date::adjust 0 -1}
        button $w.1.6 -text ">" -command {date::adjust 0 1}
        #eval pack [winfo children $w.1] -side left -fill both
        eval pack $w.1.2 $w.1.1 $w.1.3 $w.1.5 $w.1.4 $w.1.6 -side left -fill both
        set canvas [canvas $w.2 -width 160 -height 160 -bg white]
        

 # Uncomment the following to include additional controls
 #         frame $w.3
 #         entry $w.3.1 -textvar date::date -width 10
 #         button $w.3.2 -text OK -command {set date::res $date::date}
 #         button $w.3.3 -text Cancel -command {set date::res {}}
 #         eval pack [winfo children $w.3] -side left
        eval pack [winfo children $w]
        display
        vwait ::date::res
        destroy $w
        set res
}
    
proc adjust {dmonth dyear} {
        variable month; variable year; variable day
        set year  [expr {$year+$dyear}]
        set month [expr {$month+$dmonth}]
        if {$month>12} {set month 1; incr year}
        if {$month<1} {set month 12; incr year -1}
        if {[numberofdays $month $year]<$day} {
            set day [numberofdays $month $year]
        }
        display
}
    
proc display {} {
        variable month; variable year
        variable date; variable day
        variable canvas
        $canvas delete all
        set x0 20; set x $x0; set y 20
        set dx 20; set dy 20
        set xmax [expr {$x0+$dx*6}]
        foreach i {S M T W T F S} {
            $canvas create text $x $y -text $i -fill blue -font $date::canvasHeader
                        $canvas create rectangle [expr $x-10] [expr $y-10] [expr $x+10] [expr $dy+10] -fill grey90 -tags boxes
            incr x $dx
        }
        scan [clock format [clock scan $month/1/$year] \
                -format %w] %d weekday
        set x [expr {$x0+$weekday*$dx}]
        incr y $dy
        set nmax [numberofdays $month $year]
        for {set d 1} {$d<=$nmax} {incr d} {
            set id [$canvas create text $x $y -text $d -font $date::canvasFont -tag day]
             switch $x {
                20 -
                140 {set fillColor pink1}
                default {set fillColor bisque1}
            }
                        $canvas create rectangle [expr $x-10] [expr $y-10] [expr $x+10] [expr $y+10] -fill $fillColor -tags boxes
            if {$d==$day} {$canvas itemconfig $id -fill red -font $date::canvasHighlight}
            incr x $dx
            if {$x>$xmax} {set x $x0; incr y $dy}
        }
        
        $canvas lower boxes

        $canvas bind day <1> {
            set item [%W find withtag current]
            set date::day [%W itemcget $item -text]
            set date::date "$date::month/$date::day/$date::year"
            %W itemconfig day -fill black -font $date::canvasFont
            %W itemconfig $item -fill red -font $date::canvasHighlight
        }
        $canvas bind day <Double-Button-1> {
                set item [%W find withtag current]
                set date::day [%W itemcget $item -text]
                set date::date "$date::month/$date::day/$date::year"        
                set date::res $date::date
       }
}

proc numberofdays {month year} {
        if {$month==12} {set month 1; incr year}
        clock format [clock scan "[incr month]/1/$year  1 day ago"] \
                -format %d
}
        
} ;# end namespace date
 
 