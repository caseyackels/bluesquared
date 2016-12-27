# Creator: Casey Ackels
# Initial Date: June 2016]
# Dependencies: See Below
#-------------------------------------------------------------------------------

# Designed for Epson TM-T90 printer

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