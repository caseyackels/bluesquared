# Copyright: 2007-2018 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

namespace eval Excel {

    namespace ensemble create

    namespace export AddColumnChartSimple
    namespace export AddLineChart
    namespace export AddLineChartSimple
    namespace export AddPointChartSimple
    namespace export AddRadarChartSimple
    namespace export ChartObjToClipboard
    namespace export ChartToClipboard
    namespace export CreateChart
    namespace export GetChartNumSeries
    namespace export GetChartSeries
    namespace export PlaceChart
    namespace export ResizeChartObj
    namespace export SaveChartAsImage
    namespace export SaveChartObjAsImage
    namespace export SetChartMaxScale
    namespace export SetChartMinScale
    namespace export SetChartObjPosition
    namespace export SetChartObjSize
    namespace export SetChartScale
    namespace export SetChartSize
    namespace export SetChartSourceByIndex
    namespace export SetChartTicks
    namespace export SetChartTitle
    namespace export SetSeriesLineWidth

    proc ChartToClipboard { chartId } {
        # Obsolete: Replaced with ChartObjToClipboard in version 1.0.1

        Excel ChartObjToClipboard $chartId
    }

    proc ChartObjToClipboard { chartObjId } {
        # Copy a chart object to the clipboard.
        #
        # chartObjId - Identifier of the chart object.
        #
        # The chart object is stored in the clipboard as a Windows bitmap file (CF_DIB).
        #
        # No return value.
        #
        # See also: SaveChartObjAsImage CreateChart

        variable excelVersion

        # CopyPicture does not work with Excel 2007. It only copies
        # Metafiles into the clipboard.
        if { $excelVersion >= 12.0 } {
            set chartArea [$chartObjId ChartArea]
            $chartArea Copy
            Cawt Destroy $chartArea
        } else {
            $chartObjId CopyPicture $Excel::xlScreen $Excel::xlBitmap $Excel::xlScreen
        }
    }

    proc SaveChartAsImage { chartId fileName { filterType "GIF" } } {
        # Obsolete: Replaced with SaveChartObjAsImage in version 1.0.1

        Excel SaveChartObjAsImage $chartId $fileName $filterType
    }

    proc SaveChartObjAsImage { chartObjId fileName { filterType "GIF" } } {
        # Save a chart as an image in a file.
        #
        # chartObjId - Identifier of the chart object.
        # fileName   - Image file name.
        # filterType - Name of graphic filter. Possible values: GIF, JPEG, PNG.
        #
        # No return value.
        #
        # See also: ChartObjToClipboard CreateChart

        set fileName [file nativename $fileName]
        $chartObjId Export $fileName $filterType
    }

    proc SetChartObjPosition { chartObjId left top } {
        # Set the position of a chart object.
        #
        # chartObjId - Identifier of the chart object.
        # left       - Left border of the chart object in pixel.
        # top        - Top border of the chart object in pixel.
        #
        # No return value.
        #
        # See also: PlaceChart SetChartObjSize SetChartScale

        set chart [$chartObjId Parent]
        $chart Left $left
        $chart Top  $top
        Cawt Destroy $chart
    }

    proc SetChartSize { worksheetId chartId width height } {
        # Obsolete: Replaced with SetChartObjSize in version 1.0.1

        Excel SetChartObjSize $worksheetId $chartId $width $height
    }

    proc SetChartObjSize { chartObjId width height } {
        # Set the size of a chart object.
        #
        # chartObjId - Identifier of the chart object.
        # width      - Width of the chart object in pixel.
        # height     - Height of the chart object in pixel.
        #
        # No return value.
        #
        # See also: PlaceChart SetChartObjPosition SetChartScale

        # This is also an Excel mystery. After setting the width and height
        # to the correct size (i.e. use width and height unchanged), Excel
        # says, it has changed the shape to the correct size.
        # But the diagram as displayed and also the exported bitmap has a
        # size 4/3 greater than expected.
        # We correct for that discrepancy here by multiplying with 3/4.

        set chart [$chartObjId Parent]
        $chart Width  [expr {$width  * 0.75}]
        $chart Height [expr {$height * 0.75}]
        Cawt Destroy $chart
    }

    proc ResizeChartObj { chartObjId rangeId } {
        # Set the position and size of a chart object.
        #
        # chartObjId - Identifier of the chart object.
        # rangeId    - Identifier of the cell range.
        #
        # Resize the chart object so that it fits into the specified cell range.
        #
        # No return value.
        #
        # See also: PlaceChart SetChartObjSize SetChartObjPosition SelectRangeByString

        set chart [$chartObjId Parent]
        $chart Width  [$rangeId Width]
        $chart Height [$rangeId Height]
        $chart Left   [$rangeId Left]
        $chart Top    [$rangeId Top]
        Cawt Destroy $chart
    }

