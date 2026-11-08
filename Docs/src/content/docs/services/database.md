---
title: Database
description: Details on the database design and how the service is used in Mercury Core.
---

This page provides information about the database used in Mercury Core, including its design, structure, and how it integrates with other services.

Mercury Core uses [SurrealDB](https://surrealdb.com) as its primary database solution. By default, Surreal is started on port 8000, and will fail to start if that port is already in use. If you have started the database before, it may already be running in the background, and you may wish to stop it before starting a new instance.

## Startup

The following command can be used to start an instance of SurrealDB, assuming it's ran in the root directory of the Mercury Core repository.

```bash
surreal db start --bind=127.0.0.1:8000 -u=root -p=root surrealkv://data/surreal
```

SurrealDB listens on loopback only by default, so it is not reachable from other hosts. Container deployments in **compose.yml** keep the published port on `127.0.0.1` and use `--bind=0.0.0.0:8000` inside the container, which lets other containers reach it over the compose network without exposing it publicly.

This should produce output indicating the SurrealKV store started and the web server is listening, for example:

```log
INFO surreal::dbs: Initialising credentials user=root
INFO surrealdb::net: Started web server on 127.0.0.1:8000
INFO surrealdb::net: Listening for a system shutdown signal.
```

The exact banner and log lines vary between SurrealDB releases. If you are upgrading an existing 3.x datastore in place, the first 4.x start needs `SURREAL_EXPERIMENTAL_UPGRADE_FROM_3X=true` and may take longer while the data is migrated.

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
ERROR surrealdb_server::cli: There was a problem with the datastore: IO error: Permission denied (os error 13)
```
