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

proc ea::code::ld::resetWidgets {args} {
    global log tplLabel job settings
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

    # Populate table list
    ea::db::ld::getTemplateData
} ;# ea::code::ld::resetWidgets

proc ea::code::ld::saveTemplateHeader {} {
    # Check to make sure we have all required fields populated
    # If checks pass, write data to database
    global log job tplLabel ldWid

    $ldWid(f2b).listbox finishediting
    set gate 0

    ## WARNINGS - If these are triggered, nothing is written to the database
    ## Error Checks - Job Info

    # Check for title
    if {$job(TitleID) eq ""} {${log}::critical [mc "Title name must not be empty. Please insert title name."]; set gate 1}

    ## Error Checks - Label Properties
    # Label Name
    if {$tplLabel(Name) eq ""} {${log}::critical [mc "Template Name is empty."] ; set gate 1}

    # Label File Path
    if {$tplLabel(LabelPath) eq ""} {${log}::critical [mc "Label File is missing."] ; set gate 1}

    # Check folder permissions
    if {[eAssist_Global::folderAccessibility $tplLabel(LabelPath)] != 3} {${log}::critical [mc "Cannot write to"] $tplLabel(LabelPath). ; set gate 1}

    # If Label Template contains lines, and the first entry does not contain data
    #if {[string match *line [string tolower $tplLabel(LabelProfileDesc)]] == 1 && $tplLabel(tmpValues,rbtn) eq ""} {${log}::critical [mc Label Profile requires a version to be selected. None Selected.] ; set gate 1}
    if {[string match *line [string tolower $tplLabel(LabelVersionDesc,current)]] == 1 && [$ldWid(addTpl,f2).versionDescCbox get] eq ""} {${log}::critical [mc Label Profile requires a version to be selected. None Selected.] ; set gate 1}

    # NOTICES - Data is saved to the database, but notices are issued if fields are empty
    #if {$tplLabel(LabelProfileDesc) eq ""} {${log}::alert [mc "Profile is missing. Setting the ID to 0 (Default)"]; set tplLabel(LabelProfileID) 0}
    if {$tplLabel(FixedBoxQty) eq ""} {${log}::alert [mc "Fixed Box Qty is empty"]}
    if {$tplLabel(FixedLabelInfo) eq ""} {${log}::alert [mc "Fixed Label Info is empty"]}
    if {$tplLabel(SerializeLabel) eq ""} {${log}::alert [mc "Serialize Label is empty"]}

    if {$gate == 1} {
        ${log}::critical Critical errors exist, not writing to the database.
        return
    } else {
        # Write Template, Label data to database.
        # Create a dummy file for linking the BarTender document to the run-list file.

        ea::db::ld::writeTemplate
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

    switch [$tbl columncget $col -name] {
        "row"       {$w configure -values {Row01 Row02 Row03 Row04 Row05 Row06 Row07 ""} -state readonly}
        "labelText" {$w configure -values $mod(Box_Labels,uservars)}
        "editable"  {$w configure -values {Yes No} -state readonly}
        default     {}
    }
} ;# ea::code::ld::editStartCmd

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

##
##
## Original / Do Not Use
# proc ea::code::ld::writeToDb {} {
#     # Parent: ea::code::ld::saveLabel
#     global log job tplLabel
#
#     if {$job(NewCustomer) eq 1} {
#         # New customer, INSERT into DB
#         # DB Table - Customer
#         ${log}::debug Customer ($job(CustName) is new, inserting into database.
#         db eval "INSERT INTO Customer (Cust_ID, CustName) VALUES ('$job(CustID)', '$job(CustName)')"
#
#         set job(NewCustomer) ""
#     }
#
#     # DB Table - PubTitle
#     set csr_fname [lindex $job(CSRName) 0]
#     set csr_lname [lindex $job(CSRName) 1]
#     set csr_id [db eval "SELECT CSR_ID FROM CSRs WHERE FirstName = '$csr_fname' AND LastName = '$csr_lname'"]
#
#
#     # Does TitleName exist?
#     set title_id [db eval "SELECT Title_ID FROM PubTitle WHERE TitleName = '$job(Title)' AND CustID = '$job(CustID)'"]
#     if {$title_id eq ""} {
#         ${log}::notice Title ($job(Title)) is new, inserting into database.
#         db eval "INSERT INTO PubTitle (TitleName, CustID, CSRID, Status) VALUES ('$job(Title)', '$job(CustID)', '$csr_id', 1)"
#         set pubtitle_id [db eval "SELECT MAX(Title_ID) FROM PubTitle"]
#     } else {
#         ${log}::notice Title already exists in database...
#         set pubtitle_id $title_id
#         set csr_id_db [db eval "SELECT CSRID FROM PubTitle WHERE Title_ID = $pubtitle_id"]
#
#         ${log}::notice Checking to see if database has different CSR ($csr_id) name than user selected. If so, update database.
#         ${log}::debug CSR ID in Interface: $csr_id
#         ${log}::debug CSR ID in DB: $csr_id_db
#
#         if {$csr_id eq $csr_id_db} {
#             ${log}::notice CSR is the same, no changes needed
#             } else {
#                 ${log}::notice CSR ($csr_id_db) isn't the same, updating database to $csr_id
#                 db eval "UPDATE PubTitle SET CSRID = '$csr_id' WHERE Title_ID = $pubtitle_id"
#             }
#     }
#
#     # DB Table - LabelTPL
#     if {$pubtitle_id eq ""} {
#         ${log}::debug Title doesn't exist, so the template shouldn't either. Inserting data...
#         set tplLabel(LabelSizeID) [db eval "SELECT labelSizeID FROM LabelSizes WHERE labelSizeDesc = '$tplLabel(Size)'"]
#         set tplLabel(LabelProfileID) [db eval "SELECT LabelProfileID FROM LabelProfiles WHERE LabelProfileDesc = '$tplLabel(LabelProfileDesc)'"]
#             if {$tplLabel(LabelProfileID) eq ""} {set tplLabel(LabelProfileID) 0}
#
#         # Title doesn't exist. Template shouldn't exist either.
#          db eval "INSERT INTO LabelTPL (PubTitleID, LabelProfileID, labelSizeID, tplLabelName, tplLabelPath, tplNotePriv, tplNotePub, tplFixedBoxQty, tplFixedLabelInfo, tplSerialize)
#                 VALUES ($pubtitle_id, $tplLabel(LabelProfileID), $tplLabel(LabelSizeID), '$tplLabel(Name)', '$tplLabel(LabelPath)', '$tplLabel(NotePriv)', '$tplLabel(NotePub)', $tplLabel(FixedBoxQty), $tplLabel(FixedLabelInfo), $tplLabel(SerializeLabel), $tplLabel(SerializeLabel))"
#
#         set tpl_id [db eval "SELECT MAX(tplID) FROM LabelTPL"]
#     } else {
#         # Insert or Update Existing Template
#         ${log}::debug Title exists (ID: $pubtitle_id), checking to see if template exists.
#         set tplLabel(LabelSizeID) [db eval "SELECT labelSizeID FROM LabelSizes WHERE labelSizeDesc = '$tplLabel(Size)'"]
#         set tplLabel(LabelProfileID) [db eval "SElECT LabelProfileID FROM LabelProfiles WHERE LabelProfileDesc = '$tplLabel(LabelProfileDesc)'"]
#             if {$tplLabel(LabelProfileID) eq ""} {set tplLabel(LabelProfileID) 0}
#
#         set tpl_id [db eval "SELECT tplID FROM LabelTPL WHERE tplLabelName = '$tplLabel(Name)' AND PubTitleID = $pubtitle_id"]
#
#         if {$tpl_id eq ""} {
#             ${log}::debug Template does not exist, adding to database...
#             ${log}::debug db eval "INSERT INTO LabelTPL (PubTitleID, LabelProfileID, labelSizeID, tplLabelName, tplLabelPath, tplNotePriv, tplNotePub, tplFixedBoxQty, tplFixedLabelInfo, tplSerialize)
#                 VALUES ($pubtitle_id, $tplLabel(LabelProfileID), $tplLabel(LabelSizeID), '$tplLabel(Name)', '$tplLabel(LabelPath)', '$tplLabel(NotePriv)', '$tplLabel(NotePub)', '$tplLabel(FixedBoxQty)', '$tplLabel(FixedLabelInfo)', '$tplLabel(SerializeLabel)')"
#
#             db eval "INSERT INTO LabelTPL (PubTitleID, LabelProfileID, labelSizeID, tplLabelName, tplLabelPath, tplNotePriv, tplNotePub, tplFixedBoxQty, tplFixedLabelInfo, tplSerialize)
#                 VALUES ($pubtitle_id, $tplLabel(LabelProfileID), $tplLabel(LabelSizeID), '$tplLabel(Name)', '$tplLabel(LabelPath)', '$tplLabel(NotePriv)', '$tplLabel(NotePub)', '$tplLabel(FixedBoxQty)', '$tplLabel(FixedLabelInfo)', '$tplLabel(SerializeLabel)')"
#
#             set tpl_id [db eval "SELECT MAX(tplID) FROM LabelTPL"]
#             set tplLabel(ID) $tpl_id
#         } else {
#             ${log}::debug Template exists, updating...
#             db eval "UPDATE LabelTPL
#                         SET LabelProfileID = $tplLabel(LabelProfileID),
#                             labelSizeID = $tplLabel(LabelSizeID),
#                             tplLabelName = '$tplLabel(Name)',
#                             tplLabelPath = '$tplLabel(LabelPath)',
#                             tplNotePriv = '$tplLabel(NotePriv)',
#                             tplNotePub = '$tplLabel(NotePub)',
#                             tplFixedBoxQty = '$tplLabel(FixedBoxQty)',
#                             tplFixedLabelInfo = '$tplLabel(FixedLabelInfo)',
#                             tplSerialize = '$tplLabel(SerializeLabel)'
#                         WHERE tplID = $tpl_id"
#         }
#     }
#
#     # Check if the label profile allows text/etc
#     set haveData [db eval "SELECT LabelHeaders.LabelHeaderID FROM LabelHeaderGrp
#                             INNER JOIN LabelHeaders ON LabelHeaders.LabelHeaderID = LabelHeaderGrp.LabelHeaderID
#                             INNER JOIN LabelProfiles ON LabelProfiles.LabelProfileID = LabelHeaderGrp.LabelProfileID
#                                 WHERE LabelHeaderGrp.LabelProfileID = $tplLabel(LabelProfileID)
#                                 AND LabelHeaders.LabelHeaderSystemOnly = 0"]
#     if {$haveData ne ""} {
#         # Check if labelVersionID exists
#         #  - Doesn't Exist; Insert labelVersionID, Insert Row Data
#         # - Exists; Delete Row Data, then Insert
#
#         # Check to see if a new 'version' has been entered (typically happens on multi-version jobs)
#         set newVersion [.container.frame2.frame2a.labelData$tplLabel(tmpValues,rbtn) get]
#
#         if {$tplLabel(LabelVersionID,current) eq "" && $tplLabel(LabelVersionDesc,current) eq ""} {
#             # This is a new version, insert only. (Table: LabelVersions)
#             ${log}::notice LabelVersion ID doesn't exist, but Description does. Retrieving...
#             ${log}::notice LabelVersion Row: $tplLabel(tmpValues,rbtn) [.container.frame2.frame2a.labelData$tplLabel(tmpValues,rbtn) get]
#             ${log}::debug db eval "INSERT INTO LabelVersions (tplID, LabelVersionDesc) VALUES ($tpl_id, '[.container.frame2.frame2a.labelData$tplLabel(tmpValues,rbtn) get]')"
#
#             db eval "INSERT INTO LabelVersions (tplID, LabelVersionDesc) VALUES ($tpl_id, '[.container.frame2.frame2a.labelData$tplLabel(tmpValues,rbtn) get]')"
#
#             # Get version id
#             set tplLabel(LabelVersionID,current) [db eval "SELECT max(labelVersionID) FROM LabelVersions WHERE tplID = $tpl_id"]
#             ${log}::notice Retrieving new version ID: $tplLabel(LabelVersionID,current)
#
#             # Insert label date (Table: LabelData)
#             set data [join [ea::code::ld::getRowData $tplLabel(LabelVersionID,current) .container.frame2.frame2a]]
#             ${log}::notice Inserting Row Data: $data
#             ${log}::debug db eval "INSERT INTO LabelData (labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES $data"
#             db eval "INSERT INTO LabelData (labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES $data"
#
#         } elseif {[string equal $tplLabel(LabelVersionDesc,current) $newVersion] == 0} {
#             # Check to see if a new 'version' has been entered (typically happens on multi-version jobs)
#             ${log}::notice New Label Version detected
#
#             # Inserting Version info
#             db eval "INSERT INTO LabelVersions (tplID, LabelVersionDesc) VALUES ($tpl_id, '[.container.frame2.frame2a.labelData$tplLabel(tmpValues,rbtn) get]')"
#             set tplLabel(LabelVersionID,current) [db eval "SELECT max(labelVersionID) FROM LabelVersions WHERE tplID = $tpl_id"]
#             ${log}::notice Retrieving new version ID: $tplLabel(LabelVersionID,current)
#
#             set data [join [ea::code::ld::getRowData $tplLabel(LabelVersionID,current) .container.frame2.frame2a]]
#             ${log}::notice Inserting Row Data: $data
#
#             ${log}::debug db eval "INSERT INTO LabelData (labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES $data"
#             db eval "INSERT INTO LabelData (labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES $data"
#
#         } else {
#             # Remove existing data, and repopulate using existing LabelVersionID,current
#             ${log}::debug LabelVersionID,current: $tplLabel(LabelVersionID,current)
#             ${log}::notice Delete existing data for $tplLabel(LabelVersionDesc,current)
#             ${log}::debug db eval "DELETE FROM LabelData WHERE labelVersionID = $tplLabel(LabelVersionID,current)"
#             db eval "DELETE FROM LabelData WHERE labelVersionID = $tplLabel(LabelVersionID,current)"
#
#             ${log}::notice Entering new data for $tplLabel(LabelVersionDesc,current)
#             set data [join [ea::code::ld::getRowData $tplLabel(LabelVersionID,current) .container.frame2.frame2a]]
#             ${log}::debug db eval "INSERT INTO LabelData (labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES $data"
#             db eval "INSERT INTO LabelData (labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES $data"
#         }
#
#
#         # Update drop down values
#         .container.frame2.versionDescCbox configure -values [db eval "SELECT LabelVersionDesc FROM LabelVersions WHERE tplID = $tplLabel(ID)"]
#     }
# } ;# ea::code::ld::writeToDb
#
# proc ea::code::ld::modifyTemplate_old {wid} {
#     global log tplLabel job ldWid
#
#     #${log}::debug [$wid findcolumnname templateNumber]
#     #set widTplNumber [$wid findcolumnname templateNumber]
#
#
#     set widTplCustomer [$wid findcolumnname customerName]
#     set widTplTitle [$wid findcolumnname titleName]
#
#     #${log}::debug [$wid curselection]
#     #${log}::debug [lindex [$wid get [$wid curselection]] $widTplNumber]
#     #set tplLabel(ID) [lindex [$wid get [$wid curselection]] $widTplNumber]
#     set job(CustName) [lindex [$wid get [$wid curselection]] $widTplCustomer]
#     set job(Title) [lindex [$wid get [$wid curselection]] $widTplTitle]
#     ea::db::ld::getCustomerTitleID
#
#     # Retrieve data from ea DB
#      db eval "SELECT PubTitleID, LabelTPL.LabelProfileID as LabelProfileID, LabelProfiles.LabelProfileDesc as LabelProfileDesc, tplLabelName, tplLabelPath, Status
#                  FROM LabelTPL
#                  INNER JOIN LabelProfiles ON LabelTPL.LabelProfileID = LabelProfiles.LabelProfileID
#                  WHERE PubTitleID = $job(TitleID)" {
#                      ${log}::debug $PubTitleID, $LabelProfileID, $LabelProfileDesc, $tplLabelName, $tplLabelPath
#                      #set job(TitleID) $PubTitleID
#                      set tplLabel(LabelProfileID) $LabelProfileID
#                      set tplLabel(LabelProfileDesc) $LabelProfileDesc
#                      set tplLabel(Name) $tplLabelName
#                      set tplLabel(LabelPath) $tplLabelPath
#                      set tplLabel(Status) $Status
#                  }
#
#
#     # Retrieve customer name from Monarch
#     ea::db::ld::getCustomerName $job(TitleID)
#
#     # Retrieve Title Name from Monarch
#     ea::db::ld::getCustomerTitleName $job(TitleID)
#
#     # Populate title dropdown
#     #$ldWid(addTpl,f1).cbox0 configure -state normal
#     $ldWid(addTpl,f1).cbox0 set $job(Title)
#
#     # Retrieve the actual templates / Versions
#     ea::db::ld::getTemplates
#
#     # Retrieve label versions
#     ea::db::ld::getLabelVersions [ea::db::ld::getTemplateID $job(TitleID)]
#
#     # Set Label Version dropdown
#     $ldWid(addTpl,f2).versionDescCbox configure -values $tplLabel(LabelVersionDesc)
#     $ldWid(addTpl,f2).versionDescCbox set $tplLabel(LabelVersionDesc,current)
#
#     # Retreive label data
#     ea::db::ld::getLabelProfile
# } ;# ea::code::ld::modifyTemplate
#
# # Add new profiles
# proc ea::code::ld::populateProfileCbox {wid} {
#     # See: ea::db::ld::getLabelHeaders
#     global log
#
#     # delete all entries first
#     $wid delete 0 end
#     set items [join [ea::db::ld::getLabelHeaders]]
#
#     foreach item $items {
#         $wid insert end $item
#     }
# } ;#ea::code::ld::populateProfileCbox
#
# proc ea::code::ld::getAllHeaders {profile_id lbox1 lbox2} {
#     # Retrieve both available headers and assigned headers, then populate the listbox widgets with the data.
#     global log
#
#     set avail [ea::db::ld::getLabelHeaders]
#     set current [ea::db::ld::getProfileHeaders $profile_id]
#
#     set c_avail [ea::tools::listDiff $avail $current]
#     #${log}::debug c_avail: $c_avail
#     #${log}::debug current: $current
#
#     # Delete data from both list boxes before populating
#     $lbox1 delete 0 end
#     $lbox2 delete 0 end
#
#     foreach item $c_avail {
#         $lbox1 insert end $item
#     }
#
#     foreach item $current {
#         $lbox2 insert end $item
#     }
# } ;#ea::code::ld::getAllHeaders
#
# proc ea::code::ld::assignProfileHeaders {modify lbox1 lbox2} {
#     # Add selected header(s) to 'Assigned' listbox.
#     # We save everything in the DB when the user hits the 'save' button. Until then the changes are only within the widget
#     # Modify should equal add or del
#     global log
#
#     switch -- $modify {
#         "add"   {set wid1 $lbox1; set wid2 $lbox2}
#         "del"   {set wid1 $lbox2; set wid2 $lbox1}
#         default {${log}::debug assignProfileHeaders: arg for modify ($modify) is not valid. Must be add or del.; return}
#     }
#     #${log}::debug modify: $modify
#     #${log}::debug wid1: $wid1
#     #${log}::debug wid2: $wid2
#
#     # Current selection
#     set headers_id [$wid1 curselection]
#     ${log}::debug selected item id: $headers_id
#
#     foreach hdr $headers_id {
#         lappend headers [$wid1 get $hdr]
#     }
#     ${log}::debug selected item desc: $headers
#
#     # Remove selected from Available listbox (lbox1)
#     # We sort it (10 8 7), since if we don't we change the positions of what we want to delete, after deleting the first one.
#     foreach item [lsort -decreasing $headers_id] {
#         $wid1 delete $item
#     }
#
#     # Add selected to Assigned listbox (lbox2)
#     foreach item $headers {
#         $wid2 insert end $item
#     }
#
#     # unset vars
#     unset headers
# } ;#ea::code::ld::assignProfileHeaders
#
# proc ea::code::ld::editProfile {mode addPro_btn edit_btn add_btn del_btn cbox lbox2} {
#     # This button has two modes: (1) Enable add/del btns; (2) Saves Data
#     # Mode: edit or save
#     global log profile_id
#     ${log}::debug editProfile mode: $mode
#
#     if {$mode eq "edit"} {
#         ${log}::debug Enable - add/del, Enable cbox, change btn text
#         $add_btn configure -state normal
#         $del_btn configure -state normal
#         $cbox configure -state normal
#         $addPro_btn configure -state disable
#         $edit_btn configure -text [mc "Save"] -command "ea::code::ld::editProfile save $addPro_btn $edit_btn $add_btn $del_btn $cbox $lbox2"
#     } else {
#         # Saving
#         ${log}::debug Disable - add/del, readonly cbox, change btn text
#         ${log}::debug Reset Widgets (assigned lbox2), cbox, profile_id
#
#         $add_btn configure -state disable
#         $del_btn configure -state disable
#         $addPro_btn configure -state normal
#
#         $edit_btn configure -text [mc "Edit"] -state disable -command "ea::code::ld::editProfile edit $addPro_btn $edit_btn $add_btn $del_btn $cbox $lbox2"
#
#             ${log}::debug Profile: [$cbox get]
#             ${log}::debug Entries to save to DB: [$lbox2 get 0 end]
#             ea::db::ld::writeProfile $cbox $lbox2
#
#
#         # Final Cleanup
#         $lbox2 delete 0 end
#         $cbox delete 0 end
#         $cbox configure -state readonly
#
#         # Clear profile_id, and description
#         set profile_id ""
#         set tplLabel(tmp,profile) ""
#     }
# } ;#ea::code::ld::editProfile
#
# proc ea::code::ld::addProfile {mode addPro_btn edit_btn add_btn del_btn cbox lbox1 lbox2} {
#     # Add a new profile
#     global log tplLabel profile_id
#
#     # Clear profile_id
#     set profile_id ""
#
#     # Enable the cbox for editing
#     $cbox configure -state normal
#
#     # Clear out cbox, put focus
#     $cbox delete 0 end
#     focus $cbox
#
#     # Clear out lbox2
#     $lbox2 delete 0 end
#
#     # Re-populate lbox1 (available headers)
#     ea::code::ld::populateProfileCbox $lbox1
#
#     # Disable Add button
#     $addPro_btn configure -state disable
#
#     # Enable Add/Del buttons (To/From headers)
#     $add_btn configure -state normal
#     $del_btn configure -state normal
#
#     # Change edit button to 'Save'
#     $edit_btn configure -text [mc "Save"] -state normal -command "ea::code::ld::editProfile save $addPro_btn $edit_btn $add_btn $del_btn $cbox $lbox2"
# } ;#ea::code::ld::addProfile
