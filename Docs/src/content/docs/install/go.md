---
title: Go
description: Details on how to install Go.
---

[Go](https://go.dev) is a programming language and toolchain for building and managing software. It is used for parts of certain Mercury Core services. At the time of writing, the latest version is [**v1.26.0**](https://github.com/golang/go/releases/tag/go1.26.0).

To install, download the latest [binary release](https://go.dev/dl/) and follow the installation instructions. Alternatively, it may be possible to install Go using a package manager of your choice.

## Upgrading

To upgrade Go to the latest version without going through the reinstallation process, update the **go.mod** file in the project's directory and change the Go version:

```
module whatever

go 1.26.0
```

Upon the next build or run command, Go will automatically download and use the specified version. However, changing the Go version in a **go.mod** file may prevent older versions of Go from building the project, even if newer features aren't used, which could be required if an older Go version is required to work with an older system or CPU architecture. If you run into any issues with Go versions, please file an issue on the [GitHub repository](https://github.com/tp-link-extender/MercuryCore/issues) so we can help out.

Alternatively, your editor may support changing or switching between Go versions, or have an available extension/plugin for doing so. If you're using a package manager, refer to its documentation for upgrade instructions.
