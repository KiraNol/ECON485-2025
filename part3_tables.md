# ECON485 Homework 1 - Part 3a: Database Tables (2NF Design)

## 1. Student Table
| Column Name | Data Type | Description | Constraint |
|-------------|-----------|-------------|------------|
| student_id | INT | Unique student identifier | PRIMARY KEY |
| name | VARCHAR(100) | Full name of student | NOT NULL |
| email | VARCHAR(100) | Student email address | UNIQUE |
| status | VARCHAR(20) | Active/Inactive status | DEFAULT 'Active' |

## 2. Course Table
| Column Name | Data Type | Description | Constraint |
|-------------|-----------|-------------|------------|
| course_code | VARCHAR(10) | Course code (e.g., ECON211) | PRIMARY KEY |
| course_name | VARCHAR(200) | Course title | NOT NULL |
| credits | INT | Credit value | NOT NULL |
| department | VARCHAR(50) | Offering department | |

## 3. Instructor Table
| Column Name | Data Type | Description | Constraint |
|-------------|-----------|-------------|------------|
| instructor_id | INT | Unique instructor identifier | PRIMARY KEY |
| name | VARCHAR(100) | Full name of instructor | NOT NULL |
| department | VARCHAR(50) | Academic department | |
| email | VARCHAR(100) | Instructor email | UNIQUE |

## 4. Section Table
| Column Name | Data Type | Description | Constraint |
|-------------|-----------|-------------|------------|
| section_id | INT | Unique section identifier | PRIMARY KEY |
| course_code | VARCHAR(10) | Course this section belongs to | FOREIGN KEY (Course) |
| instructor_id | INT | Instructor teaching this section | FOREIGN KEY (Instructor) |
| schedule | VARCHAR(50) | Meeting days and times | |
| classroom | VARCHAR(20) | Room number or online link | |
| max_capacity | INT | Maximum number of students | |

## 5. Registration Table
| Column Name | Data Type | Description | Constraint |
|-------------|-----------|-------------|------------|
| registration_id | INT | Unique registration record | PRIMARY KEY |
| student_id | INT | Student who is registering | FOREIGN KEY (Student) |
| section_id | INT | Section being registered for | FOREIGN KEY (Section) |
| registration_date | DATE | Date of registration | DEFAULT CURRENT_DATE |

---

*Note: All tables are in 2NF (Second Normal Form) with no repeating groups and no partial dependencies.*
