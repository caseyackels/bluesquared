# Creator: Casey Ackels
# File Initial Date: 02 22,2015

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
    #   
    #   
    #***
    global log widSec
    
    set dbid $args
    
    if {$mode eq "add"} {
        # Insert into the db
        db eval "INSERT OR ABORT INTO SecGroupNames (SecGroupName, Status) VALUES ('$widSec(group,Name)','$widSec(group,Active)')"
    
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

proc eAssistSetup::populateSecUsersEdit {widTbl} {
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
    #   eAssistSetup::populateSecUsersEdit widTbl
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
    global log

    $widTbl delete 0 end
    
    db eval "SELECT User_ID, UserLogin, UserName, UserEmail, User_Status FROM Users" {
        $widTbl insert end [list {} $User_ID $UserLogin $UserName $UserEmail $User_Status]
    }

} ;# eAssistSetup::populateSecUsersEdit

proc eAssistSetup::writeSecUsers {method widTbl userName userLogin userPasswd {userEmail ""} {userStatus 1}} {
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
    #   eAssistSetup::writeSecUsers -insert|-update <widTbl> <userName> <userLogin> <userPasswd> ?userEmail? ?userStatus?
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

    # Write user data to database
    set usrID [ea::db::writeUser $method $userName $userLogin $userEmail $userStatus]
    
    # Write password to database
    
    # Populate new/updated entry in tablelist

    
} ;# eAssistSetup::writeSecUsers
