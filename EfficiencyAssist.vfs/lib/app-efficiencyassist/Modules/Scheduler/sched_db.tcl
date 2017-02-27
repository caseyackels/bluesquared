# Scheduler Module
# a tool that assists in creating schedules, and responding to clients prior to the work entering the facility.
# essentially a prescheduler.

# Namespaces (app, module, categroy)
#   ea::sched::code {}
#   ea::sched::gui {}
#   ea::sched::db {}


##
## USED IN STARTUP
## Register the module with the database

proc ea::sched::db::regWithDB {} {
    global log
    db eval {INSERT or IGNORE INTO Modules (ModuleName, EnableModNotification, ModuleCode) VALUES ('Scheduler',1,'SC')}
       
    set modID [db eval "SELECT Mod_ID FROM Modules WHERE ModuleName = 'Scheduler'"]
    set groupNameID [db eval "SELECT SecGroupName_ID FROM SecGroupNames WHERE SecGroupName = 'Admin'"]
    
    ## If module is already added to the db, then we don't need to execute the following code. We need to abort the proc.
    set accessExists [db eval "SELECT * from SecurityAccess WHERE SecGrpNameID = $groupNameID AND ModID = $modID"]
    if {$accessExists != ""} {return}
    
    ea::sched::db::regWithSecurity $modID $groupNameID
}

# Register the module with Security Access (table)
proc ea::sched::db::regWithSecurity {mod_id group_id} {

    db eval "INSERT or IGNORE INTO SecurityAccess (SecGrpNameID, ModID, SecAccess_Read, SecAccess_Write, SecAccess_Delete)
                VALUES ($group_id, $mod_id, 1, 1, 1)"
}

##
## Used in SETUP
##

proc ea::sched::db::getAllGroupNames {args} {
    global log
    
    switch -- $args {
        -g  {set data [list [db eval "SELECT groups_name FROM sched_Groups"]]}
        -n  {set data [db eval "SELECT dateType_Name FROM sched_DateType"]}
        default {${log}::debug Unknown $args, must use -g or -n}
    }
    
    return $data
}

proc ea::sched::db::addDateType {name grp weekend plant freight usps} {
    global log sched
    ${log}::info Button Press (Setup, Scheduler, Date Type, Add) OK
    ${log}::info Command and Args: [info level 0]
    
    set groupExists [db eval "SELECT groups_name FROM sched_Groups WHERE groups_name = '$grp'"]
    
    if {$groupExists == ""} {
        # the group doesn't exist we have to add it.
        ${log}::info Inserting new group: $grp
        db eval "INSERT INTO sched_Groups (groups_name) VALUES ('$grp')"
    }
    
    set grp_id [db eval "SELECT groups_id FROM sched_Groups WHERE groups_name = '$grp'"]
    set dateTypeExists [db eval "SELECT dateType_Name FROM sched_DateType WHERE dateType_Name = '$name'"]
    
    if {$dateTypeExists == ""} {
        # Enter main data into DateTypes table
        ${log}::debug Inserting DateType Data: $name $weekend $plant $freight $usps
        db eval "INSERT INTO sched_DateType (fk_groups_id, dateType_Name, dateType_Weekend, dateType_PlantHoliday, dateType_FreightHoliday, dateType_USPSHoliday)
                VALUES ($grp_id, '$name', '$weekend', '$plant', '$freight', '$usps')"
    } else {
        ${log}::info Date Type exists, not adding to the db.
    }
}

proc ea::sched::db::delDateType {w} {
    global log
    set name [$w get [$w curselection]]
    
    ${log}::info Button Press (Setup, Scheduler, Date Type) DELETE
    ${log}::info Command and Args: [info level 0] / $name
    
    #${log}::debug Delete $name from sched_DateType
    
    db eval "DELETE FROM sched_DateType WHERE dateType_Name = '$name'"
    
    # delete from the GUI
    $w delete [$w curselection]
}

proc ea::sched::db::getDateTypeSetup {w} {
    global log sched
    
    set dateTypeName [$w get [$w curselection]]
    set dateTypeSetup [db eval "SELECT dateType_Weekend, dateType_PlantHoliday, dateType_FreightHoliday, dateType_USPSHoliday FROM sched_DateType WHERE dateType_Name = '$dateTypeName'"]

    set sched(avoid_weekend) [lindex $dateTypeSetup 0]
    set sched(avoid_plantHoliday) [lindex $dateTypeSetup 1]
    set sched(avoid_freightHoliday) [lindex $dateTypeSetup 2]
    set sched(avoid_USPSHoliday) [lindex $dateTypeSetup 3]
}

proc ea::sched::db::writeFreqency {desc freq} {
    global log sched
    
    db eval "INSERT INTO sched_frequency (frequency_desc, frequency_days) VALUES ('$desc', $freq)"
    
    # Update listbox
}

##
## Used in Scheduler module
##