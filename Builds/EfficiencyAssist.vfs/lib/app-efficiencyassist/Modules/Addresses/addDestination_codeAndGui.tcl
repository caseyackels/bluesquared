# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 11 07,2013
# Dependencies:  
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 421 $
# $LastChangedBy: casey.ackels@gmail.com $
# $LastChangedDate: 2015-03-04 19:02:39 -0800 (Wed, 04 Mar 2015) $
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


proc eAssistHelper::addDestination {tblPath {id -1}} {
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
    global log dist w carrierSetup packagingSetup shipOrder job
	#ttk::style map TCombobox -fieldbackground {!focus yellow}
	#ttk::style configure TEntry -fieldbackground {!focus yellow}
	#ttk::style map TEntry -fieldbackground {focus yellow}
	#ttk::style configure Highlight.TEntry -fieldbackground {focus yellow}
	#ttk::style map Highlight.TEntry -fieldbackground {focus yellow}
#	
#	ttk::style element create highlight.field from default
#	
##	ttk::style layout Highlight.Entry {
##        Highlight.Entry.highlight.field -sticky nswe -border 0 -children {
##             Highlight.Entry.padding -sticky nswe -children {
##                 Highlight.Entry.textarea -sticky nswe
##             }
##         }
##     }
#	ttk::style layout Highlight.Entry {
#        Highlight.Entry.highlight.field -sticky nswe -border 0 -children {
#             Highlight.Entry.padding -sticky nswe -children {
#                 Highlight.Entry.textarea -sticky nswe
#             }
#         }
#     }
#	#Entry.field -sticky nswe -children {Entry.background -sticky nswe -children {Entry.padding -sticky nswe -children {Entry.textarea -sticky nswe}}}
#	# Configure the colour and padding for our new style.
#    ttk::style configure Highlight.Entry -background \
#		{*}[ttk::style configure TEntry -fieldbackground]
#     
#	ttk::style map Highlight.Entry {*}[ttk::style map TEntry] \
#         -fieldbackground {focus yellow}

#	image create photo border -width 20 -height 20
#	#border put red -to 0 0 19 19
#	#border put white -to 2 2 17 17
#	border put red -to 0 0 19 19
#	border put white -to 2 2 17 17
#	
#	ttk::style element create Redborder image border -border 3
#	
#	ttk::style layout test.TEntry {
#	  Redborder -sticky nswe -border 0 -children {
#		Entry.padding -sticky nswe -children {
#		  Entry.textarea -sticky nswe
#		}
#	  }
#	}
#	
#	image create photo border2 -width 20 -height 20
#	#border put red -to 0 0 19 19
#	#border put white -to 2 2 17 17
#	border put blue -to 0 0 19 19
#	border put white -to 2 2 17 17
#	
#	ttk::style element create Whiteborder image border2 -border 3
#	#
#	#ttk::style layout wBorder.TEntry {
#	#  Whiteborder -sticky nswe -border 1 -children {
#	#	Entry.padding -sticky nswe -children {
#	#	  Entry.textarea -sticky nswe
#	#	}
#	#  }
#	#}
#	
##	ttk::style map TEntry {*}[ttk::style map TEntry] \
##         -fieldbackground {focus yellow}
#    
#	ttk::style map test.TEntry {
#	  Whiteborder -sticky nswe -border 1 -children {
#		Entry.padding -sticky nswe -children {
#		  Entry.textarea -sticky nswe
#		}
#	  }
#	}
#	
#	ttk::style map test.TEntry {
#	  Redborder -sticky nswe -border 0 -children {
#		Entry.padding -sticky nswe -children {
#		  Entry.textarea -sticky nswe
#		}
#	  }
#	}
	
	if {![info exists job(db,Name)]} {${log}::notice Tried to open "Add Destination" without an active job; return}
	if {$id != -1} {
		# We're editing an existing row ...
		# Populate the shipOrder array
		${log}::debug Editing DB Row $id
		eAssistHelper::loadShipOrderArray $job(db,Name) Addresses $id
	} else {
		# Reset Ship Order array
		eAssistHelper::initShipOrderArray
	}
	
	
    set win [eAssist_Global::detectWin -k .dest]
    #${log}::debug Current Window: $win
    toplevel $win
    wm transient $win .
    wm title $win [mc "Add Destination"]

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    wm geometry $win +${locX}+${locY}

	
    # ----- Frame 1
	set w(dest) [ttk::frame $win.frame1]
	pack $w(dest) -fill both -expand yes  -pady 5p -padx 5p
	
    
    ttk::button $w(dest).btn1 -text [mc "Select an Address..."] -command {} -state disabled
    ttk::checkbutton $w(dest).chkbtn1 -text [mc "Save to Address Book"] -state disabled
	
	grid $w(dest).btn1 -column 0 -row 0 -sticky w -padx 3p -pady 3p
    grid $w(dest).chkbtn1 -column 1 -row 0 -sticky w -padx 3p -pady 1p -columnspan 2
	
	##
	## - Consignee Frame
	set w(dest,1) [ttk::labelframe $w(dest).frame1a -text [mc "Consignee"] -padding 10]
	grid $w(dest,1) -column 0 -row 1 -padx 2p -sticky n
    
	ttk::label $w(dest,1).reqCompany -text [mc "Company"] ;#-foreground red
	ttk::entry $w(dest,1).getCompany -textvariable shipOrder(Company)

	focus $w(dest,1).getCompany
	
	ttk::label $w(dest,1).txt1 -text [mc "Attention"]
	ttk::entry $w(dest,1).getAttention -textvariable shipOrder(Attention)

	ttk::label $w(dest,1).reqAddress1 -text [mc "Address1"] ;#-foreground red
	ttk::entry $w(dest,1).getAddress1 -textvariable shipOrder(Address1)
    
    ttk::label $w(dest,1).txt3a -text [mc "Address2"]
	ttk::entry $w(dest,1).getAddress2 -textvariable shipOrder(Address2)
	
	ttk::label $w(dest,1).txt4 -text [mc "Address3"]
	ttk::entry $w(dest,1).getAddress3 -textvariable shipOrder(Address3)
	
	ttk::label $w(dest,1).reqCity -text [mc "City"] ;#-foreground red
	ttk::entry $w(dest,1).getCity -textvariable shipOrder(City)
    
    ttk::label $w(dest,1).reqState -text [mc "State"] ;#-foreground red
	ttk::entry $w(dest,1).getState -textvariable shipOrder(State) -width 4
    
    ttk::label $w(dest,1).reqZip -text [mc "Zip"] ;#-foreground red
	ttk::entry $w(dest,1).getZip -textvariable shipOrder(Zip) -width 15
	
	ttk::label $w(dest,1).reqCountry -text [mc "Country"]
	ttk::entry $w(dest,1).getCountry -textvariable shipOrder(Country) -width 3
	
	ttk::label $w(dest,1).txt6 -text [mc "Phone"]
	ttk::entry $w(dest,1).phone -textvariable shipOrder(Phone)
	
    
    ttk::label $w(dest,1).txt8 -text [mc "Email"]
    ttk::entry $w(dest,1).email -textvariable shipOrder(Email)
	
	#----- Grid
	grid $w(dest,1).reqCompany -column 0 -row 2 -padx 1p -pady 1p -sticky nes
	grid $w(dest,1).getCompany -column 1 -row 2 -padx 1p -pady 1p -sticky news -columnspan 3
	
	grid $w(dest,1).txt1 -column 0 -row 3 -padx 1p -pady 2p -sticky nes
	grid $w(dest,1).getAttention -column 1 -row 3 -padx 1p -pady 1p -sticky news -columnspan 3 
	
	grid $w(dest,1).reqAddress1 -column 0 -row 4 -padx 1p -pady 1p -sticky nes
	grid $w(dest,1).getAddress1 -column 1 -row 4 -padx 1p -pady 1p -sticky news -columnspan 3 
    
    grid $w(dest,1).txt3a -column 0 -row 5 -padx 1p -pady 1p -sticky nes
	grid $w(dest,1).getAddress2 -column 1 -row 5 -padx 1p -pady 1p -sticky news  -columnspan 3 
	
	grid $w(dest,1).txt4 -column 0 -row 6 -padx 1p -pady 1p -sticky nes
	grid $w(dest,1).getAddress3 -column 1 -row 6 -padx 1p -pady 1p -sticky news -columnspan 3 
	
	grid $w(dest,1).reqCity -column 0 -row 7 -padx 1p -pady 1p -sticky nes
	grid $w(dest,1).getCity -column 1 -row 7 -padx 1p -pady 1p -sticky news -columnspan 3
    
    grid $w(dest,1).reqState -column 0 -row 8 -padx 1p -pady 1p -sticky nes
	grid $w(dest,1).getState -column 1 -row 8 -padx 1p -pady 1p -sticky w
    
    grid $w(dest,1).reqZip -column 2 -row 8 -padx 1p -pady 1p -sticky nes
	grid $w(dest,1).getZip -column 3 -row 8 -padx 1p -pady 1p -sticky w
	
	grid $w(dest,1).reqCountry -column 0 -row 9 -padx 1p -pady 1p -sticky nes
	grid $w(dest,1).getCountry -column 1 -row 9 -padx 1p -pady 1p -sticky ew
	
	grid $w(dest,1).txt6 -column 0 -row 10 -padx 1p -pady 1p -sticky nes
	grid $w(dest,1).phone -column 1 -row 10 -padx 1p -pady 1p -sticky ew -columnspan 3
        
    grid $w(dest,1).txt8 -column 0 -row 11 -padx 1p -pady 1p -sticky nes
    grid $w(dest,1).email -column 1 -row 11 -padx 1p -pady 1p -sticky news -columnspan 3
	
	##
	## - Shipment Info Frame
	set w(dest,2) [ttk::labelframe $w(dest).frame1b -text [mc "Shipment"] -padding 10]
	grid $w(dest,2) -column 1 -row 1 -padx 3p -sticky n
	
	ttk::label $w(dest,2).reqVersion -text [mc "Version"]
	ttk::combobox $w(dest,2).getVersion -values [$job(db,Name) eval "SELECT distinct(VERSION) from ADDRESSES"] \
												-textvariable shipOrder(Version)
	
	ttk::label $w(dest,2).reqQuantity -text [mc "Quantity"]
	ttk::entry $w(dest,2).getQuantity -textvariable shipOrder(Quantity)
	
	ttk::label $w(dest,2).txt1 -text [mc "Notes"]
	ttk::entry $w(dest,2).notes -textvariable shipOrder(Notes)
	
	ttk::label $w(dest,2).reqDistributionType -text [mc "Distribution Type"] ;#-foreground red
    ttk::combobox $w(dest,2).getDistributionType -values $dist(distributionTypes) \
												-width 40 \
												-state readonly \
												-textvariable shipOrder(DistributionType) \
	
	ttk::label $w(dest,2).reqShipVia -text [mc "Ship Via"]
	ttk::combobox $w(dest,2).getShipVia -values $carrierSetup(ShipViaName) \
												-width 40 \
												-state readonly \
												-textvariable shipOrder(ShipVia)
	
	ttk::label $w(dest,2).reqShippingClass -text [mc "Shipping Class"]
	ttk::combobox $w(dest,2).getShippingClass -values $carrierSetup(ShippingClass) \
												-width 40 \
												-state readonly \
												-textvariable shipOrder(ShippingClass)
	
	ttk::label $w(dest,2).txt2 -text [mc "Package"]
	ttk::combobox $w(dest,2).getPackage -values $packagingSetup(PackageType) \
												-width 40 \
												-state readonly \
												-textvariable shipOrder(PackageType)
	
	ttk::label $w(dest,2).txt3 -text [mc "Container"]
	ttk::combobox $w(dest,2).getContainer -values $packagingSetup(ContainerType) \
												-width 40 \
												-state readonly \
												-textvariable shipOrder(ContainerType)
	
	ttk::label $w(dest,2).txt4 -text [mc "Ship Date"]
	ttk::entry $w(dest,2).shipDate -textvariable shipOrder(ShipDate)
	
	ttk::label $w(dest,2).txt5 -text [mc "Arrive Date"]
	ttk::entry $w(dest,2).arriveDate -textvariable shipOrder(ArriveDate)
    
	## ---- GRID
	grid $w(dest,2).reqVersion -column 0 -row 0 -padx 1p -pady 1p -sticky nes
	grid $w(dest,2).getVersion -column 1 -row 0 -padx 1p -pady 1p -sticky news
	
	grid $w(dest,2).reqQuantity -column 0 -row 1 -padx 1p -pady 1p -sticky nes
	grid $w(dest,2).getQuantity -column 1 -row 1 -padx 1p -pady 1p -sticky news
	
	grid $w(dest,2).txt1 -column 0 -row 2 -padx 1p -pady 1p -sticky nes
	grid $w(dest,2).notes -column 1 -row 2 -padx 1p -pady 1p -sticky news
	
	grid $w(dest,2).reqDistributionType -column 0 -row 3 -padx 1p -pady 1p -sticky nes
    grid $w(dest,2).getDistributionType -column 1 -row 3 -padx 1p -pady 1p -sticky news
	
	grid $w(dest,2).reqShipVia -column 0 -row 4 -padx 1p -pady 1p -sticky nes
	grid $w(dest,2).getShipVia -column 1 -row 4 -padx 1p -pady 1p -sticky news
	
	grid $w(dest,2).reqShippingClass -column 0 -row 5 -padx 1p -pady 1p -sticky nes
	grid $w(dest,2).getShippingClass -column 1 -row 5 -padx 1p -pady 1p -sticky news
	
	grid $w(dest,2).txt2 -column 0 -row 6 -padx 1p -pady 1p -sticky nes
	grid $w(dest,2).getPackage -column 1 -row 6 -padx 1p -pady 1p -sticky news
	
	grid $w(dest,2).txt3 -column 0 -row 7 -padx 1p -pady 1p -sticky nes
	grid $w(dest,2).getContainer -column 1 -row 7 -padx 1p -pady 1p -sticky news
	
	grid $w(dest,2).txt4 -column 0 -row 8 -padx 1p -pady 1p -sticky nes
	grid $w(dest,2).shipDate -column 1 -row 8 -padx 1p -pady 1p -sticky nws
	
	grid $w(dest,2).txt5 -column 0 -row 9 -padx 1p -pady 1p -sticky nes
	grid $w(dest,2).arriveDate -column 1 -row 9 -padx 1p -pady 1p -sticky nws
	
	
    # ---- BUTTON BAR
    set btnbar [ttk::frame $win.btnbar]
    pack $btnbar -pady 5 -padx 10p -anchor se
    
	ttk::button $btnbar.close -text [mc "Cancel"] -command [list destroy $win]
    ttk::button $btnbar.save -text [mc "Save"] -command [list eAssistHelper::saveDest $id $tblPath $job(db,Name) Addresses] -state disabled
	
    #--------- Grid
    grid $btnbar.close -column 0 -row 0 -sticky news -padx 5p -pady 5p
    grid $btnbar.save -column 1 -row 0 -sticky news -pady 5p
	
    
    #------- Set text color
	set parentWid [list $w(dest,1) $w(dest,2)]
	eAssistHelper::initFGTextColor $w(dest,1) $w(dest,2)
	
	#------- Bindings
	foreach wid $parentWid {
		${log}::debug Looking at $wid
		#set widChild [winfo children $wid]
		foreach child [winfo children $wid] {
			#${log}::debug Looking at $child
			if {[winfo class $child] eq "TEntry"} {

				if {[string match *.get* $child]} {
					#${log}::debug Adding a binding to: $child
					bind $child <KeyRelease> [subst {eAssistHelper::detectData $child $btnbar.save "$parentWid"}]
				}
			} elseif {[winfo class $child] eq "TCombobox"} {
				#${log}::debug Adding a binding to: $child
				bind $child <KeyRelease> [subst {eAssistHelper::detectData $child $btnbar.save "$parentWid"}]
				bind $child <<ComboboxSelected>> [subst {eAssistHelper::detectData $child $btnbar.save "$parentWid"}]
			}
		}
	}
    
} ;# End eAssistHelper::addDestination



