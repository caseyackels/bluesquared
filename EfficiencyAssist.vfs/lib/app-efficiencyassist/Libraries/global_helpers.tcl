# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 612 $
# $LastChangedBy: casey.ackels@gmail.com $
# $LastChangedDate: 2014-09-12 19:06:03 -0700 (Fri, 12 Sep 2014) $
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

namespace eval eAssist_Global {}

namespace eval ea::tools {}

proc eAssist_Global::resetFrames {args} {
    #****f* resetFrames/eAssist_Global
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Reset frames in the master or preferences so we can switch modes.
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
    global log
    
    switch -- $args {
        parent  {foreach child [winfo children .container] {destroy $child} }
        -pref    {foreach child [winfo children .pref.frame] {destroy $child} }
        default { ${log}::notice No option for $args - resetFrames }
    }
} ;# eAssist_Global::resetFrames


proc eAssist_Global::resetSetupFrames {} {
    #****f* resetSetupFrames/eAssist_Global
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2013 Casey Ackels
    #
    # FUNCTION
    #	Reset frames in the setup window so we can switch modes tree groups.
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
    global savePage
    
    #foreach child [winfo children .container.setup] {
    #    puts $child
    #}
    
    foreach child [winfo children .container.setup] {
        destroy $child
    }
    
    #set savePage $args ;# Allows us to save what is on that page

} ;# eAssist_Global::resetSetupFrames


proc eAssist_Global::checkVars {win {var ""}} {
    #****f* checkVars/eAssist_Global
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	eAssist_Global::checkVars <prefWindow> ?variable? ?msg?
    #
    # SYNOPSIS
	# 	Checks to ensure that the variable exists, if it doesn't, let display a window asking the user if they'd like to launch the Preferences window (or Setup).
	# 	It is possible to check if the var exists prior to this command, in that case, omit the var name in the command.
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
    global log program
    #${log}::debug --START-- [info level 1]
    
	
	if {($var == "") || (![info exists $var])} {
		#${log}::debug Variable doesn't exist ... launching window.
	} else {
		return $var
	}
	
	switch -- $win {
		pref	{set launchWin "eAssistPref::launchPreferences"}
		setup	{set launchWin "eAssist::buttonBarGUI Setup 2"}
		default	{${log}::notice No window was set, aborting.
				return}
	}
	
	set answer [tk_messageBox -title [mc "Additonal configuration needed"] \
					-type yesno \
					-icon error \
					-parent . \
					-detail [mc "Additional options need to be configured, would you like to go there now?\n\n$program(Name) will not be able to function properly until these options are set."]]
	
	switch $answer {
		yes		{$launchWin}
		no		{${log}::debug We Selected NO}
		default	{}
	}
					
	
    #${log}::debug --END-- [info level 1]
} ;# eAssist_Global::checkVars


proc eAssist_Global::widgetState {state win} {
    #****f* widgetState/eAssist_Global
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Control the state of the widgets of the window by passing disabled/normal, and the widget path
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
    global log
    ${log}::debug --START-- [info level 1]
    
    foreach w [winfo children $win] {
		if {$state eq "disabled"} {
			set newState disabled
			set newCommand [list $w state]
		
		} elseif {$state eq "normal"} {
			set newState normal
			set newCommand [list $w configure -state]
		
		} else {
			${log}::critical [info level 1] available arguments are: Disabled, or Normal
			return
		}
	
		${log}::debug STATE: $newState $w
        {*}$newCommand $newState
    }
	
    ${log}::debug --END-- [info level 1]
} ;# eAssist_Global::widgetState

