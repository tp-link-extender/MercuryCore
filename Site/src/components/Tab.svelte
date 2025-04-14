<script lang="ts">
	import type { Snippet } from "svelte"
	import { fade } from "svelte/transition"

	let {
		tabData = $bindable(),
		children,
		class: class_
	}: {
		tabData: {
			tabs: string[]
			currentTab: string
			num: number
		}
		children?: Snippet
		class?: string
	} = $props()

	const num = ++tabData.num
</script>

{#if tabData.currentTab === tabData.tabs[num - 1]}
	<div
		class={["w-full", class_]}
		role="tabpanel"
		tabindex="0"
		in:fade={{ duration: 200 }}>
		{@render children?.()}
	</div>
{/if}
