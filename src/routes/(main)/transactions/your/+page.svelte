<script lang="ts">
	import type { PageData } from "./$types"
	import fade from "$lib/fade"

	export let data: PageData
	//
</script>

<svelte:head>
	<title>Your transactions - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">
	Your transactions
	<!-- <a href="/transactions" class="btn btn-primary ms-4">All transactions</a> -->
</h1>

<div class="container mt-5">
	<table class="table m-auto">
		{#each data.transactions as transaction, num}
			<tr in:fade={{ num, total: data.transactions.length, max: 12 }} class="light-text">
				<td class="p-0">
					<a href="/user/{transaction.sender.number}" class="d-flex text-decoration-none">
						<div class="me-2 rounded-circle pfp">
							<img src={transaction.sender?.image} alt={transaction.sender.username} class="rounded-circle rounded-top-0" />
						</div>
						<p class="light-text my-auto fs-6 text-truncate">
							{transaction.sender.username}
						</p>
					</a>
				</td>

				<td class="p-0 d-flex justify-content-center">
					<div class="fs-6 currency">
						<span class="text-success">
							<i class="fa fa-gem" />
							{transaction.amountSent}
						</span>
						<i class="fa fa-arrow-right ms-1" />
					</div>
					<div>
						{transaction.taxRate}% tax
						<br />
						<small>
							{transaction.time.toLocaleString()}
						</small>
					</div>
					<div class="fs-6 currency">
						<i class="fa fa-arrow-right me-1" />
						<span class="text-success">
							<i class="fa fa-gem" />
							{Math.round((1 - transaction.taxRate / 100) * transaction.amountSent)}
						</span>
					</div>
				</td>

				<td class="p-0">
					<a href="/user/{transaction.receiver.number}" class="d-flex justify-content-end text-decoration-none">
						<p class="light-text my-auto fs-6">
							{transaction.receiver.username}
						</p>
						<div class="ms-2 rounded-circle pfp">
							<img src={transaction.receiver?.image} alt={transaction.receiver.username} class="rounded-circle rounded-top-0" />
						</div>
					</a>
				</td>

				<td class="p-0">
					{#if transaction.note && transaction.link}
						<a href={transaction.link} class="text-light">
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

<style lang="sass">
	.currency
		margin-top: 0.5rem

	// Change colour of every 2nd row
	tr:nth-child(2n)
		background: var(--darker)

	.pfp
		background: var(--accent)
		width: 2.5rem
		height: 2.5rem

	img
		width: 2.5rem
		height: 2.5rem
</style>
