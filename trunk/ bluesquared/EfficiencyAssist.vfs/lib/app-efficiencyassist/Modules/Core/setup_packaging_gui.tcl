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
# $LastChangedDate: 2011-10-17 16:11:20 -0700 (Mon, 17 Oct 2011) $
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
    listbox $f1.lbox
    
    ## Grid
    grid $f1.lbl -column 0 -row 0 -sticky e
    grid $f1.entry -column 1 -row 0 -sticky news
    grid $f1.lbox -column 1 -row 1 -sticky news
    
    ## Bindings
    # Enter
    bind $f1.entry <Return> "eAssistSetup::addPackagingSetup CONTAINER $f1.entry $f1.lbox"
    # .. So both enter key's work the same way
    bind $f1.entry <KP_Enter> "eAssistSetup::addPackagingSetup CONTAINER $f1.entry $f1.lbox"
    
    # Delete
    bind $f1.lbox <Delete> "eAssistSetup::delPackagingSetup CONTAINER $f1.lbox"
    bind $f1.lbox <BackSpace> "eAssistSetup::delPackagingSetup CONTAINER $f1.lbox"


    
    # Populate the listbox if we have existing data
    if {[info exists packagingSetup(ContainerType)] == 1} {
        foreach item $packagingSetup(ContainerType) {
            $f1.lbox insert end $item
        }
    }
    
    ##
    ## Frame 2
    ##
    set f2 [ttk::labelframe $frame0.f2 -text [mc "Packages"] -padding 10]
    grid $f2 -column 1 -row 0 -sticky news -padx 5p
    
    ttk::label $f2.lbl -text [mc "Name"]
    ttk::entry $f2.entry -textvariable packagingSetup(enterPackageType)
    listbox $f2.lbox
    
    grid $f2.lbl -column 0 -row 0 -sticky e
    grid $f2.entry -column 1 -row 0 -sticky news
    grid $f2.lbox -column 1 -row 1 -sticky news
    
    ## Bindings
    # Enter
    bind $f2.entry <Return> "eAssistSetup::addPackagingSetup PACKAGE $f2.entry $f2.lbox"
    # .. So both enter key's work the same way
    bind $f2.entry <KP_Enter> "eAssistSetup::addPackagingSetup PACKAGE $f2.entry $f2.lbox"
    
    # Delete
    bind $f2.lbox <Delete> "eAssistSetup::delPackagingSetup PACKAGE $f2.lbox"
    bind $f2.lbox <BackSpace> "eAssistSetup::delPackagingSetup PACKAGE $f2.lbox"
    
    
    # Populate the listbox if we have existing data
    if {[info exists packagingSetup(PackageType)] == 1} {
        foreach item $packagingSetup(PackageType) {
            $f2.lbox insert end $item
        }
    }

} ;#packagingTypes_GUI