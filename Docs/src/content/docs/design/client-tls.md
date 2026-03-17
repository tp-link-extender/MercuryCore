---
title: Client TLS
description: Information about when and why TLS & HTTPS are used for communicating with the Client and Studio.
---

Transport Layer Security (TLS) is a cryptographic protocol that provides secure communication over a network. It is commonly used to encrypt data transmitted between clients and servers, ensuring confidentiality and integrity of the data. In the modern web, TLS is used as a part of HTTPS, and is essential for protecting user data and allowing the user to verify the identity of the server they are communicating with.

In the context of Mercury, it would be best to use TLS and HTTPS for all communication between the Site and the Client and Studio. However, this is often not possible due to technical limitations of the Client and Studio. Due to this, Mercury Core takes a flexible approach to allow TLS to be used as much as possible, while minimising risk of security issues when it cannot be used.

## TLS versions

A table of various TLS versions is provided below.

Version | Year released | Status
-- | -- | --
1.0 | 1999 | Deprecated in 2021
1.1 | 2006 | Deprecated in 2021
1.2 | 2008 | Widely supported, no plans for deprecation
1.3 | 2018 | Widely supported, latest version

Later versions of TLS provide improved security and performance. The [Caddy](/install/caddy) web server used by Mercury Core does not support deprecated versions of TLS (as of Caddy 2, see Caddy issues [#2819](https://github.com/caddyserver/caddy/issues/2819) and [#3667](https://github.com/caddyserver/caddy/issues/3667) for more info). However, some older Clients may not support TLS 1.2 or later, so it may be necessary to introduce a different external proxy server or load balancer that supports older TLS versions if support for these Clients is desired.

## Unencrypted subdomain

By default, Mercury Core is configured to host the Site on the root domain (eg. *example.com*), which is always encrypted with HTTPS, and an unencrypted subdomain (eg. *<www.example.com>*) is used only for communication with the Client and Studio. This allows the Site to always be accessed securely by users through their web browsers, while still allowing systems that don't support TLS to communicate with the unencrypted subdomain.

The unencrypted subdomain should never be used for Site access from a web browser. This is why a separate subdomain is the recommended approach. Under proper configuration of Mercury Core, any user attempting to access the Site through an unencrypted connection will not be able to submit any information in forms to minimise the risk of sensitive data being intercepted.
