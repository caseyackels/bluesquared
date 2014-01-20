# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision$
# $LastChangedBy$
# $LastChangedDate$
#
########################################################################################

##
## - Overview
# This file holds the parent GUI for Distribution Helper

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

## Coding Conventions
# - Namespaces:

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

package provide eAssist_importFiles 1.0

namespace eval eAssist_GUI {}
namespace eval importFiles {}

proc importFiles::eAssistGUI {} {
    #****f* eAssistGUI/importFiles
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Builds the GUI of the Import Files Module, with bindings
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	eAssist::parentGUI
    #
    # NOTES
    #
    #	
    # SEE ALSO
    #	
    #
    #***
    global log program currentModule w headerParent files mySettings process dist filter w options csmpls
    
    set program(currentModule) Addresses
    set currentModule Addresses
      
    # Clear the frames before continuing
    eAssist_Global::resetFrames parent
    
    # Setup the Filter array
    eAssist_Global::launchFilters
    
    ##
    ## Parent Frame
    ##
    set frame0 [ttk::frame .container.frame0]
    pack $frame0 -expand yes -fill both -pady 5p -padx 5p

    ##
    ## Notebook
    ##
    set w(nbk) [ttk::notebook $frame0.nbk]
    pack $w(nbk) -expand yes -fill both

    # Tab setup is in the corresponding proc
    ttk::notebook::enableTraversal $w(nbk)

    #
    # Create the notebook
    #
    $w(nbk) add [ttk::frame $w(nbk).f1] -text [mc "Import Files"]
    $w(nbk) add [ttk::frame $w(nbk).f2] -text [mc "Process Batch Files"] -state disabled
    $w(nbk) add [ttk::frame $w(nbk).f3] -text [mc "Process Planner Files"] -state disabled

    $w(nbk) select $w(nbk).f1
    
    ##
    ## - TAB 1
    ##
    
    #------------- Frame 1a - Top frame
    set frame1a [ttk::labelframe $w(nbk).f1.top -text [mc "Open file"]]
    pack $frame1a -side top -fill both -padx 5p -pady 5p
    
    ttk::label $frame1a.txt1 -text [mc "File Name:"]
    ttk::entry $frame1a.entry1 -textvariable process(fileName) -width 50
    
    grid $frame1a.txt1 -column 0 -row 0 -pady 5p -sticky e ;#-padx 2p
    grid $frame1a.entry1 -column 1 -row 0 -pady 5p -sticky ew ;#-padx 2p
    
    ttk::button $frame1a.btn1 -text [mc "Open File"] -command {importFiles::readFile [eAssist_Global::OpenFile "Open File" $mySettings(sourceFiles) file csv]}
    ttk::button $frame1a.btn2 -text [mc "Import"] -command {importFiles::processFile 2} -state disabled ;# The "2" designates the tab id.
    #ttk::button $frame1a.btn3 -text [mc "Reset"] -command {{$log}::debug Reset Interface} -state disabled
    
    grid $frame1a.btn1 -column 2 -row 0 -padx 5p
    grid $frame1a.btn2 -column 3 -row 0 -padx 3p
    #grid $frame1a.btn3 -column 4 -row 0 -padx 3p
    
    # This option should be saved, and read from the config file.
        set options(AutoAssignHeader) 1
    ttk::checkbutton $frame1a.chkbtn1 -text [mc "Auto-Assign header names"] -variable options(AutoAssignHeader)
    grid $frame1a.chkbtn1 -column 0 -columnspan 2 -row 1 -sticky w

    
    #ttk::label $frame1a.txt2 -text [mc "Number of Records:"]
    #ttk::label $frame1a.entry2 -textvariable process(numOfRecords) -relief flat
    #
    #grid $frame1a.txt2 -column 0 -row 2 -sticky e
    #grid $frame1a.entry2 -column 1 -row 2 -sticky ew
    
    #------------- Frame 1 - Listbox for unassigned file headers
    set files(tab1f1) [ttk::labelframe $w(nbk).f1.lbox1 -text [mc "Unassigned Columns"]]
    pack $files(tab1f1) -side left -fill both -padx 5p -pady 5p ;#-ipady 2p -anchor nw -side left

    listbox $files(tab1f1).listbox \
                -width 22 \
                -selectbackground yellow \
                -selectforeground black \
                -exportselection no \
                -selectmode single \
                -yscrollcommand [list $files(tab1f1).scrolly set] \
                -xscrollcommand [list $files(tab1f1).scrollx set]


    ttk::scrollbar $files(tab1f1).scrolly -orient v -command [list $files(tab1f1).listbox yview]
    ttk::scrollbar $files(tab1f1).scrollx -orient h -command [list $files(tab1f1).listbox xview]
    

    grid $files(tab1f1).listbox -column 0 -row 0 -sticky news
    grid columnconfigure $files(tab1f1) $files(tab1f1).listbox -weight 1
    grid rowconfigure $files(tab1f1) $files(tab1f1).listbox -weight 1

    grid $files(tab1f1).scrolly -column 1 -row 0 -sticky nse
    grid $files(tab1f1).scrollx -column 0 -row 1 -sticky ews
    

    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $files(tab1f1).scrolly
    ::autoscroll::autoscroll $files(tab1f1).scrollx
    
    #-------------- Frame 2 - Listbox, available headers to map to.
    set files(tab1f2) [ttk::labelframe $w(nbk).f1.lbox2 -text [mc "Available Columns"]]
    pack $files(tab1f2) -side left -fill both -padx 5p -pady 5p
    
    listbox $files(tab1f2).listbox \
                -width 25 \
                -selectbackground yellow \
                -selectforeground black \
                -exportselection no \
                -selectmode single \
                -yscrollcommand [list $files(tab1f2).scrolly set] \
                -xscrollcommand [list $files(tab1f2).scrollx set]
    
    if {[info exists headerParent(headerList)] != 0 } {
        foreach item $headerParent(headerList) {
            $files(tab1f2).listbox insert end $item
        }
        ${log}::debug Inserting masterHeader into files(tab1f2).listbox: $headerParent(headerList)
    }

    ttk::scrollbar $files(tab1f2).scrolly -orient v -command [list $files(tab1f2).listbox yview]
    ttk::scrollbar $files(tab1f2).scrollx -orient h -command [list $files(tab1f2).listbox xview]
    

    grid $files(tab1f2).listbox -column 0 -row 0 -sticky news
    grid columnconfigure $files(tab1f2) $files(tab1f2).listbox -weight 1
    grid rowconfigure $files(tab1f2) $files(tab1f2).listbox -weight 1

    grid $files(tab1f2).scrolly -column 1 -row 0 -sticky nse
    grid $files(tab1f2).scrollx -column 0 -row 1 -sticky ews
    

    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $files(tab1f2).scrolly
    ::autoscroll::autoscroll $files(tab1f2).scrollx
    

    #--------------- Frame 2a - Buttons
    set files(tab1f2a) [ttk::frame $w(nbk).f1.btns]
    pack $files(tab1f2a) -side left -fill both -padx 5p -pady 5p
    
    ttk::button $files(tab1f2a).btn1 -text [mc "Add >"] -command {eAssistHelper::mapHeader} -state disabled
    ttk::button $files(tab1f2a).btn2 -text [mc "< Remove"] -command {eAssistHelper::unMapHeader} -state disabled
    
    grid $files(tab1f2a).btn1 -column 0 -row 0 -sticky n -pady 5p
    grid $files(tab1f2a).btn2 -column 0 -row 1 -sticky n -pady 5p

    #--------------- Frame 3 - Listbox, mapped headers
    set files(tab1f3) [ttk::labelframe $w(nbk).f1.lbox3 -text [mc "Mapped Columns"]]
    pack $files(tab1f3) -side left -fill both -padx 5p -pady 5p
    
    listbox $files(tab1f3).listbox \
                -width 28 \
                -selectbackground yellow \
                -selectforeground black \
                -exportselection no \
                -selectmode single \
                -yscrollcommand [list $files(tab1f3).scrolly set] \
                -xscrollcommand [list $files(tab1f3).scrollx set]

    ttk::scrollbar $files(tab1f3).scrolly -orient v -command [list $files(tab1f3).listbox yview]
    ttk::scrollbar $files(tab1f3).scrollx -orient h -command [list $files(tab1f3).listbox xview]

    grid $files(tab1f3).listbox -column 0 -row 0 -sticky news
    grid columnconfigure $files(tab1f3) $files(tab1f3).listbox -weight 2
    grid rowconfigure $files(tab1f3) $files(tab1f3).listbox -weight 2

    grid $files(tab1f3).scrolly -column 1 -row 0 -sticky nse
    grid $files(tab1f3).scrollx -column 0 -row 1 -sticky ews

    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $files(tab1f3).scrolly
    ::autoscroll::autoscroll $files(tab1f3).scrollx
    
    ##
    ## - TAB 3
    ##
    
    ##
    ## Notebook 2
    ##
    set nb [ttk::notebook $w(nbk).f3.nb]
    pack $nb -expand yes -fill both

    ttk::notebook::enableTraversal $nb

    #
    # Create the notebook
    #
    $nb add [ttk::frame $nb.f1] -text [mc "Destinations"]
    $nb add [ttk::frame $nb.f2] -text [mc "Samples / Customer Copies"] -state hidden

    
    $nb select $nb.f1
    
    ##
    ##------------- Frame 1 Top Frame - Container
    ##
    set files(tab3f1a) [ttk::frame $nb.f1.f1]
    pack $files(tab3f1a) -side top -fill both -padx 5p -pady 5p
    
    ##
    ##------------- Frame 1a, Top Left Frame
    ##
    set files(tab3f1a) [ttk::labelframe $nb.f1.f1.a -text [mc "Available Columns"]]
    pack $files(tab3f1a) -side left -fill both -padx 5p -pady 5p
    
    #ttk::label $files(tab3f1).txt1 -text [mc "Available Columns"]
        set scrolly_lbox1 $files(tab3f1a).scrolly
        set scrollx_lbox1 $files(tab3f1a).scrollx
    
    listbox $files(tab3f1a).lbox1 -width 20 \
                                -yscrollcommand [list $scrolly_lbox1 set] \
                                -xscrollcommand [list $scrollx_lbox1 set]

    ttk::scrollbar $scrolly_lbox1 -orient v -command [list $files(tab3f1a).lbox1 yview]
    ttk::scrollbar $scrollx_lbox1 -orient h -command [list $files(tab3f1a).lbox1 xview]
        
    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $scrolly_lbox1
    ::autoscroll::autoscroll $scrollx_lbox1
    
    ttk::button $files(tab3f1a).btn1 -text [mc "Add"] -command {eAssistHelper::unHideColumns}
    
    
    #------------- Grid Frame 1  
    #grid $files(tab3f1).txt1 -column 0 -row 0 -sticky new
    grid $files(tab3f1a).lbox1 -column 1 -row 0 -sticky news
    grid $scrollx_lbox1 -column 1 -row 1 -sticky ew
    grid $scrolly_lbox1 -column 2 -row 0 -sticky ns
    
    grid $files(tab3f1a).btn1 -column 3 -row 0 -sticky new

    
    ##
    ##------------- Frame 1a
    ##
    set files(tab1) [ttk::labelframe $nb.f1.f1.f3 -text [mc "Job Information"]]
    pack $files(tab1) -fill both -padx 2p -pady 5p
    
    #ttk::label $files(tab1).txt1 -text [mc "Customer Name"]
    #ttk::entry $files(tab1).entry1 ;#-textvariable
    
    ttk::label $files(tab1).txt2 -text [mc "Job Name"]
    ttk::entry $files(tab1).entry2 ;#-textvariable
    
    ttk::label $files(tab1).txt3 -text [mc "Job Number"]
    ttk::entry $files(tab1).entry3 ;#-textvariable
    
    # Grid frame f3
    #grid $files(tab1).txt1 -column 0 -row 0 -sticky nes -padx 2p
    #grid $files(tab1).entry1 -column 1 -row 0 -sticky news -padx 2p
    grid $files(tab1).txt2 -column 0 -row 1 -sticky nes -padx 2p
    grid $files(tab1).entry2 -column 1 -row 1 -sticky news -padx 2p
    grid $files(tab1).txt3 -column 0 -row 2 -sticky nes -padx 2p
    grid $files(tab1).entry3 -column 1 -row 2 -sticky news -padx 2p
    
    
    ##
    ##------------- Frame 1b
    ##
    set files(tab3f1b) [ttk::labelframe $nb.f1.f1.b -text [mc "Internal Samples"]]
    pack $files(tab3f1b) -fill both -padx 2p -pady 5p

    ttk::label $files(tab3f1b).txt1 -text [mc "Ticket"]
    ttk::label $files(tab3f1b).txt1a -textvariable csmpls(TicketTotal)
    ttk::label $files(tab3f1b).txt2 -text [mc "CSR"]
    ttk::label $files(tab3f1b).txt2a -textvariable csmpls(CSRTotal)
    ttk::label $files(tab3f1b).txt3 -text [mc "Sample Room"]
    ttk::label $files(tab3f1b).txt3a -textvariable csmpls(SmplRoomTotal)
    ttk::label $files(tab3f1b).txt4 -text [mc "Sales"]
    ttk::label $files(tab3f1b).txt4a -textvariable csmpls(SalesTotal)
    
    #------------- Grid Frame 1b
    grid $files(tab3f1b).txt1 -column 0 -row 0 -sticky new -padx 2p
    grid $files(tab3f1b).txt1a -column 1 -row 0 -sticky new -padx 3p
    grid $files(tab3f1b).txt2 -column 0 -row 1 -sticky new -padx 2p
    grid $files(tab3f1b).txt2a -column 1 -row 1 -sticky new -padx 3p
    grid $files(tab3f1b).txt3 -column 0 -row 2 -sticky new -padx 2p
    grid $files(tab3f1b).txt3a -column 1 -row 2 -sticky new -padx 3p
    grid $files(tab3f1b).txt4 -column 0 -row 3 -sticky new -padx 2p
    grid $files(tab3f1b).txt4a -column 1 -row 3 -sticky new -padx 3p
    
    ##
    #------------- Frame 2, Tablelist Notebook
    ##
    set files(tab3f2) [ttk::labelframe $nb.f1.f2 -text [mc "Distribution"]]
    pack $files(tab3f2) -side bottom -fill both -expand yes -padx 5p -pady 5p
    
    
    set scrolly $files(tab3f2).scrolly
    set scrollx $files(tab3f2).scrollx
    tablelist::tablelist $files(tab3f2).tbl \
                                    -showlabels yes \
                                    -selectbackground lightblue \
                                    -selectforeground black \
                                    -stripebackground lightyellow \
                                    -exportselection yes \
                                    -showseparators yes \
                                    -fullseparators yes \
                                    -movablecolumns yes \
                                    -movablerows yes \
                                    -editselectedonly 1 \
                                    -editstartcommand {importFiles::startCmd} \
                                    -editendcommand {importFiles::endCmd} \
                                    -yscrollcommand [list $scrolly set] \
                                    -xscrollcommand [list $scrollx set]


    ttk::scrollbar $scrolly -orient v -command [list $files(tab3f2).tbl yview]
    ttk::scrollbar $scrollx -orient h -command [list $files(tab3f2).tbl xview]
        
    grid $scrolly -column 1 -row 0 -sticky ns
    grid $scrollx -column 0 -row 1 -sticky ew
        
    ::autoscroll::autoscroll $scrolly ;# Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $scrollx ;# Enable the 'autoscrollbar'
    

    #----- GRID
    grid $files(tab3f2).tbl -column 0 -row 0 -sticky news -padx 5p -pady 5p
    grid columnconfigure $files(tab3f2) $files(tab3f2).tbl -weight 2
    grid rowconfigure $files(tab3f2) $files(tab3f2).tbl -weight 2
    
#ttk::style map TEntry -fieldbackground [list focus yellow]


} ;# importFiles::eAssistGUI


proc importFiles::initMenu {} {
    #****f* initMenu/importFiles
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Initialize menus for the Addresses module
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
    global log mb
    ${log}::debug --START -- [info level 1]
    
    catch {menu $mb.dist -tearoff 0 -relief raised -bd 2} err
    if {$err != ""} {$mb delete 2}
    
    $mb insert 2 cascade -label [mc "Distribution"] -menu $mb.dist
    
    #$mb.dist add command -label [mc "Filters"] -command {eAssistHelper::filters}
    $mb.dist add command -label [mc "Filter Editor"] -command {eAssist_tools::FilterEditor}
    $mb.dist add command -label [mc "Internal Samples"] -command {eAssistHelper::addCompanySamples}
    $mb.dist add command -label [mc "Split"] -command {eAssistHelper::splitVersions}
    $mb.dist add separator
    $mb.dist add command -label [mc "Options"] -command {eAssistPref::launchPreferences}
	
    ${log}::debug --END -- [info level 1]
} ;# importFiles::initMenu