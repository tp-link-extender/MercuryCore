---
title: Economy
description: Features and design of Mercury Core's economy system.
---

Mercury Core includes an external transaction, asset ownership, and currency management system known as the Economy service. This service is designed to handle all economic activities within a revival platform, ensuring a fair, balanced, and fun in-game economy for players.

## Ledger

The Economy service maintains a ledger of all transactions, recording details such as the sender and receiver, what was exchanged, timestamps, and a unique transaction ID. This ledger is crucial for auditing purposes and ensuring transparency in all economic activities.

The ledger is designed to be immutable, meaning that once a transaction is recorded, it cannot be altered or deleted. This allows the ledger to be treated as a single source of truth for all economic activities within the platform &ndash; user balances and inventories are always derived from the ledger, and it's easy for a balance/inventory history to be reconstructed from the ledger if needed.

## Incentives

In small revival platforms, there is usually not enough market activity for it to be clear what the expected value is of certain items or assets, and by extension how valuable the currency is. However, in a large enough platform with a thriving economy, supply and demand will naturally determine the value of items and currency.  
In both cases, the economy can be used as a powerful tool to incentivise player behaviour. By rewarding players with currency for completing certain actions, or by making certain items more expensive or cheaper, operators and administrators can guide the economy in a direction that benefits the overall health of the platform.

First, it's important to work out what platform behaviours are best to encourage or discourage. Common choices include:

- Creation of high-quality places, for example being well-made, technically impressive, highly rated by users, or popular.
- Regular user engagement &ndash; logging in frequently, spending time on the platform, or interacting with many other users.
- Creation of user-generated content like development assets, models, or scripts that can be shared with other users.
- Participation in the community through forums, groups, or social features.
- Participation in the economy itself through buying and trading items, or by creating and selling assets at a price that reflects their perceived value.
- Avoiding negative behaviours such as scamming, spamming, or harassment.
- Referral of active, engaged, and well-behaved new users to the platform.
- Professional or mature conduct such as adhering to community guidelines, reporting issues, or helping other users.
- Providing feedback to help improve the platform.

Once the desired behaviours are identified, appropriate incentives can be designed. Examples of these may include:

- Stipends for logging in regularly, for example weekly, daily, or every 12-16 hours.
  - These can be scaled based on user activity, for example giving larger stipends to users who log in more frequently, or made contributions to the site in this time.
- Limiting the number of messages or forum posts a user can make, and requiring a small fee to make additional posts, to discourage spamming.
- Economic rewards from participating in a trading system in positive ways, such as making fair trades.
  - This could be in a form of cashback rewards, or more subtle incentives such as reduced fees or improved selling prices for assets they own.
  - It is common for the trading scene (LMaD) to become a huge part of a platform's economy if it's rewarding enough to participate in. In some cases, this can be so successful as to overshadow other aspects of the platform. In these cases, fees and rewards could be automatically or manually adjusted to encourage spending in other areas of the platform.
- Controlling the growth of the platform by attaching currency bonuses or costs to an existing registration key system.
  - Growth could be boosted by giving currency rewards to users that refer new users, incentivising them to publicise the platform.
  - Growth could be limited by requiring users to pay a currency fee to create a registration key, resulting in fewer keys being created and shared.
  - Using a combination of both, for example a small fee to create a key but a larger reward for referring new users, can balance growth and control spam registrations.
- Controlling the availability of assets or catalog items by providing currency costs or rewards for their creation.
  - This could be requiring a higher cost to create them based on their supply (for limited items) or price, to incentivise users to create items at a cost that users are willing to pay. The initial investment required to create the item may encourage creators to carefully consider the demand for the item before creating it.
- Liquidity incentives for selling or buying assets, such as higher fees for users that hold large quantities of valuable assets without selling them, or higher stipends for users that frequently sell or trade assets.

Choose carefully, as misaligned incentives can have adverse effects on the platform's economy and user behaviour. Regular review and adjustment of incentives based on observed outcomes is important to ensure they continue to align with the goals of the revival platform. Complex and interconnected systems may require extra testing or careful planning to get right, and even then might not be intuitive enough to users for the intended effects to be produced. Therefore in some cases it would be better to start with a simple economy structure, note the outcomes, and then gradually introduce more complexity as needed along with the growth of the platform.

It is key to remember that the economy is not physically tied to the real world, so may not need to reflect it and its systems directly. The main purpose of an economy should be to meet the needs of its users &ndash; in the context of a revival platform, this means providing a fun and engaging experience for users.

## Previous systems

Prior to introduction of the Economy service, Mercury stored user balances and transaction histories directly as records in the database. The main drawback of this approach was that user balances and sources of funds could not be audited or verified, and it was common for desynchronisation issues to occur, leading to incorrect balances, misplaced transactions, and lost funds.

Queries also had to be carefully constructed to check each user's balance before creating and processing a transaction, to ensure that users could not overspend their funds. These checks were performed directly within the database, so were easy to roll back if a check or creation failed.

