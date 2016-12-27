# Creator: Casey Ackels
# Initial Date: August 30, 2016]
# Description
# This is the batch formatter for small packages (UPS, FedEx, USPS), that Shipping uses to format the files based on parameters, in setup and at run time. The formatted file is then
# imported into Process Shipper to actually process (ship).
#-------------------------------------------------------------------------------

# Namespaces are initialized in startup.tcl
# Available namespaces
# ea::code::bf
# ea::gui::bf
# ea::db::bf

package provide eAssist_ModBatchFormatter 1.0

proc ea::gui::bf::LaunchGUI {} {
    #****f* ea::gui::bf/LaunchGUI
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011 - Casey Ackels
    #
    # FUNCTION
    #	Builds the GUI of the Batch Formatter module.
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
    #	
    # SEE ALSO
    #	
    #
    #***
    global log program mySettings settings user
    
    ${log}::notice Launching Batch Formatter

    # Clear the frames before continuing
    eAssist_Global::resetFrames parent
    
    # Set the vars
    # n/a


    ##
    ## Parent Frame
    ##

    set f0 .container.f0
    pack [ttk::frame $f0] -expand yes -fill both
    
    set f0a $f0.f0a
    grid [ttk::labelframe $f0a -text [mc "Job Information"] -padding 10] -column 0 -row 0 -sticky new -padx 5p -pady 5p 
    
    grid [ttk::label $f0a.txt0 -text [mc "File Name"]] -column 0 -row 0 -sticky e -pady 2p -padx 2p
    grid [ttk::entry $f0a.entry0 -width 50] -column 1 -row 0 -sticky ew
    
    grid [ttk::button $f0a.btn0 -text [mc "Import File"]] -column 2 -row 0 -sticky ew
    
    grid [ttk::label $f0a.txt1 -text [mc "Job Number"]] -column 0 -row 1 -sticky e -pady 2p -padx 2p
    grid [ttk::entry $f0a.entry1] -column 1 -row 1 -sticky ew
    
    grid [ttk::label $f0a.txt2 -text [mc "Job Description"]] -column 0 -row 2 -sticky e -pady 2p -padx 2p
    grid [ttk::entry $f0a.entry2] -column 1 -row 2 -sticky ew
    
    
    set f1 $f0.f1
    grid [ttk::labelframe $f1 -text [mc "Shipping Parameters"] -padding 10] -column 1 -row 0 -sticky new -padx 5p -pady 5p
    
    grid [ttk::label $f1.txt0 -text [mc "Piece Weight"]] -column 0 -row 0 -sticky e -pady 2p -padx 2p
    grid [ttk::entry $f1.entry0 -width 6] -column 1 -row 0 -sticky w
    tooltip::tooltip $f1.entry0 [mc "Leading zeros are not required"]
    
    grid [ttk::label $f1.txt1 -text [mc "Full Box"]] -column 0 -row 1 -sticky e -pady 2p -padx 2p
    grid [ttk::entry $f1.entry1 -width 6] -column 1 -row 1 -sticky w
    
    set f2 $f0.f2
    grid [ttk::labelframe $f2 -text [mc "Customer"] -padding 10] -column 2 -row 0 -sticky new -padx 5p -pady 5p
    
    grid [ttk::label $f2.txt0 -text [mc "Third Party Acct"]] -column 0 -row 0 -sticky e -pady 2p -padx 2p
    grid [ttk::combobox $f2.entry0 -width 40] -column 1 -row 0 -sticky ew -pady 2p -padx 2p
    
    set addrGrid .container.f3
    pack [ttk::frame $addrGrid -padding 10] -expand yes -fill both
    
    set scrolly $addrGrid.scrolly
    set scrollx $addrGrid.scrollx
    tablelist::tablelist $addrGrid.tbl -columns {
                                        0 "Ship Via" center
                                        0 "Company" center
                                        0 "Attention" center
                                        0 "Delivery Address"
                                        0 "Address 2"
                                        0 "Address 3"
                                        0 "City"
                                        0 "State"
                                        0 "Zip"
                                        0 "Country"
                                        0 "Phone"
                                        0 "Version"
                                        0 "Quantity"
                                        0 "Full Box"
                                        0 "Piece Weight"
                                        0 "Email"
                                        } \
                                    -showlabels yes \
                                    -selectbackground lightblue \
                                    -selectforeground black \
                                    -stripebackground lightyellow \
                                    -exportselection yes \
                                    -showseparators yes \
                                    -fullseparators yes \
                                    -height 25 \
                                    -yscrollcommand [list $scrolly set] \
                                    -xscrollcommand [list $scrollx set]
    
    ttk::scrollbar $scrolly -orient v -command [list $addrGrid.tbl yview]
    ttk::scrollbar $scrollx -orient h -command [list $addrGrid.tbl xview]
        
    grid $scrolly -column 1 -row 0 -sticky ns
    grid $scrollx -column 0 -row 1 -sticky ew
        
    ::autoscroll::autoscroll $scrolly ;# Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $scrollx ;# Enable the 'autoscrollbar'
    
    grid $addrGrid.tbl -column 0 -row 0 -sticky news
    grid columnconfigure $addrGrid $addrGrid.tbl -weight 2
    grid rowconfigure $addrGrid $addrGrid.tbl -weight 2
}
    