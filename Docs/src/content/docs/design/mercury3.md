---
title: Mercury 3 & Mercury Core
description: An overview on the relationship between Mercury 3 and Mercury Core.
---

Mercury 3 is a revival platform using a hosted version of Mercury Core as its source code. This page provides an overview of the relationship between Mercury 3 and Mercury Core.

## Development of Mercury 2

As explained in the [History](/history) page, the source code of Mercury 2 continued undergoing modification after it was shut down in June 2024, being released as Mercury Core in September 2024. As such, Mercury 2 is not considered to be based on Mercury Core.

Mercury 2 changed a significant amount during its 2 years of development. Many core pieces of the codebase were modified or rewritten, services were changed, and libraries used (many of which were in beta or early development at the time) were updated or replaced. As such, while Mercury Core shows clear resemblance with Mercury 2[^1] in 2024, the resemblance with a version of Mercury 2 from 2022 or 2023 is less clear. 

## Development of Mercury 3

The development process of Mercury 3 has been very different to that of Mercury 2. Originally, Mercury 3 was planned to be a fork of Mercury Core with improvements being backported to Mercury Core when possible. However, an alternative development process was found to be easier and chosen instead, where Mercury 3 is simply a hosted version of Mercury Core with no modifications. If you are interested more in the revival platform than the source code, Mercury Core can be seen as the "testing ground" for Mercury 3. If you are interested more in the source code than the revival platform, Mercury 3 can be seen as the "testing ground" for Mercury Core. Different Mercury 3 developers see the relationship differently.

The existence and testing of Mercury 3 helps with the development of Mercury Core, as it allows for testing of new features and changes in a real-world environment. Before Mercury 3, Mercury Core was only tested in development environments, which were not as effective at finding bugs and issues as a production environment would be.

[^1]: These changes can be viewed in full, with code change history throughout the entirety of Mercury 2, in Mercury Core's [commit history](https://github.com/tp-link-extender/MercuryCore/commits/).