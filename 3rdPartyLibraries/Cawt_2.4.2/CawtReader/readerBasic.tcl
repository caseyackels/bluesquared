# Copyright: 2017-2018 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

namespace eval Reader {

    namespace ensemble create

    namespace export Open
    namespace export OpenNew
    namespace export Quit
    namespace export SetReaderProg

    variable readerProgName ""
    variable _ruffdoc

    lappend _ruffdoc Introduction {
        The Reader namespace provides commands to control Acrobat Reader.
    }

    proc _Init {} {
        variable readerProgName

        if { $readerProgName ne "" } {
            return
        }

        set readerProg ""

        # First, try to get path to Acrobat Reader from Windows registry.
        set readerProg [Cawt GetProgramByExtension ".pdf"]

        if { $readerProg eq "" } {
            set retVal [catch { package require registry } version]
            if { $retVal == 0 } {
                set keys [list \
                    {HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes\\SOFTWARE\\Abobe\\Acrobat} \
                    {HKEY_CLASSES_ROOT\\Software\\Abobe\\Acrobat}]

                foreach key $keys {
                    if { ! [catch "registry get \"$key\" Exe" result] } {
                        if { [file executable $result] } {
                            set readerProg [file normalize $result]
                            break
                        }
                    }
                }
            }
        }

        # If reading from registry did not work, try some standard installation pathes.
        if { $readerProg eq "" } {
            set acroProgs [list \
                    "C:/Program Files/Adobe/Acrobat Reader DC/Reader/AcroRd32.exe" \
                    "C:/Program Files (x86)/Adobe/Acrobat Reader DC/Reader/AcroRd32.exe" \
                    "C:/Program Files/Adobe/Reader 11.0/Reader/AcroRd32.exe" \
                    "C:/Program Files/Adobe/Reader 10.0/Reader/AcroRd32.exe"]
            foreach acroProg $acroProgs {
                if { [file executable $acroProg] } {
                    set readerProg $acroProg
                    break
                }
            }
        }

        if { $readerProg eq "" } {
            error "CawtReader: Cannot find Acrobat Reader"
        }
        set readerProgName $readerProg
    }

    proc _Start { fileName useNewInstance args } {
        variable readerProgName

        set readerOpts ""
        if { $useNewInstance } {
            append readerOpts "/n "
        }
        if { [llength $args] > 0 } {
            append readerOpts "/A \""

            foreach { key value } $args {
                switch -exact $key {
                    "-nameddest" { append readerOpts "namedest=$value"  }
                    "-page"      { append readerOpts "page=$value" }
                    "-zoom"      { append readerOpts "zoom=$value" }
                    "-pagemode"  { append readerOpts "pagemode=$value"}
                    "-search"    { append readerOpts "search=$value"}
                    "-scrollbar" { append readerOpts "scrollbar=[Cawt TclInt $value]" }
                    "-toolbar"   { append readerOpts "toolbar=[Cawt TclInt $value]" }
                    "-statusbar" { append readerOpts "statusbar=[Cawt TclInt $value]" }
                    "-messages"  { append readerOpts "messages=[Cawt TclInt $value]" }
                    "-navpanes"  { append readerOpts "navpanes=[Cawt TclInt $value]" }
                    default      { error "CawtReader: Unknown key \"$key\" specified" }
                }
                append readerOpts "&" 
            }
            append readerOpts "\""
        }
        # puts "opts=$readerOpts"

        eval exec [list $readerProgName] $readerOpts $fileName &
    }

    proc SetReaderProg { fileName } {
        # Set the path to Acrobat Reader program.
        #
        # fileName - Full path name to Acrobat Reader program AcroRd32.exe
        #
        # Use this precure, if the automatic detection of the path to 
        # Acrobat Reader does not work.
        # Note, that this procedure must be called before calling Open or OpenNew.
        #
        # No return value.
        #
        # See also: Open OpenNew

        variable readerProgName

        set readerProgName $fileName
    }

    proc OpenNew { fileName args } {
        # Open a new Acrobat Reader instance.
        #
        # fileName - File name of PDF file to open.
        # args     - List of key value pairs specifying the startup
        #            options and its values.
        #
        # For a detailled description of supported key value pairs see Open.
        #
        # No return value.
        #
        # See also: Open Quit

        Reader::_Init
        Reader::_Start $fileName true {*}$args
    }

    proc Open { fileName args } {
        # Open an Acrobat Reader instance. Use an already running instance, if available.
        #
        # fileName - File name of PDF file to open.
        # args     - List of key value pairs specifying the startup
        #            options and its values.
        #
        # Option keys:
        #
        # -nameddest
        #       Specify a named destination in the PDF document.
        # -page
        #       Specify a numbered page in the document, using an integer value. 
        #       The document’s first page has a value of 1.
        # -zoom
        #       Specify a zoom factor in percent.
        # -pagemode
        #       Specify page display mode.
        #       Valid values: bookmarks thumbs none
        # -search
        #       Open the Search panel and perform a search for the 
        #       words in the specified string. You can search only for single words.
        #       The first matching word is highlighted in the document.
        # -scrollbar
        #       Turn scrollbars on or off. Value is of type bool.
        # -toolbar
        #       Turn the toolbar on or off. Value is of type bool.
        # -statusbar
        #       Turn the status bar on or off. Value is of type bool.
        # -messages
        #       Turn document message bar on or off. Value is of type bool.
        # -navpanes
        #       Turn the navigation panes and tabs on or off. Value is of type bool.
        #
        # Note, that above described options are only a subset of all available
        # command line parameters. For a full list, see:
        # http://www.adobe.com/content/dam/Adobe/en/devnet/acrobat/pdfs/pdf_open_parameters.pdf
        #
        # No return value.
        #
        # See also: OpenNew Quit

        Reader::_Init
        Reader::_Start $fileName false {*}$args
    }

    proc Quit {} {
        # Quit all Acrobat Reader instances.
        #
        # No return value.
        #
        # See also: Open OpenNew

        variable readerProgName

        if { $readerProgName ne "" } {
            Cawt KillApp [file tail $readerProgName]
        }
    }
}
