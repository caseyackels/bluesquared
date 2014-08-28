
-- Table: Countries
CREATE TABLE Countries ( 
    Country_ID  INTEGER     PRIMARY KEY AUTOINCREMENT
                            NOT NULL,
    CountryCode CHAR( 2 )   NOT NULL
                            UNIQUE,
    CountryName CHAR( 50 )  NOT NULL 
);


-- Table: PostalCodes
CREATE TABLE PostalCodes ( 
    PostalCode_ID     INTEGER       PRIMARY KEY AUTOINCREMENT,
    PostalCodeLowEnd  INTEGER( 3 ),
    PostalCodeHighEnd INTEGER( 3 ),
    ProvID            INTEGER       NOT NULL
                                    REFERENCES Provinces ( Prov_ID ),
    CountryID         INTEGER       NOT NULL
                                    REFERENCES Countries ( Country_ID ) 
);


-- Table: Provinces
CREATE TABLE Provinces ( 
    Prov_ID   INTEGER    PRIMARY KEY AUTOINCREMENT
                         NOT NULL,
    Prov_Abbr CHAR( 3 )  NOT NULL
                         UNIQUE,
    Prov_Name TEXT       NOT NULL
                         UNIQUE 
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
                             UNIQUE ON CONFLICT FAIL,
    HeaderMaxLength  INTEGER,
    OutputHeaderName VARCHAR,
    Widget           VARCHAR,
    Highlight        VARCHAR,
    AlwaysDisplay    VARCHAR,
    Required         VARCHAR,
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


-- Table: CSRs
CREATE TABLE CSRs ( 
    CSR_ID    INTEGER PRIMARY KEY AUTOINCREMENT
                      NOT NULL,
    FirstName VARCHAR NOT NULL,
    LastName  VARCHAR 
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

