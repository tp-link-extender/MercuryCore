<script lang="ts">
	import Head from "$lib/components/Head.svelte"

	export let data

	const { balance } = data

	const beforePoint = Math.floor(balance / 1e6).toString()
	const zerosBefore = "0".repeat(6 - beforePoint.length)
	const afterPoint = (balance % 1e6).toString().replace(/0+$/, "")
	const zerosAfter = "0".repeat(6 - afterPoint.length)
</script>

<Head title="Economy" />

<h1 class="text-center">Economy</h1>

<div class="ctnr pt-12 grid lg:grid-cols-[1fr_1fr] gap-4">
	<div
		class="balance card bg-darker flex flex-row items-center p-4 text-emerald-6 text-2rem">
		<fa fa-gem class="pr-3" />
		<span class="balancenum flex flex-row text-emerald-6">
			<span class="text-emerald-9">{zerosBefore}</span>
			{beforePoint}.{afterPoint}
			<span class="text-emerald-9">{zerosAfter}</span>
		</span>
	</div>
</div>

<style>
	.balance {
		border: 1px solid var(--accent);
	}
	.balancenum,
	.balancenum span {
		font-feature-settings: "tnum", "calt", "zero";
	}
</style>
