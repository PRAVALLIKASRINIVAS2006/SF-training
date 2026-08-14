# Salesforce Security – User Personas

## Overview

The Placement Management System contains four major user personas:

1. Student
2. Placement Officer
3. Recruiter
4. Administrator

Security decisions are based on what each persona needs to accomplish and what information they should or should not access.

---

## 1. Student

### Can Do

- View their own profile
- View eligible jobs
- Apply for jobs
- View their own applications
- Update appropriate profile information

### Cannot Do

- View another student's application
- Modify another student's profile
- Change Selection Status
- Change job eligibility rules
- Modify confidential recruiter information
- Delete another student's application

---

## 2. Placement Officer

### Can Do

- Create jobs
- Review applications
- Update interview results
- Manage placement information
- View student placement records
- Manage appropriate placement workflows

### Should Not Have

- Unnecessary system administration privileges
- Unrestricted access to unrelated configuration
- Permissions beyond placement responsibilities

---

## 3. Recruiter

### Can Do

- View candidates relevant to assigned jobs
- View authorised candidate information
- Update interview outcomes where authorised
- Add or manage recruiter information where appropriate

### Cannot Do

- View unrelated candidate information
- Access confidential information outside their responsibility
- Modify placement officer data
- Change information they are not authorised to change

---

## 4. Administrator

### Can Do

- Manage system configuration
- Manage users and security
- Manage Salesforce configuration
- Perform authorised administrative operations
- Manage integrations where required

### Security Principle

Administrator access should still follow the principle of least privilege.

Being an administrator should not mean that every user receives unrestricted access.

---

## Security Principle

Security design should begin with personas rather than Profiles.

The design process is:

```text
Who are the users?
        ↓
What must each user accomplish?
        ↓
What information does each task require?
        ↓
What should the user NOT access?
        ↓
Which Salesforce security layer should enforce it?
