---
title: History
description: Details on how Mercury Core's history and development.
---

This page outlines a broad history of Mercury development and the various components of platforms that became part of Mercury Core.

## Mercury 1

The first version of Mercury started development in late 2020, built upon a version of the [Project Polygon source code](https://github.com/ProjectPolygon/polygon-website-foss)[^1] and hosted at [banland.xyz (archive link)](https://web.archive.org/web/20210803231644/https://banland.xyz/). Mercury 1 was eventually shut down in late 2021 and merged with Project Polygon.

A [functional archive](https://files.heliodex.cf/mercury-website.zip) of the original Mercury 1 website is available.

## Krypton X

From early to mid 2022, some developments were made on a successor to Mercury 1 and Krypton named Krypton X, also hosted at [banland.xyz (archive link)](https://web.archive.org/web/20220517195738/https://banland.xyz/). A [non-functional archive](https://files.heliodex.cf/krypton-website.zip) of the Krypton X website is available.

## Renova

In June 2022, development started on prototypes for a new revival platform. Multiple prototypes were produced, some in PHP and others with a JS-based backend, some using components from existing codebases and others built from scratch. The placeholder name "Renova" was used for this assortment of prototypes. These prototypes were never fully functional platforms, though had a number of useful features for testing purposes.

Many of the features from some prototypes of Renova were later integrated into Mercury 2. If you were to scroll back far enough in Mercury Core's [commit history](https://github.com/tp-link-extender/MercuryCore/commits/), you may be able to find some references to Renova.

## Mercury 2

In July 2022, development started on a spiritual successor to Mercury 1 named Mercury 2. Mercury 2 used a JS-based stack with [SvelteKit](/architecture/stack), different to any other revival platform apart from some experimental prototypes from Renova. This meant we couldn't use large chunks of code from existing PHP-based platforms, so most components had to be built from scratch.

Mercury 2 quickly moved from an alpha development stage to a closed beta testing stage. At the end of July 2022, Project Polygon announced the [shutdown of their platform](https://web.archive.org/web/20220729233714/https://polygon.pizzaboxer.xyz/farewell?ReturnUrl=%2F). At this time, Mercury 2 was not yet ready for public use, so Polygon users migrated to other revival platforms. Development continued, mainly adding pages and features, improving frontend design, and improving database design.

At the beginning of 2023, improvements continued to be made, including a new RedisGraph database to go alongside the existing PostgreSQL database in order to simplify social graph queries. Development accelerated, and a hosted version of Mercury 2 was released on the same domain used for Mercury 2, [banland.xyz (archive link)](https://web.archive.org/web/20230119011856/https://banland.xyz/). By the end of January, testing was beginning for multiplayer game launching, and 30 beta testers were registered on site.

Mercury 2 moved to the domain [mercury2.com (archive link)](https://web.archive.org/web/20240423190637/https://mercury2.com/) in April 2024. Some work continued on the site, and more attempts were made at getting the DLL hook working to enable more features in the Client and Studio.

Eventually, it was decided that DLL hooking was not feasible, and with  no good way to connect the Client and Studio to the rest of the platform, it was decided to [shut down Mercury 2](https://web.archive.org/web/20240622203757/https://mercury2.com/) on 22 June 2024.

[^1]: The Project Polygon FOSS source code listed at this link differs slightly from the version used to develop Mercury 1 and is missing the commit history.
