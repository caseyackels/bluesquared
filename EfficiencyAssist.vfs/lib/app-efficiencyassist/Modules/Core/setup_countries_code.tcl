# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 09 29,2014
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
# DB Commands for Setup_Countries

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

proc eAssistSetup::placeholder {tbl row col text} {return $text}

proc eAssistSetup::loadCtryProv {method tbl wid dbTable cols args} {
    #****f* loadCtryProv/eAssistSetup
    # CREATION DATE
    #   10/16/2014 (Thursday Oct 16)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::loadCtryProv method tbl wid dbTable cols args
    #   method = -add | -delete | -query
    #   tbl = table widget
    #   wid = entry widgets
    #   dbTable = Table in db
    #   cols = Column Names
    #   
    #
    # FUNCTION
    #	Refreshes the table widget with data from the DB
    #	e.g. We just added a country code and name, this proc will refresh the widget with the data that we just inserted into the db.
    #   
    #   
    # CHILDREN
    #	eAssistSetup::modifyCountry
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
    global log program
    if {[info exists region]} {unset region}
    
    # Insert the data into the db first; then refresh
    switch -- $method {
        -add    {eAssistSetup::modifyCountry $tbl $dbTable $wid $cols}
        -delete {eAssistSetup::delCountryProv $tbl $dbTable}
        -query  {set region [eAssist_db::dbSelectQuery -columnNames $cols -table $dbTable]}
        default {}
    }


    #set region [eAssist_db::dbSelectQuery -columnNames $cols -table $dbTable]
    #set children [winfo children $wid]
    #${log}::debug Children: $children
    foreach item [winfo children $wid] {
        if {[string match *cbx* $item]} {
            set widCountry $item
        }
    }
    
    #switch -nocase $dbTable {
    #    countries {set data "[lrange %val 0 1] [lrange %val 2 end]"}
    #    provinces {set data "[lrange %val 0 1] [lrange %val 2 end]"}
    #    default {${log}::critical Table isn't set up in [info level]: $dbTable; return}
    #}
    
    if {[info exists region]} {
        $tbl delete 0 end
        
        foreach value $region {
            # the quoting works for the tablelist widget; unknown for listboxes
            #$tbl insert end "{} [subst [string map "%val $data" $value]]"
            $tbl insert end "{} $value"
            #${log}::debug insert end "{} $value"
            
        }
    } else {
        eAssistSetup::dbGetProvinces $tbl $widCountry
        ${log}::debug Retrieved Provinces ....
    }

} ;# eAssistSetup::loadCtryProv

proc eAssistSetup::modifyCountry {tbl dbTable wid cols} {
    #****f* modifyCountry/eAssistSetup
    # CREATION DATE
    #   09/29/2014 (Monday Sep 29)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::addCountry tbl wid
    #
    # FUNCTION
    #	tbl = path to the tablelist widget
    #   wid = path to the entry widgets
    #   dbTable = Table that we want to reference in the database
    #   cols = Column Names
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   eAssistSetup::loadCtryProv
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log

    ${log}::debug win: $tbl $wid
    
    set children [winfo children $wid]
    if {[winfo exists valuesToInsert]} {unset valuesToInsert}
    
    # Retrieves data from each entry widget, and puts them into a list.
    # Clear out all entry widgets
    foreach item $children {
        
        if {[string match -nocase *entry* $item] == 1} {
            ${log}::debug CHILDREN - $item _ [$item get]
            lappend valuesToInsert [$item get]
            $item delete 0 end
        }
        if {[string match -nocase *cbx* $item] == 1} {
            set cName [$item get]
        }
    }
    
    # If we're inserting a province, we'll need the country code ID
    if {$dbTable eq "Provinces"} {
        lappend valuesToInsert [db eval "SELECT Country_ID FROM Countries WHERE CountryName='$cName'"]
    }
    
    #${log}::debug inserting values: $valuesToInsert
    ## insert into the table widget
    #$tbl insert end "{} $valuesToInsert"
    
    # insert into the DB
    ${log}::debug valuesToInsert - $valuesToInsert
    eAssist_db::dbInsert -columnNames $cols -table $dbTable -data $valuesToInsert
} ;# eAssistSetup::modifyCountry


