<script lang="ts">
	import type TabData from "$components/TabData"
	import TabNav from "$components/TabNav.svelte"

	export let tabData: ReturnType<typeof TabData>
	export let space = false
</script>

<div
	class="flex <md:flex-wrap {space
		? ''
		: 'ctnr max-w-240 ' + $$restProps.class || ''}">
	<TabNav bind:tabData vertical class="w-full md:w-75 pr-4 pb-6" />
	<div class="flex w-full">
		<div
			class="w-full mx-auto {space
				? 'max-w-240 ' + $$restProps.class || ''
				: ''}">
			<slot />
		</div>
		<!-- I know this looks like a hack but it works like a charm -->
		<div class="<md:hidden shrink-9999 w-75"></div>
	</div>
</div>
