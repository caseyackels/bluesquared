# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 157 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2011-10-03 14:41:48 -0700 (Mon, 03 Oct 2011) $
#
########################################################################################

##
## - Overview
# This file holds the parent GUI for Distribution Helper

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

## Coding Conventions
# - Namespaces:

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


# See: setup_gui.tcl for [package provide] and [namespace eval]

proc eAssistSetup::createRows {win fields} {
    #****f* createRows/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Add rows to the tablelist
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	eAssistSetup::eAssistSetup
    #
    # NOTES
    #
    # SEE ALSO
    #
    #
    #***
    $win delete 0 end
    
    for {set x 0} {$x<$fields} {incr x} {
        $win insert end ""
    }
} ;# eAssistSetup::createRows


proc eAssistSetup::selectionChanged {tbl} {
    #****f* selectionChanged/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Detect what we've selected in the Treeview
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	eAssistSetup::eAssistSetup
    #
    # NOTES
    #
    # SEE ALSO
    #
    #
    #***
    global G_currentSetupFrame program
    
     set rowList [$tbl curselection] 
     if {[llength $rowList] == 0} { 
         return 
     } 

    set row [lindex $rowList 0]
    set G_currentSetupFrame [$tbl get $rowList]

     #puts "The current selection is: $G_currentSetupFrame" ;# Get the name
     #puts "The currently selected row is: $row." ;# Get the row number
     
     switch -- $G_currentSetupFrame {
        Paths       {eAssistSetup::selectFilePaths_GUI ; set program(lastFrame) selectFilePaths_GUI ; puts $G_currentSetupFrame}
        Labels      {eAssistSetup::boxLabels_GUI ; set program(lastFrame) boxLabels_GUI ; puts $G_currentSetupFrame}
        Delimiters  {}
        Headers     {}
        ShipMethod  {}
        Misc.       {}
        Setup       {eAssistSetup::setup_GUI ; set program(lastFrame) setup_GUI ; puts $G_currentSetupFrame}
        Company     {eAssistSetup::company_GUI ; set program(lastFrame) company_GUI ; puts $G_currentSetupFrame}
        default     {puts "no items selected"}
     }
     
} ;# eAssistSetup::selectionChanged


proc eAssistSetup::controlState {var entryWidget buttonWidget} {
    #****f* controlState/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2013 Casey Ackels
    #
    # FUNCTION
    #	Control the state of an Entry and a Button
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	eAssistSetup::
    #
    # NOTES
    #
    # SEE ALSO
    #
    #
    #***
    global GS_filePaths
    
    if {$var == 1} {
        $entryWidget state disabled
        $buttonWidget state disabled
    } else {
        $entryWidget configure -state enable
        $buttonWidget configure -state enable
    }
    
    
    
};# eAssistSetup::controlState


proc eAssistSetup::SaveGlobalSettings {} {
    #****f* SaveGlobalSettings/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2013 Casey Ackels
    #
    # FUNCTION
    #	Save the Gloal Settings to a file. These settings are what affect everyone's usage of Efficiency Assist.
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	eAssistSetup::
    #
    # NOTES
    #
    # SEE ALSO
    #
    #
    #***
    global GS_filePaths program company setup logSettings
    
    # Global Settings - saved to the server
    set fd [open [file join $program(Home) config.txt] w]
    
    foreach value [array names GS_filePaths] {
            puts $fd "GS_filePaths($value) $GS_filePaths($value)"
    }
    
    foreach value [array names program] {
            puts $fd "program($value) $program($value)"
    }
     
    foreach value [array names company] {
            puts $fd "company($value) $company($value)"
    }
    
    foreach value [array names logSettings] {
            puts $fd "logSettings($value) $logSettings($value)"
    }


    
    
    #set setup(smallPackageCarriers) [.container.setup.frame2.listbox get 0 end]
        #puts "carriers1: $setup(smallPackageCarriers)"
    
    #set setup(smallPackageCarriers) [lrange $setup(smallPackageCarriers) 0 end-1] ;# Get rid of the empty list generated by inserting an empty line in the listbox.
    #    puts "carriers2: [lrange $setup(smallPackageCarriers) 0 end-1]"
    #
    #set setup(smallPackageCarrierName) "" ;# Always generate a new list
    #foreach carrier $setup(smallPackageCarriers) {
    #    lappend setup(smallPackageCarrierName) [join [lrange $carrier 0 0] ]
    #}
    
    puts $fd "setup(smallPackageCarriers) $setup(smallPackageCarriers)"
    puts $fd "setup(smallPackageCarrierName) $setup(smallPackageCarrierName)"

    chan close $fd   
} ;# eAssistSetup::SaveGlobalSettings


