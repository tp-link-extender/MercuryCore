<script lang="ts">
	import { tweened, type Tweened } from "svelte/motion"
	import { interpolateLab } from "d3-interpolate"

	export let tabData: {
		name: string
		tabs: string[]
		currentTab: string
		url: string
		icons?: string[]
		num: number
	}
	export let justify: boolean = false
	export let vertical: boolean = false

	let colour = tweened("#fff", {
		duration: 200,
		interpolate: interpolateLab,
	})
</script>

<ul
	class="nav {vertical ? 'flex-column gap-2 pe-6' : 'pb-6'}"
	class:justified={justify}
	role="tablist">
	{#each tabData.tabs as tab, pos}
		<li
			class="item {vertical && tabData.currentTab == tab
				? 'activeTab'
				: ''} {vertical ? 'rounded-2' : 'p-1'}"
			class:active={!vertical && tabData.currentTab == tab}
			style="border-bottom-color: {$colour}"
			data-sveltekit-preload-data="off">
			<a
				class="d-block tab text-decoration-none light-text {vertical
					? 'p-4 py-2'
					: 'p-3 py-1'} rounded-2 {tabData.currentTab == tab
					? 'disabled active'
					: ''}"
				href="?{(() => {
					const currentSearch = new URL(tabData.url).searchParams
					currentSearch.set(tabData.name, tab)
					return currentSearch.toString()
				})()}"
				on:click|preventDefault={() => {
					colour = tweened("#7531ff", {
						duration: 500,
						interpolate: interpolateLab,
					})
					tabData.currentTab = tab
					$colour = "#fff"
				}}>
				{#if tabData.icons}
					<i class={tabData.icons[pos]} />
				{/if}
				{tab}
			</a>
		</li>
	{/each}
</ul>

<style lang="stylus">
	.nav
		min-width 7rem

	.active.item
		border-bottom-width 2px
		border-bottom-style solid
	.activeTab.item
		background var(--accent2)


	.justified .item
		flex-basis 0
		flex-grow 1
		text-align center
		width 100%

	.item
	.tab
		transition background-color 0.2s
	.tab
		background 0 0
		border-radius 0
		border-width 0px 0px 2px !important
		color var(--light-text)
		&:hover
			background #7531ff7f
</style>
