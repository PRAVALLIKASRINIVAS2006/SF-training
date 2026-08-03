# Sprint 5 – Retrieving and Managing Information with SOQL and DML

## Overview

This sprint focuses on retrieving and managing data in Salesforce using SOQL (Salesforce Object Query Language) and DML (Data Manipulation Language). The main objective is to understand that enterprise applications must retrieve the required information before applying business logic and then use DML operations to store or update records.

## Learning Objectives

By completing this sprint, I learned to:

* Understand why enterprise software retrieves data before making decisions.
* Use SOQL to retrieve records from Salesforce objects.
* Use DML to insert, update, and delete records.
* Retrieve, create, and update Salesforce records using Apex.
* Understand the importance of data in business applications.
* Write efficient and reusable data access code.

---

# Part 1: Understanding Data Retrieval

Every business application depends on accurate information. Before making any decision, the software must first retrieve the required data.

For example, when a student applies for a job, the system cannot immediately determine eligibility. It must first retrieve information such as:

* Student details
* CGPA
* Branch
* Number of backlogs
* Graduation year
* Job eligibility criteria
* Application deadline
* Existing applications
* Current offers

Only after retrieving this information can the application decide whether the student is eligible.

The overall process followed by the application is:

```text
Retrieve Information
        ↓
Apply Business Logic
        ↓
Store or Update Information
```

---

# Part 2: Retrieving Data Using SOQL

SOQL (Salesforce Object Query Language) is used to retrieve records from Salesforce objects. It allows the application to ask questions and fetch only the required information.

Before writing a SOQL query, it is important to identify:

* Which object contains the required information?
* Which fields are needed?
* Which record should be retrieved?

### Basic SOQL Syntax

```apex
SELECT Field1, Field2
FROM ObjectName
WHERE Condition
```

### Example

```apex
Student__c student = [
    SELECT Name, CGPA__c, Branch__c
    FROM Student__c
    WHERE Id = :studentId
];
```

The purpose of this query is to retrieve the student's academic details before checking eligibility.

---

# Part 3: Managing Data Using DML

DML (Data Manipulation Language) is used to modify Salesforce records after the required business logic has been executed.

Common DML operations include:

| Operation | Description                 |
| --------- | --------------------------- |
| insert    | Creates a new record        |
| update    | Modifies an existing record |
| delete    | Removes a record            |
| undelete  | Restores a deleted record   |
| upsert    | Inserts or updates a record |
| merge     | Combines duplicate records  |

### Insert Example

```apex
Student__c student = new Student__c();
student.Name = 'Rahul';
student.CGPA__c = 8.6;

insert student;
```

### Update Example

```apex
Student__c student = [
    SELECT Id, CGPA__c
    FROM Student__c
    LIMIT 1
];

student.CGPA__c = 9.0;

update student;
```

---

# Complete Business Flow

A typical placement application follows these steps:

1. Retrieve student details using SOQL.
2. Retrieve job details using SOQL.
3. Check the student's eligibility based on business rules.
4. Create or update the application record using DML.

This sequence ensures that decisions are made using accurate and up-to-date information.

---

# Key Takeaways

* Retrieve data before applying business logic.
* Use SOQL to read Salesforce records.
* Use DML to create and modify Salesforce records.
* Write queries based on business requirements rather than syntax.
* Treat Salesforce data as an important business asset.

---

# Technologies Used

* Salesforce Platform
* Apex
* SOQL
* DML
* Salesforce Developer Console
* Visual Studio Code

---

# Conclusion

This sprint introduced the fundamentals of working with Salesforce data. SOQL is used to retrieve the information required for business decisions, while DML is used to create and manage records. Understanding these concepts is essential for building reliable and efficient Salesforce applications.
