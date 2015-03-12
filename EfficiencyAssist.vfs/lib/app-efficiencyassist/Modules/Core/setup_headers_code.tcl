# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 09 25,2013
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 479 $
# $LastChangedBy: casey.ackels@gmail.com $
# $LastChangedDate$
#
########################################################################################

##
## - Overview
# Headers for Batch addresses

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


proc eAssistSetup::removeHeader {type wListbox args} {
    #****f* removeHeader/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 - Casey Ackels
    #
    # FUNCTION
    #	
    #
    # SYNOPSIS
    #	Removes the selected header (Parent or Child) and updates the list of values for that particular variable
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
    global log w headerAddress headerParent
    ${log}::debug removeChildHeader

    if {[$wListbox curselection] == "" } {return}
    $wListbox delete [$wListbox curselection]
    
    # Set the new list of values to the array variable.
    switch -- $type {
        parent  {set headerParent(headerList) [$wListbox get 0 end]
                unset -nocomplain headerAddress([$wListbox get 0 end]) ;# Remove the array so we don't "hang" onto the data unneccessarily
                ${log}::debug new headerParent $headerParent(headerList)
                }
        
        child   {set headerAddress($args) [$wListbox get 0 end]
                unset -nocomplain headerAddress($args)
                ${log}::debug new headerAddress($args) $headerAddress($args)
                }
        
        default {}
    }
} ;# end eAssistSetup::removeHeader


proc eAssistSetup::displayHeader {wListbox cboxIndex parentHeader} {
    #****f* displayHeader/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 - Casey Ackels
    #
    # FUNCTION
    #	Called with the indice of the value of the combobox; and returns the associated array with values, of that array variable.
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
    global log headerAddress
    ${log}::debug Display Header

    $wListbox delete 0 end
    
    #${log}::debug headers lbox: $wListbox . $cboxIndex
    #${log}::debug headers lbox: headerAddress($parentHeader)
    
    if {[info exists headerAddress($parentHeader)] == 1} {
        ${log}::debug checkVar: headerAddress($parentHeader)
    } else {
        return
    }

    ${log}::debug headers lbox: $headerAddress($parentHeader)
        
    foreach headerName $headerAddress($parentHeader) {
        $wListbox insert end $headerName
        ${log}::debug parentHeader - headerAddress($parentHeader)
        ${log}::debug childHeader - $headerName
    }

} ;# End eAssistSetup::displayHeader


#proc eAssistSetup::addToMasterHeader {wListbox wEntry tmp_header} {
#    #****f* addToMasterHeader/eAssistSetup
#    # AUTHOR
#    #	Casey Ackels
#    #
#    # COPYRIGHT
#    #	(c) 2011-2013 Casey Ackels
#    #
#    # FUNCTION
#    #	Add to the master header list
#    #
#    # SYNOPSIS
#    #   addToMasterHeader <listbox widget> <entry widget> textvariable
#    #
#    # CHILDREN
#    #	N/A
#    #
#    # PARENTS
#    #	
#    #
#    # NOTES
#    #
#    # SEE ALSO
#    #
#    #***
#    global log headerParent
#    global GUI
#    
#    # Insert data from the entry widget to the listbox
#    $wListbox insert end $tmp_header
#    
#    # Clear out the entry widget
#    $wEntry delete 0 end
#    
#    set headerParent(headerList) [$wListbox get 0 end]
#} ;# eAssistSetup::addToMasterHeader


proc eAssistSetup::addToChildHeader {wListbox wEntry childHeader parentHeader} {
    #****f* addToChildHeader/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Add children to the Master Headers
    #
    # SYNOPSIS
    #
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
    global log program headerParent headerAddress
    global GUI

    ${log}::debug addToChildHeader args - $wListbox . $wEntry . $childHeader
    
    # Cycle through all header arrays to check for duplicates
    #  We must allow only one instance of a word for all SubHeaders
    foreach name [array names headerParent] {
        if {[lsearch $headerParent($name) $childHeader] != -1} {
            ${log}::debug Found duplicate in $name
            Error_Message::errorMsg header1 $name
            return
        }
    }
    # Clear out the entry widget
    $wEntry delete 0 end
    
    # Insert data from the entry widget to the listbox
    $wListbox insert end $childHeader

    # set array, so it saves correctly.
    set headerAddress($parentHeader) [$wListbox get 0 end]
    ${log}::debug save-array headerAddress($parentHeader) [$wListbox get 0 end]
 
} ;# eAssistSetup::addToMasterHeader


