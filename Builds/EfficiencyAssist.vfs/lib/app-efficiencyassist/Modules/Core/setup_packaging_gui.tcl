# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 02 20,2014
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 169 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2014-12-23 12:26:36 -0800 (Tue, 23 Dec 2014) $
#
########################################################################################

##
## - Overview
# Packaging setup, includes: Containers - Something a package goes on (pallets), Cartons - Something that sits inside of a container, or stand alone. (Boxes)

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


proc eAssistSetup::packagingTypes_GUI {} {
    #****f* packagingTypes_GUI/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Setup the Containers and packages (this must exactly duplicate what is in Planner/Foundation)
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
    global log G_setupFrame packagingSetup
    ${log}::debug --START-- [info level 1]
    
    eAssist_Global::resetSetupFrames ;# Reset all frames so we start clean
	
    set frame0 [ttk::label $G_setupFrame.frame0]
    pack $frame0 -expand yes -fill both ;#-pady 5p -padx 5p
    
    
    ##
    ## Frame 1
    ##
    set f1 [ttk::labelframe $frame0.f1 -text [mc "Containers"] -padding 10]
    grid $f1 -column 0 -row 0 -sticky news -padx 5p

    ttk::label $f1.lbl -text [mc "Name"]
    ttk::entry $f1.entry -textvariable packagingSetup(enterContainerType)
    listbox $f1.lbox -width 30 \
    		    -yscrollcommand [list $f1.scrolly set] \
                -xscrollcommand [list $f1.scrollx set]
        
    ttk::scrollbar $f1.scrolly -orient v -command [list $f1.lbox yview]
    ttk::scrollbar $f1.scrollx -orient h -command [list $f1.lbox xview]
    
    
    ## Grid
    grid $f1.lbl -column 0 -row 0 -sticky e
    grid $f1.entry -column 1 -row 0 -sticky news
    grid $f1.lbox -column 1 -row 1 -sticky news
    grid $f1.scrolly -column 2 -row 1 -sticky nse
    grid $f1.scrollx -column 1 -row 2 -sticky ews
    
    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $f1.scrolly
    ::autoscroll::autoscroll $f1.scrollx
    
    # Populate the listbox if we have existing data
    eAssist_db::initContainers containers $f1.lbox
    
    ## Bindings
    # Enter
    ea::tools::bindings $f1.entry {Return KP_Enter} "ea::tools::populateListbox add $f1.entry $f1.lbox Containers Container"
    
    # Delete
    ea::tools::bindings $f1.entry {Delete BackSpace} "ea::tools::populateListbox delete $f1.entry $f1.lbox Containers Container"

    
    ##
    ## Frame 2
    ##
    set f2 [ttk::labelframe $frame0.f2 -text [mc "Packages"] -padding 10]
    grid $f2 -column 1 -row 0 -sticky news -padx 5p
    
    ttk::label $f2.lbl -text [mc "Name"]
    ttk::entry $f2.entry
    listbox $f2.lbox -width 30 \
    		    -yscrollcommand [list $f2.scrolly set] \
                -xscrollcommand [list $f2.scrollx set]
    
    ttk::scrollbar $f2.scrolly -orient v -command [list $f2.lbox yview]
    ttk::scrollbar $f2.scrollx -orient h -command [list $f2.lbox xview]
    
    grid $f2.lbl -column 0 -row 0 -sticky e
    grid $f2.entry -column 1 -row 0 -sticky news
    grid $f2.lbox -column 1 -row 1 -sticky news
    
    grid $f2.scrolly -column 2 -row 1 -sticky nse
    grid $f2.scrollx -column 1 -row 2 -sticky ews
    
    # Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $f2.scrolly
    ::autoscroll::autoscroll $f2.scrollx
    
    # Populate the listbox if we have existing data
    eAssist_db::initContainers packages $f2.lbox
    
    ## Bindings
    # Enter
    ea::tools::bindings $f2.entry {Return KP_Enter} "ea::tools::populateListbox add $f2.entry $f2.lbox Packages Package"
    #bind $f2.entry <Return> "eAssistSetup::addPackagingSetup PACKAGES $f2.entry $f2.lbox"
    # .. So both enter key's work the same way
    #bind $f2.entry <KP_Enter> "eAssistSetup::addPackagingSetup PACKAGES $f2.entry $f2.lbox"
    
    # Delete
    ea::tools::bindings $f2.entry {Delete BackSpace} "ea::tools::populateListbox add $f2.entry $f2.lbox Packages Package"
    #bind $f2.lbox <Delete> "eAssistSetup::delPackagingSetup PACKAGES $f2.lbox"
    #bind $f2.lbox <BackSpace> "eAssistSetup::delPackagingSetup PACKAGES $f2.lbox"
    
    

    #if {[info exists packagingSetup(PackageType)] == 1} {
    #    foreach item $packagingSetup(PackageType) {
    #        $f2.lbox insert end $item
    #    }
    #}
    #set pkg [eAssist_db::dbSelectQuery -columnNames Package -table Packages]
    #if {$pkg ne ""} {
    #    foreach item $pkg {
    #        $f2.lbox insert end $item
    #    }
    #}

} ;#packagingTypes_GUI