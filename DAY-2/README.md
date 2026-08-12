# 🚀 Sprint 5 – Working with Salesforce Data Using SOQL and DML

> **“Good applications do not make decisions without information. They retrieve the right data, process it, and then update the system.”**

## 📖 About This Sprint

**Sprint 5 – Retrieving and Managing Information with SOQL and DML** focuses on one of the most important aspects of Salesforce development: **working with data through Apex**.

An application becomes useful only when it can interact with the information stored inside the platform. In a Salesforce-based Placement Management System, the application needs to retrieve student information, evaluate job requirements, create applications, and update records as the placement process progresses.

This sprint introduces two fundamental technologies used for interacting with Salesforce data:

* **SOQL – Salesforce Object Query Language**
* **DML – Data Manipulation Language**

The sprint demonstrates how these technologies work together to support a complete business workflow.

---

# 🎯 Sprint Objective

The objective of this sprint is to understand the complete data-processing cycle in an Apex application:

```text
Salesforce Data
      ↓
Retrieve Required Information
      ↓
Process Business Rules
      ↓
Create / Modify Records
      ↓
Save Updated Information
```

The focus is not simply on learning query syntax or DML commands, but on understanding **when and why data should be retrieved and modified**.

---

# 📚 Learning Objectives

By completing this sprint, I learned how to:

* Understand the role of data in enterprise applications.
* Retrieve Salesforce records using SOQL.
* Select only the fields required by the application.
* Filter records using SOQL conditions.
* Use Apex variables with SOQL queries.
* Create Salesforce records using DML.
* Modify existing records using DML.
* Delete and restore records.
* Use `upsert` for insert-or-update scenarios.
* Understand the relationship between data retrieval and business logic.
* Build reusable Apex code for Salesforce data operations.

---

# 🏢 Business Scenario – Placement Management System

The project continues the development of a **Placement Management System**.

Consider a student applying for a company.

The application cannot decide whether the student is eligible simply by receiving the application request. It needs information from multiple Salesforce records.

### Student Information

The system may need:

* Student Name
* CGPA
* Branch
* Graduation Year
* Backlog Information
* Placement Status

### Job Information

The system may need:

* Job Title
* Required CGPA
* Eligible Branches
* Graduation Criteria
* Application Deadline
* Number of Available Positions

### Application Information

The system may also need:

* Application Status
* Application Date
* Student
* Job
* Selection Status

The application therefore follows a data-driven process:

```text
Student Request
      ↓
Retrieve Student Information
      ↓
Retrieve Job Requirements
      ↓
Compare Eligibility Rules
      ↓
Create / Update Application
      ↓
Store Result in Salesforce
```

---

# 🔎 Part 1 – Retrieving Information with SOQL

## What is SOQL?

**SOQL (Salesforce Object Query Language)** is used to retrieve records from Salesforce objects.

It allows Apex developers to specify:

* Which object to query
* Which fields to retrieve
* Which records are required
* How the results should be filtered or ordered

SOQL is similar to SQL in purpose, but it is specifically designed for the Salesforce platform and its object model.

---

# 🧩 Basic SOQL Structure

A simple SOQL query follows this pattern:

```apex
SELECT Field1, Field2
FROM ObjectName
WHERE Condition
```

For example:

```apex
SELECT Name, CGPA__c, Branch__c
FROM Student__c
WHERE CGPA__c >= 7.0
```

This query retrieves students whose CGPA satisfies the specified condition.

---

# 🎓 Retrieving a Specific Student

Suppose the Placement Management System needs academic information for a particular student.

```apex
Student__c student = [
    SELECT Id, Name, CGPA__c, Branch__c
    FROM Student__c
    WHERE Id = :studentId
];
```

Here:

* `Student__c` is the Salesforce object.
* `Id`, `Name`, `CGPA__c`, and `Branch__c` are the required fields.
* `studentId` is an Apex variable.
* `:` binds the Apex variable to the SOQL query.

The retrieved information can then be used by the application to perform business calculations.

---

# 🎯 Querying Only Required Information

A good query should retrieve only the information needed by the application.

### Avoid unnecessary fields

```apex
SELECT Id, Name, CGPA__c, Branch__c, Graduation_Year__c
FROM Student__c
WHERE Id = :studentId
```

If the application only needs the student's CGPA and branch, retrieving additional fields may be unnecessary.

A better approach is:

```apex
SELECT Id, CGPA__c, Branch__c
FROM Student__c
WHERE Id = :studentId
```

