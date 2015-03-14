# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 09 22,2014
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
# DB commands dealing with the CSRs

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

namespace eval dbCSR {
    #variable csrList
}

proc dbCSR::getCSRID {cbox args} {
    #****f* getCSRID/dbCSR
    # CREATION DATE
    #   09/22/2014 (Monday Sep 22)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   dbCSR::getCSR cbox args
    #   args must be column names surrounded by curly braces for grouping
    #
    # FUNCTION
    #	Retrieves the list of CSR db table fields based on the argument flag passed; then uses the $cbox argument to configure the values for the combobox
    #	if CSR(inactive) doesn't exist we default to 1, to show the status of the CSR entry
    #   
    #   
    # CHILDREN
    #	eAssist_db::dbWhereQuery
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
    global log CSR
    
    if {![info exists CSR(inactive)]} {set csrStatus 1} else {set csrStatus $CSR(inactive)}

    set csrList [eAssist_db::dbWhereQuery -columnNames [join $args] -table CSRs -where Status=$csrStatus]
    
    if {$cbox eq ""} {return $csrList} else {$cbox configure -values "$csrList"}
    
    
} ;# dbCSR::getCSRID


proc dbCSR::saveCSR {args} {
    #****f* saveCSR/dbCSR
    # CREATION DATE
    #   09/22/2014 (Monday Sep 22)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   dbCSR::saveCSR args 
    #
    # FUNCTION
    #	Saves/Updates the CSR's information into the db
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   eAssistSetup::saveCSR
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log CSR
    #set args [split [join $args]]
    ${log}::debug LLENGTH ARGS: [llength $args]
    set csrID [lrange $args 0 0]
    set firstName [lrange $args 1 1]
    set lastName [lrange $args 2 2]
    set email [lrange $args 3 3]
    #set csrStatus [lrange $args end end]

    # See if we have any matching entries ... This column must be unique
    set checkData [db eval {SELECT CSR_ID from CSRs where CSR_ID = $csrID}]
                   
    if {$checkData eq ""} {
        ${log}::notice DB INSERTing CSR : $csrID, $firstName, $lastName, $email, $CSR(status)
        # no matching entries, lets insert
        db eval {INSERT INTO CSRs (CSR_ID, FirstName, LastName, Email, Status)
                VALUES ($csrID, $firstName, $lastName, $email, $CSR(status))}
    } else {
        ${log}::notice DB UPDATE CSR : $csrID, $firstName, $lastName, $email, $CSR(status)
        # Matching entries, lets update
        db eval {UPDATE CSRs SET FirstName = $firstName, LastName = $lastName, Email = $email, Status = $CSR(status) WHERE CSR_ID = $csrID}
    }

    
} ;# dbCSR::saveCSR


proc dbCSR::populateCSR {cbx args} {
    #****f* populateCSR/dbCSR
    # CREATION DATE
    #   09/22/2014 (Monday Sep 22)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2014 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   dbCSR::populateCSR cbx args 
    #
    # FUNCTION
    #	Populates the CSR fields with the selection from the combobox (CSR ID)
    #	cbx = the path to the cbox widget
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   eAssistSetup::customerService_GUI
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log CSR
    
    set id [$cbx get]

    db eval {SELECT FirstName, LastName, Email, Status FROM CSRs WHERE CSR_ID = $id} {
        foreach {key value} $args {
            #$value configure -state normal
            switch -- $key {
                -fname {$value delete 0 end; $value insert end [join $FirstName]}
                -lname {$value delete 0 end; $value insert end [join $LastName]}
                -email {$value delete 0 end; $value insert end [join $Email]}
                -status {set CSR(status) $Status}
            }
            ${log}::debug KEY: $key, VALUE: $value, $FirstName $LastName $Email
            #if {[winfo class $value] eq "TEntry"} {
            #    $value configure -state readonly
            #    } else {
            #        $value configure -state disabled
            #    }
        }
    }

    
} ;# dbCSR::populateCSR
