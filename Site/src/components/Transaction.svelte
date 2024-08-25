<script lang="ts">
	import User from "$components/User.svelte"
	import beautifyCurrency from "$lib/beautifyCurrency"

	export let transaction: import("../routes/(main)/admin/transactions/$types").PageData["transactions"][0]
	export let users: import("../routes/(main)/admin/transactions/$types").PageData["users"]
	export let currencySymbol: string

	const [, c1, c2] = beautifyCurrency(transaction.Amount)
</script>

<td>
	{transaction.Type}
</td>
<td>
	{#if transaction.Type !== "Mint"}
		<User
			user={users[transaction.From]}
			full
			thin
			size="2.5rem"
			bg="accent" />
	{/if}
</td>

<td>
	<small class="tnum">
		{new Date(transaction.Time).toLocaleString()}
	</small>
</td>
<td>
	<span class="tnum text-emerald-6 tracking-tighter">
		{currencySymbol}
		{c1}{c2 ? "." : ""}{c2}
	</span>
</td>
<td>
	{#if transaction.Type === "Transaction"}
		{@const [, f1, f2] = beautifyCurrency(transaction.Fee)}
		<span class="tnum text-yellow-5 tracking-tighter">
			{currencySymbol}
			{f1}{f2 ? "." : ""}{f2}
		</span>
	{/if}
</td>

<td>
	{#if transaction.Type !== "Burn"}
		<User
			user={users[transaction.To]}
			full
			thin
			size="2.5rem"
			bg="accent" />
	{/if}
</td>

<td>
	{#if transaction.Note && transaction.Type !== "Mint"}
		<a href={transaction.Link} class="light-text">
			{transaction.Note}
		</a>
	{:else if transaction.Note}
		<p>
			{transaction.Note}
		</p>
	{:else}
		<em>No transaction note</em>
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
