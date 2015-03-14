# Creator: Casey Ackels
# Initial Date: April 8th, 2011
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 220 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2012-01-01 19:45:20 -0800 (Sun, 01 Jan 2012) $
#
########################################################################################

##
## - Overview
# This file holds the parent GUI frame, buttons and menu for Distribution Helper

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

## Coding Conventions
# - Namespaces:

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

namespace eval Disthelper_Preferences {}

proc Disthelper_Preferences::prefGUI {} {
    #****f* prefGUI/Disthelper_Preferences
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #
    #
    # SYNOPSIS
    #	GUI for the preferences window
    #
    # CHILDREN
    #	Disthelper_Preferences::chooseDir, Disthelper_Preferences::saveConfig
    #
    # PARENTS
    #
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global settings tab3 header header_sorted

    toplevel .preferences
    wm transient .preferences .
    wm title .preferences [mc "Preferences"]

    # Put the window in the center of the parent window
    set locX [expr {[winfo width . ] / 3 + [winfo x .]}]
    set locY [expr {[winfo height . ] / 3 + [winfo y .]}]
    wm geometry .preferences +${locX}+${locY}

    focus .preferences

    set header_sorted [lsort -dictionary [array names header]]

    ##
    ## Parent Frame
    ##
    set frame0 [ttk::frame .preferences.frame0]
    pack $frame0 -expand yes -fill both -pady 5p -padx 5p

    ##
    ## Notebook
    ##
    set nb [ttk::notebook $frame0.nb]
    pack $nb -expand yes -fill both


    $nb add [ttk::frame $nb.f1] -text [mc "File Paths"]
    $nb add [ttk::frame $nb.f2] -text [mc "Miscellaneous"]
    $nb add [ttk::frame $nb.f3] -text [mc "Header Names"]
    $nb select $nb.f1

    ttk::notebook::enableTraversal $nb

    ##
    ## Tab 1 (File Paths)
    ##

    ttk::label $nb.f1.sourceText -text [mc "Source Import Files"]
    ttk::entry $nb.f1.sourceEntry -textvariable settings(sourceFiles)
    ttk::button $nb.f1.sourceButton -text ... -command {Disthelper_Preferences::chooseDir sourceFiles}

    ttk::label $nb.f1.outFilesText -text [mc "Formatted Import Files"]
    ttk::entry $nb.f1.outFilesEntry -textvariable settings(outFilePath)
    ttk::button $nb.f1.outFilesButton -text ... -command {Disthelper_Preferences::chooseDir outFilePath}

    ttk::label $nb.f1.outFilesCopyText -text [mc "Archive Files"]
    ttk::entry $nb.f1.outFilesCopyEntry -textvariable settings(outFilePathCopy)
    ttk::button $nb.f1.outFilesCopyButton -text ... -command {Disthelper_Preferences::chooseDir outFilePathCopy}

    grid $nb.f1.sourceText -column 0 -row 0 -sticky e -padx 5p -pady 5p
    grid $nb.f1.sourceEntry -column 1 -row 0 -sticky ew -padx 5p -pady 5p
    grid $nb.f1.sourceButton -column 2 -row 0 -sticky e -padx 5p -pady 5p

    grid $nb.f1.outFilesText -column 0 -row 1 -sticky e -padx 5p -pady 5p
    grid $nb.f1.outFilesEntry -column 1 -row 1 -sticky ew -padx 5p -pady 5p
    grid $nb.f1.outFilesButton -column 2 -row 1 -sticky e -padx 5p -pady 5p

    grid $nb.f1.outFilesCopyText -column 0 -row 2 -sticky e -padx 5p -pady 5p
    grid $nb.f1.outFilesCopyEntry -column 1 -row 2 -sticky ew -padx 5p -pady 5p
    grid $nb.f1.outFilesCopyButton -column 2 -row 2 -sticky e -padx 5p -pady 5p

    grid columnconfigure $nb.f1 1 -weight 2


    ##
    ## Tab 2 (Miscellaneous)
    ##

    set tab2a [ttk::labelframe $nb.f2.misc -text [mc "Miscellaneous"]]
    #pack $tab2a -fill both -expand yes -padx 5p -pady 5p
    grid $tab2a -column 0 -row 0 -padx 3p -pady 5p -sticky news

    ttk::label $tab2a.boxTareText -text [mc "Box Tare"]
    ttk::entry $tab2a.boxTareEntry -textvariable settings(BoxTareWeight)

    grid $tab2a.boxTareText -column 0 -row 0 -sticky e -padx 5p -pady 5p
    grid $tab2a.boxTareEntry -column 1 -row 0 -sticky ew -padx 5p -pady 5p

    set tab2b [ttk::labelframe $nb.f2.prepaidship -text [mc "Ship Prepaid Codes"]]
    #pack $tab2b -fill both -expand yes -padx 5p -pady 5p
    grid $tab2b -column 0 -row 1 -padx 5p -pady 5p -sticky news

    ttk::entry $tab2b.ppentry -textvariable ShipPrePaid
    ttk::button $tab2b.ppbtn1 -text [mc "Add"]
    ttk::button $tab2b.ppbtn2 -text [mc "Remove"]

    listbox $tab2b.pplistbox \
                -width 20 \
                -height 10 \
                -selectbackground yellow \
                -selectforeground black \
                -exportselection yes \
                -selectmode single \
                -yscrollcommand [list $tab2b.ppscrolly set] \
                -xscrollcommand [list $tab2b.ppscrollx set]

    ttk::scrollbar $tab2b.ppscrolly -orient v -command [list $tab2b.pplistbox yview]
    ttk::scrollbar $tab2b.ppscrollx -orient h -command [list $tab2b.pplistbox xview]

    grid $tab2b.ppentry -column 0 -row 0
    grid $tab2b.pplistbox -column 0 -row 1
    grid $tab2b.ppbtn1 -column 1 -row 0 -sticky n -pady 5p -padx 5p
    grid $tab2b.ppbtn2 -column 1 -row 1 -sticky n


    set tab2bb [ttk::labelframe $nb.f2.3pShip -text [mc "Ship 3rd party Codes"]]
    #pack $tab2bb -fill both -expand yes -padx 5p -pady 5p
    grid $tab2bb -column 1 -row 1 -padx 5p -pady 5p -sticky news

    ttk::entry $tab2bb.3pentry -textvariable Ship3rdParty
    ttk::button $tab2bb.3pbtn1 -text [mc "Add"]
    ttk::button $tab2bb.3pbtn2 -text [mc "Remove"]

    listbox $tab2bb.3plistbox \
                -width 20 \
                -height 10 \
                -selectbackground yellow \
                -selectforeground black \
                -exportselection yes \
                -selectmode single \
                -yscrollcommand [list $tab2bb.3pscrolly set] \
                -xscrollcommand [list $tab2bb.3pscrollx set]

    ttk::scrollbar $tab2bb.3pscrolly -orient v -command [list $tab2bb.3plistbox yview]
    ttk::scrollbar $tab2bb.3pscrollx -orient h -command [list $tab2bb.3plistbox xview]

    grid $tab2bb.3pentry -column 2 -row 0
    grid $tab2bb.3plistbox -column 2 -row 1
    grid $tab2bb.3pbtn1 -column 3 -row 0 -sticky n -pady 5p -padx 5p
    grid $tab2bb.3pbtn2 -column 3 -row 1 -sticky n

    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $tab2b.ppscrolly
    ::autoscroll::autoscroll $tab2b.ppscrollx

    ::autoscroll::autoscroll $tab2bb.3pscrolly
    ::autoscroll::autoscroll $tab2bb.3pscrollx


    ##
    ## Tab 3 (Header Names)
    ##

    set tab3 [ttk::labelframe $nb.f3.importOrder -text [mc "Header Names"]]
    grid $tab3 -column 0 -row 0 -padx 5p -pady 5p

    ttk::combobox $tab3.combo -width 20 \
                            -values $header_sorted \
                            -state readonly \
                            -textvariable parentHeader

    # Start out with displaying a header
    $tab3.combo set [lrange $header_sorted 0 0]

    ttk::entry $tab3.entry -textvariable subHeader
    ttk::button $tab3.add -text [mc "Add"] -command {catch {Disthelper_Preferences::addSubHeader $parentHeader $subHeader}}

    listbox $tab3.listbox \
                -width 18 \
                -height 10 \
                -selectbackground yellow \
                -selectforeground black \
                -exportselection yes \
                -selectmode single \
                -yscrollcommand [list $tab3.scrolly set] \
                -xscrollcommand [list $tab3.scrollx set]

    ttk::scrollbar $tab3.scrolly -orient v -command [list $tab3.listbox yview]
    ttk::scrollbar $tab3.scrollx -orient h -command [list $tab3.listbox xview]

    # Put the default values in
    Disthelper_Preferences::displayHeader [$tab3.combo current]

    ttk::button $tab3.del -text [mc "Remove"] -command  {Disthelper_Preferences::removeSubHeader $parentHeader}

    grid $tab3.combo -column 0 -row 0 -sticky news -padx 3p -pady 3p

    grid $tab3.entry -column 0 -row 1 -sticky news -padx 3p -pady 3p
    grid $tab3.add -column 1 -row 1 -sticky news -padx 2p -pady 3p

    grid $tab3.listbox -column 0 -row 2 -rowspan 8 -padx 3p -pady 3p -sticky news ;#-padx 5p -pady 5p
    grid $tab3.scrolly -column 0 -row 2 -rowspan 8 -sticky nse
    grid $tab3.scrollx -column 0 -row 2 -rowspan 8 -sticky sew

    grid $tab3.del -column 1 -row 2 -sticky new -padx 2p -pady 3p

    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $tab3.scrolly
    ::autoscroll::autoscroll $tab3.scrollx


    ##
    ## Button Bar
    ##

    set buttonbar [ttk::frame .preferences.buttonbar]
    ttk::button $buttonbar.ok -text [mc "Save & Close"] -command { Disthelper_Preferences::saveConfig; destroy .preferences }
    ttk::button $buttonbar.close -text [mc "Discard Changes"] -command { destroy .preferences }

    grid $buttonbar.ok -column 0 -row 3 -sticky nse -padx 8p -ipadx 4p
    grid $buttonbar.close -column 1 -row 3 -sticky nse -ipadx 4p
    pack $buttonbar -side bottom -anchor e -pady 8p -padx 5p

##
## - Bindings
##

bind all <<ComboboxSelected>> {
    #'debug ComboBox - [$tab3.combo current]
    Disthelper_Preferences::displayHeader [$tab3.combo current]
}

} ;# end Disthelper_Preferences::prefGUI


