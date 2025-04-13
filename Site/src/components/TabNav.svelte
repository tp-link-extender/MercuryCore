<script lang="ts">
	import { interpolateLab } from "d3-interpolate"
	import { tweened } from "svelte/motion"

	let {
		tabData = $bindable(),
		justify = false,
		vertical = false,
		class: class_
	}: {
		tabData: {
			name: string
			tabs: string[]
			currentTab: string
			url: string
			icons?: string[]
			num: number
		}
		justify?: boolean
		vertical?: boolean
		class: string
	} = $props()

	let colour = $state(
		tweened("white", {
			duration: 200,
			interpolate: interpolateLab
		})
	)
</script>

<ul
	class={[
		"flex flex-wrap list-none min-w-28 pl-0",
		vertical ? "vertical flex-col gap-2" : "pb-6",
		class_
	]}
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
				onclick={e => {
					e.preventDefault()
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
					<fa class="{tabData.icons[pos]} pr-2"></fa>
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
		--un-ring-color: hsla(var(--hue), 75%, 45%, 0.5);
	}

	:not(.activetab) > .tab {
		&:hover {
			background: hsla(var(--hue), 100%, 60%, 0.5);
		}
		&:active {
			background: hsla(var(--hue), 100%, 55%, 0.4);
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
