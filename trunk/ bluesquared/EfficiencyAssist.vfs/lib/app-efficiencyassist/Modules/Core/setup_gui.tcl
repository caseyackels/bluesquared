# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 157 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2011-10-03 14:41:48 -0700 (Mon, 03 Oct 2011) $
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

package provide eAssist_setup 1.0

namespace eval eAssistSetup {}


proc eAssistSetup::eAssistSetup {} {
    #****f* eAssistSetup/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Setup Efficiency Assist; this is not a Preference window, so it shouldn't be used by anyone outside of the person setting it.
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	eAssistSetup::selectionChanged
    #
    # PARENTS
    #	eAssist::parentGUI
    #
    # NOTES
    #
    # SEE ALSO
    #
    #
    #***
    global G_setupFrame currentModule tree log program
    
    set currentModule Setup
    
    # Reset frames before continuing
    eAssist_Global::resetFrames
    
    # Create tree for Setup
    set tbl [ttk::frame .container.tree]
    pack $tbl -fill both -side left -anchor nw -padx 5p -pady 5p -ipady 2p
    
    # Create main frame for all children in Setup
    set G_setupFrame [ttk::frame .container.setup]
    pack $G_setupFrame -expand yes -fill both -anchor n -padx 5p -pady 5p -ipady 2p
    
    # Create groups and children
    # 
    # *** Add your new options to: eAssistSetup::selectionChanged
    set tree(groups) {BoxLabels BatchAddresses Setup Company}
    
    set tree(BoxLabelsChildren) [list Paths Labels Delimiters Headers ShipMethod Misc.] ;# when changing these, also change them in eAssistSetup::selectionChanged
        set BoxLabelsChildren_length [llength $tree(BoxLabelsChildren)] ;# so we can add new tree items without having to adjust manually. Used in following childLists.
    
    set tree(BatchAddressesChildren) [list row2 row2 another2]
        set BatchAddressesChildren_length [llength $tree(BatchAddressesChildren)]
    

    
    tablelist::tablelist $tbl.t -columns {18 ""}\
                                -background white \
                                -exportselection yes \
                                -yscrollcommand [list $tbl.scrolly set] \
                                -xscrollcommand [list $tbl.scrollx set]
    
    grid $tbl.t -column 0 -row 0 -sticky news
    
    ttk::scrollbar $tbl.scrolly -orient v -command [list $tbl.t yview]
    ttk::scrollbar $tbl.scrollx -orient h -command [list $tbl.t xview]

    grid $tbl.t -column 0 -row 0 -sticky news;# -padx 5p -pady 5p
    grid columnconfigure $tbl $tbl.t -weight 1
    grid rowconfigure $tbl $tbl.t -weight 1

    grid $tbl.scrolly -column 1 -row 0 -sticky nse
    grid $tbl.scrollx -column 0 -row 1 -sticky ews

    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $tbl.scrolly
    ::autoscroll::autoscroll $tbl.scrollx
    
    # Insert groups
    $tbl.t insertchildlist root end $tree(groups)
    
    # Group - BoxLabels
    $tbl.t insertchildlist 0 end $tree(BoxLabelsChildren)
    
    # Group - BatchAddresses
    $tbl.t insertchildlist [incr BoxLabelsChildren_length] end $tree(BatchAddressesChildren)
   
    
    ##
    ## Main Frame
    ##
    
    # Default window
    ${log}::notice currentSetupFrame: [info exists $program(lastFrame)]

    eAssistSetup::$program(lastFrame)
    
    #$tbl.t selection set 1
    #$tbl.t activate 1

   

    ##
    ## Bindings
    ##
    # For Tree widget
    bind $tbl.t <<TablelistSelect>> {eAssistSetup::selectionChanged %W} 

}

