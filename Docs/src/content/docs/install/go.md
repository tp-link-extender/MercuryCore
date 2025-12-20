---
title: Go
description: Details on how to install Go.
---

[Go](https://go.dev) is a programming language and toolchain for building and managing software. It is used for parts of certain Mercury Core services. At the time of writing, the latest version is [**v1.25.5**](https://github.com/golang/go/releases/tag/go1.25.5).

To install, download the latest [binary release](https://go.dev/dl/) and follow the installation instructions. Alternatively, it may be possible to install Go using a package manager of your choice.

## Upgrading

To upgrade Go to the latest version without going through the reinstallation process, update the **go.mod** file in the project's directory and change the Go version:

```
module whatever

go 1.25.4
```

Upon the next build or run command, Go will automatically download and use the specified version. If you're using a package manager, refer to its documentation for upgrade instructions.
