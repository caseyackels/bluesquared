# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 09 30,2013
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 468 $
# $LastChangedBy: casey.ackels@gmail.com $
# $LastChangedDate$
#
########################################################################################

##
## - Overview
# core file for preferences to launch from

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


proc eAssistPref::startCmd {tbl row col text} {
    #****f* startCmd/eAssistPref
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2012-2013 - Casey Ackels
    #
    # FUNCTION
    #	Configuration options when the user enters the listbox
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global log internal setup
        set w [$tbl editwinpath]
        
        #'debug index: [$w index bottom]
        
        switch -- [$tbl columncget $col -name] {
            Name {
                # 
                #$w configure -textvariable purchased($purchased(Name),$row,item)
                    #'debug allRows: [$tbl get 0 end]
                    #'debug cRow [$tbl get $internal(table,currentRow) $internal(table,currentRow)]
            }
            Code {
                ## Allow only 4 numbers, and the . character. (ex. 1.04)
                #$w configure -invalidcommand bell \
                #              -validate key \
                #              -validatecommand {expr {[string length %P] <= 4 && [regexp {^[0-9.]*$} %S]}} \
                #                -textvariable purchased($purchased(Name),$row,price)
            }
            Account {
                ## Populate and make it readonly, and insert another line.
                #$w configure -values {"Tax (Food)" "Tax (Other)" None} \
                #            -state readonly \
                #            -textvariable purchased($purchased(Name),$row,tax)
                #
                ##'debug INDEX: [expr {[$tbl index end] - 1}] # Using index-end, and subtracting 1
                ##'debug INDEX: [$tbl index end] # Using the standard index-end
                ##'debug ROW: $row # If row and INDEX-end match, insert a row.
                set myRow [expr {[$tbl index end] - 1}]
                if {$row == 0} {$tbl insert end ""; ${log}::debug Inserting 2nd Row}
                ## See tablelist help for using 'end' as an index point.
                if {($row != 0) && ($row == $myRow)} {$tbl insert end ""; ${log}::debug Inserting Row}
                }
            Carrier {
                ${log}::debug tbl: $tbl
                if {![info exists setup(smallPackageCarrierName)]} {
                    ${log}::critical Please set the Small Package Carriers up in Setup
                    return
                    } else {
                        $w configure -values $setup(smallPackageCarrierName) -state readonly
                    }
            }
            "Ship Via" {
                set myRow_b [expr {[$tbl index end] - 1}]
                if {$row == 0} {$tbl insert end ""; ${log}::debug Inserting 2nd Row}
                ## See tablelist help for using 'end' as an index point.
                if {($row != 0) && ($row == $myRow_b)} {$tbl insert end ""; ${log}::debug Inserting Row}
            }
            Delete {}
            default {}
        }

        return $text
} ;#eAssistPref::startCmd


proc eAssistPref::endCmd {tbl row col text} { 
    #****f* endCmd/eAssistPref
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2012 - Casey Ackels
    #
    # FUNCTION
    #	Configuration options when the user leaves the listbox
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global internal customer3P log setup
    ${log}::debug Starting endCmd
   
    set w [$tbl editwinpath]
    
    switch -- [$tbl columncget $col -name] {
            Account {
                # Set the current row at the last column (Account) so we have an accurate row count.
                incr internal(table,currentRow)
                    #'debug cust elements: [$tbl get 0 end-1]
                    #'debug cRow [$tbl get $internal(table,currentRow) $internal(table,currentRow)]
                }
            "Ship Via" {
                # Set the current row at the last column (Ship Via) so we have an accurate row count.
                incr internal(table2,currentRow)
            }
            default {
                #'debug default endCmd
            }
    }
    return $text
} ;#eAssistPref::endCmd
