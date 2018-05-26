# Copyright: 2007-2018 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

namespace eval Outlook {

    namespace ensemble create

    namespace export AddAppointment
    namespace export AddCalendar
    namespace export AddCategory
    namespace export AddHolidayAppointment
    namespace export ApplyHolidayFile
    namespace export CreateMail
    namespace export CreateHtmlMail
    namespace export DeleteAppointmentByIndex
    namespace export DeleteCalendar
    namespace export DeleteCategory
    namespace export GetAppointmentByIndex
    namespace export GetAppointmentProperties
    namespace export GetCalendarId
    namespace export GetCalendarNames
    namespace export GetCategoryId
    namespace export GetCategoryNames
    namespace export GetMailIds
    namespace export GetMailSubjects
    namespace export GetNumAppointments
    namespace export GetNumCalendars
    namespace export GetNumCategories
    namespace export GetVersion
    namespace export HaveCalendar
    namespace export HaveCategory
    namespace export Open
    namespace export OpenNew
    namespace export Quit
    namespace export ReadHolidayFile
    namespace export SendMail

    variable outlookVersion "0.0"
    variable outlookAppName "Outlook.Application"
    variable _ruffdoc

    lappend _ruffdoc Introduction {
        The Outlook namespace provides commands to control Microsoft Outlook.
    }

    proc GetVersion { objId { useString false } } {
        # Get the version of an Outlook application.
        #
        # objId     - Identifier of an Outlook object instance.
        # useString - true: Return the version name (ex. "Outlook 2000").
        #             false: Return the version number (ex. "9.0").
        #
        # Returns the version of an Outlook application.
        #
        # Both version name and version number are returned as strings.
        # Version number is in a format, so that it can be evaluated as a
        # floating point number.
        #
        # See also: Open

        array set map {
            "7.0"  "Outlook 95"
            "8.0"  "Outlook 97"
            "9.0"  "Outlook 2000"
            "10.0" "Outlook 2002"
            "11.0" "Outlook 2003"
            "12.0" "Outlook 2007"
            "14.0" "Outlook 2010"
            "15.0" "Outlook 2013"
            "16.0" "Outlook 2016"
        }
        set versionString [Office GetApplicationVersion $objId]

        set members [split $versionString "."]
        set version "[lindex $members 0].[lindex $members 1]"
        if { $useString } {
            if { [info exists map($version)] } {
                return $map($version)
            } else {
                return "Unknown Outlook version $version"
            }
        } else {
            return $version
        }
    }

    proc Open { { explorerType "olFolderInbox" } } {
        # Open an Outlook instance.
        #
        # explorerType - Value of enumeration type OlDefaultFolders (see outlookConst.tcl).
        #                Typical values are: olFolderCalendar, olFolderInbox, olFolderTasks.
        #
        # Returns the identifier of the Outlook application instance.
        #
        # See also: OpenNew Quit

        variable outlookAppName
	variable outlookVersion

        set appId [Cawt GetOrCreateApp $outlookAppName true]
        set outlookVersion [Outlook GetVersion $appId]

        set explorers [$appId Explorers]
        if { $explorerType ne "" && ! [Cawt IsComObject [$appId ActiveExplorer]] } {
            set nsObj [$appId GetNamespace "MAPI"]
            set myFolder [$nsObj GetDefaultFolder [Outlook GetEnum $explorerType]]
            set myExplorer [$explorers Add $myFolder $Outlook::olFolderDisplayNormal]
            $myExplorer Display
            Cawt Destroy $myExplorer
            Cawt Destroy $myFolder
            Cawt Destroy $nsObj
        }
        Cawt Destroy $explorers
        return $appId
    }

    proc OpenNew { { explorerType "olFolderInbox" } } {
        # Obsolete: Replaced with Open in version 2.4.1

        return [Outlook::Open $explorerType]
    }

    proc Quit { appId { showAlert true } } {
        # Quit an Outlook instance.
        #
        # appId     - Identifier of the Outlook instance.
        # showAlert - true: Show an alert window, if there are unsaved changes.
        #             false: Quit without saving any changes.
        #
        # No return value.
        #
        # See also: Open OpenNew

        if { ! $showAlert } {
            Office ShowAlerts $appId false
        }
        $appId Quit
    }

