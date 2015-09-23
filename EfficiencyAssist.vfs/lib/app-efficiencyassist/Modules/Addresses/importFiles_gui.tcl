# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 498 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2015-03-12 13:09:23 -0700 (Thu, 12 Mar 2015) $
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

#package provide eAssist_importFiles 1.0
package provide eAssist_ModImportFiles 1.0

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
    global log program w headerParent files mySettings process dist filter w options csmpls CSR job settings user
    
    #${log}::debug $settings(currentModule)
    #${log}::debug $user($user(id),modules) [lsearch $user($user(id),modules) [lindex $settings(currentModule) 0]]
    #
    #if {[lsearch $user($user(id),modules) [lindex $settings(currentModule) 0]] == -1} {
    #    ${log}::debug [parray user]
    #    ${log}::debug Permission Denied.
    #}
    # Clear the frames before continuing
    eAssist_Global::resetFrames parent
    
    # Setup the Filter array
   # eAssist_Global::launchFilters
    

    
    
    ##
    ## Parent Frame
    ##
    set frame0 [ttk::frame .container.frame0]
    pack $frame0 -expand yes -fill both -pady 5p -padx 5p


    ##
    ## Parent Notebook
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
    #$w(nbk) add [ttk::frame $w(nbk).f3] -text [mc "Process Planner Files"]
    $w(nbk) add [ttk::frame $w(nbk).f3] -text [mc "Default Title"]

    $w(nbk) select $w(nbk).f3
    
    
    
    ## 
    ## - TAB 1 (Process Planner Files) / First level
    ##
    set contFrame [ttk::frame $w(nbk).f3.cont]
    pack $contFrame -fill x
    
    #set custFrame [ttk::frame $contFrame.cf1 -padding 10]
    #grid $custFrame -column 0 -row 0 -sticky news
    #
    #ttk::label $custFrame.txt2a -text [mc "Customer Name:"]
    #ttk::label $custFrame.txt2b -textvariable job(CustName) -width 35
    #
    #ttk::label $custFrame.txt3a -text [mc "CSR Name:"]
    #ttk::label $custFrame.txt3b -text csrname -textvariable job(CSRName) -width 35
    #
    #grid $custFrame.txt2a -column 0 -row 1 -sticky nse -padx 3p
    #grid $custFrame.txt2b -column 1 -row 1 -sticky nsw -ipady 1p -pady 1p
    #
    #grid $custFrame.txt3a -column 0 -row 2 -sticky nse -padx 3p
    #grid $custFrame.txt3b -column 1 -row 2 -sticky nsw -ipady 1p -pady 1p
    
    #set jobFrame [ttk::frame $contFrame.jf1 -padding 10]
    #grid $jobFrame -column 0 -row 0 -sticky news
    #
    #ttk::label $jobFrame.txt4a -text [mc "Job Number:"]
    #ttk::label $jobFrame.txt4b -textvariable job(Number)
    #
    #ttk::label $jobFrame.txt5a -text [mc "Job Title/Name:"]
    #ttk::label $jobFrame.txt5b -textvariable job(Title)
    #ttk::label $jobFrame.txt6b -textvariable job(Name)
    #
    #grid $jobFrame.txt4a -column 0 -row 0 -sticky nse -padx 3p
    #grid $jobFrame.txt4b -column 1 -row 0 -sticky nsw -ipady 1p -pady 1p
    #
    #grid $jobFrame.txt5a -column 0 -row 1 -sticky nse -padx 3p
    #grid $jobFrame.txt5b -column 1 -row 1 -sticky nsw -ipady 1p -pady 1p
    #grid $jobFrame.txt6b -column 2 -row 1 -sticky nsw -ipady 1p -pady 1p
    


    ## Tab 1 (Destinations) / Second Level
    ## 
    set nb [ttk::notebook $w(nbk).f3.nb]
    pack $nb -expand yes -fill both -padx 5p -pady 5p
    #grid $nb -column 0 -row 3 -sticky news

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
    #------------- Frame 2, Tablelist Notebook
    ##
    set files(tab3f2) [ttk::frame $nb.f1.f2]
    pack $files(tab3f2) -side bottom -fill both -expand yes
    
    
    set scrolly $files(tab3f2).scrolly
    set scrollx $files(tab3f2).scrollx
    # Columns are configured in importFiles_code.tcl [importFiles::insertIntoGUI]
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
                                    -labelcommand tablelist::sortByColumn \
                                    -labelcommand2 tablelist::addToSortColumns \
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

    # Setup the bindings
    set bodyTag [$files(tab3f2).tbl bodytag]
    set labelTag [$files(tab3f2).tbl labeltag]
    set editWinTag [$files(tab3f2).tbl editwintag]
    
    # Begin bodyTag
    #bind $bodyTag <<Button3>> +[list tk_popup .tblMenu %X %Y]
    
    # Toggle between selecting a row, or a single cell
    bind $bodyTag <Button-1> {
        #${log}::debug Clicked on column %W %x %y
        #${log}::debug Column Name: [$files(tab3f2).tbl containingcolumn %x]
        set colName [$files(tab3f2).tbl columncget [$files(tab3f2).tbl containingcolumn %x] -name]
        #${log}::debug Column Name: $colName
        
        if {$colName eq "OrderNumber"} {
            $files(tab3f2).tbl configure -selecttype row
        } else {
            $files(tab3f2).tbl configure -selecttype cell
        }
    }
    
    bind $bodyTag <Double-1> {
        #${log}::debug Clicked on column %W %x %y
        #${log}::debug Column Name: [$files(tab3f2).tbl containingcolumn %x]
        set colName [$files(tab3f2).tbl columncget [$files(tab3f2).tbl containingcolumn %x] -name]
        #${log}::debug Column Name: $colName
        if {$colName eq "OrderNumber"} {
            eAssistHelper::shippingOrder $files(tab3f2).tbl -edit
            ${log}::debug Current Row: [$files(tab3f2).tbl curselection]
        }
    }
   
    
    bind $bodyTag <Control-v> {
        #eAssistHelper::insValuesToTableCells -hotkey $files(tab3f2).tbl [clipboard get] [$files(tab3f2).tbl curcellselection]
        #${log}::debug CLIPBOARD _ CTRL+V t [split [clipboard get] \t]
        #${log}::debug CLIPBOARD _ CTRL+V n [split [clipboard get] \n]
        #${log}::debug CLIPBOARD _ CTRL+V _list [list [clipboard get]]
        #${log}::debug Pressed <Control-V>
    }
    
    bind $bodyTag <Control-c> {
        #IFMenus::copyCell $files(tab3f2).tbl hotkey
        #${log}::debug Pressed <Control-C>
    }
    
    # Begin labelTag
    bind $labelTag <Button-3> +[list tk_popup .tblToggleColumns %X %Y]
    #bind $labelTag <Enter> {tooltip::tooltip $labelTag testing}

    #----- GRID
    grid $files(tab3f2).tbl -column 0 -row 0 -sticky news -padx 5p -pady 5p
    grid columnconfigure $files(tab3f2) $files(tab3f2).tbl -weight 2
    grid rowconfigure $files(tab3f2) $files(tab3f2).tbl -weight 2
    
