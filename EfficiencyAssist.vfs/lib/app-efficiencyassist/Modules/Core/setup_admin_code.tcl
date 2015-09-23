# Creator: Casey Ackels
# File Initial Date: 02 22,2015
# Admin namespaces
# ea::code::admin
# ea::gui::admin
# ea::db::admin


proc ea::code::admin::initWidSecArray {mode {widRow ""}} {
    #****if* initWidSecArray/ea::code::admin
    # CREATION DATE
    #   09/16/2015 (Wednesday Sep 16)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   widRow is only used when using -populate
    #   
    #***
    global log widSec widTmp
    
    if {$mode eq "-populate"} {
        for {set x 0} {$x < [$widTmp(sec,users_f2).listbox columncount]} {incr x} {
                set widSec(users,[$widTmp(sec,users_f2).listbox columncget $x -name]) [$widTmp(sec,users_f2).listbox cellcget $widRow,$x -text]
        }
    } elseif {$mode eq "-clear"} {
        for {set x 0} {$x < [$widTmp(sec,users_f2).listbox columncount]} {incr x} {
                set widSec(users,[$widTmp(sec,users_f2).listbox columncget $x -name]) ""
        }
    }
} ;# ea::code::admin::initWidSecArray

proc eAssistSetup::readSecGroup {wid} {
    #****f* readSecGroup/eAssistSetup
    # CREATION DATE
    #   09/05/2015 (Saturday Sep 05)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::readSecGroup wid 
    #
    # FUNCTION
    #   Helper function for the Groups tab
    #	Reads the security groups from the database, and populates <wid>
    #   
    #    
    # NOTES
    #   
    #    
    #***
    global log
    
    $wid delete 0 end
    
    db eval "SELECT SecGroupName_ID, SecGroupName, Status FROM SecGroupNames" {
        $wid insert end [list {} $SecGroupName_ID $SecGroupName $Status]
    }

} ;# eAssistSetup::readSecGroup $f2.listbox

proc eAssistSetup::populateSecGroupEdit {dbid} {
    #****f* populateSecGroupEdit/eAssistSetup
    # CREATION DATE
    #   09/05/2015 (Saturday Sep 05)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::populateSecGroupEdit dbid 
    #
    # FUNCTION
    #	Retrieves the given dbid data and populates the Group Name widget, and the Active checkbutton
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
    global log widSec
    
    db eval "SELECT SecGroupName, Status FROM SecGroupNames WHERE SecGroupName_ID = $dbid" {
        set widSec(group,Name) $SecGroupName
        set widSec(group,Active) $Status
    }

    
} ;# eAssistSetup::populateSecGroupEdit

proc ea::db::insertSecGroup {mode widTbl args} {
    #****f* insertSecGroup/ea::db
    # CREATION DATE
    #   09/05/2015 (Saturday Sep 05)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::db::insertSecGroup <add|update> <widTbl> ?dbid?
    #
    # FUNCTION
    #	Inserts a new entry into the SecGroupNames table
    #	The dbid is required when using 'update'
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
    #   TODO: Upon inserting into SecGroupNames, we need to insert into SecurityAccess also.
    #   
    #***
    global log widSec
    
    set dbid $args
    
    if {$mode eq "add"} {
        # Insert into the db
        db eval "INSERT OR ABORT INTO SecGroupNames (SecGroupName, Status) VALUES ('$widSec(group,Name)','$widSec(group,Active)')"
        
        set lastGroupID [db eval "SELECT MAX(SecGroupName_ID) FROM SecGroupNames"]
        
        set modIDs [db eval "SELECT Mod_ID from Modules ORDER BY Mod_ID"]
        
        foreach mod $modIDs  {
            lappend sql_modsGroups "($lastGroupID, $mod)"
        }
        
        ${log}::debug db eval "INSERT OR ABORT INTO SecurityAccess (SecGrpNameID, ModID) VALUES [join $sql_modsGroups ,]"
        db eval "INSERT OR ABORT INTO SecurityAccess (SecGrpNameID, ModID) VALUES [join $sql_modsGroups ,]"
        
    } elseif {$mode eq "update" && $args ne ""} {
        ${log}::debug Updating ID: $dbid - $widSec(group,Name)
        db eval "UPDATE SecGroupNames SET SecGroupName='$widSec(group,Name)', Status='$widSec(group,Active)' WHERE SecGroupName_ID=$dbid"
    }

} ;# ea::db::insertSecGroup


