<script lang="ts">
	import type { TransferWithID } from "economy/economy"
	import { Items } from "economy/items"
	import * as Econ from "economy/types"
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

{#snippet owner(o: Econ.Owner)}
	{#if o instanceof Econ.User}
		{@const u = ownerData.users[o.ID]}
		{#if u}
			<User user={u} full thin size="2.5rem" bg="accent" />
		{:else}
			<i>Unknown user</i>
		{/if}
	{:else if o instanceof Econ.Group}
		<span>{ownerData.groups[o.ID]?.name ?? "Unknown group"}</span>
	{:else if o instanceof Econ.PackageSource}
		<span>
			{assetName(o.ID) ?? "Package source"}
			<small>(package source)</small>
		</span>
	{:else if o instanceof Econ.UnlimitedSource || o instanceof Econ.LimitedSource}
		<span>
			{assetName(o.ID) ?? "Asset source"}
			<small>(source)</small>
		</span>
	{:else}
		<i>Unknown owner</i>
	{/if}
{/snippet}

{#snippet canOwnOne(i: Econ.CanOwnOne)}
	{#if i instanceof Econ.UnlimitedAsset}
		UnlimitedAsset
	{:else if i instanceof Econ.Package}
		{assetName(i.ID) ?? "Package"}
		<small>(package)</small>
	{:else if i instanceof Econ.PackageSource}
		{assetName(i.ID) ?? "Package source"}
		<small>(package source)</small>
	{:else if i instanceof Econ.LimitedSource}
		{assetName(i.ID) ?? "LimitedSource"}
		<small>(limited source)</small>
	{:else if i instanceof Econ.UnlimitedSource}
		{assetName(i.ID) ?? "UnlimitedSource"}
		<small>(asset source)</small>
	{:else if i instanceof Econ.Place}
		Place
	{:else if i instanceof Econ.Group}
		Group
	{:else}
		<i>Unknown item (one)</i>
	{/if}
{/snippet}

{#snippet canOwnMany(i: Econ.CanOwnMany)}
	{#if i instanceof Econ.Currency}
		<span class="text-emerald-600">{currencySymbol}</span>
	{:else if i instanceof Econ.LimitedAsset}
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