    proc GetChartNumSeries { chartId } {
        # Return the number of series of a chart.
        #
        # chartId - Identifier of the chart.
        #
        # See also: GetChartSeries CreateChart

        return [$chartId -with { SeriesCollection } Count]
    }

    proc GetChartSeries { chartId index } {
        # Get a specific series of a chart.
        #
        # chartId - Identifier of the chart.
        # index   - Index of the series. Index numbering starts with 1.
        #
        # Return the series identifier.
        #
        # See also: GetChartNumSeries CreateChart SetSeriesLineWidth

        return [$chartId -with { SeriesCollection } Item [expr {int($index)}]]
    }

    proc SetSeriesLineWidth { seriesId width } {
        # Set the line width of a series.
        #
        # seriesId - Identifier of the series.
        # width    - Line width.
        #
        # No return value.
        #
        # See also: GetChartNumSeries GetChartSeries SetSeriesLineWidth

        $seriesId -with { Format Line } Weight [expr {int($width)}]
    }

    proc SetChartMinScale { chartId axisName value } {
        # Set the minimum scale of an axis of a chart.
        #
        # chartId  - Identifier of the chart.
        # axisName - Name of axis. Possible values: "x" or "y".
        # value    - Scale value.
        #
        # No return value.
        #
        # See also: SetChartMaxScale SetChartScale SetChartObjSize

        if { $axisName eq "x" || $axisName eq "X" } {
            set axis [$chartId -with { Axes } Item $Excel::xlPrimary]
        } else {
            set axis [$chartId -with { Axes } Item $Excel::xlSecondary]
        }
        $axis MinimumScale [expr {$value}]
        Cawt Destroy $axis
    }

    proc SetChartMaxScale { chartId axisName value } {
        # Set the maximum scale of an axis of a chart.
        #
        # chartId  - Identifier of the chart.
        # axisName - Name of axis. Possible values: "x" or "y".
        # value    - Scale value.
        #
        # No return value.
        #
        # See also: SetChartMinScale SetChartScale SetChartObjSize

        if { $axisName eq "x" || $axisName eq "X" } {
            set axis [$chartId -with { Axes } Item $Excel::xlPrimary]
        } else {
            set axis [$chartId -with { Axes } Item $Excel::xlSecondary]
        }
        $axis MaximumScale [expr {$value}]
        Cawt Destroy $axis
    }

    proc SetChartScale { chartId xmin xmax ymin ymax } {
        # Set the minimum and maximum scale of both axes of a chart.
        #
        # chartId - Identifier of the chart.
        # xmin    - Minimum scale value of x axis.
        # xmax    - Maximum scale value of x axis.
        # ymin    - Minimum scale value of y axis.
        # ymax    - Maximum scale value of y axis.
        #
        # No return value.
        #
        # See also: SetChartMinScale SetChartMaxScale SetChartObjSize

        Excel SetChartMinScale $chartId "x" $xmin
        Excel SetChartMaxScale $chartId "x" $xmax
        Excel SetChartMinScale $chartId "y" $ymin
        Excel SetChartMaxScale $chartId "y" $ymax
    }

    proc SetChartTicks { chartId axisName { tickMarkSpacing "" } { tickLabelSpacing "" } } {
        # Set the tick spacing of an axis of a chart.
        #
        # chartId          - Identifier of the chart.
        # axisName         - Name of axis. Possible values: "x" or "y".
        # tickMarkSpacing  - Spacing of tick marks.
        # tickLabelSpacing - Spacing of tick labels.
        #
        # If spacing values are not specified or the emtpy string, the 
        # corresponding spacing uses the default values, which are automatically
        # determined by Excel.
        #
        # No return value.
        #
        # See also: SetChartMaxScale SetChartScale SetChartObjSize

        if { $axisName eq "x" || $axisName eq "X" } {
            set axis [$chartId -with { Axes } Item $Excel::xlPrimary]
        } else {
            set axis [$chartId -with { Axes } Item $Excel::xlSecondary]
        }
        if { $tickMarkSpacing ne "" } {
            $axis TickMarkSpacing [expr {int($tickMarkSpacing)}]
        }
        if { $tickLabelSpacing ne "" } {
            $axis TickLabelSpacing [expr {int($tickLabelSpacing)}]
        }
        Cawt Destroy $axis
    }

