---
title: Site
description: Details on the Site service, the main part of Mercury Core that users interact with.
---

This page provides information about the Site service in Mercury Core, including its functionality, features, and how it integrates with other services.

## Startup

A development server can be started with `bun dev`. This will start the server in development mode (by default on port 5173), enabling features like hot-reloading for easier development. For a production preview, run `bun run build` followed by `bun preview` (or both at once by using `bun run buildview`). This will start a production preview server (by default on port 4173). The ports for these services will automatically increment by 1 if the default ports are already in use until a free port is found. The development server starting on an unexpected port is an indication that there is probably already a development server running, and you may wish to stop it before starting a new one.

For a full production deployment, run `bun run build` followed by `bun -b ./build`. The server will be started on the port specified in your **.env** file. We use port 4443, and if not specified the default is 3000, though this can be changed to any port you wish.

On successful startup, the Site will display output similar to the following:

```
Starting SurrealDB...
Starting Economy service (../Economy/Economy)...
connecting to database
reloaded surrealdb-3.0.1

  ██▙    ▟██ Started
  ███▙  ▟███ ▟████▙ ▗████▛▗█████▌██   ██ ▟████▙▝█▙    ▗█▛
  ██▝█▙▟█▘██▐█▌  ▐█▌██▘   ██▘    ██   ██▐█▛     ▝█▙  ▗█▛
  ██ ▝██▘ ██▐█████▛ ██    ██     ██   ██▐█▌      ▝█▙▗█▛
  ██      ██▐█▌     ██    ██▖    ██▖ ▗██▐█▌       ▝██▛
  ▛▀      ▜█ ▜████▛ ██    ▝█████▙▝█████▘▐█▌       ▗█▛
  ▗██████▛                                       ▗█▛
  ██▘    ▗█████▖ ▟████▛▗█████▖                  ▗█▛
  ██     ██   ██▐█▛    ██   ██ Self-hostable MMO
  ██     ██   ██▐█▌    ██████▘ game creation platform:
  ██▖    ██   ██▐█▌    ██      Build-your-own-Roblox
  ▝█████▙▝█████▘▐█▌    ▝█████▘

Successfully loaded configuration file
```

![Output on successful startup of Site](../../../assets/startup.png)

## Economy authentication

If you run the Site and Economy service outside containers, the Site reads `ECONOMY_KEY` from **Site/.env** and passes it to the Economy service when auto-starting it. If you start the Economy service yourself, set the same `ECONOMY_KEY` in its environment. The service refuses to start without a key and rejects any request that doesn't carry it. It listens on `127.0.0.1:2009` by default; pass `-addr :2009` only when another container must reach it over a container network.

For compose deployments, set `ECONOMY_KEY` in a **.env** file next to **compose.yml** (copy **.env.example** and replace the value); compose passes it to both containers and keeps the Economy port bound to loopback.