proc ea::db::populateSecGroupSingleEntry {widTbl {widRow ""} {dbid ""}} {
    #****f* populateSecGroupSingleEntry/ea::db
    # CREATION DATE
    #   09/05/2015 (Saturday Sep 05)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::db::populateSecGroupSingleEntry tablelist_path ?dbid?
    #
    # FUNCTION
    #	Updates the tablelist with the newly added or updated data
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
    global log widTmp widSec
    
    # If a dbid was supplied, we've updated...
    if {$widRow eq "" && $dbid eq ""} {
        # Insert values into the tablelist
        db eval "SELECT max(SecGroupName_ID) as SecGroupName_ID, SecGroupName, Status FROM SecGroupNames" {
           $widTmp(sec,group_f2).listbox insert end [list {} $SecGroupName_ID $SecGroupName $Status]
        }

    } else {
        # Update the widTbl
        ${log}::debug Selection update: $widRow - dbid: $dbid
        $widTbl delete $widRow
        db eval "SELECT SecGroupName_ID, SecGroupName, Status FROM SecGroupNames WHERE SecGroupName_ID = $dbid" {
            $widTbl insert $widRow [list {} $SecGroupName_ID $SecGroupName $Status]
        }
        
        # Ensure button says "Add"; this could have been changed to 'update' a record.
        $widTmp(sec,group_wid_btn) configure -text [mc "Add"] -command {ea::db::insertSecGroup add $widTmp(sec,group_f2).listbox; ea::db::populateSecGroupSingleEntry $widTmp(sec,group_f2),listbox}
    }
    
    # Clear variables
    set widSec(group,Name) ""
    set widSec(group,Active) 0
} ;# ea::db::populateSecGroupSingleEntry

proc eAssistSetup::populateSecUsersEdit {method widTbl {widRow end} {userLogin ""}} {
    #****f* populateSecUsersEdit/eAssistSetup
    # CREATION DATE
    #   09/05/2015 (Saturday Sep 05)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::populateSecUsersEdit -update|-populate widTbl ?widRow? ?userLogin?
    #
    # FUNCTION
    #	Populates the Users tablelist widget from the database
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
    
    set sql "SELECT SecGroupNames.SecGroupName as groupName,
                    Users.User_ID as User_ID,
                    Users.UserLogin as UserLogin,
                    Users.UserName as UserName,
                    Users.UserEmail as UserEmail,
                    Users.User_Status as User_Status
                FROM SecGroups
                    LEFT JOIN Users on Users.User_ID = SecGroups.UserID
                    INNER JOIN SecGroupNames on SecGroupNames.SecGroupName_ID = SecGroups.SecGroupNameID"

    switch -- $method {
        -update     {
            append sql " WHERE SecGroups.UserID = (SELECT User_ID FROM Users WHERE UserLogin = '$userLogin')"
        }
        -populate   {
        }
        default     {${log}::debug [info level 0] unknown argument: $method}
    }

    db eval "$sql ORDER BY UserLogin" {
        $widTbl insert $widRow [list {} $User_ID $groupName $UserLogin $UserName $UserEmail $User_Status]
    }

} ;# eAssistSetup::populateSecUsersEdit