    proc _CreateMail { appId mailType recipientList { subject "" } { body "" } { attachmentList {} } } {
        set mailId [$appId CreateItem $Outlook::olMailItem]

        $mailId Display
        foreach recipient $recipientList {
            $mailId -with { Recipients } Add $recipient
        }
        if { $mailType eq "text" } {
            set sig [$mailId Body]
            $mailId Body [format "%s\n%s" $body $sig]
        } else {
            set sig [$mailId HtmlBody]
            $mailId HtmlBody [format "%s %s" $body $sig]
        }
        $mailId Subject $subject
        foreach attachment $attachmentList {
            $mailId -with { Attachments } Add [file nativename [file normalize $attachment]]
        }
        return $mailId
    }

    proc CreateMail { appId recipientList { subject "" } { body "" } { attachmentList {} } } {
        # Create a new Outlook text mail.
        #
        # appId          - Identifier of the Outlook instance.
        # recipientList  - List of mail addresses.
        # subject        - Subject text.
        # body           - Mail body text.
        # attachmentList - List of files used as attachment.
        #
        # Returns the identifier of the new mail object.
        #
        # See also: CreateHtmlMail SendMail

        return [Outlook::_CreateMail $appId "text" $recipientList $subject $body $attachmentList]
    }

    proc CreateHtmlMail { appId recipientList { subject "" } { body "" } { attachmentList {} } } {
        # Create a new Outlook HTML mail.
        #
        # appId          - Identifier of the Outlook instance.
        # recipientList  - List of mail addresses.
        # subject        - Subject text.
        # body           - Mail body text in HTML format.
        # attachmentList - List of files used as attachment.
        #
        # Returns the identifier of the new mail object.
        #
        # See also: CreateMail SendMail

        return [Outlook::_CreateMail $appId "html" $recipientList $subject $body $attachmentList]
    }

    proc SendMail { mailId } {
        # Send an Outlook mail.
        #
        # mailId - Identifier of the Outlook mail object.
        #
        # No return value.
        #
        # See also: CreateMail CreateHtmlMail

        $mailId Send
    }

    proc GetMailIds { appId } {
        # Get a list of mail identifiers.
        #
        # appId - Identifier of the Outlook instance.
        #
        # Returns a list of mail identifiers.
        #
        # See also: GetMailSubjects CreateMail SendMail 

        set idList [list]
        foreach { name folderId } [Outlook::GetFoldersRecursive $appId $Outlook::olMailItem] {
            set numItems [$folderId -with { Items } Count]
            if { $numItems > 0 } {
                for { set i 1 } { $i <= $numItems } { incr i } {
                    lappend idList [$folderId -with { Items } Item $i]
                }
            }
        }
        return $idList
    }

    proc GetMailSubjects { appId } {
        # Get a list of mail subjects.
        #
        # appId - Identifier of the Outlook instance.
        #
        # Returns a list of mail subjects.
        #
        # See also: GetMailIds CreateMail SendMail 

        set subjectList [list]
        foreach { name folderId } [Outlook::GetFoldersRecursive $appId $Outlook::olMailItem] {
            set numItems [$folderId -with { Items } Count]
            if { $numItems > 0 } {
                for { set i 1 } { $i <= $numItems } { incr i } {
                    set mailId [$folderId -with { Items } Item $i]
                    lappend subjectList [$mailId Subject]
                    Cawt Destroy $mailId
                }
            }
        }
        return $subjectList
    }

    proc _GetFoldersRecursive { node type trashPath } {
        variable sFolderList

        set numFolders [$node -with {Folders} Count]
        for { set i 1 } { $i <= $numFolders } { incr i } {
            set folderId   [$node -with {Folders} Item [expr {$i}]]
            set folderName [$folderId Name]
            set folderType [$folderId DefaultItemType]
            # puts "Folder \"$folderName\" [Outlook GetEnumName OlItemType $folderType] [$folderId FolderPath]"
            if { $type == $folderType } {
                set sFolderList($folderName) $folderId
            }
            # Only traverse, if folder is not the trash folder.
            if { [$folderId FolderPath] ne $trashPath } {
                Outlook::_GetFoldersRecursive $folderId $type $trashPath
            }
        }
    }