#ttk::style map TEntry -fieldbackground [list focus yellow]
   
    # Initialize popup menus
    IFMenus::tblPopup $files(tab3f2).tbl browse .tblMenu
    IFMenus::createToggleMenu $files(tab3f2).tbl

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
    global log mb files job

    if {[winfo exists $mb.modMenu.quick]} {
        destroy $mb.modMenu.quick
    }
    
    if {[winfo exists $mb.modMenu.validate]} {
        destroy $mb.modMenu.validate
    }

    if {[winfo exists $mb.file.project]} {
        destroy $mb.file.project
    }
    
    if {[winfo exists $mb.file.reports]} {
        destroy $mb.file.reports
    }
    
    if {[winfo exists $mb.file.job]} {
        destroy $mb.file.job
    }
    
    $mb.modMenu delete 0 end
    $mb.file delete 0 end
    
    # Add Module specific Menus
    menu $mb.file.project
    $mb.file add cascade -label [mc "Title"] -menu $mb.file.project
        # New Title allows you to add a Title and job at the same time. Edit only allows you to modify the Title
        $mb.file.project add command -label [mc "New..."] -command {customer::projSetup newTitle $mb.file} ;# Activate the Job menu
        $mb.file.project add command -label [mc "Edit..."] -command {customer::projSetup editTitle} ;# Read Only on the job level widgets
        $mb.file.project add command -label [mc "Open..."] -command {job::db::open $mb.file} ;# Activate the Job menu
    menu $mb.file.job
    $mb.file add cascade -label [mc "Job"] -menu $mb.file.job -state disabled
     # New Job requires a Title DB to be opened already or else the state is disabled. Edit Job allows you to modify the job info only.
        $mb.file.job add command -label [mc "New..."] -command {customer::projSetup newJob} ;# Read Only on the Title level widgets
        $mb.file.job add command -label [mc "Edit..."] -command {customer::projSetup editJob} ;# Read Only on the Title level widgets
        $mb.file.job add command -label [mc "Open..."] -command {${log}::debug Open Job}
    $mb.file add separator
    $mb.file add command -label [mc "Import File"] -command {importFiles::fileImportGUI}
    $mb.file add command -label [mc "Export File"] -command {export::DataToExport} ;#-state disabled
    $mb.file add separator
    menu $mb.file.reports
    $mb.file add cascade -label [mc "Reports"] -menu $mb.file.reports
    $mb.file.reports add command -label [mc "General"] -command {job::reports::Viewer}
    
    #$mb.file add command -label [mc "Export File"] -command {export::newDataToExport}
    
    # Change menu name
    #$mb entryconfigure Edit -label Distribution
    # Add cascade
    #menu $mb.modMenu.quick
    #$mb.modMenu add cascade -label [mc "Quick Add"] -menu $mb.modMenu.quick 
    #$mb.modMenu.quick add command -label [mc "JG Mail"]
    #$mb.modMenu.quick add command -label [mc "JG Inventory"]
    
    #$mb.modMenu add separator
    
    $mb.modMenu add command -label [mc "Notes"] -command {eAssistHelper::editNotes}
    $mb.modMenu add command -label [mc "Add Destination"] -command {eAssistHelper::shippingOrder $files(tab3f2).tbl -add}
    $mb.modMenu add command -label [mc "Filters..."] -command {eAssist_tools::FilterEditor}
    
    #Add Cascade for Validation functions
    menu $mb.modMenu.validate
    $mb.modMenu add cascade -label [mc "Validation"] -menu $mb.modMenu.validate
    $mb.modMenu.validate add command -label [mc "Check Country against Zip"] -command {ea::validate::checkCountryAgainstZip; importFiles::highlightAllRecords $files(tab3f2).tbl}
    #$mb.modMenu add command -label [mc "Internal Samples"] -command {eAssistHelper::addCompanySamples} -state disable
    #$mb.modMenu add command -label [mc "Split"] -command {eAssistHelper::splitVersions}
    $mb.modMenu add command -label [mc "Manage Customers..."] -command {customer::manage}
    
    #$mb.modMenu add separator
    #
    #$mb.modMenu add command -label [mc "Preferences"] -command {ea::gui::pref::startPref}
	
    #${log}::debug --END -- [info level 1]
} ;# importFiles::initMenu
