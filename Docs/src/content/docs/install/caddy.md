---
title: Caddy
description: Details on how to install Caddy.
---

[Caddy](https://caddyserver.com) is a web server used as a reverse proxy for the Mercury Core Site service. At the time of writing, the latest version is **v2.10.2**.

Check out the [installation guide](https://caddyserver.com/docs/install) for detailed instructions.

## Upgrading

To upgrade Caddy to the latest version without going through the reinstallation process, run the following command:

```bash
caddy upgrade
```

You may need to run this command as an administrator or with `sudo` depending on your installation method. If you're using a package manager, refer to its documentation for upgrade instructions.

After upgrading, restart any running Caddy services to use the new version.
