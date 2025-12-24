# Homework 2 - Part 2: Extended Design with Prerequisites

## Updated ER Diagram with Prerequisite Support

```mermaid
erDiagram
    STUDENT {
        int student_id PK
        string name
        string email
        string status
    }
    
    COURSE {
        string course_code PK
        string course_name
        int credits
        string department
    }
    
    INSTRUCTOR {
        int instructor_id PK
        string name
        string department
        string email
    }
    
    SECTION {
        int section_id PK
        string course_code FK
        int instructor_id FK
        string schedule
        string classroom
        int max_capacity
    }
    
    REGISTRATION {
        int registration_id PK
        int student_id FK
        int section_id FK
        date registration_date
    }
    
    PREREQUISITE {
        int prerequisite_id PK
        string course_code FK
        string required_course_code FK
        string minimum_grade
    }
    
    GRADE {
        int grade_id PK
        int student_id FK
        string course_code FK
        string grade
        date completion_date
    }
    
    STUDENT ||--o{ REGISTRATION : "has"
    REGISTRATION }o--|| SECTION : "for"
    COURSE ||--o{ SECTION : "offers"
    INSTRUCTOR ||--o{ SECTION : "teaches"
    COURSE ||--o{ PREREQUISITE : "requires"
    STUDENT ||--o{ GRADE : "receives"
    COURSE ||--o{ GRADE : "graded_in"
```

## New Tables Added:

### 1. Prerequisite Table
| Column Name | Data Type | Description | Constraint |
|-------------|-----------|-------------|------------|
| prerequisite_id | INT | Unique identifier | PRIMARY KEY |
| course_code | VARCHAR(10) | Course that has prerequisite | FOREIGN KEY (Course) |
| required_course_code | VARCHAR(10) | Required prerequisite course | FOREIGN KEY (Course) |
| minimum_grade | VARCHAR(2) | Minimum passing grade (e.g., 'C') | |

### 2. Grade Table
| Column Name | Data Type | Description | Constraint |
|-------------|-----------|-------------|------------|
| grade_id | INT | Unique identifier | PRIMARY KEY |
| student_id | INT | Student who received grade | FOREIGN KEY (Student) |
| course_code | VARCHAR(10) | Course for which grade is given | FOREIGN KEY (Course) |
| grade | VARCHAR(2) | Grade received (A, B, C, D, F, W) | |
| completion_date | DATE | Date course was completed | |

## Relationships:
1. **Course → Prerequisite**: One course can have multiple prerequisites
2. **Student → Grade**: One student can have multiple grades
3. **Course → Grade**: One course can have multiple grade records
