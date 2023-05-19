<script lang="ts">
	import { fade } from "svelte/transition"

	export let pos: number
	export let tabData: any

	const name = tabData.tabs[pos - 1]

	let div: HTMLDivElement
</script>

{#if tabData.currentTab == name || (!tabData.currentTab && name == tabData.tabs[0])}
	<div
		class="w-100"
		in:fade={{ duration: 200 }}
		bind:this={div}>
		<slot />
	</div>
{/if}
