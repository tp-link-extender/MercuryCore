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
	export let vertical: boolean = false
	export let justify: boolean = false
	export let tabs: boolean = false

	let colour: Tweened<string>
</script>

<ul
	class="nav {vertical ? 'nav-vert-pills flex-column' : 'mb-4'} {tabs
		? 'nav-tabs flex-column border-0 me-4'
		: 'nav-pills'}"
	class:nav-justified={justify}
	role="tablist">
	{#each tabData.tabs as tab, pos}
		<li class="nav-item" data-sveltekit-preload-data="off">
			<a
				class:rounded-0={!tabs}
				class="nav-link light-text {tabData.currentTab == tab
					? 'disabled active'
					: ''}"
				style={tabs
					? ""
					: `border-color: ${$colour || "rgb(52, 89, 230)"}`}
				href="?{(() => {
					const currentSearch = new URL(tabData.url).searchParams
					currentSearch.set(tabData.name, tab)
					return currentSearch.toString()
				})()}"
				on:click|preventDefault={() => {
					colour = tweened("rgb(255, 255, 255)", {
						duration: 200,
						interpolate: interpolateLab,
					})
					tabData.currentTab = tab
					$colour = "rgb(52, 89, 230)"
				}}>
				{#if tabData.icons}
					<i class={tabData.icons[pos]} />
				{/if}
				{tab}
			</a>
		</li>
	{/each}
</ul>

{#if tabs}
	<style lang="stylus">
		.nav-tabs
			min-width 7rem
			.nav-item.show .nav-link
			.nav-link.active
				color white
				background-color rgb(13, 109, 252)
				border-color var(--bs-nav-tabs-link-active-border-color)
				border-radius 0.375rem

			.active
				border 1px solid

		.nav-link
			margin-bottom calc(0 * var(--bs-nav-tabs-border-width))
			background 0 0
			border var(--bs-nav-tabs-border-width) solid transparent
			border-radius 0
			border-width 0px 0px 2px !important
			color var(--light-text)
	</style>
{:else}
	<style lang="stylus">
		.nav-pills .active
			background transparent !important
			border-style solid
			border-width 0px 0px 2px 0px
			color var(--light-text)
			border-color rgb(52, 89, 230)
	</style>
{/if}
