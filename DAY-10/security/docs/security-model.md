# Salesforce Security – Permission Matrix

## Overview

This document defines the planned object-level permissions for the Placement Management System.

The purpose of the permission matrix is to identify what each user persona can do with Salesforce objects.

The four primary personas are:

- Student
- Placement Officer
- Recruiter
- Administrator

> These permissions represent the security design for the project. Actual Salesforce permissions should be configured and tested against this matrix.

---

## 1. Student Permissions

Students should have enough access to manage their own placement activities while being restricted from modifying sensitive placement information.

| Object | Create | Read | Edit | Delete |
|---|:---:|:---:|:---:|:---:|
| Student Profile | No | Own | Limited | No |
| Job | No | Yes | No | No |
| Application | Yes | Own | Limited | No |
| Interview | No | Own | No | No |
| Placement | No | Own | No | No |
| Offer | No | Own | No | No |

### Student Security Rules

Students should:

- View their own profile.
- View available jobs.
- Create job applications.
- View their own applications.
- View authorised placement information.

Students should not:

- View another student's applications.
- Modify another student's records.
- Change selection decisions.
- Modify interview results.
- Modify offer status.
- View confidential recruiter notes.
- Delete placement records.

---

# 2. Placement Officer Permissions

Placement Officers manage the placement process and therefore require broader access than Students.

| Object | Create | Read | Edit | Delete |
|---|:---:|:---:|:---:|:---:|
| Student Profile | No | Yes | Limited | No |
| Job | Yes | Yes | Yes | Depends |
| Application | Yes | Yes | Yes | No |
| Interview | Yes | Yes | Yes | No |
| Placement | Yes | Yes | Yes | No |
| Offer | Yes | Yes | Yes | No |

### Placement Officer Security Rules

Placement Officers should be able to:

- Manage job information.
- Review student applications.
- Manage interview information.
- Update placement status.
- Review authorised student information.
- Manage appropriate placement workflows.

Placement Officers should not automatically receive:

- Salesforce system administration permissions.
- Unnecessary configuration access.
- Access to unrelated administrative data.

---

# 3. Recruiter Permissions

Recruiters should receive access related to their recruitment responsibilities.

| Object | Create | Read | Edit | Delete |
|---|:---:|:---:|:---:|:---:|
| Student Profile | No | Authorised | Limited | No |
| Job | Depends | Yes | Limited | No |
| Application | Depends | Authorised | Limited | No |
| Interview | Yes | Authorised | Yes | No |
| Placement | No | Authorised | No | No |
| Offer | No | Authorised | Limited | No |

### Recruiter Security Rules

Recruiters should be able to:

- View candidates relevant to their jobs.
- Review authorised application information.
- Participate in interview processes.
- Update authorised interview information.

Recruiters should not:

- View unrelated candidate records.
- Modify placement decisions without authorisation.
- Access confidential internal information outside their responsibility.
- Delete Applications or Placement records.

---

# 4. Administrator Permissions

Administrators may require broad access to configure and maintain the Salesforce application.

| Object | Create | Read | Edit | Delete |
|---|:---:|:---:|:---:|:---:|
| Student Profile | Yes | Yes | Yes | Yes |
| Job | Yes | Yes | Yes | Yes |
| Application | Yes | Yes | Yes | Yes |
| Interview | Yes | Yes | Yes | Yes |
| Placement | Yes | Yes | Yes | Yes |
| Offer | Yes | Yes | Yes | Yes |

### Administrator Security Rules

Administrators may be responsible for:

- User management.
- Security configuration.
- Object configuration.
- Data management.
- Application maintenance.
- Integration configuration.
- Troubleshooting.

Even administrators should follow the principle of least privilege where possible.

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

The Create, Read, Edit, and Delete permissions above represent **object-level access**.

For example:

```text
Student
   ↓
Application Object
   ↓
Read = Yes
