---
title: Orbiter contract
description: The wire contract between the Site and the Orbiter, the combined gameserver and render service.
---

The Orbiter is the single service on the RCC machine that manages gameservers and renders. It replaces the separate RCCService proxy and Orbiter. This page is the contract between the Site and the Orbiter. Changes to it need both sides updated together. The Orbiter side lives in the [RCCService](https://github.com/tp-link-extender/RCCService) repository.

## Listeners

| Listener | Address | Caller | Auth |
| --- | --- | --- | --- |
| Private | `:64991` | Site | Bearer `ORBITER_KEY` |
| Loopback | `127.0.0.1:64990` | RCC scripts and Studio, on the same machine | None (loopback only) |
| Public | `:64992` in dev, `gs.{DOMAIN}` on 443 in production | Browsers | None (read-only) |

The public listener serves only `GET /{id}`, on its own mux. It must never expose the private or loopback routes.

## Auth

There is one secret, `ORBITER_KEY`, at least 16 characters and not an example value. It is the same on both sides and is sent as `Authorization: Bearer <key>`. Both sides compare it in constant time and refuse all requests that need it if it is unset or unusable. There is no IP fallback.

The key is an environment variable only. It is never placed in `mercury.core.ts`, which is committed.

The key also guards the Site's `GET /game/{id}` place-file route and `GET /game/{id}/serve`, which replaces `GAMESERVER_KEY` on that route.

## Private listener (Site calls the Orbiter)

- `POST /render/{id}`: starts a render. The body is the render loadscript as `text/plain`, at most 8 MiB. The Site fills in `PING_URL` as `http://127.0.0.1:64990/ping/{id}`, the loopback callback. Responds `202` with an empty body once the render is accepted.
- `GET /gameservers`: lists current gameservers. Responds `200` with `[[placeId, {"pid": number, "startTime": number, "status": number}], ...]`. `status` is `0` closed, `1` starting, `2` running. The Site reads only `pid` and `startTime`.
- `PUT /gameserver/{placeId}?engine=studio|rcc`: starts a gameserver. `engine` defaults to the Orbiter's `DEFAULT_ENGINE`. Responds `202` when started. If the gameserver is already running, responds `202` too, so that two players starting the same place at once don't see an error.
- `DELETE /gameserver/{placeId}`: closes a gameserver. Idempotent. Responds `204` whether or not it existed.

Gameserver ids are decimal integers. Render ids are SurrealDB record ids, validated by the Orbiter as `[A-Za-z0-9_-]`, 1 to 64 characters.

## Loopback listener (RCC and Studio call the Orbiter)

- `POST /ping/{renderId}`: render status from the RCC render script. The body is a status line, then for `Completed` the base64 body and head images, as sent today.
- `POST /hostping/{placeId}`: status from a hosted gameserver. The body is a status line, then an optional user id. Statuses are `Loaded`, `Ready`, `Heartbeat`, `PlayerAdded`, `PlayersLeft`, `Unoccupied` and `Closed`.
- `GET /serve/{placeId}?t={token}`: the Studio serve script, with a token the Orbiter generates. The Site never sees or sends tokens.

The Orbiter writes its own loopback URLs into scripts it sends to RCC or Studio.

## Orbiter calls the Site

- `GET {SITE_URL}/game/{placeId}/serve`: fetches the serve loadscript for a gameserver. Sends the bearer key. Responds `200` with the script as text.
- `POST {SITE_URL}/api/render/update/{renderId}`: reports render progress. Sends the bearer key with `Content-Type: application/octet-stream`. The body is the status line and a newline, then for `Completed` the big-endian `uint32` body length, the big-endian `uint32` head length, the body image and the head image. The status is `Rendering` or `Completed`. The Site responds `200`.

`SITE_URL` is the one Site address the Orbiter uses for all of these, including a scheme and no trailing slash.

## Errors

Error responses are JSON `{"error": "<message>"}` with one of these statuses:

- `400`: bad id or body
- `401`: missing or wrong bearer
- `404`: unknown gameserver or render
- `413`: body too large
- `500`: the Orbiter failed to do the work

Success responses are JSON except for `202` and `204`. The Site treats any non-2xx response as a failed call and reports the `error` message.

## Config

Site (`mercury.core.ts` and `Site/.env`):

- `Orbiter.PrivateURL` and `Orbiter.PublicURL` are kept.
- `RCCServiceProxyURL` is removed.
- `ORBITER_KEY` replaces `RCC_KEY` and `GAMESERVER_KEY`.

Orbiter (`.env`):

- Required: `ORBITER_KEY`, `DOMAIN`, `SITE_URL`, `SETUPDOMAIN`, `MAX_JOBS_PER_RCC`, `RCC_BASE_PORT`, `HOST_EXPIRATION`, `ENV`.
- Optional: `DEFAULT_ENGINE` (defaults to `rcc`), `RCC_MAP_LOCATION`, `RCC_SPAWN`.
- Removed: `IP`, `IPV4`, `IPV6`, `ENDPOINT`, `RCC_KEY`, `GAMESERVER_KEY`, `PROXY_URL`, `PROXY_KEY`, `HOST_ENDPOINT`.

## Cutover

The Site and the Orbiter switch in one window. Stop the old proxy and Orbiter, start the new Orbiter with its new `.env`, then deploy the Site with its new config and `ORBITER_KEY`. The old and new routes are not compatible, so there is no overlap period.
