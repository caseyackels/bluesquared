--
-- File generated with SQLiteStudio v3.0.6 on Wed Jul 1 18:06:45 2015
--
-- Text encoding used: windows-1252
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: SecGroupNames
DROP TABLE IF EXISTS SecGroupNames;

CREATE TABLE SecGroupNames (
    SecGroupName_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    SecGroupName    TEXT,
    Status          BOOLEAN DEFAULT (1) 
);


-- Table: Countries
DROP TABLE IF EXISTS Countries;

CREATE TABLE Countries (
    Country_ID  INTEGER     PRIMARY KEY AUTOINCREMENT
                            NOT NULL,
    CountryCode VARCHAR (2) NOT NULL
                            UNIQUE,
    CountryName TEXT        NOT NULL
);


-- Table: Customer
DROP TABLE IF EXISTS Customer;

CREATE TABLE Customer (
    Cust_ID  TEXT    PRIMARY KEY
                     NOT NULL ON CONFLICT ABORT
                     UNIQUE ON CONFLICT ABORT,
    CustName TEXT    NOT NULL ON CONFLICT ABORT,
    Status   BOOLEAN
);


-- Table: Modules
DROP TABLE IF EXISTS Modules;

CREATE TABLE Modules (
    Mod_ID                INTEGER PRIMARY KEY AUTOINCREMENT,
    ModuleName            VARCHAR NOT NULL ON CONFLICT ABORT
                                  UNIQUE ON CONFLICT ABORT,
    EnableModNotification BOOLEAN DEFAULT (1) 
);


-- Table: AccountNumbers
DROP TABLE IF EXISTS AccountNumbers;

CREATE TABLE AccountNumbers (
    AcctNumbers_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    CompaniesID    INTEGER REFERENCES MasterAddresses (MasterAddr_ID) ON UPDATE CASCADE,
    CarriersID     INTEGER REFERENCES Carriers (Carrier_ID) ON UPDATE CASCADE,
    AcctNumber     TEXT
);


-- Table: EmailNotifications
DROP TABLE IF EXISTS EmailNotifications;

CREATE TABLE EmailNotifications (
    EN_ID             INTEGER PRIMARY KEY AUTOINCREMENT
                              NOT NULL,
    ModuleName        VARCHAR NOT NULL,
    EventName         VARCHAR NOT NULL
                              UNIQUE ON CONFLICT ABORT,
    EventNotification BOOLEAN NOT NULL,
    EmailFrom         VARCHAR NOT NULL ON CONFLICT ABORT,
    EmailTo           VARCHAR NOT NULL ON CONFLICT ABORT,
    EmailSubject      VARCHAR NOT NULL ON CONFLICT ABORT,
    EmailBody         VARCHAR NOT NULL ON CONFLICT ABORT
);


-- Table: Provinces
DROP TABLE IF EXISTS Provinces;

CREATE TABLE Provinces (
    Prov_ID           INTEGER  PRIMARY KEY AUTOINCREMENT
                               NOT NULL,
    ProvAbbr          CHAR (3) NOT NULL,
    ProvName          TEXT     NOT NULL,
    PostalCodeLowEnd  TEXT,
    PostalCodeHighEnd TEXT,
    CountryID         INTEGER  REFERENCES Countries (Country_ID) ON DELETE CASCADE
);


-- Table: EmailSetup
DROP TABLE IF EXISTS EmailSetup;

CREATE TABLE EmailSetup (
    Email_ID                INTEGER PRIMARY KEY AUTOINCREMENT
                                    NOT NULL,
    EmailServer             VARCHAR NOT NULL,
    EmailPassword           VARCHAR,
    EmailPort               INTEGER,
    EmailLogin              VARCHAR,
    GlobalEmailNotification BOOLEAN NOT NULL
                                    DEFAULT (1),
    TLS                     BOOLEAN DEFAULT (0) 
);


-- Table: RateTypes
DROP TABLE IF EXISTS RateTypes;

CREATE TABLE RateTypes (
    RateType_ID INTEGER PRIMARY KEY AUTOINCREMENT
                        NOT NULL,
    RateType    TEXT    NOT NULL ON CONFLICT ABORT
);


-- Table: SubHeaders
DROP TABLE IF EXISTS SubHeaders;

CREATE TABLE SubHeaders (
    SubHeaderName  VARCHAR UNIQUE ON CONFLICT ROLLBACK
                           PRIMARY KEY ASC ON CONFLICT ROLLBACK
                           COLLATE NOCASE,
    HeaderConfigID TEXT    NOT NULL ON CONFLICT ROLLBACK
                           REFERENCES HeadersConfig (HeaderConfig_ID) ON UPDATE CASCADE
);


