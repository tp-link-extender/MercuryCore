---
title: SurrealDB
description: Details on how to install SurrealDB.
---

[SurrealDB](https://surrealdb.com) is a multi-model database that combines the flexibility of document databases with the power of graph databases. It is used as the main data storage mechanism for Mercury Core. At the time of writing, the latest version is **v2.3.8**.

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

To upgrade SurrealDB to the latest version without going through the reinstallation process, run the following command:

```bash
surreal upgrade
```

You may need to run this command as an administrator or with `sudo` depending on your installation method. If you're using a package manager, refer to its documentation for upgrade instructions.
