---
title: IDs
description: Design of unique identifiers used in Mercury Core.
---

IDs are used throughout Mercury systems to identify a variety of entities. They are essential in any database or service to uniquely identify records, facilitate relationships between entities, and ensure data integrity. This page outlines the design principles and formats for IDs used in Mercury Core.

## String identifiers

The most common type of ID used in Mercury is a 20-character lowercase alphanumeric string. These are the [default random IDs used in SurrealDB](https://surrealdb.com/docs/surrealql/datamodel/ids#random-ids), as well as when using the [`rand::id()` function](https://surrealdb.com/docs/surrealql/functions/database/rand#randid) and are used as the primary identifiers for most entities in the system.
An example of such an ID is as follows:

```
a1b2c3d4e5f6g7h8i9j0
```

In Mercury Core, these types of IDs are most visible in the URLs for comments and groups, place server and private tickets, and registration keys. While not visible for other entities, they are still used as the main identifiers for record lookups, even if other fields are used for display purposes.
