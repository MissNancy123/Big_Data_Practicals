-- Step 1: Check Hive version
!hive --version;

-- Step 2: Create a new database
CREATE DATABASE IF NOT EXISTS bigdata_db;
USE bigdata_db;

-- Step 3: Create an internal table for student data
CREATE TABLE IF NOT EXISTS student_data (
    id INT,
    name STRING,
    course STRING,
    marks INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Step 4: Load CSV data into internal table
-- (Make sure CSV file exists in HDFS path /user/nancy/student_data.csv)
LOAD DATA INPATH '/user/nancy/student_data.csv'
INTO TABLE student_data;

-- Step 5: Display all records
SELECT * FROM student_data;

-- Step 6: Analytical queries

-- (a) Find average marks per course
SELECT course, AVG(marks) AS avg_marks
FROM student_data
GROUP BY course;

-- (b) Get students scoring above 80
SELECT name, course, marks
FROM student_data
WHERE marks > 80;

-- (c) Count total students per course
SELECT course, COUNT(*) AS total_students
FROM student_data
GROUP BY course;

-- Step 7: Create another table for course details
CREATE TABLE IF NOT EXISTS course_info (
    course STRING,
    instructor STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Step 8: Load data into course_info table
-- (CSV file path: /user/nancy/course_info.csv)
LOAD DATA INPATH '/user/nancy/course_info.csv'
INTO TABLE course_info;

-- Step 9: Perform JOIN between tables
SELECT s.name, s.course, c.instructor
FROM student_data s
JOIN course_info c
ON (s.course = c.course);

-- Step 10: Export result to HDFS
INSERT OVERWRITE DIRECTORY '/user/nancy/hive_output'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
SELECT s.name, s.course, s.marks
FROM student_data s
WHERE s.marks > 80;

-- Step 11: Verify exported results in HDFS (Run in terminal)
-- hdfs dfs -ls /user/nancy/hive_output
-- hdfs dfs -cat /user/nancy/hive_output/000000_0;


