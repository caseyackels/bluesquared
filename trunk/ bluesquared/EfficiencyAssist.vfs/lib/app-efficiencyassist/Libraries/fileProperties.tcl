# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 01 19,2014
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
# Look at folder and/or file permissions, and act accordingly

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

proc eAssist_Global::folderAccessibility {path} {
    #****f* folderAccessibility/eAssist_Global
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Find out if we can read or write to the specified folder. Returns 0 if we can't do anything; 1 if we can read, 2 if we can write, 3 if we can do both.
    #
    # SYNOPSIS
    #   eAssist_Global::folderAccessibility <PathToFolder>
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
    global log
    #${log}::debug --START-- [info level 1]
    
    set fileRead 0
    set fileWrite 0
    
    ## READ FOLDER
    # This shouldn't every apply since, if we can't read the folder, we shouldn't be able to execute the .exe; but just in case...
    if {[file readable [file join $path]]} {
        ${log}::notice -PASS- $path folder is readable ...
        set fileRead 1

    } else {
        console show
        ${log}::critical -FAIL- $path is not readable ...
    }
    
    ## WRITE FOLDER
    if {[file writable [file join $path]]} {
        ${log}::notice -PASS- $path folder is writable ...
        set fileWrite 2
    } else {
        console show
        ${log}::critical -FAIL- $path is not writable ...
    }
    
    return [expr {$fileRead + $fileWrite}]
	
    #${log}::debug --END-- [info level 1]
} ;# eAssist_Global::folderAccessibility


proc eAssist_Global::fileAccessibility {folder file} {
    #****f* fileAccessibility/eAssist_Global
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2011-2014 Casey Ackels
    #
    # FUNCTION
    #	Find out if we can read or write to the specified file. Returns 0 if we can't do anything; 1 if we can read, 2 if we can write, 3 if we can do both.
    #
    # SYNOPSIS
    #   eAssist_Global::fileAccessibility <PathToFolder> <FileName>
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
    global log
    #${log}::debug --START-- [info level 1]
    
    set fileRead 0
    set fileWrite 0
    
    # READ FILE
    if {[file readable [file join $folder $file]]} {
        ${log}::notice -PASS- $file file is readable ...
        set fileRead 1
    
    } else {
        console show
        ${log}::critical -FAIL- $file file is NOT readable, settings will NOT be loaded!
    }
    
    # WRITE FILE
    if {[file writable [file join $folder $file]]} {
        ${log}::notice -PASS- $file file is writable ...
        set fileWrite 2

    } else {
        console show
        ${log}::critical -FAIL- Cannot write to $file file for saving. Check the file permissions and try again.
    }
	
    
    return [expr {$fileRead + $fileWrite}]
    #${log}::debug --END-- [info level 1]
} ;# eAssist_Global::fileAccessibility
    
    