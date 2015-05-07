--
-- File generated with SQLiteStudio v3.0.4 on Tue Apr 28 17:31:52 2015
--
-- Text encoding used: windows-1252
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: History
DROP TABLE IF EXISTS History;

CREATE TABLE History (
    History_ID TEXT PRIMARY KEY,
    HistUser   TEXT NOT NULL ON CONFLICT ROLLBACK,
    HistDate   DATE NOT NULL ON CONFLICT ROLLBACK,
    HistTime   TIME NOT NULL ON CONFLICT ROLLBACK,
    HistSysLog TEXT
);


-- Table: ExportType
DROP TABLE IF EXISTS ExportType;

CREATE TABLE ExportType (
    ExportType_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    ExportTypes   TEXT    NOT NULL ON CONFLICT ROLLBACK,
    Active        BOOLEAN DEFAULT (1) 
);


-- Table: NoteTypes
DROP TABLE IF EXISTS NoteTypes;

CREATE TABLE NoteTypes (
    NoteType_ID      INTEGER PRIMARY KEY AUTOINCREMENT,
    NoteType         TEXT    NOT NULL ON CONFLICT ROLLBACK,
    IncludeOnReports BOOLEAN NOT NULL
                             DEFAULT (1),
    Active           BOOLEAN DEFAULT (1) 
                             NOT NULL
);


-- Table: ShippingOrders
DROP TABLE IF EXISTS ShippingOrders;

CREATE TABLE ShippingOrders (
    JobInformationID TEXT UNIQUE ON CONFLICT ROLLBACK
                          PRIMARY KEY,
    AddressID        TEXT UNIQUE ON CONFLICT ROLLBACK
);


-- Table: Published
DROP TABLE IF EXISTS Published;

CREATE TABLE Published (
    Published_ID     INTEGER PRIMARY KEY AUTOINCREMENT,
    NotesID          TEXT    REFERENCES Notes (Notes_ID) ON UPDATE CASCADE,
    JobInformationID TEXT    REFERENCES JobInformation (JobInformation_ID) ON UPDATE CASCADE
                             NOT NULL ON CONFLICT ROLLBACK,
    PublishedRev     INTEGER NOT NULL ON CONFLICT ROLLBACK,
    PublishedBy      TEXT    NOT NULL ON CONFLICT ROLLBACK,
    PublishedDate    DATE    NOT NULL ON CONFLICT ROLLBACK,
    PublishedTime    TIME    NOT NULL ON CONFLICT ROLLBACK
);


-- Table: JobInformation
DROP TABLE IF EXISTS JobInformation;

CREATE TABLE JobInformation (
    JobInformation_ID TEXT UNIQUE ON CONFLICT ROLLBACK
                           NOT NULL ON CONFLICT ROLLBACK
                           PRIMARY KEY ASC ON CONFLICT ROLLBACK,
    JobName           TEXT NOT NULL ON CONFLICT ROLLBACK
);


-- Table: TitleInformation
DROP TABLE IF EXISTS TitleInformation;

CREATE TABLE TitleInformation (
    TitleInformation_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    NotesID             TEXT    REFERENCES Notes (Notes_ID) ON UPDATE CASCADE,
    CustCode            TEXT    NOT NULL ON CONFLICT ROLLBACK,
    CSRName             TEXT    NOT NULL ON CONFLICT ROLLBACK,
    TitleName           TEXT    NOT NULL ON CONFLICT ROLLBACK
);


-- Table: Notes
DROP TABLE IF EXISTS Notes;

CREATE TABLE Notes (
    Notes_ID   TEXT    PRIMARY KEY,
    HistoryID  INTEGER NOT NULL ON CONFLICT ROLLBACK
                       REFERENCES History (History_ID) ON UPDATE CASCADE,
    NoteTypeID INTEGER REFERENCES NoteTypes (NoteType_ID) ON UPDATE CASCADE
                       NOT NULL ON CONFLICT ROLLBACK,
    NotesText  TEXT    NOT NULL ON CONFLICT ROLLBACK,
    Active     BOOLEAN DEFAULT (1) 
                       NOT NULL ON CONFLICT ROLLBACK
);


-- Table: Addresses
DROP TABLE IF EXISTS Addresses;

CREATE TABLE Addresses (
    Addresses_ID    TEXT    UNIQUE ON CONFLICT ROLLBACK,
    NotesID         TEXT    REFERENCES Notes (Notes_ID) ON UPDATE CASCADE,
    AddressParentID TEXT,
    AddressChildID  INTEGER,
    User_Company    TEXT
);


COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
