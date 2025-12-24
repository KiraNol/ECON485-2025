-- ============================================
-- ECON485 Homework 2 - Part 1: SQL Implementation
-- Student: Elif Işıl Çiçek
-- Student ID: 23232810007
-- Date: December 2025
-- ============================================

-- TASK 1a: CREATE TABLE Statements
-- Based on Homework 1 Part 3a design

-- 1. Student Table
CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    status VARCHAR(20) DEFAULT 'Active'
);

-- 2. Course Table
CREATE TABLE Course (
    course_code VARCHAR(10) PRIMARY KEY,
    course_name VARCHAR(200) NOT NULL,
    credits INT NOT NULL,
    department VARCHAR(50)
);

-- 3. Instructor Table
CREATE TABLE Instructor (
    instructor_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    email VARCHAR(100) UNIQUE
);

-- 4. Section Table
CREATE TABLE Section (
    section_id INT PRIMARY KEY,
    course_code VARCHAR(10),
    instructor_id INT,
    schedule VARCHAR(50),
    classroom VARCHAR(20),
    max_capacity INT,
    FOREIGN KEY (course_code) REFERENCES Course(course_code),
    FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id)
);

-- 5. Registration Table
CREATE TABLE Registration (
    registration_id INT PRIMARY KEY,
    student_id INT,
    section_id INT,
    registration_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (section_id) REFERENCES Section(section_id)
);

-- ============================================
-- TASK 1b: INSERT Example Data
-- ============================================

-- Insert Courses (minimum 3 courses)
INSERT INTO Course (course_code, course_name, credits, department) VALUES
('ECON101', 'Introduction to Economics', 6, 'Economics'),
('MATH101', 'Calculus I', 6, 'Mathematics'),
('COMP101', 'Introduction to Programming', 6, 'Computer Science'),
('ECON211', 'Microeconomics', 6, 'Economics'),
('MATH102', 'Calculus II', 6, 'Mathematics');

-- Insert Instructors
INSERT INTO Instructor (instructor_id, name, department, email) VALUES
(1, 'Dr. Alice Smith', 'Economics', 'alice.smith@university.edu'),
(2, 'Prof. Bob Johnson', 'Mathematics', 'bob.johnson@university.edu'),
(3, 'Dr. Carol Davis', 'Computer Science', 'carol.davis@university.edu'),
(4, 'Prof. David Wilson', 'Economics', 'david.wilson@university.edu');

-- Insert Sections (each course has at least 1 section)
INSERT INTO Section (section_id, course_code, instructor_id, schedule, classroom, max_capacity) VALUES
(101, 'ECON101', 1, 'Mon-Wed 09:00-10:30', 'Room A101', 50),
(102, 'ECON101', 1, 'Tue-Thu 14:00-15:30', 'Room A102', 50),
(103, 'MATH101', 2, 'Mon-Wed-Fri 10:00-11:00', 'Room B201', 40),
(104, 'MATH101', 2, 'Tue-Thu 13:00-14:30', 'Room B202', 40),
(105, 'COMP101', 3, 'Mon-Wed 11:00-12:30', 'Lab C301', 30),
(106, 'ECON211', 4, 'Tue-Thu 10:00-11:30', 'Room D401', 45),
(107, 'MATH102', 2, 'Mon-Wed-Fri 09:00-10:00', 'Room B203', 35);

-- Insert Students (minimum 10 students)
INSERT INTO Student (student_id, name, email, status) VALUES
(1001, 'Ahmet Yılmaz', 'ahmet.yilmaz@student.edu', 'Active'),
(1002, 'Ayşe Kaya', 'ayse.kaya@student.edu', 'Active'),
(1003, 'Mehmet Demir', 'mehmet.demir@student.edu', 'Active'),
(1004, 'Zeynep Şahin', 'zeynep.sahin@student.edu', 'Active'),
(1005, 'Can Öztürk', 'can.ozturk@student.edu', 'Active'),
(1006, 'Elif Arslan', 'elif.arslan@student.edu', 'Active'),
(1007, 'Burak Çelik', 'burak.celik@student.edu', 'Active'),
(1008, 'Seda Yıldız', 'seda.yildiz@student.edu', 'Active'),
(1009, 'Emre Korkmaz', 'emre.korkmaz@student.edu', 'Active'),
(1010, 'Deniz Aydın', 'deniz.aydin@student.edu', 'Active'),
(1011, 'Cemre Aksoy', 'cemre.aksoy@student.edu', 'Active'),
(1012, 'Tolga Karahan', 'tolga.karahan@student.edu', 'Active');

-- ============================================
-- TASK 1c: Demonstrate Add and Drop Actions
-- ============================================

-- ADD Actions (each student adds at least one course)
-- Initial registrations
INSERT INTO Registration (registration_id, student_id, section_id, registration_date) VALUES
(1, 1001, 101, '2025-09-01'),
(2, 1001, 103, '2025-09-01'),
(3, 1002, 101, '2025-09-01'),
(4, 1003, 105, '2025-09-01'),
(5, 1004, 102, '2025-09-01'),
(6, 1005, 104, '2025-09-01'),
(7, 1006, 106, '2025-09-01'),
(8, 1007, 107, '2025-09-01'),
(9, 1008, 103, '2025-09-01'),
(10, 1009, 105, '2025-09-01'),
(11, 1010, 101, '2025-09-01'),
(12, 1011, 102, '2025-09-01'),
(13, 1012, 104, '2025-09-01');

-- Additional ADD actions (to reach minimum 15 registrations)
INSERT INTO Registration (registration_id, student_id, section_id, registration_date) VALUES
(14, 1002, 103, '2025-09-02'),
(15, 1003, 101, '2025-09-02'),
(16, 1005, 106, '2025-09-02'),
(17, 1007, 103, '2025-09-02'),
(18, 1009, 101, '2025-09-02');

-- DROP Actions (at least 3 students drop a course)
DELETE FROM Registration WHERE registration_id = 2;  -- Ahmet drops MATH101
DELETE FROM Registration WHERE registration_id = 7;  -- Elif drops ECON211
DELETE FROM Registration WHERE registration_id = 11; -- Deniz drops ECON101 section 101
DELETE FROM Registration WHERE registration_id = 17; -- Burak drops MATH101

-- Additional DROP to show more actions
DELETE FROM Registration WHERE registration_id = 9;  -- Seda drops MATH101

-- ============================================
-- TASK 1d: Show All Final Registrations
-- ============================================

-- Final state of registrations
SELECT 
    s.name AS Student_Name,
    c.course_code AS Course_Code,
    c.course_name AS Course_Name,
    sec.section_id AS Section_Number,
    sec.schedule AS Schedule,
    sec.classroom AS Classroom,
    r.registration_date AS Registration_Date
FROM Registration r
JOIN Student s ON r.student_id = s.student_id
JOIN Section sec ON r.section_id = sec.section_id
JOIN Course c ON sec.course_code = c.course_code
ORDER BY s.name, c.course_code;
