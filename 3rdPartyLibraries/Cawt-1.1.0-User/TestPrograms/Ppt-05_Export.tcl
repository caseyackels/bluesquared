# Test CawtPpt procedures for exporting a PowerPoint presentation as HTML slide show.
#
# Copyright: 2007-2014 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

source "SetTestPathes.tcl"
package require cawt

set appId [::Ppt::Open]

set inFile [file join [pwd] ".." "Documentation" "UserManual" "CawtFigures.ppt"]
set outDir [file join [pwd] "testOut" "Ppt-05_Export"]

# Delete export files from previous test run.
file mkdir testOut
file delete -force $outDir

# ExportPptFile pptFile outputDir outputFileFmt startIndex endIndex
#               imgType width height useMaster genHtmlTable thumbsPerRow thumbSize
::Ppt::ExportPptFile $inFile $outDir "Slide-%02d.gif" 1 end \
                     "GIF" 1000 700 false true 3 250

::Cawt::Destroy
exit 0
