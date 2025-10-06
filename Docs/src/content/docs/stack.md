---
title: Technology stack
description: Overview of the technology stack used in Mercury Core.
---

Mercury's frontend is built with [Svelte](https://svelte.dev/), a UI framework that compiles to vanilla JS, and SvelteKit, a powerful full-stack framework for building transitional apps.

The Site uses [Typescript](https://typescripts.org/) throughout, a language that adds type extensions ontop of Javascript. Intellisense and type checking are used as well, as they help to prevent bugs and improve understanding of the codebase.

[SurrealDB](https://surrealdb.com/) is used as the database, a powerful multi-model database that easily allows for storing and querying the highly relational data used in Mercury.

[Vite](https://vite.dev/) brings the stack for the website together, giving an extremely fast and responsive development environment, as well as zero-downtime deployments.

[Caddy](https://caddyserver.com) is used as a reverse proxy server, which allows for automatic HTTPS and TLS certificates, rewriting URLs, and provides a simpler configuration interface than popular alternatives like Apache or nginx.

## Route structure

Actual pages for the Site are stored in the [**Site/src/routes**](https://github.com/tp-link-extender/MercuryCore/tree/main/Site/src/routes) directory. The structure for them might look strange at first if you're not familiar with SvelteKit, but it makes it very simple to differentiate between clientside and serverside code, and layout groups help to heavily reduce boilerplate and code duplication.

See the [SvelteKit Routing docs](https://svelte.dev/docs/kit/routing) for more information.

The markup for pages is enhanced with HTMLx templating, which adds extra features such as adding variables, reactivity, and logic blocks such as {#if} and {#each}.

Take a look at the [Svelte docs](https://svelte.dev/docs), or the incredibly helpful [Svelte tutorial](https://svelte.dev/tutorial/svelte/welcome-to-svelte), for more information.