proc eAssistSetup::writeSecUsers {method widTbl widRow userGroup userName userLogin userPasswd {userEmail ""} {userStatus 1} {userID ""}} {
    #****f* writeSecUsers/eAssistSetup
    # CREATION DATE
    #   09/06/2015 (Sunday Sep 06)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::writeSecUsers -insert|-update <widTbl> <widRow> <userGroup> <userName> <userLogin> <userPasswd> ?userEmail? ?userStatus? ?userID?
    #
    # FUNCTION
    #	Command function, which controls writing/updating user data including passwords
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   userEmail defaults to <empty> if not supplied
    #   userStatus defaults to '1'
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log
    
    if {$method eq "-insert"} {
        # Adding a new record, password doesn't exist yet. Create Salt and encrypt.
        ${log}::debug [info level 0] -insert
        set passSalt [ea::sec::setPasswd $userPasswd]
            set pass [lindex $passSalt 0]
            set salt [lindex $passSalt 1]
            
            set widRow end
        
    } elseif {$method eq "-update"} {
        # Record exists, now check to see if the password field was populated, if it was retrieve pass and salt from DB
        ${log}::debug [info level 0] -update
        
        ${log}::debug [info level 0] -update - Password Field is blank, skipping...
        # Retrieve old pass and salt - these get overwritten if a new pass is detected
        set oldPassSalt [ea::db::getPasswd $userLogin]
            set pass [lindex $oldPassSalt 0]
            set salt [lindex $oldPassSalt 1]
        
        if {$userPasswd ne ""} {
            # Generate new pass and salt based on userPasswd
            ${log}::debug [info level 0] -update - Password Field contains data, adding to db...
            set newPassSalt [ea::sec::setPasswd $userPasswd $salt]
            
            # Compare the two, if they don't match, update passwd in db.
            if {![string match $oldPassSalt $newPassSalt]} {
                ${log}::debug [info level 0] -update - Field contains a new password
                set pass [lindex $newPassSalt 0]
                set salt [lindex $newPassSalt 1]
            }
        }
        $widTbl delete $widRow
    }
    
    
    # Write user data to database
    ea::db::writeUser $method $userGroup $userName $userLogin $pass $salt $userEmail $userStatus $userID
    
    # Update the widget
    eAssistSetup::populateSecUsersEdit -update $widTbl $widRow $userLogin

    ## Populate new/updated entry in tablelist
    #$widTbl insert $widRow "{} [ea::db::getUser $method $userID]"

    
} ;# eAssistSetup::writeSecUsers
proc ea::db::admin::populateModPerms {widTbl grpName} {
    #****if* populateModPerms/ea::db::admin
    # CREATION DATE
    #   09/17/2015 (Thursday Sep 17)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   
    #   
    #***
    global log

    $widTbl delete 0 end
    
    db eval "SELECT Modules.ModuleName as ModName, SecAccess_Read, SecAccess_Write, SecAccess_Delete FROM SecurityAccess
                INNER JOIN SecGroupNames ON SecurityAccess.SecGrpNameID = SecGroupNames.SecGroupName_ID
                INNER Join Modules ON SecurityAccess.ModID = Modules.Mod_ID
                WHERE SecGroupNames.SecGroupName = '$grpName'" {
                    # Display yes or no, instead of 1 or 0
                    set secRead [expr {$SecAccess_Read ? [mc "Yes"] : [mc "No"]}]
                    set secWrite [expr {$SecAccess_Write ? [mc "Yes"] : [mc "No"]}]
                    set secDel [expr {$SecAccess_Delete ? [mc "Yes"] : [mc "No"]}]

                    $widTbl insert end "{} [list $ModName] $secRead $secWrite $secDel"
                }

    
} ;# ea::db::admin::populateModPerms

proc ea::db::admin::updateModPerms {col value modName groupName} {
    #****if* updateModPerms/ea::db::admin
    # CREATION DATE
    #   09/18/2015 (Friday Sep 18)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    # NOTES
    #   
    #   
    #***
    global log
    
    ${log}::debug $col $value $modName $groupName

    db eval "UPDATE SecurityAccess SET $col=$value
                            WHERE ModID = (SELECT Mod_ID FROM Modules WHERE ModuleName = '$modName')
                            AND SecGrpNameID = (SELECT SecGroupName_ID FROM SecGroupNames
                                                    WHERE SecGroupName = '$groupName')"

} ;# ea::db::admin::updateModPerms

proc ea::db::admin::addUserToGroup {userLogin userModule} {
    #****f* addUserToGroup/ea::db::admin
    # CREATION DATE
    #   09/19/2015 (Saturday Sep 19)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::db::admin::addUserToGroup args 
    #
    # FUNCTION
    #	Adds/Edits the User's assigned group. We delete any existing entries before inserting, so we don't have to keep track if we are adding (new) or editing (updating existing)
    #   
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   
    #   
    #***
    global log

    set userid [db eval "SELECT User_ID from Users WHERE UserLogin = '$userLogin'"]
    set module [db eval "SELECT SecGroupName_ID FROM SecGroupNames WHERE SecGroupName = '$userModule'"]
    
    # Delete all records if they already exist
    db eval "DELETE FROM SecGroups WHERE UserID = $userid"


    # Now insert
    db eval "INSERT OR ABORT INTO SecGroups (SecGroupNameID, UserID)
                VALUES ($module, $userid)"
    
} ;# ea::db::admin::addUserToGroup
