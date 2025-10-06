---
title: Podman
description: Details on how to install Podman.
---

[Podman](https://podman.io) is a container management tool that is compatible with Docker. Its commands can be used interchangeably with Docker's, making it easy to switch between the two.

For a graphical interface, you can install [Podman Desktop](https://podman-desktop.io/downloads). For a command line only experience, just install [Podman](https://podman.io/docs/installation) on its own.

After installation, Podman should be available from the command line with `podman`.

## Virtualisation

Podman requires a virtualisation system to be enabled on your machine to run. This usually means enabling virtualization in your motherboard's UEFI/BIOS settings. Depending on your CPU, this may be called VT-x (Intel) or SVM (AMD), or something else, sometimes found under advanced CPU or security settings.
