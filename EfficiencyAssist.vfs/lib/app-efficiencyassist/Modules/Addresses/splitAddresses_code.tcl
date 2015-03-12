# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 10 24,2013
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 421 $
# $LastChangedBy: casey.ackels@gmail.com $
# $LastChangedDate$
#
########################################################################################

##
## - Overview
# Split addresses code

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample



proc eAssistHelper::displayVerQty {cVersion} {
    #****f* displayVerQty/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Display the quantity of the current version
    #
    # SYNOPSIS
    #   eAssistHelper:displayVerQty <textVariable>
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
    global log process files splitVers
    ${log}::debug --START-- [info level 1]
    
    set qty [$files(tab3f2).tbl getcolumn Quantity]
    set vPos [lsearch $process(versionList) $cVersion]    
    set splitVers(totalVersionQty) [lindex $qty $vPos]

    ${log}::debug --END-- [info level 1]
} ;# eAssistHelper::displayVerQty


proc eAssistHelper::splitInsertData {splitTable mainTable} {
    #****f* splitInsertData/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Insert data into the Split table
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
    global log w files
    ${log}::debug --START-- [info level 1]
    
    set ColumnCount [$files(tab3f2).tbl columncount]
    #set showColumns [list Company Contact Zip Quantity]
    
    $w(sVersf2).tbl insertcolumns end 0 ...
    $w(sVersf2).tbl columnconfigure 0 -name "count" -showlinenumbers 1 -labelalign center
    
    # Insert and configure columns
    set x 0
    for {set y 0} {$ColumnCount > $y} {incr y} {
        incr x
        set ColumnName [$files(tab3f2).tbl columncget $y -name]
        $w(sVersf2).tbl insertcolumns end 0 $ColumnName
        
        # Over ride the defaults, since this is not meant to cleanse the data; but to allocate quantities.
        switch -nocase $ColumnName {
            Company         {set vHide no; set vEditable no; set vWindow ttk::entry}
            Attention       {set vHide no; set vEditable no; set vWindow ttk::entry}
            Zip             {set vHide no; set vEditable no; set vWindow ttk::entry}
            Quantity        {set vHide no; set vEditable yes; set vWindow ttk::entry; set qtyPos1 [expr {$x - 2}]; set qtyPos2 $x}
            distributiontype    {set vHide no; set vEditable yes; set vWindow ttk::combobox}
            default         {set vHide yes; set vEditable no; set vWindow ttk::entry}
        }
        #${log}::debug ColumnName: $ColumnName, hide: $vHide, editable: $vEditable, window: $vWindow
        $w(sVersf2).tbl columnconfigure $x -name $ColumnName -labelalign center -editable $vEditable -hide $vHide -editwindow $vWindow      
    }

    # Insert the data
    set dest [$files(tab3f2).tbl getcolumns Company]
    set zip [$files(tab3f2).tbl getcolumns Zip]

    set process(controlDupes) ""
    set z 0
	# We need to cycle through each contact name (decision on this column was arbitrary)
    # Then we make sure it isn't a contact that we've already come across, if is, then we'll skip it.
    foreach contact [$files(tab3f2).tbl getcolumns Attention] {
        # Dupe control
        set currentEntry [list $contact [lindex $dest $z] [lindex $zip $z]]
        
        # Grab the row and add a space, since the first column is just a count field.
        # using the qtyPos variables, we skip the Quantity column.
        set currentRow1 "{} [$files(tab3f2).tbl getcells $z,0 $z,$qtyPos1] {}"
        set currentRow2 [$files(tab3f2).tbl getcells $z,$qtyPos2 $z,end]
        
        if {[lsearch -nocase $process(controlDupes) $currentEntry] == -1} {
            $w(sVersf2).tbl insert end "$currentRow1 $currentRow2"
        }
        
        lappend process(controlDupes) $currentEntry
        incr z
    }
	

    ${log}::debug --END-- [info level 1]
} ;# eAssistHelper::splitInsertData


