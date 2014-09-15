# Creator: Casey Ackels (C) 2006 - 2011
# Initial Date: September 24th, 2008
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision$
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2013-12-22 21:34:49 -0800 (Sun, 22 Dec 2013) $
#
########################################################################################

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

proc eAssist_GUI::editPopup {} {
    #****f* editPopup/eAssist_GUI
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	call {tk_popup .editPopup %X %Y}
    #
    # SYNOPSIS
    #	Basic popup for editing
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	eAssist::parentGUI eAssist_GUI::dropDest
    # NOTES
    #
    # SEE ALSO
    #
    #***

    menu .editPopup -tearoff 0
    .editPopup add command -label [mc "Reset"] -command {[focus] delete 0 end}
    .editPopup add separator
    .editPopup add command -label [mc "Cut"] -command {event generate [focus] <<Cut>>}
    .editPopup add command -label [mc "Copy"] -command {event generate [focus] <<Copy>>}
    .editPopup add command -label [mc "Paste"] -command {event generate [focus] <<Paste>>}
    
    #puts "gui_Entry: $gui_Entry"
    
} ;# editPopup


proc eAssist_GUI::resetEntry {} {
    global gui_Entry
    
    $gui_Entry delete 0 end
}
#$menu config -command {event generate [focus] <<Copy>>}