    proc SetChartTitle { chartId title } {
        # Set the title of a chart.
        #
        # chartId - Identifier of the chart.
        # title   - Name of the chart title.
        #
        # No return value.
        #
        # See also: SetChartMinScale SetChartScale CreateChart

        if { $title eq "" } {
            $chartId HasTitle [Cawt TclBool false]
        } else {
            $chartId HasTitle [Cawt TclBool true]
            $chartId -with { ChartTitle Characters } Text $title
        }
    }

    proc SetChartSourceByIndex { chartId worksheetId row1 col1 row2 col2 { type xlColumns } } {
        # Set the cell range for the source of a chart.
        #
        # chartId     - Identifier of the chart.
        # worksheetId - Identifier of the worksheet.
        # row1        - Row number of upper-left corner of the cell range.
        # col1        - Column number of upper-left corner of the cell range.
        # row2        - Row number of lower-right corner of the cell range.
        # col2        - Column number of lower-right corner of the cell range.
        # type        - Value of enumeration type XlRowCol (see excelConst.tcl). 
        #
        # No return value.
        #
        # See also: CreateChart SetChartTitle SetChartScale

        set rangeId [Excel SelectRangeByIndex $worksheetId $row1 $col1 $row2 $col2]
        $chartId SetSourceData $rangeId [Excel GetEnum $type]
        Cawt Destroy $rangeId
    }

    proc PlaceChart { chartId worksheetId } {
        # Place an existing chart into a worksheet.
        #
        # chartId     - Identifier of the chart.
        # worksheetId - Identifier of the worksheet.
        #
        # Return the ChartObject identifier of the placed chart.
        #
        # See also: CreateChart SetChartObjSize SetChartObjPosition

        set newChartId [$chartId Location $Excel::xlLocationAsObject \
                        [Excel GetWorksheetName $worksheetId]]
        return $newChartId
    }

    proc CreateChart { worksheetId chartType } {
        # Create a new empty chart in a worksheet.
        #
        # worksheetId - Identifier of the worksheet.
        # chartType   - Value of enumeration type XlChartType (see excelConst.tcl).
        #
        # Return the identifier of the new chart.
        #
        # See also: PlaceChart AddLineChart AddLineChartSimple AddPointChartSimple AddRadarChartSimple

        set cellsId [Excel GetCellsId $worksheetId]
        set appId [Office GetApplicationId $cellsId]

        switch [Excel GetVersion $appId] {
            "12.0" {
                set chartId [[[$worksheetId Shapes] AddChart [Excel GetEnum $chartType]] Chart]
            }
            default {
                set chartId [$appId -with { Charts } Add]
                $chartId ChartType $chartType
            }
        }
        Cawt Destroy $cellsId
        Cawt Destroy $appId
        return $chartId
    }

    proc AddLineChart { worksheetId headerRow xaxisCol startRow numRows startCol numCols \
                       { title "" } { yaxisName "Values" } { markerSize 5 } } {
        # Add a line chart to a worksheet. Generic case.
        #
        # worksheetId - Identifier of the worksheet.
        # headerRow   - Row containing names for the lines.
        # xaxisCol    - Data for the x-axis is taken from this column.
        # startRow    - Starting row for data of x-axis.
        # numRows     - Number of rows used as data of x-axis.
        # startCol    - Column in header from which names start.
        # numCols     - Number of columns to use for the chart.
        # title       - String used as title of the chart.
        # yaxisName   - Name of y-axis.
        # markerSize  - Size of marker.
        #
        # The data range for the "numCols" lines starts at (startRow, startCol)
        # and goes to (startRow+numRows-1, startCol+numCols-1).
        #
        # markerSize must be between 2 and 72.
        #
        # Return the identifier of the added chart.
        #
        # See also: CreateChart AddLineChartSimple AddPointChartSimple AddRadarChartSimple

        if { $markerSize < 2 || $markerSize > 72 } {
            error "AddLineChart: Valid marker size is between 2 and 72."
        }

        set chartId [Excel CreateChart $worksheetId $Excel::xlLineMarkers]

        # Select the range of data.
        Excel SetChartSourceByIndex $chartId $worksheetId $startRow $startCol \
                                    [expr {$startRow+$numRows-1}] [expr {$startCol+$numCols-1}]

        # Select the column containing the data for the x-axis.
        set xrangeId [Excel SelectRangeByIndex $worksheetId $startRow $xaxisCol \
                      [expr {$startRow+$numRows-1}] $xaxisCol]

        # Set the x-axis, name and marker size for each line.
        for { set i 1 } { $i <= $numCols } { incr i } {
            set series [GetChartSeries $chartId $i]
            set name   [Excel GetCellValue $worksheetId $headerRow [expr {$startCol+$i-1}]]
            $series Name       $name
            $series XValues    $xrangeId
            $series MarkerSize $markerSize
            Cawt Destroy $series
        }
        Cawt Destroy $xrangeId

        # Set the names for the x-axis and the y-axis.
        set axis [$chartId -with { Axes } Item $Excel::xlPrimary]
        $axis HasTitle True
        $axis -with { AxisTitle Characters } Text \
              [Excel GetCellValue $worksheetId $headerRow $xaxisCol]
        Cawt Destroy $axis

        set axis [$chartId -with { Axes } Item $Excel::xlSecondary]
        $axis HasTitle True
        $axis -with { AxisTitle Characters } Text $yaxisName
        Cawt Destroy $axis

        # Set the chart title.
        Excel SetChartTitle $chartId $title

        # Do not fill the chart interior area. Better for printing.
        $chartId -with { PlotArea Interior } ColorIndex [expr $Excel::xlColorIndexNone]

        return $chartId
    }

