--
-- File generated with SQLiteStudio v3.1.0 on Thu Apr 19 08:00:44 2018
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: RptConfig
CREATE TABLE RptConfig (RptConfig_ID INTEGER PRIMARY KEY AUTOINCREMENT, DistributionTypeID INTEGER NOT NULL ON CONFLICT ABORT REFERENCES DistributionTypes (DistributionType_ID) ON DELETE CASCADE ON UPDATE CASCADE, RptActionsID INTEGER REFERENCES RptActions (RptAction_ID) ON UPDATE CASCADE);

-- Table: Users
CREATE TABLE Users (User_ID INTEGER PRIMARY KEY AUTOINCREMENT, UserLogin TEXT UNIQUE ON CONFLICT ABORT NOT NULL ON CONFLICT ABORT, UserName TEXT, UserEmail TEXT, UserPwd TEXT NOT NULL ON CONFLICT ABORT, UserSalt TEXT, User_Status BOOLEAN DEFAULT (1));

-- Table: RptMethod
CREATE TABLE RptMethod (RptMethod_ID INTEGER PRIMARY KEY AUTOINCREMENT, RptMethod TEXT NOT NULL ON CONFLICT ROLLBACK);

-- Table: sched_disclaimer
CREATE TABLE sched_disclaimer (disclaimer_id INTEGER PRIMARY KEY AUTOINCREMENT, disclaimer_desc VARCHAR (20) NOT NULL ON CONFLICT ROLLBACK UNIQUE ON CONFLICT ROLLBACK, disclaimer_text TEXT NOT NULL ON CONFLICT ROLLBACK);

-- Table: sched_freightHoliday
CREATE TABLE sched_freightHoliday (freightHoliday_id INTEGER PRIMARY KEY AUTOINCREMENT, freightHoliday_date DATE NOT NULL ON CONFLICT ROLLBACK, freightHoliday_desc VARCHAR (20));

-- Table: sched_DateType
CREATE TABLE sched_DateType (dateType_id INTEGER PRIMARY KEY AUTOINCREMENT, fk_groups_id INTEGER REFERENCES "sched-Groups" (groups_id) ON UPDATE CASCADE, dateType_Name VARCHAR (20) UNIQUE ON CONFLICT ROLLBACK NOT NULL ON CONFLICT ROLLBACK, dateType_Weekend BOOLEAN DEFAULT (0) NOT NULL ON CONFLICT ROLLBACK, dateType_PlantHoliday BOOLEAN DEFAULT (0) NOT NULL ON CONFLICT ROLLBACK, dateType_FreightHoliday BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (0), dateType_USPSHoliday BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (0));

-- Table: RptAddresses
CREATE TABLE RptAddresses (RptAddress_ID INTEGER PRIMARY KEY AUTOINCREMENT, RptConfigID INTEGER REFERENCES RptConfig (RptConfig_ID) ON DELETE CASCADE ON UPDATE CASCADE, MasterAddrID INTEGER REFERENCES MasterAddresses (MasterAddr_ID) ON DELETE CASCADE ON UPDATE CASCADE, ShipViaID INTEGER REFERENCES ShipVia (ShipVia_ID) ON DELETE CASCADE ON UPDATE CASCADE);

-- Table: Modules
CREATE TABLE Modules (Mod_ID INTEGER PRIMARY KEY AUTOINCREMENT, ModuleName VARCHAR NOT NULL ON CONFLICT ABORT UNIQUE ON CONFLICT IGNORE, EnableModNotification BOOLEAN DEFAULT (1), ModuleCode TEXT (2) NOT NULL ON CONFLICT ROLLBACK);

-- Table: Packages
CREATE TABLE [Packages] ([Pkg_ID] INTEGER PRIMARY KEY AUTOINCREMENT, [Package] TEXT NOT NULL ON CONFLICT ABORT);

-- Table: RptActions
CREATE TABLE RptActions (RptAction_ID INTEGER PRIMARY KEY AUTOINCREMENT, RptAction TEXT NOT NULL ON CONFLICT ROLLBACK, RptMethodID INTEGER REFERENCES RptMethod (RptMethod_ID) ON UPDATE CASCADE);