proc Disthelper_Preferences::displayHeader {args} {
    #****f* displayHeader/Disthelper_Preferences
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Called with the indice of the value of the combobox; and returns the associated array with values, of that array variable.
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	Disthelper_Preferences::prefGUI
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global header header_sorted tab3

    # Names listed in the header array, that matches what was selected in the combobox.
    set headerCategory [lindex $header_sorted $args]

    $tab3.listbox delete 0 end

    foreach headerName $header($headerCategory) {
        $tab3.listbox insert end [string totitle $headerName]
    }

} ;# End Disthelper_Preferences::displayHeader


proc Disthelper_Preferences::addSubHeader {parentHeader subHeader} {
    #****f* addSubHeader/Disthelper_Preferences
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Pass the parentHeader name and the new subHeader.
    #
    # SYNOPSIS
    #	Allows the user to add a new subHeader to the list with the parentHeader
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	Disthelper_Preferences::prefGUI
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global tab3 header
    'debug addSubHeader

    #if {![info exists parentHeader]} {return}
    #if {![info exists subHeader]} {return}

    #$tab3.listbox delete 0 end

    #foreach headerName $header($parentHeader) {
    #    $tab3.listbox insert end $headerName
    #}

    # Cycle through all header arrays to check for duplicates
    #  We must allow only one instance of a word for all SubHeaders
    foreach name [array names header] {
        if {[lsearch $header($name) $subHeader] != -1} {
            'debug Found duplicate in $name
            Error_Message::errorMsg header1 $name
            return
        }
    }

    # Now add the new subheader
    $tab3.listbox insert end [string totitle $subHeader]

    set header($parentHeader) [$tab3.listbox get 0 end]
} ;# End Disthelper_Preferences::addSubHeader