proc eAssistHelper::editStartSplit {tbl row col text} {
    #****f* editStartSplit/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Start Command for editing the Split table
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
    global log splitVers splitData dist w
    ${log}::debug --START-- [info level 1]
        
		set win [$tbl editwinpath]
		;#eAssistHelper::calcColumn $tbl $col; ${log}::debug calculating ...
        switch -glob [string tolower [$tbl columncget $col -name]] {
            "quantity"		{
						# Reject input if it isn't a number
						if {![string is integer $text]} {
							bell
							tk_messageBox -title "Error" -icon error -message \
							 [mc "Only numbers are allowed"]
							$tbl rejectinput
							return
						}
						
						# .. Grab allocated counts
						${log}::debug Quantity Column: $text - adding text to column qty
						$tbl cellconfigure $row,$col -text $text
						
						set splitVers(allocated) [eAssistHelper::showCurrentVersTotals $w(sVersf2).tbl Quantity]
	
						# .. Calculate how much we have left to allocate
						set splitVers(unallocated) [eAssistHelper::subtAllocatedFromTotal $splitVers(totalVersionQty) $splitVers(allocated)]
						} 
            "distributiontype"  {$win configure -values $dist(distributionTypes) -state readonly}
			default	{}
        }
	
		#${log}::debug SaveData-vers $splitVers(activeVersion)
		#${log}::debug SaveData-data [$w(sVersf2).tbl get 0 end]
		# set array to save the data per version
		set splitData($splitVers(activeVersion)) [$w(sVersf2).tbl get 0 end]

    

    ${log}::debug --END-- [info level 1]
	return $text
} ;# eAssistHelper::editStartSplit


proc eAssistHelper::editEndSplit {tbl row col text} {
    #****f* editEndSplit/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	End Command for editing the Company Sample table
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
    global log splitQty splitVers w
    ${log}::debug --START-- [info level 1]

	switch -glob [string tolower [$tbl columncget $col -name]] {
            "quantity"	{
						# Reject input if it isn't a number
						if {![string is integer $text]} {
							bell
							tk_messageBox -title "Error" -icon error -message \
							 [mc "Only numbers are allowed"]
							$tbl rejectinput
							return
						}
						
						# .. Grab allocated counts
						${log}::debug Quantity Column: $text - adding text to column qty
						$tbl cellconfigure $row,$col -text $text
						
						set splitVers(allocated) [eAssistHelper::showCurrentVersTotals $w(sVersf2).tbl Quantity]
	
						# .. Calculate how much we have left to allocate
						set splitVers(unallocated) [eAssistHelper::subtAllocatedFromTotal $splitVers(totalVersionQty) $splitVers(allocated)]
						} 
			default		{}
    }
    
	${log}::debug New Alloc: $text - $splitVers(allocated)
	${log}::debug Remaining: $text - $splitVers(unallocated)

    ${log}::debug --END-- [info level 1]
	
	return $text
} ;# eAssistHelper::editEndSplit


#proc eAssistHelper::calcColumn {tbl args} {
#    #****f* calcColumn/eAssistHelper
#    # AUTHOR
#    #	Casey Ackels
#    #
#    # COPYRIGHT
#    #	(c) 2011-2013 Casey Ackels
#    #
#    # FUNCTION
#    #	eAssistHelper::calcColumn <args>
#    #
#    # SYNOPSIS
#	#	Calculates a column of data. If it contains data other than numerics this proc will choke on it.
#	#	Args must be either: $col -or- "quantity"
#    #
#    # CHILDREN
#    #	N/A
#    #
#    # PARENTS
#    #	
#    #
#    # NOTES
#	#	To be used in conjunction with a start or end edit command for a tablelist
#	#	This has a dependency on the global variable: splitVers
#	#	**This will only work with the Split Quantity Table!**
#    #
#    # SEE ALSO
#    #
#    #***
#    global log splitVers
#    ${log}::debug --START-- [info level 1]
#	
#	if {[info exists numTotal]} {unset numTotal}
#    
#	# Check to see if the vars contain data, if they don't, then we'll cycle through to find which column contains the Quantity column.
#	if {$args ne "quantity"} {
#		#${log}::debug wasn't called by a binding
#	
#		set colCount [$tbl getcolumns $args]
#		#${log}::debug column count: $colCount
#		
#	} else {
#		for {set x 0} {[$tbl columncount] > $x} {incr x} {
#			if {[string tolower [$tbl columncget $x -name]] eq $args} {
#				set splitVers(idx,Quantity) $x
#				#${log}::debug "Found: [$tbl columncget $x -name]"
#				set colCount [$tbl getcolumns $x]
#			}
#		}
#	}
#	
#	set x 0
#	foreach num $colCount {
#		if {$num ne {}} {
#			${log}::debug String should be integer: $num
#			lappend numTotal $num
#			incr x
#		}
#		#${log}::debug numTotal: $numTotal
#	}
#	
#	#if $x = 0, we know that there is nothing in $colCount as far as integers go
#	if {$x == 0} {set numTotal 0}
#	
#	if {[info exists numTotal]} {
#		${log}::debug total count: $numTotal
#		#${log}::debug [join $numTotal +]
#		${log}::debug [expr [join $numTotal +]]
#		set splitVers(allocated) [expr [join $numTotal +]]
#		set splitVers(unallocated) [expr $splitVers(totalVersionQty) - $splitVers(allocated)]
#	} else {
#		#${log}::debug No data found, set Unallocated to TotalVersionQty
#		set splitVers(unallocated) $splitVers(totalVersionQty)
#	}
#	
#	# Check to see if the splitVers(unallocated) version contains a negative number, if it does turn the text to red.
#	if {$splitVers(unallocated) < 0} {
#		${log}::debug Unallocated is less than zero, change to red!
#		.splitVersions.f2.f2b.txt8 configure -foreground red
#	} else {
#		.splitVersions.f2.f2b.txt8 configure -foreground black
#	}
#	
#	eAssistHelper::saveSplitData
#	
#    ${log}::debug --END-- [info level 1]
#} ;# eAssistHelper::calcColumn


