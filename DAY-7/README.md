# 🚀 Sprint 10 – Building Components That Think Together

## Student Placement Portal – LWC Component Communication, Forms, LDS & Reusable Architecture

> **"A component becomes truly useful when it knows not only how to perform its own task, but also how to participate in a larger system."**

---

## 📌 Overview

Sprint 10 focuses on moving from isolated Lightning Web Components to a **coordinated, reusable, and maintainable LWC application architecture**.

In the previous sprint, the Student Placement Portal could retrieve jobs, apply for opportunities, execute Apex business logic, and persist data.

In this sprint, the application evolves into a collection of focused components that communicate through well-defined contracts.

The major focus areas are:

* Parent-to-child communication
* Child-to-parent communication
* Public properties using `@api`
* Custom events
* Event contracts
* Lightning base components
* Form handling
* Client-side validation
* Server-side validation
* Lightning Data Service (LDS)
* Reactive data
* Refresh strategies
* Loading, success, empty, and error states
* Reusable components
* Component ownership
* Avoiding unnecessary coupling
* Avoiding "God Components"
* Complete LWC application architecture

---

# 🎯 Sprint Objective

The objective of Sprint 10 is to transform the Student Placement Portal from a collection of screens into a **coordinated enterprise-style application**.

The final user journey should look like:

```text
Student Login
     ↓
Student Summary
     ↓
Update Profile
     ↓
Profile Saved
     ↓
Student Record Updated
     ↓
Eligible Jobs Refresh
     ↓
Select Job
     ↓
Job Details
     ↓
Apply
     ↓
Application Created
     ↓
My Applications Refresh
     ↓
Student Sees Updated Status
```

---

# 📚 Learning Outcomes

By the end of this sprint, the application demonstrates the ability to:

* Design an LWC application as a collection of focused components.
* Communicate data from parent to child.
* Communicate actions from child to parent.
* Use `@api` for public properties and methods.
* Create meaningful custom events.
* Design clear event contracts.
* Distinguish user intent from business outcomes.
* Build forms using Lightning base components.
* Perform client-side validation.
* Maintain server-side business validation.
* Use Lightning Data Service when appropriate.
* Understand when custom Apex is still required.
* Work with reactive data.
* Refresh dependent data after record updates.
* Handle loading states.
* Handle empty states.
* Handle success states.
* Handle error states.
* Build reusable components.
* Reduce unnecessary component coupling.
* Identify oversized components.
* Avoid "God Component" architecture.
* Explain complete data flow during a technical interview.

---

# 🏗️ Application Architecture

The Student Placement Portal is organized into focused components.

```text
StudentPortal
│
├── StudentSummary
│
├── StudentProfile
│
├── EligibleJobs
│   │
│   ├── JobCard
│   └── EmptyState
│
├── MyApplications
│   │
│   ├── ApplicationCard
│   └── EmptyState
│
└── OfferSummary
    │
    └── StatusBadge
```

Each component has a specific responsibility.

| Component         | Responsibility                             |
| ----------------- | ------------------------------------------ |
| `StudentPortal`   | Coordinates major application sections     |
| `StudentSummary`  | Displays student information               |
| `StudentProfile`  | Allows profile editing                     |
| `EligibleJobs`    | Displays jobs matching student eligibility |
| `JobCard`         | Displays an individual job                 |
| `MyApplications`  | Displays submitted applications            |
| `ApplicationCard` | Displays one application                   |
| `OfferSummary`    | Displays offer information                 |
| `StatusBadge`     | Reusable status display                    |
| `EmptyState`      | Reusable empty-state UI                    |

---

# 🔄 Component Communication

## 1. Parent → Child

Parent-to-child communication is used when the parent owns information that the child needs.

```text
Parent
   │
   │ data
   ↓
Child
```

Example:

### Parent JavaScript

```javascript
selectedJob;

handleViewDetails(event) {
    this.selectedJob = event.detail.jobId;
}
```

