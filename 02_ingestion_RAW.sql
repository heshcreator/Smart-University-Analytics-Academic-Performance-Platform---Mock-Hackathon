--setting up the context
USE WAREHOUSE UNIVERSITY_WH;
USE DATABASE UNIVERSITY_DB ;
USE SCHEMA UNIRAW;

--creating a file format


-- CSV FILE FORMAT

CREATE OR REPLACE FILE FORMAT CSV_FORMAT
TYPE = CSV
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY='"'
EMPTY_FIELD_AS_NULL = TRUE
TRIM_SPACE = TRUE;


-- JSON FILE FORMAT

CREATE OR REPLACE FILE FORMAT JSON_FORMAT
TYPE = JSON;


-- =====================================================
-- SHOW FILE FORMATS
-- =====================================================

SHOW FILE FORMATS;


-- =====================================================
-- CREATE AWS S3 STAGE FOR CSV FILES
-- =====================================================

CREATE OR REPLACE STAGE UNIVERS_CSV_STAGE
URL='s3://uni-csv-bucket-hesh'
CREDENTIALS = (
  AWS_KEY_ID = 'AKIAYNQGML2KCF6DDYH6'
  AWS_SECRET_KEY = 'd+ggajeaOOLquVLB1mhvhibdqq09VESfpQBejNVU'
)
FILE_FORMAT = CSV_FORMAT;


-- =====================================================
-- CREATE AWS S3 STAGE FOR JSON FILES
-- =====================================================

CREATE OR REPLACE STAGE UNIVERS_JSON_STAGE
URL='s3://uni-json-bucket-hesh'
CREDENTIALS = (
  AWS_KEY_ID = 'AKIAYNQGML2KCF6DDYH6'
  AWS_SECRET_KEY = 'd+ggajeaOOLquVLB1mhvhibdqq09VESfpQBejNVU'
)
FILE_FORMAT = JSON_FORMAT;


SHOW STAGES;


-- =====================================================
-- CREATE REQUIRED RAW TABLES
-- =====================================================

-- STUDENT RAW TABLE

CREATE OR REPLACE TABLE STUDENT_RAW(
    studentId STRING,
    studentName STRING,
    department STRING,
    year INT,
    email STRING
);


-- FACULTY RAW TABLE

CREATE OR REPLACE TABLE FACULTY_RAW(
    facultyId STRING,
    facultyName STRING,
    specialization STRING,
    department STRING
);


-- COURSE RAW TABLE

CREATE OR REPLACE TABLE COURSE_RAW(
    courseId STRING,
    courseName STRING,
    credits INT,
    semester INT
);


-- EXAMINATION RAW TABLE

CREATE OR REPLACE TABLE EXAMINATION_RAW(
    examId STRING,
    courseId STRING,
    examDate DATE,
    totalMarks INT,
    passPercentage FLOAT
);


-- STUDENT RESULT RAW TABLE

CREATE OR REPLACE TABLE RESULT_RAW(
    resultId STRING,
    studentId STRING,
    examId STRING,
    marksObtained INT,
    resultStatus STRING
);


-- ATTENDANCE RAW TABLE FOR JSON

CREATE OR REPLACE TABLE ATTENDANCE_RAW(
    RAW_DATA VARIANT
);



-- SHOW TABLES


SHOW TABLES;



-- SHOW STAGES


SHOW STAGES;



-- LIST FILES FROM CSV S3 STAGE


LIST @UNIVERS_CSV_STAGE;



-- LIST FILES FROM JSON S3 STAGE


LIST @UNIVERS_JSON_STAGE;




INSERT INTO STUDENT_RAW
VALUES
(
'S999',
'TEST STUDENT',
'CSE',
3,
'test@gmail.com'
);

INSERT INTO RESULT_RAW
VALUES
(
'R999',
'S999',
'E401',
85,
'PASS'
);

INSERT INTO ATTENDANCE_RAW

SELECT
PARSE_JSON(
'[
  {
    "studentId":"S999",
    "attendancePercentage":60,
    "status":"LOW"
  }
]'
);