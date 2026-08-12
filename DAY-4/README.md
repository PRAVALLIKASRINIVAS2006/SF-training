# 🚀 Sprint 7 – Building Software That Survives Scale

> **“Code that works for one record is a demonstration. Code that works safely for thousands is engineering.”**

## 📖 About This Sprint

**Sprint 7 – Bulk Processing & Governor Limits in Salesforce Apex** focuses on developing Apex applications that remain reliable and efficient when processing large volumes of Salesforce records.

In earlier stages of development, it is easy to write Apex that works correctly for a single record. However, Salesforce Triggers can execute for many records within the same transaction. This makes scalability, resource management, and efficient database operations essential.

This sprint introduces the engineering mindset required to build **bulk-safe, governor-limit-aware, and maintainable Apex applications**.

The implementation demonstrates how to:

* Process records as collections
* Minimize SOQL and DML operations
* Use Lists, Sets, and Maps effectively
* Detect meaningful record changes
* Separate Trigger logic from business logic
* Build reusable Trigger Handler and Service layers
* Design Apex that can safely process bulk transactions

---

# 🎯 Sprint Objective

The primary objective of this sprint is to transform traditional single-record Apex into **bulkified enterprise Apex**.

The project follows the principle:

```text
One Record → Collection of Records → Bulk Processing → Scalable Application
```

Instead of thinking:

> “What should happen when this record changes?”

the developer learns to think:

> “What should happen when 1, 50, 100, or 200 records change in the same transaction?”

This shift is the foundation of scalable Salesforce development.

---

# 📚 Learning Outcomes

After completing this sprint, the developer should be able to:

* Explain Salesforce Governor Limits.
* Understand why Governor Limits exist.
* Write bulk-safe Apex code.
* Process multiple records efficiently.
* Avoid SOQL queries inside loops.
* Avoid DML operations inside loops.
* Use Sets to collect unique IDs.
* Use Maps for efficient record lookup.
* Work effectively with Lists.
* Use Trigger Context Variables correctly.
* Detect changes between old and new record values.
* Design maintainable Trigger architectures.
* Separate automation from business logic.
* Build Apex applications that are ready for larger data volumes.

---

# 🏗️ Application Architecture

The project follows a layered Trigger architecture.

```text
┌───────────────────────────┐
│      Salesforce Event     │
└─────────────┬─────────────┘
              │
              ▼
┌───────────────────────────┐
│    Application Trigger    │
│       Event Routing       │
└─────────────┬─────────────┘
              │
              ▼
┌───────────────────────────┐
│   Trigger Handler Class   │
│   Context Management      │
└─────────────┬─────────────┘
              │
              ▼
┌───────────────────────────┐
│    Application Service    │
│     Business Logic        │
└─────────────┬─────────────┘
              │
              ▼
┌───────────────────────────┐
│       Bulk SOQL           │
│   Query Required Data     │
└─────────────┬─────────────┘
              │
              ▼
┌───────────────────────────┐
│       Collections         │
│    List / Set / Map       │
└─────────────┬─────────────┘
              │
              ▼
┌───────────────────────────┐
│        Bulk DML           │
│     Save Changes Once     │
└───────────────────────────┘
```

### Architecture Principles

The Trigger is responsible only for **routing the event**.

The Handler manages **Trigger execution flow**.

The Service class contains the **business logic**.

Database operations are designed to work with **collections rather than individual records**.

---

# 🔄 Bulk Processing Workflow

The implementation follows a predictable bulk-processing workflow:

```text
Trigger Receives Records
          │
          ▼
Identify Relevant Records
          │
          ▼
Collect Related Record IDs
          │
          ▼
Remove Duplicate IDs Using Set
          │
          ▼
Execute Bulk SOQL
          │
          ▼
Store Results in Map
          │
          ▼
Perform Business Logic in Memory
          │
          ▼
Collect Records Requiring Changes
          │
          ▼
Execute Bulk DML
          │
          ▼
Transaction Completed
```

This approach reduces database interaction and keeps the application within Salesforce resource limits.

---