proc eAssistSetup::delCountryProv {wTbl dbTable} {
    #****f* delCountryProv/eAssistSetup
    # CREATION DATE
    #   10/10/2014 (Friday Oct 10)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::delCountryProvtbl 
    #
    # FUNCTION
    #	Deletes the selected row from the widget, and database
    #   
    #   
    # CHILDREN
    #	eAssist_db::delete
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

    #$tbl delete [$tbl curselection]
    ${log}::debug curselection: [$wTbl curselection]
    
    set row_data [$wTbl get [$wTbl curselection]]
    set row_id [lrange $row_data 1 1]
    
    ${log}::debug row_data: $row_data
    ${log}::debug row_id: $row_id

    # Delete from DB
    eAssist_db::delete $dbTable "" $row_id
    
} ;# eAssistSetup::delCountryProv


proc eAssistSetup::editTblEntry {tbl wid dbTable idx} {
    #****f* editTblEntry/eAssistSetup
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
    #   eAssistSetup::editTblEntry tbl wid
    #   tbl = Tablelist widget path
    #   wid = Entry Widget path
    #   dbTable = Name of the db table that we're dealing with
    #   idx = Index Column
    #
    # FUNCTION
    #	Gets the selected values, and populates the entry widgets that exist in the passed frame
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
    global log tmp

    
    # Grag the rowid, so that we can update the record instead of inserting a new one.
    set data [$tbl get [$tbl curselection]]
    set tmp(db,ID) [lrange $data 1 1]
    ${log}::debug db_ID [lrange $data 1 1]
    set tmp(db,rowID) [eAssist_db::dbWhereQuery -columnNames rowid -table $dbTable -where $idx='$tmp(db,ID)']
    
    set children [winfo children $wid]
    if {[winfo exists widgets]} {unset widgets}
    
    foreach item $children {
        #${log}::debug CHILDREN - $item
        if {[string match -nocase *entry* $item] == 1} {
            lappend widgets $item
        }
    }
    
    set x 2 ;# Using 2 because we don't want to insert the row count, or db index into the entry widgets.
    foreach wid $widgets {
        ${log}::debug $wid insert end [lrange $data $x $x]
        $wid delete 0 end
        $wid insert end [join [lrange $data $x $x]]
        incr x
    }

    
} ;# eAssistSetup::editTblEntry


proc eAssistSetup::resetEntries {wid} {
    #****f* resetEntries/eAssistSetup
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
    #   eAssistSetup::resetEntries args 
    #
    # FUNCTION
    #	Reset the entry widgets, and unsets the global vars that may have been set
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
    global log tmp
    
    if {[info exists tmp(db,rowID)]} {unset tmp(db,rowID)}
    
    set children [winfo children $wid]
    foreach item $children {
        if {[string match -nocase *entry* $item] == 1} {
            $item delete 0 end
        }
    }
    
    

    

    
} ;# eAssistSetup::resetEntries

proc eAssistSetup::getCountries {win} {
    #****f* getCountries/eAssistSetup
    # CREATION DATE
    #   10/10/2014 (Friday Oct 10)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::getCountries win 
    #
    # FUNCTION
    #	Retrieves the list of country names in the database
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

    $win.cbx1 configure -values [eAssist_db::dbSelectQuery -columnNames CountryName -table Countries]

    
} ;# eAssistSetup::getCountries


#proc eAssistSetup::countryEditEnd {tbl row col text} {
#    #****f* countryEditEnd/eAssistSetup
#    # CREATION DATE
#    #   09/29/2014 (Monday Sep 29)
#    #
#    # AUTHOR
#    #	Casey Ackels
#    #
#    # COPYRIGHT
#    #	(c) 2014 Casey Ackels
#    #   
#    #
#    # SYNOPSIS
#    #   eAssistSetup::countryEditEnd args 
#    #
#    # FUNCTION
#    #	What does it do?
#    #   
#    #   
#    # CHILDREN
#    #	N/A
#    #   
#    # PARENTS
#    #   
#    #   
#    # NOTES
#    #   
#    #   
#    # SEE ALSO
#    #   
#    #   
#    #***
#    global log
#    
#    set win [$tbl editwinpath]
#    ${log}::debug Tbl: $tbl Row: $row Col: $col Text: $text
#    ${log}::debug win: $win
#    
#
#    #$w(hdr_frame1a).listbox
#    
#    switch -- [$tbl columncget $col -name] {
#        CountryCode { if {[string length $text] ne 2} {
#                            return -code 1 [mc "Two character code only!\nYou entered: $text"]
#                            #break
#                        } else {
#                            set newTxt $text
#                        }
#        }
#        CountryName { foreach val $text {
#                        lappend newTxt [string totitle $val]
#                    }
#        }
#        default     {}
#    }
#    
#    $tbl cellconfigure $row,$col -text $newTxt
#
#    ${log}::debug dbInsert [lrange [$tbl get $row] 1 end]
#    eAssistSetup::dbInsertCountry [lrange [$tbl get $row] 1 end]
#    return $newTxt
#} ;# eAssistSetup::countryEditEnd


