<script lang="ts">
	import type { PageData } from "./$types"

	export let data: PageData
</script>

<svelte:head>
	<title>Transactions - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">Transactions</h1>

<div class="container mt-5">
	{#each data.transactions as transaction}
		<div class="light-text">
			{transaction.sender.displayname} sent <i class="fa fa-gem"/> {transaction.amountSent},
			{transaction.receiver.displayname} received <i class="fa fa-gem"/> {Math.floor((1 - transaction.taxRate) * transaction.amountSent)} ({transaction.taxRate * 100}% tax)
		</div>
	{/each}
</div>

<style lang="sass">
	@media only screen and (min-width: 576px)
		.container
			width: 50rem
</style>