### Parent HTML

```html
<c-job-details
    job={selectedJob}>
</c-job-details>
```

### Child JavaScript

```javascript
import { LightningElement, api } from 'lwc';

export default class JobDetails extends LightningElement {
    @api job;
}
```

The child receives the information through a public property.

### Engineering Principle

> **Give a component what it needs instead of making it independently retrieve information that is already available.**

This improves:

* Data ownership
* Reusability
* Maintainability
* Testability
* Performance

---

# 📤 Child → Parent

A child should not directly modify the parent's state.

Instead, the child dispatches a custom event.

```text
Child
   │
   │ Custom Event
   ↓
Parent
```

Example:

```javascript
this.dispatchEvent(
    new CustomEvent('viewdetails', {
        detail: {
            jobId: this.job.Id
        }
    })
);
```

The parent listens for the event:

```html
<c-job-card
    job={job}
    onviewdetails={handleViewDetails}>
</c-job-card>
```

The parent then decides what should happen.

---

# 🎯 Event Contract

Events should communicate **facts and intent clearly**.

For example:

```text
applyclicked
```

may mean:

> The user clicked the Apply button.

It does **not** necessarily mean:

> The application was successfully created.

The successful application creation should only be communicated after the appropriate business logic and server operation succeed.

### Good Event Design

```text
Child:
"The user clicked Apply."

Parent:
"I will decide what that means."

Apex:
"I will validate and process the application."

Database:
"The record was successfully created."
```

### Engineering Principle

> **Distinguish user intent from business outcome.**

---

# 🧩 JobCard Communication

The reusable `JobCard` supports:

* View Details
* Apply
* Favorite (optional stretch challenge)

Example:

```javascript
handleViewDetails() {
    this.dispatchEvent(
        new CustomEvent('viewdetails', {
            detail: {
                jobId: this.job.Id
            }
        })
    );
}
```

The component does not directly modify parent state.

### Definition of Done

* Child does not directly change parent state.
* Child dispatches meaningful custom events.
* Parent handles events.
* Event names communicate business intent.
* `detail` contains only required information.
* Communication flow can be explained by another developer.

---

# 📝 Student Profile Form

The Student Profile component allows students to maintain their placement information.

## Fields

| Field              | Type      | Required |
| ------------------ | --------- | -------- |
| Name               | Text      | Yes      |
| Phone              | Text      | Yes      |
| Email              | Email     | Yes      |
| Branch             | Picklist  | Yes      |
| CGPA               | Number    | Yes      |
| Skills             | Long Text | No       |
| Preferred Location | Picklist  | No       |

---

# ⚡ Lightning Base Components

Instead of manually building HTML inputs, the application uses Salesforce Lightning base components.

Examples:

```html
<lightning-input>
</lightning-input>

<lightning-combobox>
</lightning-combobox>

<lightning-textarea>
</lightning-textarea>

<lightning-checkbox-group>
</lightning-checkbox-group>

<lightning-radio-group>
</lightning-radio-group>

<lightning-button>
</lightning-button>
```

### Engineering Principle

> **Reuse the platform before reinventing the platform.**

Lightning base components provide:

* Salesforce styling
* Accessibility support
* Standard behavior
* Built-in validation capabilities
* Consistent user experience

---

# ✅ Client-Side Validation

Client-side validation improves the user experience.

For example:

```text
CGPA must be between 0 and 10.
```

The browser can immediately notify the user if the value is invalid.

Example:

```javascript
validateForm() {
    const inputs = this.template.querySelectorAll(
        'lightning-input, lightning-combobox'
    );

    return [...inputs].reduce(
        (valid, input) => {
            input.reportValidity();
            return valid && input.checkValidity();
        },
        true
    );
}
```

---

# 🔐 Server-Side Validation

Client-side validation is **not security**.

A user can potentially bypass the UI and call backend logic through another client.