proc eAssistSetup::startCmdHdr {tbl row col text} { 
    #****f* startCmdHdr/eAssistSetup
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
    global internal setup log w headerParent
    ${log}::debug --START-- [info level 1]
   
    set win [$tbl editwinpath]
    #$w(hdr_frame1a).listbox
    
    switch -- [$tbl columncget $col -name] {
        
            HeaderName  {
                # We don't want spaces in our header names because we create variables from them; and if there are spaces it EA will break.
                ${log}::debug bind [$tbl editwinpath] <space> {break}
                bind [$tbl editwinpath] <space> {break}
            }
            MaxStringLength {
                set myRow [expr {[$tbl index end] - 1}]
                if {$row == 0} {$tbl insert end ""}
                ## See tablelist help for using 'end' as an index point.
                if {($row != 0) && ($row == $myRow)} {$tbl insert end ""}
                
                set headerParent(outPutHeader) [$w(hdr_frame1a).listbox getcells 0,3 end,3]
                if {[lrange $headerParent(outPutHeader) end end] == "{}"} {
                            #Remove the last list item, since it is empty.
                            set headerParent(outPutHeader) [lrange $headerParent(outPutHeader) 0 end-1]
                }
                ${log}::debug Saving : [$w(hdr_frame1a).listbox getcells 0,3 end,3]
                }
            Widget  {
                $win configure -values [list ttk::entry ttk::combobox] -state readonly
                }
            AlwaysDisplay   {
                $win configure -values [list Yes No] -state readonly
            }
            Required    {
                $win configure -values [list Yes No] -state readonly
            }
            default {
            }
    }
    
    # Update the internal list with the current text so that we can run calculations on it.
    ${log}::debug Before cellconfigure: $text
    #$tbl cellconfigure $row,$col
    #${log}::debug executing saveHeaderParams...
    #eAssistSetup::saveHeaderParams
    return $text

    ${log}::debug --END-- [info level 1]
} ;# eAssistSetup::startCmdHdr


proc eAssistSetup::endCmdHdr {tbl row col text} { 
    #****f* endCmdHdr/eAssistSetup
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
    global internal setup log headerParent w
    ${log}::debug --START-- [info level 1]
   
    #set w [$tbl editwinpath]
    
    switch -- [$tbl columncget $col -name] {
            HeaderName {
                        set headerParent(headerList) [$w(hdr_frame1a).listbox getcells 0,1 end,1]
                        #${log}::debug End of the List: [lrange $headerList end end]
    
                        if {[lrange $headerParent(headerList) end end] == "{}"} {
                            #Remove the last list item, since it is empty.
                            set headerParent(headerList) [lrange $headerParent(headerList) 0 end-1]
                        }
            }
            MaxStringLength {
                # Set the current row at the last column so we have an accurate row count.
                incr internal(addrHdr,currentRow)
                }
            default {}
    }
    
    # Update the internal list with the current text so that we can run calculations on it.
    #$tbl cellconfigure $row,$col
    #eAssistSetup::saveHeaderParams
    ${log}::debug executing saveHeaderParams...
    eAssistSetup::saveHeaderParams
    return $text

    ${log}::debug --END-- [info level 1]
} ;# eAssistSetup::endCmdHdr


proc eAssistSetup::populateComboBox {} {
    #****f* populateComboBox/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Grabs the header names, to populate the combobox, so we can assign additional 'like' headers.
    #
    # SYNOPSIS
    #
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
    global log w headerParams headerParent
    ${log}::debug --START -- [info level 1]
    
    set headerParent(headerList) [$w(hdr_frame1a).listbox getcells 0,1 end,1]
    
    if {[lrange $headerParent(headerList) end end] == "{}"} {
        #Remove the last list item, since it is empty.
        set headerParent(headerList) [lrange $headerParent(headerList) 0 end-1]
    }
    
    $w(hdr_frame1b).cbox1 configure -values $headerParent(headerList)
    
    eAssistSetup::saveHeaderParams
    
    ${log}::debug --END -- [info level 1]
} ;# eAssistSetup::populateComboBox


proc eAssistSetup::saveHeaderParams {} {
    #****f* saveHeaderParams/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Save the header, and header parameters
    #
    # SYNOPSIS
    #
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	eAssistSetup::populateComboBox, eAssistSetup::SaveGlobalSettings
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global log w headerParams 
    ${log}::debug --START-- [info level 1]
    
	set rCount [expr {[llength [$w(hdr_frame1a).listbox getcells 0,0 end,0]]} -1]
    for {set row 0} {$row <= $rCount} {incr row} {
        ${log}::debug Header Name, then the rest of the params
        ${log}::debug HEADER/PARAMS: [$w(hdr_frame1a).listbox getcells $row,1 $row,1] [$w(hdr_frame1a).listbox getcells $row,2 $row,end]
        
            if {[lrange [$w(hdr_frame1a).listbox getcells $row,1 $row,1] end end] != "{}"} {
                #Remove the last list item, since it is empty.
                set headerParams([$w(hdr_frame1a).listbox getcells $row,1 $row,1]) [$w(hdr_frame1a).listbox getcells $row,2 $row,end]
            } else {
                ${log}::debug Last line is blank, skipping...
            }
    }
    
    ${log}::debug --END-- [info level 1]
} ;# eAssistSetup::saveHeaderParams