    proc GetFoldersRecursive { appId type } {
        variable sFolderList

        set nsObj [$appId GetNamespace "MAPI"]
        if { [info exists sFolderList] } {
            foreach name [array names sFolderList] {
                if { [Cawt IsComObject $sFolderList($name)] } {
                    Cawt Destroy $sFolderList($name)
                }
            }
            unset sFolderList
        }
        set folderList [list]
        set trashPath [[$nsObj GetDefaultFolder $Outlook::olFolderDeletedItems] FolderPath]
        Outlook::_GetFoldersRecursive $nsObj $type $trashPath

        foreach name [lsort -dictionary [array names sFolderList]] {
            lappend folderList $name $sFolderList($name)
        }
        Cawt Destroy $nsObj
        return $folderList
    }

    proc GetCalendarNames { appId } {
        # Get a list of calendar names.
        #
        # appId - Identifier of the Outlook instance.
        #
        # Returns a list of calendar names.
        #
        # See also: GetNumCalendars HaveCalendar GetCalendarId AddCalendar DeleteCalendar

        set calendarNameList [list]
        foreach { name calId } [Outlook::GetFoldersRecursive $appId $Outlook::olAppointmentItem] {
            lappend calendarNameList $name
        }
        return $calendarNameList
    }

    proc GetNumCalendars { appId } {
        # Get the number of Outlook calendars.
        #
        # appId - Identifier of the Outlook instance.
        #
        # Returns the number of Outlook calendars.
        #
        # See also: HaveCalendar GetCalendarNames GetCalendarId AddCalendar DeleteCalendar

        return [llength [Outlook::GetCalendarNames $appId]]
    }

    proc HaveCalendar { appId calendarName } {
        # Check, if a calendar already exists.
        #
        # appId        - Identifier of the Outlook instance.
        # calendarName - Name of the calendar to check.
        #
        # Returns true, if the calendar exists, otherwise false.
        #
        # See also: GetNumCalendars GetCalendarNames GetCalendarId AddCalendar DeleteCalendar

        if { [lsearch -exact [Outlook::GetCalendarNames $appId] $calendarName] >= 0 } {
            return true
        } else {
            return false
        }
    }

    proc GetCalendarId { appId { calendarName "" } } {
        # Get a calendar by its name.
        #
        # appId        - Identifier of the Outlook instance.
        # calendarName - Name of the calendar to find.
        #
        # Returns the identifier of the found calendar.
        #
        # If a calendar with given name does not exist an error is thrown.
        #
        # See also: GetNumCalendars HaveCalendar GetCalendarNames AddCalendar DeleteCalendar

        if { $calendarName eq "" } {
            set nsObj [$appId GetNamespace "MAPI"]
            set calId [$nsObj GetDefaultFolder $Outlook::olFolderCalendar]
            Cawt Destroy $nsObj
            return $calId
        }
        set foundId ""
        foreach { name calId } [Outlook::GetFoldersRecursive $appId $Outlook::olAppointmentItem] {
            if { $name eq $calendarName } {
                set foundId $calId
            } else {
                Cawt Destroy $calId
            }
        }
        return $foundId
    }

    proc AddCalendar { appId calendarName } {
        # Add a new calendar.
        #
        # appId        - Identifier of the Outlook instance.
        # calendarName - Name of the new calendar.
        #
        # Returns the identifier of the new calendar.
        #
        # If a calendar with given name is already existing, the identifier of that
        # calendar is returned.
        # If the calendar could not be added an error is thrown.
        #
        # See also: GetNumCalendars HaveCalendar GetCalendarNames GetCalendarId DeleteCalendar

        set nsObj [$appId GetNamespace "MAPI"]
        set calId [$nsObj GetDefaultFolder $Outlook::olFolderCalendar]
        set numFolders [$calId -with {Folders} Count]
        for { set i 1 } { $i <= $numFolders } { incr i } {
            set folderId [$calId -with {Folders} Item [expr {$i}]]
            if { [$folderId Name] eq $calendarName } {
                puts "Calendar $calendarName already exists"
                return $folderId
            }
            Cawt Destroy $folderId
        }
        set catchVal [catch {$calId -with { Folders } Add $calendarName $Outlook::olFolderCalendar} newCalId]
        if { $catchVal != 0 } {
            error "Could not add calendar \"$calendarName\"."
        }
        Cawt Destroy $calId
        Cawt Destroy $nsObj
        return $newCalId
    }

