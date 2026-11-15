---
title: Database
description: Details on the database design and how the service is used in Mercury Core.
---

This page provides information about the database used in Mercury Core, including its design, structure, and how it integrates with other services.

Mercury Core uses [SurrealDB](https://surrealdb.com) as its primary database solution. By default, Surreal is started on port 8000, and will fail to start if that port is already in use. If you have started the database before, it may already be running in the background, and you may wish to stop it before starting a new instance.

## Credentials

The Site doesn't connect as root. It uses a database user (`site` by default) that can only use the `main` database, with the `EDITOR` role: it can read and write data and change the schema there, but can't define users, switch namespace or reach anything at root level. Three environment variables are involved:

- `DATABASE_ROOT_PASSWORD`: SurrealDB's root password. Only the database and the setup step need it.
- `DATABASE_USER` (default `site`) and `DATABASE_PASSWORD`: what the Site connects with. The Site refuses to start without a password.

Passwords must be at least 32 characters of letters, digits, underscores and hyphens, as SurrealDB doesn't accept parameters in `DEFINE USER`, so they are written into the statement. Generate each one with `openssl rand -hex 32`.

The setup step, `bun run db:setup` in the **Site** directory, signs in as root and:

1. defines the `main` namespace and the `main` database (`STRICT`)
2. defines or updates the Site's user with `DATABASE_PASSWORD`
3. changes root's password to `DATABASE_ROOT_PASSWORD` if it is still the old default, `root`
4. checks that the Site's user can sign in, and fails if `root`/`root` still works

It is safe to run more than once. Pass `--url ws://host:port` if the database isn't at `ws://localhost:8000`, and `--add-only` to skip step 3 (see [Moving an existing database](#moving-an-existing-database)).

When `Database.AutoStart` is on, the Site starts SurrealDB and runs the setup itself, so local development only needs the three variables in **Site/.env**. In compose, the one-shot `database-setup` service runs it before the Site starts.

:::caution
`surreal start` only uses `SURREAL_PASS` (or `-p`) to create the root user of a new store. On an existing store it logs "existing root users were found" and keeps the old password. Changing the password in the environment therefore doesn't change it in the database; the setup step does that with `ALTER USER`.
:::

## Startup

The following command can be used to start an instance of SurrealDB, assuming it's ran in the root directory of the Mercury Core repository. The root password is passed in the environment rather than with `-p`, so it doesn't show up in `ps`.

```bash
SURREAL_USER=root SURREAL_PASS="$DATABASE_ROOT_PASSWORD" surreal start --bind=127.0.0.1:8000 surrealkv://data/surreal
```

Then run `bun run db:setup` in the **Site** directory.

SurrealDB listens on loopback only by default, so it is not reachable from other hosts. Container deployments in **compose.yml** keep the published port on `127.0.0.1` and use `--bind=0.0.0.0:8000` inside the container, which lets other containers reach it over the compose network without exposing it publicly.

This should produce output indicating the SurrealKV store started and the web server is listening, for example:

```log
INFO surreal::dbs: Initialising credentials user=root
INFO surrealdb::net: Started web server on 127.0.0.1:8000
INFO surrealdb::net: Listening for a system shutdown signal.
```

The exact banner and log lines vary between SurrealDB releases. If you are upgrading an existing 3.x datastore in place, the first 4.x start needs `SURREAL_EXPERIMENTAL_UPGRADE_FROM_3X=true` and may take longer while the data is migrated.

Omitting the `surrealkv://data/surreal` path argument will cause SurrealDB to use an in-memory database, which is useful for testing purposes. You may see a warning about the root user account already existing; which is normal if you have started the database before.

## Moving an existing database

A database set up before this change has root's password set to `root`, and the running Site signs in with it. Changing root's password first would lock that Site out, so move in this order:

1. Take an export of the database (`surreal export`) and check it.
2. Generate `DATABASE_ROOT_PASSWORD` and `DATABASE_PASSWORD` with `openssl rand -hex 32` and add them, with `DATABASE_USER=site`, to wherever the Site's environment comes from (see below).
3. Run `bun run db:setup --add-only` in the **Site** directory. This adds the Site's user and leaves root alone, so the old Site keeps working.
4. Deploy the new Site and check that it starts and serves pages.
5. Run `bun run db:setup` without `--add-only`. It changes root's password and checks that `root`/`root` is refused.
6. Update the database service's own root password setting (`SURREAL_PASS`, or `-p` if it is still on the command line) to the new password, so it matches if the store is ever recreated.
7. Check that the Economy tools still connect (see [Economy tools](#economy-tools)).

If the Site starts SurrealDB itself (`Database.AutoStart`), it runs the full setup every time it starts, so steps 3 to 5 happen together when the new Site starts. Nothing else is signed in as root then, so that's safe, but take the export first and put `DATABASE_ROOT_PASSWORD` in the Site's environment before deploying.

The compose `database-setup` service does steps 3 and 5 at once. That's right for a new install, but don't let it be the first thing to run against an existing database: run `--add-only` by hand first.

### systemd

Put the variables in an environment file only the service's user can read, such as **/etc/mercury/site.env** with mode `0600`, and load it from the unit:

```ini
[Service]
WorkingDirectory=/path/to/MercuryCore/Site
EnvironmentFile=/etc/mercury/site.env
ExecStart=/usr/bin/env bun -b ./build
```

Run setup with the same file, for example `sudo -u mercury sh -c 'set -a; . /etc/mercury/site.env; bun run db:setup --add-only'`, then `systemctl daemon-reload` and `systemctl restart` the Site. If SurrealDB has its own unit, give it `Environment=SURREAL_USER=root` and `SURREAL_PASS` from a root-only environment file instead of `-p=root` in `ExecStart`.

### pm2

pm2 starts the Site from the **Site** directory, where Bun loads **Site/.env**, so add the variables there (keep it `0600`) rather than in **ecosystem.config.js**, which is in source control. Run `bun run db:setup --add-only` in the same directory, then `bun x pm2 restart Mercury`.

### Compose

Add the variables to the **.env** file next to **compose.yml**. For an existing database, run the setup by hand before bringing up the new Site:

```bash
docker compose run --rm database-setup --add-only
docker compose up -d --build site
```

Once the Site is working, `docker compose run --rm database-setup` changes root's password.

## Economy tools

The `migrate` and `prune` commands in **Economy/cmd** sign in as `DATABASE_USER` (default `site`) with `DATABASE_PASSWORD` from the environment, as a user of `--namespace`/`--database`. Pass `--surreal-user root` to sign in as root instead, which reads `DATABASE_ROOT_PASSWORD`. `--surreal-pass` still works but puts the password on the command line.

## Database inspection

A database management tool is available through the [Surrealist](https://app.surrealdb.com/) web interface, which can also be installed and run locally.

## Common issues

### Connection problems

SurrealDB supports connections via both HTTP (http://, https://) and WebSocket (ws://, wss://) protocols. Using the insecure versions should be fine if the service is running in local development or connected to from the Site hosted on the same machine, but if connecting remotely (such as to remotely manage the database on a VPS), the secure versions should be used. Add a domain configuration to the Caddyfile to allow for this.

The WebSocket versions of the connection are broadly recommended over the HTTP versions, as they provide improved reliability and don't require re-authentication every 1 hour after connecting. If your connection seems to drop after being open for a long time (>1 hour), it may be over HTTP..

### Filesystem permissions

In some cases, the database may fail to start due to filesystem permission issues. This can occur if the user running the database service does not have the necessary permissions to read or write to the database files.

An example of potential output could be as follows:

```log
ERROR surrealdb_server::cli: There was a problem with the datastore: IO error: Permission denied (os error 13)
```