proc eAssistSetup::selectFilePaths_GUI {} {
    #****f* eAssistSetup/selectFilePaths_GUI
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Setup Efficiency Assist; this is not a Preference window, so it shouldn't be used by anyone outside of the person setting it.
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	eAssistSetup::selectionChanged
    #
    # PARENTS
    #	eAssist::parentGUI
    #
    # NOTES
    #
    # SEE ALSO
    #
    #
    #***
    global G_setupFrame GS_filePathSetup savePage
    # Default settings, but can be overridden at the user settings level.
    
    eAssist_Global::resetSetupFrames selectFilePaths_GUI ;# Reset all frames so we start clean
    
    set frame1 [ttk::labelframe $G_setupFrame.frame1 -text [mc "File Paths"]]
    pack $frame1 -expand yes -fill both ;#-side top -anchor n -expand yes -fill both -padx 5p -pady 5p -ipady 2p
    
    ttk::label $frame1.txt1 -text [mc "Bartender"]
    ttk::entry $frame1.entry1 -textvariable GS_filePathSetup(bartenderEXE) -state disabled
    ttk::button $frame1.button1 -text [mc "Browse..."] -state disabled -command {set GS_filePathSetup(bartenderEXE) [eAssist_Global::OpenFile [mc "Find Bartender"] [pwd] file *.exe]}
        
        set GS_filePathSetup(enable,Bartender) 1
    ttk::checkbutton $frame1.checkbutton1 -text [mc "Disable"] -variable GS_filePathSetup(enable,Bartender) \
                                            -command {eAssistSetup::controlState $GS_filePathSetup(enable,Bartender) .container.setup.frame1.entry1 .container.setup.frame1.button1}

    ttk::label $frame1.txt2 -text [mc "Look in Directory"]
    ttk::entry $frame1.entry2 -textvariable GS_filePathSetup(lookInDirectory)
    ttk::button $frame1.button2 -text [mc "Browse..."] -command {set GS_filePathSetup(lookInDirectory) [eAssist_Global::OpenFile [mc "Set default Directory"] [pwd] dir]}
    #ttk::checkbutton $frame1.checkbutton2 -text [mc "Enable"] -command {} -variable GS_filePathSetup(enable,lookInDirectory)
    
    ttk::label $frame1.txt3 -text [mc "Save to Directory"]
    ttk::entry $frame1.entry3 -textvariable GS_filePathSetup(saveInDirectory)
    ttk::button $frame1.button3 -text [mc "Browse..."] -command {set GS_filePathSetup(saveInDirectory) [eAssist_Global::OpenFile [mc "Set default Save-to Directory"] [pwd] dir]}
    #ttk::checkbutton $frame1.checkbutton3 -text [mc "Enable"] -command {} -variable GS_filePathSetup(enable,saveInDirectory)
    
    #------------------------------
    
    grid $frame1.txt1 -column 0 -row 0 -padx 2p -pady 2p -sticky nse
    grid $frame1.entry1 -column 1 -row 0 -padx 2p -pady 2p -sticky news
    grid $frame1.button1 -column 2 -row 0 -padx 2p -pady 2p -sticky news
    grid $frame1.checkbutton1 -column 1 -row 1 -padx 2p -pady 2p -sticky nws
    
    grid $frame1.txt2 -column 0 -row 2 -padx 2p -pady 2p -sticky nse
    grid $frame1.entry2 -column 1 -row 2 -padx 2p -pady 2p -sticky news
    grid $frame1.button2 -column 2 -row 2 -padx 2p -pady 2p -sticky news
    
    grid $frame1.txt3 -column 0 -row 3 -padx 2p -pady 2p -sticky nse
    grid $frame1.entry3 -column 1 -row 3 -padx 2p -pady 2p -sticky news
    grid $frame1.button3 -column 2 -row 3 -padx 2p -pady 2p -sticky news
    
    grid columnconfigure $frame1 1 -weight 1 
} ;# eAssistSetup::selectFilePaths_GUI

