# 🚀 Sprint 11 – Crossing the Salesforce Boundary

## Salesforce APIs, REST Integration, Named Credentials & External Systems

> **"A good Salesforce application does not live in isolation. It knows what belongs inside the platform, what belongs outside it, and how the two should communicate safely."**

---

## 📌 Sprint Overview

Sprint 11 focuses on **Salesforce Integration Engineering**.

Until this sprint, the Placement Management System operated primarily inside Salesforce using:

* Lightning Web Components
* Apex
* SOQL
* DML
* Triggers
* Service Classes
* Queueable Apex
* Batch Apex

In this sprint, the application crosses the Salesforce boundary and communicates with an **external recruitment platform**.

The major architectural change is:

```text
Salesforce ↔ External Recruitment System
```

The goal is to understand how Salesforce can securely communicate with external systems using **REST APIs, Apex Callouts, Named Credentials and asynchronous processing**.

---

# 🎯 Sprint Objective

The objective of this sprint is to design and prototype an external recruitment integration for the Placement Management System.

When a student's application becomes **Selected**, Salesforce should send the candidate information to an external recruitment platform.

### Business Flow

```text
Student Application
        ↓
     Selected
        ↓
      Trigger
        ↓
     Service
        ↓
   Queueable Apex
        ↓
   Named Credential
        ↓
     REST API
        ↓
External Recruitment System
        ↓
   Process Response
        ↓
Integration Status
```

---

# 📚 Learning Outcomes

By completing this sprint, I learned how to:

* Understand APIs as contracts between systems
* Understand REST APIs
* Work with HTTP methods
* Understand HTTP request and response structures
* Read and construct JSON
* Perform Salesforce HTTP callouts
* Understand asynchronous callouts using Queueable Apex
* Use Named Credentials
* Understand authentication and authorization
* Understand Auth Providers
* Handle API failures
* Design retry strategies
* Understand idempotency
* Track integration status
* Understand Salesforce Connect
* Understand External Objects
* Compare point-to-point and middleware integration
* Choose synchronous vs asynchronous integration
* Design an integration architecture
* Document an API contract
* Prepare for Salesforce integration interview questions

---

# 🔑 Key Concepts

## 1. API

An **API (Application Programming Interface)** is a contract that allows two software systems to communicate.

For example:

```text
Salesforce
    ↓
POST /candidates
    ↓
External Recruitment API
    ↓
Response
    ↓
Salesforce
```

The two systems do not need to understand each other's internal implementation.

They only need to follow the agreed API contract.

---

# 2. REST API

REST is a common approach for building web APIs using HTTP.

### Important HTTP Methods

| Method | Typical Purpose             |
| ------ | --------------------------- |
| GET    | Retrieve data               |
| POST   | Create/process data         |
| PUT    | Replace/update a resource   |
| PATCH  | Partially update a resource |
| DELETE | Delete a resource           |

Example:

```text
GET    /jobs
GET    /jobs/123
POST   /applications
PATCH  /applications/123
```

The HTTP method communicates the intended operation.

---

# 3. HTTP Request & Response

An API request generally contains:

```text
REQUEST
 ├── HTTP Method
 ├── Endpoint
 ├── Headers
 ├── Authentication
 └── Body
```

The external system returns:

```text
RESPONSE
 ├── Status Code
 ├── Headers
 └── Body
```

---

# 4. HTTP Status Codes

Important status codes covered in this sprint:

| Status Code | Meaning                                  |
| ----------- | ---------------------------------------- |
| 200         | Successful request                       |
| 201         | Resource created                         |
| 204         | Successful request with no response body |
| 400         | Bad Request                              |
| 401         | Authentication failure                   |
| 403         | Forbidden                                |
| 404         | Resource not found                       |
| 500         | Server-side error                        |

The integration should interpret these responses rather than treating every failure identically.

---

# 5. JSON

JSON is a common format for exchanging data between APIs.

### Example Candidate JSON

