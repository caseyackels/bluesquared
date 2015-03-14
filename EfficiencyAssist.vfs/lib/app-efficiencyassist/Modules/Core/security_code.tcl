# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 03 08,2015
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
# Security related Procs

namespace eval ea::sec {}


proc ea::sec::initUser {{newUser 0}} {
    #****f* initUser/ea::sec
    # CREATION DATE
    #   03/08/2015 (Sunday Mar 08)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::sec::initUser ?newUser? ?passwd?
    #
    # FUNCTION
    #	Initilize the user array with values from env(USERNAME)
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   
    #   
    # NOTES
    #   $newUser would be set if this proc was called from ea::sec::newUser
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log user

    if {$newUser == 0} {
        # Check to see if the user is in the DB; adds them if they don't exist with basic info.
        set userName [ea::sec::userExist]
    } else {
        set userName $newUser
    }

    set user(id) [db eval "SELECT UserLogin FROM Users WHERE UserLogin='$userName'"]
    #if {$user(id) eq ""} {${log}::debug $userName is not listed in the database; return}
        
        
    set user($user(id),group) [db eval "SELECT SecGroupNames.SecGroupName FROM SecGroups
                                            -- # get Group Name
                                            INNER JOIN SecGroupNames ON SecGroups.SecGroupNameID = SecGroupNames.SecGroupName_ID
                                            -- # get User
                                            INNER JOIN Users on SecGroups.UserID = Users.User_ID
                                            WHERE Users.UserLogin = '$user(id)'
                                                AND Users.Users_Status = 1"]
    if {$user($user(id),group) == ""} {
        set user($user(id),group) NoGroup
    }
    
    set user($user(id),modules) [db eval "SELECT Modules.ModuleName FROM SecurityAccess
                                            -- # get Group ID
                                            INNER JOIN SecGroups ON SecGroups.SecGrp_ID = SecurityAccess.SecGrpID
                                            -- # get Module Name
                                            INNER JOIN Modules on Modules.Mod_ID = SecurityAccess.ModID
                                            -- # get Group Name
                                            INNER JOIN SecGroupNames on SecGroupNames.SecGroupName_ID = SecGroups.SecGroupNameID
                                            WHERE SecGroupNames.SecGroupName = '$user($user(id),group)'
                                                AND SecGroupNames.Status = 1"]
    if {$user($user(id),modules) == ""} {
        Error_Message::errorMsg EA001 "ID: $user(id)\nGroups: $user($user(id),group)\n\nLet your system administrator know that you need to be put into a group."
        exit
    }
    
} ;# ea::sec::initUser


proc ea::sec::userExist {} {
    #****f* userExist/ea::sec
    # CREATION DATE
    #   03/08/2015 (Sunday Mar 08)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::sec::userExist 
    #
    # FUNCTION
    #	Checks the DB to see if the user exist; if they don't exist, we add them.
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
    global log env user
    
    set userName [db eval "SELECT UserLogin FROM Users WHERE UserLogin='[string tolower $env(USERNAME)]'"]
	
	if {$userName == ""} {
		${log}::info $env(USERNAME) is not in the Database. Adding ...
		# Default password is <space>
		db eval "INSERT INTO Users (UserLogin, UserPwd) VALUES ('[string tolower $env(USERNAME)]', ' ')"
    
        #set userID [db eval "SELECT UserID from Users where UserLogin='$env(USERNAME)'"]
        
        # Put them in the default NoGroup Group
        #db eval "INSERT INTO SecGroups (SecGroupNameID, UserID) VALUES ('4','$userID')"
        #set groupID [db eval "SELECT SecGrp_ID from SecGroups WHERE UserID='$userID'"]
        ## using modID = 2; Batch Maker as a default
        #db eval "INSERT INTO SecurityAccess (SecGrpID, ModID, SecAccess_Read, SecAccess_Modify, SecAccess_Delete) VALUES ('$groupID', '2', '1', '0', '0')"
	} else {
		${log}::info Found $userName in the database.
    }
    
    set userName [db eval "SELECT UserLogin FROM Users WHERE UserLogin='[string tolower $env(USERNAME)]'"]
    return $userName

} ;# ea::sec::userExist


proc ea::sec::changeUser {newUser} {
    #****f* changeUser/ea::sec
    # CREATION DATE
    #   03/08/2015 (Sunday Mar 08)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::sec::changeUser user passwd
    #
    # FUNCTION
    #	Changes the user from the default (default is the windows user id of the person running the program)
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
    global log user

    if {[info exists user]} {${log}::debug Current User: $user(id), changing users ...}
    if {[db eval "SELECT UserLogin FROM Users WHERE UserLogin='$newUser'"] eq ""} {
        ${log}::debug $newUser does not exist, aborting.
        return
    } else {
        ${log}::debug $newUser exists, retrieving groups and permissions...
        unset user
        ea::sec::initUser $newUser
    }    
} ;# ea::sec::changeUser


proc ea::sec::setPasswd {pass} {
    #****f* setPasswd/ea::sec
    # CREATION DATE
    #   03/08/2015 (Sunday Mar 08)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::sec::setPasswd args 
    #
    # FUNCTION
    #	Inserts the users password into the DB, and create an associated salt
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
    global log user

    set salt [::md5crypt::salt 100]
    set passwd [::md5crypt::md5crypt $pass $salt]

    db eval "UPDATE Users SET UserPwd = '$passwd', UserSalt = '$salt' WHERE UserLogin = '$user(id)'"
    
} ;# ea::sec::setPasswd

proc ea::sec::authUser {userName pass} {
    #****f* authUser/ea::sec
    # CREATION DATE
    #   03/08/2015 (Sunday Mar 08)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::sec::authUser userName pass 
    #
    # FUNCTION
    #	Returns 1 if the user authenticates; Returns 0 if authentication fails
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
    global log user

    db eval "SELECT UserPwd, UserSalt FROM Users WHERE UserLogin = '$userName'" {
        set passwd $UserPwd
        set salt $UserSalt
    }

    set enteredPass [::md5crypt::md5crypt $pass $salt]
    
    if {$UserPwd eq ""} {
        # user doesn't have a password, system default ...
        ea::sec::changeUser $userName
        return 1
    }
    
    if {$passwd eq $enteredPass} {
        ${log}::debug Authenticated!
        set user($user(id),authenticated) 1
        ea::sec::changeUser $userName
        return 1
    } else {
        ${log}::debug Failed authentication!
        return 0
    }
   
} ;# ea::sec::authUser


proc ea::sec::modLauncher {args} {
    #****f* modLauncher/ea::sec
    # CREATION DATE
    #   03/09/2015 (Monday Mar 09)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::sec::modLauncher args 
    #
    # FUNCTION
    #	Ensures that the user has correct privleges before launching the module
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
    global log user settings

    lib::savePreferences ;# This will ensure that we saved the geometry to the module that we are coming from

    if {[lsearch $user($user(id),modules) $settings(currentModule)] == -1} {
        #${log}::debug [parray user]
        #${log}::debug User does not have access to view this module, switching ...
        eAssist::buttonBarGUI [join [lindex $user($user(id),modules) 0]]
        
    } else {
        if {$args == ""} {${log}::debug No args Provided; eAssist::buttonBarGUI [join [lindex $user($user(id),modules) 0]]}
        
        switch -nocase $args {
            "Box Labels"    {eAssist::buttonBarGUI $args}
            "Batch Maker"   {eAssist::buttonBarGUI $args}
            Setup           {eAssist::buttonBarGUI $args}
            default         {}
        }
    }

    
} ;# ea::sec::modLauncher
