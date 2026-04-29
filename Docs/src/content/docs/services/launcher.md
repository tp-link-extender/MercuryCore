---
title: Launcher
description: Information about the Launcher, the application responsible for starting and handling Client sessions.
---

This page provides information about the Mercury Launcher, responsible for downloading, installing, and unpacking Setup deployment packages. It also registers itself with the operating system to handle file associations, and should open when any place is joined from the Site, then launching the Client. An implementation of the Launcher is available at the [tp-link-extender/MercuryLauncher](https://github.com/tp-link-extender/MercuryLauncher) repository.

With the modularity of the Mercury Suite, it is not required to use this implementation of the Launcher alongside Mercury Core, and a custom implementation or other launcher can be used instead. However, the custom Setup deployment format is designed to be used with the Launcher, and isn't compatible with the 'standard' deployment format.

## Configuration

The Launcher can be configured by modifying the [**Config.fs**](https://github.com/tp-link-extender/MercuryLauncher/blob/main/Config.fs) file in the root of the repository. This includes options for the name of the Launcher, the domain name used for loading Setup packages and provided to the Client for communication with the Site, and the icon shown in the Launcher UI. Once this file is updated, the Launcher will need to be recompiled or republished for the changes to take effect.

## Building

See the [Launcher setup](/guides/launchersetup) page for instructions on building the Launcher.

Any executables published by the building process are ~21MB in size and do not require any existing installation of the .NET SDK or runtime to run, as they are self-contained. These production builds do not contain any debug symbols. Build configuration can be modified by editing the [**MercuryLauncher.fsproj**](https://github.com/tp-link-extender/MercuryLauncher/blob/main/MercuryLauncher.fsproj) file.
