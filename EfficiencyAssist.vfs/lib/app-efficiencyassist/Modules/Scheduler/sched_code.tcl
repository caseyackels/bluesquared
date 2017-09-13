# Scheduler Module
# a tool that assists in creating schedules, and responding to clients prior to the work entering the facility.
# essentially a prescheduler.

# Namespaces (app, module, categroy)
#   ea::sched::code {}
#   ea::sched::gui {}
#   ea::sched::db {}

proc ea::sched::code::launchReport {} {
    global GL_file schedDate
    
    set GL_file(dataList) ""
    if {[info exists schedDate(currDate)]} {unset schedDate(currDate)}
    
    ea::sched::code::readFile pfgrouped45days_shuts.csv
    ea::sched::code::eaProcessFile $GL_file(dataList)
}

proc ea::sched::code::readFile {filename} {
    global GL_file
    set fileName [open "$filename" RDONLY]

    # Make the data useful, and put it into lists
    #while {-1 != [gets $fp line]}
    while { [gets $fileName line] >= 0 } {
        # Guard against lines of comma's, this will not be viewable in excel. Only in a text editor.
        if {[string is punc [join [split [string trim $line] " "] ""]] eq 1} {continue}

        lappend GL_file(dataList) $line
        #puts $line
    }
    chan close $fileName
}

# ea::sched::code::eaProcessFile $GL_file(dataList)
proc ea::sched::code::eaProcessFile {data} {
    global log l_line schedr schedr_setup excel
    ea::sched::code::InitReport
    
    #BIG LOOP
    foreach entry $data {
        set dept ""
        set l_line [csv::split $entry]
        
        #puts "line: $l_line"
            set schedr(pjnumber) [lindex $l_line 0]
            set schedr(customer) [lindex $l_line 1]
            set schedr(name) [join [lindex $l_line 2]]
            set schedr(title) [join [lindex $l_line 3]]
            set schedr(issueid) [lindex $l_line 4]
            set schedr(time) [lindex $l_line 5]
            set schedr(machine,cccode) [join [lindex $l_line 6]]
            set schedr(machine,name) [lindex $l_line 7]
            set schedr(qty) [lindex $l_line 8]
            set schedr(number) [lindex $l_line 9]
            set schedr(colors) [lindex $l_line 10]
            set schedr(specialop) [lindex $l_line 11]
            set schedr(taskcount) [lindex $l_line 12]
            set schedr(day) [lindex $l_line 13]
            set schedr(cc_type) [lindex $l_line 14]

            
            #${log}::debug CC_TYPE: $schedr(cc_type)
            switch -- $schedr(cc_type) {
                "Press"       {
                                #${log}::debug $schedr(day) $schedr(machine,name) $schedr(title)
                                ea::sched::code::InsertDept $schedr(day) $schedr(machine,name)
                }
                "Bindery"     {}
                "PostPress"   {}
                "Shut"        {
                                #ea::sched::code::InsertDept $schedr(day) $schedr(machine,name)
                }
                default       {}
            }
            
            ea::sched::code::initvars_sched
    }

    # Turn screen updating back on
    Excel::ScreenUpdate $excel(id) on
} ;# ea::sched::code::eaProcessFile

proc ea::sched::code::InitReport {} {
    global log excel machine
    # Setup workbook/worksheet
    set excel(id) [Excel::Open]
    set excel(workbook_id) [Excel::AddWorkbook $excel(id)]
    set excel(worksheet_id) [Excel::GetWorksheetIdByIndex $excel(workbook_id) 1]
    
    # Turn off screen updating
    Excel::ScreenUpdate $excel(id) off
    
    # --- HEADER
    set excel(base_id) [Excel::SelectCellByIndex $excel(worksheet_id) 1 1]
        Excel::SetRangeFontBold $excel(base_id)
        Excel::SetRangeFontSize $excel(base_id) 12
        #[subst [list {"Job Number" "$job(Number)"}]]
        #Excel::SetMatrixValues $excel(worksheet_id) [list {"PRODUCTION SCHEDULE"}] 1 1
        
        # Setup the Columns (2 = row, 1,2 = column)
        Excel::SetMatrixValues $excel(worksheet_id) [list {"Date"}] 1 1
        Excel::SetMatrixValues $excel(worksheet_id) [list {"M500"}] 1 2
        Excel::SetMatrixValues $excel(worksheet_id) [list {"S2000"}] 1 3
        Excel::SetMatrixValues $excel(worksheet_id) [list {"M130"}] 1 4
        
        
        #set machine(m500,lastRow) 2
        #set machine(m130,lastRow) 2
        #set machine(s2000,lastRow) 2
    # Turn screen updating back on
    #Excel::ScreenUpdate $excel(id) on
}

