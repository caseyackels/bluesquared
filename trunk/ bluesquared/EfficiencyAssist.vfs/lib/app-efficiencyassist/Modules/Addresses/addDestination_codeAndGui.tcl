# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 11 07,2013
# Dependencies:  
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision$
# $LastChangedBy$
# $LastChangedDate$
#
########################################################################################

##
## - Overview
# Creates a window to add a new destination, instead of reimporting the source file.
# ---- This file contains GUI and BACKEND code

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


proc eAssistHelper::addDestination {tblPath} {
    #****f* addDestination/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	eAssistHelper::addDestination <tblPath>
    #	tblPath is the path where you want the address inserted.
    #
    # SYNOPSIS
    #	Adds a destination to the master list, so it can easily be added to the file instead of reimporting the file
    #	This will probably only be helpful for internal "addresses", as you would want to re-import the customers source file, if they made any changes.
    #
    #	If an address is typed in, clicking the save button will insert it into the table, and save it to the master destination table.
    #   If an address is selected, it is only inserted into the table, unless it is modified; then the original address is removed from the  
    #
    # CHILDREN
    #	eAssistHelper::detectData
    #
    # PARENTS
    #	
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global log dist w
    ${log}::debug --START -- [info level 1]
    #ttk::style map TCombobox -fieldbackground [list focus yellow]
    #ttk::style map TEntry -fieldbackground [list focus yellow]
    
    set win [eAssist_Global::detectWin -k .dest]
    ${log}::debug Current Window: $win
    toplevel $win
    wm transient $win .
    wm title $win [mc "Add Destination"]

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    wm geometry $win +${locX}+${locY}

    focus $win
	
    # ----- Frame 1
	set w(dest) [ttk::frame $win.frame1]
	pack $w(dest) -fill both -expand yes  -pady 5p -padx 5p
    
    ttk::button $w(dest).btn1 -text [mc "Select an Address..."] -command {} -state disabled
    ttk::checkbutton $w(dest).chkbtn1 -text [mc "Save to Address Book"]

    ttk::label $w(dest).reqDistType -text [mc "Distribution Type"] -foreground red
    ttk::combobox $w(dest).cbox1 -values $dist(distributionTypes) \
                                -width 40 \
                                -state readonly \
                                -textvariable newAddr(distType) \
                                -postcommand {}
    
    ttk::label $w(dest).txt1 -text [mc "Attention"]
	ttk::entry $w(dest).getAttention -textvariable newAddr(Attention)
	
	ttk::label $w(dest).reqCompany -text [mc "Company"] -foreground red
	ttk::entry $w(dest).getCompany -textvariable newAddr(Company)
	
	ttk::label $w(dest).reqAddress1 -text [mc "Address1"] -foreground red
	ttk::entry $w(dest).getAddress1 -textvariable newAddr(Address1)
    
    ttk::label $w(dest).txt3a -text [mc "Address2"]
	ttk::entry $w(dest).getAddress2 -textvariable newAddr(Address2)
	
	ttk::label $w(dest).txt4 -text [mc "Address3"]
	ttk::entry $w(dest).getAddress3 -textvariable newAddr(Address3)
	
	ttk::label $w(dest).reqCity -text [mc "City"] -foreground red
	ttk::entry $w(dest).getCity -textvariable newAddr(City)
    
    ttk::label $w(dest).reqState -text [mc "State"] -foreground red
	ttk::entry $w(dest).getState -textvariable newAddr(State) -width 4
    
    ttk::label $w(dest).reqZip -text [mc "Zip"] -foreground red
	ttk::entry $w(dest).getZip -textvariable newAddr(Zip) -width 10
	
	ttk::label $w(dest).txt6 -text [mc "Phone/Country"]
	ttk::entry $w(dest).getPhone -textvariable newAddr(Phone)
	ttk::entry $w(dest).getCountry -textvariable newAddr(Country) -width 3
    
    ttk::label $w(dest).txt8 -text [mc "Email"]
    ttk::entry $w(dest).getEmail -textvariable newAddr(Email)
	
	#----- Grid
    grid $w(dest).btn1 -column 1 -row 0 -sticky w -padx 3p -pady 3p
    grid $w(dest).chkbtn1 -column 2 -row 0 -sticky w -padx 3p -pady 1p
    
    grid $w(dest).reqDistType -column 0 -row 1 -sticky nes -padx 3p -pady 2p
    grid $w(dest).cbox1 -column 1 -row 1 -columnspan 3 -padx 2p -pady 1p -sticky news
    
	grid $w(dest).txt1 -column 0 -row 2 -sticky nes -padx 3p -pady 2p
	grid $w(dest).getAttention -column 1 -columnspan 3 -row 2 -padx 2p -pady 1p -sticky news
		
	grid $w(dest).reqCompany -column 0 -row 3 -sticky nes -padx 3p -pady 2p
	grid $w(dest).getCompany -column 1 -columnspan 3 -row 3 -padx 2p -pady 1p -sticky news
	
	grid $w(dest).reqAddress1 -column 0 -row 4 -sticky nes -padx 3p -pady 2p
	grid $w(dest).getAddress1 -column 1 -columnspan 3 -row 4 -padx 2p -pady 1p -sticky news
    
    grid $w(dest).txt3a -column 0 -row 5 -sticky nes -padx 2p -pady 2p
	grid $w(dest).getAddress2 -column 1 -columnspan 3 -row 5 -padx 2p -pady 1p -sticky news
	
	grid $w(dest).txt4 -column 0 -row 6 -sticky nes -padx 3p -pady 2p
	grid $w(dest).getAddress3 -column 1 -columnspan 3 -row 6 -padx 2p -pady 1p -sticky news
	
	grid $w(dest).reqCity -column 0 -row 7 -sticky nes -padx 3p -pady 2p
	grid $w(dest).getCity -column 1 -columnspan 3 -row 7 -padx 1p -pady 1p -sticky news
    
    grid $w(dest).reqState -column 0 -row 8 -padx 3p -pady 2p -sticky nes
	grid $w(dest).getState -column 1 -columnspan 3 -row 8 -padx 1p -pady 1p -sticky w
    
    grid $w(dest).reqZip -column 0 -row 9 -padx 3p -pady 2p -sticky nes
	grid $w(dest).getZip -column 1 -row 9 -columnspan 3 -padx 1p -pady 1p -sticky w
	
	grid $w(dest).txt6 -column 0 -row 10 -sticky nes -padx 3p -pady 2p
	grid $w(dest).getPhone -column 1 -row 10 -padx 1p -pady 1p -sticky news
	grid $w(dest).getCountry -column 2 -row 10 -pady 1p -sticky news
        
    grid $w(dest).txt8 -column 0 -row 11 -sticky nes -padx 3p -pady 2p
    grid $w(dest).getEmail -column 1 -columnspan 3 -row 11 -padx 2p -pady 1p -sticky news
	
    # ---- BUTTON BAR
    set btnbar [ttk::frame $win.btnbar]
    pack $btnbar -pady 5 -padx 10p -anchor se
    
	ttk::button $btnbar.close -text [mc "Close"] -command [list destroy $win]
    ttk::button $btnbar.save -text [mc "Save"] -command [list eAssistHelper::saveNewDest $w(dest) $tblPath] -state disabled
	
    #--------- Grid
    grid $btnbar.close -column 0 -row 0 -sticky news -padx 5p -pady 5p
    grid $btnbar.save -column 1 -row 0 -sticky news -pady 5p
	
    
    #------- Bindings
    set reqWin [list getCompany getAddress1 getCity getState getZip]
    foreach win $reqWin {
        bind $w(dest).$win <KeyRelease> "eAssistHelper::detectData $win $btnbar.save"
        ${log}::debug BIND - $w(dest).$win <KeyRelease> "eAssistHelper::detectData $win"
    }
    
    bind $w(dest).cbox1 <<ComboboxSelected>> "eAssistHelper::detectData cbox1 $btnbar.save"
    
    ${log}::debug --END -- [info level 1]
} ;# End eAssistHelper::addDestination



