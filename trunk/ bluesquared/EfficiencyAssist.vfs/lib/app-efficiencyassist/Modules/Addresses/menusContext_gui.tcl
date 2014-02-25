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


proc IFMenus::tblPopup {tbl mode mName} {
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
    #	eAssistHelper::insValuesToTableCells, eAssistHelper::insertItems
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
    global log files w
    ${log}::debug --START-- [info level 1]
    # This is initialized in importFiles_code.tcl [importFiles::processFile]
    # This is bound to the Mouse button in importFiles_gui.tcl [importFiles::eAssistGUI]
    
    # Setup the bindings
    set bodyTag [$tbl bodytag]
    bind $bodyTag <<Button3>> +[list tk_popup $mName %X %Y]
    
	
	if {[winfo exists $mName]} {
		destroy $mName
		menu $mName
	} else {
		menu $mName
	}
    
    
	
	# Add cascade menu
	# The commands are dynamically created in importFiles_code.tcl [importFiles::processFile]
    #.tblMenu add cascade -label [mc "Show"] -menu .tblMenu.showCols   
    #.tblMenu add cascade -label [mc "Hide"] -menu .tblMenu.hideCols
    #
    ## Create context menu items
    #IFMenus::columnMenus .tblMenu.showCols .tblMenu.hideCols
    #
    #.tblMenu add separator
    #

	# Control what shows up, depending on if we are in [extended] or [browse] mode
	# Paste [clipboard get]
    if {$mName eq ".splitTblMenu"} {
        # w(sVersf2).tbl / Split Table
        if {$mode eq "extended"} {
            $mName add command -label [mc "Quick Fill..."] -command {eAssistHelper::insertItems $w(sVersf2).tbl}
            $mName add command -label [mc "Copy"] -command {IFMenus::copyCell $w(sVersf2).tbl}
            $mName add command -label [mc "Paste"] -command {eAssistHelper::insValuesToTableCells $w(sVersf2).tbl [clipboard get] [$w(sVersf2).tbl curcellselection]}
            $mName add command -label [mc "Clear"] -command {IFMenus::clearItems $w(sVersf2).tbl}
            #$mName add separator
            #$mName add command -label [mc "Copy Row"] -command {IFMenus::copyRow $w(sVersf2).tbl}
            #$mName add command -label [mc "Paste Row"] -command {IFMenus::pasteRow $w(sVersf2).tbl}
            #$mName add command -label [mc "Clear Row Contents"] -command {IFMenus::clearRowContents $w(sVersf2).tbl}
            #$mName add command -label [mc "Insert Row"] -command {catch [$w(sVersf2).tbl insert [$w(sVersf2).tbl curselection] ""] err}
            #$mName add command -label [mc "Delete Row"] -command {catch [$w(sVersf2).tbl delete [$w(sVersf2).tbl curselection]] err}
        } else {
            # Browse mode
            $mName add command -label [mc "Copy Row"] -command {}
            $mName add command -label [mc "New Row"] -command {catch [$w(sVersf2).tbl insert [$w(sVersf2).tbl curselection] ""] err}
            $mName add command -label [mc "Delete Row"] -command {catch [$w(sVersf2).tbl delete [$w(sVersf2).tbl curselection]] err}
            $mName add command -label [mc "Display contents"] -command {${log}::debug [$w(sVersf2).tbl get [$w(sVersf2).tbl curselection]]}
        }
    } else {
        # files(tab3f2).tbl / Main Table
        if {$mode eq "extended"} {
            $mName add command -label [mc "Quick Fill..."] -command {eAssistHelper::insertItems $files(tab3f2).tbl}
            $mName add command -label [mc "Copy"] -command {IFMenus::copyCell $files(tab3f2).tbl}
            $mName add command -label [mc "Paste"] -command {eAssistHelper::insValuesToTableCells $files(tab3f2).tbl [clipboard get] [$files(tab3f2).tbl curcellselection]}
            $mName add command -label [mc "Clear"] -command {IFMenus::clearItems $files(tab3f2).tbl}
            $mName add separator
            $mName add command -label [mc "Copy Row"] -command {IFMenus::copyRow $files(tab3f2).tbl}
            $mName add command -label [mc "Paste Row"] -command {IFMenus::pasteRow $files(tab3f2).tbl}
            $mName add command -label [mc "Clear Row Contents"] -command {IFMenus::clearRowContents $files(tab3f2).tbl}
            $mName add command -label [mc "Insert Row"] -command {catch [$files(tab3f2).tbl insert [$files(tab3f2).tbl curselection] ""] err}
            $mName add command -label [mc "Delete Row"] -command {catch [$files(tab3f2).tbl delete [$files(tab3f2).tbl curselection]] err}
        } else {
            # Browse mode
            $mName add command -label [mc "Copy Row"] -command {}
            $mName add command -label [mc "New Row"] -command {catch [$files(tab3f2).tbl insert [$files(tab3f2).tbl curselection] ""] err}
            $mName add command -label [mc "Delete Row"] -command {catch [$files(tab3f2).tbl delete [$files(tab3f2).tbl curselection]] err}
            $mName add command -label [mc "Display contents"] -command {${log}::debug [$files(tab3f2).tbl get [$files(tab3f2).tbl curselection]]}
        }
    }
        
        # Items that should always be displayed
	
    ${log}::debug --END-- [info level 1]
} ;# IFMenus::tblPopup


