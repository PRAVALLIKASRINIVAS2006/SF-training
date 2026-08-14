# 🔐 Sprint 13 – Salesforce Security, Access Control, Sharing & Secure Apex

> **“A professional application does not merely decide what can be done. It decides who is allowed to do it.”**

This sprint focuses on understanding and applying **Salesforce security architecture** at a practical developer level.

The main objective was not simply to configure Profiles, Permission Sets, Sharing Rules, or Apex classes. The focus was on understanding **why each security layer exists, how the layers work together, and how to prevent unauthorised access even when users bypass the normal UI**.

---

## 📌 Sprint Overview

**Chapter:** 13 – Who Is Allowed to Do What?
**Sprint:** 13 – Salesforce Security, Access Control, Sharing and Secure Apex
**Domain:** Salesforce Development & Security
**Project Context:** Student Placement Management System

The Placement Management System contains multiple types of users:

* 👨‍🎓 Student
* 👨‍💼 Placement Officer
* 🏢 Recruiter
* 🛠️ Administrator

Each persona requires different permissions and access to different records and fields.

The central security principle explored throughout this sprint was:

> **UI Security ≠ Data Security**

Hiding a button, field, or component in an LWC does not secure the underlying data. Security must ultimately be enforced at the appropriate server and data layers.

---

# 🎯 Learning Objectives

By completing this sprint, I developed an understanding of:

* Salesforce's security model
* Authentication vs Authorisation
* Profiles
* Permission Sets
* Permission Set Groups
* Roles and Role Hierarchy
* Object-Level Security
* Field-Level Security (FLS)
* Record-Level Security
* Organization-Wide Defaults (OWD)
* Sharing Rules
* Record ownership
* `with sharing`
* `without sharing`
* `inherited sharing`
* CRUD permissions
* Field-Level Security
* User-mode and security-aware Apex
* Least-privilege security
* Secure LWC design
* Secure API and integration design
* Security testing
* Security auditing
* Secure Apex architecture

---

# 🧠 My Main Learning Approach

A major focus of this sprint was **understanding concepts rather than blindly completing configuration tasks**.

Instead of asking:

> “Which Profile should I create?”

I learned to ask:

> “Who are the users?”

Then:

1. What should each user accomplish?
2. What information does each task require?
3. What should the user be allowed to access?
4. What should the user **not** be allowed to access?
5. What happens if the user attempts to bypass the UI?
6. Which Salesforce security layer should enforce the restriction?

This helped me understand Salesforce security as an **architecture**, rather than a collection of isolated settings.

---

# 👥 User Personas

## 1. Student

### Allowed

* View their own profile
* View eligible jobs
* Apply for jobs
* View their own applications
* Update appropriate profile information

### Restricted

* Cannot view another student's application
* Cannot modify another student's profile
* Cannot change selection status
* Cannot change job eligibility rules
* Cannot modify confidential recruiter information

---

## 2. Placement Officer

### Allowed

* Create jobs
* Review applications
* Update interview results
* Manage placement information
* View student placement records
* Manage appropriate placement workflows

---

## 3. Recruiter

### Allowed

* View candidates relevant to assigned jobs
* Access authorised candidate information
* Update interview outcomes where authorised

### Restricted

* Cannot access unrelated confidential information
* Should only receive the candidate information required for their responsibilities

---

## 4. Administrator

Administrators may require broader privileges, but the sprint reinforced that:

> **Administrator does not automatically mean unlimited access should be granted to everyone.**

Administrative privileges should still follow the principle of **least privilege**.

---

# 🔑 Salesforce Security Model

A simplified model I learned is:

```text
                    USER
                      ↓
               Authentication
                      ↓
        ┌─────────────┴─────────────┐
        ↓                           ↓
 Object / Field Access        Record Access
        ↓                           ↓
Profile / Permission Sets     OWD / Roles /
                              Sharing Rules
        └─────────────┬─────────────┘
                      ↓
                Effective Access
```

Salesforce security works through multiple layers.

