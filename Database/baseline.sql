--
-- File generated with SQLiteStudio v3.1.0 on Tue Jun 5 07:28:10 2018
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: RptConfig
CREATE TABLE RptConfig (RptConfig_ID INTEGER PRIMARY KEY AUTOINCREMENT, DistributionTypeID INTEGER NOT NULL ON CONFLICT ABORT REFERENCES DistributionTypes (DistributionType_ID) ON DELETE CASCADE ON UPDATE CASCADE, RptActionsID INTEGER REFERENCES RptActions (RptAction_ID) ON UPDATE CASCADE);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (17, 21, 6);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (18, 21, 6);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (19, 22, 6);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (20, 22, 6);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (23, 24, 6);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (24, 24, 6);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (25, 25, 6);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (26, 25, 6);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (27, 26, 6);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (28, 26, 6);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (69, 28, 4);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (70, 28, 6);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (71, 30, 5);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (72, 30, 6);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (81, 33, 5);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (82, 33, 6);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (86, 31, 4);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (87, 31, 6);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (88, 31, 1);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (92, 32, 4);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (93, 32, 6);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (94, 32, 1);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (96, 23, 5);
INSERT INTO RptConfig (RptConfig_ID, DistributionTypeID, RptActionsID) VALUES (97, 23, 2);

-- Table: Users
CREATE TABLE Users (User_ID INTEGER PRIMARY KEY AUTOINCREMENT, UserLogin TEXT UNIQUE ON CONFLICT ABORT NOT NULL ON CONFLICT ABORT, UserName TEXT, UserEmail TEXT, UserPwd TEXT NOT NULL ON CONFLICT ABORT, UserSalt TEXT, User_Status BOOLEAN DEFAULT (1));
INSERT INTO Users (User_ID, UserLogin, UserName, UserEmail, UserPwd, UserSalt, User_Status) VALUES (1, 'casey.ackels', '', '', '$1$sOHwO2Lj$Ze8hciirmPA3qDsHPPISW0', 'sOHwO2LjwALpha6x9UblEku54qZJpx/B9K4/tYscTcNISL9tw1rEXGiV6u2e592zdH.A6UyOEX9IR5peDQa4al2QeLxwwHYWlaBk', 1);
INSERT INTO Users (User_ID, UserLogin, UserName, UserEmail, UserPwd, UserSalt, User_Status) VALUES (2, 'shipping', '', '', '', '', 1);
INSERT INTO Users (User_ID, UserLogin, UserName, UserEmail, UserPwd, UserSalt, User_Status) VALUES (3, 'barry.tiller', '', '', ' ', '', 1);
INSERT INTO Users (User_ID, UserLogin, UserName, UserEmail, UserPwd, UserSalt, User_Status) VALUES (4, 'dave.renner', '', '', ' ', '', 0);
INSERT INTO Users (User_ID, UserLogin, UserName, UserEmail, UserPwd, UserSalt, User_Status) VALUES (5, 'casey', NULL, NULL, '$1$FQh/VxkP$9egUB3bOCOS46mStiaqTO0', 'FQh/VxkPwj4shDF2.B/Yb103HO7ttCJlLN5MUpmOhG2tecdJF6DvoH5CCpJbmjC82VhanITKhbhd.98zrVwvx0vNn11cp5V/phTf', 1);
INSERT INTO Users (User_ID, UserLogin, UserName, UserEmail, UserPwd, UserSalt, User_Status) VALUES (8, 'test5', 'test5', 'test7', '$1$pn17FYKG$Ev3F6zcuYJTu5rLCV53xH1', 'pn17FYKGxW8Y1mIG5rRU98RjIFRK8OBrHmZOXznKZ5ii67TLXUkWlsswzih9vbT4wSAAG6yr/gqcO4bt48XAZn1fKu73sQuzwyOq', 1);
INSERT INTO Users (User_ID, UserLogin, UserName, UserEmail, UserPwd, UserSalt, User_Status) VALUES (11, 'jg.shipping', '', '', '$1$8ibsz1Ec$lg/9KGRjZxm6WKjhD.2ZW/', '8ibsz1EcwpKAPfPGXvXKd2CHgWBSG/PB14MaQs9DrMy8CFU5j5GkmSXADGpVBNfiJKDZ8CAk90OmLEymUEwO.p31w9eV5zMtypHN', 1);
INSERT INTO Users (User_ID, UserLogin, UserName, UserEmail, UserPwd, UserSalt, User_Status) VALUES (18, 'lyn.lovell', '', '', ' ', '', 1);

-- Table: RptMethod
CREATE TABLE RptMethod (RptMethod_ID INTEGER PRIMARY KEY AUTOINCREMENT, RptMethod TEXT NOT NULL ON CONFLICT ROLLBACK);
INSERT INTO RptMethod (RptMethod_ID, RptMethod) VALUES (1, 'Export');
INSERT INTO RptMethod (RptMethod_ID, RptMethod) VALUES (2, 'Report');

-- Table: sched_disclaimer
CREATE TABLE sched_disclaimer (disclaimer_id INTEGER PRIMARY KEY AUTOINCREMENT, disclaimer_desc VARCHAR (20) NOT NULL ON CONFLICT ROLLBACK UNIQUE ON CONFLICT ROLLBACK, disclaimer_text TEXT NOT NULL ON CONFLICT ROLLBACK);

-- Table: sched_freightHoliday
CREATE TABLE sched_freightHoliday (freightHoliday_id INTEGER PRIMARY KEY AUTOINCREMENT, freightHoliday_date DATE NOT NULL ON CONFLICT ROLLBACK, freightHoliday_desc VARCHAR (20));

-- Table: sched_DateType
CREATE TABLE sched_DateType (dateType_id INTEGER PRIMARY KEY AUTOINCREMENT, fk_groups_id INTEGER REFERENCES "sched-Groups" (groups_id) ON UPDATE CASCADE, dateType_Name VARCHAR (20) UNIQUE ON CONFLICT ROLLBACK NOT NULL ON CONFLICT ROLLBACK, dateType_Weekend BOOLEAN DEFAULT (0) NOT NULL ON CONFLICT ROLLBACK, dateType_PlantHoliday BOOLEAN DEFAULT (0) NOT NULL ON CONFLICT ROLLBACK, dateType_FreightHoliday BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (0), dateType_USPSHoliday BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (0));
INSERT INTO sched_DateType (dateType_id, fk_groups_id, dateType_Name, dateType_Weekend, dateType_PlantHoliday, dateType_FreightHoliday, dateType_USPSHoliday) VALUES (4, 1, 'Files In', 1, 1, 0, 0);
INSERT INTO sched_DateType (dateType_id, fk_groups_id, dateType_Name, dateType_Weekend, dateType_PlantHoliday, dateType_FreightHoliday, dateType_USPSHoliday) VALUES (5, 1, 'Print Files', 1, 1, 1, 1);

-- Table: RptAddresses
CREATE TABLE RptAddresses (RptAddress_ID INTEGER PRIMARY KEY AUTOINCREMENT, RptConfigID INTEGER REFERENCES RptConfig (RptConfig_ID) ON DELETE CASCADE ON UPDATE CASCADE, MasterAddrID INTEGER REFERENCES MasterAddresses (MasterAddr_ID) ON DELETE CASCADE ON UPDATE CASCADE, ShipViaID INTEGER REFERENCES ShipVia (ShipVia_ID) ON DELETE CASCADE ON UPDATE CASCADE);
INSERT INTO RptAddresses (RptAddress_ID, RptConfigID, MasterAddrID, ShipViaID) VALUES (3, 60, 3, NULL);
INSERT INTO RptAddresses (RptAddress_ID, RptConfigID, MasterAddrID, ShipViaID) VALUES (4, 63, 3, NULL);
INSERT INTO RptAddresses (RptAddress_ID, RptConfigID, MasterAddrID, ShipViaID) VALUES (5, 66, 3, 139);
INSERT INTO RptAddresses (RptAddress_ID, RptConfigID, MasterAddrID, ShipViaID) VALUES (6, 69, 3, 139);
INSERT INTO RptAddresses (RptAddress_ID, RptConfigID, MasterAddrID, ShipViaID) VALUES (7, 76, 5, 120);
INSERT INTO RptAddresses (RptAddress_ID, RptConfigID, MasterAddrID, ShipViaID) VALUES (8, 79, 2, 173);
INSERT INTO RptAddresses (RptAddress_ID, RptConfigID, MasterAddrID, ShipViaID) VALUES (9, 73, 7, 120);
INSERT INTO RptAddresses (RptAddress_ID, RptConfigID, MasterAddrID, ShipViaID) VALUES (10, 83, 7, 120);
INSERT INTO RptAddresses (RptAddress_ID, RptConfigID, MasterAddrID, ShipViaID) VALUES (11, 86, 7, 120);
INSERT INTO RptAddresses (RptAddress_ID, RptConfigID, MasterAddrID, ShipViaID) VALUES (12, 89, 5, 120);
INSERT INTO RptAddresses (RptAddress_ID, RptConfigID, MasterAddrID, ShipViaID) VALUES (13, 92, 5, 120);
INSERT INTO RptAddresses (RptAddress_ID, RptConfigID, MasterAddrID, ShipViaID) VALUES (14, 97, 4, 20);

-- Table: Modules
CREATE TABLE Modules (Mod_ID INTEGER PRIMARY KEY AUTOINCREMENT, ModuleName VARCHAR NOT NULL ON CONFLICT ABORT UNIQUE ON CONFLICT IGNORE, EnableModNotification BOOLEAN DEFAULT (1), ModuleCode TEXT (2) NOT NULL ON CONFLICT ROLLBACK);
INSERT INTO Modules (Mod_ID, ModuleName, EnableModNotification, ModuleCode) VALUES (1, 'Box Labels', 1, 'BL');
INSERT INTO Modules (Mod_ID, ModuleName, EnableModNotification, ModuleCode) VALUES (2, 'Batch Maker', 1, 'BM');
INSERT INTO Modules (Mod_ID, ModuleName, EnableModNotification, ModuleCode) VALUES (3, 'Setup', 1, 'SU');
INSERT INTO Modules (Mod_ID, ModuleName, EnableModNotification, ModuleCode) VALUES (4, 'Batch Formatter', 1, 'BF');
INSERT INTO Modules (Mod_ID, ModuleName, EnableModNotification, ModuleCode) VALUES (5, 'Scheduler', 1, 'SC');
INSERT INTO Modules (Mod_ID, ModuleName, EnableModNotification, ModuleCode) VALUES (6, 'Label Designer', 1, 'LD');
INSERT INTO Modules (Mod_ID, ModuleName, EnableModNotification, ModuleCode) VALUES (280, 'Load Flags', 1, 'LF');

-- Table: Packages
CREATE TABLE [Packages] ([Pkg_ID] INTEGER PRIMARY KEY AUTOINCREMENT, [Package] TEXT NOT NULL ON CONFLICT ABORT);
INSERT INTO Packages (Pkg_ID, Package) VALUES (1, 'Bundles, Loose');
INSERT INTO Packages (Pkg_ID, Package) VALUES (2, 'Bundles, Strapped');
INSERT INTO Packages (Pkg_ID, Package) VALUES (3, 'Ctn, 12.25 x 9.25 x 9 - 1364');
INSERT INTO Packages (Pkg_ID, Package) VALUES (4, 'Ctn, 11 x 9.125 x 9.5 - 1952');
INSERT INTO Packages (Pkg_ID, Package) VALUES (5, 'Ctn, 11 x 8.5 x 6 - 2228');
INSERT INTO Packages (Pkg_ID, Package) VALUES (6, 'Ctn, 11 x 8.5 x 9 - 2456');
INSERT INTO Packages (Pkg_ID, Package) VALUES (7, 'Ctn, 11 x 9.125 x 4 - 2598');
INSERT INTO Packages (Pkg_ID, Package) VALUES (8, 'Ctn, 11 x 8.5 x 9 UPS 44# - 2647');
INSERT INTO Packages (Pkg_ID, Package) VALUES (9, 'Ctn, 12.125 x 10.125 x 9 - 2650');
INSERT INTO Packages (Pkg_ID, Package) VALUES (10, 'Ctn, 12.125 x 9.625 x 3 - 3160');
INSERT INTO Packages (Pkg_ID, Package) VALUES (11, 'Ctn, 12.125 x 9.625 x 6 - 3161');
INSERT INTO Packages (Pkg_ID, Package) VALUES (12, 'Ctn, 12.25 x 11 x 6.5 - 3410');
INSERT INTO Packages (Pkg_ID, Package) VALUES (13, 'Ctn, 17 x 11 x 6 - 3541');
INSERT INTO Packages (Pkg_ID, Package) VALUES (14, 'Ctn, 11 x 8.5 x 3 - 3755');
INSERT INTO Packages (Pkg_ID, Package) VALUES (15, 'Ctn, 10.625 x 8.125 x 9 - 3905');
INSERT INTO Packages (Pkg_ID, Package) VALUES (19, 'Ctn, USPS 11 x 8.5 x 5.5');
INSERT INTO Packages (Pkg_ID, Package) VALUES (20, 'Ctn, USPS 12 x 12 x 5.5');
INSERT INTO Packages (Pkg_ID, Package) VALUES (21, 'Ctn, USPS 13.625 x 7.875 x 3.375');
INSERT INTO Packages (Pkg_ID, Package) VALUES (22, 'Env, USPS Flat Rate');

-- Table: RptActions
CREATE TABLE RptActions (RptAction_ID INTEGER PRIMARY KEY AUTOINCREMENT, RptAction TEXT NOT NULL ON CONFLICT ROLLBACK, RptMethodID INTEGER REFERENCES RptMethod (RptMethod_ID) ON UPDATE CASCADE);
INSERT INTO RptActions (RptAction_ID, RptAction, RptMethodID) VALUES (1, 'Summarize', 2);
INSERT INTO RptActions (RptAction_ID, RptAction, RptMethodID) VALUES (2, 'Single Entry', 2);
INSERT INTO RptActions (RptAction_ID, RptAction, RptMethodID) VALUES (4, 'Single Entry', 1);
INSERT INTO RptActions (RptAction_ID, RptAction, RptMethodID) VALUES (5, 'Default', 1);
INSERT INTO RptActions (RptAction_ID, RptAction, RptMethodID) VALUES (6, 'Default', 2);

