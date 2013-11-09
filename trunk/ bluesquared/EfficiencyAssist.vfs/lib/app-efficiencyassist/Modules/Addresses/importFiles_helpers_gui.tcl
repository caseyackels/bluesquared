# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# Dependencies: See Below
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
# This file holds the helper procs for the Addresses

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

## Coding Conventions
# - Namespaces:

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


proc eAssistHelper::addDistTypes_GUI {} {
    #****f* addDistTypes_GUI/eAssistHelper
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Helper GUI, for when we come across particular Distribution Types
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
    global log process dist files
    ${log}::debug --START -- [info level 1]
    
	toplevel .d
    wm transient .d .
    wm title .d [mc ""]

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    wm geometry .d +${locX}+${locY}

    focus .d
	
	set w(dType) [ttk::frame .d.frame1]
	pack $w(dType) -expand yes -fill both -pady 5p -padx 5p
	
	ttk::label $w(dType).txt1 -text [mc "Attention"]
	ttk::entry $w(dType).entry1
	ttk::button $w(dType).btn1 -text [mc "Select an Address..."] -command {}
	
	ttk::label $w(dType).txt2 -text [mc "Company"]
	ttk::entry $w(dType).entry2
	
	ttk::label $w(dType).txt3 -text [mc "Address1/Address2"]
	ttk::entry $w(dType).entry3
	ttk::entry $w(dType).entry4
	
	ttk::label $w(dType).txt4 -text [mc "Address3"]
	ttk::entry $w(dType).entry5
	
	ttk::label $w(dType).txt5 -text [mc "City/State/Zip"]
	ttk::entry $w(dType).entry6
	ttk::entry $w(dType).entry7 -width 3
	ttk::entry $w(dType).entry8 -width 10
	
	ttk::label $w(dType).txt6 -text [mc "Country/Phone"]
	ttk::entry $w(dType).entry9
	ttk::entry $w(dType).entry10
	

	#ttk::label $w(dType).txt2 -text [mc "Insert this address for each version?"]

	ttk::button $w(dType).close -text [mc "Close"] -command {destroy .d}
	
	
	#----- Grid
	grid $w(dType).txt1 -column 0 -row 0 -sticky news
	grid $w(dType).entry1 -column 1 -row 0 -sticky news
	grid $w(dType).btn1 -column 2 -row 0 -sticky news
	
	grid $w(dType).txt2 -column 0 -row 1 -sticky news
	grid $w(dType).entry2 -column 1 -row 1 -sticky news
	
	grid $w(dType).txt3 -column 0 -row 2 -sticky news
	grid $w(dType).entry3 -column 1 -row 2 -sticky news
	grid $w(dType).entry4 -column 2 -row 2 -sticky news
	
	grid $w(dType).txt4 -column 0 -row 3 -sticky news
	grid $w(dType).entry5 -column 1 -row 3 -sticky news
	
	grid $w(dType).txt5 -column 0 -row 4 -sticky news
	grid $w(dType).entry6 -column 1 -row 4 -sticky news
	grid $w(dType).entry7 -column 2 -row 4 -sticky news
	grid $w(dType).entry8 -column 3 -row 4 -sticky news
	
	grid $w(dType).txt6 -column 0 -row 5 -sticky news
	grid $w(dType).entry9 -column 1 -row 5 -sticky news
	grid $w(dType).entry10 -column 2 -row 5 -sticky news
	
	#grid $w(dType).txt2 -column 0 -row 1 -sticky news
	grid $w(dType).close -column 3 -row 6 -sticky  news
	
    ${log}::debug --END -- [info level 1]
} ;# eAssistHelper::addDistTypes_GUI