Therefore, important business rules must remain server-side.

```text
Client Validation
        ↓
Better User Experience

Server Validation
        ↓
Business Integrity
```

For example:

```text
Client:
CGPA must be between 0 and 10.

Server:
Student must satisfy the placement eligibility rules.
Student cannot apply twice for the same job.
Application must meet business requirements.
```

### Engineering Principle

> **Client validation improves UX. Server validation protects business integrity.**

---

# 🗄️ Lightning Data Service

Lightning Data Service (LDS) should be considered when working with Salesforce records where standard platform capabilities are sufficient.

LDS can reduce the need for custom Apex for common record operations.

Typical scenarios include:

* Loading records
* Displaying record fields
* Creating records
* Updating records
* Deleting records
* Keeping record data synchronized

---

# ⚖️ LDS vs Apex

The architecture should be selected based on the requirement.

| Requirement                        | Preferred Approach |
| ---------------------------------- | ------------------ |
| Standard record retrieval          | LDS / Wire         |
| Standard record update             | LDS                |
| Standard record creation           | LDS                |
| Simple record display              | LDS                |
| Complex business rules             | Apex               |
| Complex SOQL                       | Apex               |
| Multi-object business operation    | Apex               |
| Custom server-side validation      | Apex               |
| Transaction requiring custom logic | Apex               |

### Engineering Principle

> **Do not choose Apex simply because you know Apex. Choose the technology that best fits the requirement.**

---

# 🔄 Reactive Data

The Student record can affect multiple parts of the application.

```text
             Student Record
                   │
        ┌──────────┼──────────┐
        ↓          ↓          ↓
 StudentSummary  EligibleJobs  Applications
```

For example:

```text
Old CGPA = 7.4
New CGPA = 8.2
```

The student's eligible jobs may change.

If only one component updates, other components can display stale information.

---

# 🧠 Data Ownership

A major architectural concern is duplicate state.

Bad example:

```text
StudentSummary
CGPA = 8.1

EligibleJobs
CGPA = 7.9
```

The user now sees contradictory information.

The solution is to establish clear ownership.

Ask:

* Who owns the data?
* Who retrieves the data?
* Who modifies the data?
* Which components depend on it?
* How are dependent components refreshed?

### Engineering Principle

> **Data ownership must be clear.**

---

# 🔃 Refresh Strategy

After a successful profile update:

```text
Profile
   ↓
Student Record Updated
   ↓
Student Summary Refresh
   ↓
Eligible Jobs Refresh
   ↓
Updated Opportunities Displayed
```

Possible strategies include:

* Parent-owned state
* Custom events
* Wired data refresh
* LDS reactive behavior
* Record notifications
* Re-querying when genuinely necessary

The simplest architecture that keeps the UI consistent should be preferred.

---

# 🎨 UI State Management

Every major component should consider four important states.

## Loading

```text
Loading your profile...
```

or:

```text
Loading eligible jobs...
```

## Normal

Display the requested content.

## Success

```text
Profile updated successfully.
```

## Error

```text
We could not update your profile.
Please review the highlighted fields.
```

## Empty

```text
No eligible opportunities are available right now.

Keep your profile updated and check again as
new companies are added.
```

A polished application should communicate its current state clearly.

---

# ♻️ Reusable Components

Reusable components reduce duplication while keeping responsibilities focused.

## StatusBadge

Example:

```text
ApplicationCard
       ↓
   StatusBadge

InterviewCard
       ↓
   StatusBadge

OfferCard
       ↓
   StatusBadge
```

Possible API:

```html
<c-status-badge
    status={application.Status}>
</c-status-badge>
```

---

# 🧱 EmptyState Component

A reusable empty-state component can be used across the application.

Example:

```html
<c-empty-state
    title="No Eligible Jobs"
    message="Check again when new opportunities are added.">
</c-empty-state>
```

Possible inputs:

* Title
* Message
* Action Label

Optional event:

```text
EmptyState
    ↓
actionclicked
    ↓
Parent
```

The parent decides what should happen.

---

# 🚫 Avoiding the "God Component"

A dangerous architecture looks like:

```text
StudentPortal
      │
      ├── Everything
      │
      ├── All State
      │
      ├── All Events
      │
      ├── All Business Logic
      │
      └── All Data Retrieval
```

This creates a **God Component**.

Problems include:

* Hundreds of lines of code
* Too many responsibilities
* Difficult debugging
* High coupling
* Difficult testing
* Difficult reuse
* Difficult maintenance

A healthier structure is:

```text
StudentPortal
│
├── StudentSummary
├── StudentProfile
├── EligibleJobs
│   ├── JobCard
│   └── EmptyState
├── MyApplications
│   ├── ApplicationCard
│   └── EmptyState
└── OfferSummary
    └── StatusBadge
```

The parent coordinates while children maintain focused responsibilities.

---

# 🔍 Architecture Review Questions

Before completing the sprint, review the application using these questions:

### 1. Which components retrieve data?

Identify all components performing data retrieval.

### 2. Which components display data?

Separate data retrieval from presentation where appropriate.

### 3. Which components own state?

Every important piece of state should have a clear owner.

### 4. Which components only report events?

These components should communicate through custom events.

### 5. Where does business logic live?

Business-critical rules should remain in the appropriate server-side layer.

### 6. Are components retrieving the same information unnecessarily?

Avoid duplicate retrieval when data can be passed appropriately.

### 7. Are any components becoming too large?

If a component has multiple unrelated responsibilities, consider splitting it.

---

# 🔗 Complete Data Flow

The final application demonstrates the complete Salesforce application journey.

```text
User Interaction
      ↓
Lightning Web Component
      ↓
Custom Event / Public Property
      ↓
Parent Coordination
      ↓
Apex Controller
      ↓
Service Layer
      ↓
Business Rules
      ↓
SOQL / DML
      ↓
Salesforce Database
      ↓
Result
      ↓
Component State Update
      ↓
UI Refresh
```

For application submission:

```text
Click Apply
     ↓
JobCard
     ↓
applyclicked
     ↓
StudentPortal
     ↓
Apex
     ↓
Server-side Validation
     ↓
Application Service
     ↓
Database
     ↓
Application Created
     ↓
Success
     ↓
MyApplications Refresh
```

---

# 🏁 Final Integration Challenge

The completed application should support the following user journey:

```text
Student Login
      ↓
View Student Summary
      ↓
Open Profile
      ↓
Edit Profile
      ↓
Validate Fields
      ↓
Save Profile
      ↓
Student Record Updated
      ↓
Eligible Jobs Refresh
      ↓
Select Job
      ↓
View Job Details
      ↓
Click Apply
      ↓
Server Validation
      ↓
Application Created
      ↓
Success Message
      ↓
My Applications Refresh
      ↓
Updated Application Status
```

---

# ✅ Definition of Done

* [ ] Student can view their profile.
* [ ] Student can update their profile.
* [ ] Required fields are validated.
* [ ] Invalid values are handled.
* [ ] Server-side validation remains authoritative.
* [ ] Eligible Jobs reflect current student information.
* [ ] Job Cards are reusable.
* [ ] Parent-to-child communication is implemented.
* [ ] Child-to-parent communication uses custom events.
* [ ] Application submission works.
* [ ] Duplicate application attempts are handled.
* [ ] My Applications reflects newly created applications.
* [ ] Loading states are visible.
* [ ] Empty states are meaningful.
* [ ] Errors are handled professionally.
* [ ] Success states are communicated.
* [ ] Components have clear responsibilities.
* [ ] Unnecessary Apex has been avoided.
* [ ] LDS is used where appropriate.
* [ ] Apex is used where complex server-side logic is required.
* [ ] Data ownership is clearly defined.
* [ ] Refresh behavior is implemented.
* [ ] Complete data flow can be explained.