proc IFMenus::clearRowContents {tbl} {
    #****f* clearRowContents/IFMenus
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Clears the selected rows' contents
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
    
    set cRow [$tbl curselection]
    
    ## Delete Row
    catch [$tbl delete $cRow] err
    
    ## Insert new row
    catch [$tbl insert $cRow ""] err
	
    ${log}::debug --END-- [info level 1]
} ;# IFMenus::clearRowContents
proc IFMenus::pasteRow {tbl} {
    #****f* pasteRow/IFMenus
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Pastes data from the clipboard into the selected row.
    #
    # SYNOPSIS
    #   IFMenus::pasteRow <tb>
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
    
    set cRow [$tbl curselection]
    
    ## Delete Row
    catch [$tbl delete $cRow] err
    
    ## Insert (paste) new row
    catch [$tbl insert $cRow [clipboard get]] err
	
    ${log}::debug --END-- [info level 1]
} ;# IFMenus::pasteRow


proc IFMenus::copyRow {tbl} {
    #****f* copyRow/IFMenus
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Clears the clipboard, copies the selected row, and puts it on the clipboard
    #
    # SYNOPSIS
    #   IFMenus::copyRows
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
    
    clipboard clear
    clipboard append [$tbl get [$tbl curselection]]
    ${log}::debug Copy Row: [$tbl get [$tbl curselection]]
	
    ${log}::debug --END-- [info level 1]
} ;# IFMenus::copyRow
proc IFMenus::copyCell {tbl} {
    #****f* copyCell/IFMenus
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Clears the clipboard, and inserts the currently selected cells to the clipboard.
    #
    # SYNOPSIS
    #   IFMenus::copy <tbl>
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
    
    clipboard clear
    clipboard append [$tbl getcells [$tbl curcellselection]]
	
    #${log}::debug --END-- [info level 1]
} ;# IFMenus::copyCell


proc IFMenus::clearItems {tbl} {
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
    
    set cells [$tbl curcellselection]
    
    foreach cell $cells {
        $tbl cellconfigure $cell -text ""
    }
	
    ${log}::debug --END-- [info level 1]
} ;# IFMenus::clearItems


proc IFMenus::createToggleMenu {tbl} {
    #****f* createToggleMenu/IFMenus
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Sets up the the Toggle Menu
    #
    # SYNOPSIS
    #
    #
    # CHILDREN
    #	IFMenus::columnMenus
    #
    # PARENTS
    #	importFiles::processFile, importFiles::eAssistGUI
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global log
    ${log}::debug --START-- [info level 1]
    
    if {[winfo exists .tblToggleColumns]} {
		destroy .tblToggleColumns
		menu .tblToggleColumns
        menu .tblToggleColumns.showCols
        menu .tblToggleColumns.hideCols
	} else {
		menu .tblToggleColumns
        menu .tblToggleColumns.showCols
        menu .tblToggleColumns.hideCols
	}
    
    #list tk_popup .tblToggleColumns %X %Y
    
    # The commands are dynamically created in importFiles_code.tcl [importFiles::processFile]
    .tblToggleColumns add cascade -label [mc "Show"] -menu .tblToggleColumns.showCols   
    .tblToggleColumns add cascade -label [mc "Hide"] -menu .tblToggleColumns.hideCols
    
    # Create context menu items
    IFMenus::columnMenus $tbl .tblToggleColumns.showCols .tblToggleColumns.hideCols
	
    ${log}::debug --END-- [info level 1]
} ;# IFMenus::createToggleMenu


proc IFMenus::columnMenus {tbl showPath hidePath} {
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
    #	IFMenus::toggleMenus
    #
    # PARENTS
    #	IFMenus::createToggleMenu
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global log files
    ${log}::debug --START-- [info level 1]
    
	# columncount starts at 1, not 0. 
    set colCount [expr [$tbl columncount] -1]
    
    for {set x 0} {$colCount >= $x} {incr x} {
        set colName [$tbl columncget $x -name]
        if {[$tbl columncget $x -hide] == 1} {
            #${log}::debug HIDDEN COLUMNS: [$files(tab3f2).tbl columncget $x -name]
            $showPath add command -label $colName -command "IFMenus::toggleMenus $tbl no $hidePath $showPath $colName"
        } else {
            $hidePath add command -label $colName -command "IFMenus::toggleMenus $tbl yes $hidePath $showPath $colName"
            #${log}::debug VISIBLE COLUMNS: [$files(tab3f2).tbl columncget $x -name]
        }
    }
    ${log}::debug --END-- [info level 1]
} ;# IFMenus::columnMenus


proc IFMenus::toggleMenus {tbl YesNo hidePath showPath colName} {
    #****f* toggleMenus/IFMenus
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	IFMenus::toggleMenus <tbl> <yes|no> <hidePath> <showPath> <colName>
    #
    # SYNOPSIS
    #   Update the cascade r-click context menus. Paths are to the cascade menu.
    #
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	IFMenus::tblPopup, IFMenus::columnMenus
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global log files
    ${log}::debug --START-- [info level 1]
    # Removes the column name from one cascade menu and add it to the other.
    
    
    $tbl columnconfigure $colName -hide $YesNo
    
    if {$YesNo eq "no"} {
        $showPath delete $colName
        $hidePath add command -label $colName -command "IFMenus::toggleMenus $tbl yes $hidePath $showPath $colName"
    } else {
        $hidePath delete $colName
        $showPath add command -label $colName -command "IFMenus::toggleMenus $tbl no $hidePath $showPath $colName"
    }
    
    
	
    ${log}::debug --END-- [info level 1]
} ;# IFMenus::toggleMenus