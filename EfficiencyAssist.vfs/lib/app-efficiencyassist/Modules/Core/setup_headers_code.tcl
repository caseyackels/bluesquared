# Creator: Casey Ackels
# Initial Date: March 12, 2011]
# File Initial Date: 09 25,2013
# Dependencies: 
#-------------------------------------------------------------------------------
#
# Subversion
#
# $Revision: 479 $
# $LastChangedBy: casey.ackels@gmail.com $
# $LastChangedDate: 2014-10-22 15:28:53 -0700 (Wed, 22 Oct 2014) $
#
########################################################################################

##
## - Overview
# Headers for Batch addresses

## Coding Conventions
# - Namespaces: Firstword_Secondword

# - Procedures: Proc names should have two words. The first word lowercase the first character of the first word,
#   will be uppercase. I.E sourceFiles, sourceFileExample

proc eAssistSetup::initsetupHeadersConfigArray {} {
    #****f* initsetupHeadersConfigArray/eAssistSetup
    # CREATION DATE
    #   05/06/2015 (Wednesday May 06)
    #
    # AUTHOR
    #	Casey Ackels
    #
    # COPYRIGHT
    #	(c) 2015 Casey Ackels
    #   
    #
    # SYNOPSIS
    #   eAssistSetup::initTitleConfigArray  
    #
    # FUNCTION
    #	Initilizes the setupHeadersConfig array
    #   
    #   
    # CHILDREN
    #	N/A
    #   
    # PARENTS
    #   ea::db::writeHeaderToDB 
    #   
    # NOTES
    #   
    #   
    # SEE ALSO
    # db prefix deals with database options
    # wid prefix deals with widget options
    # 
    # HeaderConfig_ID - INTEGER (AUTO INCREMENT)
    #   Primary Key of the HeadersConfig table
    #   
	# dbColName - TEXT, UNIQUE, NOT NULL
    #   This will be auto-prefixed with 'User_'; this will be the column name in the Title DB
    #   
    # dbDataType - TEXT, NOT NULL
    #   Options are: TEXT, INTEGER, DATE, TIME - This is set in the GUI code
    #   The datatype of the column. Neccessary for SQL commands and sorting
    #   
    # dbActive - BOOLEAN (Defaults to 1), NOT NULL
    #   We can't delete columns, so lets ensure we can deactivate them if needed.
    #
    # widLabelName - TEXT
    #   The name of the header label on the table list widget
    #
    # widLabelAlignment - TEXT, NOT NULL
    #   Options are: Left, Center, Right
    #   Aligns the text of the header/label
    #
    # widWidget - TEXT, NOT NULL
    #   Hard coded options: ttk::entry, ttk::combobox
    #
    # widValues - TEXT
    #   List of options to select; this is populated by registering the commands and inserting the options into a table that we can then query.
    #   See: ea::db::initUserDefinedValues
    #
    # widDataType - TEXT, NOT NULL
    #   This controls the datatype that the tablelist widget requires.
    #
    # widFormat - TEXT
    #   What formatting commands should be used on this column.
    #   E.g. Date, Time, human readable thousands separator.
    #   The database will contain a date: 2015-05-06; but we want to display 5/6/2015.
    #
    # widColAlignment - TEXT, NOT NULL
    #   Options: Left, Center, Right
    #   Aligns the data within the cell
    #
	# widStartColWidth - INTEGER, NOT NULL
    #   The starting width of the column. If this isn't set it will default to the width of the label/header text.
    #
	# widMaxWidth - INTEGER, NOT NULL
    #   Width that we don't want to automatically exceed.
    #
	# widResizeToLongestEntry - BOOLEAN, NOT NULL
    #   Defaults to 0 (Does not resize)
    #   Automatically resizes to the longest entry
    #
	# widMaxStringLength - INTEGER, NOT NULL
    #   If data exceeds this limit, that cell will be highlighted. This is purely informational. But can be used to validate data, when exporting files.
    #
	# widHighlightColor - TEXT
    #   The color used when highlighted cells that exceed the string length. If no color is found, YELLOW is the default.
    #
    # widUIGroup - TEXT, NOT NULL
    #   Options are: Consignee, Shipping Order, Misc
    #   This is a hard-coded list.
    #
    # widUIPositionWeight - INTEGER, NOT NULL
    #   Defaults to 0
    #   This affects the placement within the spreadsheet view (tablelist widget). We will first sort by weight, then alphabetically.
    #
    # widExportable - BOOLEAN
    #   Defaults to 1 (Exportable)
    #   We may not want this column to be included in the exported file. For instance if this was just a column of data that was of interested with the person using the software
    #   and not of user to the software that the data was being imported into.
    #
    # widRequired - BOOLEAN, NOT NULL
    #   Defaults to 0 (Not required)
    #   This will allow us to validate the data when exporting; if the column is required and contains no data we can raise an errror.
    #   
	# widDisplayMode - TEXT, NOT NULL
    #   Options are: Always, Never, Dynamic; Defaults to Dynamic
	# 	These options are hard coded.
    #***
    global log setupHeadersConfig
    
	array set setupHeadersConfig  {
							HeaderConfig_ID "" \
							dbColName "" \
							dbDataType "" \
                            dbActive 1 \
							widLabelName "" \
							widLabelAlignment "" \
							widWidget "" \
							widValues "" \
							widDataType "" \
							widFormat "" \
							widColAlignment "" \
							widStartColWidth "" \
							widMaxWidth "" \
							widResizeToLongestEntry 0 \
							widMaxStringLength "" \
							widHighlightColor "" \
							widUIGroup "" \
							widUIPositionWeight 0 \
							widExportable 1 \
							widRequired 0 \
							widDisplayType Dynamic}
} ;# eAssistSetup::initsetupHeadersConfigArray