---

# 📂 Recommended GitHub Structure

```text
Sprint-10-LWC-Architecture/
│
├── README.md
│
├── architecture/
│   ├── component-tree.png
│   └── data-flow.png
│
├── force-app/
│   └── main/
│       └── default/
│           ├── classes/
│           ├── lwc/
│           ├── objects/
│           └── triggers/
│
├── screenshots/
│   ├── profile.png
│   ├── eligible-jobs.png
│   ├── application-success.png
│   └── empty-state.png
│
└── learning-notes/
    └── sprint-10.md
```

---

# 🧪 Testing Checklist

## Profile

* [ ] Profile loads correctly.
* [ ] Existing values are displayed.
* [ ] Required fields are identified.
* [ ] Invalid email is rejected.
* [ ] Invalid CGPA is rejected.
* [ ] Valid profile can be saved.
* [ ] Success message appears.
* [ ] Server-side validation works.
* [ ] Errors are displayed clearly.

## Eligible Jobs

* [ ] Eligible jobs load.
* [ ] Loading state appears.
* [ ] Empty state appears when there are no jobs.
* [ ] Job cards display correctly.
* [ ] View Details event works.
* [ ] Apply event works.
* [ ] Updated CGPA causes appropriate refresh.

## Applications

* [ ] Applications load.
* [ ] Application cards display correctly.
* [ ] New application appears after submission.
* [ ] Duplicate application is prevented.
* [ ] Loading state appears.
* [ ] Empty state appears.
* [ ] Errors are displayed correctly.

## Component Communication

* [ ] Parent passes data to child.
* [ ] Child dispatches events.
* [ ] Parent handles events.
* [ ] Children do not directly modify parent state.
* [ ] Event payload contains only required information.
* [ ] Event names clearly communicate intent.

---

# 🧠 Key Engineering Decisions

## Decision 1 – Parent-to-Child Communication

When the parent already owns the selected job, the job information is passed to the child rather than retrieved again unnecessarily.

**Reason:**

* Reduces duplicate data retrieval.
* Clarifies ownership.
* Makes the child more reusable.

---

## Decision 2 – Child-to-Parent Events

Child components communicate user actions through custom events.

**Reason:**

* Reduces coupling.
* Prevents direct parent manipulation.
* Allows the parent to determine the business response.

---

## Decision 3 – Client + Server Validation

Validation is performed at both levels where appropriate.

**Reason:**

* Client validation provides immediate feedback.
* Server validation protects business integrity.

---

## Decision 4 – LDS Before Custom Apex

LDS is considered for standard record operations before introducing custom Apex.

**Reason:**

* Reduces unnecessary custom code.
* Uses Salesforce platform capabilities.
* Simplifies record operations.

---

## Decision 5 – Reusable UI Components

Common UI behavior such as status indicators and empty states is extracted into reusable components.

**Reason:**

* Reduces duplication.
* Creates consistent UI.
* Improves maintainability.

---

# 💡 Interview Questions & Answers

## 1. How does a parent communicate data to a child?

A parent passes data to a child through public properties using `@api`.

```javascript
@api job;
```

The parent binds its data to the child:

```html
<c-job-details job={selectedJob}></c-job-details>
```

---

## 2. How does a child communicate an action to a parent?

The child dispatches a custom event.

```javascript
this.dispatchEvent(
    new CustomEvent('viewdetails', {
        detail: {
            jobId: this.job.Id
        }
    })
);
```

The parent listens for that event.

---

## 3. Why should a child not directly manipulate parent state?

Direct manipulation creates tight coupling between components.

Custom events allow the child to report what happened while allowing the parent to decide how to respond.

---

## 4. What is the purpose of `@api`?

`@api` exposes a public property or method that can be accessed by the component's parent.

