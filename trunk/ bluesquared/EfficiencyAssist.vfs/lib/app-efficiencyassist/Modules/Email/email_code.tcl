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
# $LastChangedDate: 2011-10-17 16:11:20 -0700 (Mon, 17 Oct 2011) $
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

proc mail::mail {SUB TEXT} {
    #****f* mail/mail
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Send a canned email to a recipient
    #
    # SYNOPSIS
    #   mail::mail:: <text>
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
    global log
    
    set tok [mime::initialize -canonical text/plain -string $TEXT]
    
    # All of these options should be user configurable
    #set USERNAME casey.ackels
    #set PASSWORD 1520567954CaDel
    set USERNAME jg.shipping
    set PASSWORD shipping
    
    set SERVER mail.journalgraphics.com
    set PORT 25
    set FROM jg.shipping
    set TO casey.ackels@journalgraphics.com
    set SUBJECT "Package Info: $SUB"
    
    smtp::sendmessage $tok \
        -servers [list $SERVER] -ports [list $PORT] \
        -usetls 1 \
        -username $USERNAME \
        -password $PASSWORD \
        -header [list From "$FROM"] \
        -header [list To "$TO"] \
        -header [list Subject "$SUBJECT"] \
        -header [list Date "[clock format [clock seconds]]"]    
    
    
    mime::finalize $tok

}