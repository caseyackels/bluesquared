# Creator: Casey Ackels
# Initial Date: March 25, 2012]
# Dependencies: See Below
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 241 $
# $LastChangedBy: casey.ackels $
# $LastChangedDate: 2012-03-01 21:26:50 -0800 (Thu, 01 Mar 2012) $
#
########################################################################################

##
## - Overview
# This file holds the code pertaining to the ESC/P printer codes

## Coding Conventions
# - Namespaces: 

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

namespace eval nextgenrm_EscP {}

proc nextgenrm_Escp::init_esc {} {
	#****f* init_esc/nextgenrm_EscP
	# AUTHOR
	#	Casey Ackels
	#
	# COPYRIGHT
	#	(c) 2012 - Casey Ackels
	#
	# FUNCTION
	#	Initialize basic printer control codes
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
	# SEE ALSO
	#
	#***
	global esc
	
	array set esc {
		ESC [format %c 0x1b] ;# Hex for ESC Code
		NUL [format %c 0x00] ;# Hex for Nul Code
		SO	[format %c 0x0e] ;# Hex for SO Code
		SI	[format %c 0x0f] ;# Hex for SI Code
	}
}