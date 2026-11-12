<script lang="ts">
	import type { TransferWithID } from "economy/economy"
	import { Items } from "economy/items"
	import {
		type CanOwnMany,
		type CanOwnOne,
		Currency,
		Group as EconGroup,
		LimitedAsset as EconLimitedAsset,
		LimitedSource as EconLimitedSource,
		type Owner as EconOwner,
		Package as EconPackage,
		Place as EconPlace,
		UnlimitedAsset as EconUnlimitedAsset,
		UnlimitedSource as EconUnlimitedSource,
		User as EconUser,
		PackageSource,
	} from "economy/types"
	import User from "$components/User.svelte"
	import type { OwnerData } from "$lib/economy"

	const {
		transfer: transaction,
		ownerData,
		currencySymbol
	}: {
		transfer: TransferWithID
		ownerData: OwnerData
		currencySymbol: string
	} = $props()

	let { Send0, Send1 } = $derived(transaction.Transfer)
	let sender0 = $derived(Send0.Owner)
	let sender1 = $derived(Send1.Owner)
	let time = $derived(transaction.ID.Time())

	// asset-like items and sources share their ids with the asset records that name them
	const assetName = (id: number) => ownerData.sources[String(id)]?.name
</script>

{#snippet owner(o: EconOwner)}
	{#if o instanceof EconUser}
		{@const u = ownerData.users[o.ID]}
		{#if u}
			<User user={u} full thin size="2.5rem" bg="accent" />
		{:else}
			<i>Unknown user</i>
		{/if}
	{:else if o instanceof EconGroup}
		<span>{ownerData.groups[o.ID]?.name ?? "Unknown group"}</span>
	{:else if o instanceof PackageSource}
		<span>
			{assetName(o.ID) ?? "Package source"}
			<small>(package source)</small>
		</span>
	{:else if o instanceof EconUnlimitedSource || o instanceof EconLimitedSource}
		<span>
			{assetName(o.ID) ?? "Asset source"}
			<small>(source)</small>
		</span>
	{:else}
		<i>Unknown owner</i>
	{/if}
{/snippet}

{#snippet canOwnOne(i: CanOwnOne)}
	{#if i instanceof EconUnlimitedAsset}
		UnlimitedAsset
	{:else if i instanceof EconPackage}
		{assetName(i.ID) ?? "Package"}
		<small>(package)</small>
	{:else if i instanceof PackageSource}
		{assetName(i.ID) ?? "Package source"}
		<small>(package source)</small>
	{:else if i instanceof EconLimitedSource}
		{assetName(i.ID) ?? "LimitedSource"}
		<small>(limited source)</small>
	{:else if i instanceof EconUnlimitedSource}
		{assetName(i.ID) ?? "UnlimitedSource"}
		<small>(asset source)</small>
	{:else if i instanceof EconPlace}
		Place
	{:else if i instanceof EconGroup}
		Group
	{:else}
		<i>Unknown item (one)</i>
	{/if}
{/snippet}

{#snippet canOwnMany(i: CanOwnMany)}
	{#if i instanceof Currency}
		<span class="text-emerald-600">{currencySymbol}</span>
	{:else if i instanceof EconLimitedAsset}
		{assetName(i.ID) ?? "LimitedAsset"}
		<small>(limited)</small>
	{:else}
		<i>Unknown item (many)</i>
	{/if}
{/snippet}

{#snippet items(is: Items)}
	{#if !is.One.Empty()}
		<b>One</b>
		<div class="flex flex-wrap gap-x-2">
			{#each is.One as i}
				<span>{@render canOwnOne(i)}</span>
			{/each}
		</div>
	{/if}

	{#if !is.Many.Empty()}
		<b>Many</b>
		<dl>
			{#each is.Many as [i, qty]}
				<dt>{@render canOwnMany(i)}</dt>
				<dd>{qty}</dd>
			{/each}
		</dl>
	{/if}

	{#if is.One.Empty() && is.Many.Empty()}
		<i>Nothing</i>
	{/if}
{/snippet}

<!-- From -->
<td>
	{#if sender0}
		{@render owner(sender0)}
	{/if}
</td>

<!-- Sent -->
<td>
	{@render items(Send0.Items)}
</td>

<!-- Time -->
<td>
	<small class="tnum">
		{time.toLocaleString()}
	</small>
</td>

<!-- Received -->
<td>
	{@render items(Send1.Items)}
</td>

<!-- To -->
<td>
	{#if sender1}
		{@render owner(sender1)}
	{/if}
</td>

<style>
	td {
		height: 3.5rem;
	}

	.tnum {
		font-feature-settings: "cv03", "cv04", "cv08", "cv09", "tnum";
	}
</style>