proc eAssist_Global::OpenFile {title initDir type args} {
    #****f* getOpenFile/eAssist_Global
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Allows the user to find the target file or directory; we save it into a variable and pass it back to the originating proc
    #   e.g. set file [eAssist_Global::OpenFile [mc "Pick File"] [pwd] file *.exe]
    #
    # SYNOPSIS
    #	eAssist_Global::OpenFile <title> <initDir> <file|dir> ?fileExtension? ?File Type?
	#	eAssist_Global::OpenFile [mc "Select Directory"] $mySettings(Home) dir 
    #
    # CHILDREN
    #	
    #
    # PARENTS
    #	
    #
    # NOTES
    #
    # SEE ALSO
    #
    #
    #***
	global log
	
	# Set the defaults first, if the programmer specified values, the defaults will be overwritten
	set ext .db
	set ftype {
		{Efficiency Assist Project} {.db}
	}
	
	foreach {item value} $args {
		switch -- $item {
			-ext		{set ext $value}
			-filetype	{set ftype [list $value]}
		}
	}

    if {$type eq "file"} {
        set filename [tk_getOpenFile \
                      -parent . \
                      -title $title \
                      -initialdir $initDir \
                      -defaultextension $ext \
					  -filetypes $ftype]
    } else {
        set filename [tk_chooseDirectory \
                -parent . \
                -title $title \
                -initialdir $initDir -title $title]
        }
	
    # If we do not select a file name, and cancel out of the dialog, do not produce an error.
    if {$filename eq ""} {return}

	${log}::debug filename: "$filename"
    return "$filename"

} ;# eAssist_Global::OpenFile


proc eAssist_Global::SaveFile {fileName {initDir 0}} {
    #****f* SaveFile/eAssist_Global
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	eAssist_Global::SaveFile <file name> ?directory?
    #
    # SYNOPSIS
    #	Save file to specified directory
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
    global log mySettings
    #${log}::debug --START-- [info level 1]
	if {$initDir == 0} {
		if {$mySettings(outFilePath) == ""} {
			set initDir [pwd]
		} else {
			set initDir $mySettings(outFilePath)
		}
	}
	
	set types {
		{{Comma Separated Values}	{.csv}}
	}

	set filename [tk_getSaveFile \
				  -filetypes $types \
				  -defaultextension .csv \
				  -initialdir $initDir \
					-initialfile $fileName \
					-parent . \
					-title [mc "Choose where to save your file"] \
				  ]
	

    # If we do not select a file name, and cancel out of the dialog, do not produce an error.
    if {$filename eq ""} {return}
	
	return $filename
    #${log}::debug --END-- [info level 1]
} ;# eAssist_Global::SaveFile

proc eAssist_Global::detectWin {args} {
    #****f* detectWin/eAssist_Global
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	eAssist_Global <win>
    #
    # SYNOPSIS
    #   Checks to make sure that the window doesn't exist. If it does, that window will be destroyed before creating it again.
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
    global log
    #${log}::debug --START-- [info level 1]
    
    set vSwitch [lindex $args 0]
    set vWindow [lindex $args 1]
    
    if {[winfo exists $vWindow] == 1} {
    # -s, serialize instead of destroying. Multiple instances are ok.
    # -k, destroy the window. We only want one instance active.
        switch -- $vSwitch {
            -s  {#serialize, strip out the first 2 chars, because one of them contain a '.'
                    append vWindow [string range [tcl::mathfunc::rand] 2 end]
                    }
            -k  {#destroy window if it exist
                    destroy $vWindow
                    }
            default { ${log}::notice Arg: $arg, not a valid argument use, -s (serialize), or -k (kill)}
        }
    }
        
    return $vWindow
	
    #${log}::debug --END-- [info level 1]
} ;# eAssist_Global::detectWin

proc eAssist_Global::at {time args} {
    #****f* at/eAssist_Global
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Richard Suchenwith
    #
    # FUNCTION
    #	eAssist_Global::at <time> <command>
    #
    # SYNOPSIS
    #	have a command execute at a certain time
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	
    #
    # NOTES
	# 	Taken from http://wiki.tcl.tk/808
	# 	Original author: RS
    #
    # SEE ALSO
    #
    #***
    global log
    ${log}::debug --START-- [info level 1]
    
	if {[llength $args] == 1} {set args [lindex $args 0]}
    
	set dt [expr {([clock scan $time]-[clock seconds])*1000}]
    
	after $dt $args
	
    ${log}::debug --END-- [info level 1]
} ;# eAssist_Global::at


