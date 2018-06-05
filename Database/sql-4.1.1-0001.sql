PRAGMA foreign_keys = 0;

CREATE TABLE sqlitestudio_temp_table AS SELECT *
                                          FROM LabelProfiles;

DROP TABLE LabelProfiles;

CREATE TABLE LabelProfiles (
    LabelProfileID   INTEGER PRIMARY KEY AUTOINCREMENT,
    LabelProfileDesc TEXT    UNIQUE ON CONFLICT ROLLBACK,
    labelSizeID      INTEGER REFERENCES LabelSizes (labelSizeID)
);

INSERT INTO LabelProfiles (
                              LabelProfileID,
                              LabelProfileDesc
                          )
                          SELECT LabelProfileID,
                                 LabelProfileDesc
                            FROM sqlitestudio_temp_table;

DROP TABLE sqlitestudio_temp_table;

PRAGMA foreign_keys = 1;
