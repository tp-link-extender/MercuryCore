---
title: Bun
description: Details on how to install Bun.
---

[Bun](https://bun.sh) is a Javascript runtime used for running the Site service, and facilitates management and installation of dependencies. At the time of writing, the latest version is [**v1.3.1**](https://bun.com/blog/bun-v1.3).

Check out the [installation guide](https://bun.com/docs/installation) for detailed instructions, or install the latest version on Linux or macOS with the following shell command:

```bash
curl -fsSL https://bun.sh/install | bash
```

or on Windows with this command:

```powershell
powershell -c "irm bun.sh/install.ps1 | iex"
```

Alternatively, it may be possible to install Bun using a package manager of your choice.

Bun should now be available as `bun`. If not, you may have to restart your shell or add it to your path.

## Upgrading

To upgrade Bun to the latest version without going through the reinstallation process, run the following command:

```bash
bun upgrade
```

You may need to run this command as an administrator or with `sudo` depending on your installation method. If you're using a package manager, refer to its documentation for upgrade instructions.

After upgrading, restart any running instances of Bun to use the new version.