proc ea::sched::code::InsertDept {date mach} {
    # GATEWAY
    global log excel schedr machine schedDate
    #${log}::debug Date: $date

    # Enter Master date; save previous date
    if {[info exists schedDate(currDate)]} {
        set schedDate(prevDate) $schedDate(currDate)

    } else {
        # on First iteration
        set schedDate(currDate) $date
        set schedDate(prevDate) $date
        #${log}::debug curr/prev Date: $schedDate(currDate) - $schedDate(prevDate)
        #set lastRow [Excel::GetLastUsedRow $excel(worksheet_id)]
        
        Excel::SetMatrixValues $excel(worksheet_id) [subst [list {"$date"}]] 2 1
        
        set schedDate(master,lastRow) 2
            set machine(m500,lastRow) $schedDate(master,lastRow)
            set machine(s2000,lastRow) $schedDate(master,lastRow)
            set machine(m130,lastRow) $schedDate(master,lastRow)
    }
    
    set schedDate(currDate) $date
    if {$schedDate(currDate) ne $schedDate(prevDate)} {
        set lastRow [Excel::GetLastUsedRow $excel(worksheet_id)]
        Excel::SetMatrixValues $excel(worksheet_id) [subst [list {"$date"}]] [incr lastRow 1] 1
        
        #set id [Excel::SelectRangeByIndex $excel(worksheet_id) $lastRow 1 $lastRow 5]
        #set id [Excel::SelectRangeByIndex $excel(worksheet_id) 5 1 5 5]
            #Excel::SetRangeBorders $id xlEdgeBottom xlThin
        
        #${log}::debug MASTER curr/prev Date: $schedDate(currDate) - $schedDate(prevDate) - $lastRow
        set schedDate(master,lastRow) $lastRow
        incr schedDate(master,lastRow)
        
        set machine(m500,lastRow) $schedDate(master,lastRow)
        set machine(s2000,lastRow) $schedDate(master,lastRow)
        set machine(m130,lastRow) $schedDate(master,lastRow)
        
        #${log}::debug m500 - $machine(m500,lastRow)
        #${log}::debug m130 - $machine(m130,lastRow)
    } else {
        #${log}::debug Dates are the same
        #${log}::debug MASTER - $schedDate(master,lastRow)
        #${log}::debug m500 - $machine(m500,lastRow)
        #${log}::debug m130 - $machine(m130,lastRow)
    }
    
    
    # By Machine
    if {$mach == "M500"} {

        # Clear out vars
        if {[info exists secondLine]} {unset secondLine}

        # Colors
        set lowerColors [string tolower $schedr(colors)]
        if {[string match *varn* $lowerColors]} {lappend secondLine Varnish}
        if {[string match *pms* $lowerColors]} {lappend secondLine PMS}
        
        # Special Ops
        if {$schedr(specialop) ne "NULL"} {lappend secondLine $schedr(specialop)}
        
        lappend secondLine [join "$schedr(taskcount)x $schedr(qty)" ""]
        set secondLine [split [join $secondLine " "]]
                

        ### DATE BY MACHINE
        set newTime [lindex [split [lindex $schedr(time) 1] .] 0]
        set newTime [join [lrange [split $newTime :] 0 1] :]
        
        if {"$schedr(pjnumber)" eq "$mach"} {
            Excel::SetMatrixValues $excel(worksheet_id) [subst [list {"_SHUT_ $newTime $schedr(name)"}]] $machine(m500,lastRow) 2
            incr machine(m500,lastRow)
        } else {
            ${log}::debug Current last Row (1): M500 - $machine(m500,lastRow) - Time: $newTime - Mach: $mach
            Excel::SetMatrixValues $excel(worksheet_id) [subst [list {"$newTime $schedr(number) $schedr(customer) $schedr(title) $schedr(name)"}]] $machine(m500,lastRow) 2
            incr machine(m500,lastRow)
            
            ${log}::debug Current last Row (2): M500 - $machine(m500,lastRow)
            Excel::SetMatrixValues $excel(worksheet_id) [subst [list {"$secondLine"}]] $machine(m500,lastRow) 2
            incr machine(m500,lastRow)
            
            ${log}::debug Current last Row(3): M500 - $machine(m500,lastRow)
        }
    }
    
    # By Machine
    if {$mach == "M130"} {
        # Clear out vars
        if {[info exists secondLine]} {unset secondLine}
            
        # Colors
        set lowerColors [string tolower $schedr(colors)]
        if {[string match *varn* $lowerColors]} {lappend secondLine Varnish}
        if {[string match *pms* $lowerColors]} {lappend secondLine PMS}
        
        # Special Ops
        if {$schedr(specialop) ne "NULL"} {lappend secondLine $schedr(specialop)}
        
        lappend secondLine [join "$schedr(taskcount)x $schedr(qty)" ""]
        set secondLine [split [join $secondLine " "]]
        
        set newTime [lindex [split [lindex $schedr(time) 1] .] 0]
        set newTime [join [lrange [split $newTime :] 0 1] :]
        
        Excel::SetMatrixValues $excel(worksheet_id) [subst [list {"$newTime $schedr(number) $schedr(customer) $schedr(title) $schedr(name)"}]] $machine(m130,lastRow) 4
        incr machine(m130,lastRow)
        
        Excel::SetMatrixValues $excel(worksheet_id) [subst [list {"$secondLine"}]] $machine(m130,lastRow) 4
        incr machine(m130,lastRow)
    }
    
    # By Machine
    if {$mach == "S2000x Side 1" || $mach == "Goss S2000x Tandem"} {
        # Clear out vars
        if {[info exists secondLine]} {unset secondLine}
            
        # Setup data
        if {[string match *Varn* $schedr(colors)]} {lappend secondLine Varnish}
        if {$schedr(specialop) ne "NULL"} {lappend secondLine $schedr(specialop)}
        
        lappend secondLine [join "$schedr(taskcount)x $schedr(qty)" ""]
        set secondLine [split [join $secondLine " "]]
        
        if {$schedDate(currDate) ne $schedDate(prevDate)} {
            set machine(s2000,lastRow) [incr lastRow -1]
            ${log}::debug S2000 curr/prev Date: $schedDate(currDate) - $schedDate(prevDate) - $lastRow
        }
        
        ### DATE BY MACHINE
        # Enter current date; save previous date
        if {[info exists schedDate(s2000,currDate)]} {
            set schedDate(s2000,prevDate) $schedDate(s2000,currDate)
    
            } else {
                # on First iteration
                set schedDate(s2000,currDate) $date
                set schedDate(s2000,prevDate) $date
        }
        
        set schedDate(s2000,currDate) $date
        
        if {$schedDate(s2000,currDate) ne $schedDate(s2000,prevDate)} {
            set machine(s2000,lastRow) [Excel::GetLastUsedRow $excel(worksheet_id)]
            #${log}::debug MASTER curr/prev Date: $schedDate(currDate) - $schedDate(prevDate) - $machine(m500,lastRow)
        }
        
        Excel::SetMatrixValues $excel(worksheet_id) [subst [list {"$schedr(number) $schedr(customer) $schedr(title) $schedr(name)"}]] $machine(s2000,lastRow) 3
        
        incr machine(s2000,lastRow)
        Excel::SetMatrixValues $excel(worksheet_id) [subst [list {"$secondLine"}]] $machine(s2000,lastRow) 3
        
        incr machine(s2000,lastRow)
    }
}
