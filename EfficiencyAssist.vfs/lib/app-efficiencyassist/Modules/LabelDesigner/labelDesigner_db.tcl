# Creator: Casey Ackels (C) 2017

proc ea::db::lb::getLabelNames {cbox} {
    global log tplLabel job
    
    if {$job(Title) eq ""} {return}
    if {$job(CustID) eq ""} {return}
    #if {$tpllabel(ID) eq ""} {return}
    
    set tmpPubTitleID [db eval "SELECT Title_ID FROM PubTitle WHERE TitleName = '$job(Title)' AND CustID = '$job(CustID)'"]
    ${log}::debug TemplateID exists? ($tmpPubTitleID)
    
    if {$tmpPubTitleID ne ""} {
        set labelNames [db eval "SELECT tplLabelName FROM LabelTPL WHERE PubTitleID = $tmpPubTitleID AND Status = 1"]
        
        if {$labelNames ne ""} {
            $cbox configure -values $labelNames
    
            ${log}::debug Label info exists, populate all widgets: Label Path, Width, Height, NumRows, FixedBoxQty, FixedRowInfo
        } else {
            ${log}::debug No labels exist
        }
    } else {
        ${log}::debug TemplateID doesn't exist, no value set
        $cbox configure -values ""
    }
} ;# ea::db::lb::getLabelNames


proc ea::db::lb::getLabelSpecs {cbox} {
    global log tplLabel job
    
    ${log}::debug cbox: $cbox

    set tmpLabelName [$cbox get]
    set tmpPubTitleID [db eval "SELECT Title_ID FROM PubTitle WHERE TitleName = '$job(Title)' AND CustID = '$job(CustID)'"]
    
    if {$tmpPubTitleID eq ""} {$cbox configure -values ""; ${log}::debug Title_ID is empty, exiting...; return}
    
    ${log}::debug tmpLabelName: $tmpLabelName
    ${log}::debug tmpPubTitleID: $tmpPubTitleID
    
    db eval "SELECT tplID, LabelTPL.LabelProfileID, LabelProfiles.LabelProfileDesc as LabelProfileDesc, tplLabelPath, LabelSizes.labelSizeDesc as Sizes, tplFixedBoxQty, tplFixedLabelInfo, tplSerialize
                FROM LabelTPL
                INNER JOIN LabelSizes ON LabelTPL.labelSizeID = LabelSizes.labelSizeID
                INNER JOIN LabelProfiles ON LabelTPL.LabelProfileID = LabelProfiles.LabelProfileID
            WHERE PubTitleID = $tmpPubTitleID AND tplLabelName = '$tmpLabelName'" {
                set tplLabel(ID) $tplID
                set tplLabel(LabelProfileID) $LabelProfileID
                set tplLabel(LabelProfileDesc) $LabelProfileDesc
                set tplLabel(LabelPath) $tplLabelPath
                set tplLabel(Size) $Sizes
                set tplLabel(FixedBoxQty) $tplFixedBoxQty
                set tplLabel(FixedLabelInfo) $tplFixedLabelInfo
                set tplLabel(SerializeLabel) $tplSerialize
    }
    
    # Do we have label versions?
    # clear the variables before creating widgets just in case we dont' have versions/label data
    set tplLabel(LabelVersionDesc) ""
    set tplLabel(LabelVersionDesc,current) ""
    set tplLabel(LabelVersionID) ""
    set tplLabel(LabelVersionID,current) ""
    
    db eval "SELECT labelVersionID, LabelVersionDesc FROM LabelVersions WHERE tplID = $tplLabel(ID)" {
        lappend tplLabel(LabelVersionID) $labelVersionID
        lappend tplLabel(LabelVersionDesc) $LabelVersionDesc
    }
    
    if {$tplLabel(LabelVersionID) eq ""} {${log}::debug No Versions detected.}

    # Do we need to retrieve label text?    
    if {$tplLabel(FixedLabelInfo) != 0 && $tplLabel(LabelVersionID) != 0} {
        
        # Get first version
        db eval "SELECT min(ROWID), labelVersionID, LabelVersionDesc FROM LabelVersions WHERE tplID = $tplLabel(ID)" {
            set tplLabel(LabelVersionID,current) $labelVersionID
            set tplLabel(LabelVersionDesc,current) $LabelVersionDesc
        }

        ea::db::lb::setProfileVars
        #ea::code::lb::genLines
        #ea::db::lb::getVersionLabel
    }
} ;# ea::db::lb::getLabelSpecs

