# Creator: Casey Ackels
# Date: May 26th, 2007
# Last Updated:
# Version: .1
# Dependencies: See brass_launch_code.tcl


# Start GUI
namespace eval Brass_Gui {
    
proc brassGUI {} {
    # This proc is launched in brass_launch_code.tcl
    global gui boxSize
    
    console show
    
    #if {[winfo exists .mainTop]} {destroy .mainTop}
    
    wm title . "Brass (UPS) - v0.1"
    # width x height
    #wm geometry . 350x325
    wm geometry . 380x370
    

    # Create Frame2
    set frame2 [ttk::labelframe .frame2 -text "File Information"]
        set gui(S_brassFile) "Please select a file"
    
    entry $frame2.entry1 -width 35 -textvariable gui(S_brassFile)
    ttk::button $frame2.button -text "Browse" -command { set gui(S_brassFile) [tk_getOpenFile] }
    
    ##
    ## Packing List
    ##
    
    grid $frame2.entry1 -column 0 -row 0 -padx 5p -pady 5p
    grid $frame2.button -column 1 -row 0 -padx 5p -pady 5p
    
    pack $frame2 -fill x -padx 5p -pady 5p
    
    # Create Frame3
    set frame3 [ttk::labelframe .frame3 -text "Box Information"]
    
    # Header Row - Box Size, Quantity, Weight
    label $frame3.boxsize -text "Box Size"
    label $frame3.quantity -text "Quantity"
    label $frame3.weight -text "Box Tare"
    
    
    
    # 9 inch boxes
    set boxSize(9,qty) 185
    set boxSize(9,lb) .55
    label $frame3.txt9_1 -text 9\"
    entry $frame3.entry9_1 -textvariable boxSize(9,qty) -width 15
    entry $frame3.entry9_2 -textvariable boxSize(9,lb) -width 15
    
    # 6 inch boxes
    set boxSize(6,qty) 140
    set boxSize(6,lb) .47
    label $frame3.txt6_1 -text 6\"
    entry $frame3.entry6_1 -textvariable boxSize(6,qty) -width 15
    entry $frame3.entry6_2 -textvariable boxSize(6,lb) -width 15
    
    # 4 inch boxes
    set boxSize(4,qty) 120
    set boxSize(4,lb) .47
    label $frame3.txt4_1 -text 4\"
    entry $frame3.entry4_1 -textvariable boxSize(4,qty) -width 15
    entry $frame3.entry4_2 -textvariable boxSize(4,lb) -width 15
    
    # 2 inch boxes
    set boxSize(2,qty) 100
    set boxSize(2,lb) .395
    label $frame3.txt2_1 -text 2\"
    entry $frame3.entry2_1 -textvariable boxSize(2,qty) -width 15
    entry $frame3.entry2_2 -textvariable boxSize(2,lb) -width 15
    
    ##
    ## PACKING LIST
    ##
    
    # Packing list for Header
    grid $frame3.boxsize -column 0 -row 0 -padx 5p -pady 5p
    grid $frame3.quantity -column 1 -row 0 -padx 5p -pady 5p
    grid $frame3.weight -column 2 -row 0 -padx 5p -pady 5p
    
    # Packing list for 9" boxes
    grid $frame3.txt9_1 -column 0 -row 1 -padx 5p -pady 5p
    grid $frame3.entry9_1 -column 1 -row 1 -padx 5p -pady 5p
    grid $frame3.entry9_2 -column 2 -row 1 -padx 5p -pady 5p
    
    # Packing list for 6" boxes
    grid $frame3.txt6_1 -column 0 -row 2 -padx 5p -pady 5p
    grid $frame3.entry6_1 -column 1 -row 2 -padx 5p -pady 5p
    grid $frame3.entry6_2 -column 2 -row 2 -padx 5p -pady 5p
    
    # Packing list for 4" boxes
    grid $frame3.txt4_1 -column 0 -row 3 -padx 5p -pady 5p
    grid $frame3.entry4_1 -column 1 -row 3 -padx 5p -pady 5p
    grid $frame3.entry4_2 -column 2 -row 3 -padx 5p -pady 5p
    
    # Packing list for 2" boxes
    grid $frame3.txt2_1 -column 0 -row 4 -padx 5p -pady 5p
    grid $frame3.entry2_1 -column 1 -row 4 -padx 5p -pady 5p
    grid $frame3.entry2_2 -column 2 -row 4 -padx 5p -pady 5p
    
    pack $frame3 -fill x -padx 5p -pady 5p
    
    # Create Frame3B
    set boxSize(pieceWeight) .5
    set frame3b [ttk::labelframe .frame3b -text "Piece Weight"]
    
    label $frame3b.txt -text "Piece Weight"
    entry $frame3b.bookWgt -textvariable boxSize(pieceWeight) -width 25
    
    ##
    ##  Packing List
    ##
    
    grid $frame3b.txt -column 0 -row 0 -padx 5p -pady 5p -sticky nws
    grid $frame3b.bookWgt -column 1 -row 0 -padx 5p -pady 5p -sticky nws
    
    pack $frame3b -fill x -padx 5p -pady 5p
    
    # Create Frame4
    set frame4 [ttk::frame .frame4]
    
    ttk::button $frame4.close -text Close -command {exit}
    ttk::button $frame4.process -text "Process File" -command {Brass_BackEnd::generateFile}
    
    ##
    ## Packing List
    ##
    
    grid $frame4.close -column 0 -row 0 -padx 5p -pady 5p
    grid $frame4.process -column 1 -row 0 -padx 5p -pady 5p
    
    pack $frame4 -fill x -side right -padx 5p
}


} ;# End Of Brass_Gui