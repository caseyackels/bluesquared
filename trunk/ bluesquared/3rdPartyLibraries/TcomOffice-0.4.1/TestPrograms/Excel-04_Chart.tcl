# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

set auto_path [linsert $auto_path 0 [file join [pwd] ".."]]

package require tcomexcel

# Name of Excel file being generated.
# Number of test rows and columns being generated.
# Note:
#   The actual number of rows will be numRows+1,
#   because the first row contains header information.
#   The actual number of columns will be numCols+1,
#   because the first column contains time information.
set xlsFile [file join [pwd] "testOut" "ExcelChart"]
set numRows  10
set numCols   3

# Test preparation: Generate lists with test data.

# The name of the header of column 1.
set timeHeader "Time"

# The names of the header of columns [2, numCols+1].
for { set c 1 } { $c <= $numCols } {incr c } {
    lappend valsHeaderList "Coord-$c"
}

# The values for the time column (1).
for { set r 0 } { $r < $numRows } {incr r } {
    lappend timeList [expr $r * 0.1]
}

# The values for the data columns [2, numCols+1].
set minVal  1.0E6
set maxVal -1.0E6
for { set r 1 } { $r <= $numRows } {incr r } {
    set colList [list]
    for { set c 1 } { $c <= $numCols } {incr c } {
        set newVal [expr {10 + $r +$c*0.6}]
        lappend colList $newVal
        if { $newVal > $maxVal } {
            set maxVal $newVal
        }
        if { $newVal < $minVal } {
            set minVal $newVal
        }
    }
    lappend valsList $colList
}

# Data for test 3: Create a RadarMark chart.
expr srand (1)
for { set i 1 } { $i <= $numRows } { incr i } {
    lappend entList "Entity-$i"
    set shoots [expr int (20 * rand())]
    if { $shoots < 5 } {
        incr shoots 5
    }
    set hits [expr $shoots - int (10 * rand())]
    if { $hits < 0 } {
        set hits $shoots
    }
    if { $hits > $shoots } {
        set hits $shoots
    }
    lappend shootList $shoots
    lappend hitList $hits
}

# Test start: Open new Excel instance,
# show the application window and create a workbook.
set appId [::Excel::OpenNew]
set workbookId [::Excel::AddWorkbook $appId]

# Delete Excel file from previous test run.
append xlsFile [::Excel::GetExtString $appId]
catch { file delete -force $xlsFile }

# Perform test 1:
# Interpret the data as flight paths and display each data column as a line.
# The time column is used for the X axis.

# Create a worksheet and set its name.
# We use the first already existing worksheet for our first test.
# Mainly because otherwise our charts are not placed on the intended
# worksheet, but on the first default one. (Bug in Excel 2000, in Excel 2003
# this works correctly.
# set worksheetId [::Excel::AddWorksheet $workbookId]
set worksheetId [::Excel::GetWorksheetIdByIndex $workbookId 1]
::Excel::SetWorksheetName $worksheetId "LineChart"
set cellsId [::Excel::GetCellsId $worksheetId]

# Insert the list data into the Excel worksheet and automatically fit
# the column width.
::Excel::InsertTestData $cellsId $timeHeader $timeList $valsHeaderList $valsList

# Generate the line chart.
set lineChartId1 [::Excel::AddLineChartSimple $cellsId \
                  $numRows $numCols "All flight paths"]
::Excel::SetChartMinScale $lineChartId1 "y" $minVal
::Excel::SetChartMaxScale $lineChartId1 "y" $maxVal
::Excel::PlaceChart $lineChartId1 $worksheetId

# AddLineChart cellsId headerRow xaxisCol 
#              startRow numRows startCol numCols
#              title yaxisName markerSize
set lineChartId2 [::Excel::AddLineChart $cellsId \
                  1 1  3 4  3 2  "Some flight paths" "Coordinate"]
::Excel::PlaceChart $lineChartId2 $worksheetId

# Perform test 2:
# Interpret the data of columns 2 and 4 as a 2D location (lat, lon).
# and display the locations as a point chart.

# Create a worksheet and set its name.
set worksheetId [::Excel::AddWorksheet $workbookId "PointChart"]
set cellsId [::Excel::GetCellsId $worksheetId]

# Insert the list data into the Excel worksheet.
::Excel::InsertTestData $cellsId $timeHeader $timeList $valsHeaderList $valsList

set pointChartId [::Excel::AddPointChartSimple $cellsId \
                  $numRows 2 4 "MunitionDetonations"]
::Excel::SetChartScale $pointChartId $minVal $maxVal $minVal $maxVal
::Excel::PlaceChart $pointChartId $worksheetId

# Perform test 3:
# Load data from entList and shootList into a worksheet.
# Display the data as a radar mark chart.

# Create a worksheet and set its name.
set worksheetId [::Excel::AddWorksheet $workbookId "RadarChart"]
set cellsId [::Excel::GetCellsId $worksheetId]

