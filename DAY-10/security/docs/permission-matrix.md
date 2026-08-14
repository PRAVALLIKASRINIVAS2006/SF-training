# Salesforce Security – Permission Matrix

## Overview

This document defines the planned object-level permissions for the Placement Management System.

The four primary user personas are:

- Student
- Placement Officer
- Recruiter
- Administrator

The permission matrix defines what each persona can **Create, Read, Edit, and Delete (CRED)** for the major Salesforce objects.

> These permissions represent the security design for the project. They should be validated against the actual Salesforce configuration and business requirements.

---

## 1. Student Permissions

Students should have enough access to manage their own placement activities while being restricted from sensitive placement operations.

| Object | Create | Read | Edit | Delete |
|---|:---:|:---:|:---:|:---:|
| Student Profile | No | Own | Limited | No |
| Job | No | Yes | No | No |
| Application | Yes | Own | Limited | No |
| Interview | No | Own | No | No |
| Placement | No | Own | No | No |
| Offer | No | Own | No | No |

### Student Can

- View their own profile.
- View available jobs.
- Apply for jobs.
- View their own applications.
- View their own placement information.

### Student Cannot

- View another student's application.
- Modify another student's records.
- Change selection decisions.
- Modify interview results.
- Modify offer status.
- Access confidential recruiter notes.
- Delete placement records.

---

## 2. Placement Officer Permissions

Placement Officers manage the placement process and therefore require broader access.

| Object | Create | Read | Edit | Delete |
|---|:---:|:---:|:---:|:---:|
| Student Profile | No | Yes | Limited | No |
| Job | Yes | Yes | Yes | Depends |
| Application | Yes | Yes | Yes | No |
| Interview | Yes | Yes | Yes | No |
| Placement | Yes | Yes | Yes | No |
| Offer | Yes | Yes | Yes | No |

### Placement Officer Can

- Create and manage jobs.
- Review student applications.
- Manage interviews.
- Update placement information.
- Review authorised student information.
- Manage appropriate placement workflows.

### Placement Officer Should Not Have

- Unnecessary system administration permissions.
- Unnecessary configuration access.
- Access to unrelated administrative information.

---

## 3. Recruiter Permissions

Recruiters should receive access according to their recruitment responsibilities.

| Object | Create | Read | Edit | Delete |
|---|:---:|:---:|:---:|:---:|
| Student Profile | No | Authorised | Limited | No |
| Job | Depends | Yes | Limited | No |
| Application | Depends | Authorised | Limited | No |
| Interview | Yes | Authorised | Yes | No |
| Placement | No | Authorised | No | No |
| Offer | No | Authorised | Limited | No |

### Recruiter Can

- View authorised candidates.
- View relevant application information.
- Participate in interview processes.
- Update authorised interview information.
- View recruitment-related information.

### Recruiter Cannot

- View unrelated candidate records.
- Modify placement decisions without authorisation.
- Access confidential internal information outside their responsibility.
- Delete applications or placement records.

---

## 4. Administrator Permissions

Administrators may require broad access to configure and maintain the Salesforce application.

| Object | Create | Read | Edit | Delete |
|---|:---:|:---:|:---:|:---:|
| Student Profile | Yes | Yes | Yes | Yes |
| Job | Yes | Yes | Yes | Yes |
| Application | Yes | Yes | Yes | Yes |
| Interview | Yes | Yes | Yes | Yes |
| Placement | Yes | Yes | Yes | Yes |
| Offer | Yes | Yes | Yes | Yes |

### Administrator Responsibilities

Administrators may manage:

- Users.
- Security configuration.
- Object configuration.
- Application data.
- Salesforce configuration.
- Integrations.
- System maintenance.

Administrator access should still follow the principle of least privilege whenever possible.

---

# 5. Complete Permission Matrix

| Persona | Object | Create | Read | Edit | Delete |
|---|---|:---:|:---:|:---:|:---:|
| Student | Student Profile | ❌ | Own | Limited | ❌ |
| Student | Job | ❌ | ✅ | ❌ | ❌ |
| Student | Application | ✅ | Own | Limited | ❌ |
| Student | Interview | ❌ | Own | ❌ | ❌ |
| Student | Placement | ❌ | Own | ❌ | ❌ |
| Student | Offer | ❌ | Own | ❌ | ❌ |
| Placement Officer | Student Profile | ❌ | ✅ | Limited | ❌ |
| Placement Officer | Job | ✅ | ✅ | ✅ | Depends |
| Placement Officer | Application | ✅ | ✅ | ✅ | ❌ |
| Placement Officer | Interview | ✅ | ✅ | ✅ | ❌ |
| Placement Officer | Placement | ✅ | ✅ | ✅ | ❌ |
| Placement Officer | Offer | ✅ | ✅ | ✅ | ❌ |
| Recruiter | Student Profile | ❌ | Authorised | Limited | ❌ |
| Recruiter | Job | Depends | ✅ | Limited | ❌ |
| Recruiter | Application | Depends | Authorised | Limited | ❌ |
| Recruiter | Interview | ✅ | Authorised | ✅ | ❌ |
| Recruiter | Placement | ❌ | Authorised | ❌ | ❌ |
| Recruiter | Offer | ❌ | Authorised | Limited | ❌ |
| Administrator | Student Profile | ✅ | ✅ | ✅ | ✅ |
| Administrator | Job | ✅ | ✅ | ✅ | ✅ |
| Administrator | Application | ✅ | ✅ | ✅ | ✅ |
| Administrator | Interview | ✅ | ✅ | ✅ | ✅ |
| Administrator | Placement | ✅ | ✅ | ✅ | ✅ |
| Administrator | Offer | ✅ | ✅ | ✅ | ✅ |

---

# 6. Understanding Object-Level Security

Create, Read, Edit, and Delete permissions represent object-level access.

For example:

```text
Student
   ↓
Application Object
   ↓
Read = Yes
