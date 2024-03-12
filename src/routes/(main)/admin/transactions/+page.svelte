<script lang="ts">
	import AdminShell from "../AdminShell.svelte"

	export let data

	let tabData = TabData(
		data.url,
		["All transactions"],
		["fa fa-money-bill-wave"]
	)
</script>

<Head title="Transactions - Admin" />

<div class="ctnr pt-6">
	<div class="pb-4">
		<h1>Admin - Transactions</h1>
		<a href="/admin" class="no-underline">
			<fa fa-caret-left />
			Back to panel
		</a>
	</div>

	<AdminShell bind:tabData>
		<Tab {tabData}>
			<table class="w-full">
				{#each data.transactions as transaction, num}
					{@const value = transaction.amountSent > 0}
					<tr
						in:fade={{
							num,
							total: data.transactions.length,
							max: 12
						}}
						class="light-text">
						<td>
							<User
								user={transaction.sender}
								full
								thin
								size="2.5rem"
								bg="accent" />
						</td>

						<td class="flex justify-center gap-3">
							<div class="text-base pt-2">
								<span class="text-emerald-6">
									<fa fa-gem />
									{transaction.amountSent}
								</span>
								{#if value}
									<fa fa-arrow-right-1 />
								{/if}
							</div>
							<div class="flex flex-col justify-center">
								{#if value}
									{transaction.taxRate}% tax
								{/if}
								<small>
									{new Date(
										transaction.time
									).toLocaleString()}
								</small>
							</div>
							{#if value}
								<div class="text-base pt-2">
									<fa fa-arrow-right class="mr-1" />
									<span class="text-emerald-6">
										<fa fa-gem />
										{Math.round(
											(1 - transaction.taxRate / 100) *
												transaction.amountSent
										)}
									</span>
								</div>
							{/if}
						</td>

						<td>
							<div class="flex justify-end">
								<User
									user={transaction.receiver}
									full
									thin
									size="2.5rem"
									bg="accent" />
							</div>
						</td>

						<td>
							{#if transaction.note && transaction.link}
								<a href={transaction.link} class="light-text">
									{transaction.note}
								</a>
							{:else if transaction.note}
								<p>
									{transaction.note}
								</p>
							{:else}
								<em>No transaction note</em>
							{/if}
						</td>
					</tr>
				{/each}
			</table>
		</Tab>
	</AdminShell>
</div>

<style lang="stylus">
	// Change colour of every second row
	tr:nth-child(2n)
		background var(--darker)

	td
		height 3.5rem
</style>
