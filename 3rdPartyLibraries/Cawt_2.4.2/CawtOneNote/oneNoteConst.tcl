# Copyright: 2007-2018 Paul Obermeier (obermeier@poSoft.de)
# Distributed under BSD license.

namespace eval OneNote {

    namespace ensemble create

    # Enumeration CreateFileType
    variable cftNone     0 ; # Creates no new object.
    variable cftNotebook 1 ; # Creates a notebook by using the specified name and location.
    variable cftFolder   2 ; # Creates a section group by using the specified name and location.
    variable cftSection  3 ; # Creates a section by using the specified name and location.

    # Enumeration DockLocation
    variable dlDefault -1 ; # The OneNote window is docked at the default location on the desktop.
    variable dlLeft     1 ; # The OneNote window is docked on the left side of the desktop.
    variable dlRight    2 ; # The OneNote window is docked on the right side of the desktop.
    variable dlTop      3 ; # The OneNote window is docked at the top of the desktop.
    variable dlBottom   4 ; # The OneNote window is docked at the bottom of the desktop.

    # Enumeration FilingLocation
    variable flEMail      0 ; # Sets where Outlook email messages will be filed.
    variable flContacts   1 ; # Sets where Outlook contacts will be filed.
    variable flTasks      2 ; # Sets where Outlook tasks will be filed.
    variable flMeetings   3 ; # Sets where Outlook meetings will be filed.
    variable flWebContent 4 ; # Sets where Internet Explorer contents will be filed.
    variable flPrintOuts  5 ; # Sets where printouts from the OneNote printer will be filed.

    # Enumeration FilingLocationType
    variable fltNamedSectionNewPage   0 ; # Sets content to be filed on a new page in a specified section.
    variable fltCurrentSectionNewPage 1 ; # Sets content to be filed on a new page in the current section.
    variable fltCurrentPage           2 ; # Sets content to be filed on the current page.
    variable fltNamedPage             4 ; # Sets content to be filed on a specified page.

    # Enumeration HierarchyElement
    variable heNone          0 ; # Refers to no element.
    variable heNotebooks     1 ; # Refers to the Notebook elements.
    variable heSectionGroups 2 ; # Refers to the Section Group elements.
    variable heSections      4 ; # Refers to the Section elements.
    variable hePages         8 ; # Refers to the Page elements.

    # Enumeration HierarchyScope
    variable hsSelf 0      ; # Gets just the start node specified and no descendants.
    variable hsChildren 1  ; # Gets the immediate child nodes of the start node, and no descendants in higher or lower subsection groups.
    variable hsNotebooks 2 ; # Gets all notebooks below the start node, or root.
    variable hsSections 3  ; # Gets all sections below the start node, including sections in section groups and subsection groups.
    variable hsPages 4     ; # Gets all pages below the start node, including all pages in section groups and subsection groups.

    # Enumeration NewPageStyle
    variable npsDefault            0 ; # Creates a page that has the default page style.
    variable npsBlankPageWithTitle 1 ; # Creates a blank page that has a title.
    variable npsBlankPageNoTitle   2 ; # Creates a blank page that has no title.
 
    # Enumeration NotebookFilterOutType
    variable nfoLocal    1 ; # Allow only Local Notebooks.
    variable nfoNetwork  2 ; # Allows UNC or SharePoint Notebooks.
    variable nfoWeb      4 ; # Allows OneDrive notebooks.
    variable nfoNoWacUrl 8 ; # Any notebooks in locations that do not have a web client.

    # Enumeration PageInfo
    variable piBasic               0 ; # Returns only basic page content, without selection markup, file types for binary data objects and binary data objects. This is the standard value to pass.
    variable piBinaryData          1 ; # Returns page content with no selection markup, but with all binary data.
    variable piSelection           2 ; # Returns page content with selection markup, but no binary data.
    variable piBinaryDataSelection 3 ; # Returns page content with selection markup and all binary data.
    variable piFileType            4 ; # Returns page content with file type info for binary data objects.
    variable piBinaryDataFileType  5 ; # Returns page content with file type info for binary data objects and binary data objects
    variable piSelectionFileType   6 ; # Returns page content with selection markup and file type info for binary data.
    variable piAll                 7 ; # Returns all page content.

    # Enumeration PublishFormat
    variable pfOneNote        0 ; # Published page is in the .one format.
    variable pfOneNotePackage 1 ; # Published page is in the .onepkg format.
    variable pfMHTML          2 ; # Published page is in the .mht format.
    variable pfPDF            3 ; # Published page is in the .pdf format.
    variable pfXPS            4 ; # Published page is in the .xps format.
    variable pfWord           5 ; # Published page is in the .doc or .docx format.
    variable pfEMF            6 ; # Published page is in the enhanced metafile (.emf) format.
    variable pfHTML           7 ; # Published page is in the .html format. This member is new in OneNote 2013.
    variable pfOneNote2007    8 ; # Published page is in the 2007 .one format. This member is new in OneNote 2013.