    proc DeleteCalendar { calId } {
        # Delete an Outlook calendar.
        #
        # calId - Identifier of the Outlook calendar.
        #
        # No return value.
        #
        # See also: GetNumCalendars HaveCalendar GetCalendarNames GetCalendarId AddCalendar
        $calId Delete
    }

    proc GetNumAppointments { calId } {
        # Get the number of appointments in an Outlook calendar.
        #
        # calId - Identifier of the Outlook calendar.
        #
        # Returns the number of Outlook appointments.
        #
        # See also: GetAppointmentByIndex DeleteAppointmentByIndex AddAppointment

        set count [$calId -with { Items } Count]
        return $count
    }

    proc GetAppointmentByIndex { calId index } {
        # Get an appointment of an Outlook calendar by its index.
        #
        # calId - Identifier of the Outlook calendar.
        # index - Index of the appointment.
        #
        # Returns the identifier of the found appointment.
        #
        # The first appointment has index 1.
        # Instead of using the numeric index the special word "end" may
        # be used to specify the last appointment.
        # If the index is out of bounds an error is thrown.
        #
        # See also: GetNumAppointments DeleteAppointmentByIndex AddAppointment

        set count [Outlook::GetNumAppointments $calId]
        if { $index eq "end" } {
            set index $count
        } else {
            if { $index < 1 || $index > $count } {
                error "GetAppointmentIdByIndex: Invalid index $index given."
            }
        }

        set itemId [$calId -with { Items } Item [expr {$index}]]
        return $itemId
    }

    proc DeleteAppointmentByIndex { calId index } {
        # Delete an appointment of an Outlook calendar by its index.
        #
        # calId - Identifier of the Outlook calendar.
        # index - Index of the appointment.
        #
        # No return value.
        #
        # The first appointment has index 1.
        # Instead of using the numeric index the special word "end" may
        # be used to specify the last appointment.
        # If the index is out of bounds an error is thrown.
        #
        # See also: GetNumAppointments GetAppointmentByIndex AddAppointment

        set count [Outlook::GetNumAppointments $calId]
        if { $index eq "end" } {
            set index $count
        } else {
            if { $index < 1 || $index > $count } {
                error "DeleteAppointmentIdByIndex: Invalid index $index given."
            }
        }
        $calId -with { Items } Remove [expr {$index}]
    }

    proc GetAppointmentProperties { appointId args } {
        # Get properties of an appointment.
        #
        # appointId - Identifier of the Outlook appointment.
        # args      - List of keys specifying appointment configure options.
        #
        # Option keys:
        #
        # See AddAppointment for a list of configure options.
        #
        # Returns the appointment properties as a list of values.
        # The list elements have the same order as the list of keys.
        #
        # See also: AddAppointment GetNumAppointments

        set valueList [list]
        foreach key $args {
            switch -exact $key {
                "-subject" {
                    lappend valueList [$appointId Subject]
                }
                "-startdate" {
                    lappend valueList [Cawt OutlookDateToIsoDate [$appointId Start]]
                }
                "-enddate" {
                    lappend valueList [Cawt OutlookDateToIsoDate [$appointId End]]
                }
                "-category" {
                    lappend valueList [$appointId Categories]
                }
                "-location" {
                    lappend valueList [$appointId Location]
                }
                "-body" {
                    lappend valueList [$appointId Body]
                }
                "-alldayevent" {
                    lappend valueList [$appointId AllDayEvent]
                }
                "-reminder" {
                    lappend valueList [$appointId ReminderSet]
                }
                "-busystate" {
                    lappend valueList [Outlook GetEnumName OlBusyStatus [$appointId BusyStatus]]
                }
                "-importance" {
                    lappend valueList [Outlook GetEnumName OlImportance [$appointId Importance]]
                }
                "-sensitivity" {
                    lappend valueList [Outlook GetEnumName OlSensitivity [$appointId Sensitivity]]
                }
                "-isrecurring" {
                    lappend valueList [$appointId IsRecurring]
                }
                default {
                    error "GetAppointmentProperties: Unknown key \"$key\" specified" 
                }
            }
        }
        return $valueList
    }

