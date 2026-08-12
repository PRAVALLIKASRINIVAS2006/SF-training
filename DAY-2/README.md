# 🚀 Sprint 5 – Data Operations with SOQL & DML

> **“Data is the foundation of every business decision. Effective applications know how to find it, use it, and update it.”**

## 📖 Sprint Overview

**Sprint 5** takes the Placement Management System from business-rule design into actual **Salesforce data interaction**.

In the previous sprint, the focus was on identifying business requirements and organizing application responsibilities. This sprint builds on that foundation by teaching Apex how to communicate with Salesforce data.

The application now learns to:

* Retrieve information from Salesforce.
* Filter and work with specific records.
* Use retrieved information in business decisions.
* Create new records.
* Modify existing records.
* Remove and restore records.
* Insert or update records using `upsert`.
* Structure data operations with future scalability in mind.

The two primary concepts covered are:

**SOQL** → Retrieve Salesforce data
**DML** → Change Salesforce data

---

# 🎯 Sprint Goal

The goal of this sprint is to understand how an Apex application interacts with Salesforce data throughout a business process.

```text
Business Requirement
        ↓
Identify Required Data
        ↓
Retrieve Data with SOQL
        ↓
Apply Business Rules
        ↓
Create / Modify Records
        ↓
Save Changes with DML
```

The important lesson is that **data access is part of application design**, not simply a collection of database commands.

---

# 📚 Learning Outcomes

By the end of this sprint, I was able to:

* Explain the purpose of SOQL.
* Retrieve Salesforce records using Apex.
* Select specific fields from Salesforce objects.
* Filter records using conditions.
* Use Apex variables inside SOQL queries.
* Understand common DML operations.
* Create Salesforce records programmatically.
* Update existing records.
* Delete and restore records.
* Use `upsert` for flexible record management.
* Connect retrieved data with business logic.
* Understand why inefficient SOQL and DML can cause governor-limit problems.
* Prepare data-access logic for future bulk processing.

---

# 🏢 Project Context

The project continues to use a **Placement Management System** as the real-world business scenario.

The system manages information related to:

```text
Students
   │
   ├── Academic Information
   ├── Branch
   ├── CGPA
   └── Placement Status

Jobs
   │
   ├── Job Title
   ├── Eligibility Criteria
   ├── Required CGPA
   └── Application Deadline

Applications
   │
   ├── Student
   ├── Job
   ├── Application Date
   └── Application Status
```

When a student applies for a job, the application needs information from these records before it can make a decision.

---

# 🔄 Application Data Flow

A typical application process looks like this:

```text
Student Application Request
            ↓
       Find Student
            ↓
         SOQL
            ↓
    Find Job Requirements
            ↓
         SOQL
            ↓
    Evaluate Eligibility
            ↓
     Create Application
            ↓
          DML
            ↓
     Salesforce Database
```

This demonstrates the relationship between **data retrieval, business logic, and data modification**.

---

# 🔎 Part 1 – Querying Salesforce with SOQL

## What is SOQL?

**SOQL (Salesforce Object Query Language)** is Salesforce's query language for retrieving records from objects.

It allows developers to define:

* The object being queried
* The fields required
* The records to retrieve
* Filtering conditions
* Sorting and other query requirements

A basic query follows this structure:

```apex
SELECT Field1, Field2
FROM ObjectName
WHERE Condition
```

---

# 🎓 Example – Retrieving Student Information

Suppose the application needs to retrieve a student's academic details.

```apex
Student__c student = [
    SELECT Id, Name, CGPA__c, Branch__c
    FROM Student__c
    WHERE Id = :studentId
];
```

The query retrieves only the information needed for the current operation.

### Query Breakdown

| Element           | Purpose                      |
| ----------------- | ---------------------------- |
| `SELECT`          | Specifies fields to retrieve |
| `Name`            | Student name                 |
| `CGPA__c`         | Academic score               |
| `Branch__c`       | Student branch               |
| `FROM Student__c` | Specifies the object         |
| `WHERE`           | Filters records              |
| `:studentId`      | Apex bind variable           |

