-- Create a new database named SchoolDB to store the student course enrolment system data
CREATE DATABASE SchoolDB;

-- Use the SchoolDB database for all subsequent operations
USE SchoolDB;

-- Create the Students table to store information about each student
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,  -- Primary Key: unique identifier for each student
    first_name VARCHAR(100) NOT NULL,           -- First name of the student (required)
    last_name VARCHAR(100) NOT NULL,            -- Last name of the student (required)
    date_of_birth DATE NOT NULL,                -- Date of birth of the student (required)
    email VARCHAR(255) NOT NULL UNIQUE          -- Email of the student (required and unique)
);

-- Create the Courses table to store information about each course offered
CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,   -- Primary Key: unique identifier for each course
    course_name VARCHAR(255) NOT NULL,          -- Name of the course (required)
    description TEXT,                           -- Description of the course (optional)
    credits INT NOT NULL                        -- Number of credits awarded for the course (required)
);

-- Create the Enrolments table to manage student enrollments in courses
CREATE TABLE Enrolments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,   -- Primary Key: unique identifier for each enrollment
    student_id INT,                                 -- Foreign Key linking to Students table
    course_id INT,                                  -- Foreign Key linking to Courses table
    enrolment_date DATE NOT NULL,                   -- Date when the student enrolled in the course
    grade CHAR(2),                                  -- Grade achieved by the student in the course (optional)
    
    -- Foreign Key constraint to ensure each enrollment is linked to a valid student
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
    ON DELETE CASCADE,                              -- If a student is deleted, their enrollments are also deleted
    
    -- Foreign Key constraint to ensure each enrollment is linked to a valid course
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
    ON DELETE CASCADE                               -- If a course is deleted, associated enrollments are deleted
);



-- Insert sample data into Students table
-- Adding initial students with details like first name, last name, date of birth, and email
INSERT INTO Students (first_name, last_name, date_of_birth, email) VALUES
('Alamin', 'Ahmad', '1999-10-27', 'alamin.a@example.com'),
('Sammi', 'zayn', '1998-05-15', 'sammi.z@example.com');

-- Insert sample data into Courses table
-- Adding initial courses with details like course name, description, and credits
INSERT INTO Courses (course_name, description, credits) VALUES
('Mathematics', 'An advanced course in mathematics.', 4),
('History', 'Comprehensive history of ancient civilizations.', 3);

-- Insert sample data into Enrolments table
-- Adding initial enrollments, linking students to courses with enrolment dates
INSERT INTO Enrolments (student_id, course_id, enrolment_date, grade) VALUES
(1, 1, '2024-01-10', 'A'),   -- Alamin enrolled in Mathematics on 2024-01-10 and received grade 'A'
(2, 2, '2024-01-12', 'B');   -- Sammi enrolled in History on 2024-01-12 and received grade 'B'

-- Select all columns for all students in the Students table to display their information
SELECT * FROM Students;

-- Select all columns for all courses in the Courses table to display course details
SELECT * FROM Courses;

-- Retrieves all enrollments, linking them with student and course details using joins
SELECT e.enrollment_id,        -- The enrollment ID from the Enrolments table
       s.first_name,           -- The first name of the student from the Students table
       s.last_name,            -- The last name of the student from the Students table
       c.course_name,          -- The name of the course from the Courses table
       e.enrolment_date,       -- The date of enrolment
       e.grade                 -- The grade achieved by the student in the course
FROM Enrolments e              -- The Enrolments table acts as the base
JOIN Students s ON e.student_id = s.student_id   -- Join Enrolments with Students on student_id
JOIN Courses c ON e.course_id = c.course_id;     -- Join Enrolments with Courses on course_id


-- Updates the grade of a specific student for a specific course in the Enrolments table
UPDATE Enrolments
SET grade = 'A+'               -- Change the grade to 'A+'
WHERE student_id = 1           -- Specify the student by ID
  AND course_id = 1;           -- Specify the course by ID


-- Creates a view to display students' enrolled courses and their grades
CREATE VIEW StudentCourseGrades AS
SELECT s.first_name,           -- Student's first name
       s.last_name,            -- Student's last name
       c.course_name,          -- Name of the enrolled course
       e.grade                 -- Grade achieved in the course
FROM Enrolments e              -- The Enrolments table acts as the base
JOIN Students s ON e.student_id = s.student_id   -- Link Enrolments with Students
JOIN Courses c ON e.course_id = c.course_id;     -- Link Enrolments with Courses


SELECT * FROM StudentCourseGrades;

SHOW PROCEDURE STATUS WHERE Db = 'SchoolDB';

USE SchoolDB;


DELIMITER $$ -- Change the statement delimiter to $$ to handle the procedure body
CREATE PROCEDURE `Enrol`(IN student INT, course INT, IN enrolmentdate DATE) -- Input parameter for student ID, Input parameter for course ID, Input parameter for enrolment date
BEGIN
INSERT INTO enrolments(student_id, course_id, enrolment_date) -- Insert a new row into Enrolments with the provided student ID, course ID, and enrolment date
VALUES(student,course,enrolmentdate);
END$$ -- End the procedure with the new delimiter
DELIMITER $$ -- End the procedure with the new delimiter



CALL Enrol(1, 2, '2024-01-15');


SELECT * FROM Enrolments;


-- Categorizes students into performance levels based on their grades
SELECT s.first_name,           -- Student's first name
       s.last_name,            -- Student's last name
       e.grade,                -- Grade from Enrolments table
       CASE
           WHEN e.grade = 'A+,A' THEN 'Excellent'          -- Grade A: Excellent performance
           WHEN e.grade = 'B' THEN 'Good'               -- Grade B: Good performance
           WHEN e.grade = 'C' THEN 'Average'            -- Grade C: Average performance
           WHEN e.grade = 'D' THEN 'Below Average'      -- Grade D: Below Average performance
           ELSE 'Needs Improvement'                    -- Any other grade: Needs Improvement
       END AS performance_category
FROM Enrolments e              -- Use Enrolments as the base table
JOIN Students s ON e.student_id = s.student_id;  -- Link Enrolments with Students
