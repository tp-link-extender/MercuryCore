<script lang="ts">
	import Head from "$components/Head.svelte"
	import Transaction from "$components/Transaction.svelte"
	import beautifyCurrency from "$lib/beautifyCurrency"
	import fade from "$lib/fade"

	let { data } = $props();

	const [c1, c2, c3, c4] = beautifyCurrency(data.balance)
</script>

<Head name={data.siteName} title="Economy" />

<h1 class="text-center">Economy</h1>

<div class="ctnr pt-12 flex flex-col gap-4">
	<div class="grid lg:grid-cols-[1fr_1fr] gap-4">
		<div class="card bg-darker p-4">
			<h2>Current balance</h2>
			<div class="flex flex-row items-center text-2rem">
				<span class="pr-2 text-emerald-600">{data.currencySymbol}</span>
				<span class="balancenum flex flex-row text-emerald-600">
					<span class="text-emerald-900">{c1}</span>
					{c2}
					<span class={c3 ? "text-emerald-600" : "text-emerald-900"}>
						.
					</span>
					{c3}
					<span class="text-emerald-900">{c4}</span>
				</span>
			</div>
		</div>
	</div>

	<h2>Your recent transactions</h2>

	<div class="card bg-darker p-4">
		<table class="w-full">
			<thead>
				<tr>
					<th>Type</th>
					<th>From</th>
					<th>Time</th>
					<th>Amount</th>
					<th>Fee</th>
					<th>To</th>
					<th>Note & link</th>
				</tr>
			</thead>
			<tbody>
				{#each data.transactions as transaction, num}
					<tr
						in:fade={{
							num,
							total: data.transactions.length,
							max: 12
						}}>
						<Transaction
							{transaction}
							users={data.users}
							currencySymbol={data.currencySymbol} />
					</tr>
				{/each}
			</tbody>
		</table>
	</div>
</div>

<style>
	tbody tr:nth-child(2n-1) {
		background: var(--background);
	}

	h2 {
		@apply text-xl font-500;
	}

	.balancenum,
	.balancenum span {
		font-feature-settings: "tnum", "calt", "zero";
	}
</style>