---

# 🧩 Three Levels of Access

One of the most important concepts from this sprint was understanding the difference between:

```text
OBJECT
   ↓
Can I access this type of record?

FIELD
   ↓
Can I access this particular information?

RECORD
   ↓
Can I access this specific record?
```

For example, a Student may have access to the `Application__c` object but should not necessarily have access to every Application record or every field on those records.

---

# 👤 Profiles

A **Profile** provides the baseline permissions and settings for a user.

It can control areas such as:

* Object permissions
* Field permissions
* System permissions
* App access
* Login-related settings

### Mental Model

```text
Profile = Baseline Access
```

The sprint also introduced the idea that modern Salesforce security design often keeps Profiles relatively minimal and uses Permission Sets to grant additional capabilities.

---

# 🧰 Permission Sets

Permission Sets provide **additional permissions** to users without requiring a completely new Profile.

### Mental Model

```text
Profile
   +
Permission Set
   +
Permission Set
   =
Effective Permissions
```

For example:

```text
Placement Officer
        +
Interview Management
        +
Offer Management
```

This approach is more flexible than creating multiple Profiles for every possible combination of permissions.

---

# 🏢 Roles and Role Hierarchy

Roles are different from Profiles and Permission Sets.

| Salesforce Feature | Main Purpose                                    |
| ------------------ | ----------------------------------------------- |
| Profile            | Baseline capabilities                           |
| Permission Set     | Additional capabilities                         |
| Role               | Record-access hierarchy and reporting structure |

Example:

```text
Placement Director
       ↓
Placement Manager
       ↓
Placement Officer
       ↓
Coordinator
```

The Role Hierarchy can influence record visibility depending on the sharing model.

---

# 🔒 Organization-Wide Defaults

**Organization-Wide Defaults (OWD)** establish the baseline level of record access.

For example:

```text
Application__c
       ↓
OWD = Private
```

A restrictive baseline can then be expanded through appropriate sharing mechanisms.

### Security Principle

> **Start restrictive, then grant what is required.**

Instead of giving everyone broad access and trying to remove unwanted access later, the system should begin with a secure baseline.

---

# 🤝 Sharing Rules

Sharing Rules extend record-level access when business requirements require it.

Example:

```text
Private by Default
        ↓
Business Requirement
        ↓
Sharing Rule
        ↓
Additional Record Access
```

Sharing Rules do **not** replace object permissions.

A user needs both appropriate object-level access and appropriate record-level access.

---

# 🛡️ Field-Level Security

Record access does not automatically mean every field should be visible.

For example, an Application may contain:

* Company
* Role
* Application Status
* Selection Status
* Recruiter Notes
* Internal Recommendation
* Confidential Comments

Students may need access to general application information but should not see confidential recruiter information.

### Security Model

```text
Application Record
       ↓
Student can access record
       ↓
Sensitive fields remain protected
```

This demonstrates why **record-level security and field-level security are separate concerns**.

---

# ⚙️ Secure Apex

A major focus of this sprint was understanding Apex sharing behaviour.

## `with sharing`

```apex
public with sharing class ApplicationService {
}
```

Conceptually, this indicates that record-sharing rules should be respected for the current context.

---

## `without sharing`

```apex
public without sharing class ApplicationService {
}
```

This does not enforce normal record-sharing behaviour in the same way.

It may be appropriate in carefully designed situations, but it should **never be used casually simply because it makes queries easier**.

---

## `inherited sharing`

```apex
public inherited sharing class ApplicationService {
}
```

This allows the sharing behaviour to be inherited from the calling context where applicable.

It can make sharing intent explicit in service-oriented designs.

---

## Important Security Insight

I learned not to simplify the concept as:

```text
with sharing = secure
without sharing = insecure
```

Real Salesforce security is layered.

Apex sharing behaviour is only one part of the security model.

Other layers include:

* Record sharing
* Object permissions
* Field permissions
* User context
* Apex execution mode
* Data exposure
* API exposure
* UI exposure

---