This keeps data access focused and easier to maintain.

---

# 🧠 SOQL and Business Logic

SOQL itself does not decide whether a student is eligible.

Its responsibility is to provide the information required by the business logic.

For example:

```text
SOQL
 ↓
Retrieve CGPA
 ↓
Retrieve Branch
 ↓
Retrieve Job Requirements
 ↓
Business Logic
 ↓
Determine Eligibility
```

This separation makes the application easier to understand and maintain.

---

# ✏️ Part 2 – Managing Salesforce Records with DML

## What is DML?

**DML (Data Manipulation Language)** is used to perform operations that change Salesforce data.

DML allows Apex to:

* Create records
* Modify records
* Remove records
* Restore deleted records
* Insert or update records
* Combine duplicate records where supported

---

# 📋 Common DML Operations

| DML Operation | Purpose                    |
| ------------- | -------------------------- |
| `insert`      | Creates new records        |
| `update`      | Modifies existing records  |
| `delete`      | Removes records            |
| `undelete`    | Restores deleted records   |
| `upsert`      | Inserts or updates records |
| `merge`       | Combines duplicate records |

---

# ➕ Creating a Record with Insert

Suppose a new student needs to be added to Salesforce.

```apex
Student__c student = new Student__c();

student.Name = 'Rahul';
student.CGPA__c = 8.6;
student.Branch__c = 'Computer Science';

insert student;
```

The `insert` statement sends the new record to the Salesforce database.

After a successful insert, Salesforce assigns the record an `Id`.

---

# ✏️ Updating an Existing Record

Before updating a record, the application normally retrieves it.

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
Retrieve Record
      ↓
Modify Field
      ↓
Update Record
```

This demonstrates how SOQL and DML work together.

---

# 🗑️ Deleting Records

A record can be removed using the `delete` operation.

```apex
Student__c student = [
    SELECT Id
    FROM Student__c
    LIMIT 1
];

delete student;
```

The record is moved to the Salesforce Recycle Bin and can potentially be restored.

---

# ♻️ Restoring Records

Deleted records can be restored using `undelete`.

```apex
undelete student;
```

This is useful when a record was removed accidentally or needs to be restored as part of a business process.

---

# 🔄 Upsert

`upsert` is useful when the application needs to either create a new record or update an existing record.

```apex
upsert student;
```

Conceptually:

```text
Record Exists?
     /       \
   Yes        No
    ↓          ↓
 Update      Insert
```

This can simplify data synchronization scenarios.

---

# 🏗️ Complete Placement Application Flow

SOQL and DML become more meaningful when combined into a complete business process.

For example, when a student applies for a job:

### Step 1 – Retrieve Student

```apex
Student__c student = [
    SELECT Id, CGPA__c, Branch__c
    FROM Student__c
    WHERE Id = :studentId
];
```

### Step 2 – Retrieve Job

```apex
Job__c job = [
    SELECT Id, Required_CGPA__c, Eligible_Branch__c
    FROM Job__c
    WHERE Id = :jobId
];
```

### Step 3 – Evaluate Eligibility

```apex
Boolean eligible =
    student.CGPA__c >= job.Required_CGPA__c;
```

Additional business rules can be applied for branch, graduation year, backlogs, or other requirements.

### Step 4 – Create Application

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
Student
   │
   ▼
SOQL
   │
   ▼
Student Information
   │
   ├───────────────┐
   │               │
   ▼               ▼
Job Information   Eligibility Rules
   │               │
   └───────┬───────┘
           ▼
      Application
           │
           ▼
          DML
           │
           ▼
    Salesforce Database
```

---

# 🔐 Data Access and Application Design

A well-designed Salesforce application should not treat data access as an isolated activity.

The application should clearly separate:

```text
Data Retrieval
      ↓
Business Processing
      ↓
Data Modification
```

This separation provides several benefits:

* Easier maintenance
* Better readability
* Reusable logic
* Easier testing
* Clearer responsibilities
* Improved scalability

This approach also prepares the project for later topics such as **Triggers, Bulkification, and Service Layer Architecture**.

---

# ⚠️ Important Apex Considerations

Although SOQL and DML are powerful, they consume Salesforce resources.

Developers should therefore avoid inefficient patterns such as:

### ❌ SOQL Inside a Loop

```apex
for (Application__c app : applications) {

    Student__c student = [
        SELECT Id, CGPA__c
        FROM Student__c
        WHERE Id = :app.Student__c
    ];

}
```

This can consume Salesforce Governor Limits rapidly.

