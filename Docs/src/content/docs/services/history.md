---
title: History
description: Details on how Mercury Core's history and development.
---

This page outlines a broad history of Mercury development and the various components of platforms that became part of Mercury Core. 

Each project listed had a similar goal of reviving an MMO game platform, and each project shared some members of the development team. Small revival projects from before Krypton are not listed here.

## Project Polygon

Project Polygon was a revival started in late 2020 by pizzaboxer. Polygon's codebase used predominantly PHP as the backend programming language, and it had multiple clients available for users to play with. Polygon was mainly developed by pizzaboxer, however taskmanager (the owner of all of the following revivals) contributed significantly to the development of Polygon's website. Due to this, pizzaboxer assisted with the development of Mercury 1 and it's predecessor, Krypton by using an earlier version of Polygon source code as the backend. Krypton and Mercury 1 did not sync any changes done to Polygon - so even though Polygon finished development in 2021, this was not reflected within Krypton and Mercury 1 (they were still based on the early Polygon source). In conclusion, Polygon is the grandfather of all revivals prior to Mercury 2.

## Krypton

Krypton was a revival platform developed in late 2020 and early 2021, built upon an earlier version of the [Project Polygon source code](https://github.com/ProjectPolygon/polygon-website-foss)[^1] and hosted on the domain [kryptoni.xyz (archive link)](https://web.archive.org/web/20210118181413/http://kryptoni.xyz/). Krypton used a late 2011 version of the Client and Studio. It shut down in April 2021.

## Mercury 1

The first version of Mercury started development as a rebranding and improvement of the Krypton codebase in May 2021, and was hosted at [banland.xyz (archive link)](https://web.archive.org/web/20210803231644/https://banland.xyz/). Mercury 1 used the late 2013 Client and Studio.

Mercury 1 peaked at around 300 users before it shut down in September 2021 and merged with Project Polygon. A [functional archive](https://files.heliodex.cf/mercury-website.zip) of the original Mercury 1 website is available.

## Krypton X

From early to mid 2022, some developments were made on a successor to Mercury 1 and Krypton named Krypton X, also hosted at [banland.xyz (archive link)](https://web.archive.org/web/20220517195738/https://banland.xyz/). Krypton X used the same late 2011 Client and Studio as Krypton.

A [non-functional archive](https://files.heliodex.cf/krypton-website.zip) of the Krypton X website is available.

## Renova

In June 2022, development started on prototypes for a new revival platform. Multiple prototypes were produced, some in PHP and others with a JS-based backend, some using components from existing codebases and others built from scratch. The placeholder name "Renova" was used for this assortment of prototypes. These prototypes were never fully functional platforms, though had a number of useful features for testing purposes.

Many of the features from some prototypes of Renova were later integrated into Mercury 2. If you were to scroll back far enough in Mercury Core's [commit history](https://github.com/tp-link-extender/MercuryCore/commits/), you may be able to find some references to Renova.

## Mercury 2

In July 2022, development started on a spiritual successor to Mercury 1 named Mercury 2. Mercury 2 used a JS-based stack with [SvelteKit](/architecture/stack), different to any other revival platform apart from some experimental prototypes from Renova. This meant we couldn't use large chunks of code from existing PHP-based platforms, so most components had to be built from scratch.

Mercury 2 quickly moved from an alpha development stage to a closed beta testing stage. At the end of July 2022, Project Polygon announced the [shutdown of their platform](https://web.archive.org/web/20220729233714/https://polygon.pizzaboxer.xyz/farewell?ReturnUrl=%2F). At this time, Mercury 2 was not yet ready for public use, so Polygon users migrated to other revival platforms. Development continued, mainly adding pages and features, improving frontend design, and improving database design.

At the beginning of 2023, improvements continued to be made, including a new RedisGraph database to go alongside the existing PostgreSQL database in order to simplify social graph queries. Development accelerated, and a hosted version of Mercury 2 was released on the same domain used for Mercury 2, [banland.xyz (archive link)](https://web.archive.org/web/20230119011856/https://banland.xyz/). By the end of January, testing was beginning for multiplayer game launching, and ~30 beta testers were registered on site.

In February 2023, the ability to join games from the site was added, using the same late 2013 client as Mercury 1. This allowed work to start on Client development, as well as a slightly improved Setup deployer. Due to the shutdown of Tadah, another similar project, and its rebranding of Kapish and shutting down again, we had a small influx of users from those platforms, ending up with ~40 users by the end of February. Throughout March we continued working on more site features including the forums, and ended the month with ~50 users. 

Mercury 2 moved to the domain [mercury2.com (archive link)](https://web.archive.org/web/20240423190637/https://mercury2.com/) in April 2024. Some work continued on the site, and more attempts were made at getting the DLL hook working to enable more features in the Client and Studio.

Eventually, it was decided that DLL hooking was not feasible, and with  no good way to connect the Client and Studio to the rest of the platform, it was decided to [shut down Mercury 2](https://web.archive.org/web/20250622030340/http://mercury2.com/) on 22 June 2024. At the time of shutdown, Mercury 2 had just over 150 registered users.

Some of Mercury 2's related projects were already available as open source, such as [melt](https://github.com/Heliodex/melt). Many other components, including the Setup deployer, 2013 scripts and tools, RCCService proxy, application settings JSON, and Discord bot were all made available as well.

## Mercury Core

Immediately after the shutdown of Mercury 2, the plan was made to take everything that was not already made open source as a separate component, and polish it for release as a self-hostable and customisable version of Mercury, called Mercury Core.

[^1]: The Project Polygon FOSS source code listed at this link differs slightly from the version used to develop Mercury 1 and is missing the commit history.
