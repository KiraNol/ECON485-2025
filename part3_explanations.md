# ECON485 Homework 1 - Part 3b: Design Explanations

## 1. Primary Key Choices
- **student_id, instructor_id, section_id, registration_id** are integers (INT) because they are sequential, unique, and efficient for database indexing.
- **course_code** is VARCHAR(10) because course codes follow a specific alphanumeric format (e.g., "ECON211", "MATH101").

## 2. Foreign Key Choices
- **section.course_code** references **course.course_code** to ensure every section belongs to a valid, existing course.
- **section.instructor_id** references **instructor.instructor_id** to link each section with its teaching instructor.
- **registration.student_id** references **student.student_id** to track which student made the registration.
- **registration.section_id** references **section.section_id** to track which section the student registered for.

## 3. Table Connections and Relationships
- The **Registration** table serves as a **junction table** between Student and Section, resolving the many-to-many (N:M) relationship.
- **Section** connects two main entities: Course (what is taught) and Instructor (who teaches it).
- **Course → Section** is a one-to-many relationship: one course can have multiple sections in a semester.
- **Instructor → Section** is also one-to-many: one instructor can teach multiple sections.

## 4. N:M Relationship Solution
- The relationship between **Student** and **Section** is N:M:
  - One student can register for multiple sections.
  - One section can have multiple students registered.
- This is solved using the **Registration** table with:
  - **student_id** (FK to Student)
  - **section_id** (FK to Section)
  - **registration_id** as the primary key for each enrollment record.

## 5. 2NF Compliance
All tables satisfy Second Normal Form (2NF) because:
1. **No repeating groups:** Each column contains atomic values.
2. **No partial dependencies:** All non-key columns depend on the **entire primary key**.
   - Example: In Registration table, all columns depend on registration_id (not just student_id or section_id).
3. **Proper primary keys:** Each table has a single-column primary key where possible.
4. **Foreign keys correctly reference primary keys** in related tables.

## 6. Design Decisions
- Added **status** column to Student table to track active/inactive status (for future rule implementations).
- Used **VARCHAR** for text fields with appropriate lengths to balance storage and flexibility.
- Included **max_capacity** in Section table for enrollment limits (scalability).
- Added **registration_date** with DEFAULT CURRENT_DATE for automatic timestamping.
