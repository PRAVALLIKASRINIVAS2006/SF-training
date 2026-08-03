# Sprint 4 – Building Business Logic with Apex

## Overview

Sprint 4 focuses on introducing business logic into the Placement Management System using Apex. Instead of simply storing data, the application begins making business decisions based on predefined rules. The sprint emphasizes understanding business requirements before writing code and organizing the application using service classes.

## Learning Objectives

After completing this sprint, I learned to:

* Understand the importance of business logic in enterprise applications.
* Identify business rules from customer requirements.
* Differentiate between data storage and business decision-making.
* Design Apex classes based on business responsibilities.
* Understand why software architecture should be planned before implementation.
* Prepare business services for future Apex development.

---

## Part 1 – Understanding Business Logic

The Placement Management System can store student and job information, but it also needs to make business decisions automatically.

Some business rules include:

* Reject applications submitted after the deadline.
* Prevent duplicate applications.
* Validate student eligibility based on CGPA, branch, and backlogs.
* Ensure companies do not create duplicate job postings.

The key principle learned is:

```text
Understand the business
        ↓
Identify business rules
        ↓
Design the solution
        ↓
Implement using Apex
```

---

## Part 2 – Designing the Application

Before writing any Apex code, the application is divided into separate services based on business responsibilities.

### StudentService

Responsible for:

* Registering students
* Updating student information
* Verifying academic details
* Checking placement status

### JobService

Responsible for:

* Creating job postings
* Updating eligibility criteria
* Publishing jobs
* Closing expired opportunities

### ApplicationService

Responsible for:

* Receiving applications
* Checking eligibility
* Preventing duplicate applications
* Saving valid applications
* Returning meaningful messages

This separation of responsibilities improves readability, maintainability, and scalability.

---

## Part 3 – Preparing for Apex Implementation

The business design is translated into Apex by creating service classes and methods.

The primary service introduced in this sprint is:

```apex
public class ApplicationService {

}
```

The first business method is:

```apex
public void submitApplication(Id studentId, Id jobId){

}
```

This method represents the business activity of submitting a student application. The parameters identify the student and the selected job, while future implementations will include validation and record creation.

---

## Engineering Principles Learned

* Understand business requirements before writing code.
* One class should represent one business responsibility.
* One method should perform one business activity.
* Use meaningful class and method names.
* Design first, implement later.
* Build software incrementally.

---

## Technologies Used

* Salesforce Platform
* Apex
* Salesforce Developer Console
* Visual Studio Code

---

## Conclusion

Sprint 4 introduced the concept of business logic in Salesforce applications. Instead of focusing only on syntax, the sprint emphasized understanding business requirements, designing service classes, and preparing for Apex implementation. These principles form the foundation for developing scalable and maintainable Salesforce applications.
