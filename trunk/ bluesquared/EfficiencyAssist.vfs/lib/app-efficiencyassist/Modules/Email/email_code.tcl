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
# $LastChangedDate$
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

proc mail::mail {mode SUB TEXT} {
    #****f* mail/mail
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	mail::mail:: <Mode> <Subject> <Text>
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
    #   Server, user and password are hardcoded.
    # SEE ALSO
    #
    #***
    global log emailSetup

    # Ensure <mode> is valid
    if {$mode eq "boxlabels" || $mode eq "batchmaker"} {
        ${log}::debug Email Mode: OK
    } else {
        ${log}::debug Email Mode: FAILED - Please use boxlabels or batchmaker
        return
    }
    
    if {$emailSetup($mode,Notification) == 0} {
        ${log}::notice Email Notification is DISABLED
        return
    } else {
        ${log}::notice Email Notifications is ENABLED
    }
    
    # All of these options should be user configurable
    #set USERNAME casey.ackels
    #set PASSWORD 1520567954CaDel
    #set USERNAME jg.shipping
    #set PASSWORD shipping
    #set SERVER mail.journalgraphics.com
    #set PORT 25
    #
    #set FROM $emailSetup($mode,From)
    #set TO $emailSetup($mode,To)
    #set SUBJECT "$emailSetup($mode,Subject) $SUB"
    
    set tok [mime::initialize -canonical text/plain -string $TEXT]
    ##
    ## To send to multiple people, we must add additional '-header' lines
    smtp::sendmessage $tok \
        -servers [list $emailSetup(email,serverName)] \
        -ports [list $emailSetup(email,port)] \
        -usetls 1 \
        -username $emailSetup(email,userName) \
        -password $emailSetup(email,password) \
        -header [list From [list $emailSetup($mode,From)]] \
        -header [list To "$emailSetup($mode,To)"] \
        -header [list Subject "$emailSetup($mode,Subject) $SUB"] \
        -header [list Date "[clock format [clock seconds]]"]    
    
    
    mime::finalize $tok

}