```json
{
  "studentId": "STU10045",
  "name": "Ananya",
  "email": "ananya@example.com",
  "branch": "CSE",
  "cgpa": 8.4,
  "jobId": "JOB1007",
  "company": "KSquare",
  "role": "Salesforce Developer"
}
```

JSON contains:

* Objects
* Keys
* Values
* Arrays

Salesforce can serialize Apex objects into JSON before sending them to an external API.

---

# 6. Apex HTTP Callouts

Salesforce provides Apex classes for making HTTP requests.

The basic flow is:

```text
HttpRequest
     ↓
Configure Request
     ↓
Http
     ↓
send()
     ↓
HttpResponse
```

Conceptually:

```apex
HttpRequest request = new HttpRequest();

request.setEndpoint(
    'callout:Recruitment_API/candidates'
);

request.setMethod('POST');

request.setHeader(
    'Content-Type',
    'application/json'
);

request.setBody(
    JSON.serialize(candidate)
);

Http http = new Http();

HttpResponse response = http.send(request);
```

### Important Components

| Component    | Responsibility                  |
| ------------ | ------------------------------- |
| HttpRequest  | Represents outgoing request     |
| Endpoint     | Specifies destination           |
| Method       | Specifies operation             |
| Headers      | Provides additional information |
| Body         | Contains data                   |
| Http         | Sends request                   |
| HttpResponse | Contains external response      |

---

# 🔐 7. Named Credentials

Credentials should **never be hard-coded in Apex**.

### ❌ Bad Practice

```apex
request.setHeader(
    'Authorization',
    'Bearer abc123'
);
```

Hard-coded credentials can:

* Leak into Git
* Appear in code reviews
* Be copied accidentally
* Become difficult to rotate
* Create security vulnerabilities

### ✅ Better Architecture

```text
Apex
 ↓
Named Credential
 ↓
Authentication
 ↓
External API
```

Named Credentials separate **configuration and authentication from business logic**.

The Apex code can focus on:

> "Which API operation should I perform?"

rather than:

> "Where should I store the secret?"

---

# 🔑 8. Authentication vs Authorization

These concepts are different.

### Authentication

**Who are you?**

Example:

```text
Are these credentials valid?
```

### Authorization

**What are you allowed to do?**

Example:

```text
Does this authenticated user have permission
to create candidates?
```

### Easy Interview Trick

```text
Authentication → Identity
Authorization  → Permissions
```

---

# 9. Auth Providers

Auth Providers can help Salesforce handle authentication with supported external identity providers.

The architecture can be understood as:

```text
External Identity Provider
          ↓
     Auth Provider
          ↓
Authentication Configuration
          ↓
    Named Credential
          ↓
      Apex Callout
          ↓
     External API
```

The exact configuration depends on the external authentication protocol.

---

# ⚙️ 10. Queueable Apex for Callouts

The candidate synchronization should not unnecessarily block the user's transaction.

Recommended architecture:

```text
Application Selected
        ↓
      Trigger
        ↓
     Service
        ↓
   Queueable Apex
        ↓
    HTTP Callout
        ↓
 External Recruitment API
```

### Why Queueable?

Because the external system:

* May be slow
* May be temporarily unavailable
* May return errors
* Is outside Salesforce's control
* Does not necessarily need to respond before the user continues

This keeps the primary Salesforce transaction separate from secondary external communication.

---

# 🔄 11. Transaction & Callout Considerations

A key architectural principle is:

```text
Essential Salesforce Work
          ↓
       Commit
          ↓
    Queueable Apex
          ↓
     HTTP Callout
```

The Salesforce business transaction should establish the important business truth first.

The external synchronization can then happen asynchronously.

---

# 📊 12. Integration Status Tracking

Salesforce success does **not automatically mean** external-system success.

Therefore, integration state should be tracked.

Example fields:

```text
Integration_Status__c
External_Candidate_Id__c
Last_Integration_Attempt__c
Integration_Error__c
```

### Possible Status Flow

```text
Pending
   ↓
Queueable
   ↓
Success ─────→ Sent
   ↓
Failure
   ↓
Retry Required
```

This allows administrators to identify failed integrations.

---

# 🚨 13. Error Handling