# 🔐 CRUD and FLS

## CRUD

CRUD represents:

* Create
* Read
* Update
* Delete

These operations relate to object-level access.

## FLS

FLS means **Field-Level Security**.

It determines whether a user can access particular fields.

Example:

A Student may be allowed to:

```text
Read Application
```

but should not be allowed to:

```text
Update Selection Status
```

---

# ⚠️ UI Security Is Not Data Security

One of the most important lessons from this sprint:

> **Never trust the client.**

A Lightning Web Component is not a security boundary.

The following are not sufficient by themselves:

* Hiding a button
* Hiding a field
* Disabling an input
* Removing a component
* Restricting navigation
* Checking permissions only in JavaScript

For example:

```text
Student
   ↓
LWC
   ↓
Button Hidden
```

does not guarantee security if:

```text
Student
   ↓
Direct Apex Call
   ↓
Unauthorized Operation
```

is still possible.

Important permissions must be enforced server-side.

---

# 🧑‍💻 Secure LWC Design

Suppose a Student should not see:

```text
Recruiter_Notes__c
```

Simply removing the field from the LWC HTML is not enough.

If Apex retrieves the sensitive field and sends it to the browser, the information may already have been exposed.

The safer architecture is:

```text
Security
   ↓
Server / Data Layer
   ↓
LWC
```

Not:

```text
LWC Hiding
   ↓
Security
```

---

# 🌐 Secure Integrations

External systems also require security controls.

For an integration user, I learned to ask:

* Who is calling?
* How are they authenticated?
* What objects can they access?
* What fields can they access?
* What data can they modify?
* Is elevated access actually required?
* Are credentials protected outside source code?

### Least Privilege

An integration user should receive only the permissions required for its legitimate responsibilities.

---

# 🧠 Principle of Least Privilege

The sprint reinforced:

> **Give a user or integration only the access required to perform its legitimate responsibilities.**

This applies to:

* Students
* Placement Officers
* Recruiters
* Administrators
* Integration Users

Broad permissions should not be granted merely because they make development easier.

---

# 🧪 Security Testing

Security testing is different from normal functional testing.

### Functional Test

> Can the student apply for a job?

### Security Test

> Can the wrong student apply?

The second question requires thinking about misuse and bypass scenarios.

---

# 🔍 Security Testing Matrix

| Scenario                                           | Expected Result |
| -------------------------------------------------- | --------------- |
| Student views own Application                      | ✅ Allowed       |
| Student views another student's Application        | ❌ Denied        |
| Student changes Selection Status                   | ❌ Denied        |
| Placement Officer reviews Application              | ✅ Allowed       |
| Recruiter views authorised candidate               | ✅ Allowed       |
| Recruiter views unrelated confidential information | ❌ Denied        |
| Student edits Recruiter Notes                      | ❌ Denied        |
| Student modifies another student's profile         | ❌ Denied        |
| Student calls Apex directly for restricted action  | ❌ Denied        |
| User changes a record Id to access another record  | ❌ Denied        |

---

# 🕵️ Think Like an Attacker

Instead of asking only:

> “How should a normal user use the application?”

I learned to ask:

> **“If I wanted to misuse this application, what would I try?”**

Potential attack scenarios include:

1. Changing a record Id
2. Calling Apex directly
3. Modifying request parameters
4. Accessing an unprotected field
5. Invoking an API directly
6. Trying another user's record
7. Guessing a record Id
8. Using a different UI
9. Attempting unauthorised updates
10. Using an over-privileged integration identity

---

# 🔗 The URL / Record ID Test

Suppose a Student has access to:

```text
Application A-1001
```

The Student changes the request to:

```text
Application A-1002
```

If `A-1002` belongs to another Student, Salesforce must still enforce the appropriate record-level security.

Therefore:

> **Knowing a Record Id must not automatically grant access to the record.**

---

# 🏗️ Security Architecture

The Placement Management System can be viewed conceptually as:

```text
                    USER
                      ↓
              Lightning Web UI
                      ↓
              Secure Apex Layer
                      ↓
              Business Services
                      ↓
       ┌──────────────┴──────────────┐
       ↓                             ↓
Salesforce Database           External Systems
       ↓                             ↓
Security Model               Secure Integration
```

The security model includes:

```text
Profile
   +
Permission Set
   +
Object Permissions
   +
Field Security
   +
OWD
   +
Ownership
   +
Role Hierarchy
   +
Sharing Rules
   +
Apex Sharing
   +
Server-Side Validation
```

---

# 📋 Security Model Deliverables

The sprint defines the following security artefacts for the project:

```text
docs/
└── security/
    ├── security-model.md
    ├── permission-matrix.md
    ├── sharing-model.md
    └── security-test-cases.md
```

These documents should capture:

### 1. Persona Matrix

Who uses the application and what responsibilities they have.

### 2. Object Permission Matrix

For each object:

* Create
* Read
* Edit
* Delete

### 3. Field Security Matrix

Identify sensitive fields and determine who can access them.

### 4. Record Sharing Model

Document:

* OWD
* Ownership
* Role Hierarchy
* Sharing Rules

### 5. Apex Security Review

For each service class, document:

* `with sharing`
* `without sharing`
* `inherited sharing`
* Reason for the chosen approach

### 6. Security Test Cases

Document attempts to access or modify unauthorised information.

---

# 🚩 Security Red Flags Reviewed

During the security review, the following patterns were identified as potential risks:

### Red Flag 1

Using `without sharing` without documented justification.

### Red Flag 2

Returning sensitive fields to every LWC.

### Red Flag 3

Performing critical validation only in JavaScript.

### Red Flag 4

Allowing Students to modify fields intended for Placement Officers.

### Red Flag 5

Accepting arbitrary record Ids without appropriate access checks.

### Red Flag 6

Storing integration credentials directly in source code.

### Red Flag 7

Granting broad permissions simply to make development easier.

### Red Flag 8

Allowing all users to access all records because it is easier.

---

# 🛠️ Mini Project – Secure Student Placement Portal

The security hardening exercise focused on the following requirements:

### Requirement 1

Students can view only their own Applications.

### Requirement 2

Students cannot change:

* Selection Status
* Interview Result
* Offer Status
* Recruiter Notes

### Requirement 3

Placement Officers can manage placement workflows.

### Requirement 4

Recruiters can access only authorised candidate information.

### Requirement 5

Sensitive fields are protected.

### Requirement 6

Apex services have explicit sharing intent.

### Requirement 7

Integration credentials remain outside source code.

### Requirement 8

Unauthorised access attempts are tested and documented.

---

# ✅ Definition of Done

* [ ] Object permissions reviewed
* [ ] Field permissions reviewed
* [ ] Record ownership model documented
* [ ] OWD model documented
* [ ] Role hierarchy considered
* [ ] Sharing Rules considered
* [ ] Apex sharing behaviour reviewed
* [ ] Student access tested
* [ ] Placement Officer access tested
* [ ] Recruiter access tested
* [ ] Attempts to access another student's data tested
* [ ] Sensitive field access tested
* [ ] Direct Apex access tested
* [ ] Record Id manipulation tested
* [ ] Integration permissions reviewed

---

# 💡 Key Takeaways

This sprint changed my understanding of Salesforce security from simply configuring permissions to designing a **complete security architecture**.

The major concepts I learned were:

### 1. Security starts with personas

First identify:

```text
Who is the user?
What should they do?
What should they see?
What should they never access?
```

### 2. Security is layered

```text
Object
   ↓
Field
   ↓
Record
```

All three levels must be considered.

### 3. Profiles and Permission Sets are different

```text
Profile = Baseline
Permission Set = Additional Capability
Role = Record Hierarchy
```

### 4. OWD establishes the baseline

A restrictive baseline can be expanded using appropriate sharing mechanisms.

### 5. Sharing is only one layer

`with sharing` does not automatically solve CRUD, FLS, API exposure, or every other security concern.