proc eAssistSetup::dbInsertCountry {args} {
    #****f* dbInsertCountry/eAssistSetup
    # CREATION DATE
    #   09/29/2014 (Monday Sep 29)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::dbInsert args 
    #
    # FUNCTION
    #	Inserts data into specified table and column
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
    set args [join $args]
    set cCode [lrange $args 0 0]
    set cName [lrange $args 1 end]

    set dbCheck [eAssist_db::dbWhereQuery -columnNames "CountryCode CountryName" -table Countries -where CountryCode='$cCode']
    set myWhere "WHERE CountryCode = '$cCode'"
    
    if {$dbCheck == 0} {
        # Didn't find the CountryCode in the DB, lets see if we can find the CountryName. The user may have modified the country name.
        set dbCheck [eAssist_db::dbWhereQuery -columnNames "CountryCode CountryName" -table Countries -where CountryName='$cName']
        set myWhere "WHERE CountryName = '$cName'"
        #${log}::debug Found the CountryName: $dbCheck
    }
    
    if {$dbCheck eq ""} {
        # INSERT
        db eval "INSERT or ABORT INTO Countries (CountryCode, CountryName) VALUES ('$cCode', '$cName')"
    } else {
        # UPDATE
        db eval "UPDATE Countries SET CountryCode = '$cCode', CountryName = '$cName' $myWhere"
    }

} ;# eAssistSetup::dbInsertCountry


proc eAssistSetup::dbGetProvinces {win country} {
    #****f* dbGetProvinces/eAssistSetup
    # CREATION DATE
    #   09/29/2014 (Monday Sep 29)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::dbGetProvinces win country
    #
    # FUNCTION
    #	Retrieves the list of provinces already entered into the DB
    #	win - province table
    #   country - widget path to retrieve the country name
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
    global log program
    
    $win delete 0 end
    
    set cName [$country get]
    
    set program(db,currentCountryID) [db eval "SELECT Country_ID FROM Countries WHERE CountryName='$cName'"]
    ${log}::debug country code: $program(db,currentCountryID)
    ${log}::debug win: $win
    
    #WHERE Countries.CountryCode = '$program(db,currentCountryID)'" {}
    db eval "SELECT Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd
             FROM Provinces
                INNER JOIN Countries
                    ON Countries.Country_ID = Provinces.CountryID
                    WHERE Countries.Country_ID = '$program(db,currentCountryID)'" {
                        $win insert end [list {} $Prov_ID $ProvAbbr $ProvName $PostalCodeLowEnd $PostalCodeHighEnd]
                        ${log}::debug PROVINCES: [list {} $Prov_ID $ProvAbbr $ProvName $PostalCodeLowEnd $PostalCodeHighEnd]
                    }

    
} ;# eAssistSetup::dbGetProvinces