The integration should distinguish different failures.

```text
API Response
     ↓
 ┌───┴───────────────┐
 ↓                   ↓
Success             Failure
                     ↓
       ┌─────────────┼─────────────┐
       ↓             ↓             ↓
      400           401/403        500
 Bad Request    Authentication   Server Error
                    / Access
```

The system should not simply say:

```text
Something went wrong.
```

It should understand what the external system reported.

---

# 🔁 14. Retry Strategy

Suppose the external API returns:

```text
500 Internal Server Error
```

The failure may be temporary.

Instead of permanently failing the synchronization:

```text
Failed
  ↓
Retry Required
  ↓
Retry
  ↓
Success
```

However, retries introduce another important problem:

## Idempotency

---

# 🛡️ 15. Idempotency

Idempotency means that processing the same business request multiple times should not unintentionally create duplicate results.

### Problem

Suppose Salesforce sends:

```text
Candidate STU10045
```

The external system creates the candidate.

But Salesforce does not receive the response because of a network problem.

Salesforce retries.

The external system receives the candidate again.

Without an idempotency strategy:

```text
STU10045
    ↓
Candidate A created

Retry
    ↓
Candidate B created
```

Now there are duplicates.

### Possible Solutions

Use:

* Salesforce Application Id
* External Reference Id
* Idempotency Key
* Existing-record lookup
* Synchronization status

---

# 🌐 16. Salesforce Connect & External Objects

Not every external dataset needs to be copied into Salesforce.

Sometimes Salesforce users only need to **access external data**.

Conceptually:

```text
External System
      ↓
External Object
      ↓
Salesforce
      ↓
Salesforce Users
```

### Copy Data

```text
External System
      ↓
Integration
      ↓
Salesforce Records
```

Advantages:

* Salesforce reporting
* Salesforce automation
* Local data access
* Native Salesforce processing

Disadvantages:

* Data duplication
* Synchronization complexity
* Storage requirements
* Stale data risk

### External Objects

External Objects can be useful when:

* Data volume is very large
* External system owns the data
* Salesforce mainly needs access to the data
* Copying the entire dataset is unnecessary

---

# 🏗️ 17. Point-to-Point Integration

In point-to-point integration, Salesforce communicates directly with an external system.

```text
Salesforce
     ↕
External System
```

### Advantages

* Simple
* Easy to understand
* Suitable for a small number of systems

### Challenge

As the number of systems increases, direct integrations can become difficult to maintain.

---

# 🔌 18. Middleware Integration

Middleware provides an integration layer between Salesforce and multiple systems.

```text
              Salesforce
                  ↕
              Middleware
             ↙    ↓    ↘
          HR   Finance  ERP
```

Middleware can provide:

* Routing
* Transformation
* Orchestration
* Monitoring
* Retry handling
* Protocol conversion

This becomes useful when enterprise integration complexity increases.

---

# ⏱️ 19. Synchronous vs Asynchronous Integration

## Synchronous

```text
Salesforce
    ↓
External API
    ↓
Response
    ↓
Salesforce
```

Use when the user needs the result immediately.

### Example

Certification number verification.

```text
LWC
 ↓
Apex
 ↓
External API
 ↓
Verification Result
 ↓
LWC
```

---

## Asynchronous

```text
Salesforce
    ↓
Queueable
    ↓
External API
```

Use when the user does not need to wait.

### Example

Candidate synchronization after selection.

```text
Trigger
   ↓
Queueable
   ↓
External API
```

---

# 🧩 20. Integration Architecture

The main architecture developed in this sprint is:

```text
┌──────────────────────┐
│ Student Application  │
└──────────┬───────────┘
           ↓
     Application
      Selected
           ↓
       Trigger
           ↓
        Service
           ↓
    Queueable Apex
           ↓
    Named Credential
           ↓
       REST API
           ↓
┌──────────────────────┐
│ External Recruitment │
│       Platform       │
└──────────┬───────────┘
           ↓
      HTTP Response
           ↓
   Integration Status
```

---

# 🧪 21. Integration Scenarios

