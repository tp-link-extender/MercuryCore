<script lang="ts">
	export let data

	let tabData = TabData(data.url, ["Transactions"])
</script>

<Head title="Transactions - Admin" />

<div class="container py-6">
	<h1 class="light-text mb-0">Admin - Transactions</h1>
	<a href="/admin" class="text-decoration-none">
		<fa class="fa-caret-left" />
		Back to panel
	</a>
	<div class="row mt-6">
		<div class="col-lg-2 col-md-3 mb-6">
			<TabNav bind:tabData vertical />
		</div>
		<div class="col-lg-10 col-md-9">
			<Tab {tabData}>
				<table class="w-100 m-auto">
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

							<td class="d-flex justify-content-center gap-3">
								<div class="fs-6 pt-2">
									<span class="text-success">
										<fa class="fa-gem" />
										{transaction.amountSent}
									</span>
									{#if value}
										<fa class="fa-arrow-right-1" />
									{/if}
								</div>
								<div
									class="d-flex flex-column justify-content-center">
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
									<div class="fs-6 pt-2">
										<fa class="fa-arrow-right me-1" />
										<span class="text-success">
											<fa class="fa-gem" />
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
								<div class="d-flex justify-content-end">
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
