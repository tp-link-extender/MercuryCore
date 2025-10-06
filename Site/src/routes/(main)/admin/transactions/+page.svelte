<script lang="ts">
	import Head from "$components/Head.svelte"
	import SidebarShell from "$components/SidebarShell.svelte"
	import TabData from "$components/TabData"
	import Transaction from "$components/Transaction.svelte"
	import fade from "$lib/fade"

	const { data } = $props()

	let tabData = $state(
		TabData(data.url, ["All transactions"], ["fa-money-bill-wave"])
	)
</script>

<Head name={data.siteName} title="Transactions - Admin" />

<div class="ctnr pb-6">
	<h1>Transactions &ndash; Admin</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left></fa>
		Back to panel
	</a>
</div>

<SidebarShell bind:tabData class="max-w-300">
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
</SidebarShell>

<style>
	/* Change colour of every second row */
	tbody tr:nth-child(2n-1) {
		background: var(--darker);
	}
</style>
