# 🚀 Sprint 4 – Designing Business Logic with Apex

> **“Software becomes valuable when it can turn business requirements into meaningful decisions.”**

## 📖 About This Sprint

**Sprint 4 – Building Business Logic with Apex** marks an important stage in the development of the **Placement Management System**.

The application has already established the foundation for storing information about students, companies, jobs, and applications. The next step is to make the system capable of **understanding business rules and responding to real-world requirements**.

This sprint focuses on translating business requirements into Apex-based services.

Instead of thinking only about:

> “How do I write this Apex code?”

the focus shifts toward:

> “What should the application do, and why?”

This approach introduces the fundamentals of **business-driven software design**.

---

# 🎯 Sprint Objective

The main objective of this sprint is to understand how business requirements are transformed into application logic.

The development process follows:

```text
Business Requirement
        ↓
Identify Business Rule
        ↓
Define Responsibility
        ↓
Design Service
        ↓
Implement Apex Logic
```

The sprint therefore focuses more on **design and reasoning** than on writing large amounts of code.

---

# 📚 Learning Objectives

By completing this sprint, I learned to:

* Understand the role of business logic in enterprise applications.
* Convert customer requirements into software rules.
* Distinguish between data storage and business processing.
* Identify responsibilities within an application.
* Design Apex classes around business responsibilities.
* Create service-oriented Apex classes.
* Use meaningful class and method names.
* Plan application architecture before implementation.
* Build a foundation for future Salesforce automation.
* Develop software incrementally instead of writing everything at once.

---

# 🏢 Business Scenario – Placement Management System

The Placement Management System is designed to support the complete placement process for students and organizations.

Simply storing records is not enough.

The system must also understand rules such as:

* Can this student apply for the job?
* Has the application deadline passed?
* Has the student already applied?
* Does the student satisfy the CGPA requirement?
* Is the student's branch eligible?
* Does the student have the required academic status?
* Is the company posting a duplicate opportunity?

These requirements represent **business logic**.

---

# 🧠 Part 1 – Understanding Business Logic

Business logic represents the rules and decisions that determine how an application should behave.

For example:

### Application Deadline

A student should not be allowed to submit an application after the job's closing date.

```text id="c0f72b"
Current Date
      ↓
Compare with Deadline
      ↓
Deadline Passed?
    /       \
  Yes        No
   ↓          ↓
 Reject     Continue
```

### Duplicate Application

A student should not submit multiple applications for the same job.

```text id="r4l7qn"
Student + Job
      ↓
Existing Application?
    /        \
  Yes         No
   ↓           ↓
Reject       Allow
```

### Eligibility

The application can evaluate multiple requirements:

```text id="2x5p5c"
Student Information
        +
Job Requirements
        ↓
Eligibility Rules
        ↓
Eligible?
   /       \
 Yes        No
  ↓          ↓
Continue   Reject
```

These decisions form the core behavior of the Placement Management System.

---

# 🔍 Part 2 – Converting Requirements into Rules

Before implementing Apex, requirements must be translated into clear rules.

For example:

| Requirement           | Business Rule                                          |
| --------------------- | ------------------------------------------------------ |
| Application Deadline  | Reject applications after the closing date             |
| Duplicate Application | Allow only one application per student-job combination |
| CGPA                  | Student must satisfy the minimum CGPA                  |
| Branch                | Student branch must be eligible for the job            |
| Backlogs              | Student must satisfy the company's backlog requirement |
| Job Posting           | Avoid duplicate job opportunities                      |

This step prevents developers from writing code without understanding what the application is actually supposed to accomplish.

---

# 🏗️ Part 3 – Designing Application Services

As the system grows, putting every rule into one Apex class becomes difficult to maintain.

Instead, the application is divided according to **business responsibilities**.

```text id="7yq9we"
Placement Management System
            │
      ┌─────┼─────┐
      ↓     ↓     ↓
   Student  Job  Application
   Service Service Service
```

Each service focuses on a particular area of the application.

---

# 👨‍🎓 StudentService

`StudentService` is responsible for student-related business activities.

Possible responsibilities include:

* Registering students
* Updating student information
* Validating academic information
* Checking placement status
* Managing student-related business rules

Example structure:

```apex id="3gkvx6"
public class StudentService {

    // Student-related business operations

}
```

The class provides a central place for student-specific business logic.

---

# 💼 JobService

`JobService` handles business activities related to job postings.

Possible responsibilities include:

* Creating job opportunities
* Updating job requirements
* Publishing job postings
* Closing expired opportunities
* Validating job information

Example:

```apex id="5sq7se"
public class JobService {

    // Job-related business operations

}
```

This prevents job-related rules from becoming mixed with student or application logic.

---

# 📝 ApplicationService

`ApplicationService` manages the application process.

Its responsibilities can include:

* Receiving student applications
* Validating eligibility
* Checking duplicate applications
* Verifying application deadlines
* Creating valid application records
* Returning meaningful results

Example:

```apex id="qf0k4u"
public class ApplicationService {

    // Application-related business operations

}
```

---

# 🔧 Part 4 – Designing the Application Method

The first business operation introduced for the application process is the submission of an application.

```apex id="3s3y5w"
public class ApplicationService {

    public void submitApplication(
        Id studentId,
        Id jobId
    ) {

        // Business validation
        // Eligibility checks
        // Application creation

    }
}
```

The method receives two important inputs:

* `studentId` → identifies the student
* `jobId` → identifies the selected job

The method represents a real business action:

> **A student wants to apply for a particular job.**

Future implementations can add the required validations and database operations.

---

# 🧩 Business Logic vs Data Storage

One of the important concepts introduced in this sprint is the difference between **storing information** and **making decisions**.

