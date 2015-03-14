# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 07 29,2014
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 169 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2014-09-17 18:41:28 -0700 (Wed, 17 Sep 2014) $
#
########################################################################################

##
## - Overview
# Mailing module

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

package provide eAssist_email 1.0

namespace eval mail {}

proc mail::mail {moduleName eventName args} {
    #****f* mail/mail
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	mail::mail:: <moduleName> -from value -to value -subject value -body value
    #
    # SYNOPSIS
    #   Send a canned email to a recipient
    #   Mode = boxlabels or batchmaker
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	
    #
    # NOTES
    #   
    # SEE ALSO
    #
    #***
    global log emailSetup
    
    # Check to see if we can even send email
    if {![maildb::emailGateway $moduleName $eventName]} {return}

    set emailFrom [join [maildb::emailNoticeFromTo $::boxLabelsVars::cModName $eventName -from]]
	set emailTo [join [maildb::emailNoticeFromTo $::boxLabelsVars::cModName $eventName -to]]
    
    foreach {key value} $args {
        switch -- $key {
            -subject    {set emailSubject $value}
            -body       {set emailBody $value}
        }
    }
    
    ${log}::debug From: $emailFrom
    ${log}::debug To: $emailTo
    ${log}::debug Subject: $emailSubject
    ${log}::debug EmailBody: $emailBody

    
    set tok [mime::initialize -canonical text/plain -string $emailBody]
    ##
    ## To send to multiple people, we must add additional '-header' lines
    smtp::sendmessage $tok \
        -servers [list $emailSetup(email,serverName)] \
        -ports [list $emailSetup(email,port)] \
        -usetls 0 \
        -username $emailSetup(email,userName) \
        -password $emailSetup(email,password) \
        -header [list From [list $emailFrom]] \
        -header [list To "$emailTo"] \
        -header [list Subject "$emailSubject"] \
        -header [list Date "[clock format [clock seconds]]"]    
    
    
    mime::finalize $tok

}