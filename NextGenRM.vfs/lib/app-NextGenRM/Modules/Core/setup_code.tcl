##
## ----------  STATES
##

proc rmGUI::AddState {abbr state tbl} {  
    set abbr_txt [string toupper [$abbr get]]
    set state_txt [string totitle [$state get]]
    
    rmDB::AddState $abbr_txt $state_txt
    
    $tbl insert end [list $abbr_txt $state_txt]
    
    # Clear the entry widgets
    $abbr delete 0 end
    $state delete 0 end
} ;# rmGUI::AddState

proc rmDB::AddState {abbr state} {
    global log
    
    if {[string length $abbr] != 2} {
        #TODO This should probably throw an error window
        ${log}::notice The State Abbreviation ($abbr) does not equal two chars!
        return
    }
    
    db eval "INSERT INTO States (StateAbbr, StateName) VALUES ('$abbr', '$state')"
}

proc rmGUI::DeleteState {tbl row} {
    $tbl delete $row
}

proc rmDB::DelState {data tbl row} {
    # Remove from GUI
    rmGUI::DeleteState $tbl $row
    
    set abbr [lrange $data 0 0]
    set state [lrange $data 1 1]
    
    # Remove from database
    db eval "DELETE FROM States WHERE StateAbbr = '$abbr' AND StateName = '$state'"
    
}

proc rmDB::ReadStates {tbl} {
    
    db eval "SELECT StateAbbr, StateName FROM States" {
        $tbl insert end "$StateAbbr $StateName"
    }
    
    
}

proc rmDB::GetStateAbbr {} {
    return [db eval "SELECT StateAbbr FROM States"]
}

proc rmDB::GetStateID {stateabbr} {
    return [db eval "SELECT State_ID FROM States WHERE StateAbbr = '$stateabbr'"]
}

##
## ----------  Tax Type
##

proc rmDB::InsertTaxType {wid_entry wid_lbox} {
    global log tmp
    
    # Always in title case
    set data [string totitle [$wid_entry get]]
    $wid_entry delete 0 end
    
    if {$tmp(taxtype,id) != ""} {
        # We are updating an existing entry
        db eval "UPDATE TaxTypes SET TaxTypeName = '$data' WHERE TaxType_ID = $tmp(taxtype,id)"
 
        set tmp(taxtype,id) ""
    } else {
        ${log}::debug InsertTaxType: data - $data
        db eval "INSERT INTO TaxTypes (TaxTypeName) VALUES ('$data')"
    }
    
    # Clear listbox and re-read values.
    $wid_lbox delete 0 end
    rmDB::ReadTaxType $wid_lbox
        
}

proc rmDB::ReadTaxType {wid_lbox} {
    global log
    
    $wid_lbox insert end [join [db eval "SELECT TaxTypeName FROM TaxTypes"]]
}

proc rmDB::GetTaxTypeID {wid args} {
    if {$args == ""} {
        set args [$wid get [$wid curselection]]
    }
    
    return [db eval "SELECT TaxType_ID FROM TaxTypes WHERE TaxTypeName = '$args'"]
}

proc rmDB::GetTaxType {} {
    return [db eval "SELECT TaxTypeName FROM TaxTypes"]
}

##
## ----------  Liquor Type
##

proc rmDB::LiquorType {wid_entry wid_lbox} {
    global log tmp
    
    # Always in title case
    set data [string totitle [$wid_entry get]]
    $wid_entry delete 0 end
    
    if {$tmp(liquortype,id) != ""} {
        # We are updating an existing entry
        db eval "UPDATE LiquorType SET LiquorTypeName = '$data' WHERE LiquorType_ID = $tmp(liquortype,id)"
 
        set tmp(liquortype,id) ""
    } else {
        ${log}::debug InsertLiquorType: data - $data
        db eval "INSERT INTO LiquorType (LiquorTypeName) VALUES ('$data')"
    }
    
    # Clear listbox and re-read values.
    $wid_lbox delete 0 end
    rmDB::ReadLiquorType $wid_lbox
        
}

proc rmDB::ReadLiquorType {wid_lbox} {
    global log
    
    $wid_lbox insert end [join [db eval "SELECT LiquorTypeName FROM LiquorType"]]
}

proc rmDB::GetLiquorTypeID {wid args} {
    if {$args == ""} {
        set args [$wid get [$wid curselection]]
    }
    
    return [db eval "SELECT LiquorType_ID FROM LiquorType WHERE LiquorTypeName = '$args'"]
}

##
## ----------  Tax Rates
## Insert, Read, Update, Remove?