### Data Storage

Stores information such as:

```text
Student Name
CGPA
Branch
Job Title
Minimum CGPA
Application Status
```

### Business Logic

Uses that information to make decisions:

```text
Is the student eligible?
Has the deadline passed?
Is this a duplicate application?
Should the application be accepted?
```

The relationship can be represented as:

```text id="t8v5ap"
Salesforce Data
      ↓
Business Logic
      ↓
Business Decision
      ↓
Application Action
```

---

# 🏛️ Service-Based Architecture

The project follows a simple service-oriented design.

```text id="f4g5z7"
                 Placement System
                       │
          ┌────────────┼────────────┐
          ↓            ↓            ↓
   StudentService  JobService  ApplicationService
          │            │            │
          ↓            ↓            ↓
      Student        Job        Application
       Rules         Rules          Rules
```

This structure provides clear separation between different areas of the application.

---

# 🌟 Why Separation of Responsibilities Matters

If all business logic is placed inside one large class, the application can become difficult to understand and modify.

Separating responsibilities provides:

### Better Readability

Developers can quickly identify where a particular rule belongs.

### Easier Maintenance

Changes to job-related rules do not require modifying unrelated student logic.

### Reusability

Service methods can be reused by other parts of the Salesforce application.

### Easier Testing

Each service can be tested according to its specific responsibilities.

### Scalability

The architecture provides a foundation for future features such as Triggers, SOQL, DML, and asynchronous processing.

---

# 🔄 Development Approach

This sprint follows an incremental development process:

```text id="v9o9iw"
Requirement
    ↓
Business Rule
    ↓
Service Design
    ↓
Method Definition
    ↓
Apex Implementation
    ↓
Testing
    ↓
Future Enhancement
```

The objective is not to implement every feature immediately.

Instead, the system is developed in small, understandable stages.

---

# 🧪 Example Business Scenario

Consider a student named Rahul who wants to apply for a software developer position.

The application receives:

```text
Student ID
Job ID
```

The service can eventually perform the following checks:

```text id="wq5j5e"
Receive Application
       ↓
Find Student
       ↓
Find Job
       ↓
Check Deadline
       ↓
Check CGPA
       ↓
Check Branch
       ↓
Check Backlogs
       ↓
Check Duplicate Application
       ↓
Create Application
```

Each step represents a business rule that can later be implemented using Apex, SOQL, and DML.

---

# 📂 Suggested Project Structure

```text id="e1m6gc"
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

As the project grows, additional classes such as selectors, handlers, and test classes can be introduced.

---

# 💡 Engineering Principles

This sprint introduced several important software engineering practices.

### 1. Understand Before Implementing

A developer should understand the business requirement before writing code.

### 2. Model Responsibilities Clearly

Each class should have a clear purpose.

### 3. Keep Methods Focused

A method should represent a meaningful business operation rather than performing unrelated tasks.

### 4. Use Meaningful Names

Names such as:

```text
ApplicationService
submitApplication()
checkEligibility()
```

communicate the intent of the code clearly.

### 5. Design for Change

Business requirements evolve. A good architecture should allow new rules to be added without rewriting the entire application.

### 6. Build Incrementally

Complex enterprise applications should be developed in manageable stages.

---

# 🎤 Interview Questions

This sprint provides a foundation for common Salesforce and software engineering interview questions:

1. What is business logic?
2. Why is business logic important in enterprise applications?
3. What is the difference between data storage and business logic?
4. Why should business requirements be understood before coding?
5. What is a Service Class in Apex?
6. Why should responsibilities be separated across classes?
7. What is the purpose of `ApplicationService`?
8. Why should methods have meaningful names?
9. What are the advantages of separating business logic?
10. How would you design an application eligibility service?
11. How would you prevent duplicate applications?
12. How would you validate an application deadline?
13. Why is incremental development useful?
14. How can service classes support future Trigger development?

---

# 🛠️ Technologies Used

* **Salesforce Platform**
* **Apex**
* **Salesforce Objects**
* **Salesforce Developer Console**
* **Visual Studio Code**
* **Salesforce CLI**

---

# 🚀 Future Development

The service classes created during this sprint provide the foundation for the next stages of development.

Future implementation will introduce:

* SOQL-based data retrieval
* DML-based record management
* Apex Triggers
* Trigger Handler Pattern
* Bulkification
* Governor Limits
* Test Classes
* Asynchronous Apex

The learning path progresses as follows:

```text id="w2e0r3"
Business Requirements
        ↓
Business Logic
        ↓
SOQL & DML
        ↓
Apex Triggers
        ↓
Bulk Processing
        ↓
Asynchronous Apex
```

---

# 📈 Key Takeaways

Sprint 4 represents the transition from **data modeling to application behavior**.

The most important lessons from this sprint are:

* Business requirements should guide implementation.
* Business rules are the decision-making layer of an application.
* Apex can be used to represent those rules.
* Service classes help organize business responsibilities.
* Clear architecture makes applications easier to maintain.
* Small, focused methods are easier to test and reuse.
* Good software design begins before the first line of production code is written.

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
* Business Logic Design
* Salesforce Automation
* Backend Development
* Enterprise Application Development

---

# ⭐ Sprint Summary

Sprint 4 established the **business logic layer** of the Placement Management System.

The application is no longer viewed only as a collection of Salesforce objects. It is beginning to behave like a real business application by understanding requirements, applying rules, and organizing functionality into dedicated services.

```text id="y8v7fq"
Store Information
       ↓
Understand Requirements
       ↓
Define Business Rules
       ↓
Design Services
       ↓
Implement Apex
       ↓
Build Enterprise Application
```

> **“Good software does not merely store information. It understands the rules that give that information meaning.”**