    proc AddLineChartSimple { worksheetId numRows numCols \
                              { title "" } { yaxisName "Values" } { markerSize 5 } } {
        # Add a line chart to a worksheet. Simple case.
        #
        # worksheetId - Identifier of the worksheet.
        # numRows     - Number of rows used as data of x-axis.
        # numCols     - Number of rows used as data of y-axis.
        # title       - String used as title of the chart.
        # yaxisName   - Name of y-axis.
        # markerSize  - Size of marker.
        #
        # Data for the x-axis is taken from column 1, starting at row 2.
        # Names for the lines are taken from row 1, starting at column 2.
        # The data range for the "numCols" lines starts at (2, 2)
        # and goes to (numRows+1, numCols+1).
        #
        # Return the identifier of the added chart.
        #
        # See also: CreateChart AddLineChart AddPointChartSimple AddRadarChartSimple

        return [Excel AddLineChart $worksheetId 1 1  2 $numRows  2 $numCols \
                                   $title $yaxisName $markerSize]
    }

    proc AddPointChartSimple { worksheetId numRows col1 col2 { title "" } { markerSize 5 } } {
        # Add a point chart to a worksheet. Simple case.
        #
        # worksheetId - Identifier of the worksheet.
        # numRows     - Number of rows beeing used for the chart.
        # col1        - Start column of the chart data.
        # col2        - End column of the chart data.
        # title       - String used as title of the chart.
        # markerSize  - Size of the point marker.
        #
        # Data for the x-axis is taken from column "col1", starting at row 2.
        # Data for the y-axis is taken from column "col2", starting at row 2.
        # Names for the axes are taken from row 1, columns "col1" and "col2".
        #
        # Return the identifier of the added chart.
        #
        # See also: CreateChart AddLineChart AddLineChartSimple AddRadarChartSimple

        set chartId [Excel CreateChart $worksheetId $Excel::xlXYScatter]

        # Select the range of cells to be used as data.
        # Data of col1 is the X axis. Data of col2 is the Y axis.
        Excel SetChartSourceByIndex $chartId $worksheetId 2 $col2 [expr {$numRows+1}] $col2

        set series [GetChartSeries $chartId 1]
        set xrangeId [Excel SelectRangeByIndex $worksheetId 2 $col1 [expr {$numRows+1}] $col1]
        $series XValues    $xrangeId
        $series MarkerSize $markerSize
        Cawt Destroy $xrangeId
        Cawt Destroy $series

        # Set chart specific properties.
        # Switch of legend display.
        $chartId HasLegend False

        # Set the chart title string.
        Excel SetChartTitle $chartId $title

        # Do not fill the chart interior area. Better for printing.
        $chartId -with { PlotArea Interior } ColorIndex [expr $Excel::xlColorIndexNone]

        # Set axis specific properties.
        # Set the X axis description to cell col1 in row 1.
        set axis [$chartId -with { Axes } Item $Excel::xlPrimary]
        $axis HasTitle True
        $axis -with { AxisTitle Characters } Text [Excel GetCellValue $worksheetId 1 $col1]
        # Set the display of major and minor gridlines.
        $axis HasMajorGridlines True
        $axis HasMinorGridlines False
        Cawt Destroy $axis

        # Set the Y axis description to cell col2 in row 1.
        set axis [$chartId -with { Axes } Item $Excel::xlSecondary]
        $axis HasTitle True
        $axis -with { AxisTitle Characters } Text [Excel GetCellValue $worksheetId 1 $col2]
        # Set the display of major and minor gridlines.
        $axis HasMajorGridlines True
        $axis HasMinorGridlines False
        Cawt Destroy $axis

        return $chartId
    }

