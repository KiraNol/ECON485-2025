# ECON485 Homework 1 - Part 4: Constraints and History Discussions

## Part 4a: Constraints That Force a Student to Register for a Course

In the real registration system, several rules **force** students to take certain courses in a specific order or simultaneously:

1. **Prerequisites** ensure students have the necessary foundational knowledge before taking advanced courses. For example, a student must pass Calculus I before taking Calculus II.

2. **Co-requisites** require students to take two courses together in the same semester, typically when one is a lab or practical component of the other.

3. **Required chains** enforce strict sequencing (e.g., Programming I → Programming II → Data Structures).

**Database Support:**
- A `Prerequisite` table would be needed with columns: `course_code` (the course), `prereq_code` (required course), and `min_grade` (minimum passing grade).
- A `CoRequisite` table would store pairs of courses that must be taken together.
- The `Grade` table would track student performance to check if prerequisites are satisfied.

**Why not in simple system?** The simplified system in Part 2 has no rules, so these constraints and supporting tables are unnecessary.

## Part 4b: Constraints That Limit What Students Can Register For

The real system includes rules that **block** registrations under certain conditions:

1. **Time conflicts** prevent students from registering for overlapping sections.
2. **Credit limits** restrict the total ECTS credits per semester based on GPA.
3. **Mutually exclusive courses** block registration if content overlaps significantly.
4. **Withdrawal/failure rules** may block re-registration for previously failed courses.

**Database Support:**
- A `TimeSlot` table would store section schedules to detect overlaps.
- A `MutualExclusion` table would list course pairs that cannot both be taken for credit.
- The `Student` table would need a `current_credits` field to track semester load.
- A `RegistrationHistory` table would track past failures/withdrawals.

**Why removed?** These are "limiting" rules that add complexity. The simple system allows unlimited, unrestricted registration.

## Part 4c: The Requirement to Keep History

A real registration system must maintain a complete history of all actions for:

1. **Audit trails** – tracking who did what and when.
2. **Dispute resolution** – proving registration attempts, drops, or overrides.
3. **Analytics** – understanding registration patterns and system usage.
4. **Compliance** – meeting institutional or accreditation requirements.

**Database Support:**
- An `ActionLog` table would store: `log_id`, `user_id`, `action_type` (ADD/DROP/WITHDRAW), `timestamp`, `course_section`, and `details`.
- Related tables would need audit columns like `created_at`, `modified_by`.

**Increased Complexity:**
- Storage requirements grow significantly.
- Query performance may degrade with large log tables.
- Application logic must write to logs for every action.

**Why excluded?** The simple system focuses only on current state, not historical tracking, to keep design minimal and understandable.