proc eAssistSetup::boxLabels_GUI {} {
    #****f* eAssistSetup/boxLabels_GUI
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2013 Casey Ackels
    #
    # FUNCTION
    #	Configure the box labels, this is where we will link the bartender label to eAssist.
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	eAssistSetup::selectionChanged
    #
    # PARENTS
    #	eAssist::parentGUI
    #
    # NOTES
    #
    # SEE ALSO
    #
    #
    #***
    global G_setupFrame internal log boxLabelInfo
    
    eAssist_Global::resetSetupFrames boxLabels_GUI ;# Reset all frames so we start clean
    
    set frame1 [ttk::labelframe $G_setupFrame.frame1 -text [mc "Define Box Labels"]]
    pack $frame1 -expand yes -fill both ;#-side top -anchor n -expand yes -fill both -padx 5p -pady 5p -ipady 2p
    
    ttk::button $frame1.btn -text [mc "Add New Label..."] -command {eAssistSetup::addLabel}
    
    ttk::label $frame1.txt -text [mc "Select Label"]
    ${log}::debug box label names: $boxLabelInfo(labelNames)
    
    ttk::combobox $frame1.cbox -width 20 \
                                -values $boxLabelInfo(labelNames) \
                                -state readonly \
                                -textvariable boxLabelInfo(currentBoxLabel)
    

    
    #ttk::label $frame1.txt1 -text [mc "Label Directory"]
    #ttk::entry $frame1.entry1 -textvariable GS_filePaths(labelDirectory)
    #ttk::button $frame1.button1 -text [mc "Browse..."] -command {set GS_filePaths(labelDirectory) [eAssist_Global::OpenFile [mc "Set default Save-to Directory"] [pwd] dir]}
    #
    #ttk::checkbutton $frame1.checkbutton1 -text [mc "Use global path"] -variable globalPath
    #    $frame1.checkbutton1 invoke ;# lets preselect this
    #
    #ttk::label $frame1.txt2 -text [mc "Label Name"]
    #ttk::entry $frame1.entry2 -textvariable GS_label(name)
    #
    #ttk::label $frame1.txt3 -text [mc "Number of Fields"]
    #spinbox $frame1.spin -from 1 -to 20 -increment 1 -textvariable GS_label(numberOfFields) -command {eAssistSetup::createRows .container.frame2.listbox $GS_label(numberOfFields)}
    
    #------------------------------
    
    grid $frame1.btn -column 0 -row 0 -padx 2p -pady 2p  -sticky ew
    grid $frame1.txt -column 0 -row 1 -padx 2p -pady 2p -sticky nse
    grid $frame1.cbox -column 1 -row 1 -padx 2p -pady 2p -sticky news
    
    #grid $frame1.txt1 -column 0 -row 1 -padx 2p -pady 2p -sticky nse
    #grid $frame1.entry1 -column 1 -row 1 -padx 2p -pady 2p -sticky news
    #grid $frame1.button1 -column 2 -row 1 -padx 2p -pady 2p -sticky ew
    #grid $frame1.checkbutton1 -column 1 -row 2 -sticky nsw
    #
    #grid $frame1.txt2 -column 0 -row 3 -padx 2p -pady 2p -sticky nse
    #grid $frame1.entry2 -column 1 -row 3 -padx 2p -pady 2p -sticky news
    #
    #grid $frame1.txt3 -column 0 -row 5 -padx 2p -pady 2p -sticky nse
    #grid $frame1.spin -column 1 -row 5 -padx 2p -pady 2p -sticky news
    #
    #grid columnconfigure $frame1 1 -weight 1
    
   #------------------------------
    
    set frame2 [ttk::labelframe $G_setupFrame.frame2 -text [mc "Define Box Labels Headers"]]
    pack $frame2 -expand yes -fill both ;#-side top -anchor n -expand yes -fill both -padx 5p -pady 5p -ipady 2p
    
    tablelist::tablelist $frame2.listbox -columns {
                                                    0   "..."       center
                                                    0   "Field" center
                                                    0   "Field Name"  center
                                                    0   "Num of Chars"  center
                                                    0   "Import Header" center
                                                    0   "Delimter"
                                                    } \
                                        -showlabels yes \
                                        -height 5 \
                                        -selectbackground yellow \
                                        -selectforeground black \
                                        -stripebackground lightblue \
                                        -exportselection yes \
                                        -showseparators yes \
                                        -fullseparators yes \
                                        -yscrollcommand [list $frame2.scrolly set] \
                                        -editstartcommand {eAssistSetup::startCmdBoxLabels} \
                                        -editendcommand {eAssistSetup::endCmdBoxLabels}

        $frame2.listbox columnconfigure 0 -name "count" \
                                            -showlinenumbers 1

        $frame2.listbox columnconfigure 1 -name "field" \
                                            -editable yes \
                                            -editwindow ttk::combobox
        $frame2.listbox columnconfigure 2 -name "fieldName" \
                                            -editable yes \
                                            -editwindow ttk::entry
        $frame2.listbox columnconfigure 3 -name "numOfChars" \
                                            -editable yes \
                                            -editwindow ttk::entry
        $frame2.listbox columnconfigure 4 -name "importHeader" \
                                            -editable yes \
                                            -editwindow ttk::entry
        $frame2.listbox columnconfigure 5 -name "delimter" \
                                            -editable yes \
                                            -editwindow ttk::entry
        
    set internal(table2,currentRow) 0
        
        if {[info exists setup(boxLabelConfig)]} {
            #'debug Populate listobx - data exists
                foreach boxlabel $setup(boxLabelConfig) {
                    #'debug inserting $customer
                    $frame2.listbox insert end $boxlabel
                    incr internal(table2,currentRow)
                }
        }

    # Create the first line
    $frame2.listbox insert end ""


    ttk::scrollbar $frame2.scrolly -orient v -command [list $frame2.listbox yview]

    grid $frame2.listbox -column 0 -row 0 -sticky news
    grid columnconfigure $frame2 $frame2.listbox -weight 1

    grid $frame2.scrolly -column 1 -row 0 -sticky nse

    ::autoscroll::autoscroll $frame2.scrolly ;# Enable the 'autoscrollbar'
    
    
} ;# eAssistSetup::boxLabels_GUI


