# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 03 08,2015
#-------------------------------------------------------------------------------

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
    #   ea::sec::initUser ?newUser?
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
                                                AND Users.User_Status = 1"]
    if {$user($user(id),group) == ""} {
        set user($user(id),group) NoGroup
    }
    
    set user($user(id),modules) [db eval "SELECT Modules.ModuleName FROM SecurityAccess
											-- # get Module Name
											INNER JOIN Modules on Modules.Mod_ID = SecurityAccess.ModID
											-- # get Group Name
											INNER JOIN SecGroupNames ON SecGroupNames.SecGroupName_ID = SecurityAccess.SecGrpNameID
											  WHERE SecGroupNames.SecGroupName = '$user($user(id),group)'
												AND SecGroupNames.Status = 1"]
    
	# Throw an error/information dialog, telling the user that they are not in a group
	if {$user($user(id),modules) == ""} {
        Error_Message::errorMsg EA001 "ID: $user(id)\nGroups: $user($user(id),group)\n\nLet your system administrator know that you need to be put into a group."
        #exit
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
	
	set defaultGroupID 3 ;# Warehouse - Should add a group called "NOGROUP" for the default
	
	set user_Name [string tolower $env(USERNAME)]
    
    set userName [db eval "SELECT UserLogin FROM Users WHERE UserLogin='$user_Name'"]
	
	if {$userName == ""} {
		${log}::info $env(USERNAME) is not in the Database. Adding ...
		# Default password is <space>
		db eval "INSERT INTO Users (UserLogin, UserPwd) VALUES ('$userName', ' ')"
		set user_id [db eval "SELECT max(User_ID) FROM Users WHERE UserLogin = '$user_Name'"]
		
		db eval "INSERT INTO SecGroups (SecGroupNameID, UserID) ($defaultGroupID, $user_id)"

	} else {
		${log}::info Found $userName in the database.
    }
    
    set userName [db eval "SELECT UserLogin FROM Users WHERE UserLogin='$user_Name'"]
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


proc ea::sec::setPasswd {pass {salt 0}} {
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
    #   ea::sec::setPasswd ?salt? 
    #
    # FUNCTION
    #	Creates a Salt and a Salted Password; returns Passwd, Salt
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

	if {$salt == 0} {
		set salt [::md5crypt::salt 100]
	}

    set passwd [::md5crypt::md5crypt $pass $salt]
	
	return [list $passwd $salt]
    
} ;# ea::sec::setPasswd

proc ea::db::writeUser {method userGroup userName userLogin userPasswd userSalt {userEmail ""} {userStatus 1} {userID ""}} {
    #****f* writeUser/ea::db
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
    #   ea::db::writeUser -insert|-update userGroup userName userLogin userPassword userSalt ?userEmail? ?userStatus? ?userID?
    #
    # FUNCTION
    #	Writes the user info to the database, and returns the userID
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   ea::db::admin::addUserToGroup, ea::db::writePasswd
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log

    if {$method eq "-insert"} {
		${log}::debug Writing New user info to db: $userName, $userLogin, $userEmail, $userStatus
		db eval "INSERT OR ABORT INTO Users (UserName, UserLogin, UserPwd, UserSalt, UserEmail, User_Status)
					VALUES ('$userName', '$userLogin', '$userPasswd', '$userSalt', '$userEmail', $userStatus)"
	
		
	} elseif {$method eq "-update"} {
		db eval "UPDATE Users SET UserName='$userName', UserLogin='$userLogin', UserEmail='$userEmail', User_Status=$userStatus
					WHERE User_ID = $userID"
					
		
		# If the password field is populated, lets up date the db
		if {$userPasswd ne ""} {
			set passwd [ea::db::getPasswd $userLogin]
            set pass [lindex $passwd 0]
            set salt [lindex $passwd 1]
			
			ea::db::writePasswd $method $pass $salt $userLogin
		}
	}	

	ea::db::admin::addUserToGroup $userLogin $userGroup
	
	return $userID
} ;# ea::db::writeUser

proc ea::db::getUser {method {id 0}} {
    #****f* getUser/ea::db
    # CREATION DATE
    #   09/07/2015 (Monday Sep 07)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   ea::db::getUser method ?id?
	#   id is only used when method is -update
    #
    # FUNCTION
    #	Returns all user info
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

    if {$method eq "-insert"} {
		return [db eval "SELECT max(User_ID), UserLogin, UserName, UserEmail, User_Status FROM Users"]
	
	} elseif {$method eq "-update"} {
		return [db eval "SELECT User_ID, UserLogin, UserName, UserEmail, User_Status FROM Users WHERE User_ID = $id"]
	}

} ;# ea::db::getUser

proc ea::db::writePasswd {method passwd salt userLogin} {
    #****f* writePasswd/ea::db
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
    #   ea::db::writePasswd -update|-insert passwd salt userLogin
    #
    # FUNCTION
    #	Inserts/Updates the password in the DB
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

	if {$method eq "-update"} {
		db eval "UPDATE Users SET UserPwd = '$passwd', UserSalt = '$salt' WHERE UserLogin = '$userLogin'"
		
	} elseif {$method eq "-insert"} {
		db eval "INSERT INTO Users (UserPwd, UserSalt) VALUES ('$passwd', '$salt') WHERE UserLogin = '$userLogin'"
	}

} ;# ea::db::writePasswd

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

proc ea::sec::validatePasswd {oldPasswd} {
    #****f* validatePasswd/ea::sec
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
    #   ea::sec::validatePasswd <oldPasswd>
    #
    # FUNCTION
    #	Validates the password that the user entered to the one that we have in the DB for that user
	#	
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

	set pass_and_salt [ea::db::getPasswd]
	set db_oldPasswd [lindex $pass_and_salt 0]
	set db_oldSalt [lindex $pass_and_salt 1]
	
	# Salt/crypt user entered passwd
	set userOldPasswd [ea::sec::setPasswd $oldPasswd $db_oldSalt]
    
	if {[string match $db_oldPasswd [lindex $userOldPasswd 0]]} {
		${log}::debug Passwords match!
	} else {
		${log}::debug Passwords do not match. Try again.
	}
    
} ;# ea::sec::validatePasswd

proc ea::db::getPasswd {user} {
    #****f* getPasswd/ea::db
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
    #   ea::db::getPasswd user 
    #
    # FUNCTION
    #	Retrieves the password and salt from the database from the given user login
	#	Returns: Password, Salt
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

	return [db eval "SELECT UserPwd, UserSalt FROM Users WHERE UserLogin = '$user'"]
} ;# ea::db::getPasswd

proc ea::sec::getAccessState {method args} {
	#****if* getAccessState/ea::sec
	# CREATION DATE
	#   09/23/2015 (Wednesday Sep 23)
	#
	# AUTHOR
	#	Casey Ackels
	#
	# COPYRIGHT
	#	(c) 2015 Casey Ackels
	#   
	# NOTES
	#   Returns what state the OK, Cancel, Delete buttons should be
	#
	# USAGE
	#	$gui(pref,btnBar).ok configure -state [ea::sec::getAccessState -w $args]
	#   
	#***
	global log

	set args [join [join $args]]
	
	# Read
	lappend access [expr {[lindex [join $args] 0] ? "normal" : "disable"}]
	# Write
	lappend access [expr {[lindex [join $args] 1] ? "normal" : "disable"}]
	# Delete
	lappend access [expr {[lindex [join $args] 2] ? "normal" : "disable"}]
	
	switch -- $method {
		-r		{set accessValue [lindex $access 0]}
		-w		{set accessValue [lindex $access 1]}
		-d		{set accessValue [lindex $access 2]}
		-all	{set accessValue $access}
		default	{${log}::debug [info level 0] Parameters must be one of: -r, -w, -d, -all; return}
	}

	return $accessValue
} ;# ea::sec::getAccessState