    # Enumeration RecentResultType
    variable rrtNone   0 ; # Sets no recent-result list to be rendered.
    variable rrtFiling 1 ; # Sets the "Filing" recent-result list to be rendered.
    variable rrtSearch 2 ; # Sets the "Search" recent-result list to be rendered.
    variable rrtLinks  3 ; # Sets the "Links" recent-result list to be rendered.

    # Enumeration SpecialLocation
    variable slBackupFolder          0 ; # Gets the path to the Backup Folders folder location.
    variable slUnfiledNotesSection   1 ; # Gets the path to the Unfiled Notes folder location.
    variable slDefaultNotebookFolder 2 ; # Gets the path to the Default Notebook folder location.

    # Enumeration TreeCollapsedStateType
    variable tcsExpanded  0 ; # Sets the hierarchy tree to expanded.
    variable tcsCollapsed 1 ; # Sets the hierarchy tree to collapsed.

    # Enumeration XMLSchema
    variable xs2007    0 ; # References the OneNote 2007 schema.
    variable xs2010    1 ; # References the OneNote 2010 schema.
    variable xs2013    2 ; # References the OneNote 2013 schema.

    variable enums

    array set enums {
        CreateFileType { cftNone 0 cftNotebook 1 cftFolder 2 cftSection 3 }
        DockLocation { dlDefault -1 dlLeft 1 dlRight 2 dlTop 3 dlBottom 4 }
        FilingLocation { flEMail 0 flContacts 1 flTasks 2 flMeetings 3 flWebContent 4 flPrintOuts 5 }
        FilingLocationType { fltNamedSectionNewPage 0 fltCurrentSectionNewPage 1 fltCurrentPage 2 fltNamedPage 4 }
        HierarchyElement { heNone 0 heNotebooks 1 heSectionGroups 2 heSections 4 hePages 8 }
        HierarchyScope { hsSelf 0 hsChildren 1 hsNotebooks 2 hsSections 3 hsPages 4 }
        NewPageStyle { npsDefault 0 npsBlankPageWithTitle 1 npsBlankPageNoTitle 2 }
        NotebookFilterOutType { nfoLocal 1 nfoNetwork 2 nfoWeb 4 nfoNoWacUrl 8 }
        PageInfo { piBasic 0 piBinaryData 1 piSelection 2 piBinaryDataSelection 3 piFileType 4 piBinaryDataFileType 5 piSelectionFileType 6 piAll 7 }
        PublishFormat { pfOneNote 0 pfOneNotePackage 1 pfMHTML 2 pfPDF 3 pfXPS 4 pfWord 5 pfEMF 6 pfHTML 7 pfOneNote2007 8 }
        RecentResultType { rrtNone 0 rrtFiling 1 rrtSearch 2 rrtLinks 3 }
        SpecialLocation { slBackupFolder 0 slUnfiledNotesSection 1 slDefaultNotebookFolder 2 }
        TreeCollapsedStateType { tcsExpanded 0 tcsCollapsed 1 }
        XMLSchema { xs2007 0 xs2010 1 xs2013 2 }
    }

    namespace export GetEnum
    namespace export GetEnumNames
    namespace export GetEnumTypes
    namespace export GetEnumVal

    proc GetEnumTypes { } {
        # Get available enumeration types.
        #
        # Returns a list of available enumeration types.
        #
        # See also: GetEnumNames GetEnumVal GetEnum

        variable enums

        return [lsort [array names enums]]
    }

    proc GetEnumNames { enumType } {
        # Get names of a given enumeration type.
        #
        # enumType - Enumeration type
        #
        # Returns a list of names of a given enumeration type.
        #
        # See also: GetEnumTypes GetEnumVal GetEnum

        variable enums

        if { [info exists enums($enumType)] } {
            foreach { key val } $enums($enumType) {
                lappend nameList $key
            }
            return $nameList
        } else {
            return [list]
        }
    }

    proc GetEnumVal { enumName } {
        # Get numeric value of an enumeration name.
        #
        # enumName - Enumeration name
        #
        # Returns the numeric value of an enumeration name.
        #
        # See also: GetEnumTypes GetEnumNames GetEnum

        variable enums

        foreach enumType [GetEnumTypes] {
            set ind [lsearch -exact $enums($enumType) $enumName]
            if { $ind >= 0 } {
                return [lindex $enums($enumType) [expr { $ind + 1 }]]
            }
        }
        return ""
    }

    proc GetEnum { enumOrString } {
        # Get numeric value of an enumeration.
        #
        # enumOrString - Enumeration name
        #
        # Returns the numeric value of an enumeration.
        #
        # See also: GetEnumTypes GetEnumVal GetEnumNames

        set retVal [catch { expr int($enumOrString) } enumInt]
        if { $retVal == 0 } {
            return $enumInt
        } else {
            return [GetEnumVal $enumOrString]
        }
    }
}