## Scenario A – Immediate Verification

```text
LWC
 ↓
Apex
 ↓
External API
 ↓
Response
 ↓
LWC
```

### Choice

**Synchronous integration**

### Reason

The user needs the result immediately.

---

## Scenario B – Candidate Synchronization

```text
Trigger
 ↓
Queueable
 ↓
External API
```

### Choice

**Asynchronous integration**

### Reason

The user does not need to wait for the external system.

---

## Scenario C – 200,000 Record Synchronization

```text
Scheduled Apex
      ↓
Batch Apex
      ↓
External API
      ↓
Error Handling
      ↓
Retry Strategy
```

### Choice

**Scheduled + Batch + Integration architecture**

A large dataset should not be processed as one synchronous user transaction.

---

# 📋 22. API Contract

The integration API contract should document:

### Endpoint

```text
POST /candidates
```

### Request

```json
{
  "studentId": "STU10045",
  "name": "Ananya",
  "email": "ananya@example.com",
  "branch": "CSE",
  "cgpa": 8.4,
  "jobId": "JOB1007",
  "company": "KSquare",
  "role": "Salesforce Developer"
}
```

### Expected Responses

```text
201 → Candidate Created
400 → Invalid Request
401 → Authentication Failure
403 → Forbidden
500 → External Server Error
```

The complete contract should be maintained in:

```text
api-contract/
└── candidate-api.md
```

---

# 🗂️ 23. Project Structure

```text
Sprint-11-Integration/
│
├── README.md
│
├── architecture/
│   ├── integration-flow.png
│   ├── sequence-diagram.png
│   └── integration-pattern.png
│
├── force-app/
│   └── main/
│       └── default/
│
├── api-contract/
│   └── candidate-api.md
│
├── screenshots/
│
├── learning-notes/
│
└── sprint-11.md
```

---

# 🔨 24. Mini Project – External Recruitment Gateway

The Sprint 11 project implements an **External Recruitment Gateway**.

### Requirement 1 – Send Selected Candidates

```text
Application
    ↓
Selected
    ↓
Queueable
    ↓
External API
```

---

### Requirement 2 – Track Integration Status

Recommended fields:

```text
Integration Status
External Candidate Id
Last Integration Attempt
Integration Error
```

---

### Requirement 3 – Secure Authentication

Use:

```text
Named Credential
```

Do not store:

```text
Username
Password
Access Token
API Secret
```

directly inside Apex.

---

### Requirement 4 – Handle Responses

The integration should handle:

```text
Success
400
401
403
500
Unexpected Error
```

---

### Requirement 5 – Retry

Document:

```text
What happens when the external API is temporarily unavailable?
```

Example:

```text
Failed
  ↓
Retry Required
  ↓
Queueable Retry
  ↓
Success
```

---

### Requirement 6 – Prevent Duplicates

Document:

```text
What uniquely identifies the candidate submission?
```

Possible solution:

```text
Salesforce Application Id
```

or another agreed external reference.

---

# 🧠 25. Engineering Principles Learned

### Principle 1

> **An API is a contract, not just an HTTP request.**

### Principle 2

> **Do not hard-code credentials in Apex.**

### Principle 3

> **Separate business commitment from external communication when appropriate.**

### Principle 4

> **External systems can fail. Design for failure.**

### Principle 5

> **Retries require idempotency.**

### Principle 6

> **Salesforce success does not automatically mean external-system success.**

### Principle 7

> **Choose synchronous or asynchronous integration based on the business requirement.**

### Principle 8

> **Architecture should scale with the number of systems.**

### Principle 9

> **Data ownership determines whether data should be copied or accessed externally.**

### Principle 10

> **Configuration should be separated from business code.**

---

# 💼 26. Interview Questions Prepared

This sprint prepared me for common Salesforce integration questions:

1. What is an API?
2. What is REST?
3. Difference between GET and POST?
4. What is JSON?
5. What is an HTTP status code?
6. What is an Apex callout?
7. Why should credentials not be hard-coded?
8. What is a Named Credential?
9. Authentication vs Authorization?
10. What is an Auth Provider?
11. What are Salesforce Connect and External Objects?
12. What is point-to-point integration?
13. Why is middleware useful?
14. When should integration be asynchronous?
15. What is idempotency?
16. Why is Queueable Apex useful for callouts?
17. What happens when an external API is unavailable?
18. How would you design retry handling?
19. How would you prevent duplicate external records?
20. How would you monitor failed integrations?

---

# 🎯 27. Key Interview Architecture

### Scenario

> When an Opportunity becomes Closed Won, Salesforce must send customer information to an external ERP. The user should not wait for the ERP.

### Solution

```text
Opportunity Updated
       ↓
Trigger
       ↓
Service Layer
       ↓
Queueable Apex
       ↓
Named Credential
       ↓
REST API
       ↓
External ERP
       ↓
Response
       ↓
Integration Status
```

### Additional considerations

* Authentication
* Error handling
* Retry
* Idempotency
* Duplicate prevention
* Monitoring
* Integration status

---

# 📝 28. Sprint Deliverables

* [ ] Define external recruitment API contract
* [ ] Define candidate request JSON
* [ ] Define response structure
* [ ] Document HTTP status codes
* [ ] Create CandidateSyncQueueable
* [ ] Configure Named Credential
* [ ] Build HTTP request
* [ ] Serialize candidate data as JSON
* [ ] Send REST callout
* [ ] Process API response
* [ ] Track integration status
* [ ] Track external candidate ID
* [ ] Track last integration attempt
* [ ] Track integration errors
* [ ] Design retry strategy
* [ ] Design idempotency strategy
* [ ] Document synchronous vs asynchronous decisions
* [ ] Document point-to-point vs middleware decision
* [ ] Document Salesforce Connect considerations
* [ ] Add architecture diagrams
* [ ] Add screenshots
* [ ] Complete sprint learning notes

---

# 📈 29. What I Learned

The biggest lesson from Sprint 11 is that integration is not simply:

```apex
http.send(request);
```

A production-ready integration must consider:

```text
API Contract
     +
Authentication
     +
Authorization
     +
Security
     +
Timeouts
     +
Error Handling
     +
Retries
     +
Idempotency
     +
Monitoring
     +
Data Ownership
```

An integration is a **business conversation between two independent systems**.

---

# 🚀 Final Architecture

The Placement Management System has now evolved into an enterprise-style Salesforce application:

```text
                    ┌───────────────┐
                    │   Students    │
                    └───────┬───────┘
                            ↓
                    Lightning Web
                      Components
                            ↓
                       Apex Services
                            ↓
              ┌─────────────┴─────────────┐
              ↓                           ↓
       Salesforce DB                Async Apex
              ↓                    Queueable/Batch
          Triggers                       ↓
              ↓                    Named Credential
              ↓                           ↓
              └──────────────→ External APIs
                                          ↓
                                 External Systems
```

---

# 🏆 Sprint 11 Outcome

By the end of Sprint 11, the Placement Management System has crossed from being a **Salesforce-only application** to an **integrated enterprise application**.

The application can now conceptually:

* Communicate with external systems
* Consume REST APIs
* Send JSON payloads
* Perform Apex callouts
* Secure integrations with Named Credentials
* Process external communication asynchronously
* Handle API failures
* Retry temporary failures
* Prevent duplicate submissions
* Track synchronization status
* Access external data using External Objects
* Scale integrations using middleware architecture

---

## 🔑 Final Takeaway

> **An integration is successful not when one API call works, but when two independent systems can continue working correctly even when the other system does not.**

### Salesforce Architecture Journey

```text
LWC
 ↓
Apex
 ↓
SOQL / DML
 ↓
Triggers
 ↓
Service Layer
 ↓
Queueable / Batch
 ↓
REST Integration
 ↓
Named Credentials
 ↓
External Systems
```

**Sprint 11 completed: Salesforce Integration Engineering.**

**Next:** Salesforce Development, Git, Salesforce CLI, Metadata, Sandboxes, Scratch Orgs and Deployment Engineering.