proc eAssistSetup::setup_GUI {} {
    #****f* eAssistSetup/setup_GUI
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2013 Casey Ackels
    #
    # FUNCTION
    #	Setup core program information
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	
    #
    # PARENTS
    #	
    #
    # NOTES
    #
    # SEE ALSO
    #
    #
    #***
    global G_setupFrame GS_program log logSettings s
    
    eAssist_Global::resetSetupFrames setup_GUI;# Reset all frames so we start clean
    
    set s(frame1) [ttk::labelframe $G_setupFrame.frame1 -text [mc "Log Settings"]]
    pack $s(frame1) -expand yes -fill both
    
    set logSettings(levels) [list Debug Info Notice Warn Error Critical Alert Emergency]
    
    ttk::label $s(frame1).text1 -text [mc "Log Level"]
    ttk::combobox $s(frame1).cbox1 -width 20 \
                            -values $logSettings(levels) \
                            -state readonly \
                            -textvariable logSettings(currentLogLevel)
    
    #----------- Grid
    grid $s(frame1).text1 -column 0 -row 0 -padx 5p -pady 5p
    grid $s(frame1).cbox1 -column 1 -row 0 -padx 5p -pady 5p
    
    bind all <<ComboboxSelected>> { 
    ${log}::debug [$s(frame1).cbox1 current]
        eAssistSetup::changeLogLevel [$s(frame1).cbox1 current]
    }
    
} ;# eAssistSetup::setup_GUI


