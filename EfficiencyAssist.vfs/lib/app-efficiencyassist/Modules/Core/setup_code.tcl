# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 475 $
# $LastChangedBy: casey.ackels@gmail.com $
# $LastChangedDate: 2015-02-22 12:50:13 -0800 (Sun, 22 Feb 2015) $
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
    global G_currentSetupFrame log GS
    #${log}::debug --START-- selectionChanged

     set rowList [$tbl curselection]
     if {[llength $rowList] == 0} {
         return
     }

    set row [lindex $rowList 0]
    set G_currentSetupFrame [$tbl get $rowList]

     switch -- $G_currentSetupFrame {
        Admin           {eAssistSetup::admin_GUI ; set GS(gui,lastFrame) admin_GUI ; ${log}::debug Current Frame: $G_currentSetupFrame}
        Paths           {eAssistSetup::selectFilePaths_GUI ; set GS(gui,lastFrame) selectFilePaths_GUI ; ${log}::debug Current Frame: $G_currentSetupFrame}
        Labels          {eAssistSetup::boxLabels_GUI ; set GS(gui,lastFrame) boxLabels_GUI ; ${log}::debug Current Frame: $G_currentSetupFrame}
        Delimiters      {}
        ShipMethod      {}
        Misc.           {}
        International   {eAssistSetup::international_GUI ; set GS(gui,lastFrame) international_GUI ; ${log}::debug Current Frame: $G_currentSetupFrame}
        AddressHeaders  {eAssistSetup::addressHeaders_GUI ; set GS(gui,lastFrame) addressHeaders_GUI ; ${log}::debug Current Frame: $G_currentSetupFrame}
        Carrier         {eAssistSetup::carrierMethod_GUI; set GS(gui,lastFrame) carrierMethod_GUI; ${log}::debug Current Frame: $G_currentSetupFrame}
        Countries       {eAssistSetup::countries_GUI; set GS(gui,lastFrame) countries_GUI; ${log}::debug Current Frame: $G_currentSetupFrame}
        Packaging       {eAssistSetup::packagingTypes_GUI; set GS(gui,lastFrame) packagingTypes_GUI; ${log}::debug Current Frame: $G_currentSetupFrame}
        DistTypes       {eAssistSetup::distributionTypes_GUI ; set GS(gui,lastFrame) distributionTypes_GUI ; ${log}::debug Current Frame: $G_currentSetupFrame}
        CSR             {eAssistSetup::customerService_GUI ; set GS(gui,lastFrame) customerService_GUI ; ${log}::debug current Frame: $G_currentSetupFrame}
        Company         {eAssistSetup::company_GUI ; set GS(gui,lastFrame) company_GUI ; ${log}::debug Current Frame: $G_currentSetupFrame}
        Logging         {eAssistSetup::logging_GUI ; set GS(gui,lastFrame) logging_GUI ; ${log}::debug Current Frame: $G_currentSetupFrame}
        EmailSetup      {eAssistSetup::emailSetup_GUI ; set GS(gui,lastFrame) emailSetup_GUI ; ${log}::debug Current Frame: $G_currentSetupFrame}
        Scheduler       {eAssistSetup::scheduler_GUI ; set GS(gui,lastFrame) scheduler_GUI ; ${log}::debug Current Frame: $G_currentSetupFrame}
        default         {${log}::notice $G_currentSetupFrame does not match any configured frames.}
     }

     ##
     ## Reconfigure Button Bar // save this module
     ##
     eAssist::addButtons [mc "Save"] eAssistSetup::SaveGlobalSettings btn1 0 8p

    #${log}::debug --END-- selectionChanged
} ;# eAssistSetup::selectionChanged


proc eAssistSetup::controlState {} {
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
    global log GS_filePathSetup w
    ${log}::debug --START-- controlState

    ${log}::debug Change entry_variable to: $GS_filePathSetup(lookInDirectory)
    ${log}::debug Check Toggle is: $GS_filePathSetup(checkToggle)

    if {$GS_filePathSetup(checkToggle) == 1} {
        set GS_filePathSetup(labelDirectory) $GS_filePathSetup(lookInDirectory)
    } else {
        set GS_filePathSetup(labelDirectory) ""
    }

    ${log}::debug --END-- controlState
};# eAssistSetup::controlState





proc eAssistSetup::saveBoxLabels {} {
    #****f* saveBoxLabels/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Preprocessor to save the box label configurations. Calls SaveGlobalSettings once the preprocessing is complete.
    #
    # SYNOPSIS
    #   eAssistSetup::saveBoxLabels $boxLabelInfo(currentBoxLabel) $GS_label(numberOfFields) $GS_filePathSetup(labelDirectory)
    #
    # CHILDREN
    #	eAssistSetup::SaveGlobalSettings
    #
    # PARENTS
    #
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global log boxLabelInfo GS_label GS_filePathSetup
    ${log}::debug --START-- boxLabels

    ${log}::debug Duplicate Name? [lsearch $boxLabelInfo(labelNames) $boxLabelInfo(currentBoxLabel)]

    # Cancel if there is no label name
    if {$boxLabelInfo(currentBoxLabel) == ""} {return}

    if {[lsearch $boxLabelInfo(labelNames) $boxLabelInfo(currentBoxLabel)] == -1} {
        lappend boxLabelInfo(labelNames) $boxLabelInfo(currentBoxLabel)
    }

    #set boxLabelInfo($boxLabelInfo(labelNames),labelSetup) [lrange $args 1 end]
    set boxLabelInfo($boxLabelInfo(currentBoxLabel),labelSetup) [list $GS_label(numberOfFields) $GS_filePathSetup(labelDirectory)]

    #${log}::debug labelNames: $boxLabelInfo(labelNames)
    #${log}::debug currentLabel: $boxLabelInfo(currentBoxLabel)
    #${log}::debug labelSetup: $boxLabelInfo($boxLabelInfo(currentBoxLabel),labelSetup)

    eAssistSetup::SaveGlobalSettings

    ${log}::debug --END-- boxLabels
} ;#eAssistSetup::saveBoxLabels


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


proc eAssistSetup::startCmdBoxLabels {tbl row col text} {
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
    global internal boxLabels log
        set w [$tbl editwinpath]

        #'debug index: [$w index bottom]

        switch -- [$tbl columncget $col -name] {
            field {
                ## Populate and make it readonly, and insert another line.
                #set myRow [expr {[$tbl index end] - 1}]
                #if {$row == 0} {$tbl insert end ""}
                ## See tablelist help for using 'end' as an index point.
                #if {($row != 0) && ($row == $myRow)} {$tbl insert end ""}
                }
            fieldname {
                #puts "tbl: $tbl"
                #$w configure -values {UPS FedEX} -state readonly
            }
            Delete {}
            default {}
        }

    set boxLabels(boxLabelConfig) [.container.setup.frame2.listbox get 0 end]
    ${log}::debug BoxLabels: $boxLabels(boxLabelConfig)

    set boxLabels(boxLabelConfig) [lrange $boxLabels(boxLabelConfig) 0 end-1]

    set boxLabels(boxLabelConfigNames) "" ;# Always generate a new list

    foreach boxlabels $boxLabels(boxLabelConfig) {
        lappend boxLabels(boxLabelConfig) [join [lrange $boxlabels 0 0]]
    }
    ${log}::debug boxLabelConfigNames: $boxLabels(boxLabelConfigNames)
    ${log}::debug boxLabelConfig: $boxLabels(boxLabelConfig)


        return $text
} ;# eAssistSetup::startCmdBoxLabels
