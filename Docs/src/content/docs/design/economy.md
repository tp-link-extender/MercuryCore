---
title: Economy
description: Features and design of Mercury Core's economy system.
---

Mercury Core includes an external transaction, asset ownership, and currency management system known as the Economy service. This service is designed to handle all economic activities within a revival platform, ensuring a fair, balanced, and fun in-game economy for players.

## Ledger

The Economy service maintains a ledger of all transactions, recording details such as the sender and receiver, what was exchanged, timestamps, and a unique transaction ID. This ledger is crucial for auditing purposes and ensuring transparency in all economic activities.

The ledger is designed to be immutable, meaning that once a transaction is recorded, it cannot be altered or deleted. This allows the ledger to be treated as a single source of truth for all economic activities within the platform &ndash; user balances and inventories are always derived from the ledger.

## Incentives

In small revival platforms, there is usually not enough market activity for it to be clear what the expected value is of certain items or assets, and by extension how valuable the currency is. However, in a large enough platform with a thriving economy, supply and demand will naturally determine the value of items and currency.  
In both cases, the economy can be used as a powerful tool to incentivise player behaviour. By rewarding players with currency for completing certain actions, or by making certain items more expensive or cheaper, operators and administrators can guide the economy in a direction that benefits the overall health of the platform.

First, it's important to work out what platform behaviours are best to encourage or discourage. Common choices include:

- todo

## Previous systems

Prior to introduction of the Economy service, Mercury stored user balances and transaction histories directly as records in the database. The main drawback of this approach was that user balances and sources of funds could not be audited or verified, and it was common for desynchronisation issues to occur, leading to incorrect balances, misplaced transactions, and lost funds.

Queries also had to be carefully constructed to check each user's balance before creating and processing a transaction, to ensure that users could not overspend their funds. These checks were performed directly within the database, so were easy to roll back if a check or creation failed.

