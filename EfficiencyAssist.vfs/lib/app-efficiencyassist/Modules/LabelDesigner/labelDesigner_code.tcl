# Creator: Casey Ackels (C) 2017

proc ea::code::ld::getOpenFile {wid} {
    global log tplLabel job

    # filePathName should really be set in Setup/Labels
    set tplLabel(RootPath) "//fileprint/Labels/Templates"

    # Check to see if Customer, and Title folders have been created already
    set customerPath [file join $tplLabel(RootPath) "$job(CustID) $job(CustName)"]
    set tplLabel(titlePath) [file join $customerPath "$job(TitleID) $job(Title)"]

    if {[file isdirectory $customerPath] == 0} {
        ${log}::notice $customerPath doesn't exist, creating ...

        file mkdir $customerPath
    } else {
        ${log}::notice $customerPath already exists, skipping ...
    }

    if {[file isdirectory $tplLabel(titlePath)] == 0} {
        ${log}::notice $tplLabel(titlePath) doesn't exist, creating ...

        file mkdir $tplLabel(titlePath)
    } else {
        ${log}::notice $tplLabel(titlePath) already exists, skipping ...
    }

    # Copy bartender template file ...
    if {$tplLabel(LabelPath) eq ""} {
        # This will be empty if we are creating a new template
        ${log}::debug Copying template file for label size $tplLabel(LabelSize)

        ${log}::debug dest_path $tplLabel(titlePath) labelID: $tplLabel(LabelSizeID)
        ea::db::ld::getDefaultLabelDoc $tplLabel(titlePath) $tplLabel(LabelSizeID)
    }

    #set tplLabel(titlePath) [join [split $tplLabel(titlePath) /] \\]
    set openFilePath [tk_getOpenFile -initialdir $tplLabel(titlePath) -filetypes {{Bartender {.btw}}}]

    if {$openFilePath eq ""} {return}

    ${log}::debug filePathName: $openFilePath

    $wid delete 0 end
    $wid insert end $openFilePath
} ;#ea::code::ld::getOpenFile

proc ea::code::ld::resetWidgets {} {
    global log tplLabel job
    ${log}::debug Resetting arrays: Job (partial) and tplLabel

    # reset standard
    set job(CustID) ""
    set job(CustName) ""
    set job(CSRName) ""
    set job(NewCustomer) ""
    set job(Title) ""

    foreach item [array names tplLabel] {
        set tplLabel($item) ""
    }
} ;# ea::code::ld::resetWidgets

proc ea::code::ld::resetLabelVersion {args} {
    global log tplLabel ldWid

    switch -- $args {
        -complete       {
            set tplLabel(LabelVersionID,current) ""
            set tplLabel(LabelVersionDesc,current) ""
        }
        -keepVersion    {
        }
        default         {
            ${log}::debug [info level 0] Unknown argument $args
        }
    }

    # Base vars, these should always be reset
    set tplLabel(LabelSizeID) ""
    set tplLabel(LabelPath) ""
    set tplLabel(SerializeLabel) 0
    set tplLabel(MaxBoxQty) ""
    set tplLabel(LabelSize) ""
    set tplLabel(LabelVersionStatus) 1

    $ldWid(f2b).listbox delete 0 end
} ;# ea::code::ld::resetLabelVersion

proc ea::code::ld::saveTemplateHeader {} {
    # Check to make sure we have all required fields populated
    # If checks pass, write data to database
    global log job tplLabel ldWid

    $ldWid(f2b).listbox finishediting
    set gate1 0
    set gate2 0

    ## WARNINGS - If these are triggered, nothing is written to the database
    ## Error Checks - Job Info

    # Check for title
    if {$job(TitleID) eq ""} {${log}::critical [mc "Title name must not be empty. Please insert title name."]; set gate1 1}

    ## Error Checks - Template Header Properties
    # Label Name
    if {$tplLabel(Name) eq ""} {${log}::critical [mc "Template Name is empty."] ; set gate1 1}

    # Label File Path
    if {$tplLabel(LabelPath) eq ""} {${log}::critical [mc "Label File is missing."] ; set gate2 1}

    ## Error Checks - Label Data Properties
    # Check folder permissions
    if {[eAssist_Global::folderAccessibility $tplLabel(LabelPath)] != 3} {${log}::critical [mc "Cannot write to"] $tplLabel(LabelPath). ; set gate2 1}

    # If Label Template contains lines, and the first entry does not contain data
    if {[string match *line [string tolower $tplLabel(LabelVersionDesc,current)]] == 1 && [$ldWid(addTpl,f2).versionDescCbox get] eq ""} {
         ${log}::critical [mc Label Profile requires a version to be selected. None Selected.] ; set gate 1
    }

    # NOTICES - Data is saved to the database, but notices are issued if fields are empty
    if {$tplLabel(FixedBoxQty) eq ""} {${log}::alert [mc "Fixed Box Qty is empty"]}
    if {$tplLabel(FixedLabelInfo) eq ""} {${log}::alert [mc "Fixed Label Info is empty"]}
    if {$tplLabel(SerializeLabel) eq ""} {${log}::alert [mc "Serialize Label is empty"]}

    if {$gate1 == 1} {
        ${log}::critical GATE1: Critical errors exist for writing the template to the database. Aborting.
        return
    } else {
        # Write Template header data to database.
        ea::db::ld::writeTemplate
    }

    if {$gate2 == 1} {
        ${log}::critical GATE2: Critical errors exist, not writing to the database.
        return
    } else {
        # Write Label data to database.
        # Create a dummy file for linking the BarTender document to the run-list file.
        #ea::db::ld::writeLabelData
        ea::db::ld::writeLabelVersions
        ea::code::ld::createDummyFile
        # Populate table list
        ea::db::ld::getTemplateData
    }
} ;# ea::code::ld::saveTemplateHeader