### 6. Never trust the client

The LWC is not the final security boundary.

### 7. Least privilege matters

Users and integrations should receive only the access they actually require.

### 8. Security must be tested

It is not enough to test whether authorised users can perform an operation.

We must also test whether **unauthorised users can bypass it**.

---

# 🎤 Interview Preparation

This sprint prepared me to explain questions such as:

### What is the difference between Profile and Permission Set?

A Profile provides baseline permissions, while Permission Sets provide additional capabilities without requiring another Profile.

### What is the purpose of a Role?

Roles primarily participate in record-access hierarchy and reporting structure.

### What are OWD?

Organization-Wide Defaults define the baseline record-level access for an object.

### What is a Sharing Rule?

A Sharing Rule extends record-level access based on defined business conditions or ownership/group relationships.

### What is the difference between Object, Field and Record security?

```text
Object → Can I access this type of record?

Field → Can I access this particular information?

Record → Can I access this particular instance?
```

### Why is hiding a field in an LWC not enough?

Because the browser is controlled by the user. If sensitive data is already returned by Apex, hiding it in the UI does not protect the data.

### What is least privilege?

Giving users and integrations only the permissions required for their legitimate responsibilities.

---

# 📚 Security Mindset

The most important lesson from this sprint is:

> **A feature is not complete until its security behaviour is defined.**

For every feature, I should be able to answer:

```text
Who can use it?
       ↓
What can they see?
       ↓
What can they change?
       ↓
What must they never access?
       ↓
What happens if they try to bypass the UI?
```

---

# 🚀 Sprint Outcome

After this sprint, my Placement Management System security model progressed from simply controlling visible functionality to considering:

```text
User Personas
      ↓
Profiles
      ↓
Permission Sets
      ↓
Object Permissions
      ↓
Field-Level Security
      ↓
OWD
      ↓
Ownership
      ↓
Role Hierarchy
      ↓
Sharing Rules
      ↓
Apex Sharing Behaviour
      ↓
Server-Side Security
      ↓
LWC / API Protection
      ↓
Security Testing
```

The key lesson is:

> **Security is not one Salesforce feature. It is an architecture.**

---

# 🏁 Sprint 13 Conclusion

This sprint helped me understand that building a Salesforce application is not only about making functionality work.

A professional Salesforce developer must also understand:

* Who is allowed to perform an action
* What data they are allowed to see
* What data they are allowed to modify
* How records are shared
* How sensitive fields are protected
* How Apex handles security
* How APIs and integrations are secured
* How unauthorised access is tested

The strongest mindset I developed from this sprint is:

> **Do not ask only: “Can I make this work?”**

Instead ask:

> **“Who should be able to make this work?”**

And then:

> **“What should happen if somebody who is not authorised tries?”**

That is where professional Salesforce security thinking begins.

---

## 🛠️ Technologies & Concepts

`Salesforce` `Apex` `Lightning Web Components` `SOQL` `DML` `CRUD` `FLS` `OWD` `Profiles` `Permission Sets` `Roles` `Role Hierarchy` `Sharing Rules` `Secure Apex` `User Mode` `APIs` `Integration Security` `Least Privilege`

---

## 📁 Suggested Repository Structure

```text
Sprint-13-Salesforce-Security/
│
├── README.md
│
├── force-app/
│   └── main/
│       └── default/
│
├── docs/
│   └── security/
│       ├── security-model.md
│       ├── permission-matrix.md
│       ├── sharing-model.md
│       └── security-test-cases.md
│
└── screenshots/
    └── security-evidence/
```

---

## 👩‍💻 Learning Philosophy

> **I focused on understanding the reason behind Salesforce security decisions rather than simply completing configuration steps.**

This sprint strengthened my ability to think about Salesforce applications from the perspective of both a **developer and a security engineer**.

The goal was not just to build a system that works.

The goal was to build a system where:

> **The right user can do the right thing with the right data — and the wrong user cannot bypass the rules.**
