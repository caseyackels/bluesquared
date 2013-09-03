# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

proc __TcomExcelSourcePkgs { dir } {
    source [file join $dir excelConst.tcl]
    source [file join $dir excelBasic.tcl]
    source [file join $dir excelUtil.tcl]
    source [file join $dir excelTablelist.tcl]
    source [file join $dir excelWord.tcl]
    source [file join $dir excelImgRaw.tcl]
    source [file join $dir excelMatlab.tcl]
    source [file join $dir excelChart.tcl]
    source [file join $dir excelCsv.tcl]
    source [file join $dir excelTestUtil.tcl]
    rename ::__TcomExcelSourcePkgs {}
}

# All modules are exported as package tcomexcel
package ifneeded tcomexcel 0.4.1 "[list __TcomExcelSourcePkgs $dir]"
