MakeSchoolNotes
This is a Make School assignment created by Martin Walsh and attempted by Connor Maher. This readme contains all notes and observations while completing this assignment.

TABLE VIEWS
UITableView - designed specifically for a scrolling list of items
UITableViewController - Subclass of UITableView specialized for handling related logic
storyboard - file that contains visual representation of the app's UI
UITableViewCell - responsible for the content on each cell for a table view
static data - this data is supplied by the UI
dynamic data - this data is supplied by the table view controller

REALM
Persistance - the ability to save data so the app isn't lost when you close the app
Realm - Replacement for SQLite, great for offline applications
When declaring variables in the Note model class, the data is considered _dynamic_ because both the storage and implementation of a property will be provided at runtime.

NoteTableViewCell.swift
- Instance of UITableViewCell class
- Uses NSDateFormatter to set a date as "yyyy-MM-dd"
- Connects both the _titleLabel_ and the _dateLabel_ objects to variables set using connections
- If there is a new note it'll update itself

NoteViewController.swift