proc eAssistHelper::detectData {child btn parentWid} {
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
	
	set labelPath [string map {get req} $child]
	
	# This is true, when the txt label doesn't match up to to the entry/combobox path name (has 'req' in the name)
	if {![winfo exists $labelPath]} {return}
	
	if {[$child get] != ""} {
        #${log}::debug Entry has data, turn txt to black.
        $labelPath configure -foreground black
    } else {
        #${log}::debug Entry does NOT have data
        $labelPath configure -foreground red
    }

	
	eAssistHelper::setBGColor $labelPath $btn $parentWid


} ;# eAssistHelper::detectData


proc eAssistHelper::setBGColor {labelPath btn parentWid} {
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

	#set parentWid [list $w(dest,1) $w(dest,2)]
	if {[info exists fail]} {unset fail}
	foreach wid $parentWid {
		foreach child [winfo children $wid] {
			#${log}::debug Looking at $child
			if {[winfo class $child] eq "TLabel"} {
				#puts $child
				if {[string match *.req* $child] && [$child cget -foreground] eq "red"} {
					#${log}::debug $child is RED
					lappend fail yes
				} elseif {[string match *.req* $child] && [$child cget -foreground] eq "black"} {
					#${log}::debug $child [$child cget -foreground]
					lappend fail no
				}
			}
		}
	}
    
    if {[lsearch $fail yes] == -1} {
		#${log}::debug FAIL = $fail
		$btn configure -state normal
	} else {
		$btn configure -state disabled
	}
} ;# eAssistHelper::setBGColor

