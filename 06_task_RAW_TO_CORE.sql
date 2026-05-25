
-- SETTING UP CONTEXT


USE WAREHOUSE UNIVERSITY_WH;

USE DATABASE UNIVERSITY_DB;

USE SCHEMA UNICORE;


-- CREATE CORE TABLES USING LIKE


CREATE OR REPLACE TABLE STUDENT_CORE
LIKE UNIRAW.STUDENT_RAW;


CREATE OR REPLACE TABLE FACULTY_CORE
LIKE UNIRAW.FACULTY_RAW;


CREATE OR REPLACE TABLE COURSE_CORE
LIKE UNIRAW.COURSE_RAW;


CREATE OR REPLACE TABLE EXAMINATION_CORE
LIKE UNIRAW.EXAMINATION_RAW;


CREATE OR REPLACE TABLE RESULT_CORE
LIKE UNIRAW.RESULT_RAW;


-- ATTENDANCE CORE TABLE

CREATE OR REPLACE TABLE ATTENDANCE_CORE(
    studentId STRING,
    attendancePercentage INT,
    status STRING
);



-- ALERT TABLES


CREATE OR REPLACE TABLE FAILED_STUDENT_ALERT(
    studentId STRING,
    examId STRING,
    marksObtained INT,
    alertMessage STRING,
    createdAt TIMESTAMP
);


CREATE OR REPLACE TABLE LOW_ATTENDANCE_ALERT(
    studentId STRING,
    attendancePercentage INT,
    alertMessage STRING,
    createdAt TIMESTAMP
);



-- CREATE SINGLE TASK : RAW TO CORE


CREATE OR REPLACE TASK TASK_RAW_TO_CORE_UNI

WAREHOUSE = UNIVERSITY_WH

SCHEDULE = '1 MINUTE'

AS

BEGIN


    
    -- STUDENT LOAD
    

    INSERT INTO STUDENT_CORE

    SELECT DISTINCT
        studentId,
        studentName,
        department,
        year,
        email

    FROM UNIRAW.STUDENT_STREAM

    WHERE studentId IS NOT NULL;


    -- FACULTY LOAD
    

    INSERT INTO FACULTY_CORE

    SELECT DISTINCT
        facultyId,
        facultyName,
        specialization,
        department

    FROM UNIRAW.FACULTY_STREAM

    WHERE facultyId IS NOT NULL;


    -- COURSE LOAD
    

    INSERT INTO COURSE_CORE

    SELECT DISTINCT
        courseId,
        courseName,
        credits,
        semester

    FROM UNIRAW.COURSE_STREAM

    WHERE courseId IS NOT NULL;



    
    -- EXAMINATION LOAD
    

    INSERT INTO EXAMINATION_CORE

    SELECT
        examId,
        courseId,
        examDate,
        totalMarks,
        passPercentage

    FROM UNIRAW.EXAMINATION_STREAM

    WHERE totalMarks > 0;



  

    INSERT INTO RESULT_CORE

    SELECT
        r.resultId,
        r.studentId,
        r.examId,
        r.marksObtained,
        r.resultStatus

    FROM UNIRAW.RESULT_STREAM r
    JOIN EXAMINATION_CORE e
    ON r.examId = e.examId

    WHERE r.marksObtained <= e.totalMarks;



    INSERT INTO FAILED_STUDENT_ALERT

    SELECT
        studentId,
        examId,
        marksObtained,
        'FAILED STUDENT ALERT',
        CURRENT_TIMESTAMP()

    FROM RESULT_CORE

    WHERE resultStatus = 'FAIL';



    INSERT INTO ATTENDANCE_CORE

    SELECT
        VALUE:studentId::STRING,
        VALUE:attendancePercentage::INT,
        VALUE:status::STRING

    FROM UNIRAW.ATTENDANCE_STREAM,
    LATERAL FLATTEN(INPUT => RAW_DATA);



    -- =================================================
    -- LOW ATTENDANCE ALERT
    -- =================================================

    INSERT INTO LOW_ATTENDANCE_ALERT

    SELECT
        studentId,
        attendancePercentage,
        'LOW ATTENDANCE ALERT',
        CURRENT_TIMESTAMP()

    FROM ATTENDANCE_CORE

    WHERE attendancePercentage < 75;

END;



-- START TASK


ALTER TASK TASK_RAW_TO_CORE_UNI RESUME;


-- STOP TASK


ALTER TASK TASK_RAW_TO_CORE_UNI SUSPEND;



-- VERIFY TASKS


SHOW TASKS;



-- VERIFY CORE DATA


SELECT COUNT(*) FROM UNICORE.STUDENT_CORE;

SELECT COUNT(*) FROM UNICORE.FACULTY_CORE;

SELECT COUNT(*) FROM COURSE_CORE;

SELECT COUNT(*) FROM EXAMINATION_CORE;

SELECT COUNT(*) FROM RESULT_CORE;

SELECT COUNT(*) FROM ATTENDANCE_CORE;



-- VERIFY ALERT TABLES


SELECT * FROM FAILED_STUDENT_ALERT;

SELECT * FROM LOW_ATTENDANCE_ALERT;