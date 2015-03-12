# Copyright: 2007-2011 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

set auto_path [linsert $auto_path 0 [file join [pwd] ".."]]

set retVal [catch {package require tcomword} pkgVersion]

set appId [::Word::OpenNew false]

puts [format "%-25s: %s" "Tcl version" [info patchlevel]]
puts [format "%-25s: %s" "TcomWord version" $pkgVersion]

puts [format "%-25s: %s" "Tcom version"  [::Word::GetPkgVersion "tcom"]]
puts [format "%-25s: %s" "Twapi version" [::Word::GetPkgVersion "twapi"]]

puts [format "%-25s: %s (%s)" "Word Version" \
                             [::Word::GetVersion $appId] \
                             [::Word::GetVersion $appId true]]

puts [format "%-25s: %s" "Word filename extension" \
                             [::Word::GetExtString $appId]]

puts [format "%-25s: %s" "Active Printer" \
                        [::Word::GetActivePrinter $appId]]

puts [format "%-25s: %s" "User Name" \
                        [::Word::GetUserName $appId]]

puts [format "%-25s: %s" "Startup Pathname" \
                         [::Word::GetStartupPath $appId]]
puts [format "%-25s: %s" "Installation Pathname" \
                         [::Word::GetInstallationPath $appId]]

set docId [::Word::AddDocument $appId]

puts [format "%-30s: %s" "Appl. name (from Application)" \
         [::Word::GetApplicationName $appId]]
puts [format "%-30s: %s" "Appl. name (from Document)" \
         [::Word::GetApplicationName [::Word::GetApplicationId $docId]]]

::Word::Close $docId

if { [lindex $argv 0] eq "auto" } {
    ::Word::Quit $appId
    exit 0
}
