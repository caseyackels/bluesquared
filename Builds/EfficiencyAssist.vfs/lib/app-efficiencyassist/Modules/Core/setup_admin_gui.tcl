# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 02 22,2015
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
# Admin section

proc eAssistSetup::admin_GUI {args} {
    #****f* admin_GUI/eAssistSetup
    # CREATION DATE
    #   02/22/2015 (Sunday Feb 22)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::admin_GUI args 
    #
    # FUNCTION
    #	Displays the gui for the Administrator's panel
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
    #   
    # SEE ALSO
    #   
    #   
    #***
    global log G_setupFrame program admin

    eAssist_Global::resetSetupFrames ;# Reset all frames so we start clean
    
    #-------- Container Frame
    set frame1 [ttk::label $G_setupFrame.frame1]
    pack $frame1 -expand yes -fill both -pady 5p -padx 5p
    
    ##
    ## Notebook
    ##
    
    set nbk [ttk::notebook $frame1.adminNotebook]
    pack $nbk -expand yes -fill both
    
    ttk::notebook::enableTraversal $nbk
    
    #
    # Setup the notebook
    #
    $nbk add [ttk::frame $nbk.schema] -text [mc "Schema Change"]
    $nbk add [ttk::frame $nbk.perm] -text [mc "Permissions"]
    
    $nbk select $nbk.schema

    
    ##
    ## Tab 1 (Schema Change Import)
    ##
    
    #
    # --- Frame 1
    #
    set f1 [ttk::frame $nbk.schema.f1 -padding 10]
    #grid $f1 -column 0 -row 0 -pady 5p -padx 5p -sticky news
    pack $f1 -expand yes -fill both
    
    ttk::label $f1.txt1 -text [mc "File"]
    ttk::entry $f1.entry1 -textvariable admin(sqlFile)
    ttk::button $f1.btn1 -text [mc ....] -command {set admin(sqlFile) [eAssist_Global::OpenFile [mc "Find SQL File"] $program(Home) file -ext .sql -filetype {{SQL File} {.sql}}]}
    
    grid $f1.txt1 -column 0 -row 0 -sticky nsw
    grid $f1.entry1 -column 1 -row 0 -sticky ew
    grid $f1.btn1 -column 2 -row 0 -sticky ew
    
    grid columnconfigure $f1 1 -weight 2
    

    
} ;# eAssistSetup::admin_GUI