proc eAssist_Global::getGeom {module args} {
    #****f* getGeom/eAssist_Global
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Executes, or uses the default for the current module
    #
    # SYNOPSIS
    #	getGeom <module> ?args?
	#	Args = qualified geometry eg 450x500+200+200
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
    global log options
    #${log}::debug --START-- [info level 1]
	#${log}::debug CURRENT OPTIONS: $options(geom,$settings(currentModule))
    
	if {[info exists options(geom,$module)]} {
		wm geometry . $options(geom,$module)
		${log}::notice Geometry exists for $module - Using $options(geom,$module)
		
		set dims [split $options(geom,$module) x]
		set dims [split $dims +]
		
		set dims [join $dims]
		#${log}::notice [winfo screenwidth .] == [lindex $dims 0]
		#${log}::notice [winfo screenheight . ] == [lindex $dims 1]

	
		if {[winfo screenheight . ] == [lindex $dims 1]} {
			#wm attributes . -zoomed 1
			wm state . zoomed
			} elseif {[winfo screenwidth .] == [lindex $dims 0]} {
			   #wm attributes . -zoomed 1
			   wm state . zoomed
		}
	} else {
		wm geometry . $args
		${log}::notice Geometry does NOT exist for $module - Using $args
	}
	
	#lib::savePreferences
	
    #${log}::debug --END-- [info level 1]
} ;# eAssist_Global::getGeom


proc eAssist_Global::validate {val validation char args} {
    #****f* validate/eAssist_Global
    # CREATION DATE
    #   10/11/2014 (Saturday Oct 11)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssist_Global::validate %W %d %S args 
    #
    # FUNCTION
    #	Returns validated data
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
	if {$validation == 1} {
		# we only care about prevalidation
		#${log}::debug validation: $d
		#${log}::debug val: $P
		#${log}::debug char: $S
		#set validation $d
		#set val $P
		#set char $S

		set returnValue 1
	} else { return 1}
	
    foreach {key value} $args {
		switch -- $key {
			-length	{ ${log}::debug Length: [string length $val] - $val
					if {$value < [string length $val]} {bell; set returnValue 0; ${log}::debug only $value chars not ([string length $val]), breaking; break}
				}
			-alpha	{ ${log}::debug Alpha: [string is alpha $char] - $char
					if {$value eq "no" & [string is alnum $char] == 1} {bell; set returnValue 0; ${log}::debug NaN, found one - breaking; break}
					
				}
			-space	{ ${log}::debug Space: [string is space $char] - $char
					if {$value eq "no" & [string is space $char] == 1} {bell; set returnValue 0; ${log}::debug No Spaces, found one - breaking; break}
					
				}
			-punc	{ ${log}::debug Punc: [string is punc $char] - $char
					if {$value eq "no" & [string is punc $char] == 1} {bell; set returnValue 0; ${log}::debug No Punctuation, found one - breaking; break}
				}
			-integer	{ ${log}::debug Integer: [string is integer $char] - $char
					if {$value eq "only" & [string is integer $char] == 0} {bell; set returnValue 0; ${log}::debug Integers Only - breaking; break}
				}
			default	{${log}::debug -DEFAULT-}
		}
    }
	
return $returnValue
    
} ;# eAssist_Global::validate


