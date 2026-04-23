---
title: Revival platform types
description: Comparison of 2 popular types of revival platforms, launcher-based and web-based.
---

Mercury Core is a foundation for building web-based revival platforms. These are platforms where services external to the Client, such as place launching and character customisation, are accessed via a hosted website. This is in contrast to launcher-based platforms, where a custom launcher application is used to join places and customise characters. This page provides an overview of the differences between these 2 types of platforms, and whether the web-based approach of Mercury Core is suitable for certain use cases.

## Launchers

Launchers are still necessary for both types of platforms, as they are used to launch the Client application, and in the case of a web-based platform, to interact with the site and download a Client. Conversely, a web-based platform is not necessarily required for a launcher-based platform, as the launcher could come pre-bundled with a Client and Studio, as well as possibly its own API server for interacting with the Client. However, sometimes these launchers have web API servers that are used for downloading Client updates and other features.

The difference is mainly where the functionality is accessed from, the centralisation or decentralisation of service hosting & access, and the development & usage focus on either the website or the launcher. Both types of platforms have their own advantages and disadvantages, users may have strong preferences of one over another, and the choice between them depends on the specific use case, goals, and user base of the platform being developed.

There do exist web-based platforms that do not need a separate launcher, most commonly by compiling 2016 Client source code to WebAssembly, allowing it to run in the browser. However, this approach is not very common, and has its own set of challenges and limitations. These include performance issues and modification requirements, with certain unsupported libraries needing to be substituted for compatible alternatives.

## Distinction

Generally, the distinction is broader than simply the type of application where the services are accessed from. Web-based platforms tend to host centralised features on the website alongside their main services, such as a marketplace & economy, features & communication, and discoverability, whereas launcher-based platforms typically have more decentralised place joining and local character customisation systems, allowing the user to choose for themselves where to connect to places and what accessories to use with their avatar.

Launcher-based platforms also usually have a launcher more closely integrated with the Client and more often depend on users hosting their own places rather than using centralised dedicated hosting. However, this can mean that game discoverability suffers due to lack of place listings. Multiplayer experiences using launcher-based platforms generally revolve around external communication platforms to organise place hosting and joining. This also happens for small web-based platforms with few users hosting places at a time, though this tends to be less of an issue for larger web-based platforms with more users hosting places at a time, as they can display more active place listings and better discoverability.

## Related experiments

Previous Mercury experiments, including [Mercury Core for Launcher Revivals](https://github.com/tp-link-extender/MCLauncherRevivals), aimed to tackle the launcher platform server discoverability problem by hosting a decentralised list of active servers, for various different launchers, on the website. Anyone would be able to host their own version of the list and see the same servers, with an ability to rate servers and join currently active ones. However, this approach offered no further economy or social features, and is not actively being developed.

[Reblox](https://github.com/Heliodex/Reblox) was one of several attempts at building a hybrid platform, with a single launcher, or multiple implementations of such, that could each connect to multiple different servers. Each server would have only hosted a standardised API for communicating with the launcher, and the launcher would have handled all interactions with the Client. Users would have been able to transfer their identity across multiple platforms, preventing inaccessibility of user accounts due to platform shutdowns. Places could have been hosted on any server, and have their discoverability across many servers. This approach would have offered more of the advantages of both types of platforms, also featuring plenty of social features, though at a much higher development cost than an approach like Mercury Core for Launcher Revivals due to lack of interoperability with existing launcher-based platforms. However, an implementation of an engaging marketplace or economic system would have been difficult or not possible, and the project is also not in development anymore.
