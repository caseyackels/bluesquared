--
-- File generated with SQLiteStudio v3.0.4 on Fri May 15 13:09:00 2015
--
-- Text encoding used: windows-1252
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: Addresses
CREATE TABLE Addresses (
    Addresses_ID    TEXT    UNIQUE ON CONFLICT ROLLBACK,
    NotesID         TEXT    REFERENCES Notes (Notes_ID) ON UPDATE CASCADE,
    AddressParentID TEXT,
    AddressChildID  INTEGER,
    Active          BOOLEAN DEFAULT (1) 
                            NOT NULL ON CONFLICT ROLLBACK,
    Version         INTEGER REFERENCES Versions (Version_ID) ON UPDATE CASCADE,
    User_Company    TEXT
);


-- Table: JobInformation
CREATE TABLE JobInformation (
    JobInformation_ID  TEXT    UNIQUE ON CONFLICT ROLLBACK
                               NOT NULL ON CONFLICT ROLLBACK
                               PRIMARY KEY ASC ON CONFLICT ROLLBACK,
    JobName            TEXT    NOT NULL ON CONFLICT ROLLBACK,
    JobNumber          TEXT    NOT NULL ON CONFLICT ROLLBACK
                               UNIQUE ON CONFLICT ROLLBACK,
    JobSaveLocation    TEXT    NOT NULL ON CONFLICT ROLLBACK,
    JobFirstShipDate   DATE,
    JobBalanceShipDate DATE,
    TitleInformationID INTEGER REFERENCES TitleInformation (TitleInformation_ID) ON UPDATE CASCADE
);


-- Table: TitleInformation
CREATE TABLE TitleInformation (
    TitleInformation_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    NotesID             TEXT    REFERENCES Notes (Notes_ID) ON UPDATE CASCADE,
    HistoryID           TEXT    REFERENCES History (History_ID) ON UPDATE CASCADE
                                NOT NULL ON CONFLICT ROLLBACK,
    CustCode            TEXT    NOT NULL ON CONFLICT ROLLBACK,
    CSRName             TEXT    NOT NULL ON CONFLICT ROLLBACK,
    TitleName           TEXT    NOT NULL ON CONFLICT ROLLBACK,
    TitleSaveLocation   TEXT
);


-- Table: Versions
CREATE TABLE Versions (
    Version_ID    INTEGER PRIMARY KEY AUTOINCREMENT,
    VersionName   TEXT    UNIQUE ON CONFLICT ROLLBACK
                          NOT NULL ON CONFLICT ROLLBACK,
    VersionActive BOOLEAN NOT NULL ON CONFLICT ROLLBACK
                          UNIQUE ON CONFLICT ROLLBACK
                          DEFAULT (1) 
);


-- Table: Notes
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


-- Table: History
CREATE TABLE History (
    History_ID TEXT PRIMARY KEY,
    HistUser   TEXT NOT NULL ON CONFLICT ROLLBACK,
    HistDate   DATE NOT NULL ON CONFLICT ROLLBACK,
    HistTime   TIME NOT NULL ON CONFLICT ROLLBACK,
    HistSysLog TEXT
);


-- Table: ExportType
CREATE TABLE ExportType (
    ExportType_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    ExportTypes   TEXT    NOT NULL ON CONFLICT ROLLBACK,
    Active        BOOLEAN DEFAULT (1) 
);


-- Table: SysInfo
CREATE TABLE SysInfo (
    SysInfo_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    SysSchema  INTEGER UNIQUE
                       NOT NULL,
    HistoryID  TEXT    REFERENCES History (History_ID) ON UPDATE CASCADE
);


-- Table: Published
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


-- Table: NoteTypes
CREATE TABLE NoteTypes (
    NoteType_ID      INTEGER PRIMARY KEY AUTOINCREMENT,
    NoteType         TEXT    NOT NULL ON CONFLICT ROLLBACK,
    IncludeOnReports BOOLEAN NOT NULL
                             DEFAULT (1),
    Active           BOOLEAN DEFAULT (1) 
                             NOT NULL
);


-- Table: ShippingOrders
CREATE TABLE ShippingOrders (
    JobInformationID TEXT UNIQUE ON CONFLICT ROLLBACK
                          PRIMARY KEY,
    AddressID        TEXT UNIQUE ON CONFLICT ROLLBACK
);


COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
