---
title: Installation
description: Tools needed to use and develop Mercury Core, and how to install them.
---

This page describes how to install and manage the tools for development and production environments for Mercury Core.


In the near future, we may provide a tool for setting up and installing the necessary tools automatically. Please let us know if you would find that helpful.

## Baseline tools

These are the tools always needed to run a complete Mercury Core setup, regardless of the environment.

- [Bun](/install/bun)

For the remaining tools, choose whether or not you wish to use containers:

### If using containers

If you plan to use containers for development or production, you can install one of the container managers listed below instead of installing its tools directly.

- [Docker](/install/docker)
- [Podman](/install/podman)

### If not using containers

For running without containers, install the following tools directly.

- [SurrealDB](/install/surrealdb)
- [Go](/install/go)

## Development tools

To set up a development environment, install all tools from the [Baseline tools](#baseline-tools) section, as well as the following.

- [Go](/install/go)
	- It's possible to use the container instead if developing the Economy service, though this will be slower to start than compiling and running it directly with Go.

## Production tools

To set up a production environment, install all tools from the [Baseline tools](#baseline-tools) section, as well as the following.

- [Caddy](/install/caddy)
