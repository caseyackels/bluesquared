# Scheduler Module
# a tool that assists in creating schedules, and responding to clients prior to the work entering the facility.
# essentially a prescheduler.

# Namespaces (app, module, categroy)
#   ea::sched::code {}
#   ea::sched::gui {}
#   ea::sched::db {}

# Register the module with the database
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