# Insert the list data into the Excel worksheet.
::Excel::SetHeaderLine $cellsId [list "Entity" "Shots" "Hits"]

::Excel::SetColumnValues $cellsId 1 2 $entList
::Excel::SetColumnValues $cellsId 2 2 $shootList
::Excel::SetColumnValues $cellsId 3 2 $hitList

# Fit the column width automatically.
::Excel::SetColumnsWidth $cellsId 1 3 0

set radarChartId [::Excel::AddRadarChartSimple $cellsId $numRows 2]

# Place the radar chart as an object in the current worksheet.
set objChartId [::Excel::PlaceChart $radarChartId $worksheetId]

# Set the size of the generated chart.
::Excel::SetChartSize $worksheetId $objChartId 640 480

# Copy the radar chart to the Windows clipboard.
::Excel::CopyChartToClipboard $objChartId

# Save the radar chart as a GIF file.
::Excel::SaveChartToFile $objChartId [file join [pwd] "testOut" "ExcelChart.gif"]

# Utility function to copy the clipboard content into a photo image.
# Needs the Img and the Twapi extension.
# Code taken from the Tcl3D extension: www.tcl3d.org
proc Clipboard2Img {} {
    set retVal [catch {package require Img} version]
    if { $retVal } {
        puts "Img extension not available"
        return ""
    }
    if { ! [::Excel::HavePkg "twapi"] } {
        puts "Twapi extension not available"
        return ""
    }

    twapi::open_clipboard

    # Assume clipboard content is in format 8 (CF_DIB)
    set retVal [catch {twapi::read_clipboard 8} clipData]
    if { $retVal != 0 } {
        error "Invalid or no content in clipboard"
    }

    # First parse the bitmap data to collect header information
    binary scan $clipData "iiissiiiiii" \
           size width height planes bitcount compression sizeimage \
           xpelspermeter ypelspermeter clrused clrimportant

    # We only handle BITMAPINFOHEADER right now (size must be 40)
    if {$size != 40} {
        error "Unsupported bitmap format. Header size=$size"
    }

    # We need to figure out the offset to the actual bitmap data
    # from the start of the file header. For this we need to know the
    # size of the color table which directly follows the BITMAPINFOHEADER
    if {$bitcount == 0} {
        error "Unsupported format: implicit JPEG or PNG"
    } elseif {$bitcount == 1} {
        set color_table_size 2
    } elseif {$bitcount == 4} {
        # TBD - Not sure if this is the size or the max size
        set color_table_size 16
    } elseif {$bitcount == 8} {
        # TBD - Not sure if this is the size or the max size
        set color_table_size 256
    } elseif {$bitcount == 16 || $bitcount == 32} {
        if {$compression == 0} {
            # BI_RGB
            set color_table_size $clrused
        } elseif {$compression == 3} {
            # BI_BITFIELDS
            set color_table_size 3
        } else {
            error "Unsupported compression type '$compression' for bitcount value $bitcount"
        }
    } elseif {$bitcount == 24} {
        set color_table_size $clrused
    } else {
        error "Unsupported value '$bitcount' in bitmap bitcount field"
    }

    set phImg [image create photo]
    set filehdr_size 14                 ; # sizeof(BITMAPFILEHEADER)
    set bitmap_file_offset [expr {$filehdr_size+$size+($color_table_size*4)}]
    set filehdr [binary format "a2 i x2 x2 i" \
                 "BM" [expr {$filehdr_size + [string length $clipData]}] \
                 $bitmap_file_offset]

    append filehdr $clipData
    $phImg put $filehdr -format bmp

    twapi::close_clipboard
    return $phImg
}

# If we have the Img and Twapi extension, get the chart as a photo image
# from the clipboard and create a Tk label to display it.
set phImg [Clipboard2Img]
if { $phImg ne "" } {
    pack [label .l]
    .l configure -image $phImg
    wm title . "Extracted Excel chart as photo image \
               (Size: [image width $phImg] x [image height $phImg])"
} else {
    wm title . "Twapi extension missing."
}

# Check number of rows in different range objects.
puts "Number of rows in worksheet   : [::Excel::GetNumRows    $worksheetId]"
puts "Number of columns in worksheet: [::Excel::GetNumColumns $worksheetId]"

puts "Number of rows in cells   : [::Excel::GetNumRows    $cellsId]"
puts "Number of columns in cells: [::Excel::GetNumColumns $cellsId]"

set rangeId [::Excel::SelectRangeByIndex $worksheetId 2 1 \
                                         [expr $numRows+1] 3 true]
puts "Number of rows in range   : [::Excel::GetNumRows    $rangeId]"
puts "Number of columns in range: [::Excel::GetNumColumns $rangeId]"

# Enable the auto filter menus.
::Excel::ToggleAutoFilter $rangeId

puts "Saving as Excel file: $xlsFile"
::Excel::SaveAs $workbookId $xlsFile

if { [lindex $argv 0] eq "auto" } {
    ::Excel::Quit $appId
    exit 0
}