proc eAssistHelper::detectData {args} {
    #****f* detectData/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	eAssistHelper:detectData <args> ?args...?
    #
    # SYNOPSIS
    #   This is used in a Binding
    #
    # CHILDREN
    #	eAssistHelper::setBGColor
    #
    # PARENTS
    #	
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global log unlockBtn
    ${log}::debug --START-- [info level 1]
    
    #if {[info exists tempVars]} {unset tempVars}
    #
    ## Setup the tmp array
    #if {![info exists tempVars]} {
    #    # Detect if we exist, if not set the array.
    #    array set tempVars {
    #        getCompany ""
    #        getAddress1 ""
    #        getCity ""
    #        getState ""
    #        getZip ""
    #        getCbox ""
    #    }
    #    set unlockBtn 0
    #}
    
    set args1 [lindex $args 0]
    set btnPath [lindex $args 1]
    
    switch -- $args1 {
        getCompany     {eAssistHelper::setBGColor getCompany reqCompany $btnPath}
        getAddress1    {eAssistHelper::setBGColor getAddress1 reqAddress1 $btnPath}
        getCity        {eAssistHelper::setBGColor getCity reqCity $btnPath}
        getState       {eAssistHelper::setBGColor getState reqState $btnPath}
        getZip         {eAssistHelper::setBGColor getZip reqZip $btnPath}
        cbox1          {eAssistHelper::setBGColor cbox1 reqDistType $btnPath}
        default        {${log}::debug No known args founds, received this instead: $args}
    }
	
    
    ${log}::debug --END-- [info level 1]
} ;# eAssistHelper::detectData


