<script lang="ts">
	export let tabData: ReturnType<typeof TabData>
</script>

<div class="flex flex-wrap">
	<TabNav
		bind:tabData
		vertical
		class="w-full lg:w-1/6 md:w-1/4 pb-6 md:pr-4" />
	<div class="w-full lg:w-5/6 md:w-3/4 {$$restProps.class}">
		<slot />
	</div>
</div>
