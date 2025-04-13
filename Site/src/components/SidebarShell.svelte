<script lang="ts">
	import type TabData from "$components/TabData"
	import TabNav from "$components/TabNav.svelte"

	interface Props {
		tabData: ReturnType<typeof TabData>;
		space?: boolean;
		children?: import('svelte').Snippet;
		[key: string]: any
	}

	let { tabData = $bindable(), space = false, children, ...rest }: Props = $props();
</script>

<div
	class="flex <md:flex-wrap {space
		? ''
		: 'ctnr max-w-240 ' + rest.class || ''}">
	<TabNav bind:tabData vertical class="w-full md:w-75 pr-4 pb-6" />
	<div class="flex w-full">
		<div
			class="w-full mx-auto {space
				? 'max-w-240 ' + rest.class || ''
				: ''}">
			{@render children?.()}
		</div>
		<!-- I know this looks like a hack but it works like a charm -->
		<div class="<md:hidden shrink-9999 w-75"></div>
	</div>
</div>
