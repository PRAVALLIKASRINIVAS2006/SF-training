# Salesforce Security – Test Cases

## Overview

Security testing verifies that users can perform the actions required by their role while preventing unauthorised access to records, fields, and business operations.

The Placement Management System security testing covers:

- Object-level access
- Field-Level Security
- Record-level access
- Apex security
- LWC-to-Apex security
- Record ID manipulation
- Role-based access
- Sensitive data protection

---

# 1. Security Testing Objectives

The objectives of security testing are to verify that:

1. Students can access only their authorised information.
2. Placement Officers can manage placement-related records.
3. Recruiters can access only authorised candidate information.
4. Administrators can perform required administrative operations.
5. Sensitive fields are protected.
6. Users cannot access another user's records without authorisation.
7. Apex does not bypass record-level security.
8. Users cannot bypass security by manipulating Salesforce record IDs.
9. The UI is not the only security boundary.

---

# 2. User Personas

The following personas are used for testing:

| Persona | Main Responsibility |
|---|---|
| Student | Apply for jobs and track personal applications |
| Placement Officer | Manage students, applications, interviews and placements |
| Recruiter | Review authorised candidates and recruitment information |
| Administrator | Manage Salesforce configuration and system data |

---

# 3. Student Security Test Cases

## ST-001 – Student Views Own Application

### Objective

Verify that a Student can view their own Application.

### Preconditions

- Student user exists.
- Student has an Application record.

### Steps

1. Login as the Student.
2. Open the student's Application.
3. Review the record.

### Expected Result

The Student can view their own Application.

### Result

```text
[ ] Pass
[ ] Fail