It is commonly used for:

* Parent-to-child data communication
* Public child methods

---

## 5. What are custom events in LWC?

Custom events allow a child component to communicate information or user actions to its parent.

They are created using:

```javascript
new CustomEvent()
```

and dispatched using:

```javascript
this.dispatchEvent()
```

---

## 6. When would you use LDS instead of Apex?

I would prefer LDS when the requirement involves standard Salesforce record operations that LDS already supports.

I would use Apex when the requirement involves complex queries, business logic, multi-record operations, or custom server-side processing.

---

## 7. Why is client-side validation not sufficient?

Client-side validation can be bypassed.

Therefore, critical business rules must also be enforced server-side.

---

## 8. What is reactive data?

Reactive data means that when tracked or wired data changes, the framework can update dependent parts of the UI accordingly.

---

## 9. Why can a component show stale data after a successful update?

The Salesforce record may have been updated successfully while another component still holds an old copy of the data.

The dependent component may therefore require reactive updates, a wire refresh, LDS synchronization, or another appropriate refresh mechanism.

---

## 10. What is a reusable component?

A reusable component provides a focused capability that can be used by multiple parts of an application.

Examples:

```text
StatusBadge
EmptyState
JobCard
ApplicationCard
```

---

## 11. When does reuse become over-engineering?

Reuse becomes over-engineering when abstraction adds more complexity than it removes.

A component should not be made reusable merely because reuse is theoretically possible.

---

## 12. How should two sibling components communicate?

Sibling components should generally communicate through a common parent.

```text
Sibling A
    ↓
 Parent
    ↓
Sibling B
```

The parent coordinates the interaction instead of one child directly manipulating another.

For more complex applications, an appropriate shared communication mechanism can also be considered.

---

# 🎤 Interview Scenario

### Question

> Two LWCs are displayed on the same page. One updates a student's CGPA, while another displays eligible jobs. How would you ensure the second component reflects the new eligibility?

### Strong Answer

First, I would identify the ownership of the student data.

If the parent owns the student state, the profile component can notify the parent after a successful update. The parent can then coordinate the refresh of dependent components.

If the components use LDS or reactive wired data appropriately, the record update may automatically propagate. If the eligible-job query depends on the changed student information and does not automatically refresh, I would refresh the relevant wired data or retrieve the information again where necessary.

I would avoid creating unnecessary global state.

The important part is to ensure that:

```text
Student Update
      ↓
Source Data Changes
      ↓
Dependent Data Identified
      ↓
Eligible Jobs Refresh
      ↓
Updated Eligibility Displayed
```

The architecture should determine the specific refresh mechanism.

---

# 🐛 Debugging Example

### Problem

The profile was successfully updated, but Eligible Jobs still displayed opportunities based on the old CGPA.

### Investigation

1. Confirmed that the Student record was updated.
2. Checked whether the Eligible Jobs component had stale data.
3. Identified the data source used by Eligible Jobs.
4. Reviewed ownership of the Student record.
5. Checked whether the wired data was reactive.
6. Determined whether a refresh was required.
7. Updated the communication/refresh strategy.
8. Verified that Eligible Jobs reflected the updated CGPA.

### Lesson

> A successful database update does not automatically guarantee that every UI component has fresh data.

---

# 📊 Architecture Principles Learned

### Principle 1

> **Focused components are easier to maintain than giant components.**

### Principle 2

> **Children report events; parents coordinate behavior.**

### Principle 3

> **Give components the data they need.**

### Principle 4

> **Do not duplicate state unnecessarily.**

### Principle 5

> **Client validation improves UX; server validation protects business rules.**

### Principle 6

> **Use Salesforce platform capabilities before writing custom code.**

### Principle 7

> **Reusable components should represent meaningful capabilities.**

### Principle 8

> **A successful save does not guarantee a fresh UI.**

### Principle 9

