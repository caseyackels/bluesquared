# Copyright: 2007-2018 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

namespace eval Cawt {

    namespace ensemble create

    namespace export IsoDateToSeconds
    namespace export XmlDateToSeconds
    namespace export OutlookDateToSeconds

    namespace export SecondsToIsoDate
    namespace export SecondsToXmlDate
    namespace export SecondsToOutlookDate

    namespace export IsoDateToXmlDate
    namespace export XmlDateToIsoDate

    namespace export IsoDateToOutlookDate
    namespace export OutlookDateToIsoDate

    # Reference for calculating Outlook days into Tcl seconds.
    set sOutlookDate(Day) 42942.0
    set sOutlookDate(Sec) 1501020000
    set sOutlookDate(Iso) "2017-07-26 00:00:00"

    proc IsoDateToSeconds { isoDate } {
        # Return ISO date string as seconds.
        #
        # isoDate - Date string in format %Y-%m-%d %H:%M:%S
        #
        # Return corresponding seconds as integer.
        #
        # See also: SecondsToIsoDate XmlDateToSeconds OutlookDateToSeconds

        return [clock scan $isoDate -format {%Y-%m-%d %H:%M:%S}]
    }

    proc XmlDateToSeconds { xmlDate } {
        # Return XML date string as seconds.
        #
        # xmlDate - Date string in format %Y-%m-%dT%H:%M:%S.000Z
        #
        # Return corresponding seconds as integer.
        #
        # See also: SecondsToXmlDate IsoDateToSeconds OutlookDateToSeconds

        return [clock scan $xmlDate -format {%Y-%m-%dT%H:%M:%S.000Z}]
    }

    proc OutlookDateToSeconds { outlookDate } {
        # Return Outlook date as seconds.
        #
        # outlookDate - Floating point number representing days since 1900/01/01.
        #
        # Return corresponding seconds as integer.
        #
        # See also: SecondsToOutlookDate IsoDateToSeconds XmlDateToSeconds

        variable sOutlookDate

        set diffDays [expr { $outlookDate - $sOutlookDate(Day) }]
        return [expr { $sOutlookDate(Sec) + int ($diffDays * 60.0 * 60.0 * 24.0) }]
    }

    proc SecondsToIsoDate { sec } {
        # Return date in seconds as ISO date string.
        #
        # sec - Date in seconds (as returned by clock seconds).
        #
        # Return corresponding date as ISO date string.
        #
        # See also: IsoDateToSeconds SecondsToXmlDate SecondsToOutlookDate

        return [clock format $sec -format {%Y-%m-%d %H:%M:%S}]
    }

    proc SecondsToXmlDate { sec } {
        # Return date in seconds as XML date string.
        #
        # sec - Date in seconds (as returned by clock seconds).
        #
        # Return corresponding date as XML date string.
        #
        # See also: XmlDateToSeconds SecondsToIsoDate SecondsToOutlookDate

        return [clock format $sec -format {%Y-%m-%dT%H:%M:%S.000Z}]
    }

    proc SecondsToOutlookDate { sec } {
        # Return date in seconds as Outlook date.
        #
        # sec - Date in seconds (as returned by clock seconds).
        #
        # Return corresponding date as floating point number
        # representing days since 1900/01/01.
        #
        # See also: OutlookDateToSeconds SecondsToIsoDate SecondsToXmlDate

        variable sOutlookDate

        set diffSecs [expr { $sec - $sOutlookDate(Sec) }]
        return [expr { $sOutlookDate(Day) + $diffSecs / 60.0 / 60.0 / 24.0 }]
    }

    proc XmlDateToIsoDate { xmlDate } {
        # Return XML date string as ISO date string.
        #
        # xmlDate - Date string in format %Y-%m-%dT%H:%M:%S.000Z
        #
        # Return corresponding date as ISO date string.
        #
        # See also: IsoDateToXmlDate XmlDateToSeconds

        return [SecondsToIsoDate [XmlDateToSeconds $xmlDate]]
    }

    proc OutlookDateToIsoDate { outlookDate } {
        # Return Outlook date as ISO date string.
        #
        # outlookDate - Floating point number representing days since 1900/01/01.
        #
        # Return corresponding date as ISO date string.
        #
        # See also: IsoDateToOutlookDate OutlookDateToSeconds

        return [SecondsToIsoDate [OutlookDateToSeconds $outlookDate]]
    }

    proc IsoDateToXmlDate { isoDate } {
        # Return ISO date string as XML date string.
        #
        # isoDate - Date string in format %Y-%m-%d %H:%M:%S
        #
        # Return corresponding date as XML date string.
        #
        # See also: XmlDateToIsoDate IsoDateToSeconds IsoDateToOutlookDate

        return [SecondsToXmlDate [IsoDateToSeconds $isoDate]]
    }

    proc IsoDateToOutlookDate { isoDate } {
        # Return ISO date string as Outlook date.
        #
        # isoDate - Date string in format %Y-%m-%d %H:%M:%S
        #
        # Return corresponding date as floating point number
        # representing days since 1900/01/01.
        #
        # See also: OutlookDateToIsoDate IsoDateToSeconds IsoDateToXmlDate

        return [SecondsToOutlookDate [IsoDateToSeconds $isoDate]]
    }
}
