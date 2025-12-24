-- ============================================
-- Homework 2 - Part 2: Assistive SQL Queries
-- ============================================

-- First, create the new tables for prerequisites
CREATE TABLE Prerequisite (
    prerequisite_id INT PRIMARY KEY,
    course_code VARCHAR(10),
    required_course_code VARCHAR(10),
    minimum_grade VARCHAR(2),
    FOREIGN KEY (course_code) REFERENCES Course(course_code),
    FOREIGN KEY (required_course_code) REFERENCES Course(course_code)
);

CREATE TABLE Grade (
    grade_id INT PRIMARY KEY,
    student_id INT,
    course_code VARCHAR(10),
    grade VARCHAR(2),
    completion_date DATE,
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_code) REFERENCES Course(course_code)
);

-- Insert sample prerequisite data
INSERT INTO Prerequisite (prerequisite_id, course_code, required_course_code, minimum_grade) VALUES
(1, 'ECON211', 'ECON101', 'C'),
(2, 'MATH102', 'MATH101', 'C'),
(3, 'COMP101', NULL, NULL);  -- No prerequisite

-- Insert sample grade data
INSERT INTO Grade (grade_id, student_id, course_code, grade, completion_date) VALUES
(1, 1001, 'ECON101', 'B', '2025-01-15'),
(2, 1001, 'MATH101', 'A', '2025-01-20'),
(3, 1002, 'ECON101', 'C', '2025-01-15'),
(4, 1002, 'MATH101', 'D', '2025-01-20'),
(5, 1003, 'ECON101', 'F', '2025-01-15'),
(6, 1003, 'MATH101', 'B', '2025-01-20'),
(7, 1004, 'ECON101', 'A', '2025-01-15'),
(8, 1005, 'MATH101', 'C', '2025-01-20'),
(9, 1006, 'ECON101', 'B', '2025-01-15'),
(10, 1007, 'MATH101', 'A', '2025-01-20');

-- ============================================
-- TASK 2b: Assistive SQL Queries
-- ============================================

-- Query 1: Find All Prerequisites of a Course
-- Input: Course ID (e.g., 'ECON211')
-- Output: List of all prerequisite courses and required minimum grades
SELECT 
    p.course_code AS Target_Course,
    c.course_name AS Target_Course_Name,
    p.required_course_code AS Prerequisite_Code,
    c2.course_name AS Prerequisite_Name,
    p.minimum_grade AS Minimum_Required_Grade
FROM Prerequisite p
JOIN Course c ON p.course_code = c.course_code
JOIN Course c2 ON p.required_course_code = c2.course_code
WHERE p.course_code = 'ECON211';  -- Replace with input parameter

-- Query 2: Check Whether a Student Has Passed the Prerequisites
-- Input: Student ID (e.g., 1001) and Course ID (e.g., 'ECON211')
-- Output: Prerequisite course, student's grade, and whether it's acceptable
SELECT 
    p.course_code AS Target_Course,
    p.required_course_code AS Prerequisite_Code,
    c.course_name AS Prerequisite_Name,
    p.minimum_grade AS Required_Min_Grade,
    g.grade AS Student_Grade,
    CASE 
        WHEN g.grade IS NULL THEN 'Not Taken'
        WHEN g.grade <= p.minimum_grade THEN 'Failed'
        ELSE 'Passed'
    END AS Status,
    CASE 
        WHEN g.grade IS NULL THEN 'MISSING: Course not taken'
        WHEN g.grade <= p.minimum_grade THEN 'FAILED: Grade below minimum'
        ELSE 'OK: Prerequisite satisfied'
    END AS Result
FROM Prerequisite p
LEFT JOIN Grade g ON p.required_course_code = g.course_code AND g.student_id = 1001  -- Input student_id
LEFT JOIN Course c ON p.required_course_code = c.course_code
WHERE p.course_code = 'ECON211'  -- Input course_code
ORDER BY p.required_course_code;

-- Alternative simplified version for application logic
SELECT 
    p.required_course_code,
    p.minimum_grade,
    g.grade,
    CASE 
        WHEN g.grade IS NULL THEN FALSE
        WHEN g.grade > p.minimum_grade THEN TRUE
        ELSE FALSE
    END AS is_prerequisite_met
FROM Prerequisite p
LEFT JOIN Grade g ON p.required_course_code = g.course_code AND g.student_id = 1001
WHERE p.course_code = 'ECON211';
