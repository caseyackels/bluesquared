# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 07 25,2014
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
# Displays a window to insert a password to allow changes to happen to the user preferences

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

proc lib::showPwordWindow {parent} {
    #****f* showPwordWindow/lib
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	lig::showPwordWindow <ParentWidget>
    #
    # SYNOPSIS
    #   Shows the password window; if passwords match we remove read-only access
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
    global log
    ${log}::debug --START-- [info level 1]
    
    toplevel .pwordLogin
    wm transient .pwordLogin $parent
    wm title .pwordLogin [mc "Login"]

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    wm geometry .pwordLogin +${locX}+${locY}

    
    ##
    ## Frame 1
    ##
    set f1 [ttk::frame .pwordLogin.f1 -padding 10]
    pack $f1 -expand yes -fill both
    
    
    ttk::label $f1.txt1 -text [mc "Password:"]
    ttk::entry $f1.entry1 -width 20 -show *
    
    focus $f1.entry1
    
    grid $f1.txt1 -column 0 -row 0 -padx 5p -pady 5p
    grid $f1.entry1 -column 1 -row 0 -padx 5p -pady 5p
    
    ##
    ## Frame 2
    ##
    set f2 [ttk::frame .pwordLogin.f2 -padding 10]
    pack $f2 -expand yes -fill both
    
    ttk::button $f2.btn1 -text [mc "OK"] -command "lib::pwordCompare $parent .pwordLogin"
    ttk::button $f2.btn2 -text [mc "Cancel"] -command {destroy .pwordLogin}
    
    grid $f2.btn1 -column 0 -row 0 -padx 5p
    grid $f2.btn2 -column 1 -row 0 -padx 5p    
    
	
    ${log}::debug --END-- [info level 1]
} ;# lib::showPwordWindow


proc lib::pwordCompare {parent win} {
    #****f* pwordCompare/lib
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Compare password entered by user by what we have on file
    #
    # SYNOPSIS
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
    # SEE ALSO
    #
    #***
    global log auth
    ${log}::debug --START-- [info level 1]
    
    set pword [::md5crypt::md5crypt [$win.f1.entry1 get] $auth(adminSalt)]
    
    if {![string match $auth(adminPword) $pword]} {
        ${log}::debug Invalid Password
        return
    } else {
        eAssist_Global::widgetState normal $parent
        destroy $win
    }
    
	
    ${log}::debug --END-- [info level 1]
} ;# lib::pwordCompare

#proc eAssist_Global::isAuthenticated {args} {
#    #****f* isAuthenticated/eAssist_Global
#    # AUTHOR
#    #	Casey Ackels
#    #
#    # COPYRIGHT
#    #	(c) 2011-2014 Casey Ackels
#    #
#    # FUNCTION
#    #	Find out if we are authenticated to see, or access Setup.
#    #
#    # SYNOPSIS
#    #
#    #
#    # CHILDREN
#    #	N/A
#    #
#    # PARENTS
#    #	
#    #
#    # NOTES
#    #
#    # SEE ALSO
#    #
#    #***
#    global log auth
#    ${log}::debug --START-- [info level 1]
#    
#	if {![info exists auth]} {return}
#	
#	if {![string match $args $auth(pword)]} {return}
#	
#    ${log}::debug --END-- [info level 1]
##} ;# eAssist_Global::isAuthenticated