# ⚙️ Salesforce Governor Limits

Salesforce operates on a multitenant architecture. Governor Limits ensure that one transaction does not consume an unreasonable amount of shared platform resources.

Important limits covered in this sprint include:

| Resource               | Synchronous Limit |
| ---------------------- | ----------------: |
| SOQL Queries           |               100 |
| SOQL Records Retrieved |            50,000 |
| DML Statements         |               150 |
| DML Records            |            10,000 |
| CPU Time               |         10,000 ms |
| Heap Size              |              6 MB |

> **Note:** Salesforce has different limits depending on execution context. The values above represent commonly referenced synchronous Apex limits and should be verified against the current Salesforce documentation when designing production systems.

---

# 📌 Bulkification

**Bulkification** means designing Apex so that the same logic can efficiently process multiple records in one transaction.

Salesforce commonly processes Trigger records in batches, so Apex should never assume that only one record is being processed.

### ❌ Single-Record Thinking

```apex
for (Application__c app : Trigger.new) {

    Student__c student = [
        SELECT Id, CGPA__c
        FROM Student__c
        WHERE Id = :app.Student__c
    ];

}
```

The query executes repeatedly and can quickly consume the SOQL governor limit.

### ✅ Bulk-Safe Approach

```apex
Set<Id> studentIds = new Set<Id>();

for (Application__c app : Trigger.new) {

    if (app.Student__c != null) {
        studentIds.add(app.Student__c);
    }

}

Map<Id, Student__c> studentsById =
    new Map<Id, Student__c>([
        SELECT Id, CGPA__c
        FROM Student__c
        WHERE Id IN :studentIds
    ]);
```

The IDs are collected first, and the related records are retrieved with **one SOQL query**.

---

# 🧩 Collections in Apex

Collections are one of the most important tools for bulk-safe Apex.

## List

A `List` stores an ordered collection of records.

```apex
List<Application__c> applications =
    new List<Application__c>();
```

Typical use cases:

* Records received from a query
* Records that need to be inserted
* Records that need to be updated

---

## Set

A `Set` stores unique values.

```apex
Set<Id> studentIds =
    new Set<Id>();
```

Sets are especially useful for:

* Collecting related record IDs
* Removing duplicates
* Building efficient `IN` clauses for SOQL

Example:

```apex
studentIds.add(app.Student__c);
```

---

## Map

A `Map` stores key-value pairs and provides fast lookup.

```apex
Map<Id, Student__c> studentsById =
    new Map<Id, Student__c>();
```

Example:

```apex
Student__c student =
    studentsById.get(app.Student__c);
```

This avoids repeatedly querying the database for the same record.

---

# 🔍 Trigger Context Variables

Trigger Context Variables provide information about the records and event currently being processed.

## Trigger.new

Contains the new versions of records.

Available in:

* Before Insert
* After Insert
* Before Update
* After Update

Example:

```apex
for (Application__c app : Trigger.new) {
    // Process current record values
}
```

---

## Trigger.old

Contains the previous versions of records.

Available in:

* Before Update
* After Update
* Before Delete
* After Delete

It is useful when comparing previous and current values.

---

## Trigger.newMap

Provides the current records using their Salesforce IDs as keys.

```apex
Application__c app =
    Trigger.newMap.get(recordId);
```

This is useful when a specific record needs to be accessed quickly.

---

## Trigger.oldMap

Provides the previous versions of records using their IDs.

```apex
Application__c oldApp =
    Trigger.oldMap.get(recordId);
```

This is particularly useful for detecting meaningful changes.

---

# 🔄 Detecting Meaningful Changes

A Trigger should not perform unnecessary processing when a relevant field has not actually changed.

For example:

```apex
if (
    oldApp.Status__c != app.Status__c &&
    app.Status__c == 'Selected'
) {
    // Execute business logic
}
```

This approach ensures that automation runs only when the required business condition is satisfied.

### Why This Matters

Without change detection, the application may:

* Perform unnecessary DML
* Consume CPU time
* Execute unnecessary business logic
* Cause recursive automation
* Increase transaction complexity

