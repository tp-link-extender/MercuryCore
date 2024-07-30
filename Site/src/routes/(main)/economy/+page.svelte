<script lang="ts">
	import Head from "$components/Head.svelte"
	import beautifyCurrency from "$lib/beautifyCurrency"

	export let data

	const [c1, c2, c3, c4] = beautifyCurrency(data.balance)
</script>

<Head name={data.siteName} title="Economy" />

<h1 class="text-center">Economy</h1>

<div class="ctnr pt-12 grid lg:grid-cols-[1fr_1fr] gap-4">
	<div class="card bg-darker p-4">
		Current balance
		<div class="flex flex-row items-center text-2rem">
			<span class="pr-2 text-emerald-6">{data.currencySymbol}</span>
			<span class="balancenum flex flex-row text-emerald-6">
				<span class="text-emerald-9">{c1}</span>
				{c2}
				<span class={c3 ? "text-emerald-6" : "text-emerald-9"}>.</span>
				{c3}
				<span class="text-emerald-9">{c4}</span>
			</span>
		</div>
	</div>
	<div class="border-[--accent] border-solid">
		<div class="p-4 bg-darker">
			Darker
			<span class="grey-text">Grey text</span>
		</div>
		<div class="p-4">
			Background
			<span class="grey-text">Grey text</span>
		</div>
		<div class="p-4 bg-a">
			Accent
			<span class="grey-text">Grey text</span>
		</div>
		<div class="p-4 bg-a1">
			Accent1
			<span class="grey-text">Grey text</span>
		</div>
		<div class="p-4 bg-a2">
			Accent2
			<span class="grey-text">Grey text</span>
		</div>
		<div class="p-4 bg-a3">
			Accent3
			<span class="grey-text">Grey text</span>
		</div>
		<div class="p-4 flex gap-4">
			<button class="btn btn-primary">Primary</button>
			<button class="btn btn-secondary">Secondary</button>
			<button class="btn btn-tertiary">Tertiary</button>
			<button class="btn btn-quatenary">Quatenary</button>
		</div>
	</div>
</div>

<style>
	.balancenum,
	.balancenum span {
		font-feature-settings: "tnum", "calt", "zero";
	}
</style>
