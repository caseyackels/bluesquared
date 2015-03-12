# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

set auto_path [linsert $auto_path 0 [file join [pwd] ".."]]

package require tcomexcel

set rawFile "gradient.raw"

set retVal [catch {package require img::raw} version]
if { $retVal == 0 } {
    set phImg1 [image create photo -file $rawFile \
                -format "RAW -useheader 1 -verbose 0 -nomap 0 -gamma 1"]
    pack [label .l1] -side left
    .l1 configure -image $phImg1
    wm title . "Original RAW image vs. generated RAW image \
               (Size: [image width $phImg1] x [image height $phImg1])"
    update
}

# Delete files from previous test run.
file mkdir testOut
set rawOutFile [file join [pwd] "testOut" "ExcelMatrix.raw"]
file delete -force $rawOutFile
set matOutFile [file join [pwd] "testOut" "ExcelMatrix.mat"]
file delete -force $matOutFile

set t1 [clock clicks -milliseconds]
# Transfer RAW file into a Matlab file.
set matrixList [::Excel::ReadRawImage $rawFile]
::Excel::WriteMatlab $matOutFile $matrixList
set t2 [clock clicks -milliseconds]
puts "[expr $t2 - $t1] ms to put RAW image data into a Matlab file."

set t1 [clock clicks -milliseconds]
# Transfer Matlab matrix information into a RAW image file.
set matrixList [::Excel::ReadMatlab $matOutFile]
::Excel::WriteRawImage $rawOutFile $matrixList
set t2 [clock clicks -milliseconds]
puts "[expr $t2 - $t1] ms to put Matlab matrix into Raw file."

if { $retVal == 0 } {
    set phImg2 [image create photo -file $rawOutFile \
                -format "RAW -useheader 1 -verbose 0 -nomap 0 -gamma 1"]
    pack [label .l2]
    .l2 configure -image $phImg2
}

if { [lindex $argv 0] eq "auto" } {
    exit 0
}
