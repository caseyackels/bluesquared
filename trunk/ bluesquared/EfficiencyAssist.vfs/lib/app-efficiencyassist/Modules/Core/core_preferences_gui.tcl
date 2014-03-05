# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 09 30,2013
# Dependencies: 
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
# core file for preferences to launch from

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

namespace eval eAssistPref {}

proc eAssistPref::launchPreferences {} {
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
    global log program pref settings
    
	set currentModule [lrange $settings(currentModule) 0 0]
	
    toplevel .preferences
    wm transient .preferences .
    wm title .preferences [mc "$currentModule Preferences"]

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    wm geometry .preferences +${locX}+${locY}

    focus .preferences
    ${log}::debug which Preferences : $currentModule
    
    
    ##
    ## Parent Frame
    ##
    set pref(frame0) [ttk::frame .preferences.frame0]
    pack $pref(frame0) -expand yes -fill both -pady 5p -padx 5p

    ##
    ## Notebook
    ##
    set pref(nb) [ttk::notebook $pref(frame0).nb]
    pack $pref(nb) -expand yes -fill both

    # Tab setup is in the corresponding proc
    ttk::notebook::enableTraversal $pref(nb)
    
    switch -- [string tolower $currentModule] {
        batchmaker   {${log}::debug Launching $currentModule; eAssistPref::launchBatchMakerPref} ;#eAssist_Global::resetFrames pref
        boxlabels   {${log}::debug Launching $currentModule} ;#eAssist_Global::resetFrames pref
        setup       {${log}::debug Launching $currentModule} ;#eAssist_Global::resetFrames pref
		default		{${log}::debug $currentModule isn't setup yet}
    }

    
    set btnBar [ttk::frame .preferences.btnBar]
    pack $btnBar -side bottom -anchor e -pady 8p -padx 5p
    
    ttk::button $btnBar.ok -text [mc "OK"] -command {lib::savePreferences; destroy .preferences}
    ttk::button $btnBar.cancel -text [mc "Cancel"] -command {destroy .preferences}
    
	grid $btnBar.ok -column 0 -row 3 -sticky nse -padx 8p
    grid $btnBar.cancel -column 1 -row 3 -sticky nse 

} ;#eAssistPref::launchPreferences


proc eAssistPref::launchBatchMakerPref {} {
    #****f* launchBatchMakerPref/eAssistPref
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	display the address preferences
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
    #   These are set per computer. So we cannot save these values to the same file that we save the Setup config to.
    #
    # SEE ALSO
    #
    #***
    global log pref internal mySettings setup
    # Reset Frames
    
    # Setup the tabs
    $pref(nb) add [ttk::frame $pref(nb).f1] -text [mc "File Paths"]
    $pref(nb) add [ttk::frame $pref(nb).f2] -text [mc "3P - Ship Via"]
    $pref(nb) add [ttk::frame $pref(nb).f3] -text [mc "Int'l Defaults"]
    #$nb add [ttk::frame $nb.f5] -text [mc "Company"]
    #$nb add [ttk::frame $nb.f6] -text [mc "Int'l Defaults"]
    $pref(nb) select $pref(nb).f1
    
    ##
    ## - Tab1
    ##
	if {![info exists mySettings(job,fileName)]} {set mySettings(job,fileName) "%number %title %name"}
    
    set tab1 [ttk::labelframe $pref(nb).f1.tab1 -text [mc "File Paths"]]
    pack $tab1 -expand yes -fill both -padx 5p -pady 5p
    
    ttk::label $tab1.sourceText -text [mc "Source Import Files"]
    ttk::entry $tab1.sourceEntry -textvariable mySettings(sourceFiles)
    ttk::button $tab1.sourceButton -text ... -command {set mySettings(sourceFiles) [eAssist_Global::OpenFile [mc "Choose Directory"] [pwd] dir]; ${log}::debug OpenFile: $mySettings(sourceFiles)}

    ttk::label $tab1.outFilesText -text [mc "Formatted Import Files"]
    ttk::entry $tab1.outFilesEntry -textvariable mySettings(outFilePath)
    ttk::button $tab1.outFilesButton -text ... -command {set mySettings(outFilePath) [eAssist_Global::OpenFile [mc "Choose Directory"] [pwd] dir]; ${log}::debug OpenFile: $mySettings(outFilePath)} 

    ttk::label $tab1.txt -text [mc "Output File Name"]
    ttk::entry $tab1.entry -textvariable mySettings(job,fileName)
    ttk::label $tab1.txt2 -text "%number (Job Number), %title (Job Title), %name (Job Name)"
	
	
    #---- Grid
    grid $tab1.sourceText -column 0 -row 0 -sticky e -padx 5p -pady 5p
    grid $tab1.sourceEntry -column 1 -row 0 -sticky ew -padx 5p -pady 5p
    grid $tab1.sourceButton -column 2 -row 0 -sticky e -padx 5p -pady 5p

    grid $tab1.outFilesText -column 0 -row 1 -sticky e -padx 5p -pady 5p
    grid $tab1.outFilesEntry -column 1 -row 1 -sticky ew -padx 5p -pady 5p
    grid $tab1.outFilesButton -column 2 -row 1 -sticky e -padx 5p -pady 5p
	
	grid $tab1.txt -column 0 -row 2 -sticky e -padx 5p -pady 5p
	grid $tab1.entry -column 1 -row 2 -sticky ew -padx 5p -pady 5p
	grid $tab1.txt2 -column 0 -columnspan 3 -row 3 -sticky ew -padx 5p -pady 5p

    grid columnconfigure $tab1 1 -weight 2
    
    ##
    ## - Tab2
    ##
	set tab2 [ttk::labelframe $pref(nb).f2.tab2 -text [mc "3p Ship Via Information"]]
    pack $tab2 -expand yes -fill both -pady 5p -padx 5p

    set scrolly2 $tab2.scrolly
    tablelist::tablelist $tab2.listbox \
                -columns {
                        30 "Carrier"    left
                        10 "Ship Via"   center
                        3  "..."        center
                        } \
                -showlabels yes \
                -stretch 0 \
                -height 5 \
                -width 70 \
                -selectbackground yellow \
                -selectforeground black \
                -stripebackground lightblue \
                -exportselection yes \
                -showseparators yes \
                -fullseparators yes \
                -editstartcommand {eAssistPref::startCmd} \
                -editendcommand {eAssistPref::endCmd} \
                -yscrollcommand [list $scrolly2 set]
        
        $tab2.listbox columnconfigure 0 -name "Carrier" \
                                            -editable yes \
                                            -editwindow ttk::combobox
        
        $tab2.listbox columnconfigure 1 -name "Ship Via" \
                                            -editable yes \
                                            -editwindow ttk::entry

        
        $tab2.listbox columnconfigure 2 -name "Delete" \
                                        -editable no
        
        set internal(table2,currentRow) 0
        if {[info exists shipVia3P(table)]} {
                foreach ShipVia $shipVia3P(table) {
                    $tab2.listbox insert end $ShipVia
                    incr internal(table2,currentRow)
                }
        }

        # Create the first line
        $tab2.listbox insert end ""
        
        ttk::scrollbar $scrolly2 -orient v -command [list $tab2.listbox yview]
        
        grid $scrolly2 -column 1 -row 0 -sticky ns
        
        ::autoscroll::autoscroll $scrolly2 ;# Enable the 'autoscrollbar'
    
    grid $tab2.listbox -column 0 -row 1 -sticky news -padx 5p -pady 5p
    grid rowconfigure $tab2 $tab2.listbox -weight 1
    
    $tab2.listbox selection set 0
    $tab2.listbox activate 0
    $tab2.listbox see 0
    focus $tab2.listbox
    
    set tab2b [ttk::labelframe $pref(nb).f2.tab2b -text [mc "Customer Information"]]
    pack $tab2b -expand yes -fill both -pady 5p -padx 5p
    
    ttk::label $tab2b.txt -text [mc "The customer code MUST match what is in the Shipping System."]
    

    set scrolly $tab2b.scrolly
    tablelist::tablelist $tab2b.listbox \
                -columns {
                        30  "Name"    left
                        10  "Code"    center
                        10  "Account"  center
                        3   "..."    center
                        } \
                -showlabels yes \
                -stretch 0 \
                -height 5 \
                -width 70 \
                -selectbackground yellow \
                -selectforeground black \
                -stripebackground lightblue \
                -exportselection yes \
                -showseparators yes \
                -fullseparators yes \
                -editstartcommand {eAssistPref::startCmd} \
                -editendcommand {eAssistPref::endCmd} \
                -yscrollcommand [list $scrolly set]
        
        $tab2b.listbox columnconfigure 0 -name Name \
                                            -labelalign center \
                                            -editable yes \
                                            -editwindow ttk::entry
        
        $tab2b.listbox columnconfigure 1 -name Code \
                                            -editable yes \
                                            -editwindow ttk::entry
        
        $tab2b.listbox columnconfigure 2 -name Account \
                                            -editable yes \
                                            -editwindow ttk::entry
        
        $tab2b.listbox columnconfigure 3 -name Delete \
                                        -editable no
        
        set internal(table,currentRow) 0
        
        if {[info exists customer3P(table)]} {
            #'debug Populate listobx - data exists
                foreach customer $customer3P(table) {
                    #'debug inserting $customer
                    $tab2b.listbox insert end $customer
                    incr internal(table,currentRow)
                }
        }

        # Create the first line
        $tab2b.listbox insert end ""
        
        ttk::scrollbar $scrolly -orient v -command [list $tab2b.listbox yview]
        
        grid $scrolly -column 1 -row 0 -sticky ns
        
        ::autoscroll::autoscroll $scrolly ;# Enable the 'autoscrollbar'
    grid $tab2b.txt -column 0 -row 0 -padx 5p -pady 5p
    
    grid $tab2b.listbox -column 0 -row 1 -sticky news -padx 5p -pady 5p
    grid rowconfigure $tab2b $tab2b.listbox -weight 1
    
    $tab2b.listbox selection set 0
    $tab2b.listbox activate 0
    $tab2b.listbox see 0
    
    #------Bindings
bind [$pref(nb).f2.tab2.listbox bodytag] <Double-1> {
    if {$internal(table2,currentRow) != 0} {
        $pref(nb).f2.tab2.listbox delete [$pref(nb).f2.tab2.listbox curselection]
        
        incr internal(table2,currentRow) -1
    }
}

bind [$pref(nb).f2.tab2b.listbox bodytag] <Double-1> {
    if {$internal(table,currentRow) != 0} {
        $pref(nb).f2.tab2b.listbox delete [$pref(nb).f2.tab2b.listbox curselection]
        
        incr internal(table,currentRow) -1
    }
}

#bind [$tab4.listbox bodytag] <Double-1> {
#    if {$internal(table,currentRow) != 0} {
#        .preferences.frame0.nb.f4.customer.listbox delete [.preferences.frame0.nb.f4.customer.listbox curselection]
#        
#        incr internal(table,currentRow) -1
#    }
#}



} ;# eAssistPref::launchBatchMakerPref
