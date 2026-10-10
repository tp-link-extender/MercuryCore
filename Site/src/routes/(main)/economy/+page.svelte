<script lang="ts">
	import * as Econ from "economy/economy"
	import { Buf, BufReader } from "economy/items"
	import Head from "$components/Head.svelte"
	import Transaction from "$components/Transaction.svelte"
	import fade from "$lib/fade"

	const { data } = $props()
</script>

<Head name={data.siteName} title="Economy" />

<h1 class="text-center">Economy</h1>

<div class="ctnr pt-12 flex flex-col gap-4">
	<!-- Top section -->
	<div class="grid lg:grid-cols-[1fr_1fr] gap-4">
		<!-- Current balance card -->
		<div class="card bg-darker p-4">
			<h2>Current balance</h2>
			<div class="flex flex-row items-center text-2rem">
				<span class="pr-2 text-emerald-600">{data.currencySymbol}</span>
				<data
					class="balancenum flex flex-row text-emerald-600"
					value={data.balance.toString()}>
					{data.balance.toString()}
				</data>
			</div>
		</div>
	</div>

	<h2>Your recent transactions</h2>

	<div class="card bg-darker p-4">
		<table class="w-full">
			<thead>
				<tr>
					<th>From</th>
					<th>Sent</th>
					<th>Time</th>
					<th>Received</th>
					<th>To</th>
				</tr>
			</thead>
			<tbody>
				{#each data.transactions as transaction, num}
					{@const transfer = Econ.TransferWithID.Deserialise(
						new BufReader(new Buf(transaction))
					)}
					<tr
						in:fade={{
							num,
							total: data.transactions.length,
							max: 12
						}}>
						<Transaction
							{transfer}
							ownerData={data.ownerData}
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

	.balancenum {
		font-feature-settings: "tnum", "calt", "zero";
	}
</style>
