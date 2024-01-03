<script lang="ts">
	export let data

	let tabData = TabData(data.url, ["Transactions"])
</script>

<Head title="Transactions - Admin" />

<div class="ctnr pt-6">
	<h1>Admin - Transactions</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left />
		Back to panel
	</a>
	<div class="flex flex-wrap pt-6">
		<TabNav
			bind:tabData
			vertical
			class="w-full lg:w-1/6 md:w-1/4 pb-6 md:pr-4" />
		<div class="w-full lg:w-5/6 md:w-3/4">
			<Tab {tabData}>
				<table class="w-full">
					{#each data.transactions as transaction, num}
						{@const value = transaction.amountSent > 0}
						<tr
							in:fade={{
								num,
								total: data.transactions.length,
								max: 12,
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
												(1 -
													transaction.taxRate / 100) *
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
									<a
										href={transaction.link}
										class="light-text">
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
		</div>
	</div>
</div>

<style lang="stylus">
	// Change colour of every second row
	tr:nth-child(2n)
		background var(--darker)

	td
		height 3.5rem
</style>
