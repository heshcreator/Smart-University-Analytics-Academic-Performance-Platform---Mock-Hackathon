
-- SETTING THE CONTEXT



USE WAREHOUSE UNIVERSITY_WH;

USE DATABASE UNIVERSITY_DB;

USE SCHEMA UNIMART;


-- STAR SCHEMA IMPLEMENTATION



-- FACT TABLE


CREATE OR REPLACE DYNAMIC TABLE UNIMART.FACT_RESULT

TARGET_LAG = '1 MINUTE'

WAREHOUSE = UNIVERSITY_WH

AS

SELECT

    resultId,
    studentId,
    examId,
    marksObtained,
    resultStatus

FROM UNICORE.RESULT_CORE;


-- DIMENSION TABLE : STUDENT


CREATE OR REPLACE DYNAMIC TABLE UNIMART.DIM_STUDENT

TARGET_LAG = '1 MINUTE'

WAREHOUSE = UNIVERSITY_WH

AS

SELECT

    studentId,
    studentName,
    department,
    year,
    email

FROM (

    SELECT

        studentId,
        studentName,
        department,
        year,
        email,

        ROW_NUMBER() OVER (
            PARTITION BY studentId
            ORDER BY studentId
        ) AS rn

    FROM UNICORE.STUDENT_CORE

)

WHERE rn = 1;



-- DIMENSION TABLE : FACULTY


CREATE OR REPLACE DYNAMIC TABLE UNIMART.DIM_FACULTY

TARGET_LAG = '1 MINUTE'

WAREHOUSE = UNIVERSITY_WH

AS

SELECT DISTINCT

    facultyId,
    facultyName,
    specialization,
    department

FROM UNICORE.FACULTY_CORE;




-- DIMENSION TABLE : COURSE


CREATE OR REPLACE DYNAMIC TABLE UNIMART.DIM_COURSE

TARGET_LAG = '1 MINUTE'

WAREHOUSE = UNIVERSITY_WH

AS

SELECT

    courseId,
    courseName,
    credits,
    semester

FROM (

    SELECT

        courseId,
        courseName,
        credits,
        semester,

        ROW_NUMBER() OVER (
            PARTITION BY courseId
            ORDER BY courseId
        ) AS rn

    FROM UNICORE.COURSE_CORE

)

WHERE rn = 1;



-- DIMENSION TABLE : EXAMINATION


CREATE OR REPLACE DYNAMIC TABLE UNIMART.DIM_EXAMINATION

TARGET_LAG = '1 MINUTE'

WAREHOUSE = UNIVERSITY_WH

AS

SELECT

    examId,
    courseId,
    examDate,
    totalMarks,
    passPercentage

FROM (

    SELECT

        examId,
        courseId,
        examDate,
        totalMarks,
        passPercentage,

        ROW_NUMBER() OVER (
            PARTITION BY examId
            ORDER BY examId
        ) AS rn

    FROM UNICORE.EXAMINATION_CORE

)

WHERE rn = 1;


-- DIMENSION TABLE : ATTENDANCE


CREATE OR REPLACE DYNAMIC TABLE UNIMART.DIM_ATTENDANCE

TARGET_LAG = '1 MINUTE'

WAREHOUSE = UNIVERSITY_WH

AS

SELECT DISTINCT

    studentId,
    attendancePercentage,
    status

FROM UNICORE.ATTENDANCE_CORE;


-- STUDENT PERFORMANCE SUMMARY


CREATE OR REPLACE TABLE UNIMART.STUDENT_PERFORMANCE_SUMMARY AS

SELECT

    s.studentId,
    s.studentName,
    s.department,

    COUNT(f.examId) AS total_exams,

    AVG(f.marksObtained) AS avg_marks,

    MAX(f.marksObtained) AS highest_marks,

    MIN(f.marksObtained) AS lowest_marks,

    SUM(
        CASE
            WHEN f.resultStatus = 'PASS'
            THEN 1
            ELSE 0
        END
    ) AS total_pass,

    SUM(
        CASE
            WHEN f.resultStatus = 'FAIL'
            THEN 1
            ELSE 0
        END
    ) AS total_fail

FROM UNIMART.FACT_RESULT f

JOIN UNIMART.DIM_STUDENT s
ON f.studentId = s.studentId

GROUP BY

    s.studentId,
    s.studentName,
    s.department;



-- DEPARTMENT PERFORMANCE SUMMARY