proc eAssistSetup::company_GUI {} {
    #****f* eAssistSetup/company_GUI
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2013 Casey Ackels
    #
    # FUNCTION
    #	Specify the current company information; and account numbers.
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	
    #
    # PARENTS
    #	
    #
    # NOTES
    #
    # SEE ALSO
    #
    #
    #***
    global G_setupFrame GS_program company internal currentModule setup
    
    set currentModule Setup
    eAssist_Global::resetSetupFrames ;# Reset all frames so we start clean
    
    set frame1 [ttk::labelframe $G_setupFrame.frame1 -text [mc "Company Information"]]
    pack $frame1 -expand yes -fill both
    
    ttk::label $frame1.companyText -text [mc "Company Name"]
    ttk::entry $frame1.companyEntry -textvariable company(name)
    
    ttk::label $frame1.contactText -text [mc "Contact"]
    ttk::entry $frame1.contactEntry -textvariable company(contact)
    
    ttk::label $frame1.addr1Text -text [mc "Addr1/Addr2"]
    ttk::entry $frame1.addr1Entry -textvariable company(addr1)
    set company(addr2) ""
    ttk::entry $frame1.addr2Entry -textvariable company(addr2)
    
    set company(addr3) ""
    ttk::label $frame1.addr3Text -text [mc "Address 3"]
    ttk::entry $frame1.addr3Entry -textvariable company(addr3)
    
    ttk::label $frame1.cityText -text [mc "City/State/Zip"]
    ttk::entry $frame1.cityEntry -textvariable company(city)
    ttk::entry $frame1.stateEntry -textvariable company(state)
    ttk::entry $frame1.zipEntry -textvariable company(zip)
    
    ttk::label $frame1.phoneText -text [mc "Phone"]
    ttk::entry $frame1.phoneEntry -textvariable company(phone)
    
    #set company(country) "US"
    ttk::label $frame1.countryText -text [mc "Country"]
    ttk::entry $frame1.countryEntry -textvariable company(country)
    
    
    #-------- Grid
    grid $frame1.companyText -column 0 -row 0 -sticky e -pady 3p -padx 5p
    grid $frame1.companyEntry -column 1 -row 0 -columnspan 3 -sticky ew
    
    grid $frame1.contactText -column 0 -row 1 -sticky e -pady 3p -padx 5p
    grid $frame1.contactEntry -column 1 -row 1 -columnspan 3 -sticky ew
    
    grid $frame1.addr1Text -column 0 -row 2 -sticky e -pady 3p -padx 5p
    grid $frame1.addr1Entry -column 1 -row 2 -columnspan 2 -sticky ew
    grid $frame1.addr2Entry -column 3 -row 2 -sticky ew
    
    grid $frame1.addr3Text -column 0 -row 3 -sticky e -pady 3p -padx 5p
    grid $frame1.addr3Entry -column 1 -row 3 -sticky ew
    
    grid $frame1.cityText -column 0 -row 4 -sticky e -pady 3p -padx 5p
    grid $frame1.cityEntry -column 1 -row 4 -sticky ew
    grid $frame1.stateEntry -column 2 -row 4 -sticky e
    grid $frame1.zipEntry -column 3 -row 4 -sticky ew
    
    grid $frame1.phoneText -column 0 -row 5 -sticky e -pady 3p -padx 5p
    grid $frame1.phoneEntry -column 1 -row 5 -columnspan 3  -sticky ew
    
    grid $frame1.countryText -column 0 -row 6 -sticky e -pady 3p -padx 5p
    grid $frame1.countryEntry -column 1 -row 6 -columnspan 3 -sticky ew
    
    grid columnconfigure $frame1 1 -weight 1

    
    set frame2 [ttk::labelframe $G_setupFrame.frame2 -text [mc "Small Package Carriers"]]
    pack $frame2 -expand yes -fill both
    
    set scrolly $frame2.scrolly
    tablelist::tablelist $frame2.listbox \
                -columns {
                        10  "Carrier"   left
                        0  "Account"   center
                        0   "..."       center
                        } \
                -showlabels yes \
                -stretch 1 \
                -selectbackground yellow \
                -selectforeground black \
                -stripebackground lightblue \
                -exportselection yes \
                -showseparators yes \
                -fullseparators yes \
                -editstartcommand {eAssistSetup::startCmd} \
                -editendcommand {eAssistSetup::endCmd} \
                -yscrollcommand [list $scrolly set]
        
        $frame2.listbox columnconfigure 0 -name Carrier \
                                            -labelalign center \
                                            -editable yes \
                                            -editwindow ttk::entry
        
        $frame2.listbox columnconfigure 1 -name Account \
                                            -editable yes \
                                            -editwindow ttk::entry
        
        $frame2.listbox columnconfigure 2 -name Delete \
                                        -editable no
    
    set internal(table,currentRow) 0
        
        if {[info exists setup(smallPackageCarriers)]} {
            #'debug Populate listobx - data exists
                foreach carrier $setup(smallPackageCarriers) {
                    #'debug inserting $customer
                    $frame2.listbox insert end $carrier
                    incr internal(table,currentRow)
                }
        }
        
    # Create the first line
    $frame2.listbox insert end ""

        
    ttk::scrollbar $scrolly -orient v -command [list $frame2.listbox yview]
        
    grid $scrolly -column 1 -row 0 -sticky ns
        
    ::autoscroll::autoscroll $scrolly ;# Enable the 'autoscrollbar'
    
    grid $frame2.listbox -column 0 -row 0 -sticky news -padx 5p -pady 5p
    grid columnconfigure $frame2 $frame2.listbox -weight 1
    
    #-------- Bindings

    bind [$frame2.listbox bodytag] <Double-1> {
        if {$internal(table,currentRow) != 0} {
            .container.setup.frame2.listbox delete [.container.setup.frame2.listbox curselection]        
            incr internal(table,currentRow) -1
        }
    }
  
} ;# eAssistSetup::setup_GUI


##
## Helper Windows
##

