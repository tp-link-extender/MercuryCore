<script lang="ts">
	import Head from "$components/Head.svelte"
	import SidebarShell from "$components/SidebarShell.svelte"
	import TabData from "$components/TabData"
	import User from "$components/User.svelte"
	import beautifyCurrency from "$lib/beautifyCurrency"
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
				{@const [, c1, c2] = beautifyCurrency(transaction.Amount)}

				<tr
					in:fade={{
						num,
						total: data.transactions.length,
						max: 12
					}}
					class="light-text">
					<td>
						{transaction.Type}
					</td>
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

					<td>
						<small class="tnum">
							{new Date(transaction.Time).toLocaleString()}
						</small>
					</td>
					<td>
						<span class="tnum text-emerald-6 tracking-tighter">
							{data.currencySymbol}
							{c1}{c2 ? "." : ""}{c2}
						</span>
					</td>
					<td>
						{#if transaction.Type === "Transaction"}
							{@const [, f1, f2] = beautifyCurrency(
								transaction.Fee
							)}
							<span class="tnum text-yellow-5 tracking-tighter">
								{data.currencySymbol}
								{f1}{f2 ? "." : ""}{f2}
							</span>
						{/if}
					</td>

					<td>
						{#if transaction.Type !== "Burn"}
							<User
								user={data.users[transaction.To]}
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
				</tr>
			{/each}
		</tbody>
	</table>
</SidebarShell>

<style>
	/* Change colour of every second row */
	tr:nth-child(2n) {
		background: var(--darker);
	}

	td {
		height: 3.5rem;
	}

	.tnum {
		font-feature-settings: "cv03", "cv04", "cv08", "cv09", "tnum";
	}
</style>