---

# 🚫 Common Apex Mistakes

## 1. SOQL Inside a Loop

### ❌ Avoid

```apex
for (Application__c app : Trigger.new) {

    Student__c student = [
        SELECT Id, CGPA__c
        FROM Student__c
        WHERE Id = :app.Student__c
    ];

}
```

### ✅ Prefer

```apex
Set<Id> studentIds = new Set<Id>();

for (Application__c app : Trigger.new) {
    studentIds.add(app.Student__c);
}

List<Student__c> students = [
    SELECT Id, CGPA__c
    FROM Student__c
    WHERE Id IN :studentIds
];
```

---

# 🚫 DML Inside a Loop

### ❌ Avoid

```apex
for (Application__c app : applications) {
    update app;
}
```

Each iteration consumes a DML statement.

### ✅ Prefer

```apex
List<Application__c> applicationsToUpdate =
    new List<Application__c>();

for (Application__c app : applications) {
    applicationsToUpdate.add(app);
}

if (!applicationsToUpdate.isEmpty()) {
    update applicationsToUpdate;
}
```

One DML operation can process multiple records.

---

# 🏛️ Trigger Handler Pattern

The project separates Trigger routing from business logic.

```text
ApplicationTrigger
        │
        ▼
ApplicationTriggerHandler
        │
        ▼
ApplicationService
        │
        ▼
Business Rules
```

## Trigger

The Trigger should remain lightweight.

```apex
trigger ApplicationTrigger
on Application__c (
    before insert,
    before update,
    after insert,
    after update
) {

    ApplicationTriggerHandler.handle();

}
```

## Handler

The Handler determines what should happen for the current Trigger context.

```apex
public class ApplicationTriggerHandler {

    public static void handle() {

        if (Trigger.isAfter && Trigger.isUpdate) {

            ApplicationService.processApplications(
                Trigger.new,
                Trigger.oldMap
            );

        }
    }
}
```

## Service

The Service class contains reusable business logic.

```apex
public class ApplicationService {

    public static void processApplications(
        List<Application__c> applications,
        Map<Id, Application__c> oldApplications
    ) {

        // Business logic
        // Bulk SOQL
        // Collection processing
        // Bulk DML

    }
}
```

---

# 📂 Project Structure

```text
force-app/
│
└── main/
    └── default/
        │
        ├── triggers/
        │   └── ApplicationTrigger.trigger
        │
        ├── classes/
        │   ├── ApplicationTriggerHandler.cls
        │   ├── ApplicationService.cls
        │   └── ApplicationTriggerHandlerTest.cls
        │
        └── objects/
            ├── Application__c/
            ├── Student__c/
            └── Job__c/
```

---

# 🧪 Testing Strategy

Bulk-safe Apex should be tested with more than a single record.

The test strategy should include:

### Single Record

Verify that the business rule works for one record.

### Multiple Records

Verify that the same logic works when many records are processed together.

### Duplicate Relationships

Verify that duplicate related IDs are handled correctly using Sets.

### Meaningful Changes

Verify that automation executes only when relevant fields change.

### No Relevant Changes

Verify that unnecessary processing does not occur.

### Bulk DML

Verify that records are updated together rather than individually.

Example test setup:

```apex
List<Application__c> applications =
    new List<Application__c>();

for (Integer i = 0; i < 200; i++) {

    applications.add(
        new Application__c(
            Name = 'Application ' + i
        )
    );
}

insert applications;
```

Testing with larger record collections helps expose bulkification problems that single-record tests may hide.

---

# 💡 Engineering Principles

This sprint follows several core Salesforce engineering principles:

### 1. Think in Collections

Never design Trigger logic assuming one record.

### 2. Query Once

Collect IDs first and perform bulk SOQL.

### 3. Save Once

Collect records that require changes and perform bulk DML.

### 4. Use the Right Collection

* `List` → ordered records
* `Set` → unique values
* `Map` → fast lookup

### 5. Keep Triggers Lightweight

Triggers should primarily route execution.

