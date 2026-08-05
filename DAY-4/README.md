# 🚀 Sprint 7 – Bulk Processing & Governor Limits in Salesforce Apex

> **"Code that works for one record is a demonstration. Code that works safely for thousands is engineering."**

## 📖 Overview

This repository contains the implementation and learning outcomes from **Sprint 7 – Building Software That Survives Scale**. The focus of this sprint is on writing **bulk-safe Apex**, understanding **Salesforce Governor Limits**, and designing scalable **Trigger architectures** that can efficiently process large volumes of records.

Unlike beginner Apex that works only for individual records, this sprint emphasizes enterprise-grade development practices that allow code to safely process up to **200 records per transaction** while staying within Salesforce Governor Limits.

---

## 🎯 Sprint Objectives

By completing this sprint, the following concepts were implemented and demonstrated:

- Bulk-safe Apex development
- Governor Limits and resource optimization
- Trigger Context Variables
- Trigger.new and Trigger.old
- Trigger.newMap and Trigger.oldMap
- Collections (List, Set, Map)
- Bulk SOQL
- Bulk DML
- Trigger Handler Pattern
- Service Layer Architecture
- Detecting meaningful record changes
- Enterprise Trigger Design

---

# 📚 Learning Outcomes

After completing this sprint, you should be able to:

- Understand why Salesforce applications must be designed for scale.
- Explain Governor Limits and why they exist.
- Write bulkified Apex code.
- Process multiple records safely.
- Avoid SOQL inside loops.
- Avoid DML inside loops.
- Use Lists, Sets, and Maps efficiently.
- Design clean Trigger architectures.
- Delegate business logic to Handler and Service classes.
- Build production-ready Apex code.

---

# 🏗 Project Architecture

```
Application Trigger
        │
        ▼
Application Trigger Handler
        │
        ▼
Application Service
        │
        ▼
Business Logic
        │
        ▼
Bulk SOQL
        │
        ▼
Collections (List / Set / Map)
        │
        ▼
Bulk DML
```

---

# 🔄 Bulk Processing Workflow

```
Receive Trigger Records
        │
        ▼
Collect Required IDs
        │
        ▼
Bulk SOQL Query
        │
        ▼
Store Records in Maps
        │
        ▼
Process Business Logic
        │
        ▼
Collect Records to Update
        │
        ▼
Single Bulk DML Operation
```

---

# ⚙️ Governor Limits Covered

| Resource | Limit |
|----------|-------|
| SOQL Queries | 100 |
| Records Retrieved | 50,000 |
| DML Statements | 150 |
| Records Processed by DML | 10,000 |
| CPU Time | 10,000 ms |
| Heap Size | 6 MB |

---

# 📌 Bulkification Principles

The project follows Salesforce Bulkification best practices:

✅ Process collections instead of individual records

✅ Query related records only once

✅ Use Sets to remove duplicate IDs

✅ Store queried records in Maps

✅ Perform all processing in memory

✅ Perform one DML operation

---

# 🧠 Trigger Context Variables

## Trigger.new

Contains the new versions of records currently being processed.

Used in:

- Before Insert
- Before Update
- After Insert
- After Update

---

## Trigger.old

Contains previous versions of records.

Available in:

- Before Update
- After Update
- Before Delete
- After Delete

---

## Trigger.newMap

Provides fast access to current records using their Id.

Example:

```apex
Application__c app = Trigger.newMap.get(recordId);
```

---

## Trigger.oldMap

Provides fast access to previous record values.

Useful for detecting meaningful field changes.

Example:

```apex
Application__c oldApp = Trigger.oldMap.get(recordId);
```

---

# 📦 Collections Used

## List

Stores multiple records together.

```apex
List<Application__c> applications;
```

---

## Set

Stores only unique values.

```apex
Set<Id> studentIds;
```

---

## Map

Provides key-value lookup.

```apex
Map<Id, Student__c> studentsById;
```

---

# 🚫 Common Mistakes Avoided

### ❌ SOQL inside loops

Bad

```apex
for(Application__c app : Trigger.new){

    Student__c student = [
        SELECT Id
        FROM Student__c
        WHERE Id=:app.Student__c
    ];

}
```

---

### ✅ Bulk SOQL

```apex
Set<Id> studentIds = new Set<Id>();

for(Application__c app : Trigger.new){

    studentIds.add(app.Student__c);

}

Map<Id, Student__c> students =
new Map<Id, Student__c>([
    SELECT Id, CGPA__c
    FROM Student__c
    WHERE Id IN :studentIds
]);
```

---

### ❌ DML inside loops

```apex
for(Application__c app : applications){

    update app;

}
```

---

### ✅ Bulk DML

```apex
List<Application__c> updates = new List<Application__c>();

for(Application__c app : applications){

    updates.add(app);

}

update updates;
```

---

# 🏛 Trigger Handler Pattern

The Trigger only routes events.

```
ApplicationTrigger

↓

ApplicationTriggerHandler

↓

ApplicationService

↓

Business Logic
```

Benefits:

- Cleaner code
- Better maintainability
- Easier testing
- Reusable business logic
- Enterprise architecture

---

# 📂 Project Structure

```
force-app
│
├── triggers
│      ApplicationTrigger.trigger
│
├── classes
│      ApplicationTriggerHandler.cls
│      ApplicationService.cls
│
└── objects
       Application__c
       Student__c
       Job__c
```

---

# 💡 Engineering Principles

- Think in collections, not individual records.
- Process records in memory whenever possible.
- Query once.
- Save once.
- Minimize database operations.
- Design for scalability.
- Keep Triggers lightweight.
- Separate business logic from Trigger logic.

---

# 🎤 Interview Questions Covered

- What are Governor Limits?
- Why does Salesforce enforce Governor Limits?
- What is Bulkification?
- Why is SOQL inside loops dangerous?
- Why is DML inside loops dangerous?
- Difference between Trigger.new and Trigger.old.
- Difference between Trigger.oldMap and Trigger.newMap.
- Why use Sets?
- Why use Maps?
- Why should Triggers always assume multiple records?
- Explain Trigger Handler architecture.
- How do you bulkify Apex code?

---

# 🚀 Key Takeaways

- Apex should always be written for collections.
- Salesforce Triggers process multiple records.
- Governor Limits require efficient resource usage.
- Bulkification is a design principle, not an optimization.
- Lists, Sets, and Maps are fundamental to scalable Apex.
- Trigger Handler architecture improves maintainability.
- Enterprise Apex minimizes SOQL and DML operations.

---

# 🛠 Technologies Used

- Salesforce Apex
- Apex Triggers
- SOQL
- DML
- Trigger Context Variables
- Lists
- Sets
- Maps
- Trigger Handler Pattern
- Service Layer Architecture
- Salesforce Platform

---

# 📈 Future Enhancements

The next sprint will extend this project by implementing:

- Future Methods
- Queueable Apex
- Batch Apex
- Scheduled Apex
- Asynchronous Processing
- Performance Optimization

---

## 👩‍💻 Author

**Penumarthi Pravallika**

Computer Science Student | Salesforce Developer | Apex | LWC | SOQL | DML | Java | Python

---

⭐ If you found this project useful, consider giving it a **Star** on GitHub!
