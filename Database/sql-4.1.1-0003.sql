PRAGMA foreign_keys = 0;

CREATE TABLE sqlitestudio_temp_table AS SELECT *
                                          FROM LabelSizes;

DROP TABLE LabelSizes;

CREATE TABLE LabelSizes (
    labelSizeID          INTEGER PRIMARY KEY AUTOINCREMENT,
    labelSizeDesc        TEXT    NOT NULL ON CONFLICT ROLLBACK,
    labelSizeWidth       DECIMAL NOT NULL ON CONFLICT ROLLBACK,
    labelSizeHeight      DECIMAL NOT NULL ON CONFLICT ROLLBACK,
    labelSizeOrient      TEXT,
    labelSizeMaxChar     INTEGER,
    labelPrinter         TEXT,
    labelDefaultDocument TEXT
);

INSERT INTO LabelSizes (
                           labelSizeID,
                           labelSizeDesc,
                           labelSizeWidth,
                           labelSizeHeight,
                           labelSizeOrient,
                           labelSizeMaxChar
                       )
                       SELECT labelSizeID,
                              labelSizeDesc,
                              labelSizeWidth,
                              labelSizeHeight,
                              labelSizeOrient,
                              labelSizeMaxChar
                         FROM sqlitestudio_temp_table;

DROP TABLE sqlitestudio_temp_table;

PRAGMA foreign_keys = 1;
