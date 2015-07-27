# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 10/8/2013

proc eAssistSetup::distributionTypes_GUI {} {
    #****f* distributionTypes_GUI/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	
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
    global log G_setupFrame currentModule dist
    global GUI w

    eAssist_Global::resetSetupFrames ;# Reset all frames so we start clean
    
    ##
    ## Parent Frame
    ##

    set w(dist_frame1) [ttk::labelframe $G_setupFrame.frame1 -text [mc "Distribution Types"]]
    pack $w(dist_frame1) -expand yes -fill both -ipadx 5p -ipady 5p
    

    ttk::label $w(dist_frame1).label1 -text [mc "Distribution Type Name"]
    ttk::entry $w(dist_frame1).entry1 -width 30
	
	ttk::button $w(dist_frame1).btn1 -text [mc "Add"] -command {eAssistSetup::modifyDistTypes add $w(dist_frame1).entry1 $w(dist_frame1).lbox1 DistTypeName DistributionTypes}
    ttk::button $w(dist_frame1).btn2 -text [mc "Delete"] -command {eAssistSetup::modifyDistTypes delete $w(dist_frame1).entry1 $w(dist_frame1).lbox1 DistTypeName DistributionTypes}   
    
	listbox $w(dist_frame1).lbox1 -height 20 \
                -width 30 \
                -selectbackground yellow \
                -selectforeground black \
                -selectmode single \
                -yscrollcommand [list $w(dist_frame1).scrolly set] \
                -xscrollcommand [list $w(dist_frame1).scrollx set]

    ttk::scrollbar $w(dist_frame1).scrolly -orient v -command [list $w(dist_frame1).listbox yview]
    ttk::scrollbar $w(dist_frame1).scrollx -orient h -command [list $w(dist_frame1).listbox xview]
    
    grid $w(dist_frame1).scrolly -column 1 -row 0 -sticky nse
    grid $w(dist_frame1).scrollx -column 0 -row 1 -sticky ews

    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $w(dist_frame1).scrolly
    ::autoscroll::autoscroll $w(dist_frame1).scrollx
    
    #
    #-------- Grid Frame 1a
    #
    grid $w(dist_frame1).label1 -column 0 -row 0
    grid $w(dist_frame1).entry1 -column 1 -row 0
    grid $w(dist_frame1).btn1 -column 2 -row 0
    
    grid $w(dist_frame1).lbox1 -column 1 -row 1 -sticky news
    grid $w(dist_frame1).btn2 -column 2 -row 1 -sticky new
	
	## ------
	## Commands
	# Populate the listbox
	ea::db::getDistTypes $w(dist_frame1).lbox1
    
    
	
} ;# eAssistSetup::distributionTypes_GUI

proc eAssistSetup::modifyDistTypes {method widEntryField widListbox cols dbTable} {
    #****f* addToDistTypes/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	
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
    global log dist
    
    #$lbox insert end $distType
    #set dist(distributionTypes) [$lbox get 0 end]
    #
    #$entryField delete 0 end
	
	set values [list [$widEntryField get]]
	${log}::debug VALUES: $values
	
	switch -- $method {
		add		{
			# Add to DB
			eAssist_db::dbInsert -columnNames $cols -table $dbTable -data $values
			# Remove value from the entry widget
			$widEntryField delete 0 end
		}
		delete	{
			set values [$widListbox get [$widListbox curselection]]
			eAssist_db::delete $dbTable $cols $values
		}
		default {${log}::debug [info level 1] $method isn't a valid option}
	}
		
		# Refresh list
		ea::db::getDistTypes $widListbox
	
} ;# eAssistSetup::addToDistTypes


proc ea::db::getDistTypes {widListbox} {
    #****f* getDistTypes/ea::db
    # CREATION DATE
    #   10/24/2014 (Friday Oct 24)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::db::getDistTypes  
    #
    # FUNCTION
    #	Retrieves the list of Distribution Types
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

    $widListbox delete 0 end
	
	foreach item [eAssist_db::dbSelectQuery -columnNames DistTypeName -table DistributionTypes] {
		$widListbox insert end $item
	}
    
} ;# ea::db::getDistTypes
