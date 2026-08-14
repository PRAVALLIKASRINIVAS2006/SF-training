# Salesforce Security – Field-Level Security

## Overview

Field-Level Security (FLS) controls whether a user can access a specific field on a Salesforce object.

A user may have access to an Application record without automatically having access to every field on that record.

The Placement Management System therefore uses Field-Level Security to protect sensitive placement information.

---

# 1. Security Layers

Salesforce security can be viewed as three major layers:

```text
Object-Level Security
        ↓
Can the user access the object?
        ↓
Field-Level Security
        ↓
Can the user access the field?
        ↓
Record-Level Security
        ↓
Can the user access this specific record?
