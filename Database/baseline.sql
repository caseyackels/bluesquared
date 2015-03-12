
-- Table: Countries
CREATE TABLE Countries ( 
    Country_ID  INTEGER    PRIMARY KEY AUTOINCREMENT
                           NOT NULL,
    CountryCode CHAR( 2 )  NOT NULL
                           UNIQUE,
    CountryName TEXT       NOT NULL 
);


-- Table: Provinces
CREATE TABLE Provinces ( 
    Prov_ID           INTEGER    PRIMARY KEY AUTOINCREMENT
                                 NOT NULL,
    ProvAbbr          CHAR( 3 )  NOT NULL
                                 UNIQUE,
    ProvName          TEXT       NOT NULL
                                 UNIQUE,
    PostalCodeLowEnd  VARCHAR,
    PostalCodeHighEnd VARCHAR,
    CountryID         INTEGER    REFERENCES Countries ( Country_ID ) ON UPDATE CASCADE 
);


-- Table: PostalCodes
CREATE TABLE PostalCodes ( 
    PostalCode_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    ProvID        INTEGER NOT NULL
                          REFERENCES Provinces ( Prov_ID ),
    CountryID     INTEGER NOT NULL
                          REFERENCES Countries ( Country_ID ),
    PostalCode    VARCHAR 
);


-- Table: Customers
CREATE TABLE Customers ( 
    Customer_ID INTEGER    PRIMARY KEY AUTOINCREMENT
                           NOT NULL ON CONFLICT ABORT,
    Name        VARCHAR    NOT NULL ON CONFLICT ABORT,
    Attn        VARCHAR,
    Address1    VARCHAR    NOT NULL ON CONFLICT ABORT,
    Address2    VARCHAR,
    Address3    VARCHAR,
    City        VARCHAR    NOT NULL ON CONFLICT ABORT,
    State       CHAR( 2 )  NOT NULL ON CONFLICT ABORT,
    Provinces              REFERENCES Provinces ( Prov_ID ),
    PostalCode             REFERENCES PostalCodes ( PostalCode_ID ),
    Country                REFERENCES Countries ( Country_ID ) 
);


-- Table: FreightPayer
CREATE TABLE FreightPayer ( 
    FreightPayer_ID INTEGER NOT NULL
                            REFERENCES ShipVia ( FreightPayer ),
    Payer           VARCHAR 
);


-- Table: AccountNumbers
CREATE TABLE AccountNumbers ( 
    Account_ID  INTEGER REFERENCES Customers ( Customer_ID ),
    CarrierName VARCHAR,
    AcctNumber  VARCHAR 
);


-- Table: ShipVia
CREATE TABLE ShipVia ( 
    ShipVia_ID   VARCHAR REFERENCES AccountNumbers ( CarrierName ),
    ShipViaCode  VARCHAR,
    CarrierName  TEXT    REFERENCES Carriers ( Name ),
    FreightPayer         REFERENCES FreightPayer ( Payer ),
    RateType     TEXT,
    RateTable 
);


-- Table: Headers
CREATE TABLE Headers ( 
    Header_ID        INTEGER PRIMARY KEY AUTOINCREMENT
                             NOT NULL,
    HeaderName       VARCHAR NOT NULL
                             UNIQUE ON CONFLICT ABORT,
    HeaderMaxLength  INTEGER NOT NULL ON CONFLICT ABORT,
    OutputHeaderName VARCHAR NOT NULL ON CONFLICT ABORT,
    Widget           VARCHAR NOT NULL ON CONFLICT ABORT,
    Highlight        VARCHAR,
    AlwaysDisplay    BOOLEAN DEFAULT ( 1 ),
    Required         BOOLEAN DEFAULT ( 1 ),
    DefaultWidth     INTEGER 
);


-- Table: SubHeaders
CREATE TABLE SubHeaders ( 
    SubHeader_ID  INTEGER PRIMARY KEY AUTOINCREMENT
                          NOT NULL,
    SubHeaderName VARCHAR UNIQUE ON CONFLICT FAIL,
    HeaderID      INTEGER NOT NULL
                          REFERENCES Headers ( Header_ID ) 
);


-- Table: UOM
CREATE TABLE UOM ( 
    UOM_ID INTEGER PRIMARY KEY AUTOINCREMENT
                   NOT NULL,
    UOM    VARCHAR NOT NULL
                   UNIQUE ON CONFLICT ABORT 
);