### 6. Separate Responsibilities

Business rules belong in reusable classes rather than being tightly coupled to the Trigger.

### 7. Minimize Database Operations

Database operations are expensive resources in a governed environment.

### 8. Design for Scale

A solution should work correctly for one record and remain safe when processing hundreds of records.

---

# 📊 Before vs After Bulkification

| Approach          | Beginner Design      | Bulk-Safe Design   |
| ----------------- | -------------------- | ------------------ |
| Record Processing | One record at a time | Collection-based   |
| SOQL              | Inside loops         | Outside loops      |
| DML               | Inside loops         | Bulk operation     |
| Related IDs       | Individual variables | Set                |
| Record Lookup     | Repeated queries     | Map                |
| Trigger           | Business logic       | Event routing      |
| Architecture      | Monolithic           | Layered            |
| Scalability       | Limited              | Designed for scale |
| Maintainability   | Difficult            | Improved           |

---

# 🎤 Interview Questions

This sprint prepares for common Salesforce Apex interview topics:

1. What are Salesforce Governor Limits?
2. Why does Salesforce enforce Governor Limits?
3. What is Apex Bulkification?
4. Why should SOQL not be written inside loops?
5. Why should DML not be performed inside loops?
6. What is the difference between `Trigger.new` and `Trigger.old`?
7. What is the difference between `Trigger.newMap` and `Trigger.oldMap`?
8. When would you use a Set in Apex?
9. When would you use a Map in Apex?
10. Why should every Trigger be designed for bulk processing?
11. What is the Trigger Handler Pattern?
12. Why should business logic be separated from Trigger logic?
13. How can you detect whether a field value actually changed?
14. How does bulk SOQL improve Apex scalability?
15. How would you test a Trigger for 200 records?
16. What problems can occur when DML is performed inside loops?
17. How do Governor Limits influence Apex architecture?

---

# 🛠️ Technologies Used

* **Salesforce Platform**
* **Apex**
* **Apex Triggers**
* **SOQL**
* **DML**
* **Lists**
* **Sets**
* **Maps**
* **Trigger Context Variables**
* **Trigger Handler Pattern**
* **Service Layer Architecture**
* **Salesforce Developer Tools**
* **Git & GitHub**

---

# 🚀 Future Enhancements

The next stage of the project will introduce **Asynchronous Apex** and explore how Salesforce handles long-running and resource-intensive operations.

Planned topics include:

* Future Methods
* Queueable Apex
* Batch Apex
* Scheduled Apex
* Asynchronous Processing
* Large Data Volume Processing
* Job Monitoring
* Performance Optimization

The learning progression will move from:

```text
Synchronous Apex
       ↓
Bulk-Safe Apex
       ↓
Asynchronous Apex
       ↓
Large-Scale Processing
       ↓
Enterprise Salesforce Architecture
```

---

# 📈 Key Takeaways

By completing Sprint 7, the project demonstrates an understanding that Salesforce development is not simply about making code execute successfully.

Production-quality Apex must also be:

* **Bulk-safe**
* **Governor-limit aware**
* **Efficient**
* **Maintainable**
* **Reusable**
* **Testable**
* **Scalable**

The most important lesson from this sprint is:

> **Bulkification is not an optimization added after development. It is the foundation on which scalable Apex should be designed.**

---

# 👩‍💻 Author

## Penumarthi Pravallika

**Computer Science Student | Salesforce Developer**

### Technical Skills

`Salesforce` · `Apex` · `LWC` · `SOQL` · `DML` · `Java` · `Python`

### Focus Areas

* Salesforce Development
* Apex Programming
* Lightning Web Components
* Trigger Automation
* Bulk-Safe Development
* Salesforce Architecture
* Backend Development

---

# ⭐ Project Learning

This sprint represents the transition from **writing code that works** to **engineering code that scales**.

```text
Beginner Thinking
      ↓
"Does my code work?"

Engineering Thinking
      ↓
"Does my code remain safe when Salesforce
processes hundreds or thousands of records?"
```

That mindset is the foundation of professional Salesforce development.
