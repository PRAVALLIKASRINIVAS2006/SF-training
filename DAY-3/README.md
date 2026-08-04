# Sprint 6 – Apex Triggers

## Overview

In this sprint, I learned about **Apex Triggers** and how they are used to automate business processes in Salesforce. Until this point, the application performed actions only when users explicitly requested them. With Apex Triggers, the application can automatically respond whenever important business events occur, making the system more efficient and reducing manual effort.

This sprint mainly focused on understanding the purpose of triggers, when they should execute, and how to design them using Salesforce best practices. I also learned why keeping triggers simple and moving business logic into service classes results in a cleaner and more maintainable application.

---

## Learning Objectives

After completing this sprint, I am able to:

- Understand the concept of event-driven automation.
- Explain the purpose of Apex Triggers.
- Identify business events that require automatic processing.
- Differentiate between Before and After triggers.
- Design triggers using clean architecture principles.
- Delegate business logic to service classes.
- Build scalable and maintainable Salesforce applications.

---

## What I Learned

One of the biggest takeaways from this sprint is that **a Trigger is not responsible for implementing business logic**. Its responsibility is simply to detect when a business event occurs and then call the appropriate service class.

Instead of writing validation, calculations, email logic, and database operations inside a trigger, these responsibilities should be handled by dedicated service classes. This approach improves code readability, makes testing easier, and allows future enhancements without modifying the trigger itself.

I also understood that good software should not depend on users remembering every step. Whenever an important business event occurs, the application should automatically perform all required actions.

---

## Business Scenario

The sprint uses a Placement Management System as an example.

Suppose a student's application status changes to **Selected**.

Instead of asking the Placement Officer to manually perform several tasks, the system should automatically:

- Update the student's placement status.
- Refresh placement statistics.
- Notify the Placement Officer.
- Send a congratulatory email to the student.
- Update dashboards and reports.
- Record important information for future reference.

This scenario helped me understand how automation improves productivity and reduces the possibility of human error.

---

## Understanding Apex Triggers

An Apex Trigger is a piece of code that executes automatically whenever a record is created, updated, deleted, or restored.

Rather than waiting for user instructions, triggers respond immediately to changes in Salesforce data.

Some common business events include:

- A new student registers.
- A company posts a job opportunity.
- A student submits an application.
- An interview result is updated.
- A placement offer is accepted.

Each of these events can automatically start one or more business processes.

---

## Trigger Responsibilities

A well-designed Trigger should only:

- Detect business events.
- Identify whether records are inserted, updated, or deleted.
- Pass control to the appropriate service class.

A Trigger should **not**:

- Perform complex validation.
- Write business calculations.
- Send emails directly.
- Update multiple unrelated objects.
- Contain hundreds of lines of code.

Keeping triggers lightweight makes them easier to understand and maintain.

---

## Service Class Responsibilities

The actual business logic belongs inside service classes.

Examples include:

- **ApplicationService** – Validates student applications.
- **StatisticsService** – Updates placement reports and dashboards.
- **NotificationService** – Sends emails and notifications.
- **StudentService** – Updates student-related information.

This separation of responsibilities follows good software engineering practices and improves code reusability.

---

## Before vs After Triggers

### Before Trigger

Before Triggers execute before a record is saved to the database.

Typical use cases:

- Validate student eligibility.
- Prevent duplicate applications.
- Verify mandatory fields.
- Reject invalid data.

### After Trigger

After Triggers execute after the record has been successfully saved.

Typical use cases:

- Send confirmation emails.
- Update dashboards.
- Refresh placement statistics.
- Notify users.
- Create audit records.

Understanding when to use each trigger type is important for implementing business requirements correctly.

---

## Sprint Activities

During this sprint, I explored the following concepts:

### User Story 13 – Validate Applications

Designed a trigger that automatically validates application records before they are saved by calling `ApplicationService`.

### User Story 14 – Update Placement Statistics

Designed the trigger to notify `StatisticsService` whenever an application status changes to **Selected**.

### User Story 15 – Send Notifications

Delegated notification functionality to `NotificationService` so that communication remains separate from trigger logic.

### User Story 16 – Maintain Clean Architecture

Ensured that all business logic remains inside service classes while triggers stay simple and focused.

### User Story 17 – Design for Future Enhancements

Learned how a well-designed trigger architecture allows new requirements to be implemented by simply adding new service classes without changing existing triggers.

---

## Best Practices Followed

- Keep triggers short and readable.
- Write only one trigger per object.
- Move business logic to service classes.
- Avoid duplicate validation logic.
- Design reusable and scalable components.
- Follow separation of responsibilities.
- Write code that is easy for other developers to understand.

---

## Challenges and Understanding

Initially, I assumed that triggers were responsible for performing all business operations. After completing this sprint, I realized that professional Salesforce development follows a different approach.

Triggers simply identify **what happened**, while service classes decide **what should happen next**. This separation keeps the application organized and makes future maintenance much easier.

I also learned that a single business event can trigger multiple independent processes without making the trigger itself complicated.

---

## Key Takeaways

- Automation improves business efficiency.
- Apex Triggers respond automatically to record events.
- Business logic should never be placed directly inside triggers.
- Service classes improve maintainability and code reuse.
- Before and After triggers are chosen based on business timing.
- Small and simple triggers are easier to maintain than large, complex ones.
- Good architecture allows future requirements to be added with minimal code changes.

---

## Conclusion

Sprint 6 helped me understand how Salesforce applications become more intelligent through automation. More importantly, it introduced me to the architectural principles followed in real-world Salesforce projects.

Instead of writing lengthy trigger code, I learned to build clean, modular, and reusable solutions by separating trigger logic from business logic. This design approach makes applications easier to maintain, extend, and understand, which is an essential skill for every Salesforce Developer.
