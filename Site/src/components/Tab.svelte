<script lang="ts">
	import { fade } from "svelte/transition"

	interface Props {
		tabData: {
		tabs: string[]
		currentTab: string
		num: number
	};
		children?: import('svelte').Snippet;
		[key: string]: any
	}

	let { tabData = $bindable(), children, ...rest }: Props = $props();
	const num = ++tabData.num
</script>

{#if tabData.currentTab === tabData.tabs[num - 1]}
	<div
		class="w-full {rest.class || ''}"
		role="tabpanel"
		tabindex="0"
		in:fade={{ duration: 200 }}>
		{@render children?.()}
	</div>
{/if}