proc ea::db::lb::getVersionLabel {} {
    global log tplLabel
    
    ${log}::debug getVersionLabel started
    set col 0
    set rw 2
    set f2a .container.frame2.frame2a
    
    if {[winfo exists $f2a]} {destroy $f2a}
    
    grid [ttk::frame $f2a] -column 0 -columnspan 2 -row 1
    
    grid [ttk::label $f2a.headerDesc -text [mc "Line Description"]] -column 1 -row 1 -pady 3p ;#-sticky e
    grid [ttk::label $f2a.headerUserEdit -text [mc "User Editable?"]] -column 2 -row 1 -pady 3p -ipadx 15 ;#-sticky e
    grid [ttk::label $f2a.headerVersionToggle -text [mc "Version?"]] -column 3 -row 1 -pady 3p -ipadx 15 ;#-sticky e
    
    if {$tplLabel(ID) eq ""} {
        ${log}::debug tplLabel(ID) is empty
        for {set x 1} {$x <= $tplLabel(LabelProfileRowNum)} {incr x} {
            grid [ttk::label $f2a.description$x -text [mc "Row $x"]] -column $col -row $rw -pady 2p -padx 2p -sticky e
            
            incr col
            grid [ttk::entry $f2a.labelData$x -width 35] -column $col -row $rw -pady 2p -padx 2p -sticky ew
            $f2a.labelData$x delete 0 end
            
            # Label Option / Editable?
            incr col
            set tplLabel(tmpValues,ckbtn,$x) 0
            grid [ttk::checkbutton $f2a.userEditable$x -variable tplLabel(tmpValues,ckbtn,$x)] -column $col -row $rw -pady 2p -padx 2p -ipadx 15 ;#-sticky ew
    
            # Label Option / Version?
            incr col
            #set tplLabel(tmpValues,rbtn) 0
            ${log}::debug ttk::radiobutton $f2a.isVersion$x -value $x -variable tplLabel(tmpValues,rbtn)
            grid [ttk::radiobutton $f2a.isVersion$x -value $x -variable tplLabel(tmpValues,rbtn)] -column $col -row $rw -pady 2p -padx 2p -ipadx 15 ;#-sticky ew
            
            # reset counters
            incr rw
            set col 0
        }
    
    } elseif {$tplLabel(LabelVersionID,current) eq ""} {
        ${log}::debug LabelVersionID,current is empty. Creating widgets without data.
        for {set x 1} {$x <= $tplLabel(LabelProfileRowNum)} {incr x} {
            #grid [ttk::label $f2a.description$x -text [mc "Row $x"]] -column $col -row $rw -pady 2p -padx 2p -sticky e
            #
            #incr col
            #grid [ttk::entry $f2a.labelData$x -width 35] -column $col -row $rw -pady 2p -padx 2p -sticky ew
            #$f2a.labelData$x delete 0 end
            #
            ## Label Option / Editable?
            #incr col
            #set tplLabel(tmpValues,ckbtn,$x) 0
            #grid [ttk::checkbutton $f2a.userEditable$x -variable tplLabel(tmpValues,ckbtn,$x)] -column $col -row $rw -pady 2p -padx 2p -ipadx 15 ;#-sticky ew
            #
            ## Label Option / Version?
            #incr col
            #set tplLabel(tmpValues,rbtn) 0
            #grid [ttk::radiobutton $f2a.isVersion$x -value $x -variable tplLabel(tmpValues,rbtn)] -column $col -row $rw -pady 2p -padx 2p -ipadx 15 ;#-sticky ew
            #
            ## reset counters
            #incr rw
            #set col 0
        }
    } else {
        ${log}::debug tpl(id) and labelVersionID,current exists ...
        set x 1
        db eval "SELECT labelRowNum, labelRowText, userEditable, isVersion FROM LabelData WHERE labelVersionID = '$tplLabel(LabelVersionID,current)'" {
                ${log}::debug Row: $labelRowNum, $labelRowText, $userEditable, $isVersion
                # Row Labels
                grid [ttk::label $f2a.description$x -text [mc "Row $labelRowNum"]] -column $col -row $rw -pady 2p -padx 2p -sticky e
                
                # Label Data
                incr col
                grid [ttk::entry $f2a.labelData$x -width 35] -column $col -row $rw -pady 2p -padx 2p -sticky ew
                $f2a.labelData$x delete 0 end
                $f2a.labelData$x insert end $labelRowText
                
                # Label Option / Editable?
                incr col
                set tplLabel(tmpValues,ckbtn,$x) $userEditable
                grid [ttk::checkbutton $f2a.userEditable$x -variable tplLabel(tmpValues,ckbtn,$x)] -column $col -row $rw -pady 2p -padx 2p -ipadx 15 ;#-sticky ew
    
                # Label Option / Version?
                incr col
                grid [ttk::radiobutton $f2a.isVersion$x -value $x -variable tplLabel(tmpValues,rbtn)] -column $col -row $rw -pady 2p -padx 2p -ipadx 15 ;#-sticky ew
                if {$isVersion == 1} {$f2a.isVersion$x invoke}
                
                # reset counters
                incr rw
                incr x
                set col 0
        }
    }
    
}

