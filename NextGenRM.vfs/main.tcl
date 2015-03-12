package require starkit
starkit::startup

starkit::autoextend [file join $starkit::topdir lib tcllib]
starkit::autoextend [file join $starkit::topdir lib tklib]

package require app-nextgenrm