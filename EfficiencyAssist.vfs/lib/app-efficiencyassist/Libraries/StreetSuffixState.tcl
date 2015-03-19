# Creator: Casey Ackels
# Date: May 26th, 2007
# Last Updated:
# Version: .1
# Dependencies: See brass_launch_code.tcl

proc loadSuffix {} {
    #global L_states L_streetSuffix L_secondaryUnit L_countryCodes
    global filter
    
    # Below we reset the variables to [string tolower]

# STATES
# Entries are: Name, 2 digit code
set L_states(US) [list ALABAMA \
AL \
ALASKA \
AK \
AMERICAN SAMOA \
AS \
ARIZONA \
AZ \
ARKANSAS \
AR \
CALIFORNIA \
CA \
COLORADO \
CO \
CONNECTICUT \
CT \
DELAWARE \
DE \
DISTRICT OF COLUMBIA \
DC \
FEDERATED STATES OF MICRONESIA \
FM \
FLORIDA \
FL \
GEORGIA \
GA \
GUAM \
GU \
HAWAII \
HI \
IDAHO \
ID \
ILLINOIS \
IL \
INDIANA \
IN \
IOWA \
IA \
KANSAS \
KS \
KENTUCKY \
KY \
LOUISIANA \
LA \
MAINE \
ME \
MARSHALL ISLANDS \
MH \
MARYLAND \
MD \
MASSACHUSETTS \
MA \
MICHIGAN \
MI \
MINNESOTA \
MN \
MISSISSIPPI \
MS \
MISSOURI \
MO \
MONTANA \
MT \
NEBRASKA \
NE \
NEVADA \
NV \
NEW HAMPSHIRE \
NH \
NEW JERSEY \
NJ \
NEW MEXICO \
NM \
NEW YORK \
NY \
NORTH CAROLINA \
NC \
NORTH DAKOTA \
ND \
NORTHERN MARIANA ISLANDS \
MP \
OHIO \
OH \
OKLAHOMA \
OK \
OREGON \
OR \
PALAU \
PW \
PENNSYLVANIA \
PA \
PUERTO RICO \
PR \
RHODE ISLAND \
RI \
SOUTH CAROLINA \
SC \
SOUTH DAKOTA \
SD \
TENNESSEE \
TN \
TEXAS \
TX \
UTAH \
UT \
VERMONT \
VT \
VIRGIN ISLANDS \
VI \
VIRGINIA \
VA \
WASHINGTON \
WA \
WEST VIRGINIA \
WV \
WISCONSIN \
WI \
WYOMING \
WY ]


#Street Suffix:
set filter(addrStreetSuffix) [list ALLEE ALLEY \
    ALLY ALLEY \
    ALY ALLEY \
    ANEX ANX \
    ANNX ANX \
    ANNEX ANX \
    ARCADE ARC \
    AVENUE AVE \
    AV AVE \
    AVEN AVE \
    AVENU AVE \
    AVN AVE \
    AVNUE AVE \
    BAYOO BYU \
    BAYOU BYU \
    BEACH BCH \
    BEND BND \
    BLUFF BLF \
    BLUF BLF \
    BLUFFS BLFS \
    BOTTOM BTM \
    BOTTM BTM \
    BOT BTM \
    BOULEVARD BLVD \
    BOUL BLVD \
    BOULV BLVD \
    BRANCH BR \
    BRNCH BR \
    BRIDGE BRG \
    BRDGE BRG \
    BROOK BRK \
    BROOKS BRKS \
    BURG BG \
    BURGS BGS \
    BYPASS BYP \
    BYPAS BYP \
    BYPA BYP \
    BYPS BYP \
    CAMP CP \
    CMP CP \
    CANYON CYN \
    CANYN CYN \
    CNYN CYN \
    CAPE CPE \
    CAUSEWAY CSWY \
    CAUSWAY CSWY \
    CENTER CTR \
    CENTRE CTR \
    CNTER CTR \
    CENTR CTR \
    CNTR CTR \
    CENT CTR \
    CEN CTR \
    CENTERS CTRS \
    CIRCLE CIR \
    CIRCL CIR \
    CRCLE CIR \
    CRCL CIR \
    CIRC CIR \
    CIRCLES CIRS \
    CLIFF CLF \
    CLIFFS CLFS \
    CLUB CLB \
    COMMON CMN\
    COMMONS CMNS \
    CORNER COR \
    CORNERS CORS \
    COURSE CRSE \
    COURT CT \
    CRT CT \
    COURTS CTS \
    CRTS CTS \
    COVE CV \
    COVES CVS \
    CREEK CRK \
    CR CRK \
    CK CRK \
    CRESCENT CRES \
    CRESENT CRES \
    CRECENT CRES \
    CRSCNT CRES \
    CRSENT CRES \
    CRSNT CRES \
    CREST CRST \
    CROSSING XING \
    CRSSING XING \
    CRSSNG XING \
    CROSSROAD XRD \
    CROSSROADS XRDS \
    CURVE CURV \
    DALE DL \
    DAM DM \
    DIVIDE DV \
    DIV DV \
    DVD DV \
    DRIVE DR \
    DRIV DR \
    DRV DR \
    DRIVES DRS \
    ESTATE EST \
    ESTATES ESTS \
    EXPRESSWAY EXPY \
    EXPRESS EXPY \
    EXP EXPY \
    EXPR EXPY \
    EXPW EXPY \
    EXTENSION EXT \
    EXTNSN EXT \
    EXTN EXT \
    EXTENSIONS EXTS \
    FALL FALL \
    FALLS FLS \
    FERRY FRY \
    FRRY FRY \
    FIELD FLD \
    FIELDS FLDS \
    FLAT FLT \
    FLATS FLTS \
    FORD FRD \
    FORDS FRDS \
    FOREST FRST \
    FORESTS FRST \
    FORGE FRG \
    FORG FRG \
    FORGES FRGS \
    FORK FRK \
    FORKS FRKS \
    FORT FT \
    FRT FT \
    FREEWAY FWY \
    FREEWY FWY \
    FRWAY FWY \
    FRWY FWY \
    GARDEN GDN \
    GARDN GDN \
    GRDEN GDN \
    GRDN GDN \
    GARDENS GDNS \
    GRDNS GDNS \
    GATEWAY GTWY \
    GATEWY GTWY \
    GATWAY GTWY \
    GTWAY GTWY \
    GLEN GLN \
    GLENS GLNS \
    GREEN GRN \
    GREENS GRNS \
    GROVE GRV \
    GROV GRV \
    GROVES GRVS \
    HARBOR HBR \
    HARBR HBR \
    HRBOR HBR \
    HARB HBR \
    HARBORS HBRS \
    HAVEN HVN \
    HAVN HVN \
    HEIGHTS HTS \
    HEIGHT HTS \
    HGTS HTS \
    HT HTS \
    HIGHWAY HWY \
    HIGHWY HWY \
    HIWAY HWY \
    HIWY HWY \
    HWAY HWY \
    HILL HL \
    HILLS HLS \
    HOLLOW HOLW \
    HOLLOWS HOLW \
    HOLWS HOLW \
    HLLW HOLW \
    INLET INLT \
    ISLAND IS \
    ISLND IS \
    ISLANDS ISS \
    ISLNDS ISS \
    ISLES ISLE \
    JUNCTION JCT \
    JUNCTON JCT \
    JCTION JCT \
    JUNCTN JCT \
    JCTN JCT \
    JUNCTIONS JCTS \
    JCTNS JCTS \
    KEY KY \
    KEYS KYS \
    KNOLL KNL \
    KNOL KNL \
    KNOLLS KNLS \
    LAKE LK \
    LAKES LKS \
    LANDING LNDG \
    LNDNG LNDG \
    LANE LN \
    LANES LN \
    LA LN \
    LIGHT LGT \
    LIGHTS LGTS \
    LOAF LF \
    LOCK LCK \
    LOCKS LCKS \
    LODGE LDG \
    LDGE LDG \
    LODG LDG \
    LP LOOP \
    LOOPS LOOP \
    MANOR MNR \
    MANORS MNRS \
    MEADOW MDW \
    MEADOWS MDWS \
    MEDOWS MDWS \
    MILL ML \
    MILLS MLS \
    MISSION MSN \
    MISSN MSN \
    MSSN MSN \
    MOTORWAY MTWY \
    MOUNT MT \
    MNT MT \
    MOUNTAIN MTN \
    MOUNTIN MTN \
    MNTAIN MTN \
    MNTN MTN \
    MTIN MTN \
    MOUNTAINS MTNS \
    MNTNS MTNS \
    NECK NCK \
    ORCHARD ORCH \
    ORCHRD ORCH \
    OVL OVAL \
    OVERPASS OPAS \
    PRK PARK \
    PARKS PARK \
    PARKWAY PKWY \
    PARKWY PKWY \
    PKWAY PKWY \
    PARKWAYS PKWY \
    PKWYS PKWY \
    PASSAGE PSGE \
    PATHS PATH \
    PIKES PIKE \
    PINE PNE \
    PINES PNES \
    PLACE PL \
    PLAIN PLN \
    PLAINS PLNS \
    PLAINES PLNS \
    PLAZA PLZ \
    PLZA PLZ \
    POINT PT \
    POINTS PTS \
    PORT PRT \
    PORTS PRTS \
    PRAIRIE PR \
    PRARIE PR \
    PRR PR \
    RADIAL RADL \
    RADIEL RADL \
    RAD RADL \
    RANCHES RNCH \
    RNCHS RNCH \
    RANCH RNCH \
    RAPID RPD \
    RAPIDS RPDS \
    REST RST \
    RIDGE RDG \
    RDGE RDG \
    RIDGES RDGS \
    RIVER RIV \
    RIVR RIV \
    RVR RIV \
    ROAD RD \
    ROADS RDS \
    ROUTE RTE \
    SHOAL SHL \
    SHOALS SHLS \
    SHORE SHR \
    SHOAR SHR \
    SHORES SHRS \
    SHOARS SHRS \
    SKYWAY SKWY \
    SPRING SPG \
    SPRNG SPG \
    SPNG SPG \
    SPRINGS SPGS \
    SPNGS SPGS \
    SPRNGS SPGS \
    SPURS SPUR \
    SQUARE SQ \
    SQRE SQ \
    SQU SQ \
    SQR SQ \
    SQUARES SQS \
    SQRS SQS \
    STATION STA \
    STATN STA \
    STN STA \
    STRAVENUE STRA \
    STRVNUE STRA \
    STRAVEN STRA \
    STRAVN STRA \
    STRVN STRA \
    STRAV STRA \
    STREAM STRM \
    STREME STRM \
    STREET ST \
    STRT ST \
    STR ST \
    STREETS STS \
    SUMITT SMT \
    SUMMIT SMT \
    SUMIT SMT \
    TERRACE TER \
    TERR TER \
    THROUGHWAY TER \
    TRWY TER \
    TRACE TRCE \
    TRACES TRCE \
    TRACK TRAK \
    TRACKS TRAK \
    TRK TRAK \
    TRAFFICWAY TRFY \
    TRAIL TRL \
    TRAILS TRL \
    TRLS TRL \
    TR TRL \
    TUNNELS TUNL \
    TUNNEL TUNL \
    TUNNL TUNL \
    TUNEL TUNL \
    TUNLS TUNL \
    TURNPIKE TPKE \
    TURNPK TPKE \
    TRPK TPKE \
    TPK TPKE \
    UNDERPASS UPAS \
    UNION UN \
    UNIONS UNS \
    VALLEY VLY \
    VLLY VLY \
    VALLY VLY \
    VALLEYS VLYS \
    VIADUCT VIA \
    VIADCT VIA \
    VDCT VIA \
    VIEW VW \
    VIEWS VWS \
    VILLIAGE VLG \
    VILLAGE VLG \
    VILLAG VLG \
    VILLG VLG\
    VILL VLG \
    VILLAGES VLGS \
    VILLE VL \
    VISTA VIS \
    VIST VIS \
    VSTA VIS \
    VST VIS \
    WALKS WALK \
    WY WAY \
    WELL WL \
    WELLS WLS]

    
#Secondary Unit
# Entries are: Name
set filter(secondaryUnits) [list APARTMENT APT \
BASEMENT BSMT \
BUILDING BLDG \
DEPARTMENT DEPT \
FLOOR FL \
FRONT FRNT \
HANGAR HNGR \
LOBBY LBBY \
LOWER LOWR \
OFFICE OFC \
PENTHOUSE PH \
ROOM RM \
SPACE SPC \
SUITE STE \
TRAILER TRLR \
UPPER UPPR \
# NO.]

# Countries
# Entries are: Name, 2 digit code
set L_countryCodes [list Afghanistan \
AF \
Albania \
AL \
Algeria	\
DZ \
{American Samoa} \
AS \
Andorra	\
AD \
Angola \
AO \
Anguilla \
AI \
Antarctica \
AQ \
{Antigua and Barbuda} \
AG \
Argentina \
AR \
Armenia	\
AM \
Aruba \
AW \
Australia \
AU \
Austria \
AT \
Azerbaijan \
AZ \
Bahamas \
BS \
Bahrain \
BH \
Bangladesh \
BD \
Barbados \
BB \
Belarus \
BY \
Belgium \
BE \
Belize \
BZ \
Benin \
BJ \
Bermuda \
BM \
Bhutan \
BT \
Bolivia \
BO \
{Bosnia and Herzegovina} \
BA \
Botswana \
BW \
Brazil \
BR \
{British Indian Ocean Territory} \
IO \
{British Virgin Islands} \
VG \
Brunei \
BN \
Bulgaria \
BG \
Burkina Faso \
BF \
{Burma (Myanmar)}	\
MM \
Burundi	\
BI \
Cambodia \
KH \
Cameroon \
CM \
Canada \
CA \
Cape Verde \
CV \
{Cayman Islands} \
KY \
{Central African Republic} \
CF \
Chad \
TD \
Chile \
CL \
China \
CN \
{Christmas Island} \
CX \
{Cocos (Keeling) Islands} \
CC \
Colombia \
CO \
Comoros	\
KM \
{Cook Islands} \
CK \
{Costa Rica} \
CR \
Croatia	\
HR \
Cuba \
CU \
Cyprus \
CY \
{Czech Republic} \
CZ \
{Democratic Republic of the Congo} \
CD \
Denmark \
DK \
Djibouti \
DJ \
Dominica \
DM \
{Dominican Republic} \
DO \
Ecuador \
EC \
Egypt \
EG \
{El Salvador} \
SV \
{Equatorial Guinea} \
GQ \
Eritrea \
ER \
Estonia \
EE \
Ethiopia \
ET \
{Falkland Islands} \
FK \
{Faroe Islands} \
FO \
Fiji \
FJ \
Finland \
FI \
France \
FR \
{French Polynesia} \
PF \
Gabon \
GA \
Gambia \
GM \
Gaza Strip \
Georgia \
GE \
Germany \
DE \
Ghana \
GH \
Gibraltar \
GI \
Greece \
GR \
Greenland \
GL \
Grenada \
GD \
Guam \
GU \
Guatemala \
GT \
Guinea \
GN \
Guinea-Bissau \
GW \
Guyana \
GY \
Haiti \
HT \
{Holy See (Vatican City)} \
VA \
Honduras \
HN \
{Hong Kong} \
HK \
Hungary	\
HU \
Iceland	\
IS \
India \
IN \
Indonesia \
ID \
Iran \
IR \
Iraq \
IQ \
Ireland	\
IE \
{Isle of Man}	\
IM \
Israel \
IL \
Italy \
IT \
{Ivory Coast} \
CI \
Jamaica	\
JM \
Japan \
JP \
Jersey \
JE \
Jordan \
JO \
Kazakhstan \
KZ \
Kenya \
KE \
Kiribati \
KI \
Kosovo \
Kuwait \
KW \
Kyrgyzstan \
KG \
Laos \
LA \
Latvia \
LV \
Lebanon	\
LB \
Lesotho	\
LS \
Liberia	\
LR \
Libya \
LY \
Liechtenstein \
LI \
Lithuania \
LT \
Luxembourg \
LU \
Macau \
MO \
Macedonia \
MK \
Madagascar \
MG \
Malawi \
MW \
Malaysia \
MY \
Maldives \
MV \
Mali \
ML \
Malta \
MT \
{Marshall Islands} \
MH \
Mauritania \
MR \
Mauritius \
MU \
Mayotte \
YT \
Mexico \
MX \
Micronesia \
FM \
Moldova \
MD \
Monaco \
MC \
Mongolia \
MN \
Montenegro \
ME \
Montserrat \
MS \
Morocco \
MA \
Mozambique \
MZ \
Namibia \
NA \
Nauru \
NR \
Nepal \
NP \
Netherlands \
NL \
{Netherlands Antilles} \
AN \
New Caledonia \
NC \
New Zealand \
NZ \
Nicaragua \
NI \
Niger \
NE \
Nigeria \
NG \
Niue \
NU \
{Norfolk Island} \
North Korea	\
KP \
{Northern Mariana Islands} \
MP \
Norway \
NO \
Oman \
OM \
Pakistan \
PK \
Palau \
PW \
Panama \
PA \
{Papua New Guinea} \
PG \
Paraguay \
PY \
Peru \
PE \
Philippines	\
PH \
{Pitcairn Islands} \
PN \
Poland \
PL \
Portugal \
PT \
{Puerto Rico} \
PR \
Qatar \
QA \
{Republic of the Congo} \
CG \
Romania	\
RO \
Russia \
RU \
Rwanda \
RW \
{Saint Barthelemy} \
BL \
{Saint Helena} \
SH \
{Saint Kitts and Nevis} \
KN \
{Saint Lucia} \
LC \
{Saint Martin} \
MF \
{Saint Pierre and Miquelon} \
PM \
{Saint Vincent and the Grenadines} \
VC \
Samoa \
WS \
{San Marino} \
SM \
{Sao Tome and Principe} \
ST \
{Saudi Arabia} \
SA \
Senegal \
SN \
Serbia \
RS \
Seychelles \
SC \
{Sierra Leone} \
SL \
Singapore \
SG \
Slovakia \
SK \
Slovenia \
SI \
{Solomon Islands} \
SB \
Somalia \
SO \
{South Africa} \
ZA \
{South Korea} \
KR \
Spain \
ES \
{Sri Lanka} \
LK \
Sudan \
SD \
Suriname \
SR \
Svalbard \
SJ \
Swaziland \
SZ \
Sweden \
SE \
Switzerland \
CH \
Syria \
SY \
Taiwan \
TW \
Tajikistan \
TJ \
Tanzania \
TZ \
Thailand \
TH \
Timor-Leste \
TL \
Togo \
TG \
Tokelau	\
TK \
Tonga \
TO \
{Trinidad and Tobago} \
TT \
Tunisia	\
TN \
Turkey \
TR \
Turkmenistan \
TM \
{Turks and Caicos Islands} \
TC \
Tuvalu \
TV \
Uganda \
UG \
Ukraine \
UA \
{United Arab Emirates} \
AE \
{United Kingdom} \
GB \
{United States} \
US \
Uruguay \
UY \
{US Virgin Islands} \
VI \
Uzbekistan \
UZ \
Vanuatu \
VU \
Venezuela \
VE \
Vietnam \
VN \
{Wallis and Futuna} \
WF \
{West Bank} \
{Western Sahara} \
EH \
Yemen \
YE \
Zambia \
ZM \
Zimbabwe \
ZW]

set L_states(CA) [list Alberta \
AB \
{British Columbia} \
BC \
Manitoba \
MB \
{New Brunswick} \
NB \
Newfoundland \
NL \
Labrador \
NL \
{Nova Scotia} \
NS \
{Northwest Territories} \
NT \
Nunavut \
NT \
Ontario \
ON \
{Prince Edward Island} \
PE \
Quebec \
QC \
Saskatchewan \
SK \
Yukon \
YT]

# Entries are: Name, Conventional abbreviation, 2 digit code
set L_states(MX) [list Aguascalientes \
AGS \
AG \
{Baja California} \
BC \
BC \
{Baja California Sur} \
BCS \
BS \
Campeche \
Camp \
CM \
Chiapas \
Chis \
CS \
Chihuahua \
Chih \
CH \
Coahuila \
Coah \
CO \
Colima \
Col \
CL \
{Federal District} \
DF \
DF \
Durango \
DGO \
DG \
Guanajuato \
GTO \
GT \
Guerrero \
GRO \
GR \
Hidalgo \
HGO \
HG \
Jalisco \
JAL \
JA \
{Mexico State} \
Edomex \
ME \
Michaoacan \
Mich \
MI \
Morelos \
Mor \
MO \
Nayarit \
NL \
NL \
Oaxaca \
Oax \
OA \
Puebla \
Pue \
PU \
Queretaro \
Qro \
QE \
{Quintana Roo} \
{Q Roo} \
QR \
{San Luis Potosi} \
SLP \
SL \
Sinaloa \
Sin \
SI \
Sonora \
Son \
SO \
Tabasco \
Tab \
TB \
Tamaulipas \
Tamps \
TM \
Tlaxcala \
tlax \
TL \
Veracruz \
Ver \
VE \
Yucatan \
YUC \
YU \
Zacatecas \
Zac \
ZA]

set L_ZipCodes(USA,0) [list Connecticut \
CT \
Massachussetts \
MA \
Maine \
ME \
{New Hampshire} \
NH \
{New Jersey} \
NJ \
{Puerto Rico} \
PR \
{Rhode Island} \
RI \
Vermont \
VT \
{Virigin Islands} \
VI \
{Army Post Europe} \
AE \
{Fleet Post Office Europe} \
AE]

set L_zipCodes(USA,1) [list Delaware \
DE \
{New York} \
NY \
Pennsylvania \
PA]

set L_zipCodes(USA,2) [list {District of Columbia} \
DC \
Maryland \
MD \
{North Carolina} \
NC \
{South Carolina} \
SC \
Virgina \
VA \
{West Virgina} \
WV]

set L_zipCodes(USA,3) [list Alabama \
AL \
Florida \
FL \
Georgia \
GA \
Mississippi \
MS \
Tennessee \
TN \
{Army Post Office Americas} \
AA \
{Fleet Post Office Americas} \
AA]

set L_zipCodes(USA,4) [list Indiana \
IN \
Kentucky \
KY \
Michigan \
MI \
Ohio \
OH]

set L_zipCodes(USA,5) [list Iowa \
IA \
Minnesota \
MN \
Montana \
MT \
{North Dakota} \
ND \
{South Dakota} \
SD \
Wisconsin \
WI]


#set StreetSuffix(Road) [list Road Rd]
##set L_states [string toupper $L_states]
#set L_streetSuffix [string toupper $L_streetSuffix]
#set L_secondaryUnit [string toupper $L_secondaryUnit]
}
# * Does not require secondary range number to follow
    
#Tracey Wells Daly, Marketing Manager
#7905 Malcolm Rd Ste 311
#Clinton, MD 20735
#301-856-5000 x1326
#
#
#Company Name, Attn, Address1, Address2, Address3, City, State, Zip, Phone
