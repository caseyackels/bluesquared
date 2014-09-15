# Creator: Casey Ackels (C) 2006 - 2008
# Initial Date: September 24th, 2008
# Version: See shipping_launch_code.tcl
# Dependencies: See shipping_launch_code.tcl
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

package provide shipping 1.0

namespace eval Shipping_Popup {

proc editPopup {} {
    menu .editPopup -tearoff 0
    .editPopup add command -label Cut -command {event generate [focus] <<Cut>>}
    #.editPopup add separator
    .editPopup add command -label Copy -command {event generate [focus] <<Copy>>}
    #.editPopup add separator
    .editPopup add command -label Paste -command {event generate [focus] <<Paste>>} 
    
} ;# editPopup

} ;# End Shipping_Popup
#$menu config -command {event generate [focus] <<Copy>>}
