# Creator: Casey Ackels (C) 2006 - 2011
# Initial Date: September 24th, 2008
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision$
# $LastChangedBy$
# $LastChangedDate$
#
########################################################################################

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

proc Disthelper_GUI::editPopup {} {
    #****f* editPopup/Disthelper_GUI
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
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
    #	Disthelper_GUI::dropDest
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


proc Disthelper_GUI::resetEntry {} {
    global gui_Entry
    
    $gui_Entry delete 0 end
}
#$menu config -command {event generate [focus] <<Copy>>}