    proc AddAppointment { calId args } {
        # Create a new appointment in an Outlook calendar.
        #
        # calId    - Identifier of the Outlook calendar.
        # args     - List of key value pairs specifying appointment
        #            configure options and its values.
        #
        # Option keys:
        #
        # -subject <string>
        #       Set the subject text of the appointment.
        #       Default: No subject.
        # -startdate <string>
        #       Set the start date of the appointment in format "%Y-%m-%d %H:%M:%S".
        #       Default is today.
        # -enddate <string>
        #       Set the end date of the appointment in format "%Y-%m-%d %H:%M:%S".
        #       Default is today.
        # -category <string>
        #       Assign category to appointment. If specified category does not
        #       yet exist, it is created. 
        #       Default: No category.
        # -location <string>
        #       Set the location of the appointment.
        #       Default: No location.
        # -body <string>
        #       Set the body text of the appointment.
        #       Default: No body text.
        # -alldayevent true|false
        #       Specify, if appointment is an all day event.
        #       Default: false
        # -reminder true|false
        #       Specify, if appointment has a reminder set.
        #       Default: true
        # -busystate <OlBusyStatus>
        #       Set the busy status of the appointment.
        #       Possible values: olBusy olFree olOutOfOffice olTentative olWorkingElsewhere
        #       Default: olBusy
        # -importance <OlImportance>
        #       Set the importance of the appointment.
        #       Possible values: olImportanceHigh olImportanceLow olImportanceNormal
        #       Default: olImportanceNormal
        # -sensitivity <OlSensitivity>
        #       Set the sensitivity of the appointment.
        #       Possible values: olConfidential olNormal olPersonal olPrivate
        #       Default: olNormal
        # -isrecurring
        #       Get the recurring flag of the appointment.
        #       Only available for procedure GetAppointmentProperties.
        #
        # Returns the identifier of the new appointment object.
        #
        # See also: CreateMail AddHolidayAppointment GetAppointmentProperties GetNumAppointments

        set appointId [$calId -with { Items } Add $Outlook::olAppointmentItem]

        foreach { key value } $args {
            if { $value eq "" } {
                error "AddAppointment: No value specified for key \"$key\""
            }
            switch -exact $key {
                "-subject" {
                    $appointId Subject $value
                }
                "-startdate" {
                    $appointId Start [Cawt IsoDateToOutlookDate $value]
                }
                "-enddate" {
                    $appointId End [Cawt IsoDateToOutlookDate $value]
                }
                "-category" {
                    set appId [$calId Application]
                    Outlook AddCategory $appId $value
                    $appointId Categories $value
                    Cawt Destroy $appId
                }
                "-location" {
                    $appointId Location $value
                }
                "-body" {
                    $appointId Body $value
                }
                "-alldayevent" {
                    $appointId AllDayEvent [Cawt TclBool $value]
                }
                "-reminder" {
                    $appointId ReminderSet [Cawt TclBool $value]
                }
                "-busystate" {
                    $appointId BusyStatus [Outlook GetEnum $value]
                }
                "-importance" {
                    $appointId Importance [Outlook GetEnum $value]
                }
                "-sensitivity" {
                    $appointId Sensitivity [Outlook GetEnum $value]
                }
                default {
                    error "AddAppointment: Unknown key \"$key\" specified" 
                }
            }
        }
        $appointId Save
        return $appointId
    }

    proc AddHolidayAppointment { calId subject args } {
        # Create a new appointment in an Outlook calendar.
        #
        # calId    - Identifier of the Outlook calendar.
        # subject  - Subject text.
        # args     - List of key value pairs specifying appointment
        #            configure options and its values.
        #
        # Option keys:
        #
        # -date
        #       Set the date of the appointment in format "%Y-%m-%d".
        #       Default is today.
        # -category
        #       Assign category to appointment. Value is of type string.
        #       Default: No category.
        # -location
        #       Set the location of the appointment. Value is of type string.
        #       Default: No location.
        #
        # The appointment has the following properties automatically set:
        #   All-Day event, No reminder, OutOfOffice status.
        #
        # Returns the identifier of the new appointment object.
        #
        # See also: CreateMail AddAppointment ApplyHolidayFile GetNumAppointments

        set appointId [$calId -with { Items } Add $Outlook::olAppointmentItem]
        foreach { key value } $args {
            switch -exact $key {
                "-date"     { 
                                set dateSec [clock scan $value -format "%Y-%m-%d"]
                                $appointId Start [Cawt SecondsToOutlookDate $dateSec]
                            }
                "-category" {
                                if { $value ne "" } {
                                    set appId [$calId Application]
                                    Outlook AddCategory $appId $value
                                    $appointId Categories $value
                                    Cawt Destroy $appId
                                }
                            }
                "-location" { $appointId Location $value }
                default     { error "AddHolidayAppointment: Unknown key \"$key\" specified" }
            }
        }

        $appointId Subject $subject
        $appointId AllDayEvent [Cawt TclBool true]
        $appointId ReminderSet [Cawt TclBool false]
        $appointId BusyStatus $Outlook::olOutOfOffice
        
        $appointId Save

        return $appointId
    }

