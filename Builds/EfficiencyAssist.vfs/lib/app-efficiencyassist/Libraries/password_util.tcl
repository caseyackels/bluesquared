# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 07 25,2014
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 612 $
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

proc lib::showPwordWindow {} {
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
    global log user
    
    toplevel .pwordLogin
    wm transient .pwordLogin .
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
    
    ttk::label $f1.txta -text [mc "Current User:"]
    ttk::label $f1.txtb -textvariable user(id)
    
    ttk::label $f1.txt0 -text [mc "User:"]
    ttk::entry $f1.entry0 -width 20
    
    ttk::label $f1.txt1 -text [mc "Password:"]
    ttk::entry $f1.entry1 -width 20 -show *
    
    focus $f1.entry0
    
    grid $f1.txta -column 0 -row 0 -sticky nse
    grid $f1.txtb -column 1 -row 0 -sticky nsw
    
    grid $f1.txt0 -column 0 -row 1 -padx 5p -pady 5p -sticky nse
    grid $f1.entry0 -column 1 -row 1 -padx 5p -pady 5p -sticky news
     
    grid $f1.txt1 -column 0 -row 2 -padx 5p -pady 5p -sticky nse
    grid $f1.entry1 -column 1 -row 2 -padx 5p -pady 5p -sticky news
    
    ##
    ## Frame 2
    ##
    set f2 [ttk::frame .pwordLogin.f2 -padding 10]
    pack $f2 -expand yes -fill both
    
    
    ttk::button $f2.btn1 -text [mc "OK"] -command [list lib::pwordCompare .pwordLogin $f1.entry0 $f1.entry1]
    ttk::button $f2.btn2 -text [mc "Cancel"] -command {destroy .pwordLogin}
    ttk::button $f2.btn0 -text [mc "Revert"] -command {ea::sec::changeUser [ea::sec::userExist]; ea::sec::modLauncher; destroy .pwordLogin}
    
    grid $f2.btn0 -column 0 -row 0 -padx 5p
    grid $f2.btn1 -column 1 -row 0 -padx 5p
    grid $f2.btn2 -column 2 -row 0 -padx 5p
    
    ##
    ## Bindings
    ea::tools::bindings $f1.entry1 {Return KP_Enter} [list lib::pwordCompare .pwordLogin $f1.entry0 $f1.entry1]
    
    
} ;# lib::showPwordWindow


proc lib::pwordCompare {win usr_wid pass_wid} {
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
    global log user
    
    set authed [ea::sec::authUser [$usr_wid get] [$pass_wid get]]

    if {!$authed} {
        return
    } else {
        ${log}::debug Change User was a success!
        destroy $win
        ea::sec::modLauncher
    }

} ;# lib::pwordCompare