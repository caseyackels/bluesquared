Roadmap - Version 4.1.0

* [DONE] Restructure Headers table in master db
* [DONE] Add Companies to DB; Plant and Customers
* [DONE] Update Distribution Types so reporting will be easier
* [DONE] Restructure Title level DB (still referred to 'job' db)
* [DONE] Open existing title db up, and populate widget with last job (The Job Name/Number should be displayed somewhere for UX)
* Control when to add/edit Titles
** [DONE] When adding a new Title, you should also be able to add a Job
** [DONE] When editing a title, you should only be able to edit the Title (Need to make sure DB commands work)
** [DONE] Make Import File button work when adding a title/job at the same time.
* [DONE] Once a title is active the Job menu should be enabled
* Control when to add/edit Jobs
** [DONE] When adding/editing a job, you should not be able to edit the Title info (Read only)
** [DONE] When opening a job, a tablelist widget will display the last job.
** Make Import File button work when adding a job (disable button when editing)
* Editing Jobs
** [DONE] OK Button should update the current job.
** [DONE] Import File button should be disabled.
* Deduplication after importing
** Show two tablelist widgets (one for existing addresses; one for new addresses)
*** Highlight one Existing, and one New; select the MERGE button
*** Buttons: Merge, Replace with
# Merge: Merges two addresses, keeping new data
# Accept all as new: Inserts all addresses into DB as 'new' records
** [DONE] Remove exact matches, by default
** Show records that are near matches (Allow user to get out of this, and accept as new or deny all)
* Menu Edit>Manage>Jobs. List all jobs in the title, allowing the user to select a job to make it active by showing the destinations.
* Menu Edit>Manage>Versions. List all versions, allowing the user to Add/Rename/Disable. To View All or only Active or Inactive
* [DONE] Add Ship Order records
* [DONE] Edit Ship Order Records
* [DONE] Combine records into one order
* Add Destination
** [DONE] Type-Ahead when typing in a Company name; when we hit a match populate all other address fields.
** [DONE] When editing/adding a destination, populate fields (create new filtered dropdown selection) based on the distribution type
*** [IN PROGRESS] Ship Via will either populate (if only one record is found, or the list will be filtered depending on what ship via is assigned to that dist type.
# Distribution Type, Ship Type (Freight Small Package, -ALL-), look at which freight type is assigned to distribution type.
# Look at Ship Via's assigned to Title
# Results will be A) what's assigned to the title and matches B) If no match found, display all ship via's and/or ship type for the selected distribution type This will also take into account the ship via values we place on the individual customer.

