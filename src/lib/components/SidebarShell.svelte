<script lang="ts">
	export let tabData: ReturnType<typeof TabData>
</script>

<div class="flex <md:flex-wrap">
	<TabNav bind:tabData vertical class="w-full md:w-75 pr-4 pb-6" />
	<div class="flex w-full">
		<div class="w-full max-w-240 mx-auto {$$restProps.class || ''}">
			<slot />
		</div>
		<!-- I know this looks like a hack but it works like a charm -->
		<div class="<md:hidden shrink-9999 w-75"></div>
	</div>
</div>