> **Good event contracts distinguish intent from outcome.**

### Principle 10

> **Architecture should be explainable, not merely functional.**

---

# 📝 Sprint Retrospective

## 1. What did I learn about component communication?

I learned that LWC components should communicate through clear contracts rather than directly manipulating one another.

---

## 2. Where should business logic live?

Business-critical rules should remain in the appropriate server-side layer rather than relying only on JavaScript validation.

---

## 3. Which component has the clearest responsibility?

A good component has one primary responsibility and communicates with other components through well-defined interfaces.

---

## 4. Which component could become too large?

The parent should be monitored carefully. If it begins handling too much state, data retrieval, event processing, and business logic, responsibilities should be distributed.

---

## 5. Where did Salesforce platform capabilities replace custom code?

Lightning base components and Lightning Data Service can replace custom implementations when they meet the requirement.

---

## 6. How can inconsistent state be prevented?

Define clear data ownership and establish appropriate reactive or refresh mechanisms for dependent components.

---

## 7. Can the architecture be explained in three minutes?

The final architecture should be explainable from:

```text
User
 ↓
LWC
 ↓
Component Communication
 ↓
Apex / LDS
 ↓
Business Logic
 ↓
Database
 ↓
Refresh
 ↓
UI
```

---

# 📸 GitHub Evidence

The repository should contain evidence of the sprint implementation.

Recommended screenshots:

### `profile.png`

Student profile form showing:

* Existing values
* Editable fields
* Validation
* Save action

### `eligible-jobs.png`

Eligible Jobs screen showing reusable Job Cards.

### `application-success.png`

Successful application submission.

### `empty-state.png`

Meaningful empty state for no eligible opportunities.

### Architecture Diagrams

Include:

```text
architecture/component-tree.png
architecture/data-flow.png
```

---

# 🚀 Future Improvements

Potential extensions include:

* Interview scheduling
* Offer management
* Notifications
* Advanced application status tracking
* Placement officer dashboard
* Role-based actions
* External recruitment platform integration
* REST API integration
* Named Credentials
* External university system integration
* Integration monitoring

These capabilities prepare the application for the next stage of the project: **Salesforce APIs and Integration**.

---

# 🔮 Next Sprint

The next sprint moves beyond Salesforce boundaries.

The Placement Portal will need to communicate with external systems.

Topics will include:

```text
REST APIs
   ↓
HTTP Callouts
   ↓
Authentication
   ↓
Named Credentials
   ↓
Integration Patterns
   ↓
External Systems
```

The application will evolve from:

```text
Salesforce Application
```

into:

```text
Salesforce
     ↕
External Systems
```

---

# 🏆 Sprint 10 Completion

Sprint 10 represents an important transition from learning individual Salesforce technologies to understanding how those technologies cooperate.

The Student Placement Portal now demonstrates:

* Component architecture
* Parent-child communication
* Custom events
* Public properties
* Forms
* Validation
* LDS
* Apex
* Reactive data
* Refresh strategies
* Reusable components
* Loading states
* Empty states
* Error handling
* Success handling
* Clear data ownership
* Focused responsibilities

The project is no longer simply a collection of screens.

It is becoming a **real application architecture**.

---

## ⭐ Final Engineering Takeaway

> **Good applications are not built from isolated components. They emerge when focused components communicate through clear responsibilities, clear data ownership, and clear contracts.**

The goal of this sprint is not just to make the Student Placement Portal work.

The goal is to make it:

**Maintainable.
Reusable.
Testable.
Explainable.
Scalable.**

And most importantly, to be able to explain the complete journey:

```text
User
 ↓
LWC
 ↓
Event
 ↓
Parent
 ↓
Apex / LDS
 ↓
Service Layer
 ↓
Business Rules
 ↓
Database
 ↓
Result
 ↓
Refresh
 ↓
User
```

That is the difference between writing Salesforce code and **engineering a Salesforce application**.