---

# 🎯 Filtering Records

SOQL can be used to retrieve records matching a particular business condition.

For example:

```apex
List<Student__c> eligibleStudents = [
    SELECT Id, Name, CGPA__c
    FROM Student__c
    WHERE CGPA__c >= 7.0
];
```

This query retrieves students whose CGPA meets the specified threshold.

The important point is that the query retrieves the **information**, while the application can then use that information to perform additional business processing.

---

# 🔗 Using Apex Variables in SOQL

Apex variables can be referenced inside SOQL using the `:` bind syntax.

```apex
Id studentId = someStudentId;

Student__c student = [
    SELECT Id, Name, CGPA__c
    FROM Student__c
    WHERE Id = :studentId
];
```

This allows the query to work dynamically with values supplied by the application.

---

# 🎯 Query Only What Is Required

Efficient Salesforce development means avoiding unnecessary data retrieval.

Instead of retrieving many fields:

```apex
SELECT Id, Name, CGPA__c, Branch__c, Graduation_Year__c,
       Phone__c, Email__c
FROM Student__c
WHERE Id = :studentId
```

if the application only needs CGPA and branch, it can use:

```apex
SELECT Id, CGPA__c, Branch__c
FROM Student__c
WHERE Id = :studentId
```

This keeps the query focused and helps reduce unnecessary resource consumption.

---

# ✏️ Part 2 – Changing Salesforce Data with DML

## What is DML?

**DML (Data Manipulation Language)** is used by Apex to perform operations that modify Salesforce records.

Common operations include:

```text
insert
update
delete
undelete
upsert
merge
```

These operations allow Apex to interact with Salesforce data beyond simply reading it.

---

# 📋 DML Operations

| Operation  | Purpose                     |
| ---------- | --------------------------- |
| `insert`   | Creates a new record        |
| `update`   | Changes an existing record  |
| `delete`   | Removes a record            |
| `undelete` | Restores a deleted record   |
| `upsert`   | Inserts or updates a record |
| `merge`    | Combines duplicate records  |

---

# ➕ Creating a Student Record

A new Salesforce record can be created using `insert`.

```apex
Student__c student = new Student__c();

student.Name = 'Rahul';
student.CGPA__c = 8.6;
student.Branch__c = 'Computer Science';

insert student;
```

After the successful operation, Salesforce assigns an `Id` to the newly created record.

---

# ✏️ Updating a Record

An existing record can be retrieved, modified, and saved.

```apex
Student__c student = [
    SELECT Id, CGPA__c
    FROM Student__c
    LIMIT 1
];

student.CGPA__c = 9.0;

update student;
```

The process is:

```text
Retrieve
   ↓
Modify
   ↓
Update
```

This is one of the most common SOQL + DML workflows in Apex.

---

# 🗑️ Removing a Record

A record can be deleted using:

```apex
delete student;
```

Salesforce generally moves the deleted record to the Recycle Bin rather than permanently removing it immediately.

---

# ♻️ Restoring a Record

A deleted record can be restored using:

```apex
undelete student;
```

This can be useful when records are removed accidentally or need to be restored as part of an application process.

---

# 🔄 Using Upsert

`upsert` is useful when the application does not want to handle insert and update as two completely separate operations.

```apex
upsert student;
```

Conceptually:

```text
           Record
              ↓
       Does it already exist?
          /            \
        Yes             No
         ↓               ↓
      Update           Insert
```

This is particularly useful in scenarios involving data synchronization.

---

# 🏗️ Complete Placement Application Example

SOQL and DML become more useful when combined with the business logic from Sprint 4.

## Step 1 – Retrieve Student

```apex
Student__c student = [
    SELECT Id, CGPA__c, Branch__c
    FROM Student__c
    WHERE Id = :studentId
];
```

