# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 11 09,2015

proc ea::gui::notes::editNotes {} {
    #****f* editNotes/ea::gui::notes
    # CREATION DATE
    #   03/11/2015 (Wednesday Mar 11)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistHelper::editNotes  
    #
    # FUNCTION
    #	Displays the Notes window for the job level
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
    global log job hist user
	# Do not launch if a job has not been loaded
	if {![info exists job(db,Name)]} {${log}::debug The job database has not been loaded yet; return}

	set w .notes
    eAssist_Global::detectWin $w -k
	
	# Setup the history array
	set hist(log,User) $user(id)
	set hist(log,Date) [ea::date::getTodaysDate]
	
	toplevel $w
    wm transient $w .
    wm title $w [mc "Note Editor"]
    
    set locX [expr {[winfo screenwidth . ] / 4 + [winfo x .]}]
    set locY [expr {[winfo screenheight . ] / 5 + [winfo y .]}]
    wm geometry $w +${locX}+${locY}

    #set f0 [ttk::frame $w.f0]
    #pack $f0 -fill both -padx 5p
    pack [ttk::frame $w.f] -fill both -padx 5p
    
    set nbk [ttk::notebook $w.f.notebook]
    pack $nbk -expand yes -fill both -padx 5p -pady 5p
    
    ttk::notebook::enableTraversal $nbk
    
    #
    # Setup the notebook
    #
    $nbk add [ttk::frame $nbk.title] -text [mc "Title"]
    $nbk add [ttk::frame $nbk.job] -text [mc "Job"]
    $nbk add [ttk::frame $nbk.version] -text [mc "Version"]
    $nbk add [ttk::frame $nbk.publish] -text [mc "Publish"]
    
    $nbk select $nbk.title
	
    # Setup the variables
	set title_RevList [list [$job(db,Name) eval {SELECT Notes_ID FROM NOTES WHERE NoteTypeID = 1}]]
    set job_RevList [list [$job(db,Name) eval {SELECT Notes_ID FROM NOTES WHERE NoteTypeID = 2}]]
    set version_RevList [list [$job(db,Name) eval {SELECT Notes_ID FROM NOTES WHERE NoteTypeID = 3}]]
    set publish_RevList [list [$job(db,Name) eval {SELECT Notes_ID FROM NOTES WHERE NoteTypeID = 6}]]
	
    
    ## Tab 1 (TITLE): Revision Frame
	##
    foreach revList {title_RevList job_RevList version_RevList publish_RevList} {
        set frameTitle [lindex [split $revList _] 0]
        set f0 [ttk::frame $nbk.$frameTitle.f0 -padding 10]
        pack $f0 -fill x -anchor n
        
        ${log}::debug revlist: [subst $$revList]
        set revlist [subst $$revList]
        
        grid [ttk::label $f0.txt1 -text [mc "View Revision"]] -column -0 -row 0 -pady 2p -padx 2p
        grid [ttk::combobox $f0.cbox -width 5 \
                                -state readonly \
                                -postcommand "$f0.cbox configure -values $revlist"] -column 1 -row 0 -pady 2p -padx 2p
    
        
        #ttk::button $f0.btn -text [mc "Refresh"] -command [list job::db::readNotes $f0.cbox $w.f1.txt $w.f2.bottom.txt]
        
        #grid $f0.txt1 -column 0 -row 0 -pady 2p -padx 2p
        #grid $f0.cbox -column 1 -row 0 -pady 2p -padx 2p
        #grid $f0.btn -column 2 -row 0 -pady 2p -padx 2p
    
        ## Job Notes Frame
        ##
        set f1 [ttk::labelframe $nbk.$frameTitle.f1 -text [string totitle [mc "$frameTitle Notes"]]]
        #set f1 [ttk::labelframe $w.f1 -text [mc "Job Notes"] -padding 10]
        pack $f1 -fill both -expand yes -padx 5p -pady 5p -anchor n
        
        text $f1.txt -height 10 \
                    -wrap word \
                    -yscrollcommand [list $f1.scrolly set]
        
        ttk::scrollbar $f1.scrolly -orient v -command [list $f1.txt yview]
        
        grid $f1.txt -column 0 -row 0 -sticky news
        grid $f1.scrolly -column 1 -row 0 -sticky nse
        
        grid columnconfigure $f1 0 -weight 2
        grid rowconfigure $f1 0 -weight 2
        
        ::autoscroll::autoscroll $f1.scrolly ;# Enable the 'autoscrollbar'
        
        ## Log notes Frame
        ##
        set f2 [ttk::labelframe $nbk.$frameTitle.f2 -text [mc "Internal Revision Notes"]]
        #set f2 [ttk::labelframe $w.f2 -text [mc "Internal Revision Notes"] -padding 10]
        pack $f2 -fill both -expand yes -padx 5p -pady 5p -anchor n
        
        set f2_a [ttk::frame $f2.top]
        pack $f2_a -fill both
        
        ttk::label $f2_a.txt1a -text [mc User]
        ttk::label $f2_a.txt1b -textvariable hist(log,User)
        ttk::label $f2_a.txt2a -text [mc Date/Time]
        ttk::label $f2_a.txt2b -textvariable hist(log,Date)
        ttk::label $f2_a.txt2c -textvariable hist(log,Time)
        
        grid $f2_a.txt1a -column 0 -row 0 -sticky e -padx 2p
        grid $f2_a.txt1b -column 1 -row 0 -sticky w
        grid $f2_a.txt2a -column 0 -row 1 -sticky e -padx 2p
        grid $f2_a.txt2b -column 1 -row 1 -sticky w
        grid $f2_a.txt2c -column 2 -row 1 -sticky w
        
        set f2_b [ttk::frame $f2.bottom]
        pack $f2_b -fill both -expand yes
        
        text $f2_b.txt -height 5 \
                        -wrap word \
                        -yscrollcommand [list $f2_b.scrolly set]
        
        ttk::scrollbar $f2_b.scrolly -orient v -command [list $f2_b.txt yview]
    
        grid $f2_b.txt -column 0 -row 0 -sticky news
        grid $f2_b.scrolly -column 1 -row 0 -sticky nse
        
        grid columnconfigure $f2_b 0 -weight 2
        grid rowconfigure $f2_b 0 -weight 2
        
        ::autoscroll::autoscroll $f2_b.scrolly ;# Enable the 'autoscrollbar'
        
        ##
        ## Bindings
        ##
        
        bind $f0.cbox <<ComboboxSelected>> [list job::db::readNotes $frameTitle $f0.cbox $f1.txt $f2_b.txt]
        
        ## *****
        ## Show the latest revision automatically
            
        if {$revlist ne ""} {
            $f0.cbox set [lindex [join $revlist] end]
            job::db::readNotes $frameTitle $f0.cbox $f1.txt $f2_b.txt
        }
        
        # Reset the modification flag
        $f1.txt edit modified 0
        $f2_b.txt edit modified 0
    }
    
    ## Button Frame
    ##
    set btn [ttk::frame $w.btns -padding 10]
    pack $btn -padx 5p -pady 5p -anchor se
    
    ttk::button $btn.ok -text [mc "OK"] -command "[list job::db::insertNotes $nbk]; destroy $w"
    ttk::button $btn.cancel -text [mc "Cancel"] -command [list destroy $w]
    
    grid $btn.ok -column 0 -row 0 -padx 5p -sticky e
    grid $btn.cancel -column 1 -row 0 -sticky e

    
} ;# ea::gui::notes::editNotes