    proc ReadHolidayFile { fileName } {
        # Read an Outlook holiday file.
        #
        # fileName - Name of the Outlook holiday file.
        #
        # Returns the data of the holiday file as a dict with the following keys:
        # "SectionList"  : The list of sections in the holiday file.
        #   For each section the following keys are set:
        #   "SubjectList_$section": The list of subjects of this section.
        #   "DateList_$section"   : The list of dates of this section.
        #
        # If the holiday file could not be read, an error is thrown.
        #
        # See also: AddHolidayAppointment ApplyHolidayFile

        set isUnicodeFile [Cawt IsUnicodeFile $fileName]

        set catchVal [catch {open $fileName r} fp]
        if { $catchVal != 0 } {
            error "Could not open file \"$fileName\" for reading."
        }

        if { $isUnicodeFile } {
            # If Unicode, skip the 2 BOM bytes and set appropriate encoding.
            set bom [read $fp 2]
            fconfigure $fp -encoding unicode
        }

        set holidayDict [dict create]
        dict set emptyDict   SectionList [list]
        dict set holidayDict SectionList [list]

        while { [gets $fp line] >= 0 } {
            if { [string length $line] == 0 } {
                continue
            }
            if { [string index $line 0] eq "\[" } {
                set endRange [string first "\]" $line]
                if { $endRange < 0 } {
                    return $emptyDict
                }
                set sectionName [string range $line 1 [expr {$endRange - 1}]]
                dict lappend holidayDict SectionList $sectionName
            } else {
                set nameDateList [split $line ","]
                if { [llength $nameDateList] == 2 } {
                    lassign $nameDateList name date
                    set isoDate [string map { "/" "-" } $date]
                    dict lappend holidayDict "SubjectList_$sectionName" $name
                    dict lappend holidayDict "DateList_$sectionName"    $isoDate
                } else {
                    return $emptyDict
                }
            }
        }
        close $fp
        return $holidayDict
    }

    proc ApplyHolidayFile { calId fileName { category "" } } {
        # Read an Outlook holiday file and insert appointments.
        #
        # calId    - Identifier of the Outlook calendar.
        # fileName - Name of the Outlook holiday file.
        # category - Assign category to appointment. Default: No category.
        #
        # No return value.
        # If the holiday file could not be read, an error is thrown.
        #
        # See also: ReadHolidayFile AddHolidayAppointment

        set holidayDict [Outlook::ReadHolidayFile $fileName]
        set sectionList [dict get $holidayDict SectionList]
        foreach section $sectionList {
            set subjectList [dict get $holidayDict "SubjectList_$section"]
            set dateList    [dict get $holidayDict "DateList_$section"]
            foreach subject $subjectList date $dateList {
                Outlook::AddHolidayAppointment $calId $subject \
                    -date $date \
                    -location $section \
                    -category $category
            }
        }
    }

    proc GetNumCategories { appId } {
        # Get the number of Outlook categories.
        #
        # appId - Identifier of the Outlook instance.
        #
        # Returns the number of Outlook categories.
        #
        # See also: HaveCategory GetCategoryNames GetCategoryId
        # AddCategory DeleteCategory

        set nsObj [$appId GetNamespace "MAPI"]
        set count [$nsObj -with { Categories } Count]
        Cawt Destroy $nsObj
        return $count
    }

    proc HaveCategory { appId categoryName } {
        # Check, if a category already exists.
        #
        # appId        - Identifier of the Outlook instance.
        # categoryName - Name of the category to check.
        #
        # Returns true, if the category exists, otherwise false.
        #
        # See also: HaveCategory GetCategoryNames GetCategoryId
        # AddCategory DeleteCategory GetCategoryColor

        if { [lsearch -exact [Outlook::GetCategoryNames $appId] $categoryName] >= 0 } {
            return true
        } else {
            return false
        }
    }

