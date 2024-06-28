<script lang="ts">
	import { interpolateLab } from "d3-interpolate"
	import { tweened } from "svelte/motion"

	export let tabData: {
		name: string
		tabs: string[]
		currentTab: string
		url: string
		icons?: string[]
		num: number
	}
	export let justify = false
	export let vertical = false

	let colour = tweened("white", {
		duration: 200,
		interpolate: interpolateLab
	})
</script>

<ul
	class="nav min-w-28 mt-0 {vertical
		? 'vertical flex-col gap-2'
		: 'pb-6'} {$$restProps.class || ''}"
	class:justified={justify}
	role="tablist">
	{#each tabData.tabs as tab, pos}
		<li
			class="item {vertical && tabData.currentTab === tab
				? 'activetab'
				: ''} {vertical ? 'rounded-2' : 'p-1'}"
			class:active={!vertical && tabData.currentTab === tab}
			style="border-bottom-color: {$colour}"
			data-sveltekit-preload-data="off">
			<a
				class="block tab no-underline {vertical
					? 'p-4 py-2'
					: 'p-3 py-1'} rounded-2 {tabData.currentTab === tab
					? 'disabled active'
					: ''}"
				href="?{(() => {
					const currentSearch = new URL(tabData.url).searchParams
					currentSearch.set(tabData.name, tab)
					return currentSearch.toString()
				})()}"
				on:click|preventDefault={() => {
					// get css variable --hue
					const hue = getComputedStyle(
						document.body
					).getPropertyValue("--hue")
					colour = tweened(`hsl(${hue}, 100%, 60%)`, {
						duration: 500,
						interpolate: interpolateLab
					})
					tabData.currentTab = tab
					$colour = "white"
				}}>
				{#if tabData.icons}
					<i class="{tabData.icons[pos]} pr-2" />
				{/if}
				{tab}
			</a>
		</li>
	{/each}
</ul>

<style>
	.active.item {
		border-bottom-width: 2px;
		border-bottom-style: solid;
	}
	.activetab.item {
		background: var(--accent2);
	}

	.justified .item {
		flex-basis: 0;
		flex-grow: 1;
		text-align: center;
		width: 100%;
	}

	.item,
	.tab {
		transition: background-color 0.2s;
	}

	.tab {
		color: var(--light-text) !important;
		border-width: 0px 0px 2px !important;
		--un-ring-color: rgba(86, 29, 201, 0.5);
	}

	:not(.activetab) > .tab {
		&:hover {
			background: rgba(119, 51, 255, 0.5);
		}
		&:active {
			background: rgba(102, 26, 255, 0.4);
		}
	}

	.vertical .tab {
		@apply ring-offset-neutral-9;
		@media (prefers-reduced-motion: no-preference) {
			transition:
				all 0.3s,
				box-shadow 0.1s ease-in-out;
		}

		&:focus:not(:active) {
			@apply ring-2 ring-offset-2;
		}
		&:active {
			@apply ring-3;
		}
	}
</style>