#proc eAssistSetup::provinceEditEnd {tbl row col text} {
#    #****f* provinceEditEnd/eAssistSetup
#    # CREATION DATE
#    #   09/30/2014 (Tuesday Sep 30)
#    #
#    # AUTHOR
#    #	Casey Ackels
#    #
#    # COPYRIGHT
#    #	(c) 2014 Casey Ackels
#    #   
#    #
#    # SYNOPSIS
#    #   eAssistSetup::provinceEditEndCmd args 
#    #
#    # FUNCTION
#    #	What does it do?
#    #   
#    #   
#    # CHILDREN
#    #	N/A
#    #   
#    # PARENTS
#    #   
#    #   
#    # NOTES
#    #   
#    #   
#    # SEE ALSO
#    #   
#    #   
#    #***
#    global log
#
#    set win [$tbl editwinpath]
#    ${log}::debug Tbl: $tbl Row: $row Col: $col Text: $text
#    ${log}::debug win: $win
#
#    
#    switch -- [$tbl columncget $col -name] {
#        ProvAbbr { if {[string length $text] ne 2} {
#                            return -code 1 [mc "Two character code only!\nYou entered: $text"]
#                            #break
#                        } else {
#                            set newTxt [string toupper $text]
#                            set table Provinces
#                        }
#        }
#        ProvName { foreach val $text {
#                        lappend newTxt [string totitle $val]
#                    }
#                    set table Provinces
#                }
#        PostalCodeLowEnd    {set newTxt $text; set table PostalCodes }
#        PostalCodeHighEnd   {set newTxt $text; set table PostalCodes }
#        default     {}
#    }
#    
#    #$tbl cellconfigure $row,$col -text $newTxt
#
#    ${log}::debug dbInsertProv $tbl get
#    #eAssistSetup::dbInsertProv [lrange [$tbl get $row] 1 end]
#    return $newTxt
#
#} ;# eAssistSetup::provinceEditEnd
#
#
#proc eAssistSetup::dbInsertProv {args} {
#    #****f* dbInsertProv/eAssistSetup
#    # CREATION DATE
#    #   09/30/2014 (Tuesday Sep 30)
#    #
#    # AUTHOR
#    #	Casey Ackels
#    #
#    # COPYRIGHT
#    #	(c) 2014 Casey Ackels
#    #   
#    #
#    # SYNOPSIS
#    #   eAssistSetup::dbInsertProv args 
#    #
#    # FUNCTION
#    #	Inserts/Updates Province entries
#    #   
#    #   
#    # CHILDREN
#    #	N/A
#    #   
#    # PARENTS
#    #   
#    #   
#    # NOTES
#    #   
#    #   
#    # SEE ALSO
#    #   
#    #   
#    #***
#    global log program
#
#    set data [$args get 0 end]
#    # This should return the db ID for the current country
#    set countryID [db eval "SELECT Country_ID FROM Countries WHERE CountryCode='$program(db,currentCountryCode)'"]
#    
#    foreach entry $data {
#        set pAbbr [join [lrange $entry 1 1]]
#        set pName [join [lrange $entry 2 2]]
#        set pCodeHi [join [lrange $entry 3 3]]
#        set pCodeLo [join [lrange $entry 4 4]]
#        
#        if {$pAbbr eq {}} {${log}::debug Not inserting into db, no abbreviation yet; break}
#        if {$pName eq {}} {${log}::debug Not inserting into db, no province name yet; break}
#        
#        ${log}::debug $pAbbr $pName $pCodeHi $pCodeLo
#    }
#    
#
#
#
#    
#    #${log}::debug countryID: $countryID
#
#    # Match Country and Province Abbreviation
#    #set dbCheck [eAssist_db::dbWhereQuery -columnNames "ProvAbbr ProvName" -table Provinces -where "CountryID='$countryID' AND ProvAbbr='$pAbbr'"]
#    #set myWhere "CountryID='$countryID' AND ProvAbbr='$pAbbr'"
#    #set myProv "ProvName = '$pName'"
#    #
#    #if {$dbCheck == 0} {
#    #    ${log}::debug Didn't match province abbreviation, trying province name
#    #    # Didn't find the Province Abbreviation in the DB, lets see if we can find the Province Name. The user may have modified the abbreviation.
#    #    set dbCheck [eAssist_db::dbWhereQuery -columnNames "ProvAbbr ProvName" -table Provinces -where "CountryID='$countryID' AND ProvName='$pName'"]
#    #    set myWhere "CountryID='$countryID' AND ProvName='$pName'"
#    #    set myProv "ProvAbbr = '$pAbbr'"
#    #    #${log}::debug Found the CountryName: $dbCheck
#    #}
#    #
#    #${log}::debug CountryID: $countryID
#    #${log}::debug dbCheck: $dbCheck
#    #
#    #if {$dbCheck == ""} {
#    #    # INSERT
#    #    ${log}::debug Inserting into db ... $args
#    #    db eval "INSERT or ABORT INTO Provinces (ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID)
#    #        VALUES ('$pAbbr', '$pName', '$pCodeLo', '$pCodeHi', '$countryID')"
#    #} else {
#    #    # UPDATE
#    #    ${log}::debug UPDATEing into db ... $args
#    #    ${log}::debug Elements - myProv: $myProv
#    #    ${log}::debug Elements - LowEnd: $pCodeLo
#    #    ${log}::debug Elements - HighEnd: $pCodeHi
#    #    ${log}::debug Elements - CountryID: $countryID
#    #    #db eval "UPDATE Countries SET CountryCode = '$cCode', CountryName = '$cName' $myWhere"
#    #    db eval "UPDATE Provinces SET $myProv,
#    #                                    PostalCodeLowEnd = '$pCodeLo',
#    #                                    PostalCodeHighEnd = '$pCodeHi'
#    #                            WHERE $myWhere"
#    #}
#
#    
#}
##
##proc eAssistSetup::dbInsertProv {args} {
##    #****f* dbInsertProv/eAssistSetup
##    # CREATION DATE
##    #   09/30/2014 (Tuesday Sep 30)
##    #
##    # AUTHOR
##    #	Casey Ackels
##    #
##    # COPYRIGHT
##    #	(c) 2014 Casey Ackels
##    #   
##    #
##    # SYNOPSIS
##    #   eAssistSetup::dbInsertProv args 
##    #
##    # FUNCTION
##    #	Inserts/Updates Province entries
##    #   
##    #   
##    # CHILDREN
##    #	N/A
##    #   
##    # PARENTS
##    #   
##    #   
##    # NOTES
##    #   
##    #   
##    # SEE ALSO
##    #   
##    #   
##    #***
##    global log program
##
##    set args [join $args]
##    
##    ${log}::debug Prov Args: $args
##    ${log}::debug ProvName: [lrange $args 1 1]
##
##    set pAbbr [join [lrange $args 0 0]]
##    set pName [join [lrange $args 1 1]]
##    set pCodeHi [join [lrange $args 2 2]]
##    set pCodeLo [join [lrange $args 3 3]]
##    
##    if {$pAbbr eq {}} {${log}::debug Not inserting into db, no abbreviation yet; return}
##    if {$pName eq {}} {${log}::debug Not inserting into db, no province name yet; return}
##
##    # This should return the db ID for the current country
##    set countryID [db eval "SELECT Country_ID FROM Countries WHERE CountryCode='$program(db,currentCountryCode)'"]
##    #${log}::debug countryID: $countryID
##
##    # Match Country and Province Abbreviation
##    set dbCheck [eAssist_db::dbWhereQuery -columnNames "ProvAbbr ProvName" -table Provinces -where "CountryID='$countryID' AND ProvAbbr='$pAbbr'"]
##    set myWhere "CountryID='$countryID' AND ProvAbbr='$pAbbr'"
##    set myProv "ProvName = '$pName'"
##    
##    if {$dbCheck == 0} {
##        ${log}::debug Didn't match province abbreviation, trying province name
##        # Didn't find the Province Abbreviation in the DB, lets see if we can find the Province Name. The user may have modified the abbreviation.
##        set dbCheck [eAssist_db::dbWhereQuery -columnNames "ProvAbbr ProvName" -table Provinces -where "CountryID='$countryID' AND ProvName='$pName'"]
##        set myWhere "CountryID='$countryID' AND ProvName='$pName'"
##        set myProv "ProvAbbr = '$pAbbr'"
##        #${log}::debug Found the CountryName: $dbCheck
##    }
##    
##    ${log}::debug CountryID: $countryID
##    ${log}::debug dbCheck: $dbCheck
##    
##    if {$dbCheck == ""} {
##        # INSERT
##        ${log}::debug Inserting into db ... $args
##        db eval "INSERT or ABORT INTO Provinces (ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID)
##            VALUES ('$pAbbr', '$pName', '$pCodeLo', '$pCodeHi', '$countryID')"
##    } else {
##        # UPDATE
##        ${log}::debug UPDATEing into db ... $args
##        ${log}::debug Elements - myProv: $myProv
##        ${log}::debug Elements - LowEnd: $pCodeLo
##        ${log}::debug Elements - HighEnd: $pCodeHi
##        ${log}::debug Elements - CountryID: $countryID
##        #db eval "UPDATE Countries SET CountryCode = '$cCode', CountryName = '$cName' $myWhere"
##        db eval "UPDATE Provinces SET $myProv,
##                                        PostalCodeLowEnd = '$pCodeLo',
##                                        PostalCodeHighEnd = '$pCodeHi'
##                                WHERE $myWhere"
##    }
##
##    
##}