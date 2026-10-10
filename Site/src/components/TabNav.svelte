<script lang="ts">
	import { interpolateLab } from "d3-interpolate"
	import type { ClassValue } from "svelte/elements"
	import { Tween } from "svelte/motion"

	type Group = { name: string, tabs: string[] }

	let {
		tabData = $bindable(),
		justify = false,
		vertical = false,
		class: class_ = ""
	}: {
		tabData: {
			name: string
			tabs: string[]
			currentTab: string
			url: string
			icons?: string[]
			groups?: Group[]
			num: number
		}
		justify?: boolean
		vertical?: boolean
		class?: ClassValue
	} = $props()

	// prevents nested tabs from breaking
	$effect(() => {
		tabData.num = 0
	})

	let colour = new Tween("white", {
		duration: 200,
		interpolate: interpolateLab
	})

	// Tabs belonging to a group are rendered inside a dropdown tab,
	// which shows up in the position of the first tab of the group
	type NavItem =
		| { type: "tab", tab: string, icons?: string[] }
		| { type: "group", name: string, tabs: string[] }

	let items = $derived.by(() => {
		const out: NavItem[] = []
		const emitted = new Set<string>()
		for (const tab of tabData.tabs) {
			const group = (tabData.groups ?? []).find(
				g => g.name === tab || (g.tabs ?? []).includes(tab)
			)
			if (group) {
				if (!emitted.has(group.name)) {
					emitted.add(group.name)
					out.push({ type: "group", name: group.name, tabs: group.tabs })
				}
				continue
			}
			out.push({ type: "tab", tab, icons: tabData.icons })
		}
		return out
	})

	const tabHref = tab => {
		const currentSearch = new URL(tabData.url).searchParams
		currentSearch.set(tabData.name, tab)
		return `?${currentSearch.toString()}`
	}

	const switchTab = (tab: string, e: Event) => {
		e.preventDefault()
		// get css variable --hue
		const hue = getComputedStyle(document.body).getPropertyValue("--hue")
		colour.set(`hsl(${hue}, 100%, 60%)`, { duration: 0 })
		tabData.currentTab = tab
		colour.set("white")
	}
</script>

<ul
	class={[
		"flex flex-wrap list-none min-w-28 shrink-0",
		vertical ? "vertical flex-col gap-2 <md:pl-4" : "pl-0 pb-6",
		class_,
		{ justified: justify }
	]}
	role="tablist">
	{#each items as item}
		{#if item.type === "group"}
			{@const groupActive =
				item.name === tabData.currentTab ||
				item.tabs.includes(tabData.currentTab)}
			<li
				class={["item", vertical ? "rounded-2" : "p-1", { active: groupActive }]}
				style="border-bottom-color: {colour.current}"
				data-sveltekit-preload-data="off">
				<span class="dropdown">
					<a
						class={[
							"tab block bg-transparent no-underline rounded-2 cursor-pointer px-3 py-1",
							{ "disabled active": groupActive }
						]}
						href={tabHref(item.name)}
						tabindex="0"
						onclick={e => {
							// blur so the dropdown doesn't linger after selecting a group view
							switchTab(item.name, e)
							e.currentTarget?.blur()
						}}>
						{item.name}
					</a>
					<div class="dropdown-content">
						<ul class="p-2 rounded-3">
							{#each item.tabs as tab}
								<li>
									<a
										class={[
											"tab block px-2 py-1 no-underline rounded-2 text-start",
											{ "font-bold accent-text": tabData.currentTab === tab }
										]}
										href={tabHref(tab)}
										onclick={e => {
											switchTab(tab, e)
											e.currentTarget?.blur()
										}}>
										{tab}
									</a>
								</li>
							{/each}
						</ul>
					</div>
				</span>
			</li>
		{:else}
			<li
				class={[
					"item",
					vertical ? "rounded-2" : "p-1",
					{
						activetab: vertical && tabData.currentTab === item.tab,
						active: !vertical && tabData.currentTab === item.tab
					}
				]}
				style="border-bottom-color: {colour.current}"
				data-sveltekit-preload-data="off">
				<a
					class={[
						"block tab no-underline rounded-2",
						vertical ? "pl-4 py-2" : "px-3 py-1",
						{ "disabled active": tabData.currentTab === item.tab }
					]}
					href={tabHref(item.tab)}
					onclick={e => switchTab(item.tab, e)}>
					{#if item.icons}
						<fa class="{item.icons[tabData.tabs.indexOf(item.tab)]} pr-2"></fa>
					{/if}
					{item.tab}
				</a>
			</li>
		{/if}
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

	/* stop long labels like "T-Shirts" from wrapping in justified navs */
	.tab {
		white-space: nowrap;
	}
	.vertical .tab {
		white-space: normal;
	}

	:not(.activetab) > .tab,
	:not(.active) > .dropdown .tab {
		&:hover {
			background: hsla(var(--hue), 100%, 60%, 0.5);
		}
		&:active {
			background: hsla(var(--hue), 100%, 55%, 0.4);
		}
	}

	.dropdown-content {
		/* small gap below the trigger, transparent so the dropdown stays open while crossing it */
		padding-top: 0.35rem;
	}

	.dropdown-content .tab {
		--un-ring-color: hsla(var(--hue), 75%, 45%, 0.5);
		&:focus:not(:active) {
			@apply ring-2;
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
