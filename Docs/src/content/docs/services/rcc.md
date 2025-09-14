---
title: RCCService
description: Information about how RCCService works with Mercury Core and how it integrates with a revival platform.
---

This page provides information about the RCCService (Roblox Cloud Compute Service/Roblox Compute Cloud Service) and how to use it with Mercury Core.

## Purpose

RCC is an important piece of a revival platform, and has many useful capabilities. The primary use cases are hosting servers for multiplayer games, and rendering images of user-uploaded assets such as avatars, models, clothing, and places.

## Versions

Prior to 2008, RCC was known as RBXGS (Roblox Grid Services). These versions won't be covered at the moment as they're rarely used in the community.

If you're only planning to use RCC for rendering images, the version doesn't matter too much unless you want historical accuracy. If you're planning to host multiplayer games, the version should match that of your Client and Studio as closely as possible. Mercury previously used a 2015 version of RCC alongside a 2013 Client and Studio, as RCC was not used for hosting games.

## Security

RCCService usually runs TCP traffic on port 64989. It is strongly recommended not to expose RCC directly to the internet. Instead, the most common options are to use a secure VPN tunnel, like [OpenVPN](https://openvpn.net/get-started/), [WireGuard](https://www.wireguard.com), or [Tailscale](https://tailscale.com/kb/1017/install), or a proxy server.

## Communication

Up until 2021, RCC used a SOAP-based protocol, with XML payloads for communication. From 2021 onwards, RCC switched to a JSON-based protocol. Most of the time, it's simple to create a XML/JSON template and substitute values into it as needed to create requests.

The main part of this template will usually be a Lua script instructing the service what to do, such as to create a game server in the same way that a host script does, or to render an image of a 3D model using the ThumbnailGenerator service. Once the operation is complete, the script will also handle notifying the requester of the results in an asynchronous manner.
