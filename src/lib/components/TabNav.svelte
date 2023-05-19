<script lang="ts">
	import { tweened, type Tweened } from "svelte/motion"
	import { interpolateLab } from "d3-interpolate"

	export let tabData: any
	export let vertical: boolean = false
	export let tabs: boolean = false

	let colour: Tweened<string>
</script>

<ul
	class="nav mb-4 {vertical ? 'nav-vert-pills flex-column me-4' : ''} {tabs
		? 'nav-tabs flex-column border-0 me-4'
		: 'nav-pills'}"
	role="tablist">
	{#each tabData.tabs as tab}
		<li class="nav-item">
			<a
				class:rounded-0={!tabs}
				class="nav-link light-text {tabData.currentTab == tab ||
				(!tabData.currentTab && tab == tabData.tabs[0])
					? 'disabled active'
					: ''}"
				style={tabs ? "" : `border-color: ${$colour || 'rgb(52, 89, 230)'}`}
				href="?{tabData.name}={tab}"
				on:click|preventDefault={() => {
					colour = tweened("rgb(255, 255, 255)", {
						duration: 200,
						interpolate: interpolateLab,
					})
					tabData.currentTab = tab
					$colour = "rgb(52, 89, 230)"
				}}>
				{tab}
			</a>
		</li>
	{/each}
</ul>

{#if tabs}
	<style lang="sass">
		.nav-tabs
			min-width: 7rem
			.nav-item.show .nav-link, .nav-link.active 
				color: white
				background-color: rgb(13, 109, 252)
				border-color: var(--bs-nav-tabs-link-active-border-color)
				border-radius: 0.375rem

			.active
				border: 1px solid

		.nav-link
			margin-bottom: calc(0 * var(--bs-nav-tabs-border-width))
			background: 0 0
			border: var(--bs-nav-tabs-border-width) solid transparent
			border-radius: 0.375rem
			color: var(--light-text)
	</style>
{:else}
	<style lang="sass">
		.nav-pills .active
			background: transparent !important
			border-style: solid
			border-width: 0px 0px 2px 0px
			color: var(--light-text)
			border-colour: rgb(52, 89, 230)
	</style>
{/if}