    proc GetCategoryId { appId indexOrName } {
        # Get a category by its index or name.
        #
        # appId       - Identifier of the Outlook instance.
        # indexOrName - Index or name of the category.
        #
        # Returns the identifier of the found category.
        #
        # The first category has index 1.
        # If the index is out of bounds or the category name does not
        # exist, an error is thrown.
        #
        # See also: HaveCategory GetNumCategories GetCategoryNames 
        # AddCategory DeleteCategory

        set nsObj [$appId GetNamespace "MAPI"]
        set count [$nsObj -with { Categories } Count]
        if { [string is integer -strict $indexOrName] } {
            set index [expr int($indexOrName)] 
            if { $index < 1 || $index > $count } {
                error "GetCategoryId: Invalid index $index given."
            }
        } else {
            set index 1
            set found false
            foreach name [Outlook GetCategoryNames $appId] {
                if { $indexOrName eq $name } {
                    set found true
                    break
                }
                incr index
            }
            if { ! $found } {
                error "GetCategoryId: No category with name $indexOrName"
            }
        }
        set categoryId [$nsObj -with { Categories } Item $index]
        Cawt Destroy $nsObj
        return $categoryId
    }

    proc GetCategoryNames { appId } {
        # Get a list of category names.
        #
        # appId - Identifier of the Outlook instance.
        #
        # Returns a list of category names.
        #
        # See also: HaveCategory GetNumCategories GetCategoryId
        # AddCategory DeleteCategory

        set nsObj [$appId GetNamespace "MAPI"]
        set categories [$nsObj Categories]
        set count [$categories Count]

        set nameList [list]
        for { set i 1 } { $i <= $count } { incr i } {
            set categoryId [$categories Item [expr {$i}]]
            lappend nameList [$categoryId Name]
            Cawt Destroy $categoryId
        }
        Cawt Destroy $categories
        Cawt Destroy $nsObj
        return $nameList
    }

    proc AddCategory { appId name { color "" } } {
        # Add a new category to the Outlook categories.
        #
        # appId - Identifier of the Outlook instance.
        # name  - Name of the new category.
        # color - Value of enumeration type OlCategoryColor (see outlookConst.tcl)
        #         or category color name.
        #         If set to the empty string, a color is choosen automatically by Outlook.
        #
        # Returns the identifier of the new category.
        #
        # If a category with given name is already existing, the identifier of that
        # category is returned.
        #
        # See also: HaveCategory GetNumCategories GetCategoryNames 
        # GetCategoryId DeleteCategory GetCategoryColor

        if { [Outlook HaveCategory $appId $name] } {
            return [Outlook::GetCategoryId $appId $name]
        }

        set nsObj [$appId GetNamespace "MAPI"]
        set categories [$nsObj Categories]
        if { $color eq "" } {
            set categoryId [$categories Add $name]
        } else {
            set colorEnum [Outlook::GetCategoryColorEnum $color]
            set categoryId [$categories Add $name $colorEnum]
        }
        Cawt Destroy $categories
        Cawt Destroy $nsObj
        return $categoryId
    }

    proc DeleteCategory { appId indexOrName } {
        # Delete an Outlook category.
        #
        # indexOrName - Index or name of the Outlook category.
        #
        # No return value.
        #
        # See also: AddCategory HaveCategory GetNumCategories GetCategoryNames 
        # GetCategoryId DeleteCategory

        set nsObj [$appId GetNamespace "MAPI"]
        set categories [$nsObj Categories]
        set count [$categories Count]

        if { [string is integer -strict $indexOrName] } {
            set index [expr int($indexOrName)] 
            if { $index < 1 || $index > $count } {
                error "DeleteCategory: Invalid index $index given."
            }
        } else {
            set index 1
            set found false
            foreach name [Outlook::GetCategoryNames $appId] {
                if { $indexOrName eq $name } {
                    set found true
                    break
                }
                incr index
            }
            if { ! $found } {
                error "DeleteCategory: No category with name $indexOrName"
            }
        }
        $categories Remove $index

        Cawt Destroy $categories
        Cawt Destroy $nsObj
    }
}
