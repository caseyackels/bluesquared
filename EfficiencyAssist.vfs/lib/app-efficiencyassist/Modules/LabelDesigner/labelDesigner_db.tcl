# Creator: Casey Ackels (C) 2017

proc ea::db::lb::getLabelNames {cbox} {
    global log tplLabel job
    
    if {$job(Title) eq ""} {return}
    if {$job(CustID) eq ""} {return}
    
    set tmpPubTitleID [db eval "SELECT Title_ID FROM PubTitle WHERE TitleName = '$job(Title)' AND CustID = '$job(CustID)'"]
    set labelNames [db eval "SELECT tplLabelName FROM LabelTPL WHERE PubTitleID = $tmpPubTitleID"]

    
    if {$labelNames ne ""} {
        $cbox configure -values $labelNames
        
        ${log}::debug Label info exists, populate all widgets: Label Path, Width, Height, NumRows, FixedBoxQty, FixedRowInfo
    } else {
        ${log}::debug No labels exist
    }
}


proc ea::db::lb::getLabelSpecs {cbox} {
    global log tplLabel job
    
    ${log}::debug cbox: $cbox

    
    set tmpLabelName [$cbox get]
    set tmpPubTitleID [db eval "SELECT Title_ID FROM PubTitle WHERE TitleName = '$job(Title)' AND CustID = '$job(CustID)'"]
    
    #${log}::debug [db eval "SELECT * FROM LabelTPL WHERE PubTitleID = $tmpPubTitleID AND tplLabelName = '$tmpLabelName'"]
    
    db eval "SELECT tplID, tplLabelPath, tplLabelWidth, tplLabelHeight, tplRows, tplFixedBoxQty, tplFixedLabelInfo FROM LabelTPL WHERE PubTitleID = $tmpPubTitleID AND tplLabelName = '$tmpLabelName'" {
        set tplLabel(ID) $tplID
        set tplLabel(LabelPath) $tplLabelPath
        set tplLabel(Width) $tplLabelWidth
        set tplLabel(Height) $tplLabelHeight
        set tplLabel(NumRows) $tplRows
        set tplLabel(FixedBoxQty) $tplFixedBoxQty
        set tplLabel(FixedLabelInfo) $tplFixedLabelInfo
    }
}