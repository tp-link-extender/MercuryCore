<script lang="ts">
	export let data
</script>

<Head title="Your transactions" />

<h1 class="text-center light-text">
	Your transactions
	<!-- <a href="/transactions" class="btn btn-primary ms-6">All transactions</a> -->
</h1>

<div class="container mt-12">
	<table class="table m-auto">
		{#each data.transactions as transaction, num}
			<tr
				in:fade={{ num, total: data.transactions.length, max: 12 }}
				class="light-text">
				<td class="p-0">
					<a
						href="/user/{transaction.sender.number}"
						class="flex no-underline">
						<div class="me-2 rounded-full pfp bg-a">
							<img
								src="/api/avatar/{transaction.sender?.username}"
								alt={transaction.sender.username}
								class="rounded-full rounded-top-0" />
						</div>
						<p class="light-text my-auto text-base truncate">
							{transaction.sender.username}
						</p>
					</a>
				</td>

				<td class="p-0 flex justify-center">
					<div class="text-base currency">
						<span class="text-emerald-500">
							<i class="fa fa-gem" />
							{transaction.amountSent}
						</span>
						<i class="fa fa-arrow-right light-text ms-1" />
					</div>
					<div class="light-text">
						{transaction.taxRate}% tax
						<br />
						<small>
							{transaction.time.toLocaleString()}
						</small>
					</div>
					<div class="fs-6 currency">
						<i class="fa fa-arrow-right light-text me-1" />
						<span class="text-emerald-500">
							<i class="fa fa-gem" />
							{Math.round(
								(1 - transaction.taxRate / 100) *
									transaction.amountSent
							)}
						</span>
					</div>
				</td>

				<td class="p-0">
					<a
						href="/user/{transaction.receiver.number}"
						class="flex justify-end no-underline">
						<p class="light-text my-auto text-base">
							{transaction.receiver.username}
						</p>
						<div class="ms-2 rounded-full pfp bg-a">
							<img
								src="/api/avatar/{transaction.receiver
									?.username}"
								alt={transaction.receiver.username}
								class="rounded-full rounded-top-0" />
						</div>
					</a>
				</td>

				<td class="p-0">
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
	.currency
		margin-top 0.5rem

	// Change colour of every 2nd row
	tr:nth-child(2n)
		background var(--darker)
		.pfp
			background var(--background)

	.pfp
		width 2.5rem
		height 2.5rem

	img
		width 2.5rem
		height 2.5rem
</style>
