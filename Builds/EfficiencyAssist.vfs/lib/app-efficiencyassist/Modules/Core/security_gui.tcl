# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 03/13 2015
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
# A GUI that appears prior to EA launching (if needed)


proc ea::sec::guiWarning {} {
    #****f* launchPreferences/eAssistPref
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Launch the gui for the preferences. This is just a skeleton to create the window.
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
    global log 
	
    toplevel .preferences
    wm transient .preferences .
    wm title .preferences [mc "$currentModule Preferences"]

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    wm geometry .preferences +${locX}+${locY}

    focus .preferences
    ${log}::debug which Preferences : $currentModule
    
    
}