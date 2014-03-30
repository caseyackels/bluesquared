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
namespace eval IFMenus {} ;# IF = importFiles

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
    global log program w headerParent files mySettings process dist filter w options csmpls CSR job
    
    # Clear the frames before continuing
    eAssist_Global::resetFrames parent
    
    wm geometry . 900x610 ;# Width x Height
    
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
    #$w(nbk) add [ttk::frame $w(nbk).f1] -text [mc "Import Files"] -state hidden
    #$w(nbk) add [ttk::frame $w(nbk).f2] -text [mc "Process Batch Files"] -state hidden
    $w(nbk) add [ttk::frame $w(nbk).f3] -text [mc "Process Planner Files"]

    $w(nbk) select $w(nbk).f3
    
    ##
    ## - TAB 1
    ##
    
    #------------- Frame 1a - Top frame
    #set frame1a [ttk::labelframe $w(nbk).f1.top -text [mc "Open file"]]
    #pack $frame1a -side top -fill both -padx 5p -pady 5p
    #
    #ttk::label $frame1a.txt1 -text [mc "File Name:"]
    #ttk::entry $frame1a.entry1 -textvariable process(fileName) -width 50
    #
    #grid $frame1a.txt1 -column 0 -row 0 -pady 5p -sticky e ;#-padx 2p
    #grid $frame1a.entry1 -column 1 -row 0 -pady 5p -sticky ew ;#-padx 2p
    #
    #ttk::button $frame1a.btn1 -text [mc "Open File"] -command {importFiles::readFile [eAssist_Global::OpenFile "Open File" $mySettings(sourceFiles) file csv]}
    #ttk::button $frame1a.btn2 -text [mc "Import"] -command {importFiles::processFile 2} -state disabled ;# The "2" designates the tab id.
    ##ttk::button $frame1a.btn3 -text [mc "Reset"] -command {{$log}::debug Reset Interface} -state disabled
    #
    #grid $frame1a.btn1 -column 2 -row 0 -padx 5p
    #grid $frame1a.btn2 -column 3 -row 0 -padx 3p
    ##grid $frame1a.btn3 -column 4 -row 0 -padx 3p
    #
    ## This option should be saved, and read from the config file.
    #    set options(AutoAssignHeader) 1
    #ttk::checkbutton $frame1a.chkbtn1 -text [mc "Auto-Assign Header Names"] -variable options(AutoAssignHeader)
    #grid $frame1a.chkbtn1 -column 0 -columnspan 2 -row 1 -sticky w
    #
    #
    ##ttk::label $frame1a.txt2 -text [mc "Number of Records:"]
    ##ttk::label $frame1a.entry2 -textvariable process(numOfRecords) -relief flat
    ##
    ##grid $frame1a.txt2 -column 0 -row 2 -sticky e
    ##grid $frame1a.entry2 -column 1 -row 2 -sticky ew
    #
    ##------------- Frame 1 - Listbox for unassigned file headers
    #set files(tab1f1) [ttk::labelframe $w(nbk).f1.lbox1 -text [mc "Unassigned Columns"]]
    #pack $files(tab1f1) -side left -fill both -padx 5p -pady 5p ;#-ipady 2p -anchor nw -side left
    #
    #listbox $files(tab1f1).listbox \
    #            -width 22 \
    #            -selectbackground yellow \
    #            -selectforeground black \
    #            -exportselection no \
    #            -selectmode single \
    #            -yscrollcommand [list $files(tab1f1).scrolly set] \
    #            -xscrollcommand [list $files(tab1f1).scrollx set]
    #
    #
    #ttk::scrollbar $files(tab1f1).scrolly -orient v -command [list $files(tab1f1).listbox yview]
    #ttk::scrollbar $files(tab1f1).scrollx -orient h -command [list $files(tab1f1).listbox xview]
    #
    #
    #grid $files(tab1f1).listbox -column 0 -row 0 -sticky news
    #grid columnconfigure $files(tab1f1) $files(tab1f1).listbox -weight 1
    #grid rowconfigure $files(tab1f1) $files(tab1f1).listbox -weight 1
    #
    #grid $files(tab1f1).scrolly -column 1 -row 0 -sticky nse
    #grid $files(tab1f1).scrollx -column 0 -row 1 -sticky ews
    #
    #
    ## Enable the 'autoscrollbar'
    #::autoscroll::autoscroll $files(tab1f1).scrolly
    #::autoscroll::autoscroll $files(tab1f1).scrollx
    #
    ##-------------- Frame 2 - Listbox, available headers to map to.
    #set files(tab1f2) [ttk::labelframe $w(nbk).f1.lbox2 -text [mc "Available Columns"]]
    #pack $files(tab1f2) -side left -fill both -padx 5p -pady 5p
    #
    #listbox $files(tab1f2).listbox \
    #            -width 25 \
    #            -selectbackground yellow \
    #            -selectforeground black \
    #            -exportselection no \
    #            -selectmode single \
    #            -yscrollcommand [list $files(tab1f2).scrolly set] \
    #            -xscrollcommand [list $files(tab1f2).scrollx set]
    #
    #if {[info exists headerParent(headerList)] != 0 } {
    #    foreach item $headerParent(headerList) {
    #        $files(tab1f2).listbox insert end $item
    #    }
    #    ${log}::debug Inserting masterHeader into files(tab1f2).listbox: $headerParent(headerList)
    #}
    #
    #ttk::scrollbar $files(tab1f2).scrolly -orient v -command [list $files(tab1f2).listbox yview]
    #ttk::scrollbar $files(tab1f2).scrollx -orient h -command [list $files(tab1f2).listbox xview]
    #
    #
    #grid $files(tab1f2).listbox -column 0 -row 0 -sticky news
    #grid columnconfigure $files(tab1f2) $files(tab1f2).listbox -weight 1
    #grid rowconfigure $files(tab1f2) $files(tab1f2).listbox -weight 1
    #
    #grid $files(tab1f2).scrolly -column 1 -row 0 -sticky nse
    #grid $files(tab1f2).scrollx -column 0 -row 1 -sticky ews
    #
    #
    ## Enable the 'autoscrollbar'
    #::autoscroll::autoscroll $files(tab1f2).scrolly
    #::autoscroll::autoscroll $files(tab1f2).scrollx
    

    ##--------------- Frame 2a - Buttons
    #set files(tab1f2a) [ttk::frame $w(nbk).f1.btns]
    #pack $files(tab1f2a) -side left -fill both -padx 5p -pady 5p
    #
    #ttk::button $files(tab1f2a).btn1 -text [mc "Add >"] -command {eAssistHelper::mapHeader} -state disabled
    #ttk::button $files(tab1f2a).btn2 -text [mc "< Remove"] -command {eAssistHelper::unMapHeader} -state disabled
    #
    #grid $files(tab1f2a).btn1 -column 0 -row 0 -sticky n -pady 5p
    #grid $files(tab1f2a).btn2 -column 0 -row 1 -sticky n -pady 5p
    #
    ##--------------- Frame 3 - Listbox, mapped headers
    #set files(tab1f3) [ttk::labelframe $w(nbk).f1.lbox3 -text [mc "Mapped Columns"]]
    #pack $files(tab1f3) -side left -fill both -padx 5p -pady 5p
    #
    #listbox $files(tab1f3).listbox \
    #            -width 28 \
    #            -selectbackground yellow \
    #            -selectforeground black \
    #            -exportselection no \
    #            -selectmode single \
    #            -yscrollcommand [list $files(tab1f3).scrolly set] \
    #            -xscrollcommand [list $files(tab1f3).scrollx set]
    #
    #ttk::scrollbar $files(tab1f3).scrolly -orient v -command [list $files(tab1f3).listbox yview]
    #ttk::scrollbar $files(tab1f3).scrollx -orient h -command [list $files(tab1f3).listbox xview]
    #
    #grid $files(tab1f3).listbox -column 0 -row 0 -sticky news
    #grid columnconfigure $files(tab1f3) $files(tab1f3).listbox -weight 2
    #grid rowconfigure $files(tab1f3) $files(tab1f3).listbox -weight 2
    #
    #grid $files(tab1f3).scrolly -column 1 -row 0 -sticky nse
    #grid $files(tab1f3).scrollx -column 0 -row 1 -sticky ews
    #
    ## Enable the 'autoscrollbar'
    #::autoscroll::autoscroll $files(tab1f3).scrolly
    #::autoscroll::autoscroll $files(tab1f3).scrollx
    
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
    pack $files(tab3f1a) -side top -fill both ;# -padx 5p -pady 5p
    
    ##
    ##------------- Frame 1a, Top Left Frame
    ##
    #set files(tab3f1a) [ttk::labelframe $nb.f1.f1.a -text [mc "Available Columns"]]
    #pack $files(tab3f1a) -side left -fill both -padx 5p -pady 5p
    #
    ##ttk::label $files(tab3f1).txt1 -text [mc "Available Columns"]
    #    set scrolly_lbox1 $files(tab3f1a).scrolly
    #    set scrollx_lbox1 $files(tab3f1a).scrollx
    #
    #listbox $files(tab3f1a).lbox1 -width 20 \
    #                            -yscrollcommand [list $scrolly_lbox1 set] \
    #                            -xscrollcommand [list $scrollx_lbox1 set]
    #
    #ttk::scrollbar $scrolly_lbox1 -orient v -command [list $files(tab3f1a).lbox1 yview]
    #ttk::scrollbar $scrollx_lbox1 -orient h -command [list $files(tab3f1a).lbox1 xview]
    #    
    ## Enable the 'autoscrollbar'
    #::autoscroll::autoscroll $scrolly_lbox1
    #::autoscroll::autoscroll $scrollx_lbox1
    #
    #ttk::button $files(tab3f1a).btn1 -text [mc "Add"] -command {eAssistHelper::unHideColumns}
    #
    #
    ##------------- Grid Frame 1a  
    ##grid $files(tab3f1).txt1 -column 0 -row 0 -sticky new
    #grid $files(tab3f1a).lbox1 -column 1 -row 0 -sticky news
    #grid $scrollx_lbox1 -column 1 -row 1 -sticky ew
    #grid $scrolly_lbox1 -column 2 -row 0 -sticky ns
    #
    #grid $files(tab3f1a).btn1 -column 3 -row 0 -sticky new

    
    ##
    ##------------- Frame 3a
    ## Container frame
    set files(f3a) [ttk::frame $nb.f1.f1.b]
    pack $files(f3a) -side left -fill both -expand yes ;#-padx 5p -pady 5p
    
    # --- Job Info Frame
    set files(jobInfo) [ttk::labelframe $files(f3a).f1 -text [mc "Job Information"] -padding 10]
    grid $files(jobInfo) -column 0 -row 0 -sticky news -padx 5p -pady 5p -ipady 5p
    
    ttk::label $files(jobInfo).txt1 -text [mc "CSR"]
    ttk::combobox $files(jobInfo).cbox1 -values $CSR(Names) -textvariable job(CSRName)
    
    ttk::label $files(jobInfo).txt1a -text [mc "Title"]
    ttk::entry $files(jobInfo).entry1a -textvariable job(Title)
    tooltip::tooltip $files(jobInfo).entry1a [mc "Publication Title"]
    
    ttk::label $files(jobInfo).txt2 -text [mc "Name"]
    ttk::entry $files(jobInfo).entry2 -textvariable job(Name)
    tooltip::tooltip $files(jobInfo).entry2 [mc "Job Name"]
    
    ttk::label $files(jobInfo).txt3 -text [mc "Number"]
    ttk::entry $files(jobInfo).entry3 -textvariable job(Number)
    tooltip::tooltip $files(jobInfo).entry3 [mc "Job Number"]
    
    grid $files(jobInfo).txt1      -column 0 -row 0 -sticky nes -padx 3p -pady 3p
    grid $files(jobInfo).cbox1     -column 1 -row 0 -sticky news -padx 3p -pady 3p
    grid $files(jobInfo).txt1a     -column 0 -row 1 -sticky nes -padx 3p -pady 3p
    grid $files(jobInfo).entry1a   -column 1 -row 1 -sticky news -padx 3p -pady 3p
    grid $files(jobInfo).txt2      -column 0 -row 2 -sticky nes -padx 3p -pady 3p
    grid $files(jobInfo).entry2    -column 1 -row 2 -sticky news -padx 3p -pady 3p
    grid $files(jobInfo).txt3      -column 0 -row 3 -sticky nes -padx 3p -pady 3p
    grid $files(jobInfo).entry3    -column 1 -row 3 -sticky news -padx 3p -pady 3p
    
    # --- Piece Info Frame
    set files(pieceInfo) [ttk::labelframe $files(f3a).f2 -text [mc "Piece Information"] -padding 10]
    grid $files(pieceInfo) -column 1 -row 0 -sticky news -padx 5p -pady 5p
    
    # -- Widgets
    ttk::label $files(pieceInfo).txt2 -text [mc "Weight"] -state disabled
    ttk::entry $files(pieceInfo).entry2 -state disabled
    tooltip::tooltip $files(pieceInfo).entry2 [mc "Piece Weight"]

    
    ttk::label $files(pieceInfo).txt3 -text [mc "Thickness"] -state disabled
    ttk::entry $files(pieceInfo).entry3 -state disabled
    tooltip::tooltip $files(pieceInfo).entry3 [mc "Piece Thickness"]
    
    ttk::button $files(pieceInfo).btn -text [mc "Auto Assign Carrier"] -state disabled
    
    # Grid frame f3
    #grid $files(tab1).txt1 -column 0 -row 0 -sticky nes -padx 2p
    #grid $files(tab1).entry1 -column 1 -row 0 -sticky news -padx 2p
    grid $files(pieceInfo).txt2      -column 0 -row 1 -sticky nes -padx 3p -pady 2p
    grid $files(pieceInfo).entry2    -column 1 -row 1 -sticky news -padx 3p -pady 2p
    grid $files(pieceInfo).txt3      -column 0 -row 2 -sticky nes -padx 3p -pady 2p
    grid $files(pieceInfo).entry3    -column 1 -row 2 -sticky news -padx 3p -pady 2p
    grid $files(pieceInfo).btn       -column 0 -columnspan 2 -row 3 -sticky news -padx 3p -pady 2p
    
    
    # --- Internal Samples Frame
    #set files(internalSamples) [ttk::labelframe $files(f3a).f3 -text [mc "Internal Samples"] -padding 10]
    #grid $files(internalSamples) -column 2 -row 0 -sticky news -sticky news -padx 5p -pady 5p
    #
    #ttk::label $files(internalSamples).txt1     -text [mc "Ticket"]
    #ttk::label $files(internalSamples).txt1a    -textvariable csmpls(TicketTotal)
    #ttk::label $files(internalSamples).txt2     -text [mc "CSR"]
    #ttk::label $files(internalSamples).txt2a    -textvariable csmpls(CSRTotal)
    #ttk::label $files(internalSamples).txt3     -text [mc "Sample Room"]
    #ttk::label $files(internalSamples).txt3a    -textvariable csmpls(SmplRoomTotal)
    #ttk::label $files(internalSamples).txt4     -text [mc "Sales"]
    #ttk::label $files(internalSamples).txt4a    -textvariable csmpls(SalesTotal)
    #ttk::button $files(internalSamples).btn1    -text [mc "Edit"] -command {eAssistHelper::addCompanySamples}
    #
    #
    #------------- Grid Frame 1b
    #grid $files(internalSamples).txt1   -column 0 -row 0 -sticky new -padx 2p
    #grid $files(internalSamples).txt1a  -column 1 -row 0 -sticky new -padx 2p
    #grid $files(internalSamples).txt2   -column 0 -row 1 -sticky new -padx 2p
    #grid $files(internalSamples).txt2a  -column 1 -row 1 -sticky new -padx 2p
    #grid $files(internalSamples).txt3   -column 0 -row 2 -sticky new -padx 2p
    #grid $files(internalSamples).txt3a  -column 1 -row 2 -sticky new -padx 2p
    #grid $files(internalSamples).txt4   -column 0 -row 3 -sticky new -padx 2p
    #grid $files(internalSamples).txt4a  -column 1 -row 3 -sticky new -padx 2p
    #grid $files(internalSamples).btn1   -column 1 -row 4 -sticky new ;#-padx 3p
    
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
                                    -movablecolumns no \
                                    -movablerows no \
                                    -editselectedonly 1 \
                                    -selectmode extended \
                                    -selecttype cell \
                                    -editstartcommand {importFiles::startCmd} \
                                    -editendcommand {importFiles::endCmd} \
                                    -yscrollcommand [list $scrolly set] \
                                    -xscrollcommand [list $scrollx set]

    # Create the columns
    importFiles::insertColumns $files(tab3f2).tbl
    
    ttk::scrollbar $scrolly -orient v -command [list $files(tab3f2).tbl yview]
    ttk::scrollbar $scrollx -orient h -command [list $files(tab3f2).tbl xview]
        
    grid $scrolly -column 1 -row 0 -sticky ns
    grid $scrollx -column 0 -row 1 -sticky ew
        
    ::autoscroll::autoscroll $scrolly ;# Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $scrollx ;# Enable the 'autoscrollbar'

    # Setup the bindings
    set bodyTag [$files(tab3f2).tbl bodytag]
    set labelTag [$files(tab3f2).tbl labeltag]
    set editWinTag [$files(tab3f2).tbl editwintag]
    
    # Begin bodyTag
    #bind $bodyTag <<Button3>> +[list tk_popup .tblMenu %X %Y]
    
    # Toggle between selecting a row, or a single cell
    bind $bodyTag <Double-1> {
    }
    # Begin labelTag
    bind $labelTag <Button-3> +[list tk_popup .tblToggleColumns %X %Y]
    #bind $labelTag <Enter> {tooltip::tooltip $labelTag testing}


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
    
    if {[winfo exists $mb.modMenu.quick]} {
        destroy $mb.modMenu.quick
    }

    $mb.modMenu delete 0 end
    
    # Change menu name
    #$mb entryconfigure Edit -label Distribution
    # Add cascade
    menu $mb.modMenu.quick
    $mb.modMenu add cascade -label [mc "Quick Add"] -menu $mb.modMenu.quick 
    #$mb.modMenu.quick add command -label [mc "JG Mail"]
    #$mb.modMenu.quick add command -label [mc "JG Inventory"]
    
    $mb.modMenu add separator
    
    $mb.modMenu add command -label [mc "Add Destination"] -command {eAssistHelper::addDestination $files(tab3f2).tbl}
    $mb.modMenu add command -label [mc "Filters..."] -command {eAssist_tools::FilterEditor} -state disable
    #$mb.modMenu add command -label [mc "Internal Samples"] -command {eAssistHelper::addCompanySamples} -state disable
    #$mb.modMenu add command -label [mc "Split"] -command {eAssistHelper::splitVersions}
    
    $mb.modMenu add separator
    
    $mb.modMenu add command -label [mc "Preferences"] -command {eAssistPref::launchPreferences}
	
    ${log}::debug --END -- [info level 1]
} ;# importFiles::initMenu
