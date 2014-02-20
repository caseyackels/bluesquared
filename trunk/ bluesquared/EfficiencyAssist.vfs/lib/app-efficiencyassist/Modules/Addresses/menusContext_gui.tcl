# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 2/16 ,2014
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 169 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2011-10-17 16:11:20 -0700 (Mon, 17 Oct 2011) $
#
########################################################################################

##
## - Overview
# Overview

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


proc IFMenus::tblPopup {mode} {
    #****f* tblPopup/IFMenus
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Popup menu for the main Table for editing addresses
    #
    # SYNOPSIS
    #
    #
    # CHILDREN
    #	
    #
    # PARENTS
    #	eAssist::parentGUI
    #
    # NOTES
	# 	This is initiated in the above parent.
    #
    # SEE ALSO
    #   importFiles::processFile
    #
    #***
    global log files 
    ${log}::debug --START-- [info level 1]
    # This is initialized in importFiles_code.tcl [importFiles::processFile]
    # This is bound to the Mouse button in importFiles_gui.tcl [importFiles::eAssistGUI]
	
	if {[winfo exists .tblMenu]} {
		destroy .tblMenu
		menu .tblMenu
        menu .tblMenu.showCols
        menu .tblMenu.hideCols
	} else {
		menu .tblMenu
        menu .tblMenu.showCols
        menu .tblMenu.hideCols
	}
	
	# Add cascade menu
	# The commands are dynamically created in importFiles_code.tcl [importFiles::processFile]
    .tblMenu add cascade -label [mc "Show"] -menu .tblMenu.showCols   
    .tblMenu add cascade -label [mc "Hide"] -menu .tblMenu.hideCols
    
    # Create context menu items
    IFMenus::columnMenus .tblMenu.showCols .tblMenu.hideCols
    
    .tblMenu add separator
    

	# Control what shows up, depending on if we are in [extended] or [browse] mode
	# Paste [clipboard get]
	if {$mode eq "extended"} {
		.tblMenu add command -label [mc "Quick Fill..."] -command {eAssistHelper::insertItems [$files(tab3f2).tbl curcellselection]}
		.tblMenu add command -label [mc "Copy"] -command {clipboard clear; clipboard append [$files(tab3f2).tbl getcells [$files(tab3f2).tbl curcellselection]]}
		.tblMenu add command -label [mc "Paste"] -command {eAssistHelper::insValuesToTableCells [clipboard get] [$files(tab3f2).tbl curcellselection]}
        .tblMenu add command -label [mc "Clear"] -command {IFMenus::clearItems [$files(tab3f2).tbl curcellselection]}
        .tblMenu add separator
		.tblMenu add command -label [mc "Copy Row"] -command {clipboard clear; clipboard append [$files(tab3f2).tbl get [$files(tab3f2).tbl curselection]]}
		.tblMenu add command -label [mc "Paste Row"] -command {
			set cRow [$files(tab3f2).tbl curselection]
			## Delete Row
			catch [$files(tab3f2).tbl delete $cRow] err
			## Insert (paste) new row
			catch [$files(tab3f2).tbl insert $cRow [clipboard get]] err
		}
        .tblMenu add command -label [mc "Clear Row Contents"] -command {
            set cRow [$files(tab3f2).tbl curselection]
			## Delete Row
			catch [$files(tab3f2).tbl delete $cRow] err
			## Insert new row
			catch [$files(tab3f2).tbl insert $cRow ""] err
            }
		.tblMenu add command -label [mc "New Row"] -command {catch [$files(tab3f2).tbl insert [$files(tab3f2).tbl curselection] ""] err}
		.tblMenu add command -label [mc "Delete Row"] -command {catch [$files(tab3f2).tbl delete [$files(tab3f2).tbl curselection]] err}
	} else {
		# Browse mode
		.tblMenu add command -label [mc "Copy Row"] -command {clipboard clear; clipboard append [$files(tab3f2).tbl getcells [$files(tab3f2).tbl curselection]]}
		.tblMenu add command -label [mc "New Row"] -command {catch [$files(tab3f2).tbl insert [$files(tab3f2).tbl curselection] ""] err}
		.tblMenu add command -label [mc "Delete Row"] -command {catch [$files(tab3f2).tbl delete [$files(tab3f2).tbl curselection]] err}
		.tblMenu add command -label [mc "Display contents"] -command {${log}::debug [$files(tab3f2).tbl get [$files(tab3f2).tbl curselection]]}
	}
	
	# Items that should always be displayed
	
    ${log}::debug --END-- [info level 1]
} ;# IFMenus::tblPopup


proc IFMenus::columnMenus {showPath hidePath} {
    #****f* columnMenus/IFMenus
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	IFMenus::columnMenus pathShowCols pathHideCols
    #
    # SYNOPSIS
    #   Toggle the r-click context menus
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	IFMenus::tblPopup
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global log files
    ${log}::debug --START-- [info level 1]
    
	# columncount starts at 1, not 0. 
    set colCount [expr [$files(tab3f2).tbl columncount] -1]
    
    for {set x 0} {$colCount >= $x} {incr x} {
        set colName [$files(tab3f2).tbl columncget $x -name]
        if {[$files(tab3f2).tbl columncget $x -hide] == 1} {
            #${log}::debug HIDDEN COLUMNS: [$files(tab3f2).tbl columncget $x -name]
            $showPath add command -label $colName -command "IFMenus::toggleMenus no $hidePath $showPath $colName"
        } else {
            $hidePath add command -label $colName -command "IFMenus::toggleMenus yes $hidePath $showPath $colName"
            #${log}::debug VISIBLE COLUMNS: [$files(tab3f2).tbl columncget $x -name]
        }
    }
    ${log}::debug --END-- [info level 1]
} ;# IFMenus::columnMenus


proc IFMenus::toggleMenus {YesNo hidePath showPath colName} {
    #****f* toggleMenus/IFMenus
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	IFMenus::toggleMenus yes/no <hidePath> <showPath> <colName>
    #
    # SYNOPSIS
    #   Update the cascade r-click context menus. Paths are to the cascade menu.
    #
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	IFMenus::tblPopup
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global log files
    ${log}::debug --START-- [info level 1]
    # Removes the column name from one cascade menu and add it to the other.
    
    
    $files(tab3f2).tbl columnconfigure $colName -hide $YesNo
    
    if {$YesNo eq "no"} {
        $showPath delete $colName
        $hidePath add command -label $colName -command "IFMenus::toggleMenus yes $hidePath $showPath $colName"
    } else {
        $hidePath delete $colName
        $showPath add command -label $colName -command "IFMenus::toggleMenus no $hidePath $showPath $colName"
    }
    
    
	
    ${log}::debug --END-- [info level 1]
} ;# IFMenus::toggleMenus


proc IFMenus::clearItems {cells} {
    #****f* clearItems/IFMenus
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Clears the selected cells
    #
    # SYNOPSIS
    #
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	IFMenus::tblPopup
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global log files
    ${log}::debug --START-- [info level 1]
    
    foreach cell $cells {
        $files(tab3f2).tbl cellconfigure $cell -text ""
    }
	
    ${log}::debug --END-- [info level 1]
} ;# IFMenus::clearItems