proc eAssistSetup::addLabel {} {
    #****f* eAssistSetup/addLabel
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2013 Casey Ackels
    #
    # FUNCTION
    #	Add labels to Efficiency Assist
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	
    #
    # PARENTS
    #	eAssistSetup::boxLabels_GUI
    #
    # NOTES
    #   GS_filePath - Do not write this to the settings.txt file, this is data that will be inserted into a table, which will then be saved to the settings.txt file
    #   GS_filePathSetup - Settings to be written to the file.
    #
    # SEE ALSO
    #
    #
    #***
    global GS_filePathSetup GS_filePath log GS_label
    
    toplevel .addLabel
    wm transient .addLabel .
    wm title .addLabel [mc "Add Box Label"]

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    wm geometry .addLabel +${locX}+${locY}


    ##
    ## Parent Frame
    ##
    set frame1 [ttk::frame .addLabel.frame1]
    pack $frame1 -expand yes -fill both -pady 5p -padx 5p
    
    ttk::label $frame1.txt1 -text [mc "Label Directory"]
    ttk::entry $frame1.entry1 -textvariable GS_filePathSetup(labelDirectory)
    ttk::button $frame1.button1 -text [mc "Browse..."] -command {set GS_filePathSetup(labelDirectory) [eAssist_Global::OpenFile [mc "Set default Save-to Directory"] [pwd] dir]}
    
        set GS_filePathSetup(useGlobalPath) 0
    ttk::checkbutton $frame1.checkbutton1 -text [mc "Use global path"] -variable GS_filePathSetup(useGlobalPath) \
                                            -state disabled \
                                            -command {
                                                set GS_filePathSetup(labelDirectory) $GS_filePathSetup(lookInDirectory)
                                                eAssistSetup::controlState $GS_filePathSetup(useGlobalPath) .addLabel.frame1.entry1 .addLabel.frame1.button1}
        
        if {[info exists GS_filePathSetup(lookInDirectory)] == 1 && $GS_filePathSetup(lookInDirectory) ne "" } {
            # Lets make sure that we have a default setup, before we disable this option.
            $frame1.checkbutton1 configure -state enable
            $frame1.checkbutton1 invoke
        }
    
    ttk::label $frame1.txt2 -text [mc "Label Name"]
    ttk::entry $frame1.entry2 -textvariable GS_label(name)
        
    
    ttk::label $frame1.txt3 -text [mc "Number of Fields"]
    ttk::entry $frame1.entry3 -textvariable GS_label(numberOfFields)
    
    ttk::button $frame1.cncl -text [mc "Cancel"] -command {destroy .addLabel}
    ttk::button $frame1.ok -text [mc "OK"] -command {
                                                    eAssistSetup::saveBoxLabels $GS_label(name) $GS_label(numberOfFields) $GS_filePathSetup(labelDirectory)
                                                    destroy .addLabel
                                                    }
    
    #------- GUI Calculations
    #focus $frame1.entry2
    if {$GS_filePathSetup(useGlobalPath) == 1} {
        focus $frame1.entry2
    } else {
        focus $frame1.entry1
    }
    
    #------------- Grid
    
    grid $frame1.txt1 -column 0 -row 1 -padx 2p -pady 2p -sticky nse
    grid $frame1.entry1 -column 1 -columnspan 2 -row 1 -padx 2p -pady 2p -sticky news
    grid $frame1.button1 -column 3 -row 1 -padx 2p -pady 2p -sticky ew
    grid $frame1.checkbutton1 -column 1 -row 2 -sticky nsw
    
    grid $frame1.txt2 -column 0 -row 3 -padx 2p -pady 2p -sticky nse
    grid $frame1.entry2 -column 1 -columnspan 2 -row 3 -padx 2p -pady 2p -sticky news
    
    grid $frame1.txt3 -column 0 -row 5 -padx 2p -pady 2p -sticky nse
    grid $frame1.entry3 -column 1 -row 5 -padx 2p -pady 2p -sticky news
    
    grid $frame1.cncl -column 2 -row 6 -padx 2p -pady 2p -sticky nse
    grid $frame1.ok -column 3 -row 6 -padx 2p -pady 2p -sticky nse
    
    
    
    grid columnconfigure $frame1 1 -weight 1
    
    tooltip::tooltip $frame1.entry3 [mc "Total number of fields in the label, not including the Qty field."]
    
    
} ;# eAssistSetup::boxLabels_GUI
