-- TASK 1: List Students and Their Registered Sections
SELECT 
    s.name AS Student_Name,
    c.course_code AS Course_Code,
    sec.section_id AS Section_Number,
    c.course_name AS Course_Name,
    sec.schedule AS Schedule
FROM Registration r
JOIN Student s ON r.student_id = s.student_id
JOIN Section sec ON r.section_id = sec.section_id
JOIN Course c ON sec.course_code = c.course_code
ORDER BY s.name, c.course_code;

-- TASK 2: Show Courses with Total Student Counts
SELECT 
    c.course_code AS Course_Code,
    c.course_name AS Course_Name,
    COUNT(DISTINCT r.student_id) AS Total_Students_Registered
FROM Course c
LEFT JOIN Section sec ON c.course_code = sec.course_code
LEFT JOIN Registration r ON sec.section_id = r.section_id
GROUP BY c.course_code, c.course_name
ORDER BY c.course_code;

-- TASK 3: List All Prerequisites for Each Course
SELECT 
    c1.course_code AS Target_Course,
    c1.course_name AS Target_Course_Name,
    c2.course_code AS Prerequisite_Code,
    c2.course_name AS Prerequisite_Name,
    p.minimum_grade AS Minimum_Required_Grade
FROM Prerequisite p
JOIN Course c1 ON p.course_code = c1.course_code
JOIN Course c2 ON p.required_course_code = c2.course_code
ORDER BY c1.course_code, c2.course_code;

-- TASK 4: Identify Students Eligible to Take a Course (ECON211 example)
WITH StudentPrerequisiteStatus AS (
    SELECT 
        s.student_id,
        s.name AS student_name,
        p.course_code AS target_course,
        p.required_course_code AS prerequisite_course,
        p.minimum_grade AS required_min_grade,
        g.grade AS student_grade,
        CASE 
            WHEN g.grade IS NULL THEN 'NOT_TAKEN'
            WHEN g.grade >= p.minimum_grade THEN 'PASSED'
            ELSE 'FAILED'
        END AS prerequisite_status
    FROM Student s
    CROSS JOIN Prerequisite p
    LEFT JOIN Grade g ON s.student_id = g.student_id 
        AND p.required_course_code = g.course_code
    WHERE p.course_code = 'ECON211'
),
StudentEligibility AS (
    SELECT 
        student_id,
        student_name,
        target_course,
        COUNT(*) AS total_prerequisites,
        SUM(CASE WHEN prerequisite_status = 'PASSED' THEN 1 ELSE 0 END) AS passed_prerequisites,
        BOOL_AND(prerequisite_status = 'PASSED') AS all_prerequisites_passed
    FROM StudentPrerequisiteStatus
    GROUP BY student_id, student_name, target_course
),
AlreadyRegistered AS (
    SELECT DISTINCT s.student_id
    FROM Student s
    JOIN Registration r ON s.student_id = r.student_id
    JOIN Section sec ON r.section_id = sec.section_id
    WHERE sec.course_code = 'ECON211'
)
SELECT 
    e.student_name AS Student_Name,
    e.target_course AS Target_Course,
    e.total_prerequisites AS Total_Prerequisites,
    e.passed_prerequisites AS Passed_Prerequisites,
    CASE 
        WHEN e.all_prerequisites_passed AND ar.student_id IS NULL THEN 'ELIGIBLE'
        WHEN ar.student_id IS NOT NULL THEN 'ALREADY_REGISTERED'
        ELSE 'NOT_ELIGIBLE'
    END AS Eligibility_Status
FROM StudentEligibility e
LEFT JOIN AlreadyRegistered ar ON e.student_id = ar.student_id
ORDER BY Eligibility_Status, e.student_name;

-- TASK 5: Detect Students Who Registered Without Meeting Prerequisites
WITH RegistrationWithPrerequisites AS (
    SELECT 
        r.registration_id,
        r.student_id,
        s.name AS student_name,
        sec.course_code AS registered_course,
        c.course_name AS registered_course_name,
        p.required_course_code AS prerequisite_course,
        p.minimum_grade AS required_grade
    FROM Registration r
    JOIN Student s ON r.student_id = s.student_id
    JOIN Section sec ON r.section_id = sec.section_id
    JOIN Course c ON sec.course_code = c.course_code
    LEFT JOIN Prerequisite p ON sec.course_code = p.course_code
),
StudentPrerequisiteGrades AS (
    SELECT 
        rwp.*,
        g.grade AS student_grade,
        CASE 
            WHEN g.grade IS NULL THEN 'NOT_TAKEN'
            WHEN g.grade >= rwp.required_grade THEN 'PASSED'
            ELSE 'FAILED'
        END AS prerequisite_status
    FROM RegistrationWithPrerequisites rwp
    LEFT JOIN Grade g ON rwp.student_id = g.student_id 
        AND rwp.prerequisite_course = g.course_code
    WHERE rwp.prerequisite_course IS NOT NULL
),
Violations AS (
    SELECT 
        student_name,
        registered_course,
        registered_course_name,
        prerequisite_course,
        required_grade,
        student_grade,
        prerequisite_status,
        CASE 
            WHEN student_grade IS NULL THEN 'PREREQUISITE_NOT_TAKEN'
            WHEN student_grade < required_grade THEN 'GRADE_BELOW_MINIMUM'
            ELSE 'OK'
        END AS violation_type
    FROM StudentPrerequisiteGrades
    WHERE prerequisite_status != 'PASSED'
)
SELECT 
    v.student_name AS Student_Name,
    v.registered_course AS Course_Code,
    v.registered_course_name AS Course_Name,
    v.prerequisite_course AS Missing_Prerequisite,
    COALESCE(v.student_grade, 'NOT_TAKEN') AS Student_Grade,
    v.required_grade AS Minimum_Required_Grade,
    v.violation_type AS Violation_Type,
    CASE 
        WHEN v.violation_type = 'PREREQUISITE_NOT_TAKEN' 
            THEN CONCAT('Student has not taken ', v.prerequisite_course)
        WHEN v.violation_type = 'GRADE_BELOW_MINIMUM' 
            THEN CONCAT('Student grade ', v.student_grade, ' is below minimum ', v.required_grade)
        ELSE 'No violation'
    END AS Violation_Description
FROM Violations v
ORDER BY v.student_name, v.registered_course;