proc ea::db::lb::getProfile {cbox} {
    global log
    
    $cbox configure -values [db eval "SELECT LabelProfileDesc FROM LabelProfiles"]
    
}

proc ea::db::lb::getProfileID {args} {
    # Retrieves the profile id assocatiated to 'args' value, which should be the profile description.
    global log
    
    return [db eval "SELECT LabelProfileID FROM LabelProfiles WHERE LabelProfileDesc = '[join $args]'"]
}

proc ea::db::lb::getLabelHeaders {} {
    global log
    
    return [db eval "SELECT LabelHeaderDesc FROM LabelHeaders"]
}

proc ea::db::lb::getProfileHeaders {profile_id} {
    # return the headers associated with profile_id
    
    return [db eval "SELECT LabelHeaderDesc FROM LabelHeaders
                         INNER JOIN LabelHeaderGrp ON LabelHeaders.LabelHeaderID = LabelHeaderGrp.LabelHeaderID
                         WHERE LabelHeaderGrp.LabelProfileID = $profile_id"]
}

proc ea::db::lb::getSizes {cbox} {
    global log tplLabel
    
    $cbox configure -values [db eval "SELECT labelSizeDesc FROM LabelSizes"]
}

proc ea::db::lb::setProfileVars {} {
    global log tplLabel
    
    ${log}::debug Setting Profile Vars
        # Template hasn't been saved, this is a new entry.
        db eval "SELECT LabelProfileID FROM LabelProfiles WHERE LabelProfileDesc = '$tplLabel(LabelProfileDesc)'" {
            set tplLabel(LabelProfileID) $LabelProfileID
        }


    ${log}::debug LabelProfileID: $tplLabel(LabelProfileID)
    # Get number of rows so we can create widgets
    ea::db::lb::getNumRows
    
    if {[winfo exists .container.frame2]} {
        # Destroy any widgets that have been created.
        ${log}::debug Label Lines frame already exists, destroying...
        destroy .container.frame2
    }
    
    if {$tplLabel(LabelProfileRowNum) ne 0} {
        # Create the widgets
        ea::code::lb::genLines
    }

}

proc ea::db::lb::getNumRows {} {
    global log tplLabel 
    
    db eval "SELECT COUNT(LabelHeadergrp.LabelHeaderID) FROM LabelHeaderGrp
            INNER JOIN LabelProfiles ON LabelHeaderGrp.LabelProfileID = LabelProfiles.LabelProfileID
            INNER JOIN LabelHeaders ON LabelHeaders.LabelHeaderID = LabelHeaderGrp.LabelHeaderID
        WHERE LabelProfiles.LabelProfileID = $tplLabel(LabelProfileID)
            AND LabelHeaders.LabelHeaderSystemOnly = 0" {
                set tplLabel(LabelProfileRowNum) $COUNT(LabelHeadergrp.LabelHeaderID)
            }
    
        ${log}::debug LabelProfileRowNum: $tplLabel(LabelProfileRowNum)
}

proc ea::db::lb::writeProfile {cbox lbox2} {
    # Write profile to DB. Can be new or existing.
    global log tplLabel profile_id
    
    # Check to see if Profile name already exists, if it does warn user. Otherwise insert.
    if {$profile_id eq ""} {
        set profile_name [$cbox get]
        db eval "INSERT OR ABORT INTO LabelProfiles (LabelProfileDesc) VALUES ('$profile_name')"
        
        set profile_id [db eval "SELECT MAX(LabelProfileID) FROM LabelProfiles"]

    } else {
        # We are updating existing values
        # Update the ProfileDesc just in case we modified it.
        db eval "UPDATE LabelProfiles SET LabelProfileDesc = '$tplLabel(tmp,profile)' WHERE LabelProfileID = $profile_id"
        
        # Delete any existing assigned headers before adding
        db eval "DELETE FROM LabelHeaderGrp WHERE LabelProfileID = $profile_id"
    }
    
    set getHeaderDesc [$lbox2 get 0 end]
    if {$getHeaderDesc ne ""} {
        foreach item $getHeaderDesc {
            lappend myHdrDesc '$item'
        }
        
        set getHeaderDesc [join $myHdrDesc ,]
        
        #${log}::debug hdr-id: db eval "SELECT LabelHeaderID FROM LabelHeaders WHERE LabelHeaderDesc IN ($getHeaderDesc)"
        db eval "SELECT LabelHeaderID FROM LabelHeaders WHERE LabelHeaderDesc IN ($getHeaderDesc)" {
            #${log}::debug INSERT INTO VALUES ($profile_id, $LabelHeaderID)
            db eval "INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES ($profile_id, $LabelHeaderID)"
        }
        
        unset myHdrDesc
    } else {
        ${log}::notice No headers were selected. Nothing saved to the database.
    }
}