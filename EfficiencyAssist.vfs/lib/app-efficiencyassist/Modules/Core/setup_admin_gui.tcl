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
# Admin namespaces
# ea::code::admin
# ea::gui::admin
# ea::db::admin


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
    global log G_setupFrame program admin widSec widTmp sec

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
    $nbk add [ttk::frame $nbk.sec] -text [mc "Security"]
    
    $nbk select $nbk.schema

    
    ## **********************
    ## Tab 1 (Schema Change Import)
    ##
    
    # Tab 1, Frame 1
    set f1 [ttk::frame $nbk.schema.f1 -padding 10]
    pack $f1 -expand yes -fill both
    
    ttk::label $f1.txt1 -text [mc "File"]
    ttk::entry $f1.entry1 -textvariable admin(sqlFile)
    ttk::button $f1.btn1 -text [mc ....] -command {set admin(sqlFile) [eAssist_Global::OpenFile [mc "Find SQL File"] $program(Home) file -ext .sql -filetype {{SQL File} {.sql}}]}
    
    grid $f1.txt1 -column 0 -row 0 -sticky nsw
    grid $f1.entry1 -column 1 -row 0 -sticky ew
    grid $f1.btn1 -column 2 -row 0 -sticky ew
    
    grid columnconfigure $f1 1 -weight 2
    
    ## **********************
    ## Tab 2 (Security Setup)
    ##  Subtabs: Groups, Permissions
    ##
    
    # Tab 2, Frame 1
    set t2f1 [ttk::frame $nbk.sec.f1 -padding 10]
    pack $t2f1 -expand yes -fill both
    
    ## Tab 1 (subtab of Tab2)
    set nb [ttk::notebook $t2f1.security]
    pack $nb -expand yes -fill both
    
    ttk::notebook::enableTraversal $nb
    
    #
    # Setup the notebook
    #
    $nb add [ttk::frame $nb.groups] -text [mc "Groups"]
    $nb add [ttk::frame $nb.users] -text [mc "Users"]
    $nb add [ttk::frame $nb.permissions] -text [mc "Permissions"]
    
    $nb select $nb.groups
    
    # --- Groups
    # Tab 2, Subtab 1, Frame 1
    set f1 [ttk::frame $nb.groups.f1 -padding 10]
    set widTmp(sec,group_f1) $f1
    pack $f1 -fill x

    # --- Groups
    # Tab 2, Subtab 1, Frame 2
    set f2 [ttk::frame $nb.groups.f2 -padding 10]
    set widTmp(sec,group_f2) $f2
    pack $f2 -expand yes -fill both
    
    ## --- Users
    # Tab 2, Subtab 2, Frame 1
    set widTmp(sec,users_f1) [ttk::frame $nb.users.f1 -padding 10]
    pack $widTmp(sec,users_f1) -fill x
    
    ## --- Users
    # Tab 2, Subtab 2, Frame 2
    set widTmp(sec,users_f2) [ttk::frame $nb.users.f2 -padding 10]
    pack $widTmp(sec,users_f2) -expand yes -fill both
    
    ## --- Permissions
    # Tab 2, Subtab 3, Frame 1
    set widTmp(sec,perm_f1) [ttk::frame $nb.permissions.f1 -padding 10]
    pack $widTmp(sec,perm_f1) -fill x
    
    ## --- Permissions
    # Tab 2, Subtab 3, Frame 2
    set widTmp(sec,perm_f2) [ttk::frame $nb.permissions.f2 -padding 10]
    pack $widTmp(sec,perm_f2) -expand yes -fill both
    
    # **********
    
    # --- Groups
    # Tab 2, Subtab 1, Frame 1
    grid [ttk::label $f1.txt0 -text [mc "Group Name"]] -column 0 -row 0 -padx 2p -pady 2p
    grid [ttk::entry $f1.entry0 -textvariable widSec(group,Name)] -column 1 -row 0 -padx 2p -pady 2p
    grid [ttk::checkbutton $f1.ckbtn0 -text [mc "Active"] -variable widSec(group,Active)] -column 2 -row 0 -padx 2p -pady 2p
    grid [ttk::button $f1.btn0 -text [mc "Add"] -command {ea::db::insertSecGroup add $widTmp(sec,group_f2).listbox; ea::db::populateSecGroupSingleEntry $widTmp(sec,group_f2),listbox}] -column 3 -row 0 -padx 2p -pady 2p
    
    # --- Groups
    # Tab 2, Subtab 1, Frame 2 (Groups)
    grid [tablelist::tablelist $f2.listbox -columns {
                                        0 "..." center
                                        0 "Database ID" center
                                        0 "Group" center
                                        0 "Active" center } \
                                        -showlabels yes \
                                        -stripebackground lightblue \
                                        -exportselection yes \
                                        -showseparators yes \
                                        -fullseparators yes \
                                        -editselectedonly 1 \
                                        -yscrollcommand [list $f2.scrolly set] \
                                        -xscrollcommand [list $f2.scrollx set]
                                        ] -sticky news -column 0 -row 0
    
    $f2.listbox columnconfigure 0 -name wid_id \
                                            -showlinenumbers 1 \
                                            -labelalign center
    $f2.listbox columnconfigure 1 -name db_id
    $f2.listbox columnconfigure 2 -stretch yes
    
    grid [ttk::scrollbar $f2.scrolly -orient v -command [list $f2.listbox yview]] -column 1 -row 0 -sticky nse
    grid [ttk::scrollbar $f2.scrollx -orient h -command [list $f2.listbox xview]] -column 0 -row 1 -sticky ews
    
    grid columnconfigure $f2 $f2.listbox -weight 2
    grid rowconfigure $f2 $f2.listbox -weight 2
    
    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $f2.scrolly
    ::autoscroll::autoscroll $f2.scrollx

    # Populate the widget
    eAssistSetup::readSecGroup $f2.listbox
    
    ## Binding
    set widTmp(sec,group_wid_entry) $f2.listbox
    set widTmp(sec,group_wid_btn) $f1.btn0
    
	bind [$f2.listbox bodytag] <Double-1> {
        set widTmp(sec,group_dbid) [lindex [$widTmp(sec,group_wid_entry) get [$widTmp(sec,group_wid_entry) curselection]] 1]
        eAssistSetup::populateSecGroupEdit $widTmp(sec,group_dbid)

        #${log}::debug Updating, change button text to 'update'
        $widTmp(sec,group_wid_btn) configure -text [mc "Update"] -command {
                ea::db::insertSecGroup update $widTmp(sec,group_f2).listbox $widTmp(sec,group_dbid)
                ea::db::populateSecGroupSingleEntry $widTmp(sec,group_f2).listbox [$widTmp(sec,group_f2).listbox curselection] $widTmp(sec,group_dbid) 
        }
    
    }
    
    # Users, Frame 1
    grid [ttk::label $widTmp(sec,users_f1).txt0 -text [mc "User Name"]] -column 0 -row 0 -padx 2p -pady 2p -sticky e
    grid [ttk::entry $widTmp(sec,users_f1).entry0 -textvariable widSec(users,UserName) -width 35] -column 1 -row 0 -padx 2p -pady 2p ;#-sticky ew
    grid [ttk::button $widTmp(sec,users_f1).btn0 -text [mc "Add"] -command {eAssistSetup::writeSecUsers -insert $widTmp(sec,users_f2).listbox [$widTmp(sec,users_f2).listbox curselection] \
                                                                                $widSec(users,UserName) $widSec(users,UserLogin) $widSec(users,UserPwd) $widSec(users,UserEmail) \
                                                                                $widSec(users,User_Status)}] -column 2 -row 0 -padx 2p -pady 2p ;#-sticky ew
    
    grid [ttk::label $widTmp(sec,users_f1).txt1 -text [mc "User Login"]] -column 0 -row 1 -padx 2p -pady 2p -sticky e
    grid [ttk::entry $widTmp(sec,users_f1).entry1 -textvariable widSec(users,UserLogin) -width 35] -column 1 -row 1 -padx 2p -pady 2p ;#-sticky ew
    grid [ttk::button $widTmp(sec,users_f1).btn1 -text [mc "Clear"]] -column 2 -row 1 -padx 2p -pady 2p ;#-sticky ew
    
    grid [ttk::label $widTmp(sec,users_f1).txt2 -text [mc "Email"]] -column 0 -row 2 -padx 2p -pady 2p -sticky e
    grid [ttk::entry $widTmp(sec,users_f1).entry2 -textvariable widSec(users,UserEmail) -width 35] -column 1 -row 2 -padx 2p -pady 2p ;#-sticky ew
    
    grid [ttk::label $widTmp(sec,users_f1).txt3 -text [mc "Password"]] -column 0 -row 3 -padx 2p -pady 2p -sticky e
    grid [ttk::entry $widTmp(sec,users_f1).entry3 -textvariable widSec(users,UserPwd) -show *] -column 1 -row 3 -padx 2p -pady 2p -sticky ew
    
    grid [ttk::label $widTmp(sec,users_f1).txt4 -text [mc "Group"]] -column 0 -row 4 -padx 2p -pady 2p -sticky e
    grid [ttk::combobox $widTmp(sec,users_f1).cbox4 -textvariable widSec(users,Group) \
                                                    -postcommand {$widTmp(sec,users_f1).cbox4 configure -values [ea::db::getGroups -name -active]} \
                                                    -state readonly] -column 1 -row 4 -padx 2p -pady 2p -sticky ew
    
    grid [ttk::checkbutton $widTmp(sec,users_f1).ckbtn0 -text [mc "Active"] -variable widSec(users,User_Status)] -column 1 -row 6 -sticky w

    # --- Users, Frame 2
    # Tab 2, Subtab 2, Frame 2
    grid [tablelist::tablelist $widTmp(sec,users_f2).listbox -columns {
                                        0 "..." center
                                        0 "Database ID" center
                                        0 "Group" center
                                        0 "Login" center
                                        0 "User Name" center
                                        0 "Email" center
                                        0 "Active" center } \
                                        -showlabels yes \
                                        -stripebackground lightblue \
                                        -exportselection yes \
                                        -showseparators yes \
                                        -fullseparators yes \
                                        -editselectedonly 1 \
                                        -yscrollcommand [list $widTmp(sec,users_f2).scrolly set] \
                                        -xscrollcommand [list $widTmp(sec,users_f2).scrollx set]
                                        ] -sticky news -column 0 -row 0
    
    $widTmp(sec,users_f2).listbox columnconfigure 0 -name wid_id \
                                                    -showlinenumbers 1 \
                                                    -labelalign center
    $widTmp(sec,users_f2).listbox columnconfigure 1 -name User_ID
    $widTmp(sec,users_f2).listbox columnconfigure 2 -name Group -width 20
    $widTmp(sec,users_f2).listbox columnconfigure 3 -name UserLogin -width 20
    $widTmp(sec,users_f2).listbox columnconfigure 4 -name UserName -width 35
    $widTmp(sec,users_f2).listbox columnconfigure 5 -name UserEmail -stretch yes
    $widTmp(sec,users_f2).listbox columnconfigure 6 -name User_Status
    
    grid [ttk::scrollbar $widTmp(sec,users_f2).scrolly -orient v -command [list $widTmp(sec,users_f2).listbox yview]] -column 1 -row 0 -sticky nse
    grid [ttk::scrollbar $widTmp(sec,users_f2).scrollx -orient h -command [list $widTmp(sec,users_f2).listbox xview]] -column 0 -row 1 -sticky ews
    
    grid columnconfigure $widTmp(sec,users_f2) $widTmp(sec,users_f2).listbox -weight 2
    grid rowconfigure $widTmp(sec,users_f2) $widTmp(sec,users_f2).listbox -weight 2
    
    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $widTmp(sec,users_f2).scrolly
    ::autoscroll::autoscroll $widTmp(sec,users_f2).scrollx
    

    $widTmp(sec,users_f2).listbox delete 0 end
    eAssistSetup::populateSecUsersEdit -populate $widTmp(sec,users_f2).listbox
    
    ## Binding (double-click puts the data into the fields)
    bind [$widTmp(sec,users_f2).listbox bodytag] <Double-1> {
        set widRow [$widTmp(sec,users_f2).listbox curselection]
        # Reconfigure button
        #$widTmp(sec,users_f1).btn0 configure -text [mc "Update"] -command {eAssistSetup::writeSecUsers -update $widTmp(sec,users_f2).listbox $widRow}
        $widTmp(sec,users_f1).btn0 configure -text [mc "Update"] -command {eAssistSetup::writeSecUsers -update $widTmp(sec,users_f2).listbox [$widTmp(sec,users_f2).listbox curselection] \
                                                                                $widSec(users,Group) $widSec(users,UserName) $widSec(users,UserLogin) $widSec(users,UserPwd) \
                                                                                $widSec(users,UserEmail) $widSec(users,User_Status) $widSec(users,User_ID)
                                                                            $widTmp(sec,users_f1).btn0 configure -text [mc "Add"]
                                                                            ea::code::admin::initWidSecArray -clear
                                                                        }
                                                

        set widRow [$widTmp(sec,users_f2).listbox curselection]
        ea::code::admin::initWidSecArray -populate $widRow
    }
    
    ## --- Permissions
    # Tab 2, Subtab 3, Frame 1
    # $sec(UserLogins) $program(moduleNames)
    grid [ttk::label $widTmp(sec,perm_f1).txt0a -text [mc "Group"]] -column 0 -row 0 -pady 2p -padx 2p -sticky e
    grid [ttk::combobox $widTmp(sec,perm_f1).cbox0a -values $sec(groupNames) \
                                                    -postcommand {$widTmp(sec,perm_f1).cbox0a configure -values [ea::db::getGroups -name -active]} \
                                                    -state readonly] -column 1 -row 0 -pady 2p -padx 2p -sticky w
    
    grid [tablelist::tablelist $widTmp(sec,perm_f2).tbl -columns { 0 "..." center \
                                                            20 "Module" center \
                                                            10 "View" center \
                                                            10 "Modify" center \
                                                            10 "Delete" center} \
                                                            -showlabels yes \
                                                            -stripebackground lightblue \
                                                            -exportselection yes \
                                                            -showseparators yes \
                                                            -fullseparators yes \
                                                            -editselectedonly 1 \
                                                            -selecttype cell \
                                                            -editstartcommand ea::code::admin::editStartCmd \
                                                            -editendcommand ea::code::admin::editEndCmd \
                                                            -yscrollcommand [list $widTmp(sec,perm_f2).scrolly set] \
                                                            -xscrollcommand [list $widTmp(sec,perm_f2).scrollx set]] -column 0 -row 0 -sticky news
    
    $widTmp(sec,perm_f2).tbl columnconfigure 0 -name db_id -showlinenumbers 1
    $widTmp(sec,perm_f2).tbl columnconfigure 1 -name module
    $widTmp(sec,perm_f2).tbl columnconfigure 2 -name SecAccess_Read ;#view -editable yes -editwindow ttk::combobox
    $widTmp(sec,perm_f2).tbl columnconfigure 3 -name SecAccess_Write ;# modify -editable yes -editwindow ttk::combobox
    $widTmp(sec,perm_f2).tbl columnconfigure 4 -name SecAccess_Delete ;# delete -editable yes -editwindow ttk::combobox
    
    grid [ttk::scrollbar $widTmp(sec,perm_f2).scrolly -orient v -command [list $widTmp(sec,perm_f2).tbl yview]] -column 1 -row 0 -sticky nse
    grid [ttk::scrollbar $widTmp(sec,perm_f2).scrollx -orient h -command [list $widTmp(sec,perm_f2).tbl xview]] -column 0 -row 1 -sticky ews
    
    grid columnconfigure $widTmp(sec,perm_f2) $widTmp(sec,perm_f2).tbl -weight 2
    grid rowconfigure $widTmp(sec,perm_f2) $widTmp(sec,perm_f2).tbl -weight 2
    
    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $widTmp(sec,perm_f2).scrolly
    ::autoscroll::autoscroll $widTmp(sec,perm_f2).scrollx

    bind $widTmp(sec,perm_f1).cbox0a <<ComboboxSelected>> {
        ea::db::admin::populateModPerms $widTmp(sec,perm_f2).tbl [$widTmp(sec,perm_f1).cbox0a get]
    }

    set bodyTag [$widTmp(sec,perm_f2).tbl bodytag]
    bind $bodyTag <Double-1> {
        ${log}::debug Clicked on column %W %x %y
        set colName [$widTmp(sec,perm_f2).tbl columncget [$widTmp(sec,perm_f2).tbl containingcolumn %x] -name]
        ${log}::debug Column: $colName
        
        # stop if we are not in View, Edit, Delete cells
        if {$colName eq "SecAccess_Read" || $colName eq "SecAccess_Write" || $colName eq "SecAccess_Delete"} {
                set cellLocation [$widTmp(sec,perm_f2).tbl curcellselection]
                ${log}::debug Cell $cellLocation
                
                set rowLocation [$widTmp(sec,perm_f2).tbl curselection]
                ${log}::debug Row $rowLocation
                
                set modName [$widTmp(sec,perm_f2).tbl getcell $rowLocation,1]
                ${log}::debug modName $modName
               
                set cellText [$widTmp(sec,perm_f2).tbl getcells $cellLocation]
                
                if {$cellText eq "Yes"} {set newText "No"} else {set newText "Yes"}
                
                ${log}::debug Cell Text: $cellText
                ${log}::debug Change Text to: $newText [expr {$newText ? "1" : "0"}]
                
                $widTmp(sec,perm_f2).tbl cellconfigure $cellLocation -text $newText
                
                ea::db::admin::updateModPerms $colName [expr {$newText ? "1" : "0"}] $modName [$widTmp(sec,perm_f1).cbox0a get]
        }
    }

} ;# eAssistSetup::admin_GUI

