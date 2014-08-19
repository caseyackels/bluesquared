# Creator: Casey Ackels
# Initial Date: September, 2013]
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
# This file holds the setup GUI for Efficiency Assist

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

namespace eval eAssistSetup {
    global program
    # List of namespace variables
        # w - Useage: Array, w(module_frame).widget
            variable GUI
}


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
    global G_setupFrame program tree log GS options settings
    
    #set program(currentModule) Setup
    #set currentModule Setup
    
    # Reset frames before continuing
    eAssist_Global::resetFrames parent
    
    #eAssist_Global::getGeom [lindex $settings(currentModule) 0]
    #
    #if {[info exists options(geom,[lindex $settings(currentModule) 0])]} {
    #    wm geometry . $options(geom,[lindex $settings(currentModule) 0])
    #} else {
    #    wm geometry . 700x610 ;# Width x Height
    #}
    
    
    # Create tree for Setup
    set tbl [ttk::frame .container.tree]
    pack $tbl -fill both -side left -anchor nw -padx 5p -pady 5p -ipady 2p
    
    # Create main frame for all children in Setup
    set G_setupFrame [ttk::frame .container.setup]
    pack $G_setupFrame -expand yes -fill both -anchor n -padx 5p -pady 5p -ipady 2p
    
    # Create groups and children
    # 
    # *** Add your new options to: eAssistSetup::selectionChanged in setup_code.tcl
    set tree(groups) {BoxLabels BatchMaker Packaging DistTypes CSR Company Logging EmailSetup}
    #set tree(groups) [list BoxLabels BatchMaker Packaging DistTypes CSR Company Logging "Email Setup"]
    
    set tree(BoxLabelsChildren) [list Paths Labels Delimiters BoxHeaders ShipMethod Misc.] ;# when changing these, also change them in eAssistSetup::selectionChanged
        set BoxLabelsChildren_length [llength $tree(BoxLabelsChildren)] ;# so we can add new tree items without having to adjust manually. Used in following childLists.
    
    set tree(BatchAddressesChildren) [list International AddressHeaders Carrier]
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
    #${log}::notice currentSetupFrame: [info exists $program(lastFrame)]
    ${log}::notice currentSetupFrame: [info exists GS(gui,lastFrame)]

    #eAssistSetup::$program(lastFrame)
    if {[info exists GS(gui,lastFrame)] == 0} {
        set GS(gui,lastFrame) selectFilePaths_GUI
    }
    eAssistSetup::$GS(gui,lastFrame)
    
    #$tbl.t selection set 1
    #$tbl.t activate 1

   

    ##
    ## Bindings
    ##
    # For Tree widget
    bind $tbl.t <<TablelistSelect>> {eAssistSetup::selectionChanged %W} 

} ;# eAssistSetup::eAssistSetup


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
    
    eAssist_Global::resetSetupFrames ;#selectFilePaths_GUI ;# Reset all frames so we start clean
    
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
    #   Widgets that end with:
    #   _1 (state is always enabled)
    #   _2 (state can change between disabled/enabled)
    #   _3 (state is controlled by a separate method)
    #   _4 (state fluctuates between Readonly and Enabled)
    #
    # SEE ALSO
    #
    #
    #***
    global G_setupFrame internal log boxLabelInfo w GS_filePathSetup GS_label
    
    eAssist_Global::resetSetupFrames ;# boxLabels_GUI ;# Reset all frames so we start clean
    
    #set w(bxFR1) [ttk::labelframe $G_setupFrame.frame1 -text [mc "Define Box Labels"]]
    #pack $w(bxFR1) -expand yes -fill x -anchor n;#-side top -anchor n -expand yes -fill both -padx 5p -pady 5p -ipady 2p
    #
    #
    #${log}::debug box label names: $boxLabelInfo(labelNames)
    #
    #ttk::combobox $w(bxFR1).cbox1 -width 20 \
    #                            -values $boxLabelInfo(labelNames) \
    #                            -state readonly \
    #                            -textvariable boxLabelInfo(currentBoxLabel)
    #
    ##ttk::label $frame1.txt1 -text [mc "Label Directory"]
    ##ttk::entry $frame1.entry1 -textvariable GS_filePaths(labelDirectory)
    ##ttk::button $frame1.button1 -text [mc "Browse..."] -command {set GS_filePaths(labelDirectory) [eAssist_Global::OpenFile [mc "Set default Save-to Directory"] [pwd] dir]}
    ##
    ##ttk::checkbutton $frame1.checkbutton1 -text [mc "Use global path"] -variable globalPath
    ##    $frame1.checkbutton1 invoke ;# lets preselect this
    ##
    ##ttk::label $frame1.txt2 -text [mc "Label Name"]
    ##ttk::entry $frame1.entry2 -textvariable GS_label(name)
    ##
    ##ttk::label $frame1.txt3 -text [mc "Number of Fields"]
    ##spinbox $frame1.spin -from 1 -to 20 -increment 1 -textvariable GS_label(numberOfFields) -command {eAssistSetup::createRows .container.frame2.listbox $GS_label(numberOfFields)}
    #
    ##------------- Grid Frame 1
    #
    #grid $w(bxFR1).cbox1 -column 0 -row 0 -padx 2p -pady 2p -sticky news
  
   ##
   ## Frame 2
   ##
    
    set w(bxFR2) [ttk::labelframe $G_setupFrame.frame2 -text [mc "Add/Modify Box Labels"]]
    pack $w(bxFR2) -expand yes -fill both -side top -anchor n ;#-pady 5p -padx 5p
    
    ttk::label $w(bxFR2).txt0_1 -text [mc "Label Name"]
    ttk::combobox $w(bxFR2).cbox1_4 -width 20 \
                                -values $boxLabelInfo(labelNames) \
                                -state readonly \
                                -textvariable boxLabelInfo(currentBoxLabel) \
                                -postcommand {eAssistSetup::viewBoxLabel $boxLabelInfo(currentBoxLabel)}
    
        # Display the current label; guard against a label not being there.
        if {[info exists boxLabelInfo(currentBoxLabel)] == 1} {
            eAssistSetup::viewBoxLabel $boxLabelInfo(currentBoxLabel)
        } else {
            set boxLabelInfo(currentBoxLabel) ""
        }
    
    ttk::button $w(bxFR2).del_1 -text [mc "Delete"] -command {eAssistSetup::deleteBoxLabel $boxLabelInfo(currentBoxLabel)}
    
    ttk::label $w(bxFR2).txt1_1 -text [mc "Label Folder"]
        set GS_filePathSetup(labelDirectory) "" ;# initialize variable
    ttk::entry $w(bxFR2).entry1_2 -textvariable GS_filePathSetup(labelDirectory) -state disabled

        
    ttk::button $w(bxFR2).button1_2 -text [mc "Browse..."] \
            -command {set GS_filePathSetup(labelDirectory) [eAssist_Global::OpenFile [mc "Set default Save-to Folder"] [pwd] dir]} \
            -state disabled
    
        set GS_filePathSetup(checkToggle) 0
    ttk::checkbutton $w(bxFR2).checkbutton1 -text [mc "Use global path"] -variable GS_filePathSetup(useGlobalPath) \
                                            -state disabled \
                                            -variable GS_filePathSetup(checkToggle) \
                                            -command {eAssistSetup::controlState}
    #command set GS_filePathSetup(labelDirectory) $GS_filePathSetup(lookInDirectory)
    #eAssistSetup::controlState $GS_filePathSetup(useGlobalPath) $w(bxFR2).entry1_2 $w(bxFR2).button1_2
        

       
    
    ttk::label $w(bxFR2).txt3_1 -text [mc "Number of Fields"]
    ttk::entry $w(bxFR2).entry3_2 -textvariable GS_label(numberOfFields) -state disabled
    
    ttk::button $w(bxFR2).cncl_2 -text [mc "Cancel"] -command {eAssistSetup::cancelBoxLabel} -state disabled
    ttk::button $w(bxFR2).add_1 -text [mc "Add"] -command {eAssistSetup::addBoxLabel}
    ttk::button $w(bxFR2).ok_1 -text [mc "Change"] -command {eAssistSetup::changeBoxLabel}
    
    #------- GUI Calculations
    #if {$GS_filePathSetup(useGlobalPath) == 1} {
    #    focus $w(bxFR2).entry2_2
    #} else {
    #    focus $w(bxFR2).entry1_2
    #}

    #---- Snippets of GUI Code
    #if {[info exists GS_filePathSetup(lookInDirectory)] == 1 && $GS_filePathSetup(lookInDirectory) ne "" } {
    #    # Lets make sure that we have a default setup, before we enable this option.
    #    $w(bxFR2).checkbutton1 configure -state enable
    #    $w(bxFR2).checkbutton1 invoke
    #}
    
    #------------- Grid Frame2
    
    grid $w(bxFR2).txt0_1 -column 0 -row 0 -padx 2p -pady 2p -sticky nse
    grid $w(bxFR2).cbox1_4 -column 1 -row 0 -padx 2p -pady 2p -sticky news
    grid $w(bxFR2).del_1 -column 2 -row 0 -padx 2p -pady 2p -sticky news
    
    grid $w(bxFR2).txt1_1 -column 0 -row 1 -padx 2p -pady 2p -sticky nse
    grid $w(bxFR2).entry1_2 -column 1 -columnspan 2 -row 1 -padx 2p -pady 2p -sticky news
        
    grid $w(bxFR2).button1_2 -column 3 -row 1 -padx 2p -pady 2p -sticky ew
    grid $w(bxFR2).checkbutton1 -column 1 -row 2 -sticky nsw
    
    grid $w(bxFR2).txt3_1 -column 0 -row 5 -padx 2p -pady 2p -sticky nse
    grid $w(bxFR2).entry3_2 -column 1 -row 5 -padx 2p -pady 2p -sticky news
    
    grid $w(bxFR2).cncl_2 -column 1 -row 6 -padx 2p -pady 2p -sticky nse
    grid $w(bxFR2).add_1 -column 2 -row 6 -padx 2p -pady 2p -sticky nse
    grid $w(bxFR2).ok_1 -column 3 -row 6 -padx 2p -pady 2p -sticky nse
    
    
    
    #grid columnconfigure $w(bxFR2) 1 -weight 1
    #------------- Tooltips
    tooltip::tooltip $w(bxFR2).entry3_2 [mc "Total number of fields in the label, not including the Qty field."]
    
    #------------- Bindings
    bind all <<ComboboxSelected>> {
        #eAssistSetup::viewBoxLabel [$w(bxFR2).cbox1_4 current]
        eAssistSetup::viewBoxLabel $boxLabelInfo(currentBoxLabel)
    }
    
    #set frame2 [ttk::labelframe $G_setupFrame.frame2 -text [mc "Define Box Labels Headers"]]
    #pack $frame2 -expand yes -fill both ;#-side top -anchor n -expand yes -fill both -padx 5p -pady 5p -ipady 2p
    #
    #tablelist::tablelist $frame2.listbox -columns {
    #                                                0   "..."       center
    #                                                0   "Field" center
    #                                                0   "Field Name"  center
    #                                                0   "Num of Chars"  center
    #                                                0   "Import Header" center
    #                                                0   "Delimter"
    #                                                } \
    #                                    -showlabels yes \
    #                                    -height 5 \
    #                                    -selectbackground yellow \
    #                                    -selectforeground black \
    #                                    -stripebackground lightblue \
    #                                    -exportselection yes \
    #                                    -showseparators yes \
    #                                    -fullseparators yes \
    #                                    -yscrollcommand [list $frame2.scrolly set] \
    #                                    -editstartcommand {eAssistSetup::startCmdBoxLabels} \
    #                                    -editendcommand {eAssistSetup::endCmdBoxLabels}
    #
    #    $frame2.listbox columnconfigure 0 -name "count" \
    #                                        -showlinenumbers 1
    #
    #    $frame2.listbox columnconfigure 1 -name "field" \
    #                                        -editable yes \
    #                                        -editwindow ttk::combobox
    #    $frame2.listbox columnconfigure 2 -name "fieldName" \
    #                                        -editable yes \
    #                                        -editwindow ttk::entry
    #    $frame2.listbox columnconfigure 3 -name "numOfChars" \
    #                                        -editable yes \
    #                                        -editwindow ttk::entry
    #    $frame2.listbox columnconfigure 4 -name "importHeader" \
    #                                        -editable yes \
    #                                        -editwindow ttk::entry
    #    $frame2.listbox columnconfigure 5 -name "delimter" \
    #                                        -editable yes \
    #                                        -editwindow ttk::entry
    #    
    #set internal(table2,currentRow) 0
    #    
    #    if {[info exists setup(boxLabelConfig)]} {
    #        #'debug Populate listobx - data exists
    #            foreach boxlabel $setup(boxLabelConfig) {
    #                #'debug inserting $customer
    #                $frame2.listbox insert end $boxlabel
    #                incr internal(table2,currentRow)
    #            }
    #    }
    #
    ## Create the first line
    #$frame2.listbox insert end ""
    #
    #
    #ttk::scrollbar $frame2.scrolly -orient v -command [list $frame2.listbox yview]
    #
    #grid $frame2.listbox -column 0 -row 0 -sticky news
    #grid columnconfigure $frame2 $frame2.listbox -weight 1
    #
    #grid $frame2.scrolly -column 1 -row 0 -sticky nse
    #
    #::autoscroll::autoscroll $frame2.scrolly ;# Enable the 'autoscrollbar'
    
    
} ;# eAssistSetup::boxLabels_GUI


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
    global G_setupFrame GS_program company internal setup
    
    #set currentModule company
    eAssist_Global::resetSetupFrames ;# Reset all frames so we start clean
    
    set frame1 [ttk::labelframe $G_setupFrame.frame1 -text [mc "Company Information"]]
    pack $frame1 -expand yes -fill both
    
    ttk::label $frame1.companyText -text [mc "Company Name"]
    ttk::entry $frame1.companyEntry -textvariable company(company)
    
    ttk::label $frame1.contactText -text [mc "Contact"]
    ttk::entry $frame1.contactEntry -textvariable company(contact)
    
    ttk::label $frame1.addr1Text -text [mc "Addr1/Addr2"]
    ttk::entry $frame1.addr1Entry -textvariable company(address1)
    set company(addr2) ""
    ttk::entry $frame1.addr2Entry -textvariable company(address2)
    
    set company(addr3) ""
    ttk::label $frame1.addr3Text -text [mc "Address 3"]
    ttk::entry $frame1.addr3Entry -textvariable company(address3)
    
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
  
} ;# eAssistSetup::company_GUI