### ❌ DML Inside a Loop

```apex
for (Application__c app : applications) {
    update app;
}
```

A better approach is to collect records and perform a single bulk operation.

These concepts become the foundation for the next stage of the project:

> **Sprint 7 – Bulk Processing & Governor Limits**

---

# 🗂️ Example Project Structure

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

The service classes can later be extended to centralize SOQL and DML operations.

---

# 🧪 Practical Learning Activities

During this sprint, the following activities can be practiced:

### SOQL

* Retrieve a student by Id.
* Retrieve students based on CGPA.
* Filter students by branch.
* Retrieve job requirements.
* Query application records.
* Use bind variables in Apex SOQL.

### DML

* Insert a Student record.
* Update student information.
* Delete an unnecessary record.
* Restore a deleted record.
* Use `upsert` for record synchronization.
* Create placement applications.

---

# 📊 SOQL vs DML

| Feature                        | SOQL          | DML                |
| ------------------------------ | ------------- | ------------------ |
| Purpose                        | Retrieve data | Modify data        |
| Reads Records                  | ✅             | ❌                  |
| Creates Records                | ❌             | ✅                  |
| Updates Records                | ❌             | ✅                  |
| Deletes Records                | ❌             | ✅                  |
| Used Before Business Decisions | ✅             | Sometimes          |
| Example                        | `SELECT`      | `insert`, `update` |

A simple way to remember the difference:

```text
SOQL → Read Salesforce Data

DML  → Change Salesforce Data
```

---

# 🎤 Interview Questions

This sprint provides a foundation for common Salesforce interview questions:

1. What is SOQL?
2. How is SOQL different from SQL?
3. What is DML in Salesforce?
4. What are the different DML operations?
5. What is the difference between `insert` and `upsert`?
6. When would you use `undelete`?
7. What is a bind variable in SOQL?
8. Why should only required fields be queried?
9. Why is SOQL inside a loop considered bad practice?
10. Why should DML not be performed repeatedly inside loops?
11. How do SOQL and DML work together in an Apex application?
12. How would you retrieve a related record before applying business logic?
13. What happens when a DML operation fails?
14. How can SOQL and DML be designed for bulk processing?

---

# 🛠️ Technologies Used

* **Salesforce Platform**
* **Apex**
* **SOQL**
* **DML**
* **Salesforce Objects**
* **Salesforce Developer Console**
* **Visual Studio Code**
* **Salesforce CLI**

---

# 💡 Engineering Principles Learned

This sprint introduced several important engineering principles:

### 1. Data Comes Before Decisions

Business logic needs reliable information before it can make decisions.

### 2. Query What You Need

Efficient applications retrieve only the fields and records required for the task.

### 3. Separate Data Access from Business Logic

Retrieving information and applying business rules should have clear responsibilities.

### 4. Database Operations Must Be Controlled

SOQL and DML consume Salesforce resources and should therefore be used carefully.

### 5. Design for Future Scale

Even when working with a small number of records, Apex should be written with bulk processing in mind.

---

# 🚀 Key Takeaways

The most important concepts learned during Sprint 5 are:

* **SOQL is used to retrieve Salesforce data.**
* **DML is used to create and modify Salesforce records.**
* **Business logic depends on accurate and relevant data.**
* **SOQL and DML work together to implement complete business workflows.**
* **Efficient data access is essential in Salesforce because of Governor Limits.**
* **Data access code should be organized and reusable.**
* **Bulk-safe thinking should begin even before working with Triggers.**

---

# 🔮 Next Sprint

The next stage builds upon the data-handling concepts introduced here.

### Sprint 6 – Apex Triggers

The application will learn to respond automatically to Salesforce events such as:

```text
Record Created
      ↓
Record Updated
      ↓
Trigger Executes
      ↓
Business Logic Runs
      ↓
Application Responds Automatically
```

This will introduce **event-driven Salesforce development** and prepare the project for the following sprint on **Bulk Processing & Governor Limits**.

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
* Trigger Automation
* Backend Development
* Enterprise Application Development

---

# ⭐ Sprint Summary

Sprint 5 represents an important step in the development of the Placement Management System.

The application moves from simply storing information to actively **retrieving, processing, and managing business data**.

```text
Store Data
    ↓
Retrieve Data with SOQL
    ↓
Apply Business Logic
    ↓
Modify Data with DML
    ↓
Build a Useful Application
```

> **“A Salesforce application becomes intelligent when it can retrieve the right information, make meaningful decisions, and update the system reliably.”**
