---
title: Database
description: Details on the database design and how the service is used in Mercury Core.
---

This page provides information about the database used in Mercury Core, including its design, structure, and how it integrates with other services.

## Database inspection

Mercury Core uses [SurrealDB](https://surrealdb.com) as its primary database solution. A database management tool is available through the [Surrealist](https://app.surrealdb.com/) web interface, which can also be installed and run locally.

## Common issues

### Connection problems

SurrealDB supports connections via both HTTP (http://, https://) and WebSocket (ws://, wss://) protocols. Using the insecure versions should be fine if the service is running in local development or connected to from the Site hosted on the same machine, but if connecting remotely (such as to remotely manage the database on a VPS), the secure versions should be used. Add a domain configuration to the Caddyfile and change the default password to allow for this.

The WebSocket versions of the connection are broadly recommended over the HTTP versions, as they provide improved reliability and don't require re-authentication every 1 hour after connecting. If your connection seems to drop after being open for a long time (>1 hour), it may be over HTTP..

### Filesystem permissions

In some cases, the database may fail to start due to filesystem permission issues. This can occur if the user running the Mercury Core service does not have the necessary permissions to read or write to the database files.

An example of potential output could be as follows:

```log
2038-01-19T03:14:07.740481Z  INFO surreal::env: Running 2.3.7 for linux on x86_64
2038-01-19T03:14:07.741021Z  INFO surrealdb::core::kvs::ds: Starting kvs store at surrealkv://data/surreal
2038-01-19T03:14:07.741047Z  INFO surrealdb::core::kvs::surrealkv: Setting maximum segment size: 536870912
2038-01-19T03:14:07.741051Z  INFO surrealdb::core::kvs::surrealkv: Setting maximum value threshold: 64
2038-01-19T03:14:07.805631Z  INFO surrealdb::core::kvs::surrealkv: Setting maximum value cache size: 15304321024
2038-01-19T03:14:07.805646Z  INFO surrealdb::core::kvs::surrealkv: Wait for disk sync acknowledgement: false
2038-01-19T03:14:07.805673Z  INFO surrealdb::core::kvs::ds: Started kvs store at surreal with versions disabled
2038-01-19T03:14:07.805687Z ERROR surreal::cli: There was a problem with the database: There was a problem with the underlying datastore: Log error: IO error: kind=permission denied, message=Permission denied (os error 13)
Goodbye!
[process exited with code 1]
```