proc eAssistHelper::initFGTextColor {args} {
    #****f* initFGTextColor/eAssistHelper
    # CREATION DATE
    #   03/01/2015 (Sunday Mar 01)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistHelper::initBGTextColor args 
    #
    # FUNCTION
    #	Init the text color on required widgets
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
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log

	# Cycle through each parent
    foreach wid $args {
		#${log}::debug Looking at $wid
		# Cycle through the children per parent
		foreach child [winfo children $wid] {
			# Only look at children that have TLabel as their class
			if {[winfo class $child] eq "TLabel"} {
				# Ensure it is a label that we deem 'required' with 'req' in the name.
				if {[string match *.req* $child]} {
					# It's required, now lets see if the entry widget has any data. If it doesn't, set it to Red.
					if {[[string map {req get} $child] get] == ""} {
						$child configure -foreground red
					}
				}
			}
		}
	}

    
} ;# eAssistHelper::initFGTextColor


proc eAssistHelper::saveDest {id tblPath db dbTbl} {
    #****f* saveDest/eAssistHelper
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
    global log program shipOrder job headerParent

	if {$id != -1} {
		## -- We are updating a record
		#${log}::debug ID = $id
		if {[info exists updateStatement] || [info exists headers]} {unset updateStatement; unset headers}
		set headers [list \$OrderNumber] ;# Order Number is not part of the general header names, this perhaps, should be changed... It is our index in the Addresses Table
		foreach hdr $headerParent(headerList) {
			lappend updateStatement $hdr='$shipOrder($hdr)'
			lappend headers $$hdr
		}
		#${log}::debug Update Statement: $db eval "UPDATE $dbTbl SET [join $updateStatement ,] WHERE rowid=$id"
		$db eval "UPDATE $dbTbl SET [join $updateStatement ,] WHERE rowid=$id"
		
		set tblID [expr {$id - 1}]
		foreach hdr $headerParent(headerList) {
			$tblPath cellconfigure $tblID,$hdr -text $shipOrder($hdr)
		}

	} else {
		## -- We are adding a new record
		if {[info exists insertRow]} {unset insertRow}
		foreach hdr $headerParent(headerList) {
			lappend insertRow '$shipOrder($hdr)'
		}
	
		$job(db,Name) eval "INSERT OR ABORT INTO $dbTbl ([join $headerParent(headerList) ,]) VALUES ([join $insertRow ,])"
	
		set rowID [$db last_insert_rowid]
		$tblPath insert end [$db eval "SELECT * FROM $dbTbl where rowid=$rowID"]
	}
	
	# Apply the highlights ... Technically we should also prevent the user from entering too much data into each field.
	importFiles::highlightAllRecords $tblPath
	
    # Get total copies
    set job(TotalCopies) [ea::db::countQuantity $job(db,Name) Addresses]
} ;# eAssistHelper::saveDest

