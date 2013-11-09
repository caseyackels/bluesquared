# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 10 11,2013
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
# Overview

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample


proc eAssistSetup::addressHeaders_GUI {} {
    #****f* addressHeadersI/eAssistSetup
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2013 Casey Ackels
    #
    # FUNCTION
    #	Batch Addresses - Add/Edit header mappings, to headers that we have in the system already.
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
    global log G_setupFrame currentModule program headerParams headerParent
    global GUI w filters
    #variable GUI
    
    #set currentModule addressHeaders
    eAssist_Global::resetSetupFrames ;# Reset all frames so we start clean
    
    # Initialize the filters array
    eAssist_Global::launchFilters
    
    ##
    ## Parent Frame
    ##

    set w(hdr_frame1) [ttk::frame $G_setupFrame.frame1]
    pack $w(hdr_frame1) -expand yes -fill both -ipadx 5p -ipady 5p
    

    #
    #------- Frame 1a
    #
    set w(hdr_frame1a) [ttk::labelframe $w(hdr_frame1).a -text [mc "Master Header"]]
    pack $w(hdr_frame1a) -expand yes -fill both -ipadx 5p -ipady 5p
    
    tablelist::tablelist $w(hdr_frame1a).listbox -columns {
                                                    0   "..." center
                                                    0  "Header Name"
                                                    0  "Max String Length"
                                                    0  "Output Header"
                                                    0  "Widget"
                                                    0  "Highlight"
                                                    } \
                                        -showlabels yes \
                                        -height 10 \
                                        -selectbackground yellow \
                                        -selectforeground black \
                                        -stripebackground lightblue \
                                        -exportselection yes \
                                        -showseparators yes \
                                        -fullseparators yes \
                                        -movablecolumns yes \
                                        -movablerows yes \
                                        -editselectedonly 1 \
                                        -yscrollcommand [list $w(hdr_frame1a).scrolly set] \
                                        -xscrollcommand [list $w(hdr_frame1a).scrollx set] \
                                        -editstartcommand {eAssistSetup::startCmdHdr} \
                                        -editendcommand {eAssistSetup::endCmdHdr}
    
        $w(hdr_frame1a).listbox columnconfigure 0 -name "count" \
                                            -showlinenumbers 1 \
                                            -labelalign center
    
        $w(hdr_frame1a).listbox columnconfigure 1 -name "HeaderName" \
                                            -editable yes \
                                            -editwindow ttk::entry \
                                            -labelalign center
        
        $w(hdr_frame1a).listbox columnconfigure 2 -name "MaxStringLength" \
                                            -editable yes \
                                            -editwindow ttk::entry \
                                            -labelalign center
        
        $w(hdr_frame1a).listbox columnconfigure 3 -name "OutputHeader" \
                                            -editable yes \
                                            -editwindow ttk::entry \
                                            -labelalign center
        
        $w(hdr_frame1a).listbox columnconfigure 4 -name "Widget" \
                                            -editable yes \
                                            -editwindow ttk::combobox \
                                            -labelalign center
                                            
        $w(hdr_frame1a).listbox columnconfigure 5 -name "Highlight" \
                                            -editable yes \
                                            -editwindow ttk::entry \
                                            -labelalign center
       

        
        
        
    if {[array exists headerParams] == 1} {
        #'debug Populate listobx - data exists
            #foreach hdrInfo [array names headerParams] {}
            foreach hdrInfo $headerParent(headerList) {
                #'debug inserting $customer
                #$w(hdr_frame1a).listbox insert end [list "" $hdrInfo [lindex $headerParams($hdrInfo) 0] $params]
                $w(hdr_frame1a).listbox insert end "{} $hdrInfo $headerParams($hdrInfo)"
               
                #${log}::debug HEADER: [list $hdrInfo [lindex $headerParams($hdrInfo) 0] [lindex $headerParams($hdrInfo) 1]]
                ${log}::debug _array name: $hdrInfo
                ${log}::debug field 2: [lindex $headerParams($hdrInfo) 0]
                ${log}::debug field 3: [lindex $headerParams($hdrInfo) 1]
                ${log}::debug field 4: [lindex $headerParams($hdrInfo) 2]
                ${log}::debug field 5: [lindex $headerParams($hdrInfo) 3]
                ${log}::debug field 6: [lindex $headerParams($hdrInfo) 4]
            }
    }
        
    bind [$w(hdr_frame1a).listbox bodytag] <Double-1> {
        # Delete the entry
        $w(hdr_frame1a).listbox delete [$w(hdr_frame1a).listbox curselection]
    }
        #if {[info exists setup(boxLabelConfig)]} {
        #    #'debug Populate listobx - data exists
        #        foreach boxlabel $setup(boxLabelConfig) {
        #            #'debug inserting $customer
        #            $frame2.listbox insert end $boxlabel
        #            incr internal(table2,currentRow)
        #        }
        #}
    
    # Create the row counter and the first line
    set internal(addrHdr,currentRow) 0
    $w(hdr_frame1a).listbox insert end ""
    
    
    ttk::scrollbar $w(hdr_frame1a).scrolly -orient v -command [list $w(hdr_frame1a).listbox yview]
    ttk::scrollbar $w(hdr_frame1a).scrollx -orient h -command [list $w(hdr_frame1a).listbox xview]
    
    grid $w(hdr_frame1a).listbox -column 0 -row 0 -sticky news
    grid columnconfigure $w(hdr_frame1a) $w(hdr_frame1a).listbox -weight 1
    grid rowconfigure $w(hdr_frame1a) $w(hdr_frame1a).listbox -weight 1
    
    grid $w(hdr_frame1a).scrolly -column 1 -row 0 -sticky nse
    grid $w(hdr_frame1a).scrollx -column 0 -row 1 -sticky ews
    
    ::autoscroll::autoscroll $w(hdr_frame1a).scrolly ;# Enable the 'autoscrollbar'
    ::autoscroll::autoscroll $w(hdr_frame1a).scrollx

    
    #
    #-------- Frame 1b
    #
    set w(hdr_frame1b) [ttk::labelframe $w(hdr_frame1).b -text [mc "Sub-Headers"]]
    pack $w(hdr_frame1b) -expand yes -fill both -ipadx 5p -ipady 5p
    
    ttk::label $w(hdr_frame1b).label1 -text [mc "Header Name"]

    ttk::combobox $w(hdr_frame1b).cbox1 -width 20 \
                            -state readonly \
                            -textvariable parentHeader \
                            -postcommand {eAssistSetup::populateComboBox}
    
    ttk::entry $w(hdr_frame1b).entry1 -width 20 -textvariable insertChildHeader
    
    ttk::button $w(hdr_frame1b).btn1 -text [mc "Add"] -command {eAssistSetup::addToChildHeader $w(hdr_frame1b).lbox1 $w(hdr_frame1b).entry1 $insertChildHeader $parentHeader}
    ttk::button $w(hdr_frame1b).btn2 -text [mc "Delete"] -command {eAssistSetup::removeHeader child $w(hdr_frame1b).lbox1 $parentHeader}
    
    listbox $w(hdr_frame1b).lbox1 -height 8 -width 20
    
    #-------- Grid Frame 1b
    grid $w(hdr_frame1b).label1 -column 0 -row 0
    grid $w(hdr_frame1b).cbox1 -column 1 -row 0
    
    grid $w(hdr_frame1b).entry1 -column 1 -row 1 -sticky news
    grid $w(hdr_frame1b).btn1 -column 2 -row 1
    
    grid $w(hdr_frame1b).lbox1 -column 1 -row 2 -sticky news
    grid $w(hdr_frame1b).btn2 -column 2 -row 2 -sticky new
    
    #---------- Binding
    bind $w(hdr_frame1b).cbox1 <<ComboboxSelected>> {
        # Display the child headers associated with the parent header
        eAssistSetup::displayHeader $w(hdr_frame1b).lbox1 [$w(hdr_frame1b).cbox1 current] $parentHeader
    }
	
} ;# eAssistSetup::addressHeaders_GUI