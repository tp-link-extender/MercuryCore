<script lang="ts">
	import { enhance } from "$app/forms"
	import fade from "$lib/fade"

	export let data
</script>

<svelte:head>
	<title>Admin - Mercury</title>
</svelte:head>

<div class="container py-4">
	<h1 class="light-text mb-0">Admin - Transactions</h1>
	<a href="/admin" class="text-decoration-none">
		<i class="fas fa-caret-left" />
		Back to panel
	</a>
	<div class="row mt-4">
		<div class="col-lg-2 col-md-3 mb-4">
			<ul class="nav nav-tabs flex-column border-0">
				<li class="nav-item" role="presentation">
					<a
						class="nav-link active"
						data-bs-toggle="tab"
						href="#transactions"
						aria-selected="true"
						role="tab">
						Transactions
					</a>
				</li>
			</ul>
		</div>
		<div class="col-lg-10 col-md-9">
			<div id="myTabContent" class="tab-content">
				<div
					class="tab-pane fade active show"
					id="transactions"
					role="tabpanel">
					<div class="container">
						<table class="table table-responsive m-auto">
							{#each data.transactions as transaction, num}
								<tr
									in:fade={{
										num,
										total: data.transactions.length,
										max: 12,
									}}
									class="light-text">
									<td class="p-0">
										<a
											href="/user/{transaction.sender
												.number}"
											class="d-flex text-decoration-none">
											<div
												class="me-2 rounded-circle pfp bg-a">
												<img
													src={transaction.sender
														?.image}
													alt={transaction.sender
														.username}
													class="rounded-circle rounded-top-0" />
											</div>
											<p
												class="light-text my-auto fs-6 text-truncate">
												{transaction.sender.username}
											</p>
										</a>
									</td>

									<td
										class="p-0 d-flex justify-content-center">
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
												{Math.round(
													(1 -
														transaction.taxRate /
															100) *
														transaction.amountSent
												)}
											</span>
										</div>
									</td>

									<td class="p-0">
										<a
											href="/user/{transaction.receiver
												.number}"
											class="d-flex justify-content-end text-decoration-none">
											<p class="light-text my-auto fs-6">
												{transaction.receiver.username}
											</p>
											<div
												class="ms-2 rounded-circle pfp bg-a">
												<img
													src={transaction.receiver
														?.image}
													alt={transaction.receiver
														.username}
													class="rounded-circle rounded-top-0" />
											</div>
										</a>
									</td>

									<td class="p-0">
										{#if transaction.note && transaction.link}
											<a
												href={transaction.link}
												class="text-light">
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
				</div>
			</div>
		</div>
	</div>
</div>

<style lang="sass">
	.nav-tabs .nav-item.show .nav-link,
	.nav-tabs .nav-link.active 
		color: rgb(255, 255, 255)
		background-color: rgb(13, 109, 252)
		border-color: var(--bs-nav-tabs-link-active-border-color)
		border-radius: 0.375rem

	.nav-tabs .nav-link 
		margin-bottom: calc(0 * var(--bs-nav-tabs-border-width))
		background: 0 0
		border: var(--bs-nav-tabs-border-width) solid transparent
		border-radius: 0.375rem

	.nav-link
		border-radius: 0
		color: var(--light-text)

	.currency
		margin-top: 0.5rem
	.pfp
		width: 2.5rem
		height: 2.5rem

	img
		width: 2.5rem
		height: 2.5rem

	tr:nth-child(2n)
		background: var(--darker)
</style>