## Step 2 – Retrieve Job

```apex
Job__c job = [
    SELECT Id, Required_CGPA__c, Eligible_Branch__c
    FROM Job__c
    WHERE Id = :jobId
];
```

## Step 3 – Evaluate Eligibility

```apex
Boolean eligible =
    student.CGPA__c >= job.Required_CGPA__c;
```

Additional rules can be added for:

* Branch
* Graduation year
* Backlogs
* Application deadline
* Placement status

## Step 4 – Create the Application

```apex
Application__c application =
    new Application__c();

application.Student__c = student.Id;
application.Job__c = job.Id;
application.Status__c = 'Applied';

insert application;
```

The complete process becomes:

```text
┌───────────────────┐
│ Student Request   │
└─────────┬─────────┘
          ↓
┌───────────────────┐
│ Retrieve Student  │
│      SOQL         │
└─────────┬─────────┘
          ↓
┌───────────────────┐
│ Retrieve Job      │
│      SOQL         │
└─────────┬─────────┘
          ↓
┌───────────────────┐
│ Business Rules    │
│ Eligibility Check │
└─────────┬─────────┘
          ↓
┌───────────────────┐
│ Create Application│
│       DML         │
└─────────┬─────────┘
          ↓
┌───────────────────┐
│ Salesforce Data   │
└───────────────────┘
```

---

# 🧠 Data Retrieval vs Business Logic

A key concept from this sprint is that **SOQL and business logic have different responsibilities**.

### SOQL

Answers:

> “What information do we have?”

### Business Logic

Answers:

> “What should we do with that information?”

### DML

Answers:

> “How do we save the result?”

Therefore:

```text
SOQL
 ↓
Get Information
 ↓
Business Logic
 ↓
Make Decision
 ↓
DML
 ↓
Save Result
```

This separation provides a clean foundation for future Apex architecture.

---

# ⚠️ Writing Efficient Apex

SOQL and DML are governed by Salesforce platform limits.

Therefore, developers should avoid inefficient database operations.

## ❌ Query Inside a Loop

```apex
for (Application__c app : applications) {

    Student__c student = [
        SELECT Id, CGPA__c
        FROM Student__c
        WHERE Id = :app.Student__c
    ];

}
```

This approach can generate a large number of SOQL queries.

## ❌ DML Inside a Loop

```apex
for (Application__c app : applications) {
    update app;
}
```

Repeated DML operations can also consume governor-limit resources.

These problems become the central focus of the later **Bulk Processing & Governor Limits** sprint.

---

# 🏛️ Data Service Layer

The service classes introduced in Sprint 4 can now begin handling data operations.

```text
ApplicationService
        │
        ├── Retrieve Student
        │       ↓
        │      SOQL
        │
        ├── Retrieve Job
        │       ↓
        │      SOQL
        │
        └── Save Application
                ↓
               DML
```

Example:

```apex
public class ApplicationService {

    public static void submitApplication(
        Id studentId,
        Id jobId
    ) {

        // Retrieve data
        // Apply business rules
        // Create application
        // Perform DML

    }
}
```

This provides a foundation for the Trigger Handler and Service Layer architecture introduced in later sprints.

---

# 📂 Project Structure

```text
force-app/
│
└── main/
    └── default/
        │
        ├── classes/
        │   ├── StudentService.cls
        │   ├── JobService.cls
        │   └── ApplicationService.cls
        │
        └── objects/
            ├── Student__c/
            ├── Job__c/
            └── Application__c/
```

---

# 🧪 Sprint Practice

## SOQL Practice

* Retrieve a student using an Id.
* Find students above a specific CGPA.
* Filter students by branch.
* Retrieve job eligibility requirements.
* Retrieve existing applications.
* Use Apex bind variables.
* Select only required fields.

## DML Practice

* Insert a new Student record.
* Update student information.
* Create a Job record.
* Modify an existing Job.
* Create an Application record.
* Delete a record.
* Restore a deleted record.
* Experiment with `upsert`.

