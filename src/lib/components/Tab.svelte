<script lang="ts">
	import { fade } from "svelte/transition"

	export let tabData: {
		tabs: string[]
		currentTab: string
		num: number
	}
	const num = ++tabData.num
</script>

{#if tabData.currentTab === tabData.tabs[num - 1]}
	<div
		class="w-full {$$restProps.class || ''}"
		role="tabpanel"
		tabindex="0"
		in:fade={{ duration: 200 }}>
		<slot />
	</div>
{/if}
