<script lang="ts">
	import type { PageData } from "./$types"

	export let data: PageData
</script>

<svelte:head>
	<title>Transactions - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">
	Transactions
	<a href="/transactions/your" class="btn btn-primary ms-4">Your transactions</a>
</h1>

<div class="container-fluid mt-5 mx-0 row">
	{#each data.transactions as transaction}
		<div class="light-text col-xxl-3 col-lg-4 col-md-6">
			<div class="transaction rounded-2 p-2">
				<span class="user">
					<a href="/user/{transaction.sender.number}" class="d-flex text-decoration-none">
						<div class="me-2 rounded-circle pfp">
							<img src={transaction.sender?.image} alt={transaction.sender.displayname} class="rounded-circle rounded-top-0" />
						</div>
						<p class="light-text my-auto fs-6 me-4 text-truncate">
							{transaction.sender.displayname}
						</p>
					</a>
				</span>

				<span class="my-auto text-light d-flex justify-content-center">
					<span>
						<span class="text-success">
							<i class="fa fa-gem" />
							{transaction.amountSent}
						</span>
						<span class="mx-1">
							<i class="fa fa-arrow-right mx-1" />
							{transaction.taxRate}% tax <i class="fa fa-arrow-right mx-1" />
						</span>
						<span class="text-success">
							<i class="fa fa-gem" />
							{Math.round((1 - transaction.taxRate / 100) * transaction.amountSent)}
						</span>
						<br />
						<span class="time">
							{transaction.time.toLocaleString()}
						</span>
					</span>
				</span>

				<span class="user2">
					<a href="/user/{transaction.receiver.number}" class="d-flex text-decoration-none justify-content-end">
						<p class="light-text my-auto fs-6 ms-4">
							{transaction.receiver.displayname}
						</p>
						<div class="ms-2 rounded-circle pfp">
							<img src={transaction.receiver?.image} alt={transaction.receiver.displayname} class="rounded-circle rounded-top-0" />
						</div>
					</a>
				</span>
			</div>
		</div>
	{/each}
</div>

<style lang="sass">

	@media only screen and (max-width: 767px)
		.user
			margin-bottom: -0.5rem
		.user2
			margin-top: -0.5rem

	.transaction
		background: var(--darker)
		border: 1px solid var(--accent)
		margin: 5px -7px

	.pfp
		background: var(--accent)
		width: 2.5rem
		height: 2.5rem


	img
		width: 2.5rem
		height: 2.5rem

	.time
		font-size: 0.7rem
</style>