-- Table: IntlLicense
CREATE TABLE IntlLicense ( 
    License_ID  INTEGER PRIMARY KEY AUTOINCREMENT
                        NOT NULL,
    LicenseAbbr VARCHAR NOT NULL
                        UNIQUE ON CONFLICT ABORT,
    LicenseDesc VARCHAR 
);


-- Table: IntlShipTerms
CREATE TABLE IntlShipTerms ( 
    Terms_ID  INTEGER PRIMARY KEY AUTOINCREMENT
                      NOT NULL,
    TermsAbbr VARCHAR NOT NULL
                      UNIQUE ON CONFLICT ABORT,
    TermsDesc VARCHAR,
    IncoTerms INTEGER 
);


-- Table: CarrierName
CREATE TABLE CarrierName ( 
    Carrier_ID INTEGER NOT NULL
                       REFERENCES ShipVia ( CarrierName ),
    Name       VARCHAR NOT NULL ON CONFLICT ABORT,
    RateType   VARCHAR,
    RateTable  VARCHAR 
);


-- Table: FreightRates
CREATE TABLE FreightRates ( 
    RateTable_ID         REFERENCES CarrierName ( RateTable ),
    WeightLow1   INTEGER,
    WeightHigh1  INTEGER,
    ShippingCost VARCHAR 
);


-- Table: Containers
CREATE TABLE Containers ( 
    Container_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Container    TEXT    NOT NULL ON CONFLICT ABORT 
);


-- Table: Packages
CREATE TABLE Packages ( 
    Pkg_ID  INTEGER PRIMARY KEY AUTOINCREMENT,
    Package TEXT    NOT NULL ON CONFLICT ABORT 
);


-- Table: Schema
CREATE TABLE Schema ( 
    idx                   INTEGER PRIMARY KEY AUTOINCREMENT,
    Day                   INTEGER NOT NULL ON CONFLICT ROLLBACK,
    Month                 INTEGER NOT NULL ON CONFLICT ROLLBACK,
    Year                  INTEGER NOT NULL ON CONFLICT ROLLBACK,
    CompatibleProgramVers VARCHAR NOT NULL ON CONFLICT ROLLBACK 
);


-- Table: EmailSetup
CREATE TABLE EmailSetup ( 
    Email_ID                INTEGER PRIMARY KEY AUTOINCREMENT
                                    NOT NULL,
    EmailServer             VARCHAR NOT NULL,
    EmailPassword           VARCHAR,
    EmailPort               INTEGER,
    EmailLogin              VARCHAR,
    GlobalEmailNotification BOOLEAN NOT NULL
                                    DEFAULT ( 1 ),
    TLS                     BOOLEAN DEFAULT ( 0 ) 
);


-- Table: Modules
CREATE TABLE Modules ( 
    Mod_ID                INTEGER PRIMARY KEY AUTOINCREMENT,
    ModuleName            VARCHAR NOT NULL ON CONFLICT ABORT
                                  UNIQUE ON CONFLICT ABORT,
    EnableModNotification BOOLEAN DEFAULT ( 1 ) 
);


-- Table: EventNotifications
CREATE TABLE EventNotifications ( 
    Event_ID                INTEGER PRIMARY KEY AUTOINCREMENT,
    ModID                   NONE    NOT NULL ON CONFLICT ABORT
                                    REFERENCES Modules ( Mod_ID ),
    EventName               VARCHAR NOT NULL ON CONFLICT ABORT,
    EventSubstitutions      VARCHAR,
    EnableEventNotification BOOLEAN DEFAULT ( 1 ) 
);


-- Table: EmailNotifications
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


-- Table: CSRs
CREATE TABLE CSRs ( 
    CSR_ID    VARCHAR( 6 )  PRIMARY KEY ON CONFLICT ABORT
                            NOT NULL
                            UNIQUE ON CONFLICT ABORT,
    FirstName VARCHAR       NOT NULL,
    LastName  VARCHAR,
    Email     VARCHAR,
    Status    BOOLEAN       DEFAULT ( 1 ) 
);


-- View: Ex. Show SubHeaders
CREATE VIEW [Ex. Show SubHeaders] AS
       SELECT SubHeaderName
         FROM SubHeaders
              LEFT OUTER JOIN Headers
                           ON SubHeaders.HeaderID = Headers.Header_ID
        WHERE HeaderName = 'Company';
;

