---
title: Database
description: Details on the database design and how the service is used in Mercury Core.
---

This page provides information about the database used in Mercury Core, including its design, structure, and how it integrates with other services.

Mercury Core uses [SurrealDB](https://surrealdb.com) as its primary database solution. 

## Startup

The following command can be used to start an instance of SurrealDB, assuming it's ran in the root directory of the Mercury Core repository.

```bash
surreal start -u=root -p=root surrealkv://data/surreal
```

This should produce output similar to the following:

```log
 .d8888b.                                             888 8888888b.  888888b.
d88P  Y88b                                            888 888  'Y88b 888  '88b
Y88b.                                                 888 888    888 888  .88P
 'Y888b.   888  888 888d888 888d888  .d88b.   8888b.  888 888    888 8888888K.
    'Y88b. 888  888 888P'   888P'   d8P  Y8b     '88b 888 888    888 888  'Y88b
      '888 888  888 888     888     88888888 .d888888 888 888    888 888    888
Y88b  d88P Y88b 888 888     888     Y8b.     888  888 888 888  .d88P 888   d88P
 'Y8888P'   'Y88888 888     888      'Y8888  'Y888888 888 8888888P'  8888888P'


2038-01-19T03:14:07.119628Z  INFO surreal::env: Running 2.4.0 for linux on x86_64
2038-01-19T03:14:07.120154Z  INFO surrealdb::core::kvs::ds: Starting kvs store at surrealkv://data/surreal
2038-01-19T03:14:07.120164Z  INFO surrealdb::core::kvs::surrealkv: Setting maximum segment size: 536870912
2038-01-19T03:14:07.120166Z  INFO surrealdb::core::kvs::surrealkv: Setting maximum value threshold: 64
2038-01-19T03:14:07.187947Z  INFO surrealdb::core::kvs::surrealkv: Setting maximum value cache size: 15304316928
2038-01-19T03:14:07.187968Z  INFO surrealdb::core::kvs::surrealkv: Wait for disk sync acknowledgement: false
2038-01-19T03:14:07.283928Z  INFO surrealdb::core::kvs::ds: Started kvs store at data/surreal with versions disabled
2038-01-19T03:14:07.284608Z  INFO surreal::dbs: Initialising credentials user=root
2038-01-19T03:14:07.284864Z  WARN surrealdb::core::kvs::ds: Credentials were provided, but existing root users were found. The root user 'root' will not be created
2038-01-19T03:14:07.284871Z  WARN surrealdb::core::kvs::ds: Consider removing the --user and --pass arguments from the server start command
2038-01-19T03:14:07.301045Z  INFO surrealdb::net: Listening for a system shutdown signal.
2038-01-19T03:14:07.301057Z  INFO surrealdb::net: Started web server on 127.0.0.1:8000
```

Omitting the `surrealkv://data/surreal` path argument will cause SurrealDB to use an in-memory database, which is useful for testing purposes. You may see a warning about the root user account already existing; which is normal if you have started the database before.

## Database inspection

A database management tool is available through the [Surrealist](https://app.surrealdb.com/) web interface, which can also be installed and run locally.

## Common issues

### Connection problems

SurrealDB supports connections via both HTTP (http://, https://) and WebSocket (ws://, wss://) protocols. Using the insecure versions should be fine if the service is running in local development or connected to from the Site hosted on the same machine, but if connecting remotely (such as to remotely manage the database on a VPS), the secure versions should be used. Add a domain configuration to the Caddyfile and change the default password to allow for this.

The WebSocket versions of the connection are broadly recommended over the HTTP versions, as they provide improved reliability and don't require re-authentication every 1 hour after connecting. If your connection seems to drop after being open for a long time (>1 hour), it may be over HTTP..

### Filesystem permissions

In some cases, the database may fail to start due to filesystem permission issues. This can occur if the user running the Mercury Core service does not have the necessary permissions to read or write to the database files.

An example of potential output could be as follows:

```log
2038-01-19T03:14:07.740481Z  INFO surreal::env: Running 2.4.0 for linux on x86_64
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
