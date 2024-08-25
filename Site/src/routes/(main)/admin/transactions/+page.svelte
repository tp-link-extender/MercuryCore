<script lang="ts">
	import Head from "$components/Head.svelte"
	import SidebarShell from "$components/SidebarShell.svelte"
	import Tab from "$components/Tab.svelte"
	import TabData from "$components/TabData"
	import User from "$components/User.svelte"
	import fade from "$lib/fade"

	export let data

	let tabData = TabData(
		data.url,
		["All transactions"],
		["fa-money-bill-wave"]
	)
</script>

<Head name={data.siteName} title="Transactions - Admin" />

<div class="ctnr max-w-280 pb-6">
	<h1>Transactions &ndash; Admin</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left />
		Back to panel
	</a>
</div>

<SidebarShell bind:tabData class="max-w-280">
	<Tab {tabData}>
		<table class="w-full">
			{#each data.transactions as transaction, num}
				{@const value = transaction.Amount > 0}
				<tr
					in:fade={{
						num,
						total: data.transactions.length,
						max: 12
					}}
					class="light-text">
					<td>
						{#if transaction.Type !== "Mint"}
							<User
								user={data.users[transaction.From]}
								full
								thin
								size="2.5rem"
								bg="accent" />
						{/if}
					</td>

					<td class="flex justify-center gap-3">
						<div class="flex flex-col justify-center">
							<!-- {#if value}
								{transaction.taxRate}% tax
							{/if} -->
							<small>
								{new Date(transaction.Time).toLocaleString()}
							</small>
						</div>
						{#if value}
							<div class="text-base pt-2">
								<fa fa-arrow-right />
								<span class="text-emerald-6">
									{data.currencySymbol}
									{Math.round(transaction.Amount)}
								</span>
							</div>
						{/if}
					</td>

					<td>
						{#if transaction.Type !== "Burn"}
							<div class="flex justify-end">
								<User
									user={data.users[transaction.To]}
									full
									thin
									size="2.5rem"
									bg="accent" />
							</div>
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
				</tr>
			{/each}
		</table>
	</Tab>
</SidebarShell>

<style>
	/* Change colour of every second row */
	tr:nth-child(2n) {
		background: var(--darker);
	}

	td {
		height: 3.5rem;
	}
</style>
