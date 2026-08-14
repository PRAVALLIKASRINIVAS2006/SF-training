# Apex Security Review

## Overview

Apex is the server-side programming language used to implement business logic in Salesforce.

Because Apex can query, create, update, and delete Salesforce records, Apex code must be reviewed carefully to ensure that it does not unintentionally bypass the Salesforce security model.

This review focuses on:

- Apex sharing behavior
- Object-level security
- Field-Level Security
- Record-level security
- CRUD and FLS enforcement
- SOQL security
- DML security
- User input validation
- LWC-to-Apex security
- Sensitive data exposure

---

## 1. Security Objectives

The Apex implementation should ensure that:

1. Users access only authorised records.
2. Users access only authorised fields.
3. Users perform only authorised operations.
4. Sensitive information is not unnecessarily exposed.
5. Apex does not unnecessarily bypass record-sharing rules.
6. Security does not depend only on the LWC interface.
7. Knowing a Salesforce record Id does not automatically grant access.
8. Important business operations are validated server-side.

---

## 2. Apex Sharing Model

Apex classes should have an intentional sharing declaration.

### With Sharing

Example:

```apex
public with sharing class ApplicationService {
    
}