proc eAssistHelper::setBGColor {args} {
    #****f* setBGColor/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	eAssistHelper::setBGColor <win>
    #
    # SYNOPSIS
    #   Set the foreground color on the text for the required fields
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	eAssistHelper::detectData
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global log w
    ${log}::debug --START-- [info level 1]
    set bgFilled "configure -foreground black"
    set bgEmpty "configure -foreground red"
    
    set win [lindex $args 0]
    set txt [lindex $args 1]
    set btnPath [lindex $args 2]
    
    #${log}::debug win: $win
    #${log}::debug [$w(dest).$win get]
    
    if {[$w(dest).$win get] != ""} {
        ${log}::debug Entry has data, turn txt to black.
        $w(dest).$txt configure -foreground black
    } else {
        ${log}::debug Entry does NOT have data
        $w(dest).$txt configure -foreground red
    }
    
    set fail no
    foreach child [winfo children $w(dest)] {
        if {[string match -nocase *req* $child] == 1} {
            if {[$child cget -foreground] eq "red"} {
                set fail yes
            }
        }
    }
    
    if {$fail eq "no"} {$btnPath configure -state normal}
    
	
    ${log}::debug --END-- [info level 1]
} ;# eAssistHelper::setBGColor


proc eAssistHelper::saveNewDest {win tblPath} {
    #****f* saveNewDest/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Saves all entries from addDestination into the designated table, and also saves the address into the master list which is saved into $program(home)/addressList.txt
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
    global log program newAddr
    ${log}::debug --START -- [info level 1]

    # Gather the paths for the entry widgets, using the prefix of 'get'.
    foreach win1 [winfo children $win] {
        if {[string match *get* $win1] == 1} {
            lappend name [lindex [split $win1 .] 3]
        }
    }
    
    # Set up Column info
    set ColumnCount [$tblPath columncount]
    set ColumnName ""
		for {set x 0} {$ColumnCount > $x} {incr x} {
				lappend ColumnName [$tblPath columncget $x -name]
		}


    set insertRow ""
    # remove the 'get' prefix, match the widget name to the column name, if nothing matches append {} as a placeholder
    # after cycling through all the widget names, insert the list of data.
    
    foreach col $ColumnName {
        if {[lsearch -nocase -glob $name *$col] != -1} {
            set child [lindex $name [lsearch -nocase -glob $name *$col]]
            #${log}::debug Data is: $col _ [lindex $name [lsearch -nocase -glob $name *$col]] _ [$win.$child get]
            lappend insertRow [$win.$child get]
        } else {
            #${log}::debug Data is: $col _ {}
            lappend insertRow {}
        }
    }
    
    #${log}::debug INSERT DATA: $insertRow
    $tblPath insert end $insertRow
	
    ${log}::debug --END -- [info level 1]
} ;# eAssistHelper::saveNewDest