    proc AddColumnChartSimple { worksheetId numRows numCols { title "" } } {
        # Add a clustered column chart to a worksheet. Simple case.
        #
        # worksheetId - Identifier of the worksheet.
        # numRows     - Number of rows beeing used for the chart.
        # numCols     - Number of columns beeing used for the chart.
        # title       - String used as title of the chart.
        #
        # Data for the x-axis is taken from column 1, starting at row 2.
        # Names for the lines are taken from row 1, starting at column 2.
        # The data range for the "numCols" plots starts at (2, 2) and goes
        # to (numRows+1, numCols+1).
        #
        # Return the identifier of the added chart.
        #
        # See also: CreateChart AddLineChart AddLineChartSimple AddPointChartSimple

        set chartId [Excel CreateChart $worksheetId $Excel::xlColumnClustered]

        # Select the range of cells to be used as data.
        Excel SetChartSourceByIndex $chartId $worksheetId 2 2 [expr {$numRows+1}] [expr {$numCols+1}]

        set xrangeId [Excel SelectRangeByIndex $worksheetId 2 1 [expr {$numRows+1}] 1]
        for { set i 1 } { $i <= $numCols } { incr i } {
            set series [GetChartSeries $chartId $i]
            set name [Excel GetCellValue $worksheetId 1 [expr {$i +1}]]
            $series Name    $name
            $series XValues $xrangeId
            Cawt Destroy $series
        }
        Cawt Destroy $xrangeId

        # Set chart specific properties.
        # Switch on legend display.
        $chartId HasLegend True

        # Set the chart title string.
        Excel SetChartTitle $chartId $title

        # Do not fill the chart interior area. Better for printing.
        $chartId -with { PlotArea Interior } ColorIndex [expr $Excel::xlColorIndexNone]

        # Set axis specific properties.
        set axis [$chartId -with { Axes } Item $Excel::xlPrimary]
        # Set the display of major and minor gridlines.
        $axis HasMajorGridlines False
        $axis HasMinorGridlines False
        Cawt Destroy $axis

        set axis [$chartId -with { Axes } Item $Excel::xlSecondary]
        # Set the display of major and minor gridlines.
        $axis HasMajorGridlines True
        $axis HasMinorGridlines False
        Cawt Destroy $axis

        return $chartId
    }

    proc AddRadarChartSimple { worksheetId numRows numCols { title "" } } {
        # Add a radar chart to a worksheet. Simple case.
        #
        # worksheetId - Identifier of the worksheet.
        # numRows     - Number of rows beeing used for the chart.
        # numCols     - Number of columns beeing used for the chart.
        # title       - String used as title of the chart.
        #
        # Data for the x-axis is taken from column 1, starting at row 2.
        # Names for the lines are taken from row 1, starting at column 2.
        # The data range for the "numCols" plots starts at (2, 2) and goes
        # to (numRows+1, numCols+1).
        #
        # Return the identifier of the added chart.
        #
        # See also: CreateChart AddLineChart AddLineChartSimple AddPointChartSimple

        set chartId [Excel CreateChart $worksheetId $Excel::xlRadarFilled]

        # Select the range of cells to be used as data.
        Excel SetChartSourceByIndex $chartId $worksheetId 2 2 [expr {$numRows+1}] [expr {$numCols+1}]

        set xrangeId [SelectRangeByIndex $worksheetId 2 1 [expr {$numRows+1}] 1]
        for { set i 1 } { $i <= $numCols } { incr i } {
            set series [GetChartSeries $chartId $i]
            set name [GetCellValue $worksheetId 1 [expr {$i +1}]]
            $series Name    $name
            $series XValues $xrangeId
            Cawt Destroy $series
        }
        Cawt Destroy $xrangeId

        # Set chart specific properties.
        # Switch on legend display.
        $chartId HasLegend True

        # Set the chart title string.
        Excel SetChartTitle $chartId $title

        # Do not fill the chart interior area. Better for printing.
        $chartId -with { PlotArea Interior } ColorIndex [expr $Excel::xlColorIndexNone]

        # Set axis specific properties.
        set axis [$chartId -with { Axes } Item $Excel::xlPrimary]
        # Set the display of major and minor gridlines.
        $axis HasMajorGridlines False
        $axis HasMinorGridlines False
        Cawt Destroy $axis

        set axis [$chartId -with { Axes } Item $Excel::xlSecondary]
        # Set the display of major and minor gridlines.
        $axis HasMajorGridlines True
        $axis HasMinorGridlines False
        Cawt Destroy $axis

        return $chartId
    }
}