CREATE OR REPLACE TABLE UNIMART.DEPARTMENT_PERFORMANCE AS

SELECT

    s.department,

    COUNT(f.studentId) AS total_students,

    AVG(f.marksObtained) AS department_avg_marks,

    MAX(f.marksObtained) AS highest_marks,

    MIN(f.marksObtained) AS lowest_marks,

    SUM(
        CASE
            WHEN f.resultStatus = 'PASS'
            THEN 1
            ELSE 0
        END
    ) AS total_pass_students,

    SUM(
        CASE
            WHEN f.resultStatus = 'FAIL'
            THEN 1
            ELSE 0
        END
    ) AS total_fail_students

FROM UNIMART.FACT_RESULT f

JOIN UNIMART.DIM_STUDENT s
ON f.studentId = s.studentId

GROUP BY s.department;


-- ATTENDANCE ALERT SUMMARY


CREATE OR REPLACE TABLE UNIMART.ATTENDANCE_ALERT_SUMMARY AS

SELECT

    studentId,
    attendancePercentage,
    status

FROM UNIMART.DIM_ATTENDANCE

WHERE attendancePercentage < 75;




-- TOPPERS SUMMARY


CREATE OR REPLACE TABLE UNIMART.TOPPERS_SUMMARY AS

SELECT

    s.studentId,
    s.studentName,
    s.department,

    AVG(f.marksObtained) AS avg_marks

FROM UNIMART.FACT_RESULT f

JOIN UNIMART.DIM_STUDENT s
ON f.studentId = s.studentId

GROUP BY

    s.studentId,
    s.studentName,
    s.department

ORDER BY avg_marks DESC;



-- PASS PERCENTAGE SUMMARY


CREATE OR REPLACE TABLE UNIMART.PASS_PERCENTAGE_SUMMARY AS

SELECT

    s.department,

    ROUND(

        (
            SUM(
                CASE
                    WHEN f.resultStatus = 'PASS'
                    THEN 1
                    ELSE 0
                END
            ) * 100.0

        ) / COUNT(*),

        2

    ) AS pass_percentage

FROM UNIMART.FACT_RESULT f

JOIN UNIMART.DIM_STUDENT s
ON f.studentId = s.studentId

GROUP BY s.department;



-- MATERIALIZED VIEW



CREATE OR REPLACE MATERIALIZED VIEW UNIMART.MV_TOPPERS AS

SELECT

    studentId,

    AVG(marksObtained) AS avg_marks

FROM UNICORE.RESULT_CORE

GROUP BY studentId;



-- VIEW FOR POWER BI


CREATE OR REPLACE VIEW UNIMART.VW_STUDENT_ANALYTICS AS

SELECT

    s.studentId,
    s.studentName,
    s.department,

    f.examId,
    f.marksObtained,
    f.resultStatus,

    a.attendancePercentage,
    a.status AS attendance_status

FROM UNIMART.FACT_RESULT f

JOIN UNIMART.DIM_STUDENT s
ON f.studentId = s.studentId

LEFT JOIN UNIMART.DIM_ATTENDANCE a
ON s.studentId = a.studentId;



-- VERIFY MART TABLES


SHOW TABLES;

SHOW DYNAMIC TABLES;

SHOW MATERIALIZED VIEWS;

SHOW VIEWS;



-- VERIFY DATA


SELECT * FROM UNIMART.FACT_RESULT;

SELECT COUNT(*) FROM UNIMART.DIM_STUDENT;

SELECT COUNT(*) FROM UNIMART.DIM_FACULTY;

SELECT COUNT(*) FROM UNIMART.DIM_COURSE;

SELECT COUNT(*) FROM UNIMART.DIM_EXAMINATION;

SELECT COUNT(*) FROM UNIMART.DIM_ATTENDANCE;

SELECT COUNT(*) FROM UNIMART.STUDENT_PERFORMANCE_SUMMARY;

SELECT COUNT(*) FROM UNIMART.DEPARTMENT_PERFORMANCE;

SELECT COUNT(*) FROM UNIMART.ATTENDANCE_ALERT_SUMMARY;

SELECT COUNT(*) FROM UNIMART.TOPPERS_SUMMARY;

SELECT COUNT(*) FROM UNIMART.PASS_PERCENTAGE_SUMMARY;

SELECT * FROM UNIMART.MV_TOPPERS;

SELECT * FROM UNIMART.VW_STUDENT_ANALYTICS;