<script lang="ts">
	export let data
</script>

<Head title="Your transactions" />

<h1 class="text-center">Your transactions</h1>

<div class="container mt-12">
	<table class="w-100 m-auto">
		{#each data.transactions as transaction, num}
			{@const value = transaction.amountSent > 0}
			<tr
				in:fade={{ num, total: data.transactions.length, max: 12 }}
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
					<div class="fs-4 pt-2">
						<span class="text-success">
							<fa fa-gem />
							{transaction.amountSent}
						</span>
						{#if value}
							<fa fa-arrow-right-1 />
						{/if}
					</div>
					<div class="d-flex flex-column justify-content-center">
						{#if value}
							{transaction.taxRate}% tax
						{/if}
						<small>
							{new Date(transaction.time).toLocaleString()}
						</small>
					</div>
					{#if value}
						<div class="fs-4 pt-2">
							<fa fa-arrow-right class="me-1" />
							<span class="text-success">
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
</div>

<style lang="stylus">
	// Change colour of every second row
	tr:nth-child(2n)
		background var(--darker)

	td
		height 3.5rem
</style>
