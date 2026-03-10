---
title: Database
description: Details on the database design and how the service is used in Mercury Core.
---

This page provides information about the database used in Mercury Core, including its design, structure, and how it integrates with other services.

Mercury Core uses [SurrealDB](https://surrealdb.com) as its primary database solution. By default, Surreal is started on port 8000, and will fail to start if that port is already in use. If you have started the database before, it may already be running in the background, and you may wish to stop it before starting a new instance.

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


2038-01-19T03:14:07.640032Z  INFO surrealdb_server::env: Running 3.0.1 for linux on x86_64
2038-01-19T03:14:07.640049Z  INFO surrealdb::core::kvs::ds: Starting kvs store at relative path surrealkv://data/surreal
2038-01-19T03:14:07.640649Z  INFO surrealdb::core::kvs::surrealkv: Enabling value log separation: true
2038-01-19T03:14:07.740677Z  INFO surrealdb::core::kvs::surrealkv: Setting value log max file size: 268435456
2038-01-19T03:14:07.740689Z  INFO surrealdb::core::kvs::surrealkv: Setting value log threshold: 4096
2038-01-19T03:14:07.740691Z  INFO surrealdb::core::kvs::surrealkv: Versioning enabled: false with retention period: 0ns
2038-01-19T03:14:07.740692Z  INFO surrealdb::core::kvs::surrealkv: Versioning with versioned_index: false
2038-01-19T03:14:07.816428Z  INFO surrealdb::core::kvs::surrealkv: Setting block cache capacity: 15303714816
2038-01-19T03:14:07.816442Z  INFO surrealdb::core::kvs::surrealkv: Setting block size: 65536
2038-01-19T03:14:07.816465Z  INFO surrealkv::lsm: === Starting LSM tree initialization ===
2038-01-19T03:14:07.816467Z  INFO surrealkv::lsm: Database path: "data/surreal"
2038-01-19T03:14:07.816527Z  INFO surrealkv::levels: Loading manifest from "data/surreal/manifest/00000000000000000000.manifest"
2038-01-19T03:14:07.816609Z  INFO surrealkv::levels: Manifest loaded successfully: version=1, log_number=9, last_sequence=18926, tables=9, levels=6
2038-01-19T03:14:07.816727Z  INFO surrealkv::lsm: Manifest state: log_number=9, last_sequence=18926
2038-01-19T03:14:07.816731Z  INFO surrealkv::wal::recovery: Starting WAL recovery from directory: "data/surreal/wal"
2038-01-19T03:14:07.816742Z  INFO surrealkv::wal::recovery: Replaying WAL segments #00000000000000000009 to #00000000000000000009
2038-01-19T03:14:07.816984Z  INFO surrealkv::wal::recovery: WAL recovery complete: 0 batches across 0 segments, 0 memtables created, max_seq_num=None
2038-01-19T03:14:07.817046Z  INFO surrealkv::lsm: === LSM tree initialization complete ===
2038-01-19T03:14:07.841220Z  INFO surrealdb::core::kvs::surrealkv: Sync mode: every transaction commit
2038-01-19T03:14:07.841236Z  INFO surrealdb::core::kvs::surrealkv: Grouped commit: enabled (timeout=5000000ns, wait_threshold=12, max_batch_size=4096)
2038-01-19T03:14:07.841298Z  INFO surrealdb::core::kvs::ds: Started surrealkv kvs store
2038-01-19T03:14:07.841805Z  INFO surreal::dbs: Operation succeeded operation="check_version" attempts=1
2038-01-19T03:14:07.842192Z  INFO surreal::dbs: Initialising credentials user=root
2038-01-19T03:14:07.842565Z  WARN surrealdb::core::kvs::ds: Credentials were provided, but existing root users were found. The root user 'root' will not be created
2038-01-19T03:14:07.842585Z  INFO surreal::dbs: Operation succeeded operation="initialise_credentials" attempts=1
2038-01-19T03:14:07.842576Z  WARN surrealdb::core::kvs::ds: Consider removing the --user and --pass arguments from the server start command
2038-01-19T03:14:07.972126Z  INFO surreal::dbs: Operation succeeded operation="Insert node" attempts=1
2038-01-19T03:14:07.973186Z  INFO surreal::dbs: Operation succeeded operation="Expire nodes" attempts=1
2038-01-19T03:14:07.975329Z  INFO surreal::dbs: Operation succeeded operation="Remove nodes" attempts=1
2038-01-19T03:14:07.979977Z  INFO surrealdb::net: Started web server on 127.0.0.1:8000
2038-01-19T03:14:07.980039Z  INFO surrealdb::net: Listening for a system shutdown signal.
```

Omitting the `surrealkv://data/surreal` path argument will cause SurrealDB to use an in-memory database, which is useful for testing purposes. You may see a warning about the root user account already existing; which is normal if you have started the database before.

## Database inspection

A database management tool is available through the [Surrealist](https://app.surrealdb.com/) web interface, which can also be installed and run locally.

## Common issues

### Connection problems

SurrealDB supports connections via both HTTP (http://, https://) and WebSocket (ws://, wss://) protocols. Using the insecure versions should be fine if the service is running in local development or connected to from the Site hosted on the same machine, but if connecting remotely (such as to remotely manage the database on a VPS), the secure versions should be used. Add a domain configuration to the Caddyfile and change the default password to allow for this.

The WebSocket versions of the connection are broadly recommended over the HTTP versions, as they provide improved reliability and don't require re-authentication every 1 hour after connecting. If your connection seems to drop after being open for a long time (>1 hour), it may be over HTTP..

### Filesystem permissions

In some cases, the database may fail to start due to filesystem permission issues. This can occur if the user running the database service does not have the necessary permissions to read or write to the database files.

An example of potential output could be as follows:

```log
2038-01-19T03:14:07.436374Z  INFO surrealdb_server::env: Running 3.0.1 for linux on x86_64
2038-01-19T03:14:07.436400Z  INFO surrealdb::core::kvs::ds: Starting kvs store at relative path surrealkv://data/surreal
2038-01-19T03:14:07.437518Z  INFO surrealdb::core::kvs::surrealkv: Enabling value log separation: true
2038-01-19T03:14:07.521204Z  INFO surrealdb::core::kvs::surrealkv: Setting value log max file size: 268435456
2038-01-19T03:14:07.521216Z  INFO surrealdb::core::kvs::surrealkv: Setting value log threshold: 4096
2038-01-19T03:14:07.521217Z  INFO surrealdb::core::kvs::surrealkv: Versioning enabled: false with retention period: 0ns
2038-01-19T03:14:07.521218Z  INFO surrealdb::core::kvs::surrealkv: Versioning with versioned_index: false
2038-01-19T03:14:07.591389Z  INFO surrealdb::core::kvs::surrealkv: Setting block cache capacity: 15303714816
2038-01-19T03:14:07.591404Z  INFO surrealdb::core::kvs::surrealkv: Setting block size: 65536
2038-01-19T03:14:07.591810Z ERROR surrealdb_server::cli: There was a problem with the datastore: IO error: Permission denied (os error 13)
Goodbye!
[process exited with code 1]
```