---

# 📊 SOQL vs DML

| Category         | SOQL           | DML                |
| ---------------- | -------------- | ------------------ |
| Main Purpose     | Retrieve data  | Modify data        |
| Reads Records    | ✅              | ❌                  |
| Creates Records  | ❌              | ✅                  |
| Updates Records  | ❌              | ✅                  |
| Deletes Records  | ❌              | ✅                  |
| Restores Records | ❌              | ✅                  |
| Example          | `SELECT`       | `insert`, `update` |
| Primary Role     | Data retrieval | Data modification  |

### Easy way to remember:

```text
SOQL = Read

DML = Change
```

---

# 💡 Engineering Lessons

### 1. Data Drives Decisions

Business logic cannot make reliable decisions without the required information.

### 2. Retrieve Only What You Need

Focused queries are easier to understand and more efficient.

### 3. Keep Responsibilities Separate

Data retrieval, business rules, and data modification should have clear roles.

### 4. Database Operations Need Careful Design

Every SOQL query and DML operation consumes platform resources.

### 5. Think About Scale Early

Even simple Apex should be written with future bulk-processing requirements in mind.

---

# 🎤 Interview Preparation

Questions covered by this sprint include:

1. What is SOQL?
2. What is the difference between SOQL and SQL?
3. What is DML?
4. What are the different DML operations?
5. What is the difference between `insert` and `upsert`?
6. What is a bind variable?
7. Why should developers retrieve only required fields?
8. Why should SOQL not be placed inside loops?
9. Why should DML not be placed inside loops?
10. How do SOQL and DML work together?
11. How would you retrieve a student's eligibility information?
12. How would you create an application record using Apex?
13. What happens when a DML operation encounters an error?
14. How can SOQL and DML be optimized for bulk processing?

---

# 🛠️ Technologies Used

* **Salesforce Platform**
* **Apex**
* **SOQL**
* **DML**
* **Salesforce Custom Objects**
* **Salesforce Developer Console**
* **Visual Studio Code**
* **Salesforce CLI**

---

# 🚀 Next Stage

The concepts introduced in this sprint prepare the Placement Management System for **Apex Triggers**.

The next development stage will move from manually executing business operations to **event-driven automation**.

```text
Data Operation
      ↓
Record Event
      ↓
Apex Trigger
      ↓
Business Logic
      ↓
Automatic Action
```

After that, the project will progress toward:

```text
SOQL & DML
    ↓
Apex Triggers
    ↓
Bulk Processing
    ↓
Governor Limits
    ↓
Asynchronous Apex
```

---

# 📈 Key Takeaways

Sprint 5 introduced the application's **data-access layer**.

The major lessons are:

* SOQL allows Apex to retrieve Salesforce information.
* DML allows Apex to modify Salesforce records.
* Retrieved information can be passed into business logic.
* Business decisions should be based on relevant and current data.
* Database operations should be efficient and intentional.
* Service classes provide a useful place for organizing data operations.
* Bulk-safe development should be considered from the beginning.

---

# 👩‍💻 Author

## Penumarthi Pravallika

**Computer Science Student | Salesforce Developer**

### Technical Skills

`Salesforce` · `Apex` · `LWC` · `SOQL` · `DML` · `Java` · `Python`

### Areas of Interest

* Salesforce Development
* Apex Programming
* Lightning Web Components
* SOQL & DML
* Salesforce Automation
* Backend Development
* Enterprise Application Development

---

# ⭐ Sprint Summary

Sprint 5 moves the Placement Management System from **business-rule design to real data interaction**.

The application can now follow a complete data-driven process:

```text
Identify Requirement
        ↓
Retrieve Salesforce Data
        ↓
Process Business Rules
        ↓
Create / Modify Records
        ↓
Persist the Result
```

> **“The quality of an application depends not only on the decisions it makes, but also on how efficiently it retrieves and manages the information behind those decisions.”**