proc ea::code::ld::createDummyFile {} {
    # Create a 'dummy' file that contains a sample database of the selected profile.
    # Invoked by ea::gui::ld::saveTemplateHeader
    # Writes to: Directory where label file is located with name of <Profile Desc>
    global log tplLabel

    # Actions ...
    set f_name $tplLabel(Name)
    ${log}::debug File Name: $f_name
    ${log}::debug writing to path:  [file dirname $tplLabel(LabelPath)]

    set hdr_data [::csv::join "[db eval "SELECT LabelHeaderDesc FROM LabelHeaders WHERE LabelHeaderSystemOnly = 1"] [db eval "SELECT labelRowNum FROM LabelData WHERE labelVersionID = $tplLabel(LabelVersionID,current)"]"]

    ${log}::debug Opening File: file join  [file dirname $tplLabel(LabelPath)] $f_name.csv
    ${log}::debug writing headers to file: $hdr_data

    set runlist_file [open "[file join  [file dirname $tplLabel(LabelPath)] $f_name.csv]" w]

    # Insert Header row
    chan puts $runlist_file $hdr_data

    chan close $runlist_file
} ;# ea::code::ld::createDummyFile

proc ea::code::ld::getRowData {LabelVersionID widPath} {
     global tplLabel

     for {set x 1} {$tplLabel(LabelProfileRowNum) >= $x} {incr x} {
         set rowData ""
         set rowData [list '[$widPath.labelData$x get]']

         if {[$widPath.userEditable$x state] eq "selected"} {
             lappend rowData 1
         } else {
             lappend rowData 0
         }

         if {[$widPath.isVersion$x state] eq "selected"} {
             lappend rowData 1
         } else {
             lappend rowData 0
         }

         if {[join $rowData] ne "\"\""} {
             set rowInfo $LabelVersionID,$x
             lappend rowInfo [join $rowData ,]

             lappend finalRowInfo ([join $rowInfo ,])
         }
     }

     return [join $finalRowInfo ,]
} ;# ea::code::ld::getRowData

proc ea::code::ld::modifyTemplate {wid} {
    # Populate the widgets based on the Customer/Title combo selected in the main window.
    # Version specific data will not populate until a Label Version is selected by the user.
    global log tplLabel job ldWid

    set widTplCustomer [$wid findcolumnname customerName]
    set widTplTitle [$wid findcolumnname titleName]
    set widStatus [$wid findcolumnname status]

    set job(CustName) [lindex [$wid get [$wid curselection]] $widTplCustomer]
    set job(Title) [lindex [$wid get [$wid curselection]] $widTplTitle]

    if {[lindex [$wid get [$wid curselection]] $widStatus] eq "Active"} {
        set tplLabel(Status) 1
    } else {
        set tplLabel(Status) 0
    }

    # Retrieve customer title ID
    ea::db::ld::getCustomerTitleID

    # Retrieve customer name from Monarch
    ea::db::ld::getCustomerName $job(TitleID)

    # Retrieve Title Name from Monarch
    ea::db::ld::getCustomerTitleName $job(TitleID)

    # Populate title dropdown
    #$ldWid(addTpl,f1).cbox0 configure -state normal
    $ldWid(addTpl,f1).cbox0 set $job(Title)

    # Retrieve the actual templates / Versions
    ea::db::ld::getTemplates

    # Populate the combobox with the label versions
    ea::db::ld::getLabelVersionList $ldWid(addTpl,ldf0).versionDescCbox
}


# Tablelist helper
proc ea::code::ld::editStartCmd {tbl row col text} {
    global log mod
    set w [$tbl editwinpath]
     # Row
     # $ldWid(f2b).listbox getcells 0,1 [row,colunn]
    switch [$tbl columncget $col -name] {
        "row"       {$w configure -values {Row01 Row02 Row03 Row04 Row05 Row06 Row07 ""} -state readonly}
        "labelText" {
            $w configure -values $mod(Box_Labels,uservars)
            ${log}::debug current row: $ldWid(f2b).listbox getcells $row,1
        }
        "editable"  {$w configure -values {Yes No} -state readonly}
        default     {}
    }

    $tbl cellconfigure $row,$col -text $text
} ;# ea::code::ld::editStartCmd

proc ea::code::ld::editEndCmd {tbl row col text} {

} ;# ea::code::ld::editEndCmd

# Add ship qty's to list box
proc ea::code::ld::AddShipQty {widEntry widListBox} {
    global log
    ${log}::debug quantity: [$widEntry get]
    $widListBox insert end [$widEntry get]
    $widEntry delete 0 end
} ;# ea::code::ld::AddShipQty

proc ea::code::ld::delShipQty {widListBox} {
    global log
    # Delete selected entry(ies)
    set selItem [$widListBox curselection]

    if {$selItem ne ""} {
        foreach sel [lsort -decreasing $selItem] {
            $widListBox delete $sel
        }
    }
} ;# ea::code::ld::delShipQty