-- Table: SecurityAccess
DROP TABLE IF EXISTS SecurityAccess;

CREATE TABLE SecurityAccess (
    SecAccess_ID     INTEGER PRIMARY KEY AUTOINCREMENT,
    SecGrpID         INTEGER REFERENCES Users ON UPDATE CASCADE,
    ModID            INTEGER REFERENCES Modules (Mod_ID) ON UPDATE CASCADE,
    SecAccess_Read   BOOLEAN,
    SecAccess_Write  BOOLEAN,
    SecAccess_Delete BOOLEAN
);


-- Table: SecGroups
DROP TABLE IF EXISTS SecGroups;

CREATE TABLE SecGroups (
    SecGrp_ID      INTEGER PRIMARY KEY AUTOINCREMENT,
    SecGroupNameID INTEGER NOT NULL ON CONFLICT ABORT
                           REFERENCES SecGroupNames (SecGroupName_ID) ON UPDATE CASCADE,
    UserID         INTEGER NOT NULL ON CONFLICT ABORT
                           REFERENCES Users (User_ID) ON UPDATE CASCADE
);


-- Table: HeadersConfig
DROP TABLE IF EXISTS HeadersConfig;

CREATE TABLE HeadersConfig (
    HeaderConfig_ID         TEXT    NOT NULL
                                    PRIMARY KEY ON CONFLICT ROLLBACK
                                    UNIQUE ON CONFLICT ROLLBACK,
    dbColName               TEXT    NOT NULL ON CONFLICT ROLLBACK
                                    UNIQUE ON CONFLICT ROLLBACK,
    dbDataType              TEXT    NOT NULL ON CONFLICT ROLLBACK,
    widLabelName            TEXT    NOT NULL ON CONFLICT ROLLBACK
                                    UNIQUE ON CONFLICT ROLLBACK,
    widLabelAlignment       TEXT    NOT NULL ON CONFLICT ROLLBACK,
    widWidget               TEXT    NOT NULL ON CONFLICT ROLLBACK,
    widValues               TEXT,
    widDataType             TEXT    NOT NULL ON CONFLICT ROLLBACK,
    widFormat               TEXT,
    widColAlignment         TEXT    NOT NULL ON CONFLICT ROLLBACK,
    widStartColWidth        INTEGER NOT NULL ON CONFLICT ROLLBACK,
    widMaxWidth             INTEGER NOT NULL ON CONFLICT ROLLBACK,
    widResizeToLongestEntry BOOLEAN NOT NULL ON CONFLICT ROLLBACK
                                    DEFAULT (0),
    widMaxStringLength      INTEGER NOT NULL ON CONFLICT ROLLBACK,
    widHighlightColor       TEXT,
    widUIGroup              TEXT    NOT NULL ON CONFLICT ROLLBACK,
    widUIPositionWeight     INTEGER NOT NULL ON CONFLICT ROLLBACK
                                    DEFAULT (0),
    widExportable           BOOLEAN NOT NULL ON CONFLICT ROLLBACK
                                    DEFAULT (1),
    widRequired             BOOLEAN NOT NULL ON CONFLICT ROLLBACK
                                    DEFAULT (0),
    widDisplayType          TEXT    NOT NULL ON CONFLICT ROLLBACK,
    dbActive                BOOLEAN NOT NULL ON CONFLICT ROLLBACK
                                    DEFAULT (1) 
);


-- Table: PubTitle
DROP TABLE IF EXISTS PubTitle;

CREATE TABLE PubTitle (
    Title_ID     INTEGER PRIMARY KEY AUTOINCREMENT,
    TitleName    TEXT    NOT NULL ON CONFLICT ABORT,
    CustID       TEXT    REFERENCES Customer (Cust_ID),
    Status       BOOLEAN,
    CSRID        VARCHAR REFERENCES CSRs (CSR_ID),
    SaveLocation TEXT
);


-- Table: UserDefinedValues
DROP TABLE IF EXISTS UserDefinedValues;

CREATE TABLE UserDefinedValues (
    UserDefinedValue_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    PrimaryKeyName      TEXT    UNIQUE ON CONFLICT ROLLBACK
                                NOT NULL ON CONFLICT ROLLBACK,
    TableName           TEXT    UNIQUE ON CONFLICT ROLLBACK
                                NOT NULL ON CONFLICT ROLLBACK,
    Description         TEXT    NOT NULL ON CONFLICT ROLLBACK
                                UNIQUE ON CONFLICT ROLLBACK,
    DisplayColValues    TEXT
);


