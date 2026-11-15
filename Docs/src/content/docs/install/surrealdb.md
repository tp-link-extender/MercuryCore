---
title: SurrealDB
description: Details on how to install SurrealDB.
---

[SurrealDB](https://surrealdb.com) is a multi-model database that combines the flexibility of document databases with the power of graph databases. It is used as the main data storage mechanism for Mercury Core. Mercury Core targets [**SurrealDB 4.x**](https://github.com/surrealdb/surrealdb/releases).

Check out the [installation guide](https://surrealdb.com/docs/surrealdb/installation) for detailed instructions, or install the latest version on Linux or macOS with the following shell command:

```bash
curl -sSf https://install.surrealdb.com | sh
```

or on Windows with this command:

```powershell
iwr https://windows.surrealdb.com -useb | iex
```

Alternatively, it may be possible to install SurrealDB using a package manager of your choice.

SurrealDB should now be available as `surreal`. If not, you may have to restart your shell or add it to your path.

## Upgrading

To upgrade the `surreal` CLI and SurrealDB components, follow the [SurrealDB installation and upgrade instructions](https://surrealdb.com/docs/surrealdb/installation).

If you are upgrading an existing Mercury Core deployment from SurrealDB 3.x to 4.x, take and verify a database export before the first SurrealDB 4.x start. The 3.x to 4.0 in-place upgrade is experimental and one-way: start the first 4.x node with `SURREAL_EXPERIMENTAL_UPGRADE_FROM_3X=true`, then follow the [3.x to 4.0 migration guide](https://surrealdb.com/docs/build/migrating/from-old-surrealdb-versions/3x-to-4x). A fresh datastore created by 4.x does not need this flag.
