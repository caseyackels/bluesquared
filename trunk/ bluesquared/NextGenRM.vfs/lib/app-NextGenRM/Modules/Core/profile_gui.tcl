# Initial Date: November 26, 2011]
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

## Coding Conventions
# - Namespaces:

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

proc nextgenrm_GUI::profile {} {
    #****f* profile/nextgenrm_GUI
    # AUTHOR
    #	Picklejuice
    #
    # COPYRIGHT
    #	(c) 2011 - Picklejuice
    #
    # FUNCTION
    #	Create the Profile window
    #
    # SYNOPSIS
    #	N/A
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
    global profile program internal
    
    # Make sure the window has been destroyed before creating.
    if {[winfo exists .profile]} {destroy .profile}
    
##
## Window Manager
##
    
    toplevel .profile
    wm title .profile [mc "Store Profile Editor"]
    wm transient .profile .
    focus -force .profile

    # x = horizontal
    # y = vertical
    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 16 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 6 + [winfo y .]}]

    wm geometry .profile +$locX+$locY
    
    
##
## Container
##

    set container [ttk::frame .profile.container]
    pack $container -expand yes -fill both
    
##
## Frame 1
##
    
    set frame1 [ttk::frame $container.frame1]
    pack $frame1 -expand yes -fill both -pady 5p
    
    
	ttk::label $frame1.profileTxt -text [mc "Profile Name"]
    #-textvariable profile(Store)
    #-values $program(profileList)
    ttk::combobox $frame1.profileEnt -state readonly \
									-postcommand "nextgenrm_Code::showProfiles -comboProfile $frame1.profileEnt $frame1.profileRename $frame1.profileDelete"
    
    ttk::button $frame1.profileNew -image add16x16 -command {nextgenrm_GUI::addListWindow profile .profile}
    ttk::button $frame1.profileRename -image rename16x16 -state disabled -command "'debug Rename Profile; nextgenrm_GUI::renameListWindow profile .profile $frame1.profileEnt"
    ttk::button $frame1.profileDelete -image del16x16 -state disabled -command {'debug Delete Profile}
    

    
    grid $frame1.profileTxt -column 0 -row 0 -padx 3p -pady 2p
    grid $frame1.profileEnt -column 1 -row 0 -padx 2p -pady 2p
    grid $frame1.profileNew -column 2 -row 0 -padx 2p -pady 2p
    grid $frame1.profileRename -column 3 -row 0 -padx 2p -pady 2p
    grid $frame1.profileDelete -column 4 -row 0 -padx 2p -pady 2p
    
    tooltip::tooltip $frame1.profileNew [mc "New"]
    tooltip::tooltip $frame1.profileRename [mc "Rename"]
    tooltip::tooltip $frame1.profileDelete [mc "Delete"]
    
#
# Separator Frame
#
    set sep_frame1 [ttk::frame $container.sep_frame1]
    ttk::separator $sep_frame1.separator -orient horizontal
    
    grid $sep_frame1.separator - -ipadx 1.5i
    pack $sep_frame1 -pady 5p
    
##
## Notebook
##
    set nb [ttk::notebook $container.nb]
    pack $nb -expand yes -fill both -padx 5p -pady 5p
    
    $nb add [ttk::frame $nb.f1] -text [mc "Header"]
    $nb add [ttk::frame $nb.f2] -text [mc "Miscellaneous"]
    $nb select $nb.f1
    
    ttk::notebook::enableTraversal $nb

#    
# Button frame
#
    set button_frame [ttk::frame .profile.button]
    pack $button_frame -side right
    
    #ttk::button $button_frame.ok -text [mc "OK"] -command {nextgenrm_Code::save profile $profile_Store; destroy .profile}
    ttk::button $button_frame.ok -text [mc "OK"] -command "nextgenrm_GUI::endCmdHeader .profile.container.nb.f1.frame1.listbox.listbox {} {} {}; nextgenrm_Code::save profile $profile(Store); destroy .profile"
    ttk::button $button_frame.cancel -text [mc "Cancel"] -command {destroy .profile}
    
    grid $button_frame.ok -column 0 -row 0 -padx 2p -pady 5p
    grid $button_frame.cancel -column 1 -row 0 -padx 5p -pady 5p
  
    
#
# Tab 1 - Header
#
    # Container for tab3
    set tab1 [ttk::frame $nb.f1.frame1]
    pack $tab1 -expand yes -fill both -padx 5p -pady 5p

    
    # container for listbox
    set storeList [ttk::frame $tab1.listbox]
    pack $storeList -expand yes -fill both
    
    
    set scrolly $storeList.scrolly
    tablelist::tablelist $storeList.listbox \
                -columns {
                        0  "Header Text"     
                        10    "Position"  center
                        10    "Size"    center
                        10   "Spacing"   center
                        3   "..."       center} \
                -showlabels yes \
                -stretch 0 \
                -height 10 \
                -selectbackground yellow \
                -selectforeground black \
                -stripebackground lightblue \
                -exportselection yes \
                -showseparators yes \
                -fullseparators yes \
                -editstartcommand nextgenrm_GUI::startCmdHeader \
                -yscrollcommand [list $scrolly set]
        
        $storeList.listbox columnconfigure 0 -name htext \
                                            -editable yes \
                                            -labelalign center \
                                            -editwindow ttk::entry
        
        $storeList.listbox columnconfigure 1 -name position \
                                            -editable yes \
                                            -editwindow ttk::combobox
        
        $storeList.listbox columnconfigure 2 -name size \
                                            -editable yes \
                                            -editwindow ttk::combobox
        
        $storeList.listbox columnconfigure 3 -name spacing \
                                            -editable yes \
                                            -editwindow ttk::combobox
        
        $storeList.listbox columnconfigure 4 -name delete \
                                            -editable no
        
        #$storeList.listbox insert end ""
        
        ttk::scrollbar $scrolly -orient v -command [list $storeList.listbox yview]
        
        grid $storeList.listbox -column 0 -row 0 -sticky news
        grid $scrolly -column 1 -row 0 -sticky ns
    
        # This is needed so the scrollbar displays properly
        grid columnconfigure    $storeList 0 -weight 1
        grid rowconfigure       $storeList 0 -weight 1
        
        ::autoscroll::autoscroll $scrolly ;# Enable the 'autoscrollbar'
        
        $storeList.listbox selection set 0
        $storeList.listbox activate 0
        $storeList.listbox see 0


 # Separator Frame

    set sep_frame2 [ttk::frame $container.sep_frame2]
    ttk::separator $sep_frame2.separator -orient horizontal
    
    grid $sep_frame2.separator - -ipadx 1.5i
    pack $sep_frame2 -pady 2p



#
# Tab 2 - Misc
#

    set tab2 [ttk::frame $nb.f2.frame1]
    pack $tab2 -expand yes -fill both -padx 5p -pady 5p
    
    ttk::label $tab2.printText -text [mc "Body Text Size"]
    ttk::combobox $tab2.printCombo -width 10 \
                                    -values "Large Medium Small" \
                                    -state readonly \
                                    -textvariable profile($profile(Store),bodySize)
    
    grid $tab2.printText -column 0 -row 0 -sticky e -padx 3p -pady 2p
    grid $tab2.printCombo -column 1 -row 0 -sticky news -padx 2p -pady 2p
    
    ttk::label $tab2.dataText -text [mc "Date"]
    ttk::combobox $tab2.dataCombo1 -width 10 \
                                    -values "Top Bottom" \
                                    -state readonly \
                                    -textvariable profile($profile(Store),date_pos1)
    ttk::combobox $tab2.dataCombo2 -width 10 \
                                    -values "Left Center Right" \
                                    -state readonly \
                                    -textvariable profile($profile(Store),date_pos2)
    ttk::combobox $tab2.dataCombo3 -width 10 \
                                    -values "Large Medium Small" \
                                    -state readonly \
                                    -textvariable profile($profile(Store),date_size)
    
    grid $tab2.dataText -column 0 -row 1 -padx 3p -pady 2p -sticky e
    grid $tab2.dataCombo1 -column 1 -row 1 -padx 2p -pady 2p -sticky news
    grid $tab2.dataCombo2 -column 2 -row 1 -padx 2p -pady 2p -sticky news
    grid $tab2.dataCombo3 -column 3 -row 1 -padx 2p -pady 2p -sticky news
    
    ttk::label $tab2.taxFoodTxt -text [mc "Tax (Food)"] 
    ttk::entry $tab2.taxFoodEnt -width 3 -textvariable profile($profile(Store),taxFood)
    ttk::label $tab2.taxFoodPct -text %
    
    grid $tab2.taxFoodTxt -column 0 -row 2 -padx 3p -pady 2p -sticky e
    grid $tab2.taxFoodEnt -column 1 -row 2 -padx 2p -pady 2p -sticky news
    grid $tab2.taxFoodPct -column 2 -row 2 -pady 2p -sticky w
    
    ttk::label $tab2.taxOtherTxt -text [mc "Tax (Other)"]
    ttk::entry $tab2.taxOtherEnt -width 3 -textvariable profile($profile(Store),taxOther)
    ttk::label $tab2.taxOtherPct -text %
    
    grid $tab2.taxOtherTxt -column 0 -row 3 -padx 3p -pady 2p -sticky e
    grid $tab2.taxOtherEnt -column 1 -row 3 -padx 2p -pady 2p -sticky news
    grid $tab2.taxOtherPct -column 2 -row 3 -pady 2p -sticky w

bind .profile.container.frame1.profileEnt <<ComboboxSelected>> {
    # Get the current profile name, so we can load it.
    'debug GetName: [.profile.container.frame1.profileEnt get]
    nextgenrm_Code::openFile [.profile.container.frame1.profileEnt get]
    nextgenrm_Code::displayProfileSettings .profile.container.frame1.profileEnt
}

} ;# End nextgenrm_GUI::profile



    
proc nextgenrm_GUI::startCmdHeader {tbl row col text} { 
    #****f* startCmd/nextgenrm_GUI
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Configuration options when the user enters the listbox
    #
    # SYNOPSIS
    #	N/A
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
    global profile
    
        set w [$tbl editwinpath]
        
        #'debug index: [$w index bottom]
        
        switch -- [$tbl columncget $col -name] {
            htext {
                #$w configure -textvariable profile($profile(Store),$row,htext)
            }
            position {
                    # Populate and make it readonly, and insert another line.
                    $w configure -values {"Left" "Center" "Right"} \
                                -state readonly
                                #-textvariable profile($profile(Store),$row,hpos)

            }
            size {
                # Populate and make it readonly, and insert another line.
                $w configure -values {"Large" "Medium" "Small"} \
                            -state readonly 
                            #-textvariable profile($profile(Store),$row,hsize)
            }
            spacing {
                # Populate and make it readonly, and insert another line.
                $w configure -values {"Single" "Double"} \
                            -state readonly 
                            #-textvariable profile($profile(Store),$row,hspacing)
                
                set myRow [expr {[$tbl index end] - 1}]
                if {$row == 0} {$tbl insert end ""; 'debug Inserting 2nd Row}
                # See tablelist help for using 'end' as an index point.
                if {($row != 0) && ($row == $myRow)} {$tbl insert end ""; 'debug Inserting Row}
                
            }
            default {}
        }
        
        #'debug Text: $text
        return $text
}


proc nextgenrm_GUI::endCmdHeader {tbl row col text} { 
    #****f* endCmd/nextgenrm_GUI
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Configuration options when the user leaves the listbox
    #
    # SYNOPSIS
    #	N/A
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
    global profile
   
    set w [$tbl editwinpath]
    
    switch -- [$tbl columncget $col -name] {
        spacing {puts "Leaving Spacing: $text"}
        default {}
    }
    return $text
    
}