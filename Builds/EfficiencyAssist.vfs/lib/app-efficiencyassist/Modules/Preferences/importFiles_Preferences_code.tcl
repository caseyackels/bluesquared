# Creator: Casey Ackels
# Initial Date: June 8th, 2012
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 338 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate$
#
########################################################################################

##
## - Overview
# This file holds the parent GUI frame, buttons and menu for Distribution Helper

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

## Coding Conventions
# - Namespaces:

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

proc eAssist_Preferences::startCmd {tbl row col text} { 
    #****f* startCmd/eAssist_Preferences
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2012 - Casey Ackels
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
    global internal
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
                if {$row == 0} {$tbl insert end ""; 'debug Inserting 2nd Row}
                ## See tablelist help for using 'end' as an index point.
                if {($row != 0) && ($row == $myRow)} {$tbl insert end ""; 'debug Inserting Row}
                }
            Carrier {
                puts "tbl: $tbl"
                $w configure -values {UPS FedEX} -state readonly
            }
            "Ship Via" {
                set myRow_b [expr {[$tbl index end] - 1}]
                if {$row == 0} {$tbl insert end ""; 'debug Inserting 2nd Row}
                ## See tablelist help for using 'end' as an index point.
                if {($row != 0) && ($row == $myRow_b)} {$tbl insert end ""; 'debug Inserting Row}
            }
            Delete {}
            default {}
        }
        
        #'debug Text: $text
        return $text
}


proc eAssist_Preferences::endCmd {tbl row col text} { 
    #****f* endCmd/eAssist_Preferences
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
    global internal customer3P 
    'debug Starting endCmd
   
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
}