proc ea::tools::modifyButton {wid args} {
    #****f* tools::modifyButton/ea
    # CREATION DATE
    #   10/20/2014 (Monday Oct 20)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::tools::modifyButton args 
    #
    # FUNCTION
    #	Modifies the button based on what was passed
    #	wid = path to the widget
    #	-text New name that the widget should have
    #	-state normal or disabled
    #	-command New command
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

    foreach {key value} $args {
	switch -- $key {
	    -text	{set btnConfig(txt) "-text $value"; ${log}::debug Set btnConfig(txt)}
	    -state	{set btnConfig(state) "-state $value"; ${log}::debug Set btnConfig(state)}
	    -command	{set btnConfig(command) "-command $value"; ${log}::debug Set btnConfig(command)}
	    default	{${log}::notice [info level 1] $key doesn't exist}
	}
    }

    if {[array exists btnConfig]} {
	foreach val [array names btnConfig] {
	    $wid configure {*}$btnConfig($val)
	}
	array unset btnConfig
    }

} ;# ea::tools::modifyButton

proc ea::tools::bindings {wid binding cmd} {
    #****f* bindings/ea::tools
    # CREATION DATE
    #   10/28/2014 (Tuesday Oct 28)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::tools::bindings <wid> {binding1 .. bindingN} {cmd}
    #
    # FUNCTION
    #	Add bindings to widgets; this is useful if adding multiple bindings for the same command.
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

    foreach bd $binding {
            bind $wid <$bd> $cmd
    }

} ;# ea::tools::bindings


proc ea::tools::populateListbox {modify entryWid lBoxWid dbTable dbCol} {
    #****f* populateListbox/ea::tools
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #   ea::tools::populateListbox add $f2.entry $f2.lbox Containers Container
    #	Add values to listbox
    #	entryWid = Path to widget
    #   lBoxWid = Path to widget
    #   dbTable = what it is, for the switch to work correctly
    #   modify = add|delete
    #
    # SYNOPSIS
    #   Updates the data in a list box.
    #   Remove data from an entry field, insert/delete the data in the listbox
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
    #***
    global log
    ${log}::debug --START-- [info level 1]
    
    ${log}::debug Adding $dbTable, $entryWid, $lboxWid
    
    switch -- $modify {
        add     {if {[$entryWid get] == ""} {return} else {set entryValue [$entryWid get]}; $entryWid delete 0 end
                # Insert into DB; must use quotes instead of curly braces to allow variable substituition
                db eval "insert into ${dbTable}($dbCol) values('$entryValue')"
            }
        delete  {if {[$lboxWid curselection] == ""} {return}
                # Delete the entry, then set the var to all values remaining values.
                eAssist_db::delete $dbTable $dbCol [$lboxWid get [$lboxWid curselection]]
            }
        default {${log}::debug Unknown switch option: $modify}
    }
    
    # Update the widgets with the new data ...
    eAssist_db::initContainers $dbTable $listBox

    ${log}::debug --END-- [info level 1]
} ;# ea::tools::populateListbox


proc ea::tools::formatFileName {} {
    #****f* formatFileName/ea::tools
    # CREATION DATE
    #   02/13/2015 (Friday Feb 13)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::tools::formatFileName  
    #
    # FUNCTION
    #	Returns the formatted file name
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
    global log mySettings job

    set fileName $mySettings(job,fileName)
    foreach item {Title Name Number} {
        set item2 [string tolower $item]
        #puts [string map [list %$item2 $job($item)] $mySettings(job,fileName)]
        set fileName [string map [list %$item2 [join $job($item) -]] $fileName]
    }
	# sanitize
	set fileName [string map {\\ _ / _ \" ""} $fileName]
	set fileName [join $fileName _]

	return $fileName
} ;# ea::tools::formatFileName

proc ea::tools::getGUID {args} {
    #****f* getGUID/ea::tools
    # CREATION DATE
    #   03/11/2015 (Wednesday Mar 11)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::tools::convertGUID -new|-convert
	#   The default is -new if no args are supplied.
    #
    # FUNCTION
    #	Creates a GUID using the TWAPI package; and depending on the flag it will return a converted X'093090394039403094 number, or the typical
	#	{E0EB36A4-CB17-4020-829C-56E6D243313C} format. Without braces.
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

    set guid [twapi::new_guid]
	
	if {$args eq "-convert"} {
		# clean the guid up, then append it to the default first two chars needed (For sqlite)
		set guid [string map { \{ "" \} "" - ""} $guid]
		
		append formattedGUID X' $guid
		return $formattedGUID
	} else {
		return [join $guid]
	}

} ;# ea::tools::getGUID

proc ea::tools::assembleHeaders {} {
    #****f* assembleHeaders/ea::tools
    # CREATION DATE
    #   09/29/2015 (Tuesday Sep 29)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # USAGE
    #   ea::tools::exportHeaders 
    #
    # FUNCTION
    #	Assembles the common column names into header packages.
    #   -cols, Returns the database column names used in 'SELECT <column names>'; the calling proc will need to [join] it with commas
    #   -file_hdr, Returns the database columns names, without any prefixs or other formatting. This is inserted into the first line of the exported file.
    #   -vals, Used in conjunction with -cols, this is used to grab the data out of the database which is mapped to each column.
    #   
    #     
    # EXAMPLE
    #   set headers [ea::tools::assembleHeaders]
    #   set cols [lindex $headers 0] 
    #
    # NOTES
    #   
    #  
    # SEE ALSO
    #   
    #   
    #***
    global log headerParent
       
    foreach cons $headerParent(headerList,consignee) {
        # Creating the list of columns to query
        lappend cols "Addresses.$cons as $cons"
        # Creating the list of header names
        lappend hdr $cons
        # Creating the list of variables to display the values
        lappend vals \$$cons
    }

    foreach shiporder $headerParent(headerList,shippingorder) {
        lappend hdr $shiporder
        lappend cols "ShippingOrders.$shiporder as $shiporder"
        
        if {[string tolower $shiporder] eq "shipvia"} {
            # ShipVia and ShipViaCode are both required in the columns sent to the db. But we only want one "ShipViaCode" in the values.
            set shiporder ShipViaCode
            lappend cols "ShipVia.ShipViaCode as ShipViaCode"
            lappend vals \$ShipViaCode
        } else {
            lappend vals \$$shiporder
        }
    }

    set cols [string map -nocase {{Addresses.Versions as Versions} {Versions.VersionName as Versions}} $cols]
    
    return [list $cols $hdr $vals]
} ;# ea::tools::assembleHeaders

proc eAssist_Global::launchFilters {} {
    #****f* launchFilters/eAssist_Global
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Holds the values to the 'canned' filters
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
    global log filter
    ${log}::debug --START -- [info level 1]
    	# Testing Purposes - This will need to be a GUI Config option
	set filter(addrDirectionals) [list north n \
								  east e \
								  south s \
								  west w \
								  northeast ne \
								  southeast se \
								  northwest nw \
								  southwest sw \
								  ]

	
	set filter(secondaryUnits) [list apartment apt \
							   basement bsmt \
							   building bldg \
							   department dept \
							   floor fl \
							   front frnt \
							   hanger hngr \
							   key key \
							   lobby lbby \
							   lower lowr \
							   office ofc \
							   penthouse ph \
							   room rm \
							   space spc \
							   suite ste \
							   trailer trlr \
							   upper uppr]
	
	set filter(StateList) [list alabama al \
					   alaska ak \
					   arizona az \
					   arkansas ar \
					   california ca \
					   colorado co \
					   connecticut ct \
					   delaware de \
					   florida fl \
					   georgia ga \
					   hawaii hi \
					   idaho id \
					   illinois il \
					   indiana in \
					   iowa ia \
					   kansas ks \
					   kentucky ky \
					   louisiana la \
					   maine me \
					   maryland md \
					   massachusetts ma \
					   michigan mi \
					   mississippi ms \
					   missouri mo \
					   montana mt \
					   nebraska ne \
					   nevada nv \
					   "new hampshire" nh \
					   "new jersey" nj \
					   "new mexico" nm \
					   "new york" ny \
					   "north carolina" nc \
					   "north dakota" nd \
					   ohio oh \
					   oklahoma ok \
					   oregon or \
					   pennsylvania pa \
					   "rhode island" ri \
					   "south carolina" sc \
					   "south dakota" sd \
					   tennessee tn \
					   texas tx \
					   utah ut \
					   vermont vt \
					   virginia va \
					   washington wa \
					   "west virginia" wv \
					   wisconsin wi \
					   wyoming wy]

set filter(addrStreetSuffix) [list alley aly \
								  avenue ave \
								  bayou byu \
								  boulevard blvd \
								  branch br \
                                  drive dr \
								  expressway expy \
								  freeway fwy \
								  highway hwy \
								  parkway pkwy \
								  place pl \
								  road rd \
								  route rte \
								  square sq \
								  street st \
								  valley vly \
								  way wy]

# Comprehensive list of suffix's, and common misspellings with the correct abbreviation
set 'filter(addrStreetSuffix) [list alley aly \
								  allee aly \
								  ally aly \
								  anex anx \
								  annex anx \
								  annx anx \
								  arcade arc \
								  avenue ave \
								  av ave \
								  aven ave \
								  avn ave \
								  avnue ave \
								  bayoo byu \
								  bayou byu \
								  beach bch \
								  bend bnd \
								  bluff blf \
								  bluf blf \
								  bluffs blfs \
								  bottom btm \
								  bottm btm \
								  boulevard blvd \
								  boulv blvd \
								  boul blvd \
								  branch br \
								  brnch br \
								  bridge brg \
								  brdge brg \
								  brook brk \
								  brooks brks \
								  burg bg \
								  burgs bgs \
								  bypass byp \
								  bypas byp \
								  byps byp \
								  bypa byp \
								  camp cp \
								  cmp cp \
								  canyon cyn \
								  canyn cyn \
								  cnyn cyn \
								  cape cpe \
								  causeway cswy \
								  causwy cswy \
								  center ctr \
								  cent ctr \
								  centr ctr \
								  centre ctr \
								  cnter ctr \
								  cntr ctr \
								  centers ctrs \
								  circle cir \
								  circ cir \
								  circl cir \
								  crcl cir \
								  crcle cir \
								  circles cirs \
								  cliff clf \
								  cliffs clfs \
								  club clb \
								  common cmn \
								  commons cmns \
								  corner cor \
								  corners cors \
								  course crse \
								  court ct \
								  courts cts \
								  cove cv \
								  coves cvs \
								  creek crk \
								  crescent cres \
								  crsent cres \
								  crsnt cres \
								  crest crst \
								  crossing xing \
								  crssng xing \
								  crossroad xrd \
								  croassroads xrds \
								  curve curv \
								  dale dl \
								  dam dm \
								  divide dv \
								  div dv \
								  dvd dv \
								  drive dr \
								  driv dr \
								  drv dr \
								  drives drs \
								  estate est \
								  expressway expy \
								  exp expy \
								  expr expy \
								  express expy \
								  expw expy \
								  extension ext \
								  extn ext \
								  extnsn ext \
								  extensions exts \
								  falls fls \
								  ferry fry \
								  frry fry \
								  field fld \
								  fields flds \
								  flat flt \
								  flats flts \
								  ford frd \
								  fords frds \
								  forest frst \
								  forests frst \
								  forge frg \
								  forg frg \
								  forges frgs \
								  fork frk \
								  forks frks \
								  fort ft \
								  frt ft \
								  freeway fwy \
								  freewy fwy \
								  garden gdn \
								  gardn gdn \
								  grden gdn \
								  grdn gdn \
								  gardens gdns \
								  grdns gdns \
								  gateway gtwy \
								  gatewy gtwy \
								  gatway gtwy \
								  gtway gtwy \
								  glen gln \
								  glens glns \
								  green grn \
								  greens grns \
								  grove grv \
								  grov grv \
								  groves grvs \
								  harbor hbr \
								  harb hbr \
								  harbr hbr \
								  hrbor hbr \
								  harbors hbrs \
								  haven hvn \
								  heights hts \
								  ht hts \
								  highway hwy \
								  highwy hwy \
								  hiway hwy \
								  hiwy hwy \
								  hway hwy \
								  hill hl \
								  hills hls \
								  hollow holw \
								  hllw holw \
								  hollows holw \
								  holws holw \
								  inlet inlt \
								  island is \
								  islnd is \
								  islands iss \
								  islnds iss \
								  isles isle \
								  junction jct \
								  jction jct \
								  jctn jct \
								  junctn jct \
								  junctions jcts \
								  jctns jcts \
								  key ky \
								  keys kys \
								  knoll knl \
								  knol knl \
								  knolls knls \
								  lake lk \
								  lakes lks \
								  landing lndg \
								  lndng lndg \
								  lane ln \
								  light lgt \
								  lights lgts \
								  loaf lf \
								  lock lck \
								  lock lkcs \
								  lodge ldg \
								  ldge ldg \
								  lodg ldg \
								  loop lp \
								  loops lp \
								  manor mnr \
								  manors mnrs \
								  meadow mdw \
								  meadows mdws \
								  mills mls \
								  mission msn \
								  missn msn \
								  mssn msn \
								  motorway mtwy \
								  mount mt \
								  mnt mt \
								  mountain mtn \
								  mntain mtn \
								  mntn mtn \
								  mountin mtn \
								  mtin mtn \
								  mountains mtns \
								  mntns mtns \
								  neck nck \
								  orchard orch \
								  orchrd orch \
								  ovl oval \
								  overpass opas \
								  prk park \
								  parks park \
								  parkway pkwy \
								  parkwy pkwy \
								  pkway pkwy \
								  pky pkwy \
								  parkways pkwy \
								  pkwys pkwy \
								  passage psge \
								  paths path \
								  pikes pike \
								  pine pne \
								  pines pnes \
								  place pl \
								  plc pl \
								  plain pln \
								  plains plns \
								  plaza plz \
								  plza plz \
								  point pt \
								  points pts \
								  port prt \
								  ports prts \
								  prairie pr \
								  prr pr \
								  radial radl \
								  radiel radl \
								  rad radl \
								  ranch rnch \
								  ranches rnch \
								  rnchs rnch \
								  rapid rpd \
								  rapids rpds \
								  rest rst \
								  ridge rdg \
								  rdge rdg \
								  ridges rdgs \
								  river riv \
								  rvr riv \
								  rivr riv \
								  road rd \
								  roads rds \
								  route rte \
								  shoal shl \
								  shoals shls \
								  shore shr \
								  shoar shr \
								  shores shrs \
								  shoars shrs \
								  skyway skwy \
								  spring spg \
								  spng spg \
								  sprng spg \
								  springs spgs \
								  sprngs spgs \
								  spngs spgs \
								  spurs spur \
								  square sq \
								  sqr sq \
								  sqre sq \
								  squ sq \
								  squares sqs \
								  sqrs sqs \
								  station sta \
								  statn sta \
								  stn sta \
								  stravenue stra \
								  strav stra \
								  straven stra \
								  stravn stra \
								  strvn stra \
								  strvnue stra \
								  stream strm \
								  streme strm \
								  street st \
								  strt st \
								  str st \
								  streets sts \
								  summit smt \
								  sumit smt \
								  sumitt smt \
								  terrace ter \
								  terr ter \
								  throughway trwy \
								  trace trce \
								  traces trce \
								  track trak \
								  tracks trak \
								  trk trak \
								  trks trak \
								  trafficway trfy \
								  trail trl \
								  trails trl \
								  trls trl \
								  trailer trlr \
								  tunnel tunl \
								  tunel tunl \
								  tunls tunl \
								  tunnels tunl \
								  tunnl tunl \
								  turnpike tpke \
								  trnpk tpke \
								  turnpk tpke \
								  underpass upas \
								  union un \
								  unions uns \
								  valley vly \
								  vally vly \
								  vlly vly \
								  valleys vlys \
								  viaduct vdct \
								  viadct via \
								  view vw \
								  views vws \
								  village vlg \
								  villag vlg \
								  villg vlg \
								  villiage vlg \
								  villages vlgs \
								  ville vl \
								  vista vis \
								  vist vis \
								  vst vis \
								  vsta vis \
								  walks walk \
								  way wy \
								  well wl \
								  wells wls]
    ${log}::debug --END -- [info level 1]
} ;# eAssist_Global::launchFilters