-- Table: Provinces
CREATE TABLE [Provinces] ([Prov_ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, [ProvAbbr] CHAR (3) NOT NULL, [ProvName] TEXT NOT NULL, [PostalCodeLowEnd] TEXT, [PostalCodeHighEnd] TEXT, [CountryID] INTEGER REFERENCES [Countries] ([Country_ID]) ON DELETE CASCADE);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (1, 'PR', 'Puerto Rico', '006', '007', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (2, 'PR', 'Puerto Rico', '009', '009', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (8, 'MA', 'Massachussetts', '010', '027', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (9, 'RI', 'Rhode Island', '028', '029', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (10, 'NH', 'New Hampshire', '030', '038', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (11, 'ME', 'Maine', '039', '049', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (12, 'VT', 'Vermont', '056', '059', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (13, 'MA', 'Massachussetts', '055', '055', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (15, 'CT', 'Connecticut', '060', '069', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (16, 'NJ', 'New Jersey', '070', '089', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (17, 'NY', 'New York', '100', '149', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (18, 'PA', 'Pennsylvania', '150', '196', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (19, 'DE', 'Delaware', '197', '199', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (20, 'DC', 'District Of Columbia', '200', '200', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (21, 'VA', 'Virgina', '201', '201', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (22, 'MD', 'Maryland', '206', '212', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (23, 'WV', 'West Virgina', '247', '268', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (24, 'NC', 'North Carolina', '270', '289', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (25, 'SC', 'South Carolina', '290', '299', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (26, 'GA', 'Georgia', '300', '319', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (27, 'FL', 'Florida', '320', '349', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (28, 'AL', 'Alabama', '350', '369', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (29, 'TN', 'Tennessee', '370', '385', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (30, 'MS', 'Mississippi', '386', '397', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (31, 'GA', 'Georgia', '398', '399', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (32, 'KY', 'Kentucky', '400', '427', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (33, 'OH', 'Ohio', '430', '459', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (34, 'IN', 'Indiana', '460', '479', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (35, 'MI', 'Michigan', '480', '499', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (36, 'IA', 'Iowa', '500', '528', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (37, 'WI', 'Wisconsin', '530', '549', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (38, 'MN', 'Minnesota', '550', '567', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (39, 'SD', 'South Dakota', '570', '577', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (40, 'ND', 'North Dakota', '580', '588', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (41, 'MT', 'Montana', '590', '599', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (42, 'IL', 'Illinois', '600', '629', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (43, 'MO', 'Missouri', '630', '658', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (44, 'KS', 'Kansas', '660', '679', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (45, 'NE', 'Nebraska', '680', '693', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (46, 'LA', 'Lousiana', '700', '714', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (47, 'MS', 'Mississippi', '712', '712', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (48, 'AR', 'Arkansas', '716', '729', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (49, 'OK', 'Oklahoma', '730', '731', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (50, 'OK', 'Oklahoma', '734', '749', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (51, 'TX', 'Texas', '750', '799', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (52, 'AR', 'Arkansas', '755', '755', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (53, 'TX', 'Texas', '756', '799', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (54, 'CO', 'Colorado', '800', '816', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (55, 'WY', 'Wyoming', '820', '831', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (56, 'ID', 'Idaho', '832', '838', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (57, 'UT', 'Utah', '840', '847', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (58, 'AZ', 'Arizona', '850', '865', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (59, 'NM', 'New Mexico', '870', '884', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (60, 'TX', 'Texas', '885', '885', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (61, 'NV', 'Nevada', '889', '898', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (62, 'CA', 'California', '900', '961', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (63, 'HI', 'Hawaii', '967', '968', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (64, 'OR', 'Oregon', '970', '979', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (65, 'WA', 'Washington', '980', '994', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (66, 'AK', 'Alaska', '995', '999', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (67, 'AS', 'American Samoa', '96799', '96799', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (68, 'AA', 'Army Post Office Americas', '', '', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (69, 'AE', 'Army Post Office Europe', '', '', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (70, 'AP', 'Army Post Office Pacific', '', '', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (71, 'FM', 'Federated States Of Micronesia', '', '', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (72, 'AA', 'Fleet Post Office Americas', '', '', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (73, 'AE', 'Fleet Post Office Europe', '', '', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (74, 'AP', 'Fleet Post Office Pacific', '', '', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (75, 'GU', 'Guam', '969', '969', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (76, 'MH', 'Marshall Islands', '969', '969', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (77, 'MP', 'Northern Mariana Islands', '', '', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (78, 'PW', 'Palau', '', '', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (79, 'VI', 'Virgin Islands', '008', '008', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (80, 'AI', 'Aichi', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (81, 'FI', 'Fukui', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (82, 'HS', 'Hiroshima', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (83, 'IW', 'Iwate', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (84, 'KM', 'Kumamoto', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (85, 'NN', 'Nagano', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (87, 'OY', 'Okayama', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (88, 'SH', 'Shiga', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (89, 'TK', 'Tokyo', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (90, 'YC', 'Yamaguchi', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (91, 'AK', 'Akita', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (92, 'FO', 'Fukuoka', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (93, 'HK', 'Hokkaido', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (94, 'KG', 'Kagawa', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (95, 'KY', 'Kyoto', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (96, 'NS', 'Nagasaki', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (97, 'ON', 'Okinawa', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (98, 'SM', 'Shimane', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (99, 'TT', 'Tottori', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (100, 'YN', 'Yamanashi', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (101, 'AO', 'Aomori', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (102, 'FS', 'Fukushima', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (103, 'HG', 'Hyogo', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (104, 'KS', 'Kagoshima', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (105, 'ME', 'Mie', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (106, 'NR', 'Nara', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (107, 'OS', 'Osaka', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (108, 'SZ', 'Shizuoka', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (109, 'TY', 'Toyama', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (110, 'CH', 'Chiba', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (111, 'GI', 'Gifu', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (112, 'IB', 'Ibaraki', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (113, 'KN', 'Kanagawa', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (114, 'MG', 'Miyagi', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (115, 'NI', 'Niigata', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (116, 'SG', 'Saga', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (117, 'TC', 'Tochigi', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (118, 'WK', 'Wakayama', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (119, 'EH', 'Ehime', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (120, 'GM', 'Gumma', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (121, 'IS', 'Ishikawa', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (122, 'KC', 'Kochi', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (123, 'MZ', 'Miyazaki', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (124, 'OT', 'Oita', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (125, 'SI', 'Saitama', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (126, 'TS', 'Tokushima', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (127, 'YT', 'Yamagata', '', '', 19);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (128, 'AB', 'Alberta', 'T', 'T', 2);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (129, 'NT', 'Northwest Territories', 'X', 'X', 2);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (130, 'QC', 'Quebec', 'G', 'G', 2);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (131, 'NS', 'Nova Scotia', 'B', 'B', 2);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (132, 'SK', 'Saskatchewan', 'S', 'S', 2);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (133, 'MB', 'Manitoba', 'R', 'R', 2);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (134, 'NU', 'Nunavut', 'X', 'X', 2);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (135, 'YT', 'Yukon', 'X', 'X', 2);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (136, 'NB', 'New Brunswick', 'E', 'E', 2);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (137, 'ON', 'Ontario', 'K', 'K', 2);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (138, 'ON', 'Ontario', 'L', 'L', 2);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (139, 'ON', 'Ontario', 'M', 'M', 2);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (140, 'ON', 'Ontario', 'N', 'N', 2);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (141, 'ON', 'Ontario', 'P', 'P', 2);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (142, 'NL', 'Newfoundland', 'A', 'A', 2);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (143, 'PE', 'Prince Edward Island', 'C', 'C', 2);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (144, 'QC', 'Quebec', 'H', 'H', 2);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (145, 'QC', 'Quebec', 'J', 'J', 2);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (146, 'DF', 'Distrito Federal', '0', '1', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (147, 'AG', 'Aguascallientes', '20', '20', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (148, 'BS', 'Baja California', '21', '22', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (149, 'BCS', 'Baja California Sur', '23', '23', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (150, 'CM', 'Campeche', '24', '24', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (151, 'CA', 'Coahuila', '25', '27', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (152, 'CL', 'Colima', '28', '28', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (153, 'CP', 'Chiapas', '29', '30', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (154, 'CH', 'Chihuahua', '31', '33', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (155, 'DU', 'Durango', '34', '35', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (156, 'GJ', 'Guanajuato', '36', '38', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (157, 'GR', 'Guerrero', '39', '39', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (158, 'HI', 'Hidalgo', '42', '43', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (159, 'JA', 'Jalisco', '44', '48', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (160, 'MX', 'Mexico State', '50', '57', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (161, 'MC', 'Michoacan', '58', '61', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (162, 'MR', 'Morelos', '62', '62', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (163, 'NA', 'Nayarit', '63', '63', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (164, 'NL', 'Nuevo Leon', '64', '67', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (165, 'OA', 'Oaxaca', '68', '71', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (166, 'PU', 'Puebla', '72', '75', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (167, 'QE', 'Queretaro', '76', '76', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (168, 'QR', 'Quintana Roo', '77', '77', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (169, 'SL', 'San Luis Potosi', '78', '79', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (170, 'SI', 'Sinaloa', '80', '82', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (171, 'SO', 'Sonora', '83', '85', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (172, 'TB', 'Tabasco', '86', '86', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (173, 'TM', 'Tamaulipas', '86', '86', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (174, 'TL', 'Tlaxcala', '90', '90', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (175, 'VE', 'Veracruz', '91', '94', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (176, 'YU', 'Yucatan', '97', '97', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (177, 'ZA', 'Zacatecas', '98', '98', 3);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (178, 'VT', 'Vermont', '050', '054', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (179, 'DC', 'District Of Columbia', '202', '205', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (180, 'MD', 'Maryland', '214', '219', 7);
INSERT INTO Provinces (Prov_ID, ProvAbbr, ProvName, PostalCodeLowEnd, PostalCodeHighEnd, CountryID) VALUES (181, 'VA', 'Virgina', '220', '246', 7);

-- Table: RateTypes
CREATE TABLE [RateTypes] ([RateType_ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, [RateType] TEXT NOT NULL ON CONFLICT ABORT);
INSERT INTO RateTypes (RateType_ID, RateType) VALUES (1, 'Volume');
INSERT INTO RateTypes (RateType_ID, RateType) VALUES (2, 'Pallet Rate');

-- Table: Reports
CREATE TABLE Reports (Reports_ID INTEGER PRIMARY KEY AUTOINCREMENT, Reports_Name TEXT NOT NULL ON CONFLICT ABORT UNIQUE ON CONFLICT ABORT, Reports_Status BOOLEAN NOT NULL ON CONFLICT ABORT DEFAULT (1));
INSERT INTO Reports (Reports_ID, Reports_Name, Reports_Status) VALUES (1, 'General', 1);

-- Table: PubTitle
CREATE TABLE PubTitle (Title_ID INTEGER PRIMARY KEY AUTOINCREMENT, TitleName TEXT NOT NULL ON CONFLICT ABORT, CustID TEXT REFERENCES Customer (Cust_ID), Status BOOLEAN, CSRID VARCHAR REFERENCES CSRs (CSR_ID) NOT NULL ON CONFLICT ROLLBACK, SaveLocation TEXT);
INSERT INTO PubTitle (Title_ID, TitleName, CustID, Status, CSRID, SaveLocation) VALUES (6, 'Seattle Art Dealers', 'ENCMED', 1, 'MERHUN', NULL);
INSERT INTO PubTitle (Title_ID, TitleName, CustID, Status, CSRID, SaveLocation) VALUES (7, 'Washington Wine', 'SAGMED', 1, 'MERHUN', NULL);
INSERT INTO PubTitle (Title_ID, TitleName, CustID, Status, CSRID, SaveLocation) VALUES (8, 'Seattle Met', 'SAGMED', 1, 'MERHUN', NULL);
INSERT INTO PubTitle (Title_ID, TitleName, CustID, Status, CSRID, SaveLocation) VALUES (10, 'Test02', 'SAGMED', 0, 'MERHUN', NULL);
INSERT INTO PubTitle (Title_ID, TitleName, CustID, Status, CSRID, SaveLocation) VALUES (11, 'test1', 'temp', 1, 'MERHUN', NULL);
INSERT INTO PubTitle (Title_ID, TitleName, CustID, Status, CSRID, SaveLocation) VALUES (12, 'Free Surf Magazine', 'MANINC', 1, 'LYNLOV', NULL);
INSERT INTO PubTitle (Title_ID, TitleName, CustID, Status, CSRID, SaveLocation) VALUES (13, 'Harbors Magazine', 'KATMCK', 1, 'LYNLOV', NULL);
INSERT INTO PubTitle (Title_ID, TitleName, CustID, Status, CSRID, SaveLocation) VALUES (14, 'Wine Press', 'tricit', 1, 'TIFSTE', NULL);
INSERT INTO PubTitle (Title_ID, TitleName, CustID, Status, CSRID, SaveLocation) VALUES (15, 'MJSA Journal', 'MJSINC', 1, 'LYNLOV', NULL);
INSERT INTO PubTitle (Title_ID, TitleName, CustID, Status, CSRID, SaveLocation) VALUES (16, 'Portland Monthly', 'temp', 1, 'MERHUN', NULL);
INSERT INTO PubTitle (Title_ID, TitleName, CustID, Status, CSRID, SaveLocation) VALUES (21, 'MJSA TEST', 'MJSINC', 0, 'LYNLOV', NULL);
INSERT INTO PubTitle (Title_ID, TitleName, CustID, Status, CSRID, SaveLocation) VALUES (22, 'MJSA Journal TEST', 'MJSINC', 0, 'LYNLOV', NULL);
INSERT INTO PubTitle (Title_ID, TitleName, CustID, Status, CSRID, SaveLocation) VALUES (23, 'MJSA Journal 444', 'MJSINC', 0, 'LYNLOV', NULL);
INSERT INTO PubTitle (Title_ID, TitleName, CustID, Status, CSRID, SaveLocation) VALUES (24, 'MJSA Journal TEST001', 'MJSINC', 0, 'LYNLOV', NULL);
INSERT INTO PubTitle (Title_ID, TitleName, CustID, Status, CSRID, SaveLocation) VALUES (25, 'Test title', 'MJSINC', 0, 'LYNLOV', NULL);
INSERT INTO PubTitle (Title_ID, TitleName, CustID, Status, CSRID, SaveLocation) VALUES (26, 'Portland Monthly', 'SAGMED', 1, 'MERHUN', NULL);
INSERT INTO PubTitle (Title_ID, TitleName, CustID, Status, CSRID, SaveLocation) VALUES (30, 'Ruralite Magazine', 'RURSER', 1, 'MICKAL', NULL);
INSERT INTO PubTitle (Title_ID, TitleName, CustID, Status, CSRID, SaveLocation) VALUES (31, 'Living', 'WINSER', 1, 'PATMUR', NULL);
INSERT INTO PubTitle (Title_ID, TitleName, CustID, Status, CSRID, SaveLocation) VALUES (32, 'Artslandia', 'RAMCRE', 1, 'MICKAL', NULL);
INSERT INTO PubTitle (Title_ID, TitleName, CustID, Status, CSRID, SaveLocation) VALUES (33, 'Maui Drive Guide', 'HONPUB', 1, 'MERHUN', NULL);
INSERT INTO PubTitle (Title_ID, TitleName, CustID, Status, CSRID, SaveLocation) VALUES (34, 'Thunder Roads of Northern CA', 'STAHIL', 1, 'PATMUR', NULL);

-- Table: sched_frequency
CREATE TABLE sched_frequency (frequency_id INTEGER PRIMARY KEY AUTOINCREMENT, frequency_desc VARCHAR (20) NOT NULL ON CONFLICT ROLLBACK, frequency_days INTEGER NOT NULL ON CONFLICT ROLLBACK);
INSERT INTO sched_frequency (frequency_id, frequency_desc, frequency_days) VALUES (1, 'Weekly', 7);

-- Table: ShippingClasses
CREATE TABLE [ShippingClasses] ([ShippingClass_ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, [ShippingClass] TEXT NOT NULL ON CONFLICT ABORT);
INSERT INTO ShippingClasses (ShippingClass_ID, ShippingClass) VALUES (11, 'Proof 1');
INSERT INTO ShippingClasses (ShippingClass_ID, ShippingClass) VALUES (12, 'Proof 2');
INSERT INTO ShippingClasses (ShippingClass_ID, ShippingClass) VALUES (13, 'Samples');
INSERT INTO ShippingClasses (ShippingClass_ID, ShippingClass) VALUES (14, 'Promotional Samples');
INSERT INTO ShippingClasses (ShippingClass_ID, ShippingClass) VALUES (15, 'Buyout');
INSERT INTO ShippingClasses (ShippingClass_ID, ShippingClass) VALUES (16, 'Mail Drop');
INSERT INTO ShippingClasses (ShippingClass_ID, ShippingClass) VALUES (17, 'Job Component');
INSERT INTO ShippingClasses (ShippingClass_ID, ShippingClass) VALUES (18, 'Return materials to Customer');
INSERT INTO ShippingClasses (ShippingClass_ID, ShippingClass) VALUES (19, 'Internal Samples');
INSERT INTO ShippingClasses (ShippingClass_ID, ShippingClass) VALUES (20, 'Finished Product');

-- Table: sched_Groups
CREATE TABLE sched_Groups (groups_id INTEGER PRIMARY KEY AUTOINCREMENT, groups_name VARCHAR (20) UNIQUE ON CONFLICT ROLLBACK NOT NULL ON CONFLICT ROLLBACK);
INSERT INTO sched_Groups (groups_id, groups_name) VALUES (1, 'Files');

-- Table: ShipVia
CREATE TABLE ShipVia (ShipVia_ID INTEGER PRIMARY KEY AUTOINCREMENT, CarrierID INTEGER REFERENCES Carriers (Carrier_ID) ON DELETE CASCADE ON UPDATE CASCADE, CarrierPkgID INTEGER REFERENCES CarrierPkg (CarrierPkg_ID), ShipViaCode TEXT UNIQUE ON CONFLICT ABORT, FreightPayerType TEXT NOT NULL ON CONFLICT ABORT, ShipViaName TEXT NOT NULL ON CONFLICT ABORT, ShipmentType TEXT NOT NULL ON CONFLICT ABORT, RateType TEXT, RateTable TEXT);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (1, 27, NULL, '521', 'Sender', 'Peninsula Truck Lines', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (4, 5, NULL, '017', 'Sender', 'UPS Ground', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (5, 27, NULL, '571', 'ThirdParty', 'Peninsula Truck Lines - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (6, 5, NULL, '067', 'ThirdParty', 'UPS Ground - 3P', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (7, 5, NULL, '001', 'Sender', 'UPS Next Day Air', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (8, 5, NULL, '051', 'ThirdParty', 'UPS Next Day Air - 3P', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (9, 15, NULL, '613', 'Sender', 'FedEx Freight Priority', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (10, 15, NULL, '614', 'ThirdParty', 'FedEx Freight Priority - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (11, 14, NULL, '611', 'Sender', 'FedEx Freight Economy', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (12, 14, NULL, '612', 'ThirdParty', 'FedEx Freight Economy - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (13, 7, NULL, '518', 'Sender', 'Oak Harbor', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (14, 7, NULL, '568', 'ThirdParty', 'Oak Harbor - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (15, 8, NULL, '519', 'Sender', 'Old Dominion', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (16, 8, NULL, '595', 'ThirdParty', 'Old Dominion - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (17, 9, NULL, '511', 'Sender', 'Direct Transport', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (18, 10, NULL, '508', 'Sender', 'CH Robinson', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (19, 10, NULL, '558', 'ThirdParty', 'CH Robinson - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (20, 16, NULL, 'PN5', 'Sender', 'Hand Delivery', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (21, 17, NULL, '515', 'Sender', 'Honolulu Freight Service', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (22, 17, NULL, '565', 'ThirdParty', 'Honolulu Freight Service - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (23, 19, NULL, 'JGV', 'Sender', 'JG Courier', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (24, 20, NULL, 'JG', 'Sender', 'JG Truck', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (25, 21, NULL, '536', 'Sender', 'Lynden Transport', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (26, 21, NULL, '592', 'ThirdParty', 'Lynden Transport - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (27, 22, NULL, '628', 'Sender', 'Pilot Freight', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (28, 22, NULL, '629', 'ThirdParty', 'Pilot Freight - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (29, 23, NULL, '540', 'Sender', 'Mid America Overseas', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (30, 23, NULL, '600', 'ThirdParty', 'Mid America Overseas - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (31, 24, NULL, '524', 'Sender', 'Reddaway Freight Lines', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (32, 56, NULL, '546', 'Sender', 'Soniq Transportation', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (33, 56, NULL, '606', 'ThirdParty', 'Soniq Transportation - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (34, 26, NULL, '535', 'Sender', 'Yellow Transport', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (35, 26, NULL, '585', 'ThirdParty', 'Yellow Transport - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (36, 5, NULL, '002', 'Sender', 'UPS Next Day Air', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (37, 5, NULL, '003', 'Sender', 'UPS Next Day Air - AM', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (38, 5, NULL, '005', 'Sender', 'UPS Next Day Air Saver', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (39, 5, NULL, '006', 'Sender', 'UPS 2nd Day Air - AM', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (40, 5, NULL, '010', 'Sender', 'UPS 3 Day Select', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (41, 5, NULL, '016', 'Sender', 'UPS Std Service - Canada', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (42, 5, NULL, '019', 'Sender', 'UPS WW Next Day', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (43, 5, NULL, '029', 'Sender', 'UPS WW/2-5 Day', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (44, 5, NULL, '030', 'Sender', 'UPS WW Express Saver', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (45, 5, NULL, '053', 'ThirdParty', 'UPS NDA Letter - 3P', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (46, 5, NULL, '055', 'ThirdParty', 'UPS NDA Saver - 3P', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (47, 5, NULL, '056', 'ThirdParty', 'UPS 2 Day Air - 3P', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (48, 5, NULL, '060', 'ThirdParty', 'UPS 3 Day Select - 3P', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (49, 5, NULL, '066', 'ThirdParty', 'UPS Std Service - Canada - 3P', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (50, 5, NULL, '069', 'ThirdParty', 'UPS WW Express - 3P', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (51, 5, NULL, '079', 'ThirdParty', 'UPS WW Expedited - 3P', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (53, 28, NULL, '201', 'Sender', 'USPS Priority Mail', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (54, 28, NULL, '202', 'Sender', 'USPS Priority Intl Mail', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (55, 28, NULL, '203', 'Sender', 'USPS 1st Class Mail', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (56, 28, NULL, '204', 'Sender', 'USPS 1st Class Intl Mail', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (57, 28, NULL, '205', 'Sender', 'USPS Standard Post', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (58, 28, NULL, '207', 'Sender', 'USPS Express Mail', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (59, 29, NULL, '300', 'Sender', 'Vancouver Warehouse', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (60, 30, NULL, '301', 'Sender', 'Rapid Freight', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (61, 31, NULL, '302', 'Sender', 'City Sprint', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (62, 32, NULL, '303', 'Sender', 'MME', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (63, 33, NULL, '304', 'Sender', 'Network Delivery', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (64, 34, NULL, '305', 'Sender', 'Top Carrier', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (65, 35, NULL, '306', 'Sender', 'ET Line', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (66, 36, NULL, '307', 'Sender', 'R & L Carriers', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (67, 37, NULL, '308', 'Sender', 'Green Light Transport', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (68, 38, NULL, '309', 'Sender', 'Atam Trucking', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (69, 39, NULL, '310', 'Sender', 'Wine Consolidators', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (70, 40, NULL, '311', 'Sender', 'PO Truck', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (71, 29, NULL, '400', 'ThirdParty', 'Vancouver Warehouse - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (72, 30, NULL, '401', 'ThirdParty', 'Rapid Freight - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (73, 31, NULL, '402', 'ThirdParty', 'City Sprint - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (74, 32, NULL, '403', 'ThirdParty', 'MME - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (75, 33, NULL, '404', 'ThirdParty', 'Network Delivery - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (76, 34, NULL, '405', 'ThirdParty', 'Top Carrier - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (77, 35, NULL, '406', 'ThirdParty', 'ET Line - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (78, 36, NULL, '407', 'ThirdParty', 'R & L Carriers - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (79, 38, NULL, '409', 'ThirdParty', 'Atam Trucking - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (80, 39, NULL, '410', 'ThirdParty', 'Wine Consolidators - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (81, NULL, NULL, '510', 'Sender', 'Conway', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (82, 41, NULL, '516', 'Sender', 'McCracken Motor Freight', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (83, 42, NULL, '517', 'Sender', 'UPS Freight', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (84, 43, NULL, '520', 'Sender', 'Will Call', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (85, 44, NULL, '528', 'Sender', 'Saia', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (86, 45, NULL, '529', 'Sender', 'Seko Worldwide', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (87, 46, NULL, '531', 'Sender', 'TC Transport', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (88, 47, NULL, '533', 'Sender', 'TP Freight Lines', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (89, 50, NULL, '537', 'Sender', 'Lynden International', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (90, 51, NULL, '538', 'Sender', 'UPS Air Freight', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (91, 52, NULL, '539', 'Sender', 'Beaver Freight', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (92, 54, NULL, '541', 'Sender', 'UPS Freight - VPRC', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (93, 55, NULL, '544', 'Sender', 'Logistics Services', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (94, 57, NULL, '547', 'Sender', 'Future Logistics', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (95, 58, NULL, '549', 'Sender', 'General Transportation', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (96, 59, NULL, '551', 'Sender', 'ABF Freight', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (97, 9, NULL, '561', 'ThirdParty', 'Direct Transport - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (98, 41, NULL, '566', 'ThirdParty', 'McCracken Motor Freight - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (99, 42, NULL, '570', 'ThirdParty', 'UPS Freight - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (100, 24, NULL, '574', 'ThirdParty', 'Reddaway Freight Lines - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (101, 44, NULL, '578', 'ThirdParty', 'Saia - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (102, 45, NULL, '579', 'ThirdParty', 'Seko Worldwide - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (103, 46, NULL, '581', 'ThirdParty', 'TC Transport - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (104, 47, NULL, '583', 'ThirdParty', 'TP Freight Lines - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (105, 60, NULL, '586', 'ThirdParty', 'Hawaiian Express - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (106, 61, NULL, '588', 'ThirdParty', 'Span Alaska Trans - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (107, 62, NULL, '591', 'ThirdParty', 'Dependable Hawaii Express - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (108, 62, NULL, '594', 'Sender', 'Dependable Hawaii Express', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (109, 50, NULL, '596', 'ThirdParty', 'Lynden International - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (110, 51, NULL, '598', 'ThirdParty', 'UPS Air Freight - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (111, 52, NULL, '599', 'ThirdParty', 'Beaver Freight - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (112, 54, NULL, '601', 'ThirdParty', 'UPS Freight - VPRC - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (113, 55, NULL, '604', 'ThirdParty', 'Logistics Services - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (114, 57, NULL, '607', 'Sender', 'Future Logistics - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (115, 63, NULL, '615', 'Sender', 'Team Worldwide', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (116, 63, NULL, '616', 'ThirdParty', 'Team Worldwide - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (117, 64, NULL, '617', 'Sender', 'UPS Freight - ManQ', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (118, 65, NULL, '618', 'Sender', 'Import - Freight', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (119, 66, NULL, '619', 'Sender', 'Import - FedEx', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (120, 67, NULL, '620', 'Sender', 'Import - USPS', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (121, 58, NULL, '621', 'ThirdParty', 'General Transportation - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (122, 68, NULL, '622', 'Sender', 'Johanson Transport Svc', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (123, 68, NULL, '623', 'ThirdParty', 'Johanson Transport Svc - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (124, 69, NULL, '630', 'Sender', 'Ontrac International', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (125, 70, NULL, '631', 'Sender', 'Road Runner - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (126, 71, NULL, '633', 'Sender', 'Hawaiian Airlines', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (127, 71, NULL, '634', 'ThirdParty', 'Hawaiian Airlines - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (128, 72, NULL, '635', 'Sender', 'Jerry Thurman', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (129, 72, NULL, '636', 'ThirdParty', 'Jerry Thurman - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (130, 73, NULL, '637', 'Sender', 'Armstrong Transport', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (131, 73, NULL, '638', 'ThirdParty', 'Armstrong Transport - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (132, 74, NULL, '639', 'Sender', 'Grey Hound', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (133, 74, NULL, '640', 'ThirdParty', 'Grey Hound - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (134, 75, NULL, '641', 'Sender', 'Time Logistics', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (135, 75, NULL, '642', 'ThirdParty', 'Time Logistics - 3P', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (136, 76, NULL, 'BW', 'Sender', 'Bestway Prepaid', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (137, 79, NULL, 'PMH', 'Sender', 'Advantage', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (138, 80, NULL, 'PMI', 'Sender', 'Ceva Logistics', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (139, 81, NULL, 'PN2', 'Sender', 'Import - UPS', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (140, 82, NULL, 'PN3', 'Sender', 'Aes Logistics', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (141, 61, NULL, 'PN8', 'Sender', 'Span Alaska Trans', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (142, 85, NULL, 'PN9', 'Sender', 'JG Bindery', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (143, 60, NULL, 'PP1', 'Sender', 'Hawaiian Express', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (144, 86, NULL, 'PP2', 'Sender', 'JG Inventory', 'Freight', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (145, 87, NULL, '101', 'Sender', 'FedEx 2Day Air', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (146, 87, NULL, '109', 'Sender', 'FedEx 1st O/N', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (147, 87, NULL, '116', 'Sender', 'FedEx Intl Economy', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (148, 87, NULL, '117', 'Sender', 'FedEx Intl 1st', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (149, 87, NULL, '122', 'Sender', 'FedEx Intl Economy', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (150, 87, NULL, '126', 'Sender', 'FedEx Intl Priority', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (151, 87, NULL, '132', 'Sender', 'FedEx Priority O/N', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (152, 87, NULL, '137', 'Sender', 'FedEx Standard O/N', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (153, 87, NULL, '142', 'Sender', 'FedEx Express Saver', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (154, 87, NULL, '148', 'Sender', 'FedEx Ground', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (155, 87, NULL, '151', 'ThirdParty', 'FedEx 2Day Air - 3P', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (156, 87, NULL, '156', 'ThirdParty', 'FedEx 1st O/N - 3P', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (157, 87, NULL, '166', 'Sender', 'FedEx Intl Economy - 3P', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (158, 87, NULL, '167', 'ThirdParty', 'FedEx Intl 1st - 3P', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (159, 87, NULL, '176', 'ThirdParty', 'FedEx Intl Priority - 3P', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (160, 87, NULL, '182', 'ThirdParty', 'FedEx Priority O/N - 3P', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (161, 87, NULL, '187', 'ThirdParty', 'FedEx Standard O/N - 3P', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (162, 87, NULL, '192', 'ThirdParty', 'FedEx Express Saver - 3P', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (163, 87, NULL, '198', 'ThirdParty', 'FedEx Ground - 3P', 'Small Package', NULL, NULL);
INSERT INTO ShipVia (ShipVia_ID, CarrierID, CarrierPkgID, ShipViaCode, FreightPayerType, ShipViaName, ShipmentType, RateType, RateTable) VALUES (173, 88, NULL, 'PMJ', 'Sender', 'JG Mail', 'Freight', NULL, NULL);

-- Table: UOM
CREATE TABLE [UOM] ([UOM_ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, [UOM] VARCHAR NOT NULL UNIQUE ON CONFLICT ABORT);
INSERT INTO UOM (UOM_ID, UOM) VALUES (1, 'Each');
INSERT INTO UOM (UOM_ID, UOM) VALUES (2, 'Box');

-- Table: UserDefinedValues
CREATE TABLE UserDefinedValues (UserDefinedValue_ID INTEGER PRIMARY KEY AUTOINCREMENT, PrimaryKeyName TEXT UNIQUE ON CONFLICT ROLLBACK NOT NULL ON CONFLICT ROLLBACK, TableName TEXT UNIQUE ON CONFLICT ROLLBACK NOT NULL ON CONFLICT ROLLBACK, Description TEXT NOT NULL ON CONFLICT ROLLBACK UNIQUE ON CONFLICT ROLLBACK, DisplayColValues TEXT);
INSERT INTO UserDefinedValues (UserDefinedValue_ID, PrimaryKeyName, TableName, Description, DisplayColValues) VALUES (1, 'Pkg_ID', 'Packages', 'Packages', 'Package');
INSERT INTO UserDefinedValues (UserDefinedValue_ID, PrimaryKeyName, TableName, Description, DisplayColValues) VALUES (2, 'Container_ID', 'Containers', 'Container', 'Container');
INSERT INTO UserDefinedValues (UserDefinedValue_ID, PrimaryKeyName, TableName, Description, DisplayColValues) VALUES (3, 'ShipVia_ID', 'ShipVia', 'Ship Via', 'ShipViaName');
INSERT INTO UserDefinedValues (UserDefinedValue_ID, PrimaryKeyName, TableName, Description, DisplayColValues) VALUES (4, 'Version_ID', 'Versions', 'Versions', 'VersionName');
INSERT INTO UserDefinedValues (UserDefinedValue_ID, PrimaryKeyName, TableName, Description, DisplayColValues) VALUES (5, 'DistributionType_ID', 'DistributionTypes', 'Distribution Type', 'DistTypeName');
INSERT INTO UserDefinedValues (UserDefinedValue_ID, PrimaryKeyName, TableName, Description, DisplayColValues) VALUES (6, 'ShippingClass_ID', 'ShippingClasses', 'Shipping Class', 'ShippingClass');

-- Table: SubHeaders
CREATE TABLE SubHeaders (SubHeaderName VARCHAR UNIQUE ON CONFLICT ROLLBACK PRIMARY KEY ASC ON CONFLICT ROLLBACK COLLATE NOCASE, HeaderConfigID TEXT NOT NULL ON CONFLICT ROLLBACK REFERENCES HeadersConfig (HeaderConfig_ID) ON UPDATE CASCADE);
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Destination Name', '175454CA-5944-47AA-AD99-A8753B67BAA7');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('ShipToCompany', '175454CA-5944-47AA-AD99-A8753B67BAA7');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Business', '175454CA-5944-47AA-AD99-A8753B67BAA7');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Company Name', '175454CA-5944-47AA-AD99-A8753B67BAA7');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Company', '175454CA-5944-47AA-AD99-A8753B67BAA7');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Destination', '175454CA-5944-47AA-AD99-A8753B67BAA7');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Contact', '2A4C0578-7340-4F51-957B-440F231833EE');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Atten', '2A4C0578-7340-4F51-957B-440F231833EE');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('ShipToAttention', '2A4C0578-7340-4F51-957B-440F231833EE');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Name', '2A4C0578-7340-4F51-957B-440F231833EE');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Contact Name', '2A4C0578-7340-4F51-957B-440F231833EE');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Attn:', '2A4C0578-7340-4F51-957B-440F231833EE');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Attention', '2A4C0578-7340-4F51-957B-440F231833EE');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Attn', '2A4C0578-7340-4F51-957B-440F231833EE');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Addr1', '154AE040-2B77-4FC8-9F83-669BA76EA961');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('ShipToAddressLine1', '154AE040-2B77-4FC8-9F83-669BA76EA961');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Address', '154AE040-2B77-4FC8-9F83-669BA76EA961');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Add1', '154AE040-2B77-4FC8-9F83-669BA76EA961');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Addr', '154AE040-2B77-4FC8-9F83-669BA76EA961');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('AddressLine1', '154AE040-2B77-4FC8-9F83-669BA76EA961');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Address Line 1', '154AE040-2B77-4FC8-9F83-669BA76EA961');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Address1', '154AE040-2B77-4FC8-9F83-669BA76EA961');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Address Line 2', 'CA11D880-3F88-4F08-B1C6-B0CE7D156BF0');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('AddressLine2', 'CA11D880-3F88-4F08-B1C6-B0CE7D156BF0');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Address2', 'CA11D880-3F88-4F08-B1C6-B0CE7D156BF0');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Addr2', 'CA11D880-3F88-4F08-B1C6-B0CE7D156BF0');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('ShipToAddressLine2', 'CA11D880-3F88-4F08-B1C6-B0CE7D156BF0');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Add2', 'CA11D880-3F88-4F08-B1C6-B0CE7D156BF0');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('ShipToAddressLine3', 'E7084638-6238-4241-8C90-42D916508CD5');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Add3', 'E7084638-6238-4241-8C90-42D916508CD5');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Address Line 3', 'E7084638-6238-4241-8C90-42D916508CD5');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('AddressLine3', 'E7084638-6238-4241-8C90-42D916508CD5');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Address3', 'E7084638-6238-4241-8C90-42D916508CD5');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Addr3', 'E7084638-6238-4241-8C90-42D916508CD5');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('ShipToCity', '321F91EA-DF89-425B-9FDB-071733AC7375');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('City', '321F91EA-DF89-425B-9FDB-071733AC7375');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('ShipToState', '4C7BA09F-9627-4713-B11C-829A5AA2B87F');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('St.', '4C7BA09F-9627-4713-B11C-829A5AA2B87F');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('State', '4C7BA09F-9627-4713-B11C-829A5AA2B87F');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Province/State', '4C7BA09F-9627-4713-B11C-829A5AA2B87F');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Province', '4C7BA09F-9627-4713-B11C-829A5AA2B87F');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('St', '4C7BA09F-9627-4713-B11C-829A5AA2B87F');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('ShipToPostalCode', '3F61153C-317A-4803-9DC8-2F977CEA6834');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Zip Code', '3F61153C-317A-4803-9DC8-2F977CEA6834');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('PostalCode', '3F61153C-317A-4803-9DC8-2F977CEA6834');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Postal Code', '3F61153C-317A-4803-9DC8-2F977CEA6834');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Zip', '3F61153C-317A-4803-9DC8-2F977CEA6834');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Country', 'E67E25B4-D007-43C9-AEC2-FA95BA3D6A03');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('ShipToCountry', 'E67E25B4-D007-43C9-AEC2-FA95BA3D6A03');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Ph', '57633A12-B654-487F-A67B-65579454260E');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Phone', '57633A12-B654-487F-A67B-65579454260E');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('ShipToPhone', '57633A12-B654-487F-A67B-65579454260E');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Contact Phone', '57633A12-B654-487F-A67B-65579454260E');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Vers', 'C8071A7B-4887-468D-85EB-6FFFA1225992');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Ver', 'C8071A7B-4887-468D-85EB-6FFFA1225992');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Versions', 'C8071A7B-4887-468D-85EB-6FFFA1225992');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Boxes', '14BBF55D-59CD-47F9-9A23-6CE72BDAD18B');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Qty', '14BBF55D-59CD-47F9-9A23-6CE72BDAD18B');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('ShipQuantity', '14BBF55D-59CD-47F9-9A23-6CE72BDAD18B');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Copies', '14BBF55D-59CD-47F9-9A23-6CE72BDAD18B');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Quantity', '14BBF55D-59CD-47F9-9A23-6CE72BDAD18B');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('UserNotes', '16854952-09E1-41E8-82CC-A651A4A68A1C');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('User Notes', '16854952-09E1-41E8-82CC-A651A4A68A1C');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Notes', '16854952-09E1-41E8-82CC-A651A4A68A1C');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Ship', '960CED3A-1398-4815-B9AD-BEB14BACB2BB');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('ShipToDate', '960CED3A-1398-4815-B9AD-BEB14BACB2BB');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Ship Date', '960CED3A-1398-4815-B9AD-BEB14BACB2BB');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('ShipDate', '960CED3A-1398-4815-B9AD-BEB14BACB2BB');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('DistType', 'FF810ED1-5375-4E65-8152-391750B25874');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('DistributionType', 'FF810ED1-5375-4E65-8152-391750B25874');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('ShipVia', '4CE461A2-8B20-4ECA-A116-517499D42EB0');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('ArriveDate', '143A5368-8A34-46A3-B5A9-C9A3A4102E19');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('ContainerType', 'F3FFF64E-8A1D-4366-BBD1-324713E2A480');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Container', 'F3FFF64E-8A1D-4366-BBD1-324713E2A480');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('Package', 'BC175BC4-8B1D-45FA-9D2E-F02AD14D06E2');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('PackageType', 'BC175BC4-8B1D-45FA-9D2E-F02AD14D06E2');
INSERT INTO SubHeaders (SubHeaderName, HeaderConfigID) VALUES ('ShippingClass', '3B031381-EE6B-49AB-BDFF-B56140CBD60C');

-- Table: ShipmentTypes
CREATE TABLE [ShipmentTypes] ([ShipmentType_ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, [ShipmentType] TEXT NOT NULL ON CONFLICT ABORT);
INSERT INTO ShipmentTypes (ShipmentType_ID, ShipmentType) VALUES (2, 'Freight');
INSERT INTO ShipmentTypes (ShipmentType_ID, ShipmentType) VALUES (4, 'Small Package');
INSERT INTO ShipmentTypes (ShipmentType_ID, ShipmentType) VALUES (6, '-All-');

-- Table: sched_PlantHoliday
CREATE TABLE sched_PlantHoliday (plantHoliday_id INTEGER PRIMARY KEY AUTOINCREMENT, plantHoliday_date DATE NOT NULL ON CONFLICT ROLLBACK, plantHoliday_desc VARCHAR (20));

-- Table: sched_uspsHoliday
CREATE TABLE sched_uspsHoliday (uspsHoliday_id INTEGER PRIMARY KEY AUTOINCREMENT, uspsHoliday_date DATE NOT NULL ON CONFLICT ROLLBACK, uspsHoliday_desc VARCHAR (20));

-- Table: SecurityAccess
CREATE TABLE SecurityAccess (SecAccess_ID INTEGER PRIMARY KEY AUTOINCREMENT, SecGrpNameID INTEGER REFERENCES SecGroupNames (SecGroupName_ID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL ON CONFLICT ROLLBACK, ModID INTEGER REFERENCES Modules (Mod_ID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL ON CONFLICT ROLLBACK, SecAccess_Read BOOLEAN DEFAULT (0) NOT NULL ON CONFLICT ROLLBACK, SecAccess_Write BOOLEAN DEFAULT (0) NOT NULL ON CONFLICT ROLLBACK, SecAccess_Delete BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (0));
INSERT INTO SecurityAccess (SecAccess_ID, SecGrpNameID, ModID, SecAccess_Read, SecAccess_Write, SecAccess_Delete) VALUES (1, 1, 1, 1, 1, 1);
INSERT INTO SecurityAccess (SecAccess_ID, SecGrpNameID, ModID, SecAccess_Read, SecAccess_Write, SecAccess_Delete) VALUES (2, 1, 2, 1, 1, 1);
INSERT INTO SecurityAccess (SecAccess_ID, SecGrpNameID, ModID, SecAccess_Read, SecAccess_Write, SecAccess_Delete) VALUES (3, 1, 3, 1, 1, 1);
INSERT INTO SecurityAccess (SecAccess_ID, SecGrpNameID, ModID, SecAccess_Read, SecAccess_Write, SecAccess_Delete) VALUES (4, 2, 1, 1, 1, 1);
INSERT INTO SecurityAccess (SecAccess_ID, SecGrpNameID, ModID, SecAccess_Read, SecAccess_Write, SecAccess_Delete) VALUES (5, 2, 2, 1, 1, 1);
INSERT INTO SecurityAccess (SecAccess_ID, SecGrpNameID, ModID, SecAccess_Read, SecAccess_Write, SecAccess_Delete) VALUES (6, 2, 3, 0, 0, 0);
INSERT INTO SecurityAccess (SecAccess_ID, SecGrpNameID, ModID, SecAccess_Read, SecAccess_Write, SecAccess_Delete) VALUES (7, 3, 1, 1, 1, 1);
INSERT INTO SecurityAccess (SecAccess_ID, SecGrpNameID, ModID, SecAccess_Read, SecAccess_Write, SecAccess_Delete) VALUES (8, 3, 2, 0, 0, 0);
INSERT INTO SecurityAccess (SecAccess_ID, SecGrpNameID, ModID, SecAccess_Read, SecAccess_Write, SecAccess_Delete) VALUES (9, 3, 3, 0, 0, 0);
INSERT INTO SecurityAccess (SecAccess_ID, SecGrpNameID, ModID, SecAccess_Read, SecAccess_Write, SecAccess_Delete) VALUES (10, 1, 4, 1, 1, 1);
INSERT INTO SecurityAccess (SecAccess_ID, SecGrpNameID, ModID, SecAccess_Read, SecAccess_Write, SecAccess_Delete) VALUES (11, 1, 5, 1, 1, 1);
INSERT INTO SecurityAccess (SecAccess_ID, SecGrpNameID, ModID, SecAccess_Read, SecAccess_Write, SecAccess_Delete) VALUES (15, 1, 6, 1, 1, 1);
INSERT INTO SecurityAccess (SecAccess_ID, SecGrpNameID, ModID, SecAccess_Read, SecAccess_Write, SecAccess_Delete) VALUES (16, 1, 280, 1, 1, 1);
INSERT INTO SecurityAccess (SecAccess_ID, SecGrpNameID, ModID, SecAccess_Read, SecAccess_Write, SecAccess_Delete) VALUES (17, 2, 6, 1, 1, 1);

-- Table: sched_workflow
CREATE TABLE sched_workflow (workflow_id INTEGER PRIMARY KEY AUTOINCREMENT, workflow_desc VARCHAR (20) NOT NULL ON CONFLICT ROLLBACK UNIQUE ON CONFLICT ROLLBACK, workflow_primaryDate BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (0), workflow_offset INTEGER (1) NOT NULL ON CONFLICT ROLLBACK DEFAULT (0), fk_dateType_id INTEGER REFERENCES "sched-DateType" (dateType_id) ON UPDATE CASCADE);

-- Table: SecGroupNames
CREATE TABLE SecGroupNames (SecGroupName_ID INTEGER PRIMARY KEY AUTOINCREMENT, SecGroupName TEXT UNIQUE ON CONFLICT ROLLBACK NOT NULL ON CONFLICT ROLLBACK, Status BOOLEAN DEFAULT (1) NOT NULL ON CONFLICT ROLLBACK);
INSERT INTO SecGroupNames (SecGroupName_ID, SecGroupName, Status) VALUES (1, 'Admin', 1);
INSERT INTO SecGroupNames (SecGroupName_ID, SecGroupName, Status) VALUES (2, 'Distribution', 1);
INSERT INTO SecGroupNames (SecGroupName_ID, SecGroupName, Status) VALUES (3, 'Warehouse', 1);

-- Table: SecGroups
CREATE TABLE SecGroups (SecGrp_ID INTEGER PRIMARY KEY AUTOINCREMENT, SecGroupNameID INTEGER NOT NULL ON CONFLICT ABORT REFERENCES SecGroupNames (SecGroupName_ID) ON UPDATE CASCADE, UserID INTEGER NOT NULL ON CONFLICT ABORT REFERENCES Users (User_ID) ON UPDATE CASCADE);
INSERT INTO SecGroups (SecGrp_ID, SecGroupNameID, UserID) VALUES (19, 1, 3);
INSERT INTO SecGroups (SecGrp_ID, SecGroupNameID, UserID) VALUES (21, 3, 2);
INSERT INTO SecGroups (SecGrp_ID, SecGroupNameID, UserID) VALUES (22, 1, 4);
INSERT INTO SecGroups (SecGrp_ID, SecGroupNameID, UserID) VALUES (23, 1, 1);
INSERT INTO SecGroups (SecGrp_ID, SecGroupNameID, UserID) VALUES (24, 1, 5);
INSERT INTO SecGroups (SecGrp_ID, SecGroupNameID, UserID) VALUES (26, 2, 18);

-- Table: Schema
CREATE TABLE Schema (idx INTEGER PRIMARY KEY AUTOINCREMENT, Date DATE NOT NULL ON CONFLICT ROLLBACK, ProgramVers TEXT NOT NULL ON CONFLICT ROLLBACK, SchemaVers TEXT, FileName TEXT, UserID INTEGER REFERENCES Users (User_ID) ON UPDATE CASCADE);
INSERT INTO Schema (idx, Date, ProgramVers, SchemaVers, FileName, UserID) VALUES (1, '2014-2-9', '4.0.0', '1', 'baseline.sql', 1);

-- Table: MasterAddresses
CREATE TABLE MasterAddresses (MasterAddr_ID INTEGER PRIMARY KEY AUTOINCREMENT, MasterAddr_Company TEXT NOT NULL ON CONFLICT ROLLBACK, MasterAddr_Attn TEXT, MasterAddr_Addr1 TEXT NOT NULL ON CONFLICT ROLLBACK, MasterAddr_Addr2 TEXT, MasterAddr_Addr3 TEXT, MasterAddr_City TEXT NOT NULL ON CONFLICT ROLLBACK, MasterAddr_StateAbbr TEXT NOT NULL ON CONFLICT ROLLBACK, MasterAddr_Zip TEXT NOT NULL ON CONFLICT ROLLBACK, MasterAddr_CtryCode TEXT REFERENCES Countries (CountryCode) ON UPDATE CASCADE NOT NULL ON CONFLICT ROLLBACK, MasterAddr_Phone TEXT, MasterAddr_Plant BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (0), MasterAddr_Active BOOLEAN DEFAULT (1) NOT NULL ON CONFLICT ROLLBACK, MasterAddr_Internal BOOLEAN DEFAULT (0) NOT NULL ON CONFLICT ROLLBACK);
INSERT INTO MasterAddresses (MasterAddr_ID, MasterAddr_Company, MasterAddr_Attn, MasterAddr_Addr1, MasterAddr_Addr2, MasterAddr_Addr3, MasterAddr_City, MasterAddr_StateAbbr, MasterAddr_Zip, MasterAddr_CtryCode, MasterAddr_Phone, MasterAddr_Plant, MasterAddr_Active, MasterAddr_Internal) VALUES (1, 'Journal Graphics', 'Shipping Dept', '2840 NW 35th Ave', '', '', 'Portland', 'OR', '97210', 'US', '503-790-9100', 1, 1, 1);
INSERT INTO MasterAddresses (MasterAddr_ID, MasterAddr_Company, MasterAddr_Attn, MasterAddr_Addr1, MasterAddr_Addr2, MasterAddr_Addr3, MasterAddr_City, MasterAddr_StateAbbr, MasterAddr_Zip, MasterAddr_CtryCode, MasterAddr_Phone, MasterAddr_Plant, MasterAddr_Active, MasterAddr_Internal) VALUES (2, 'JG Mailing', 'Mail Dept', '2840 NW 35th Ave', '', '', 'Portland', 'OR', '97210', 'US', '', 0, 1, 1);
INSERT INTO MasterAddresses (MasterAddr_ID, MasterAddr_Company, MasterAddr_Attn, MasterAddr_Addr1, MasterAddr_Addr2, MasterAddr_Addr3, MasterAddr_City, MasterAddr_StateAbbr, MasterAddr_Zip, MasterAddr_CtryCode, MasterAddr_Phone, MasterAddr_Plant, MasterAddr_Active, MasterAddr_Internal) VALUES (3, 'UPS Import', '', '2840 NW 35th Ave', '', '', 'Portland', 'OR', '97210', 'US', '', 0, 1, 1);
INSERT INTO MasterAddresses (MasterAddr_ID, MasterAddr_Company, MasterAddr_Attn, MasterAddr_Addr1, MasterAddr_Addr2, MasterAddr_Addr3, MasterAddr_City, MasterAddr_StateAbbr, MasterAddr_Zip, MasterAddr_CtryCode, MasterAddr_Phone, MasterAddr_Plant, MasterAddr_Active, MasterAddr_Internal) VALUES (4, 'JG Samples', 'Sample Room', '2840 NW 35th Ave', '', '', 'Portland', 'OR', '97210', 'US', '', 0, 1, 1);
INSERT INTO MasterAddresses (MasterAddr_ID, MasterAddr_Company, MasterAddr_Attn, MasterAddr_Addr1, MasterAddr_Addr2, MasterAddr_Addr3, MasterAddr_City, MasterAddr_StateAbbr, MasterAddr_Zip, MasterAddr_CtryCode, MasterAddr_Phone, MasterAddr_Plant, MasterAddr_Active, MasterAddr_Internal) VALUES (5, 'FedEx Import', '', '2840 NW 35th Ave', '', '', 'Portland', 'OR', '97210', 'US', '', 0, 1, 1);
INSERT INTO MasterAddresses (MasterAddr_ID, MasterAddr_Company, MasterAddr_Attn, MasterAddr_Addr1, MasterAddr_Addr2, MasterAddr_Addr3, MasterAddr_City, MasterAddr_StateAbbr, MasterAddr_Zip, MasterAddr_CtryCode, MasterAddr_Phone, MasterAddr_Plant, MasterAddr_Active, MasterAddr_Internal) VALUES (6, 'JG Inventory', '', '2840 NW 35th Ave', '', '', 'Portland', 'OR', '97210', 'US', '', 0, 1, 1);
INSERT INTO MasterAddresses (MasterAddr_ID, MasterAddr_Company, MasterAddr_Attn, MasterAddr_Addr1, MasterAddr_Addr2, MasterAddr_Addr3, MasterAddr_City, MasterAddr_StateAbbr, MasterAddr_Zip, MasterAddr_CtryCode, MasterAddr_Phone, MasterAddr_Plant, MasterAddr_Active, MasterAddr_Internal) VALUES (7, 'USPS Import', '', '2840 NW 35th Ave', '', '', 'Portland', 'OR', '97210', 'US', '', 0, 1, 1);

-- Table: CSRs
CREATE TABLE CSRs (CSR_ID VARCHAR (6, 0) PRIMARY KEY ON CONFLICT ABORT NOT NULL UNIQUE ON CONFLICT ABORT, FirstName VARCHAR NOT NULL, LastName VARCHAR, Email VARCHAR, Status BOOLEAN DEFAULT (1));
INSERT INTO CSRs (CSR_ID, FirstName, LastName, Email, Status) VALUES ('MERHUN', 'Meredith', 'Hunter', 'meredith.hunter@journalgraphics.com', 1);
INSERT INTO CSRs (CSR_ID, FirstName, LastName, Email, Status) VALUES ('DANHOL', 'Dan', 'Holtmeier', 'dan.holtmeier@journalgraphics.com', 0);
INSERT INTO CSRs (CSR_ID, FirstName, LastName, Email, Status) VALUES ('LYNLOV', 'Lyn', 'Lovell', 'lyn.lovell@journalgraphics.com', 0);
INSERT INTO CSRs (CSR_ID, FirstName, LastName, Email, Status) VALUES ('MARROB', 'Mary', 'Roberts', 'mary.roberts@journalgraphics.com', 0);
INSERT INTO CSRs (CSR_ID, FirstName, LastName, Email, Status) VALUES ('CYNJOH', 'Cyndi', 'Johnson', 'cyndi.johnson@journalgraphics.com', 0);
INSERT INTO CSRs (CSR_ID, FirstName, LastName, Email, Status) VALUES ('TIFSTE', 'Tiffany', 'Stephens', 'tiffany.stephens@journalgraphics.com', 0);
INSERT INTO CSRs (CSR_ID, FirstName, LastName, Email, Status) VALUES ('DARVAN', 'Darlene', 'VanLuvanee', 'darlene.vanluvanee@journalgraphics.com', 0);
INSERT INTO CSRs (CSR_ID, FirstName, LastName, Email, Status) VALUES ('PAMFRA', 'Pam', 'Frakes', 'pam.frakes@journalgraphics.com', 0);
INSERT INTO CSRs (CSR_ID, FirstName, LastName, Email, Status) VALUES ('LINFRA', 'Linda', 'Fraze', 'linda.fraze@journalgraphics.com', 0);
INSERT INTO CSRs (CSR_ID, FirstName, LastName, Email, Status) VALUES ('TOMJOE', 'Tom', 'Joel', 'tom.joel@journalgraphics.com', 0);
INSERT INTO CSRs (CSR_ID, FirstName, LastName, Email, Status) VALUES ('MICKAL', 'Michelle', 'Kalpakoff', 'michelle.kalpakoff@journalgraphics.com', 1);
INSERT INTO CSRs (CSR_ID, FirstName, LastName, Email, Status) VALUES ('CLAMCN', 'Claire', 'McNally', 'claire.mcnally@journalgraphics.com', 1);
INSERT INTO CSRs (CSR_ID, FirstName, LastName, Email, Status) VALUES ('PATMUR', 'Patty', 'Murphey', 'patty.murphey@journalgraphics.com', 1);
INSERT INTO CSRs (CSR_ID, FirstName, LastName, Email, Status) VALUES ('CRAMAX', 'Craig', 'Maxwell', 'craig.maxwell@journalgraphics.com', 1);
INSERT INTO CSRs (CSR_ID, FirstName, LastName, Email, Status) VALUES ('GREMIL', 'Greg', 'Miller', 'greg.miller@journalgraphics.com', 1);

-- Table: LabelVersions
CREATE TABLE LabelVersions (labelVersionID INTEGER PRIMARY KEY AUTOINCREMENT, tplID INTEGER REFERENCES LabelTPL (tplID) ON DELETE CASCADE NOT NULL, LabelVersionDesc TEXT NOT NULL ON CONFLICT ROLLBACK);
INSERT INTO LabelVersions (labelVersionID, tplID, LabelVersionDesc) VALUES (1, 6, 'Version 1');
INSERT INTO LabelVersions (labelVersionID, tplID, LabelVersionDesc) VALUES (2, 6, 'Version 2');
INSERT INTO LabelVersions (labelVersionID, tplID, LabelVersionDesc) VALUES (9, 12, 'row 1 - version');
INSERT INTO LabelVersions (labelVersionID, tplID, LabelVersionDesc) VALUES (12, 15, 'row1');
INSERT INTO LabelVersions (labelVersionID, tplID, LabelVersionDesc) VALUES (13, 18, 'Portland Opera');
INSERT INTO LabelVersions (labelVersionID, tplID, LabelVersionDesc) VALUES (17, 19, 'General');
INSERT INTO LabelVersions (labelVersionID, tplID, LabelVersionDesc) VALUES (24, 20, 'THUNDER ROADS MAGAZINE');

-- Table: Customer
CREATE TABLE Customer (Cust_ID TEXT PRIMARY KEY NOT NULL ON CONFLICT ABORT UNIQUE ON CONFLICT ABORT, CustName TEXT NOT NULL ON CONFLICT ABORT, Status BOOLEAN DEFAULT (1));
INSERT INTO Customer (Cust_ID, CustName, Status) VALUES ('TEMCUS', 'Temporary Customer', 0);
INSERT INTO Customer (Cust_ID, CustName, Status) VALUES ('SAGMED', 'Sagacity Media', 1);
INSERT INTO Customer (Cust_ID, CustName, Status) VALUES ('ENCMED', 'Encore Media', 1);
INSERT INTO Customer (Cust_ID, CustName, Status) VALUES ('temp', 'temp', 1);
INSERT INTO Customer (Cust_ID, CustName, Status) VALUES ('MANINC', 'MANULELE INCORPORATED', 1);
INSERT INTO Customer (Cust_ID, CustName, Status) VALUES ('KATMCK', 'KATHERINE S MCKELVEY', 1);
INSERT INTO Customer (Cust_ID, CustName, Status) VALUES ('tricit', 'tri-city herald', 1);
INSERT INTO Customer (Cust_ID, CustName, Status) VALUES ('MJSINC', 'MJSA, INC', 1);
INSERT INTO Customer (Cust_ID, CustName, Status) VALUES ('RURSER', 'Ruralite Services', 1);
INSERT INTO Customer (Cust_ID, CustName, Status) VALUES ('WINSER', 'Windermere Services', 1);
INSERT INTO Customer (Cust_ID, CustName, Status) VALUES ('RAMCRE', 'Rampant Creative Inc', 1);
INSERT INTO Customer (Cust_ID, CustName, Status) VALUES ('HONPUB', 'Honolulu Publishing Company LTD', 1);
INSERT INTO Customer (Cust_ID, CustName, Status) VALUES ('STAHIL', 'Stanley Hill', 1);

-- Table: DistributionTypeCarriers
CREATE TABLE DistributionTypeCarriers (DistributionTypesCarriers_ID INTEGER PRIMARY KEY AUTOINCREMENT, DistributionTypeID INTEGER NOT NULL ON CONFLICT ROLLBACK REFERENCES DistributionTypes (DistributionType_ID) ON DELETE CASCADE ON UPDATE CASCADE, CarrierID INTEGER REFERENCES Carriers (Carrier_ID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL ON CONFLICT ROLLBACK, ShipViaID INTEGER REFERENCES ShipVia (ShipVia_ID) ON DELETE CASCADE ON UPDATE CASCADE);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (119, 28, 5, 4);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (120, 28, 5, 6);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (121, 28, 5, 7);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (122, 28, 5, 8);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (123, 28, 5, 36);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (124, 28, 5, 37);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (125, 28, 5, 38);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (126, 28, 5, 39);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (127, 28, 5, 40);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (128, 28, 5, 41);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (129, 28, 5, 42);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (130, 28, 5, 43);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (131, 28, 5, 44);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (132, 28, 5, 45);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (133, 28, 5, 46);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (134, 28, 5, 47);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (135, 28, 5, 48);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (136, 28, 5, 49);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (137, 28, 5, 50);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (138, 28, 5, 51);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (139, 30, 86, 144);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (166, 33, 88, 173);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (173, 31, 28, 53);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (174, 31, 28, 54);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (175, 31, 28, 55);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (176, 31, 28, 56);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (177, 31, 28, 57);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (178, 31, 28, 58);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (198, 32, 87, 145);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (199, 32, 87, 146);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (200, 32, 87, 147);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (201, 32, 87, 148);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (202, 32, 87, 149);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (203, 32, 87, 150);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (204, 32, 87, 151);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (205, 32, 87, 152);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (206, 32, 87, 153);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (207, 32, 87, 154);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (208, 32, 87, 155);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (209, 32, 87, 156);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (210, 32, 87, 157);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (211, 32, 87, 158);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (212, 32, 87, 159);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (213, 32, 87, 160);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (214, 32, 87, 161);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (215, 32, 87, 162);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (216, 32, 87, 163);
INSERT INTO DistributionTypeCarriers (DistributionTypesCarriers_ID, DistributionTypeID, CarrierID, ShipViaID) VALUES (218, 23, 16, 20);

-- Table: DistributionTypes
CREATE TABLE DistributionTypes (DistributionType_ID INTEGER PRIMARY KEY AUTOINCREMENT, DistTypeName TEXT UNIQUE ON CONFLICT ABORT NOT NULL ON CONFLICT ABORT, DistType_Status BOOLEAN DEFAULT (1) NOT NULL ON CONFLICT ABORT, DistType_ShipTypeID INTEGER REFERENCES ShipmentTypes (ShipmentType_ID) ON UPDATE CASCADE);
INSERT INTO DistributionTypes (DistributionType_ID, DistTypeName, DistType_Status, DistType_ShipTypeID) VALUES (21, '00. Customer Tearsheets', 1, 6);
INSERT INTO DistributionTypes (DistributionType_ID, DistTypeName, DistType_Status, DistType_ShipTypeID) VALUES (22, '01. Customer Samples', 1, 6);
INSERT INTO DistributionTypes (DistributionType_ID, DistTypeName, DistType_Status, DistType_ShipTypeID) VALUES (23, '02. Internal Samples', 1, 2);
INSERT INTO DistributionTypes (DistributionType_ID, DistTypeName, DistType_Status, DistType_ShipTypeID) VALUES (24, '03. Customer Copies', 1, 6);
INSERT INTO DistributionTypes (DistributionType_ID, DistTypeName, DistType_Status, DistType_ShipTypeID) VALUES (25, '04. Freight', 1, 2);
INSERT INTO DistributionTypes (DistributionType_ID, DistTypeName, DistType_Status, DistType_ShipTypeID) VALUES (26, '05. Small Package', 1, 4);
INSERT INTO DistributionTypes (DistributionType_ID, DistTypeName, DistType_Status, DistType_ShipTypeID) VALUES (28, '07. UPS Import', 1, 4);
INSERT INTO DistributionTypes (DistributionType_ID, DistTypeName, DistType_Status, DistType_ShipTypeID) VALUES (30, '08. JG Inventory', 1, 2);
INSERT INTO DistributionTypes (DistributionType_ID, DistTypeName, DistType_Status, DistType_ShipTypeID) VALUES (31, '09. USPS Import', 1, 4);
INSERT INTO DistributionTypes (DistributionType_ID, DistTypeName, DistType_Status, DistType_ShipTypeID) VALUES (32, '13. FedEx Import', 1, 4);
INSERT INTO DistributionTypes (DistributionType_ID, DistTypeName, DistType_Status, DistType_ShipTypeID) VALUES (33, '06. JG Mail', 1, 2);

-- Table: CustomerShipVia
CREATE TABLE CustomerShipVia (CustomerShipVia_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, CustID INTEGER REFERENCES Customer (Cust_ID), ShipViaID INTEGER REFERENCES ShipVia (ShipVia_ID));
INSERT INTO CustomerShipVia (CustomerShipVia_ID, CustID, ShipViaID) VALUES (1, 'TEMCUS', 1);
INSERT INTO CustomerShipVia (CustomerShipVia_ID, CustID, ShipViaID) VALUES (5, 'SAGMED', 1);
INSERT INTO CustomerShipVia (CustomerShipVia_ID, CustID, ShipViaID) VALUES (6, 'SAGMED', 32);
INSERT INTO CustomerShipVia (CustomerShipVia_ID, CustID, ShipViaID) VALUES (7, 'SAGMED', 4);
INSERT INTO CustomerShipVia (CustomerShipVia_ID, CustID, ShipViaID) VALUES (11, 'SAGMED', 139);
INSERT INTO CustomerShipVia (CustomerShipVia_ID, CustID, ShipViaID) VALUES (16, 'MJSINC', 54);
INSERT INTO CustomerShipVia (CustomerShipVia_ID, CustID, ShipViaID) VALUES (17, 'MJSINC', 53);
INSERT INTO CustomerShipVia (CustomerShipVia_ID, CustID, ShipViaID) VALUES (22, 'MJSINC', 4);
INSERT INTO CustomerShipVia (CustomerShipVia_ID, CustID, ShipViaID) VALUES (25, 'MJSINC', 20);
INSERT INTO CustomerShipVia (CustomerShipVia_ID, CustID, ShipViaID) VALUES (26, 'MJSINC', 139);
INSERT INTO CustomerShipVia (CustomerShipVia_ID, CustID, ShipViaID) VALUES (27, 'MJSINC', 120);
INSERT INTO CustomerShipVia (CustomerShipVia_ID, CustID, ShipViaID) VALUES (28, 'MJSINC', 144);
INSERT INTO CustomerShipVia (CustomerShipVia_ID, CustID, ShipViaID) VALUES (29, 'MJSINC', 173);
INSERT INTO CustomerShipVia (CustomerShipVia_ID, CustID, ShipViaID) VALUES (35, 'tricit', 96);
INSERT INTO CustomerShipVia (CustomerShipVia_ID, CustID, ShipViaID) VALUES (36, 'tricit', 137);
INSERT INTO CustomerShipVia (CustomerShipVia_ID, CustID, ShipViaID) VALUES (37, 'tricit', 140);
INSERT INTO CustomerShipVia (CustomerShipVia_ID, CustID, ShipViaID) VALUES (38, 'temp', 68);
INSERT INTO CustomerShipVia (CustomerShipVia_ID, CustID, ShipViaID) VALUES (39, 'temp', 130);
INSERT INTO CustomerShipVia (CustomerShipVia_ID, CustID, ShipViaID) VALUES (40, 'temp', 131);
INSERT INTO CustomerShipVia (CustomerShipVia_ID, CustID, ShipViaID) VALUES (41, 'temp', 137);
INSERT INTO CustomerShipVia (CustomerShipVia_ID, CustID, ShipViaID) VALUES (42, 'temp', 140);

-- Table: Countries
CREATE TABLE [Countries] ([Country_ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, [CountryCode] VARCHAR (2) NOT NULL UNIQUE, [CountryName] TEXT NOT NULL);
INSERT INTO Countries (Country_ID, CountryCode, CountryName) VALUES (2, 'CA', 'Canada');
INSERT INTO Countries (Country_ID, CountryCode, CountryName) VALUES (3, 'MX', 'Mexico');
INSERT INTO Countries (Country_ID, CountryCode, CountryName) VALUES (7, 'US', 'United States');
INSERT INTO Countries (Country_ID, CountryCode, CountryName) VALUES (19, 'JP', 'Japan');

-- Table: _OLD_AccountNumbers
CREATE TABLE _OLD_AccountNumbers (AcctNumbers_ID INTEGER PRIMARY KEY AUTOINCREMENT, CompaniesID INTEGER REFERENCES MasterAddresses (MasterAddr_ID) ON UPDATE CASCADE, CarriersID INTEGER REFERENCES Carriers (Carrier_ID) ON UPDATE CASCADE, AcctNumber TEXT);

-- Table: _OLD_Headers
CREATE TABLE _OLD_Headers (Header_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, InternalHeaderName TEXT NOT NULL UNIQUE ON CONFLICT ABORT, HeaderMaxLength INTEGER NOT NULL ON CONFLICT ABORT, OutputHeaderName TEXT NOT NULL ON CONFLICT ABORT, Widget TEXT NOT NULL ON CONFLICT ABORT, Highlight TEXT, AlwaysDisplay BOOLEAN, Required BOOLEAN, DefaultWidth INTEGER, ResizeColumn BOOLEAN, DisplayOrder INTEGER);
INSERT INTO _OLD_Headers (Header_ID, InternalHeaderName, HeaderMaxLength, OutputHeaderName, Widget, Highlight, AlwaysDisplay, Required, DefaultWidth, ResizeColumn, DisplayOrder) VALUES (1, 'Company', 32, 'ShipToCompany', 'ttk::entry', '', 1, 1, 32, 1, 1);
INSERT INTO _OLD_Headers (Header_ID, InternalHeaderName, HeaderMaxLength, OutputHeaderName, Widget, Highlight, AlwaysDisplay, Required, DefaultWidth, ResizeColumn, DisplayOrder) VALUES (2, 'Attention', 24, 'ShipToAttention', 'ttk::entry', '', 1, 1, '', 1, 2);
INSERT INTO _OLD_Headers (Header_ID, InternalHeaderName, HeaderMaxLength, OutputHeaderName, Widget, Highlight, AlwaysDisplay, Required, DefaultWidth, ResizeColumn, DisplayOrder) VALUES (3, 'Address1', 32, 'ShipToAddressLine1', 'ttk::entry', '', 1, 1, '', 0, 3);
INSERT INTO _OLD_Headers (Header_ID, InternalHeaderName, HeaderMaxLength, OutputHeaderName, Widget, Highlight, AlwaysDisplay, Required, DefaultWidth, ResizeColumn, DisplayOrder) VALUES (4, 'Address2', 32, 'ShipToAddressLine2', 'ttk::entry', '', 0, 0, '', 0, 4);
INSERT INTO _OLD_Headers (Header_ID, InternalHeaderName, HeaderMaxLength, OutputHeaderName, Widget, Highlight, AlwaysDisplay, Required, DefaultWidth, ResizeColumn, DisplayOrder) VALUES (5, 'Address3', 32, 'ShipToAddressLine3', 'ttk::entry', '', '{}', '{}', '', '{}', 5);
INSERT INTO _OLD_Headers (Header_ID, InternalHeaderName, HeaderMaxLength, OutputHeaderName, Widget, Highlight, AlwaysDisplay, Required, DefaultWidth, ResizeColumn, DisplayOrder) VALUES (6, 'City', 24, 'ShipToCity', 'ttk::entry', '', 1, 1, '', '{}', 6);
INSERT INTO _OLD_Headers (Header_ID, InternalHeaderName, HeaderMaxLength, OutputHeaderName, Widget, Highlight, AlwaysDisplay, Required, DefaultWidth, ResizeColumn, DisplayOrder) VALUES (7, 'State', 2, 'ShipToState', 'ttk::entry', '', 1, 1, '', '{}', 7);
INSERT INTO _OLD_Headers (Header_ID, InternalHeaderName, HeaderMaxLength, OutputHeaderName, Widget, Highlight, AlwaysDisplay, Required, DefaultWidth, ResizeColumn, DisplayOrder) VALUES (8, 'Zip', 10, 'ShipToPostalCode', 'ttk::entry', '', 1, 1, '', '{}', 8);
INSERT INTO _OLD_Headers (Header_ID, InternalHeaderName, HeaderMaxLength, OutputHeaderName, Widget, Highlight, AlwaysDisplay, Required, DefaultWidth, ResizeColumn, DisplayOrder) VALUES (9, 'Country', 2, 'ShipToCountry', 'ttk::entry', '', 1, 1, '', 0, 9);
INSERT INTO _OLD_Headers (Header_ID, InternalHeaderName, HeaderMaxLength, OutputHeaderName, Widget, Highlight, AlwaysDisplay, Required, DefaultWidth, ResizeColumn, DisplayOrder) VALUES (10, 'Phone', 20, 'ShipToPhone', 'ttk::entry', '', 0, '{}', '', '{}', 10);
INSERT INTO _OLD_Headers (Header_ID, InternalHeaderName, HeaderMaxLength, OutputHeaderName, Widget, Highlight, AlwaysDisplay, Required, DefaultWidth, ResizeColumn, DisplayOrder) VALUES (11, 'Version', 30, 'Version', 'ttk::combobox', '', 1, 1, 32, 0, 11);
INSERT INTO _OLD_Headers (Header_ID, InternalHeaderName, HeaderMaxLength, OutputHeaderName, Widget, Highlight, AlwaysDisplay, Required, DefaultWidth, ResizeColumn, DisplayOrder) VALUES (12, 'Quantity', 22, 'ShipQuantity', 'ttk::entry', '', 1, 1, '', '{}', 12);
INSERT INTO _OLD_Headers (Header_ID, InternalHeaderName, HeaderMaxLength, OutputHeaderName, Widget, Highlight, AlwaysDisplay, Required, DefaultWidth, ResizeColumn, DisplayOrder) VALUES (13, 'Notes', 200, 'UserNotes', 'ttk::entry', '', 1, '{}', 50, '{}', 13);
INSERT INTO _OLD_Headers (Header_ID, InternalHeaderName, HeaderMaxLength, OutputHeaderName, Widget, Highlight, AlwaysDisplay, Required, DefaultWidth, ResizeColumn, DisplayOrder) VALUES (14, 'ShipDate', 10, 'ShipToDate', 'ttk::entry', '', '{}', '{}', '', '{}', 14);
INSERT INTO _OLD_Headers (Header_ID, InternalHeaderName, HeaderMaxLength, OutputHeaderName, Widget, Highlight, AlwaysDisplay, Required, DefaultWidth, ResizeColumn, DisplayOrder) VALUES (15, 'DistributionType', 32, 'DistributionType', 'ttk::combobox', '', 1, 1, 35, 0, 15);
INSERT INTO _OLD_Headers (Header_ID, InternalHeaderName, HeaderMaxLength, OutputHeaderName, Widget, Highlight, AlwaysDisplay, Required, DefaultWidth, ResizeColumn, DisplayOrder) VALUES (16, 'ShipVia', 32, 'ShipViaCode', 'ttk::combobox', '', 1, 1, 32, 0, 16);
INSERT INTO _OLD_Headers (Header_ID, InternalHeaderName, HeaderMaxLength, OutputHeaderName, Widget, Highlight, AlwaysDisplay, Required, DefaultWidth, ResizeColumn, DisplayOrder) VALUES (17, 'ThirdPartyBilling', 20, 'ThirdPartyBilling', 'ttk::entry', '', 0, 0, '', 0, 17);
INSERT INTO _OLD_Headers (Header_ID, InternalHeaderName, HeaderMaxLength, OutputHeaderName, Widget, Highlight, AlwaysDisplay, Required, DefaultWidth, ResizeColumn, DisplayOrder) VALUES (18, 'ArriveDate', 10, 'ArriveDate', 'ttk::entry', '', '{}', '{}', '', '{}', 18);
INSERT INTO _OLD_Headers (Header_ID, InternalHeaderName, HeaderMaxLength, OutputHeaderName, Widget, Highlight, AlwaysDisplay, Required, DefaultWidth, ResizeColumn, DisplayOrder) VALUES (19, 'ContainerType', 32, 'ContainerType', 'ttk::combobox', '', '{}', '{}', '', '{}', 19);
INSERT INTO _OLD_Headers (Header_ID, InternalHeaderName, HeaderMaxLength, OutputHeaderName, Widget, Highlight, AlwaysDisplay, Required, DefaultWidth, ResizeColumn, DisplayOrder) VALUES (20, 'PackageType', 32, 'PackageType', 'ttk::combobox', '', '{}', '{}', '', '{}', 20);
INSERT INTO _OLD_Headers (Header_ID, InternalHeaderName, HeaderMaxLength, OutputHeaderName, Widget, Highlight, AlwaysDisplay, Required, DefaultWidth, ResizeColumn, DisplayOrder) VALUES (21, 'ShippingClass', 20, 'ShippingClass', 'ttk::combobox', '', 1, 1, '', 1, 21);

-- Table: Containers
CREATE TABLE [Containers] ([Container_ID] INTEGER PRIMARY KEY AUTOINCREMENT, [Container] TEXT NOT NULL ON CONFLICT ABORT);
INSERT INTO Containers (Container_ID, Container) VALUES (1, 'Pallets, Mail');
INSERT INTO Containers (Container_ID, Container) VALUES (2, '*Pallets, 48x40');
INSERT INTO Containers (Container_ID, Container) VALUES (10, '*Pallets, 28x40');
INSERT INTO Containers (Container_ID, Container) VALUES (11, '*Pallets, 48x40 HT');
INSERT INTO Containers (Container_ID, Container) VALUES (12, '*Pallets, 48x40 New');

-- Table: _OLD_PostalCodes
CREATE TABLE [_OLD_PostalCodes] ([PostalCode_ID] INTEGER PRIMARY KEY AUTOINCREMENT, [ProvID] INTEGER NOT NULL ON CONFLICT ABORT REFERENCES [Provinces] ([Prov_ID]), [PostalCodeLow] TEXT, [PostalCodeHigh] TEXT, [CountryID] INTEGER NOT NULL ON CONFLICT ABORT REFERENCES [Countries] ([Country_ID]));
INSERT INTO _OLD_PostalCodes (PostalCode_ID, ProvID, PostalCodeLow, PostalCodeHigh, CountryID) VALUES (1, 1, '712', '713', 1);
INSERT INTO _OLD_PostalCodes (PostalCode_ID, ProvID, PostalCodeLow, PostalCodeHigh, CountryID) VALUES (2, 2, NULL, NULL, 1);
INSERT INTO _OLD_PostalCodes (PostalCode_ID, ProvID, PostalCodeLow, PostalCodeHigh, CountryID) VALUES (6, 3, '989', '988', 1);
INSERT INTO _OLD_PostalCodes (PostalCode_ID, ProvID, PostalCodeLow, PostalCodeHigh, CountryID) VALUES (8, 3, NULL, NULL, 1);
INSERT INTO _OLD_PostalCodes (PostalCode_ID, ProvID, PostalCodeLow, PostalCodeHigh, CountryID) VALUES (9, 3, '987', '', 1);
INSERT INTO _OLD_PostalCodes (PostalCode_ID, ProvID, PostalCodeLow, PostalCodeHigh, CountryID) VALUES (10, 3, NULL, NULL, 1);
INSERT INTO _OLD_PostalCodes (PostalCode_ID, ProvID, PostalCodeLow, PostalCodeHigh, CountryID) VALUES (11, 3, '987', '989', 1);

-- Table: CarrierPkg
CREATE TABLE CarrierPkg (CarrierPkg_ID INTEGER PRIMARY KEY ASC AUTOINCREMENT, CarrierID INTEGER NOT NULL ON CONFLICT ROLLBACK REFERENCES Carriers (Carrier_ID), CarrierPkgDesc VARCHAR (25) NOT NULL ON CONFLICT ROLLBACK);
INSERT INTO CarrierPkg (CarrierPkg_ID, CarrierID, CarrierPkgDesc) VALUES (8, 5, 'My Packaging');
INSERT INTO CarrierPkg (CarrierPkg_ID, CarrierID, CarrierPkgDesc) VALUES (13, 28, 'Card');
INSERT INTO CarrierPkg (CarrierPkg_ID, CarrierID, CarrierPkgDesc) VALUES (14, 28, 'Letter');
INSERT INTO CarrierPkg (CarrierPkg_ID, CarrierID, CarrierPkgDesc) VALUES (15, 28, 'Flat');
INSERT INTO CarrierPkg (CarrierPkg_ID, CarrierID, CarrierPkgDesc) VALUES (16, 28, 'FlatRateLegalEnvelope');
INSERT INTO CarrierPkg (CarrierPkg_ID, CarrierID, CarrierPkgDesc) VALUES (17, 28, 'FlatRateEnvelope');
INSERT INTO CarrierPkg (CarrierPkg_ID, CarrierID, CarrierPkgDesc) VALUES (18, 28, 'IrregularParcel');
INSERT INTO CarrierPkg (CarrierPkg_ID, CarrierID, CarrierPkgDesc) VALUES (19, 28, 'LargeParcel');
INSERT INTO CarrierPkg (CarrierPkg_ID, CarrierID, CarrierPkgDesc) VALUES (20, 28, 'OversizedParcel');
INSERT INTO CarrierPkg (CarrierPkg_ID, CarrierID, CarrierPkgDesc) VALUES (21, 28, 'FlatRatePaddedEnvelope');
INSERT INTO CarrierPkg (CarrierPkg_ID, CarrierID, CarrierPkgDesc) VALUES (22, 28, 'FlatRateGiftCardEnvelope');
INSERT INTO CarrierPkg (CarrierPkg_ID, CarrierID, CarrierPkgDesc) VALUES (23, 28, 'FlatRateWindowEnvelope');
INSERT INTO CarrierPkg (CarrierPkg_ID, CarrierID, CarrierPkgDesc) VALUES (24, 28, 'FlatRateCardboardEnvelope');
INSERT INTO CarrierPkg (CarrierPkg_ID, CarrierID, CarrierPkgDesc) VALUES (25, 28, 'SmallFlatRateEnvelope');
INSERT INTO CarrierPkg (CarrierPkg_ID, CarrierID, CarrierPkgDesc) VALUES (26, 28, 'MediumFlatRateEnvelope');
INSERT INTO CarrierPkg (CarrierPkg_ID, CarrierID, CarrierPkgDesc) VALUES (27, 28, 'LargeFlatRateEnvelope');
INSERT INTO CarrierPkg (CarrierPkg_ID, CarrierID, CarrierPkgDesc) VALUES (28, 28, 'DVDFlatRateBox');
INSERT INTO CarrierPkg (CarrierPkg_ID, CarrierID, CarrierPkgDesc) VALUES (29, 28, 'LargeVideoFlatRateBox');
INSERT INTO CarrierPkg (CarrierPkg_ID, CarrierID, CarrierPkgDesc) VALUES (30, 28, 'RegionalRateBoxA');
INSERT INTO CarrierPkg (CarrierPkg_ID, CarrierID, CarrierPkgDesc) VALUES (31, 28, 'RegionalRateBoxB');
INSERT INTO CarrierPkg (CarrierPkg_ID, CarrierID, CarrierPkgDesc) VALUES (32, 87, 'YOURPACKAGING');

-- Table: Carriers
CREATE TABLE Carriers (Carrier_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, Name TEXT NOT NULL ON CONFLICT ABORT UNIQUE ON CONFLICT ABORT, RateType VARCHAR, RateTable VARCHAR);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (5, 'UPS', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (6, 'FedEx Freight', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (7, 'Oak Harbor', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (8, 'Old Dominion', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (9, 'Direct Transport', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (10, 'CH Robinson', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (14, 'FedEx Freight Economy', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (15, 'FedEx Freight Priority', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (16, 'Hand Delivery', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (17, 'Honolulu Freight', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (19, 'JG Courier', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (20, 'JG Truck', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (21, 'Lynden Transport', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (22, 'Pilot Freight', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (23, 'Mid America Overseas', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (24, 'Reddaway Freight Lines', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (26, 'Yellow Transport', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (27, 'Peninsula Truck Lines', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (28, 'USPS', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (29, 'Vancouver Warehouse', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (30, 'Rapid Freight', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (31, 'City Sprint', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (32, 'MME', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (33, 'Network Delivery', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (34, 'Top Carrier', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (35, 'ET Line', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (36, 'R & L Carriers', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (37, 'Green Light Transport', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (38, 'Atam Trucking', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (39, 'Wine Consolidators', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (40, 'PO Truck', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (41, 'McCracken Motor Freight', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (42, 'UPS Freight', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (43, 'Will Call', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (44, 'Saia', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (45, 'Seko Worldwide', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (46, 'TC Transport', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (47, 'TP Freight Lines', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (50, 'Lynden International', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (51, 'UPS Air Freight', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (52, 'Beaver Freight', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (54, 'UPS Freight - VPRC', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (55, 'Logistics Services', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (56, 'Soniq Transportation', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (57, 'Future Logistics', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (58, 'General Transportation', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (59, 'ABF Freight', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (60, 'Hawaiian Express', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (61, 'Span Alaska Trans', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (62, 'Dependable Hawaii Express', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (63, 'Team Worldwide', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (64, 'UPS Freight - ManQ', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (65, 'Import - Freight', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (66, 'Import - FedEx', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (67, 'Import - USPS', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (68, 'Johanson Transport Svc', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (69, 'Ontrac International', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (70, 'Road Runner', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (71, 'Hawaiian Airlines', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (72, 'Jerry Thurman', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (73, 'Armstrong Transport', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (74, 'Grey Hound', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (75, 'Time Logistics', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (76, 'Bestway', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (79, 'Advantage', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (80, 'Ceva Logistics', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (81, 'Import - UPS', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (82, 'Aes Logistics', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (85, 'JG Bindery', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (86, 'JG Inventory', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (87, 'FedEx', NULL, NULL);
INSERT INTO Carriers (Carrier_ID, Name, RateType, RateTable) VALUES (88, 'JG Mail', NULL, NULL);

-- Table: CarrierAccts
CREATE TABLE CarrierAccts (CarrierAccts_ID INTEGER PRIMARY KEY ON CONFLICT ROLLBACK AUTOINCREMENT, CarrierAccts_Acct TEXT NOT NULL ON CONFLICT ROLLBACK, Active BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (1), MasterAddrID INTEGER REFERENCES MasterAddresses (MasterAddr_ID) ON UPDATE CASCADE, CarrierID INTEGER REFERENCES Carriers (Carrier_ID) ON UPDATE CASCADE);
INSERT INTO CarrierAccts (CarrierAccts_ID, CarrierAccts_Acct, Active, MasterAddrID, CarrierID) VALUES (1, '947919', 1, 1, 5);
INSERT INTO CarrierAccts (CarrierAccts_ID, CarrierAccts_Acct, Active, MasterAddrID, CarrierID) VALUES (5, '8889905', 1, 1, 87);

-- Table: EmailNotifications
CREATE TABLE [EmailNotifications] ([EN_ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, [ModuleName] VARCHAR NOT NULL, [EventName] VARCHAR NOT NULL UNIQUE ON CONFLICT ABORT, [EventNotification] BOOLEAN NOT NULL, [EmailFrom] VARCHAR NOT NULL ON CONFLICT ABORT, [EmailTo] VARCHAR NOT NULL ON CONFLICT ABORT, [EmailSubject] VARCHAR NOT NULL ON CONFLICT ABORT, [EmailBody] VARCHAR NOT NULL ON CONFLICT ABORT);
INSERT INTO EmailNotifications (EN_ID, ModuleName, EventName, EventNotification, EmailFrom, EmailTo, EmailSubject, EmailBody) VALUES (1, 'Box Labels', 'onPrint', 1, 'jg.shipping@journalgraphics.com', 'casey.ackels@journalgraphics.com', 'Package Info: %1', '%1
%2
%3
%4
%5

%b

------
Sent from Efficiency Assist (onPrint)

');

-- Table: LabelData
CREATE TABLE LabelData (labelDataID INTEGER PRIMARY KEY AUTOINCREMENT, labelVersionID INTEGER REFERENCES LabelVersions (labelVersionID) ON UPDATE CASCADE NOT NULL ON CONFLICT ROLLBACK, labelRowNum VARCHAR NOT NULL ON CONFLICT FAIL, labelRowText TEXT NOT NULL ON CONFLICT FAIL, userEditable BOOLEAN DEFAULT (0), isVersion BOOLEAN DEFAULT (0));
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (7, 1, '01', 'Seattle Art Dealers', 0, 0);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (8, 1, '02', 'March 2018', 0, 0);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (9, 1, '03', 'Version 1', 1, 1);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (10, 2, '01', 'Seattle Art Dealers', 0, 0);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (11, 2, '02', 'March 2018', 0, 0);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (12, 2, '03', 'Version 2', 0, 1);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (13, 9, '1', 'row 1 - version', 0, 1);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (14, 9, '2', 'row 2', 0, 0);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (15, 9, '3', 'row 3 editable', 1, 0);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (16, 9, '4', 'row 4', 0, 0);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (21, 12, '1', 'row1', 0, 1);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (22, 12, '2', 'row2', 0, 0);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (23, 12, '3', 'row3', 0, 0);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (24, 12, '4', 'row4', 0, 0);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (25, 13, '1', 'Portland Opera', 0, 1);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (26, 13, '2', 'La Cenerentola/Orfeo ed Euridice', 0, 0);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (27, 13, '3', 'Show Date: 7/14 - 8/4', 0, 0);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (28, 13, '4', '', 0, 0);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (35, 17, '1', '316551', 0, 0);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (36, 17, '2', 'Maui Drive Guide June/Sept 2018', 0, 0);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (37, 17, '3', 'v.A Neutral', 1, 1);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (64, 24, '1', 'THUNDER ROADS MAGAZINE', 0, 1);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (65, 24, '2', 'NORTHERN CALIFORNIA', 0, 0);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (66, 24, '3', 'JUNE 2018', 1, 0);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (67, 24, '4', 'VOLUME 8 ISSUE 11', 1, 0);
INSERT INTO LabelData (labelDataID, labelVersionID, labelRowNum, labelRowText, userEditable, isVersion) VALUES (68, 24, '5', '25 PER BUNDLE', 1, 0);

-- Table: LabelHeaderGrp
CREATE TABLE LabelHeaderGrp (LabelProfileID INTEGER REFERENCES LabelProfiles (LabelProfileID), LabelHeaderID INTEGER REFERENCES LabelHeaders (LabelHeaderID));
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (3, 7);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (3, 8);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (4, 7);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (4, 8);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (4, 19);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (5, 7);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (5, 8);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (5, 9);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (5, 10);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (5, 11);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (5, 12);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (1, 7);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (1, 8);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (1, 9);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (1, 10);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (1, 11);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (1, 12);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (15, 7);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (15, 8);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (15, 9);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (15, 10);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (15, 11);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (15, 19);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (2, 7);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (2, 8);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (2, 9);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (2, 10);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (2, 11);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (2, 12);
INSERT INTO LabelHeaderGrp (LabelProfileID, LabelHeaderID) VALUES (2, 13);

-- Table: EmailSetup
CREATE TABLE [EmailSetup] ([Email_ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, [EmailServer] VARCHAR NOT NULL, [EmailPassword] VARCHAR, [EmailPort] INTEGER, [EmailLogin] VARCHAR, [GlobalEmailNotification] BOOLEAN NOT NULL DEFAULT(1), [TLS] BOOLEAN DEFAULT(0));
INSERT INTO EmailSetup (Email_ID, EmailServer, EmailPassword, EmailPort, EmailLogin, GlobalEmailNotification, TLS) VALUES (1, 'mail.journalgraphics.com', 'shipping', 25, 'jg.shipping', 1, 0);

-- Table: LabelHeaders
CREATE TABLE LabelHeaders (LabelHeaderID INTEGER PRIMARY KEY AUTOINCREMENT, LabelHeaderDesc TEXT NOT NULL ON CONFLICT ABORT UNIQUE ON CONFLICT ROLLBACK, LabelHeaderSystemOnly BOOLEAN DEFAULT (0));
INSERT INTO LabelHeaders (LabelHeaderID, LabelHeaderDesc, LabelHeaderSystemOnly) VALUES (7, 'BoxQuantity', 1);
INSERT INTO LabelHeaders (LabelHeaderID, LabelHeaderDesc, LabelHeaderSystemOnly) VALUES (8, 'NumLabels', 1);
INSERT INTO LabelHeaders (LabelHeaderID, LabelHeaderDesc, LabelHeaderSystemOnly) VALUES (9, 'Row01', 0);
INSERT INTO LabelHeaders (LabelHeaderID, LabelHeaderDesc, LabelHeaderSystemOnly) VALUES (10, 'Row02', 0);
INSERT INTO LabelHeaders (LabelHeaderID, LabelHeaderDesc, LabelHeaderSystemOnly) VALUES (11, 'Row03', 0);
INSERT INTO LabelHeaders (LabelHeaderID, LabelHeaderDesc, LabelHeaderSystemOnly) VALUES (12, 'Row04', 0);
INSERT INTO LabelHeaders (LabelHeaderID, LabelHeaderDesc, LabelHeaderSystemOnly) VALUES (13, 'Row05', 0);
INSERT INTO LabelHeaders (LabelHeaderID, LabelHeaderDesc, LabelHeaderSystemOnly) VALUES (14, 'Row06', 0);
INSERT INTO LabelHeaders (LabelHeaderID, LabelHeaderDesc, LabelHeaderSystemOnly) VALUES (15, 'Row07', 0);
INSERT INTO LabelHeaders (LabelHeaderID, LabelHeaderDesc, LabelHeaderSystemOnly) VALUES (16, 'Row08', 0);
INSERT INTO LabelHeaders (LabelHeaderID, LabelHeaderDesc, LabelHeaderSystemOnly) VALUES (17, 'Row09', 0);
INSERT INTO LabelHeaders (LabelHeaderID, LabelHeaderDesc, LabelHeaderSystemOnly) VALUES (18, 'Row10', 0);
INSERT INTO LabelHeaders (LabelHeaderID, LabelHeaderDesc, LabelHeaderSystemOnly) VALUES (19, 'TotalBoxes', 1);

-- Table: LabelSizes
CREATE TABLE LabelSizes (labelSizeID INTEGER PRIMARY KEY AUTOINCREMENT, labelSizeDesc TEXT NOT NULL ON CONFLICT ROLLBACK, labelSizeWidth DECIMAL NOT NULL ON CONFLICT ROLLBACK, labelSizeHeight DECIMAL NOT NULL ON CONFLICT ROLLBACK, labelSizeOrient TEXT, labelSizeMaxChar INTEGER);
INSERT INTO LabelSizes (labelSizeID, labelSizeDesc, labelSizeWidth, labelSizeHeight, labelSizeOrient, labelSizeMaxChar) VALUES (1, '5x3 white', 5, 3, 'Horizontal', 33);
INSERT INTO LabelSizes (labelSizeID, labelSizeDesc, labelSizeWidth, labelSizeHeight, labelSizeOrient, labelSizeMaxChar) VALUES (2, '4x6 white vertical', 4, 6, 'Vertical', NULL);
INSERT INTO LabelSizes (labelSizeID, labelSizeDesc, labelSizeWidth, labelSizeHeight, labelSizeOrient, labelSizeMaxChar) VALUES (3, '4x6 white horizontal', 4, 6, 'Horizontal', NULL);
INSERT INTO LabelSizes (labelSizeID, labelSizeDesc, labelSizeWidth, labelSizeHeight, labelSizeOrient, labelSizeMaxChar) VALUES (4, '4x2.5 white', 4, 2.5, 'Horizontal', NULL);

-- Table: LabelTPL
CREATE TABLE LabelTPL (tplID INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE ON CONFLICT ROLLBACK NOT NULL ON CONFLICT ROLLBACK, PubTitleID INTEGER REFERENCES PubTitle (Title_ID), LabelProfileID INTEGER REFERENCES LabelProfiles (LabelProfileID), labelSizeID INTEGER REFERENCES LabelSizes (labelSizeID), tplLabelName TEXT NOT NULL ON CONFLICT ROLLBACK, tplLabelPath TEXT NOT NULL ON CONFLICT ROLLBACK, tplNotePriv TEXT, tplNotePub TEXT, tplFixedBoxQty INTEGER, tplFixedLabelInfo BOOLEAN, tplSerialize BOOLEAN, Status BOOLEAN DEFAULT (1));
INSERT INTO LabelTPL (tplID, PubTitleID, LabelProfileID, labelSizeID, tplLabelName, tplLabelPath, tplNotePriv, tplNotePub, tplFixedBoxQty, tplFixedLabelInfo, tplSerialize, Status) VALUES (6, 11, 1, 4, 'General', '//fileprint/Labels/Templates/TEMP Test1/Test Label #1.btw', '', '', '', 1, '', 0);
INSERT INTO LabelTPL (tplID, PubTitleID, LabelProfileID, labelSizeID, tplLabelName, tplLabelPath, tplNotePriv, tplNotePub, tplFixedBoxQty, tplFixedLabelInfo, tplSerialize, Status) VALUES (10, 30, 0, 1, 'Extras', '//fileprint/Labels/Templates/RURSER Ruralite/RURALITE - EXTRAS.btw', '', '', '', 1, '', 1);
INSERT INTO LabelTPL (tplID, PubTitleID, LabelProfileID, labelSizeID, tplLabelName, tplLabelPath, tplNotePriv, tplNotePub, tplFixedBoxQty, tplFixedLabelInfo, tplSerialize, Status) VALUES (11, 31, 4, 1, 'General - Serialized - 5x3', '//fileprint/Labels/Templates/WINSER Windermere Services/Windermere Living Serialized 3x5.btw', '', '', '', '', 1, 1);
INSERT INTO LabelTPL (tplID, PubTitleID, LabelProfileID, labelSizeID, tplLabelName, tplLabelPath, tplNotePriv, tplNotePub, tplFixedBoxQty, tplFixedLabelInfo, tplSerialize, Status) VALUES (12, 11, 5, 1, 'Static Data - Variable Text - Unknown Box Qty', '//fileprint/Labels/Templates/TEMP Test1/Static Data - Variable Data - Unknown Qty.btw', '', '', '', '', '', 1);
INSERT INTO LabelTPL (tplID, PubTitleID, LabelProfileID, labelSizeID, tplLabelName, tplLabelPath, tplNotePriv, tplNotePub, tplFixedBoxQty, tplFixedLabelInfo, tplSerialize, Status) VALUES (15, 11, 1, 1, '4line all data known', '//fileprint/Labels/Templates/TEMP Test1/Test Label #1.btw', '', '', 50, '', '', 1);
INSERT INTO LabelTPL (tplID, PubTitleID, LabelProfileID, labelSizeID, tplLabelName, tplLabelPath, tplNotePriv, tplNotePub, tplFixedBoxQty, tplFixedLabelInfo, tplSerialize, Status) VALUES (16, 6, 0, 1, 'General', '//fileprint/Labels/Templates/ENCMED Encore Media/SEATTLE ART DEALER.btw', '', '', '', '', '', 1);
INSERT INTO LabelTPL (tplID, PubTitleID, LabelProfileID, labelSizeID, tplLabelName, tplLabelPath, tplNotePriv, tplNotePub, tplFixedBoxQty, tplFixedLabelInfo, tplSerialize, Status) VALUES (17, 30, 0, 1, 'Untrimmed', '//fileprint/Labels/Templates/RURSER Ruralite/RURALITE - UNTRIMMED.btw', '', '', '', '', '', 1);
INSERT INTO LabelTPL (tplID, PubTitleID, LabelProfileID, labelSizeID, tplLabelName, tplLabelPath, tplNotePriv, tplNotePub, tplFixedBoxQty, tplFixedLabelInfo, tplSerialize, Status) VALUES (18, 32, 1, 1, 'Portland Opera', '//fileprint/Labels/Templates/RAMCRE Rampant Creative Inc/Artslandia 3x5.btw', '', '', '', '', '', 1);
INSERT INTO LabelTPL (tplID, PubTitleID, LabelProfileID, labelSizeID, tplLabelName, tplLabelPath, tplNotePriv, tplNotePub, tplFixedBoxQty, tplFixedLabelInfo, tplSerialize, Status) VALUES (19, 33, 15, 1, 'Maui Drive Guide 5x3', '//fileprint/Labels/Templates/HONPUB Honolulu Publications/Maui Drive Guide/Maui Drive Guide 3x5.btw', '', '', '', '', 1, 1);
INSERT INTO LabelTPL (tplID, PubTitleID, LabelProfileID, labelSizeID, tplLabelName, tplLabelPath, tplNotePriv, tplNotePub, tplFixedBoxQty, tplFixedLabelInfo, tplSerialize, Status) VALUES (20, 34, 2, 1, 'General', '//fileprint/Labels/Templates/STAHIL Stanley Hill/Thunder Roads of Northern CA/Stanley Hill - Thunder.btw', '', '', '', '', '', 1);

-- Table: LabelProfiles
CREATE TABLE LabelProfiles (LabelProfileID INTEGER PRIMARY KEY AUTOINCREMENT, LabelProfileDesc TEXT UNIQUE ON CONFLICT ROLLBACK);
INSERT INTO LabelProfiles (LabelProfileID, LabelProfileDesc) VALUES (0, 'Text is on Label Document');
INSERT INTO LabelProfiles (LabelProfileID, LabelProfileDesc) VALUES (1, '4 Line');
INSERT INTO LabelProfiles (LabelProfileID, LabelProfileDesc) VALUES (2, '5 Line');
INSERT INTO LabelProfiles (LabelProfileID, LabelProfileDesc) VALUES (3, 'Static Text, Dynamic Qty');
INSERT INTO LabelProfiles (LabelProfileID, LabelProfileDesc) VALUES (4, 'Static Text, Dynamic Qty, Serialize');
INSERT INTO LabelProfiles (LabelProfileID, LabelProfileDesc) VALUES (5, 'Static-Variable Text Unknown Qty');
INSERT INTO LabelProfiles (LabelProfileID, LabelProfileDesc) VALUES (15, '3 Lines - Serialized');

-- Table: IntlShipTerms
CREATE TABLE [IntlShipTerms] ([Terms_ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, [TermsAbbr] VARCHAR NOT NULL UNIQUE ON CONFLICT ABORT, [TermsDesc] VARCHAR, [IncoTerms] INTEGER);
INSERT INTO IntlShipTerms (Terms_ID, TermsAbbr, TermsDesc, IncoTerms) VALUES (1, 'DDP', 'Delivered Duty Paid', 2010);

-- Table: EventNotifications
CREATE TABLE EventNotifications (Event_ID INTEGER PRIMARY KEY AUTOINCREMENT, ModID INTEGER NOT NULL ON CONFLICT ABORT REFERENCES Modules (Mod_ID), EventName VARCHAR NOT NULL ON CONFLICT ABORT, EventSubstitutions VARCHAR, EnableEventNotification BOOLEAN DEFAULT (1));
INSERT INTO EventNotifications (Event_ID, ModID, EventName, EventSubstitutions, EnableEventNotification) VALUES (1, 1, 'onPrint_test', NULL, 1);
INSERT INTO EventNotifications (Event_ID, ModID, EventName, EventSubstitutions, EnableEventNotification) VALUES (2, 1, 'onPrintBreakDown', 'None at this time', 1);
INSERT INTO EventNotifications (Event_ID, ModID, EventName, EventSubstitutions, EnableEventNotification) VALUES (3, 2, 'onExport', NULL, 1);
INSERT INTO EventNotifications (Event_ID, ModID, EventName, EventSubstitutions, EnableEventNotification) VALUES (10, 1, 'onPrint', 'Usage: %1 %2 %3 %4 %5
 Each number represents each line of the box labels
 %b: Breakdown information', 1);

-- Table: ForestOrg
CREATE TABLE ForestOrg (ForestOrg_ID INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE ON CONFLICT ROLLBACK NOT NULL ON CONFLICT ROLLBACK, ForestOrgName TEXT UNIQUE ON CONFLICT ROLLBACK NOT NULL ON CONFLICT ROLLBACK, ForestOrgNum TEXT UNIQUE ON CONFLICT ROLLBACK NOT NULL ON CONFLICT ROLLBACK, Active BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (1));
INSERT INTO ForestOrg (ForestOrg_ID, ForestOrgName, ForestOrgNum, Active) VALUES (1, 'Forest Stewardship Council', 'RA-COC-00294', 1);

-- Table: IntlLicense
CREATE TABLE [IntlLicense] ([License_ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, [LicenseAbbr] VARCHAR NOT NULL UNIQUE ON CONFLICT ABORT, [LicenseDesc] VARCHAR);
INSERT INTO IntlLicense (License_ID, LicenseAbbr, LicenseDesc) VALUES (1, 'NLR', 'No License Required');

-- Table: ForestType
CREATE TABLE ForestType (ForestType_ID INTEGER PRIMARY KEY ON CONFLICT ROLLBACK AUTOINCREMENT NOT NULL ON CONFLICT ROLLBACK UNIQUE ON CONFLICT ROLLBACK, ForestTypeDesc TEXT NOT NULL ON CONFLICT ROLLBACK, Active BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (1), ForestOrgID INTEGER REFERENCES ForestOrg (ForestOrg_ID) ON UPDATE CASCADE NOT NULL ON CONFLICT ROLLBACK);
INSERT INTO ForestType (ForestType_ID, ForestTypeDesc, Active, ForestOrgID) VALUES (1, 'FSC Mix', 1, 1);

-- Table: FreightRates
CREATE TABLE [FreightRates] ([RateTable_ID] REFERENCES [CarrierName] ([RateTable]), [WeightLow1] INTEGER, [WeightHigh1] INTEGER, [ShippingCost] VARCHAR);

-- Table: HeadersConfig
CREATE TABLE HeadersConfig (HeaderConfig_ID TEXT NOT NULL PRIMARY KEY ON CONFLICT ROLLBACK UNIQUE ON CONFLICT ROLLBACK, dbColName TEXT NOT NULL ON CONFLICT ROLLBACK UNIQUE ON CONFLICT ROLLBACK, dbDataType TEXT NOT NULL ON CONFLICT ROLLBACK, widLabelName TEXT NOT NULL ON CONFLICT ROLLBACK UNIQUE ON CONFLICT ROLLBACK, widLabelAlignment TEXT NOT NULL ON CONFLICT ROLLBACK, widWidget TEXT NOT NULL ON CONFLICT ROLLBACK, widValues TEXT, widDataType TEXT NOT NULL ON CONFLICT ROLLBACK, widFormat TEXT, widColAlignment TEXT NOT NULL ON CONFLICT ROLLBACK, widStartColWidth INTEGER NOT NULL ON CONFLICT ROLLBACK, widMaxWidth INTEGER NOT NULL ON CONFLICT ROLLBACK, widResizeToLongestEntry BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (0), widMaxStringLength INTEGER NOT NULL ON CONFLICT ROLLBACK, widHighlightColor TEXT, widUIGroup TEXT NOT NULL ON CONFLICT ROLLBACK, widUIPositionWeight INTEGER NOT NULL ON CONFLICT ROLLBACK DEFAULT (0), widExportable BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (1), widRequired BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (0), widDisplayType TEXT NOT NULL ON CONFLICT ROLLBACK, dbActive BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (1), CopyColumn BOOLEAN NOT NULL ON CONFLICT ROLLBACK DEFAULT (0));
INSERT INTO HeadersConfig (HeaderConfig_ID, dbColName, dbDataType, widLabelName, widLabelAlignment, widWidget, widValues, widDataType, widFormat, widColAlignment, widStartColWidth, widMaxWidth, widResizeToLongestEntry, widMaxStringLength, widHighlightColor, widUIGroup, widUIPositionWeight, widExportable, widRequired, widDisplayType, dbActive, CopyColumn) VALUES ('175454CA-5944-47AA-AD99-A8753B67BAA7', 'Company', 'TEXT', 'Company', 'Center', 'ttk::entry', NULL, 'ASCIINOCASE', NULL, 'Left', 30, 35, 0, 32, 'Yellow', 'Consignee', 0, 1, 1, 'Always', 1, 0);
INSERT INTO HeadersConfig (HeaderConfig_ID, dbColName, dbDataType, widLabelName, widLabelAlignment, widWidget, widValues, widDataType, widFormat, widColAlignment, widStartColWidth, widMaxWidth, widResizeToLongestEntry, widMaxStringLength, widHighlightColor, widUIGroup, widUIPositionWeight, widExportable, widRequired, widDisplayType, dbActive, CopyColumn) VALUES ('2A4C0578-7340-4F51-957B-440F231833EE', 'Attention', 'TEXT', 'Attention', 'Center', 'ttk::entry', NULL, 'ASCIINOCASE', NULL, 'Left', 20, 35, 1, 24, NULL, 'Consignee', 1, 1, 1, 'Always', 1, 0);
INSERT INTO HeadersConfig (HeaderConfig_ID, dbColName, dbDataType, widLabelName, widLabelAlignment, widWidget, widValues, widDataType, widFormat, widColAlignment, widStartColWidth, widMaxWidth, widResizeToLongestEntry, widMaxStringLength, widHighlightColor, widUIGroup, widUIPositionWeight, widExportable, widRequired, widDisplayType, dbActive, CopyColumn) VALUES ('154AE040-2B77-4FC8-9F83-669BA76EA961', 'Address1', 'TEXT', 'Address', 'Center', 'ttk::entry', NULL, 'ASCIINOCASE', NULL, 'Left', 25, 32, 1, 32, NULL, 'Consignee', 2, 1, 1, 'Always', 1, 0);
INSERT INTO HeadersConfig (HeaderConfig_ID, dbColName, dbDataType, widLabelName, widLabelAlignment, widWidget, widValues, widDataType, widFormat, widColAlignment, widStartColWidth, widMaxWidth, widResizeToLongestEntry, widMaxStringLength, widHighlightColor, widUIGroup, widUIPositionWeight, widExportable, widRequired, widDisplayType, dbActive, CopyColumn) VALUES ('CA11D880-3F88-4F08-B1C6-B0CE7D156BF0', 'Address2', 'TEXT', 'Address 2', 'Center', 'ttk::entry', NULL, 'ASCIINOCASE', NULL, 'Left', 20, 32, 1, 32, NULL, 'Consignee', 4, 1, 0, 'Dynamic', 1, 0);
INSERT INTO HeadersConfig (HeaderConfig_ID, dbColName, dbDataType, widLabelName, widLabelAlignment, widWidget, widValues, widDataType, widFormat, widColAlignment, widStartColWidth, widMaxWidth, widResizeToLongestEntry, widMaxStringLength, widHighlightColor, widUIGroup, widUIPositionWeight, widExportable, widRequired, widDisplayType, dbActive, CopyColumn) VALUES ('E7084638-6238-4241-8C90-42D916508CD5', 'Address3', 'TEXT', 'Address 3', 'Center', 'ttk::entry', NULL, 'ASCIINOCASE', NULL, 'Left', 20, 32, 1, 32, NULL, 'Consignee', 5, 1, 0, 'Dynamic', 1, 0);
INSERT INTO HeadersConfig (HeaderConfig_ID, dbColName, dbDataType, widLabelName, widLabelAlignment, widWidget, widValues, widDataType, widFormat, widColAlignment, widStartColWidth, widMaxWidth, widResizeToLongestEntry, widMaxStringLength, widHighlightColor, widUIGroup, widUIPositionWeight, widExportable, widRequired, widDisplayType, dbActive, CopyColumn) VALUES ('321F91EA-DF89-425B-9FDB-071733AC7375', 'City', 'TEXT', 'City', 'Center', 'ttk::entry', NULL, 'ASCIINOCASE', NULL, 'Left', 15, 24, 1, 24, NULL, 'Consignee', 6, 1, 1, 'Always', 1, 0);
INSERT INTO HeadersConfig (HeaderConfig_ID, dbColName, dbDataType, widLabelName, widLabelAlignment, widWidget, widValues, widDataType, widFormat, widColAlignment, widStartColWidth, widMaxWidth, widResizeToLongestEntry, widMaxStringLength, widHighlightColor, widUIGroup, widUIPositionWeight, widExportable, widRequired, widDisplayType, dbActive, CopyColumn) VALUES ('4C7BA09F-9627-4713-B11C-829A5AA2B87F', 'State', 'TEXT', 'State/Province', 'Center', 'ttk::entry', NULL, 'ASCIINOCASE', NULL, 'Left', 4, 4, 0, 2, NULL, 'Consignee', 7, 1, 1, 'Always', 1, 0);
INSERT INTO HeadersConfig (HeaderConfig_ID, dbColName, dbDataType, widLabelName, widLabelAlignment, widWidget, widValues, widDataType, widFormat, widColAlignment, widStartColWidth, widMaxWidth, widResizeToLongestEntry, widMaxStringLength, widHighlightColor, widUIGroup, widUIPositionWeight, widExportable, widRequired, widDisplayType, dbActive, CopyColumn) VALUES ('3F61153C-317A-4803-9DC8-2F977CEA6834', 'Zip', 'TEXT', 'Zip', 'Center', 'ttk::entry', NULL, 'ASCIINOCASE', NULL, 'Left', 10, 10, 1, 10, NULL, 'Consignee', 8, 1, 1, 'Always', 1, 0);
INSERT INTO HeadersConfig (HeaderConfig_ID, dbColName, dbDataType, widLabelName, widLabelAlignment, widWidget, widValues, widDataType, widFormat, widColAlignment, widStartColWidth, widMaxWidth, widResizeToLongestEntry, widMaxStringLength, widHighlightColor, widUIGroup, widUIPositionWeight, widExportable, widRequired, widDisplayType, dbActive, CopyColumn) VALUES ('E67E25B4-D007-43C9-AEC2-FA95BA3D6A03', 'Country', 'TEXT', 'Country', 'Center', 'ttk::entry', NULL, 'ASCIINOCASE', NULL, 'Center', 5, 5, 1, 2, NULL, 'Consignee', 9, 1, 1, 'Always', 1, 0);
INSERT INTO HeadersConfig (HeaderConfig_ID, dbColName, dbDataType, widLabelName, widLabelAlignment, widWidget, widValues, widDataType, widFormat, widColAlignment, widStartColWidth, widMaxWidth, widResizeToLongestEntry, widMaxStringLength, widHighlightColor, widUIGroup, widUIPositionWeight, widExportable, widRequired, widDisplayType, dbActive, CopyColumn) VALUES ('57633A12-B654-487F-A67B-65579454260E', 'Phone', 'TEXT', 'Phone', 'Center', 'ttk::entry', NULL, 'ASCIINOCASE', NULL, 'Left', 15, 20, 1, 20, NULL, 'Consignee', 10, 1, 0, 'Always', 1, 0);
INSERT INTO HeadersConfig (HeaderConfig_ID, dbColName, dbDataType, widLabelName, widLabelAlignment, widWidget, widValues, widDataType, widFormat, widColAlignment, widStartColWidth, widMaxWidth, widResizeToLongestEntry, widMaxStringLength, widHighlightColor, widUIGroup, widUIPositionWeight, widExportable, widRequired, widDisplayType, dbActive, CopyColumn) VALUES ('C8071A7B-4887-468D-85EB-6FFFA1225992', 'Versions', 'TEXT', 'Versions', 'Center', 'ttk::combobox', 'Versions', 'ASCIINOCASE', NULL, 'Left', 15, 30, 1, 30, NULL, 'Shipping Order', 11, 1, 1, 'Always', 1, 0);
INSERT INTO HeadersConfig (HeaderConfig_ID, dbColName, dbDataType, widLabelName, widLabelAlignment, widWidget, widValues, widDataType, widFormat, widColAlignment, widStartColWidth, widMaxWidth, widResizeToLongestEntry, widMaxStringLength, widHighlightColor, widUIGroup, widUIPositionWeight, widExportable, widRequired, widDisplayType, dbActive, CopyColumn) VALUES ('14BBF55D-59CD-47F9-9A23-6CE72BDAD18B', 'Quantity', 'INTEGER', 'Quantity', 'Center', 'ttk::entry', NULL, 'INTEGER', NULL, 'Left', 6, 15, 1, 22, NULL, 'Shipping Order', 12, 1, 1, 'Always', 1, 0);
INSERT INTO HeadersConfig (HeaderConfig_ID, dbColName, dbDataType, widLabelName, widLabelAlignment, widWidget, widValues, widDataType, widFormat, widColAlignment, widStartColWidth, widMaxWidth, widResizeToLongestEntry, widMaxStringLength, widHighlightColor, widUIGroup, widUIPositionWeight, widExportable, widRequired, widDisplayType, dbActive, CopyColumn) VALUES ('16854952-09E1-41E8-82CC-A651A4A68A1C', 'Notes', 'TEXT', 'Notes', 'Center', 'ttk::entry', NULL, 'ASCIINOCASE', NULL, 'Left', 20, 35, 0, 200, NULL, 'Consignee', 13, 1, 0, 'Dynamic', 1, 0);
INSERT INTO HeadersConfig (HeaderConfig_ID, dbColName, dbDataType, widLabelName, widLabelAlignment, widWidget, widValues, widDataType, widFormat, widColAlignment, widStartColWidth, widMaxWidth, widResizeToLongestEntry, widMaxStringLength, widHighlightColor, widUIGroup, widUIPositionWeight, widExportable, widRequired, widDisplayType, dbActive, CopyColumn) VALUES ('960CED3A-1398-4815-B9AD-BEB14BACB2BB', 'ShipDate', 'DATE', 'Ship Date', 'Center', 'ttk::entry', NULL, 'ASCIINOCASE', 'Date', 'Left', 10, 10, 0, 10, NULL, 'Shipping Order', 11, 1, 0, 'Dynamic', 1, 0);
INSERT INTO HeadersConfig (HeaderConfig_ID, dbColName, dbDataType, widLabelName, widLabelAlignment, widWidget, widValues, widDataType, widFormat, widColAlignment, widStartColWidth, widMaxWidth, widResizeToLongestEntry, widMaxStringLength, widHighlightColor, widUIGroup, widUIPositionWeight, widExportable, widRequired, widDisplayType, dbActive, CopyColumn) VALUES ('FF810ED1-5375-4E65-8152-391750B25874', 'DistributionType', 'TEXT', 'Distribution', 'Center', 'ttk::combobox', 'Distribution Type', 'ASCIINOCASE', NULL, 'Left', 15, 20, 1, 32, NULL, 'Consignee', 12, 1, 1, 'Always', 1, 1);
INSERT INTO HeadersConfig (HeaderConfig_ID, dbColName, dbDataType, widLabelName, widLabelAlignment, widWidget, widValues, widDataType, widFormat, widColAlignment, widStartColWidth, widMaxWidth, widResizeToLongestEntry, widMaxStringLength, widHighlightColor, widUIGroup, widUIPositionWeight, widExportable, widRequired, widDisplayType, dbActive, CopyColumn) VALUES ('4CE461A2-8B20-4ECA-A116-517499D42EB0', 'ShipVia', 'TEXT', 'Ship Via', 'Center', 'ttk::combobox', 'Ship Via', 'ASCIINOCASE', NULL, 'Left', 15, 25, 1, 32, NULL, 'Shipping Order', 13, 1, 1, 'Always', 1, 0);
INSERT INTO HeadersConfig (HeaderConfig_ID, dbColName, dbDataType, widLabelName, widLabelAlignment, widWidget, widValues, widDataType, widFormat, widColAlignment, widStartColWidth, widMaxWidth, widResizeToLongestEntry, widMaxStringLength, widHighlightColor, widUIGroup, widUIPositionWeight, widExportable, widRequired, widDisplayType, dbActive, CopyColumn) VALUES ('143A5368-8A34-46A3-B5A9-C9A3A4102E19', 'ArriveDate', 'DATE', 'Arrive Date', 'Center', 'ttk::entry', NULL, 'ASCIINOCASE', 'Date', 'Left', 5, 10, 1, 10, NULL, 'Shipping Order', 14, 1, 0, 'Dynamic', 1, 0);
INSERT INTO HeadersConfig (HeaderConfig_ID, dbColName, dbDataType, widLabelName, widLabelAlignment, widWidget, widValues, widDataType, widFormat, widColAlignment, widStartColWidth, widMaxWidth, widResizeToLongestEntry, widMaxStringLength, widHighlightColor, widUIGroup, widUIPositionWeight, widExportable, widRequired, widDisplayType, dbActive, CopyColumn) VALUES ('F3FFF64E-8A1D-4366-BBD1-324713E2A480', 'ContainerType', 'TEXT', 'Container', 'Center', 'ttk::combobox', 'Container', 'ASCIINOCASE', NULL, 'Left', 10, 15, 1, 32, NULL, 'Packaging', 15, 1, 1, 'Always', 1, 0);
INSERT INTO HeadersConfig (HeaderConfig_ID, dbColName, dbDataType, widLabelName, widLabelAlignment, widWidget, widValues, widDataType, widFormat, widColAlignment, widStartColWidth, widMaxWidth, widResizeToLongestEntry, widMaxStringLength, widHighlightColor, widUIGroup, widUIPositionWeight, widExportable, widRequired, widDisplayType, dbActive, CopyColumn) VALUES ('BC175BC4-8B1D-45FA-9D2E-F02AD14D06E2', 'PackageType', 'TEXT', 'Package', 'Center', 'ttk::combobox', 'Packages', 'ASCIINOCASE', NULL, 'Left', 10, 15, 1, 32, NULL, 'Packaging', 16, 1, 1, 'Always', 1, 0);
INSERT INTO HeadersConfig (HeaderConfig_ID, dbColName, dbDataType, widLabelName, widLabelAlignment, widWidget, widValues, widDataType, widFormat, widColAlignment, widStartColWidth, widMaxWidth, widResizeToLongestEntry, widMaxStringLength, widHighlightColor, widUIGroup, widUIPositionWeight, widExportable, widRequired, widDisplayType, dbActive, CopyColumn) VALUES ('3B031381-EE6B-49AB-BDFF-B56140CBD60C', 'ShippingClass', 'TEXT', 'Shipping Class', 'Center', 'ttk::combobox', 'Shipping Class', 'ASCIINOCASE', NULL, 'Left', 15, 20, 1, 20, NULL, 'Shipping Order', 17, 1, 1, 'Always', 1, 0);

-- Table: FreightPayer
CREATE TABLE [FreightPayer] ([FreightPayer_ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, [Payer] TEXT NOT NULL ON CONFLICT ABORT);
INSERT INTO FreightPayer (FreightPayer_ID, Payer) VALUES (1, 'Sender');
INSERT INTO FreightPayer (FreightPayer_ID, Payer) VALUES (2, 'ThirdParty');

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