-- Table: Packages
DROP TABLE IF EXISTS Packages;

CREATE TABLE Packages (
    Pkg_ID  INTEGER PRIMARY KEY AUTOINCREMENT,
    Package TEXT    NOT NULL ON CONFLICT ABORT
);


-- Table: IntlShipTerms
DROP TABLE IF EXISTS IntlShipTerms;

CREATE TABLE IntlShipTerms (
    Terms_ID  INTEGER PRIMARY KEY AUTOINCREMENT
                      NOT NULL,
    TermsAbbr VARCHAR NOT NULL
                      UNIQUE ON CONFLICT ABORT,
    TermsDesc VARCHAR,
    IncoTerms INTEGER
);


-- Table: ForestType
DROP TABLE IF EXISTS ForestType;

CREATE TABLE ForestType (
    ForestType_ID        INTEGER PRIMARY KEY ON CONFLICT ROLLBACK AUTOINCREMENT
                                 NOT NULL ON CONFLICT ROLLBACK
                                 UNIQUE ON CONFLICT ROLLBACK,
    ForestTypeDesc       TEXT    NOT NULL ON CONFLICT ROLLBACK,
    ForestTypeNoteLayout TEXT    NOT NULL ON CONFLICT ROLLBACK,
    Active               BOOLEAN NOT NULL ON CONFLICT ROLLBACK
                                 DEFAULT (1),
    ForestOrgID          INTEGER REFERENCES ForestOrg (ForestOrg_ID) ON UPDATE CASCADE
                                 NOT NULL ON CONFLICT ROLLBACK
);


-- Table: FreightRates
DROP TABLE IF EXISTS FreightRates;

CREATE TABLE FreightRates (
    RateTable_ID         REFERENCES CarrierName (RateTable),
    WeightLow1   INTEGER,
    WeightHigh1  INTEGER,
    ShippingCost VARCHAR
);


-- Table: Containers
DROP TABLE IF EXISTS Containers;

CREATE TABLE Containers (
    Container_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Container    TEXT    NOT NULL ON CONFLICT ABORT
);


-- Table: Reports
DROP TABLE IF EXISTS Reports;

CREATE TABLE Reports (
    Reports_ID     INTEGER PRIMARY KEY AUTOINCREMENT,
    Reports_Name   TEXT    NOT NULL ON CONFLICT ABORT
                           UNIQUE ON CONFLICT ABORT,
    Reports_Status BOOLEAN NOT NULL ON CONFLICT ABORT
                           DEFAULT (1) 
);


-- Table: ForestOrg
DROP TABLE IF EXISTS ForestOrg;

CREATE TABLE ForestOrg (
    ForestOrg_ID  INTEGER PRIMARY KEY AUTOINCREMENT
                          UNIQUE ON CONFLICT ROLLBACK
                          NOT NULL ON CONFLICT ROLLBACK,
    ForestOrgName TEXT    UNIQUE ON CONFLICT ROLLBACK
                          NOT NULL ON CONFLICT ROLLBACK,
    ForestOrgNum  TEXT    UNIQUE ON CONFLICT ROLLBACK
                          NOT NULL ON CONFLICT ROLLBACK,
    Active        BOOLEAN NOT NULL ON CONFLICT ROLLBACK
                          DEFAULT (1) 
);


-- Table: Headers
DROP TABLE IF EXISTS Headers;

CREATE TABLE Headers (
    Header_ID          INTEGER PRIMARY KEY AUTOINCREMENT
                               NOT NULL,
    InternalHeaderName TEXT    NOT NULL
                               UNIQUE ON CONFLICT ABORT,
    HeaderMaxLength    INTEGER NOT NULL ON CONFLICT ABORT,
    OutputHeaderName   TEXT    NOT NULL ON CONFLICT ABORT,
    Widget             TEXT    NOT NULL ON CONFLICT ABORT,
    Highlight          TEXT,
    AlwaysDisplay      BOOLEAN,
    Required           BOOLEAN,
    DefaultWidth       INTEGER,
    ResizeColumn       BOOLEAN,
    DisplayOrder       INTEGER
);


-- Table: UOM
DROP TABLE IF EXISTS UOM;

CREATE TABLE UOM (
    UOM_ID INTEGER PRIMARY KEY AUTOINCREMENT
                   NOT NULL,
    UOM    VARCHAR NOT NULL
                   UNIQUE ON CONFLICT ABORT
);


-- Table: IntlLicense
DROP TABLE IF EXISTS IntlLicense;