proc eAssistSetup::startCmd {tbl row col text} { 
    #****f* startCmd/eAssistSetup
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
    global internal setup log
        set w [$tbl editwinpath]
        
        #'debug index: [$w index bottom]
        
        switch -- [$tbl columncget $col -name] {
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
                if {$row == 0} {$tbl insert end ""}
                ## See tablelist help for using 'end' as an index point.
                if {($row != 0) && ($row == $myRow)} {$tbl insert end ""}
                }
            Carrier {
                #puts "tbl: $tbl"
                #$w configure -values {UPS FedEX} -state readonly
            }
            Delete {}
            default {}
        }
        
    set setup(smallPackageCarriers) [.container.setup.frame2.listbox get 0 end]
    ${log}::debug smallPackageCarriers: $setup(smallPackageCarriers)
    
    set setup(smallPackageCarriers) [lrange $setup(smallPackageCarriers) 0 end-1] ;# Get rid of the empty list generated by inserting an empty line in the listbox.
        #puts "carriers2: [lrange $setup(smallPackageCarriers) 0 end-1]"
    
    set setup(smallPackageCarrierName) "" ;# Always generate a new list
    foreach carrier $setup(smallPackageCarriers) {
        lappend setup(smallPackageCarrierName) [join [lrange $carrier 0 0]]
    }
    ${log}::debug smallPackageCarrierNameFinalList: $setup(smallPackageCarrierName)
    ${log}::debug smallPackageCarriers: $setup(smallPackageCarriers)
    
        
        return $text
} ;# eAssistSetup::startCmd


proc eAssistSetup::endCmd {tbl row col text} { 
    #****f* endCmd/eAssistSetup
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
    global internal setup log
   
    set w [$tbl editwinpath]
    
    switch -- [$tbl columncget $col -name] {
            Account {
                # Set the current row at the last column (Account) so we have an accurate row count.
                incr internal(table,currentRow)
                    #'debug cust elements: [$tbl get 0 end-1]
                    #'debug cRow [$tbl get $internal(table,currentRow) $internal(table,currentRow)]
                }
            default {
            }
    }

    set setup(smallPackageCarriers) [.container.setup.frame2.listbox get 0 end]
    ${log}::debug smallPackageCarriers: $setup(smallPackageCarriers)
    
    set setup(smallPackageCarriers) [lrange $setup(smallPackageCarriers) 0 end-1] ;# Get rid of the empty list generated by inserting an empty line in the listbox.
        #puts "carriers2: [lrange $setup(smallPackageCarriers) 0 end-1]"
    
    set setup(smallPackageCarrierName) "" ;# Always generate a new list
    foreach carrier $setup(smallPackageCarriers) {
        lappend setup(smallPackageCarrierName) [join [lrange $carrier 0 0]]
    }
    ${log}::debug smallPackageCarrierNameFinalList: $setup(smallPackageCarrierName)
    ${log}::debug smallPackageCarriers: $setup(smallPackageCarriers)
    
    return $text
} ;# eAssistSetup::endCmd


proc eAssistSetup::changeLogLevel {args} { 
    #****f* changeLogLevel/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2013 Casey Ackels
    #
    # FUNCTION
    #	Change the logging level on the fly
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	eAssistSetup::setup_GUI
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global log logSettings
        
        logger::setlevel [string tolower [lindex $logSettings(levels) $args]]
        ${log}::notice [mc "Logging level has been set to: ${log}::currentloglevel"]
    

} ;#eAssistSetup::changeLogLevel 