proc rmDB::InsertTaxRate {cbox1 cbox2 entry2 tbl} {
    global log
    
    set state [$cbox1 get]
    set stateid [rmDB::GetStateID $state]
    set taxtype [$cbox2 get]
    set taxtypeid [rmDB::GetTaxTypeID "" $taxtype]
    set taxpct [$entry2 get]
    
    catch {expr {$taxpct + 0}} err
    if {$err ne $taxpct} {
        ${log}::debug err: $err Tax Percent is not a valid number ($taxpct). Exiting...
        return
    }
    
    db eval "INSERT INTO TaxRates (StateID, TaxTypeID, TaxPercent) VALUES ($stateid, $taxtypeid, $taxpct)"
    
    $tbl insert end "$state $taxtype $taxpct"
    
    ${log}::debug $state $taxtype $taxpct
}

proc rmDB::PopulateTaxRate {tbl} {
    global log
    
    db eval "SELECT StateAbbr, TaxTypeName, TaxPercent FROM TaxRates
                        INNER JOIN States ON State_ID = StateID
                        INNER JOIN TaxTypes ON TaxType_ID = TaxTypeID" {
                            $tbl insert end "$StateAbbr $TaxTypeName $TaxPercent"
                        }
}

proc rmGUI::DeleteTaxRate {tbl row} {
    $tbl delete $row
}

proc rmDB::DelTaxRate {data tbl row} {
    rmGUI::DeleteTaxRate $tbl $row
    
    set abbr [lrange $data 0 0]
    set taxtype [lrange $data 1 1]
    set taxpct [lrange $data 2 2]
    
    # Remove from database
    
    set dbdata [db eval "SELECT StateID, TaxTypeID, TaxPercent FROM TaxRates
                        INNER JOIN States on StateID = State_ID
                        INNER JOIN TaxTypes on TaxTypeID = TaxType_ID
                            WHERE States.StateAbbr = '$abbr'
                            AND TaxTypes.TaxTypeName = '$taxtype'
                            AND TaxPercent = '$taxpct'"]
    
    set stateid [lrange $dbdata 0 0]
    set taxtypeid [lrange $dbdata 1 1]
                
    db eval "DELETE FROM TaxRates WHERE StateID = $stateid AND TaxTypeID = $taxtypeid AND TaxPercent = '$taxpct'"
}

proc rmDB::GetTaxRateNames {} {
    return [db eval "SELECT TaxTypeName FROM TaxTypes"]
}

##
## ----------  Purchased Items (PCL)
##

proc rmDB::GetPCLID {lname} {
    return [db eval "SELECT PurchasedItemsList_ID FROM PurchasedItemsList WHERE ListName = '$lname'"]
}

proc rmDB::GetPCLNames {} {
    return [db eval "SELECT ListName FROM PurchasedItemsList"]
}

proc rmDB::InsertPCLitems {lnameWid inameWid priceWid taxtypeWid} {
    global log
    
    set lname [$lnameWid get]
    set iname [$inameWid get]
    set price [$priceWid get]
    set taxtype [$taxtypeWid get]
    
    if {$lname eq ""} {return}
    if {$iname eq ""} {return}
    if {$price eq ""} {return}
    if {$taxtype eq ""} {return}
    
    # Check if listname already exists
    set listID [rmDB::GetPCLID $lname]
    set taxtypeid [rmDB::GetTaxTypeID $taxtypeWid $taxtype]
    
    if {$listID == ""} {
        # List Name doesn't exist, lets insert..
        db eval "INSERT INTO PurchasedItemsList (ListName) VALUES ('$lname')"
        
        set listID [rmDB::GetPCLID $lname]
    }
    
    # Insert the data
    ${log}::debug Inserting Purchased List data into PurchasedItems...
    db eval "INSERT INTO PurchasedItems (PurchasedItemsListID, ItemName, ItemCost, TaxTypeID) VALUES ($listID, '$iname', '$price', $taxtypeid)"
}

proc rmDB::readPCLitems {tbl lnameWid} {
    global log
    
    set lname [$lnameWid get]
    
    db eval "SELECT TaxTypes.TaxTypeName AS TaxType, ItemName, ItemCost FROM PurchasedItems
                INNER JOIN PurchasedItemsList ON PurchasedItemsListID = PurchasedItemsList_ID
                INNER JOIN TaxTypes ON TaxTypeID = TaxType_ID
                    WHERE PurchasedItemsList.ListName = '$lname'" {
                        $tbl insert end [list "$ItemName" "$ItemCost" "$TaxType"]
                    }
                
                
}