-- Table: Provinces
CREATE TABLE [Provinces] ([Prov_ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, [ProvAbbr] CHAR (3) NOT NULL, [ProvName] TEXT NOT NULL, [PostalCodeLowEnd] TEXT, [PostalCodeHighEnd] TEXT, [CountryID] INTEGER REFERENCES [Countries] ([Country_ID]) ON DELETE CASCADE);

-- Table: RateTypes
CREATE TABLE [RateTypes] ([RateType_ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, [RateType] TEXT NOT NULL ON CONFLICT ABORT);

-- Table: Reports
CREATE TABLE Reports (Reports_ID INTEGER PRIMARY KEY AUTOINCREMENT, Reports_Name TEXT NOT NULL ON CONFLICT ABORT UNIQUE ON CONFLICT ABORT, Reports_Status BOOLEAN NOT NULL ON CONFLICT ABORT DEFAULT (1));

-- Table: PubTitle
CREATE TABLE PubTitle (Title_ID INTEGER PRIMARY KEY AUTOINCREMENT, TitleName TEXT NOT NULL ON CONFLICT ABORT, CustID TEXT REFERENCES Customer (Cust_ID), Status BOOLEAN, CSRID VARCHAR REFERENCES CSRs (CSR_ID) NOT NULL ON CONFLICT ROLLBACK, SaveLocation TEXT);

-- Table: sched_frequency
CREATE TABLE sched_frequency (frequency_id INTEGER PRIMARY KEY AUTOINCREMENT, frequency_desc VARCHAR (20) NOT NULL ON CONFLICT ROLLBACK, frequency_days INTEGER NOT NULL ON CONFLICT ROLLBACK);

-- Table: ShippingClasses
CREATE TABLE [ShippingClasses] ([ShippingClass_ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, [ShippingClass] TEXT NOT NULL ON CONFLICT ABORT);

-- Table: sched_Groups
CREATE TABLE sched_Groups (groups_id INTEGER PRIMARY KEY AUTOINCREMENT, groups_name VARCHAR (20) UNIQUE ON CONFLICT ROLLBACK NOT NULL ON CONFLICT ROLLBACK);

-- Table: ShipVia
CREATE TABLE ShipVia (ShipVia_ID INTEGER PRIMARY KEY AUTOINCREMENT, CarrierID INTEGER REFERENCES Carriers (Carrier_ID) ON DELETE CASCADE ON UPDATE CASCADE, CarrierPkgID INTEGER REFERENCES CarrierPkg (CarrierPkg_ID), ShipViaCode TEXT UNIQUE ON CONFLICT ABORT, FreightPayerType TEXT NOT NULL ON CONFLICT ABORT, ShipViaName TEXT NOT NULL ON CONFLICT ABORT, ShipmentType TEXT NOT NULL ON CONFLICT ABORT, RateType TEXT, RateTable TEXT);

-- Table: UOM
CREATE TABLE [UOM] ([UOM_ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, [UOM] VARCHAR NOT NULL UNIQUE ON CONFLICT ABORT);

-- Table: UserDefinedValues
CREATE TABLE UserDefinedValues (UserDefinedValue_ID INTEGER PRIMARY KEY AUTOINCREMENT, PrimaryKeyName TEXT UNIQUE ON CONFLICT ROLLBACK NOT NULL ON CONFLICT ROLLBACK, TableName TEXT UNIQUE ON CONFLICT ROLLBACK NOT NULL ON CONFLICT ROLLBACK, Description TEXT NOT NULL ON CONFLICT ROLLBACK UNIQUE ON CONFLICT ROLLBACK, DisplayColValues TEXT);

-- Table: SubHeaders
CREATE TABLE SubHeaders (SubHeaderName VARCHAR UNIQUE ON CONFLICT ROLLBACK PRIMARY KEY ASC ON CONFLICT ROLLBACK COLLATE NOCASE, HeaderConfigID TEXT NOT NULL ON CONFLICT ROLLBACK REFERENCES HeadersConfig (HeaderConfig_ID) ON UPDATE CASCADE);

-- Table: ShipmentTypes
CREATE TABLE [ShipmentTypes] ([ShipmentType_ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, [ShipmentType] TEXT NOT NULL ON CONFLICT ABORT);

-- Table: sched_PlantHoliday
CREATE TABLE sched_PlantHoliday (plantHoliday_id INTEGER PRIMARY KEY AUTOINCREMENT, plantHoliday_date DATE NOT NULL ON CONFLICT ROLLBACK, plantHoliday_desc VARCHAR (20));

-- Table: sched_uspsHoliday
CREATE TABLE sched_uspsHoliday (uspsHoliday_id INTEGER PRIMARY KEY AUTOINCREMENT, uspsHoliday_date DATE NOT NULL ON CONFLICT ROLLBACK, uspsHoliday_desc VARCHAR (20));

-- Table: SecurityAccess
CREATE TABLE SecurityAccess (SecAccess_ID INTEGER PRIMARY KEY AUTOINCREMENT, SecGrpNameID INTEGER REFERENCES SecGroupNames (SecGroupName_ID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL ON CONFLICT ROLLBACK, ModID INTEGER REFERENCES Modules (Mod_ID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL ON CONFLICT ROLLBACK, SecAccess_Read BOOLEAN DEFAULT (0) NOT NULL ON CONFLICT ROLLBACK, SecAccess_Write BOOLEAN DEFAULT (0) NOT NULL ON CONFLICT ROLLBACK, SecAccess_Delete BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (0));

-- Table: sched_workflow
CREATE TABLE sched_workflow (workflow_id INTEGER PRIMARY KEY AUTOINCREMENT, workflow_desc VARCHAR (20) NOT NULL ON CONFLICT ROLLBACK UNIQUE ON CONFLICT ROLLBACK, workflow_primaryDate BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (0), workflow_offset INTEGER (1) NOT NULL ON CONFLICT ROLLBACK DEFAULT (0), fk_dateType_id INTEGER REFERENCES "sched-DateType" (dateType_id) ON UPDATE CASCADE);

-- Table: SecGroupNames
CREATE TABLE SecGroupNames (SecGroupName_ID INTEGER PRIMARY KEY AUTOINCREMENT, SecGroupName TEXT UNIQUE ON CONFLICT ROLLBACK NOT NULL ON CONFLICT ROLLBACK, Status BOOLEAN DEFAULT (1) NOT NULL ON CONFLICT ROLLBACK);

-- Table: SecGroups
CREATE TABLE SecGroups (SecGrp_ID INTEGER PRIMARY KEY AUTOINCREMENT, SecGroupNameID INTEGER NOT NULL ON CONFLICT ABORT REFERENCES SecGroupNames (SecGroupName_ID) ON UPDATE CASCADE, UserID INTEGER NOT NULL ON CONFLICT ABORT REFERENCES Users (User_ID) ON UPDATE CASCADE);

-- Table: Schema
CREATE TABLE Schema (idx INTEGER PRIMARY KEY AUTOINCREMENT, Date DATE NOT NULL ON CONFLICT ROLLBACK, ProgramVers TEXT NOT NULL ON CONFLICT ROLLBACK, SchemaVers TEXT, FileName TEXT, UserID INTEGER REFERENCES Users (User_ID) ON UPDATE CASCADE);

-- Table: MasterAddresses
CREATE TABLE MasterAddresses (MasterAddr_ID INTEGER PRIMARY KEY AUTOINCREMENT, MasterAddr_Company TEXT NOT NULL ON CONFLICT ROLLBACK, MasterAddr_Attn TEXT, MasterAddr_Addr1 TEXT NOT NULL ON CONFLICT ROLLBACK, MasterAddr_Addr2 TEXT, MasterAddr_Addr3 TEXT, MasterAddr_City TEXT NOT NULL ON CONFLICT ROLLBACK, MasterAddr_StateAbbr TEXT NOT NULL ON CONFLICT ROLLBACK, MasterAddr_Zip TEXT NOT NULL ON CONFLICT ROLLBACK, MasterAddr_CtryCode TEXT REFERENCES Countries (CountryCode) ON UPDATE CASCADE NOT NULL ON CONFLICT ROLLBACK, MasterAddr_Phone TEXT, MasterAddr_Plant BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (0), MasterAddr_Active BOOLEAN DEFAULT (1) NOT NULL ON CONFLICT ROLLBACK, MasterAddr_Internal BOOLEAN DEFAULT (0) NOT NULL ON CONFLICT ROLLBACK);

-- Table: CSRs
CREATE TABLE CSRs (CSR_ID VARCHAR (6, 0) PRIMARY KEY ON CONFLICT ABORT NOT NULL UNIQUE ON CONFLICT ABORT, FirstName VARCHAR NOT NULL, LastName VARCHAR, Email VARCHAR, Status BOOLEAN DEFAULT (1));

-- Table: LabelVersions
CREATE TABLE LabelVersions (labelVersionID INTEGER PRIMARY KEY AUTOINCREMENT, tplID INTEGER REFERENCES LabelTPL (tplID) ON DELETE CASCADE NOT NULL, LabelVersionDesc TEXT NOT NULL ON CONFLICT ROLLBACK);

-- Table: Customer
CREATE TABLE Customer (Cust_ID TEXT PRIMARY KEY NOT NULL ON CONFLICT ABORT UNIQUE ON CONFLICT ABORT, CustName TEXT NOT NULL ON CONFLICT ABORT, Status BOOLEAN DEFAULT (1));

-- Table: DistributionTypeCarriers
CREATE TABLE DistributionTypeCarriers (DistributionTypesCarriers_ID INTEGER PRIMARY KEY AUTOINCREMENT, DistributionTypeID INTEGER NOT NULL ON CONFLICT ROLLBACK REFERENCES DistributionTypes (DistributionType_ID) ON DELETE CASCADE ON UPDATE CASCADE, CarrierID INTEGER REFERENCES Carriers (Carrier_ID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL ON CONFLICT ROLLBACK, ShipViaID INTEGER REFERENCES ShipVia (ShipVia_ID) ON DELETE CASCADE ON UPDATE CASCADE);

-- Table: DistributionTypes
CREATE TABLE DistributionTypes (DistributionType_ID INTEGER PRIMARY KEY AUTOINCREMENT, DistTypeName TEXT UNIQUE ON CONFLICT ABORT NOT NULL ON CONFLICT ABORT, DistType_Status BOOLEAN DEFAULT (1) NOT NULL ON CONFLICT ABORT, DistType_ShipTypeID INTEGER REFERENCES ShipmentTypes (ShipmentType_ID) ON UPDATE CASCADE);

-- Table: CustomerShipVia
CREATE TABLE CustomerShipVia (CustomerShipVia_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, CustID INTEGER REFERENCES Customer (Cust_ID), ShipViaID INTEGER REFERENCES ShipVia (ShipVia_ID));

-- Table: Countries
CREATE TABLE [Countries] ([Country_ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, [CountryCode] VARCHAR (2) NOT NULL UNIQUE, [CountryName] TEXT NOT NULL);

-- Table: _OLD_AccountNumbers
CREATE TABLE _OLD_AccountNumbers (AcctNumbers_ID INTEGER PRIMARY KEY AUTOINCREMENT, CompaniesID INTEGER REFERENCES MasterAddresses (MasterAddr_ID) ON UPDATE CASCADE, CarriersID INTEGER REFERENCES Carriers (Carrier_ID) ON UPDATE CASCADE, AcctNumber TEXT);

-- Table: _OLD_Headers
CREATE TABLE _OLD_Headers (Header_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, InternalHeaderName TEXT NOT NULL UNIQUE ON CONFLICT ABORT, HeaderMaxLength INTEGER NOT NULL ON CONFLICT ABORT, OutputHeaderName TEXT NOT NULL ON CONFLICT ABORT, Widget TEXT NOT NULL ON CONFLICT ABORT, Highlight TEXT, AlwaysDisplay BOOLEAN, Required BOOLEAN, DefaultWidth INTEGER, ResizeColumn BOOLEAN, DisplayOrder INTEGER);

-- Table: Containers
CREATE TABLE [Containers] ([Container_ID] INTEGER PRIMARY KEY AUTOINCREMENT, [Container] TEXT NOT NULL ON CONFLICT ABORT);

-- Table: _OLD_PostalCodes
CREATE TABLE [_OLD_PostalCodes] ([PostalCode_ID] INTEGER PRIMARY KEY AUTOINCREMENT, [ProvID] INTEGER NOT NULL ON CONFLICT ABORT REFERENCES [Provinces] ([Prov_ID]), [PostalCodeLow] TEXT, [PostalCodeHigh] TEXT, [CountryID] INTEGER NOT NULL ON CONFLICT ABORT REFERENCES [Countries] ([Country_ID]));

-- Table: CarrierPkg
CREATE TABLE CarrierPkg (CarrierPkg_ID INTEGER PRIMARY KEY ASC AUTOINCREMENT, CarrierID INTEGER NOT NULL ON CONFLICT ROLLBACK REFERENCES Carriers (Carrier_ID), CarrierPkgDesc VARCHAR (25) NOT NULL ON CONFLICT ROLLBACK);

-- Table: Carriers
CREATE TABLE Carriers (Carrier_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, Name TEXT NOT NULL ON CONFLICT ABORT UNIQUE ON CONFLICT ABORT, RateType VARCHAR, RateTable VARCHAR);

-- Table: CarrierAccts
CREATE TABLE CarrierAccts (CarrierAccts_ID INTEGER PRIMARY KEY ON CONFLICT ROLLBACK AUTOINCREMENT, CarrierAccts_Acct TEXT NOT NULL ON CONFLICT ROLLBACK, Active BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (1), MasterAddrID INTEGER REFERENCES MasterAddresses (MasterAddr_ID) ON UPDATE CASCADE, CarrierID INTEGER REFERENCES Carriers (Carrier_ID) ON UPDATE CASCADE);

-- Table: EmailNotifications
CREATE TABLE [EmailNotifications] ([EN_ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, [ModuleName] VARCHAR NOT NULL, [EventName] VARCHAR NOT NULL UNIQUE ON CONFLICT ABORT, [EventNotification] BOOLEAN NOT NULL, [EmailFrom] VARCHAR NOT NULL ON CONFLICT ABORT, [EmailTo] VARCHAR NOT NULL ON CONFLICT ABORT, [EmailSubject] VARCHAR NOT NULL ON CONFLICT ABORT, [EmailBody] VARCHAR NOT NULL ON CONFLICT ABORT);

-- Table: LabelData
CREATE TABLE LabelData (labelDataID INTEGER PRIMARY KEY AUTOINCREMENT, labelVersionID INTEGER REFERENCES LabelVersions (labelVersionID) ON UPDATE CASCADE NOT NULL ON CONFLICT ROLLBACK, labelRowNum VARCHAR NOT NULL ON CONFLICT FAIL, labelRowText TEXT NOT NULL ON CONFLICT FAIL, userEditable BOOLEAN DEFAULT (0), isVersion BOOLEAN DEFAULT (0));

-- Table: LabelHeaderGrp
CREATE TABLE LabelHeaderGrp (LabelProfileID INTEGER REFERENCES LabelProfiles (LabelProfileID), LabelHeaderID INTEGER REFERENCES LabelHeaders (LabelHeaderID));

-- Table: EmailSetup
CREATE TABLE [EmailSetup] ([Email_ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, [EmailServer] VARCHAR NOT NULL, [EmailPassword] VARCHAR, [EmailPort] INTEGER, [EmailLogin] VARCHAR, [GlobalEmailNotification] BOOLEAN NOT NULL DEFAULT(1), [TLS] BOOLEAN DEFAULT(0));

-- Table: LabelHeaders
CREATE TABLE LabelHeaders (LabelHeaderID INTEGER PRIMARY KEY AUTOINCREMENT, LabelHeaderDesc TEXT NOT NULL ON CONFLICT ABORT UNIQUE ON CONFLICT ROLLBACK, LabelHeaderSystemOnly BOOLEAN DEFAULT (0));

-- Table: LabelSizes
CREATE TABLE LabelSizes (labelSizeID INTEGER PRIMARY KEY AUTOINCREMENT, labelSizeDesc TEXT NOT NULL ON CONFLICT ROLLBACK, labelSizeWidth DECIMAL NOT NULL ON CONFLICT ROLLBACK, labelSizeHeight DECIMAL NOT NULL ON CONFLICT ROLLBACK, labelSizeOrient TEXT, labelSizeMaxChar INTEGER);

-- Table: LabelTPL
CREATE TABLE LabelTPL (tplID INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE ON CONFLICT ROLLBACK NOT NULL ON CONFLICT ROLLBACK, PubTitleID INTEGER REFERENCES PubTitle (Title_ID), LabelProfileID INTEGER REFERENCES LabelProfiles (LabelProfileID), labelSizeID INTEGER REFERENCES LabelSizes (labelSizeID), tplLabelName TEXT NOT NULL ON CONFLICT ROLLBACK, tplLabelPath TEXT NOT NULL ON CONFLICT ROLLBACK, tplNotePriv TEXT, tplNotePub TEXT, tplFixedBoxQty INTEGER, tplFixedLabelInfo BOOLEAN, tplSerialize BOOLEAN, Status BOOLEAN DEFAULT (1));

-- Table: LabelProfiles
CREATE TABLE LabelProfiles (LabelProfileID INTEGER PRIMARY KEY AUTOINCREMENT, LabelProfileDesc TEXT UNIQUE ON CONFLICT ROLLBACK);

-- Table: IntlShipTerms
CREATE TABLE [IntlShipTerms] ([Terms_ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, [TermsAbbr] VARCHAR NOT NULL UNIQUE ON CONFLICT ABORT, [TermsDesc] VARCHAR, [IncoTerms] INTEGER);

-- Table: EventNotifications
CREATE TABLE EventNotifications (Event_ID INTEGER PRIMARY KEY AUTOINCREMENT, ModID INTEGER NOT NULL ON CONFLICT ABORT REFERENCES Modules (Mod_ID), EventName VARCHAR NOT NULL ON CONFLICT ABORT, EventSubstitutions VARCHAR, EnableEventNotification BOOLEAN DEFAULT (1));

-- Table: ForestOrg
CREATE TABLE ForestOrg (ForestOrg_ID INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE ON CONFLICT ROLLBACK NOT NULL ON CONFLICT ROLLBACK, ForestOrgName TEXT UNIQUE ON CONFLICT ROLLBACK NOT NULL ON CONFLICT ROLLBACK, ForestOrgNum TEXT UNIQUE ON CONFLICT ROLLBACK NOT NULL ON CONFLICT ROLLBACK, Active BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (1));

-- Table: IntlLicense
CREATE TABLE [IntlLicense] ([License_ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, [LicenseAbbr] VARCHAR NOT NULL UNIQUE ON CONFLICT ABORT, [LicenseDesc] VARCHAR);

-- Table: ForestType
CREATE TABLE ForestType (ForestType_ID INTEGER PRIMARY KEY ON CONFLICT ROLLBACK AUTOINCREMENT NOT NULL ON CONFLICT ROLLBACK UNIQUE ON CONFLICT ROLLBACK, ForestTypeDesc TEXT NOT NULL ON CONFLICT ROLLBACK, Active BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (1), ForestOrgID INTEGER REFERENCES ForestOrg (ForestOrg_ID) ON UPDATE CASCADE NOT NULL ON CONFLICT ROLLBACK);

-- Table: FreightRates
CREATE TABLE [FreightRates] ([RateTable_ID] REFERENCES [CarrierName] ([RateTable]), [WeightLow1] INTEGER, [WeightHigh1] INTEGER, [ShippingCost] VARCHAR);

-- Table: HeadersConfig
CREATE TABLE HeadersConfig (HeaderConfig_ID TEXT NOT NULL PRIMARY KEY ON CONFLICT ROLLBACK UNIQUE ON CONFLICT ROLLBACK, dbColName TEXT NOT NULL ON CONFLICT ROLLBACK UNIQUE ON CONFLICT ROLLBACK, dbDataType TEXT NOT NULL ON CONFLICT ROLLBACK, widLabelName TEXT NOT NULL ON CONFLICT ROLLBACK UNIQUE ON CONFLICT ROLLBACK, widLabelAlignment TEXT NOT NULL ON CONFLICT ROLLBACK, widWidget TEXT NOT NULL ON CONFLICT ROLLBACK, widValues TEXT, widDataType TEXT NOT NULL ON CONFLICT ROLLBACK, widFormat TEXT, widColAlignment TEXT NOT NULL ON CONFLICT ROLLBACK, widStartColWidth INTEGER NOT NULL ON CONFLICT ROLLBACK, widMaxWidth INTEGER NOT NULL ON CONFLICT ROLLBACK, widResizeToLongestEntry BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (0), widMaxStringLength INTEGER NOT NULL ON CONFLICT ROLLBACK, widHighlightColor TEXT, widUIGroup TEXT NOT NULL ON CONFLICT ROLLBACK, widUIPositionWeight INTEGER NOT NULL ON CONFLICT ROLLBACK DEFAULT (0), widExportable BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (1), widRequired BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (0), widDisplayType TEXT NOT NULL ON CONFLICT ROLLBACK, dbActive BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (1), CopyColumn BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (0));

-- Table: FreightPayer
CREATE TABLE [FreightPayer] ([FreightPayer_ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, [Payer] TEXT NOT NULL ON CONFLICT ABORT);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