proc Disthelper_Preferences::removeSubHeader {parentHeader} {
    #****f* removeSubheader/Disthelper_Preferences
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Supply the parentHeader name (from the textvariable)
    #	removeSubHeader $parentHeader
    #
    # SYNOPSIS
    #	Removes the selected SubHeader and updates the list of values for that particular parentHeader variable
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	Disthelper_Preferences::prefGUI
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global tab3 header
    if {[$tab3.listbox curselection] == "" } {return}

    $tab3.listbox delete [$tab3.listbox curselection]

    # Set the new list of values to the array variable.
    set header($parentHeader) [$tab3.listbox get 0 end]
} ;# end Disthelper_Preferences::removeSubHeader


proc Disthelper_Preferences::chooseDir {target} {
    #****f* chooseDir/Disthelper_Preferences
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	Disthelper_Preferences::prefGUI
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global settings


    set settingsTMP($target) [tk_chooseDirectory \
        -parent .preferences \
        -title [mc "Choose a Directory"] \
	-initialdir $settings($target)
    ]

    'debug "(folderName) $settingsTMP($target)"

    # If we do not select a file name, and cancel out of the dialog, do not produce an error.
    # The usage of settingsTMP prevents us from over writing our original value; which we may want to keep if the user does not select a directory.
    if {$settings($target) eq ""} {
        'debug "No directory was selected"
        return
        } else {
            set settings($target) $settingsTMP($target)
        }

} ;# end Disthelper_Preferences::chooseDir


proc Disthelper_Preferences::saveConfig {} {
    #****f* saveConfig/Disthelper_Preferences
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	saveConfig
    #
    # SYNOPSIS
    #	Write settings to config.txt file.
    #
    # CHILDREN
    #	N/A
    #
    # PARENTS
    #	'distHelper_loadSettings, Disthelper_Preferences::prefGUI
    #
    # NOTES
    #
    # SEE ALSO
    #
    #***
    global settings header

    # We should use the path set in $settings(Home), instead of hard coding
    set fd [open config.txt w]

    foreach value [array names settings] {
            puts $fd "settings($value) $settings($value)"
    }

    foreach value [array names header] {
            puts $fd "header($value) $header($value)"
    }

    chan close $fd
}
