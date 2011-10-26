# Creator: Casey Ackels
# Initial Date: October 28th, 2006]
# Massive Rewrite: February 2nd, 2007
# Last Updated: February 6th, 2007
# Dependencies: See shipping_launch_code.tcl
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 10 $
# $LastChangedBy: casey $
# $LastChangedDate: 2007-02-23 06:30:17 -0800 (Fri, 23 Feb 2007) $
#
########################################################################################

# Definitions for prefixes of Variables
# G = Global
# S = String
# L = List
# I = Integer (Do not use this unless you are certain it is an Integer and not a plain string)

## Coding Conventions
# - Namespaces: These should have two parts, a _gui and a _code. Both words should be capitalized. i.e. Example_Code

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


# Start GUI
package provide bluesquirrel_core 1.0

namespace eval blueSquirrel {}


proc blueSquirrel::parentGUI {} {
    #****f* parentGUI/blueSquirrel
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2008 Casey Ackels
    #
    # FUNCTION
    #	Generate the parent GUI container and buttons (Close / Print)
    #
    # SYNOPSIS
    #	N/A
    #
    # CHILDREN
    #	blueSquirrel::shippingGUI
    #
    # PARENTS
    #	None
    #
    # NOTES
    #	None
    #
    # SEE ALSO
    #	N/A
    #
    #***
    global GI_textVar GS_textVar frame1 frame2b genResults GS_windows GS_widget GS_winGeom

    # List of frames within this proc
    set GS_windows ".frame1 .frame2 .frame3"
    #array set GS_widget breakdown

    # Make the window appear in a certain location every time.
    set GS_winGeom(main,x) [expr {[winfo screenwidth .]/3}]
    set GS_winGeom(main,y) [expr {[winfo screenheight .]/3}]
    puts "actual x: $GS_winGeom(main,x)"
    puts "actual y: $GS_winGeom(main,y)"

    #wm geometry . 390x420
    wm geometry . 390x415-$GS_winGeom(main,x)-$GS_winGeom(main,y)
    update

    # Create the Menu's
    set mb [menu .mb]
    . configure -menu $mb

    ## File
    menu $mb.file -tearoff 0 -relief raised -bd 2

    $mb add cascade -label "File" -menu $mb.file
    $mb.file add command -label "Import File" -command {}
    $mb.file add command -label "Breakdown" -command { wm deiconify .breakdown }
    $mb.file add command -label "Exit" -command {exit}

    ## Edit
    menu $mb.edit -tearoff 0 -relief raised -bd 2
    $mb add cascade -label "Edit" -menu $mb.edit
    $mb.edit add command -label "Preferences..." -command {blueSquirrel::preferences}
    $mb.edit add command -label "Clear List" -command { Shipping_Code::clearList }

    ## Help
    menu $mb.help -tearoff 0 -relief raised -bd 2
    $mb add cascade -label "Help" -menu $mb.help

    $mb.help add command -label "About" -command {blueSquirrel::about}

    # Create Separator Frame
    set frame0 [ttk::frame .frame0]
    ttk::separator $frame0.separator -orient horizontal

    grid $frame0.separator - -sticky ew -ipadx 4i
    pack $frame0 -anchor n -fill x -expand yes

    # Create the container frame
    ttk::frame .container
    pack .container -expand yes -fill both -anchor n -side top

    # Start the Default GUI - ShippingGUI
    # All frames that make up the GUI are children to .container
    Shipping_Gui::shippingGUI

    # Start the breakDown window (The window will be immediately iconified
    Shipping_Gui::breakDown


    ##
    ## Control Buttons
    ##

    set btnBar [ttk::frame .btnBar]

    ttk::button $btnBar.printb -text "Print Breakdown" -command Shipping_Gui::printbreakDown
    ttk::button $btnBar.print -text "Print Labels" -command Shipping_Code::printLabels
    ttk::button $btnBar.close -text "Close" -command exit

    grid $btnBar.printb -column 0 -row 3 -sticky nsw -padx 30p
    grid $btnBar.print -column 1 -row 3 -sticky nse -padx 8p
    grid $btnBar.close -column 2 -row 3 -sticky nse


    pack $btnBar -side bottom -expand yes -anchor se -pady 10p -padx 5p

    # ToolTips
    #tooltip::tooltip $btnBar.close "Close (Esc)"

    # Bindings
    bind all <Control-p> "Shipping_Code::printLabels"
    focus .

} ;# End of parentGUI


proc blueSquirrel::about {} {

    toplevel .about
    wm transient .about .
    wm title .about About
    focus .about

    ttk::frame .about.parent

    ttk::label .about.parent.version -text "Version: 1.5.1 (Released February 2011)"
    text .about.parent.txt -wrap word
    ttk::button .about.parent.close -text "Close" -command {destroy .about}
    ttk::label .about.parent.copy -text "\u00a9 2007-2011 Casey Ackels"

    .about.parent.txt insert end "I wrote this program so that we would not have to repeatedly do mundane math for each job that required box labels.\n"
    .about.parent.txt insert end "\n\n"
    .about.parent.txt insert end "Release 1.6.0 (June 2011)\n1. Ability to print what is listed in the Breakdown window"
    .about.parent.txt insert end "\n\n"
    .about.parent.txt insert end "Release 1.5.1 (February 2011)\n1. Break Down will now automatically refresh if the window is open and you add or remove an entry."
    .about.parent.txt insert end "\n\n"
    .about.parent.txt insert end "Release 1.5 (February 2011)\n1. Fixed Break Down to work correctly.\n2. Changed the versioning scheme to include version number, following with the month it was released.\n3. Deactivated a module that wasn't in use, might increase speed."
    .about.parent.txt insert end "\n\n"
    .about.parent.txt insert end "Release 1.2.11 (February 2011)\n1. Overview reinstated, go to Edit > Breakdown\n\n2. When selecting the blank line in the History it will now clear out all entry fields\n\n3. A few cosmetic updates"


    bind .about.parent.txt <KeyPress> {break} ;# Prevent people from entering/removing anything
    bind .about.parent.txt <Button-1> {break} ;# Prevent people from entering/removing anything

    grid .about.parent.version -column 0 -row 0

    grid .about.parent.txt -column 0 -row 2 -sticky news -padx 5p -pady 5p
    grid .about.parent.close -column 0 -row 3 -sticky ns -padx 5p -pady 5p
    grid .about.parent.copy -column 0 -row 4 -padx 5p -pady 5p

    grid rowconfigure .about.parent 2 -weight 1
    pack .about.parent -expand yes -fill both

}
