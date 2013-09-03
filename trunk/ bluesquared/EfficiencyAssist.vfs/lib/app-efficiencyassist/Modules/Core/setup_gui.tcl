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


proc eAssistSetup::createRows {win fields} {
    $win delete 0 end
    
    for {set x 0} {$x<$fields} {incr x} {
        $win insert end ""
    }
}


proc eAssistSetup::selectionChanged {tbl} { 
     set rowList [$tbl curselection] 
     if {[llength $rowList] == 0} { 
         return 
     } 

     set row [lindex $rowList 0] 
     puts "The currently selected row is $row." 
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
    #	N/A
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
    

    set tbl [ttk::frame .container.tree]
    pack $tbl -fill both -side left -anchor nw -padx 5p -pady 5p -ipady 2p

    
    tablelist::tablelist $tbl.t -columns {0 ""} \
                                -background white \
                                -exportselection yes
    
    pack $tbl.t -fill both -expand yes
    
    set data {BoxLabels}
    $tbl.t insertchildlist root end $data
    $tbl.t collapse 0
    
    set childlist1 [list {Paths} {Labels} {Delimiters} {Headers} {ShipMethod} {Misc.}]
    $tbl.t insertchildlist 0 end $childlist1
    
    set data2 "BatchAddresses"
    $tbl.t insertchildlist root end $data2
    $tbl.t collapse 0
    
    set childlist2 [list {row2} {row2} {another2}]
    $tbl.t insertchildlist 0 end $childlist2
   
    $tbl.t selection set 0
    $tbl.t activate 0
    
    ##
    ## Main Frame
    ##
    
    #eAssist_Global::resetFrames selectFilePaths_GUI
    #eAssist_Global::resetFrames
    boxLabels_GUI
    


   

    ##
    ## Bindings
    ##
    #bind [$tbl.t bodytag] <Button-1> {
    #    #$frame2b.listbox delete [$frame2b.listbox curselection]
    #    set win [$tbl.t get [$tbl.t curselection]]
    #    puts $win
    #}
    bind $tbl.t <<TablelistSelect>> {eAssistSetup::selectionChanged %W} 



}

proc eAssistSetup::selectFilePaths_GUI {} {
    # Default settings, but can be overridden at the user settings level.
    
    set frame1 [ttk::labelframe .container.frame1 -text [mc "Default File Paths"]]
    pack $frame1 -side top -anchor n -expand yes -fill both -padx 5p -pady 5p -ipady 2p
    
    ttk::label $frame1.txt1 -text [mc "Bartender"]
    ttk::entry $frame1.entry1 -textvariable GS_filePaths(bartenderEXE)
    ttk::button $frame1.button1 -text [mc "Browse..."] -command {}
    
    ttk::label $frame1.txt2 -text [mc "Look in Directory"]
    ttk::entry $frame1.entry2 -textvariable GS_filePaths(lookInDirectory)
    ttk::button $frame1.button2 -text [mc "Browse..."] -command {}
    
    ttk::label $frame1.txt3 -text [mc "Save to Directory"]
    ttk::entry $frame1.entry3 -textvariable GS_filePaths(saveInDirectory)
    ttk::button $frame1.button3 -text [mc "Browse..."] -command {}
    
    #------------------------------
    
    grid $frame1.txt1 -column 0 -row 0 -padx 2p -pady 2p -sticky nse
    grid $frame1.entry1 -column 1 -row 0 -padx 2p -pady 2p -sticky news
    grid $frame1.button1 -column 2 -row 0 -padx 2p -pady 2p -sticky news
    
    grid $frame1.txt2 -column 0 -row 1 -padx 2p -pady 2p -sticky nse
    grid $frame1.entry2 -column 1 -row 1 -padx 2p -pady 2p -sticky news
    grid $frame1.button2 -column 2 -row 1 -padx 2p -pady 2p -sticky news
    
    grid $frame1.txt3 -column 0 -row 2 -padx 2p -pady 2p -sticky nse
    grid $frame1.entry3 -column 1 -row 2 -padx 2p -pady 2p -sticky news
    grid $frame1.button3 -column 2 -row 2 -padx 2p -pady 2p -sticky news
    
    #grid configure $frame1.jobNameEntry -columnspan 2
    grid columnconfigure $frame1 1 -weight 1 
}

proc eAssistSetup::boxLabels_GUI {} {
    
    set frame1 [ttk::labelframe .container.frame1 -text [mc "Define Box Labels"]]
    pack $frame1 -side top -anchor n -expand yes -fill both -padx 5p -pady 5p -ipady 2p
    
    ttk::label $frame1.txt -text [mc "Select Label"]
    ttk::combobox $frame1.cbox
    
    ttk::label $frame1.txt1 -text [mc "Label Directory"]
    ttk::entry $frame1.entry1 -textvariable GS_filePaths(labelDirectory)
    ttk::button $frame1.button1 -text [mc "Browse..."] -command {}
    
    ttk::label $frame1.txt2 -text [mc "Label Name"]
    ttk::entry $frame1.entry2 -textvariable GS_label(name)
    
    ttk::label $frame1.txt3 -text [mc "Key Words"]
    ttk::entry $frame1.entry3 -textvariable GS_label(keywords)
    
    ttk::label $frame1.txt4 -text [mc "Number of Fields"]
    spinbox $frame1.spin -from 1 -to 20 -increment 1 -textvariable GS_label(numberOfFields) -command {createRows .container.frame2.listbox $GS_label(numberOfFields)} ;#-width 2 -font 10 -justify center -textvariable GS_label(numberOfFields)
    
    #------------------------------
    
    grid $frame1.txt -column 0 -row 0 -sticky nse
    grid $frame1.cbox -column 1 -row 0 -sticky news
    
    grid $frame1.txt1 -column 0 -row 1 -padx 2p -pady 2p -sticky nse
    grid $frame1.entry1 -column 1 -row 1 -padx 2p -pady 2p -sticky news
    grid $frame1.button1 -column 2 -row 1 -padx 2p -pady 2p -sticky news
    
    grid $frame1.txt2 -column 0 -row 2 -padx 2p -pady 2p -sticky nse
    grid $frame1.entry2 -column 1 -row 2 -padx 2p -pady 2p -sticky news
    
    grid $frame1.txt3 -column 0 -row 3 -padx 2p -pady 2p -sticky nse
    grid $frame1.entry3 -column 1 -row 3 -padx 2p -pady 2p -sticky news
    
    grid $frame1.txt4 -column 0 -row 4 -padx 2p -pady 2p -sticky nse
    grid $frame1.spin -column 1 -row 4 -padx 2p -pady 2p -sticky news
    
   #------------------------------
    
    set frame2 [ttk::labelframe .container.frame2 -text [mc "Define Box Labels Headers"]]
    pack $frame2 -side top -anchor n -expand yes -fill both -padx 5p -pady 5p -ipady 2p
    
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
                                        -yscrollcommand [list $frame2.scrolly set]

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


    ttk::scrollbar $frame2.scrolly -orient v -command [list $frame2.listbox yview]

    grid $frame2.listbox -column 0 -row 0 -sticky news
    grid columnconfigure $frame2 $frame2.listbox -weight 1

    grid $frame2.scrolly -column 1 -row 0 -sticky nse

    ::autoscroll::autoscroll $frame2.scrolly ;# Enable the 'autoscrollbar'
    
}