CREATE TABLE IntlLicense (
    License_ID  INTEGER PRIMARY KEY AUTOINCREMENT
                        NOT NULL,
    LicenseAbbr VARCHAR NOT NULL
                        UNIQUE ON CONFLICT ABORT,
    LicenseDesc VARCHAR
);


-- Table: ShippingClasses
DROP TABLE IF EXISTS ShippingClasses;

CREATE TABLE ShippingClasses (
    ShippingClass_ID INTEGER PRIMARY KEY AUTOINCREMENT
                             NOT NULL,
    ShippingClass    TEXT    NOT NULL ON CONFLICT ABORT
);


-- Table: CustomerShipVia
DROP TABLE IF EXISTS CustomerShipVia;

CREATE TABLE CustomerShipVia (
    CustomerShipVia_ID INTEGER PRIMARY KEY AUTOINCREMENT
                               NOT NULL,
    CustID             INTEGER REFERENCES Customer (Cust_ID),
    ShipViaID          INTEGER REFERENCES ShipVia (ShipVia_ID) 
);


-- Table: MasterAddresses
DROP TABLE IF EXISTS MasterAddresses;

CREATE TABLE MasterAddresses (
    MasterAddr_ID        INTEGER PRIMARY KEY AUTOINCREMENT,
    MasterAddr_Name      TEXT    NOT NULL ON CONFLICT ROLLBACK,
    MasterAddr_Attn      TEXT,
    MasterAddr_Add1      TEXT    NOT NULL ON CONFLICT ROLLBACK,
    MasterAddr_Add2      TEXT,
    MasterAddr_Add3      TEXT,
    MasterAddr_StateAbbr TEXT    NOT NULL ON CONFLICT ROLLBACK,
    MasterAddr_Zip       TEXT    NOT NULL ON CONFLICT ROLLBACK,
    MasterAddr_CtryCode  TEXT    REFERENCES Countries (CountryCode) ON UPDATE CASCADE
                                 NOT NULL ON CONFLICT ROLLBACK,
    MasterAddr_Plant     BOOLEAN NOT NULL ON CONFLICT ROLLBACK
                                 DEFAULT (0),
    MasterAddr_Active    BOOLEAN DEFAULT (1) 
                                 NOT NULL ON CONFLICT ROLLBACK
);


-- Table: Users
DROP TABLE IF EXISTS Users;

CREATE TABLE Users (
    User_ID      INTEGER PRIMARY KEY AUTOINCREMENT,
    UserLogin    TEXT    UNIQUE ON CONFLICT ABORT
                         NOT NULL ON CONFLICT ABORT,
    UserName     TEXT,
    UserPwd      TEXT    NOT NULL ON CONFLICT ABORT,
    Users_Status BOOLEAN DEFAULT (1),
    UserSalt     TEXT
);


-- Table: EventNotifications
DROP TABLE IF EXISTS EventNotifications;

CREATE TABLE EventNotifications (
    Event_ID                INTEGER PRIMARY KEY AUTOINCREMENT,
    ModID                   INTEGER NOT NULL ON CONFLICT ABORT
                                    REFERENCES Modules (Mod_ID),
    EventName               VARCHAR NOT NULL ON CONFLICT ABORT,
    EventSubstitutions      VARCHAR,
    EnableEventNotification BOOLEAN DEFAULT (1) 
);


-- Table: ShipVia
DROP TABLE IF EXISTS ShipVia;

CREATE TABLE ShipVia (
    ShipVia_ID       INTEGER PRIMARY KEY AUTOINCREMENT,
    CarrierID        INTEGER REFERENCES Carriers (Carrier_ID) ON DELETE CASCADE
                                                              ON UPDATE CASCADE,
    ShipViaCode      TEXT    UNIQUE ON CONFLICT ABORT,
    FreightPayerType TEXT    NOT NULL ON CONFLICT ABORT,
    ShipViaName      TEXT    NOT NULL ON CONFLICT ABORT,
    ShipmentType     TEXT    NOT NULL ON CONFLICT ABORT,
    RateType         TEXT,
    RateTable        TEXT
);


-- Table: CSRs
DROP TABLE IF EXISTS CSRs;

CREATE TABLE CSRs (
    CSR_ID    VARCHAR (6, 0) PRIMARY KEY ON CONFLICT ABORT
                             NOT NULL
                             UNIQUE ON CONFLICT ABORT,
    FirstName VARCHAR        NOT NULL,
    LastName  VARCHAR,
    Email     VARCHAR,
    Status    BOOLEAN        DEFAULT (1) 
);


-- Table: Carriers
DROP TABLE IF EXISTS Carriers;

