# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 09 11,2014
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 169 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate$
#
########################################################################################

##
## - Overview
# Email DB Code

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


namespace eval maildb {}

proc maildb::getEmailText {moduleName eventName arg} {
    #****f* getEmailText/eAssist_db
    # CREATION DATE
    #   09/17/2014 (Wednesday Sep 17)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssist_db::getEmailBody moduleName eventName <-subject|-body>
    #
    # FUNCTION
    #	Retrieves the email notification setup (subject and body of the email)
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

    if {![info exists moduleName] || ![info exists eventName]} {
        return -code 1 [mc wrong # args: use eAssist_db::getEmailText <moduleName> <eventName> <-subject|-body> <Subject|]
    }
    
    switch -- $arg {
        -subject {db eval { SELECT EmailSubject FROM EmailNotifications WHERE ModuleName = $moduleName AND EventName = $eventName}}
        -body    {db eval { SELECT EmailBody FROM EmailNotifications WHERE ModuleName = $moduleName AND EventName = $eventName}}
    }
    
} ;# maildb::getEmailText


proc maildb::emailGateway {moduleName eventName} {
    #****f* emailGateway/maildb
    # CREATION DATE
    #   09/17/2014 (Wednesday Sep 17)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   maildb::emailGateway moduleName eventName
    #
    # FUNCTION
    #   Ensure that GlobalNotifications is not 0
    #   Ensure EnableModNotifications is not 0
    #   Ensure EventNotifications is not 0
    #	
    #   
    #   
    # CHILDREN
    #	 
    #   
    # PARENTS
    #   maildb::preProcessMail
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log

    # Can we send Notifications at all?
    if {![db eval {SELECT GlobalEmailNotification FROM EmailSetup WHERE ROWID = 1}]} {
        ${log}::notice GlobalEmailNotification is not enabled, not sending email.
        return 0
        }
        
    # Check to see if the Module is enabled to send notifications
    if {![db eval {SELECT EnableModNotification FROM Modules WHERE ModuleName = $moduleName}]} {
        ${log}::notice EnableModNotification ($moduleName) is not enabled, not sending email.
        return 0
    }
    
    # Now the specific events ... 
    if {![db eval {SELECT EventNotification FROM EmailNotifications WHERE ModuleName = $moduleName AND EventName = $eventName}]} {
        ${log}::notice EventNotification ($eventName) is not enabled, not sending email.
        return 0
    }
    
    return 1
} ;# maildb::emailGateway


proc maildb::emailNoticeFromTo {moduleName eventName key} {
    #****f* emailNoticeFromTo/maildb
    # CREATION DATE
    #   09/17/2014 (Wednesday Sep 17)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   maildb::emailNoticeFromTo moduleName eventName key
    #   key = -from or -to
    #
    # FUNCTION
    #	Retrieves the header information for the email
    #   
    #   
    # CHILDREN
    #	maildb::emailGateway mail::mail
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
    
    switch -- $key {
        -from   {return [db eval {SELECT EmailFrom FROM EmailNotifications WHERE ModuleName = $moduleName AND EventName = $eventName}]}
        -to     {return [db eval {SELECT EmailTo FROM EmailNotifications WHERE ModuleName = $moduleName AND EventName = $eventName}]}
        default {${log}::debug $key is not a valid switch}
    }
 
} ;# maildb::emailNoticeFromTo