proc eAssistHelper::saveSplitData {tblTo} {
    #****f* saveSplitData/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	eAssistHelper::saveSplitData <tableToInsertInto>
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
    global log w splitData headerParams
    ${log}::debug --START-- [info level 1]

	# Clear out any data that currently exists in the tblTo widget
	$tblTo delete 0 end
	
	foreach vers [array names splitData] {
		# Looping by the Version
		${log}::debug INSERTING: $vers
		
		foreach row $splitData($vers) {
			# Looping per row within Version
			set row [lrange $row 1 end]
			#${log}::debug ROW (Before): $row
			
			set vIdx [$tblTo columnindex Version]
			set vPos [lindex $row $vIdx]
			set row [lreplace $row $vIdx $vIdx $vers]
			
			#${log}::debug ROW (After): $row
			$tblTo insert end $row
		}
	}
	
		
    ${log}::debug --END-- [info level 1]
} ;# eAssistHelper::saveSplitData


proc eAssistHelper::resetQuantityColumn {actVers} {
    #****f* resetQuantityColumn/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	eAssistHelper::resetQuantityColumn
    #
    # SYNOPSIS
    #	Reset column quantities if saved data doesn't exist, if it does insert the saved data.
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
    global log w splitVers splitData
    ${log}::debug --START-- [info level 1]

	# if we've edited this version, lets insert what we've already put in.
	if {[info exists splitData($actVers)]} {

		# Get the column indices
		set colQty [$w(sVersf2).tbl columnindex Quantity]
		set colDist [$w(sVersf2).tbl columnindex DistributionType]
		
		set row 0
		foreach val $splitData($actVers) {
			$w(sVersf2).tbl cellconfigure $row,Quantity -text [lindex $val $colQty] ;# assuming that the Quantity column is the 12th index
			$w(sVersf2).tbl cellconfigure $row,DistributionType -text [lindex $val $colDist] ;# assuming that the Quantity column is the 12th index
			incr row
		}
	} else {
		# Remove Data if nothing exists ... (this will happen when we are going through the versions for the first time)
		set clearColumns [list Quantity]
		foreach col $clearColumns {
			$w(sVersf2).tbl fillcolumn $col ""
		}
	}
	
	#.. Grab allocated counts
	set splitVers(allocated) [eAssistHelper::showCurrentVersTotals $w(sVersf2).tbl Quantity]
   
	#.. Calculate how much we have left to allocate
	set splitVers(unallocated) [eAssistHelper::subtAllocatedFromTotal $splitVers(totalVersionQty) $splitVers(allocated)]
	
	
    ${log}::debug --END-- [info level 1]
} ;# eAssistHelper::resetQuantityColumn