CREATE TABLE Carriers (
    Carrier_ID INTEGER PRIMARY KEY AUTOINCREMENT
                       NOT NULL,
    Name       TEXT    NOT NULL ON CONFLICT ABORT
                       UNIQUE ON CONFLICT ABORT,
    RateType   VARCHAR,
    RateTable  VARCHAR
);


-- Table: DistributionTypes
DROP TABLE IF EXISTS DistributionTypes;

CREATE TABLE DistributionTypes (
    DistributionType_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    DistTypeName        TEXT    UNIQUE ON CONFLICT ABORT
                                NOT NULL ON CONFLICT ABORT,
    DistType_Status     BOOLEAN DEFAULT (1) 
                                NOT NULL ON CONFLICT ABORT
);


-- Table: GenerateReports
DROP TABLE IF EXISTS GenerateReports;

CREATE TABLE GenerateReports (
    GenerateReports_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    DistributionTypeID INTEGER NOT NULL ON CONFLICT ABORT
                               REFERENCES DistributionTypes (DistributionType_ID) ON UPDATE CASCADE,
    ReportsID          INTEGER REFERENCES Reports (Reports_ID) ON UPDATE CASCADE
                               NOT NULL ON CONFLICT ABORT
);


-- Table: FreightPayer
DROP TABLE IF EXISTS FreightPayer;

CREATE TABLE FreightPayer (
    FreightPayer_ID INTEGER PRIMARY KEY AUTOINCREMENT
                            NOT NULL,
    Payer           TEXT    NOT NULL ON CONFLICT ABORT
);


-- Table: GenerateExports
DROP TABLE IF EXISTS GenerateExports;

CREATE TABLE GenerateExports (
    GenerateExports_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    DistributionTypeID INTEGER NOT NULL ON CONFLICT ABORT
                               REFERENCES DistributionTypes (DistributionType_ID) ON UPDATE CASCADE,
    ExportsID          INTEGER REFERENCES Exports (Exports_ID) ON UPDATE CASCADE
                               NOT NULL ON CONFLICT ABORT
);


-- Table: Schema
DROP TABLE IF EXISTS Schema;

CREATE TABLE Schema (
    idx         INTEGER PRIMARY KEY AUTOINCREMENT,
    Day         INTEGER NOT NULL ON CONFLICT ROLLBACK,
    Month       INTEGER NOT NULL ON CONFLICT ROLLBACK,
    Year        INTEGER NOT NULL ON CONFLICT ROLLBACK,
    ProgramVers TEXT    NOT NULL ON CONFLICT ROLLBACK,
    SchemaVers  TEXT
);


-- Table: Exports
DROP TABLE IF EXISTS Exports;

CREATE TABLE Exports (
    Exports_ID     INTEGER PRIMARY KEY AUTOINCREMENT,
    Exports_Name   TEXT    NOT NULL ON CONFLICT ABORT
                           UNIQUE ON CONFLICT ABORT,
    Exports_Status BOOLEAN NOT NULL ON CONFLICT ABORT
                           DEFAULT (1) 
);


-- Table: CarrierAccts
DROP TABLE IF EXISTS CarrierAccts;

CREATE TABLE CarrierAccts (
    CarrierAccts_ID   INTEGER PRIMARY KEY ON CONFLICT ROLLBACK AUTOINCREMENT,
    CarrierAccts_Acct TEXT    NOT NULL ON CONFLICT ROLLBACK,
    MasterAddrID      INTEGER REFERENCES MasterAddresses (MasterAddr_ID) ON UPDATE CASCADE,
    Active            BOOLEAN NOT NULL ON CONFLICT ROLLBACK
                              DEFAULT (1) 
);


-- Table: ShipmentTypes
DROP TABLE IF EXISTS ShipmentTypes;

CREATE TABLE ShipmentTypes (
    ShipmentType_ID INTEGER PRIMARY KEY AUTOINCREMENT
                            NOT NULL,
    ShipmentType    TEXT    NOT NULL ON CONFLICT ABORT
);


-- Table: _OLD_PostalCodes
DROP TABLE IF EXISTS _OLD_PostalCodes;

CREATE TABLE _OLD_PostalCodes (
    PostalCode_ID  INTEGER PRIMARY KEY AUTOINCREMENT,
    ProvID         INTEGER NOT NULL ON CONFLICT ABORT
                           REFERENCES Provinces (Prov_ID),
    PostalCodeLow  TEXT,
    PostalCodeHigh TEXT,
    CountryID      INTEGER NOT NULL ON CONFLICT ABORT
                           REFERENCES Countries (Country_ID) 
);


COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
