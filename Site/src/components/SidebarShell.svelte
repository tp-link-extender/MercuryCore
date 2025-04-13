<script lang="ts">
	import type TabData from "$components/TabData"
	import TabNav from "$components/TabNav.svelte"

	let {
		tabData = $bindable(),
		space = false,
		children,
		class: class_ = ""
	}: {
		tabData: ReturnType<typeof TabData>
		space?: boolean
		children?: import("svelte").Snippet
		class?: string
	} = $props()
</script>

<div class={["flex <md:flex-wrap", { ["ctnr max-w-240" + class_]: space }]}>
	<TabNav bind:tabData vertical class="w-full md:w-75 pr-4 pb-6" />
	<div class="flex w-full">
		<div class={["w-full mx-auto", { ["max-w-240 " + class_]: space }]}>
			{@render children?.()}
		</div>
		<!-- I know this looks like a hack but it works like a charm -->
		<div class="<md:hidden shrink-9999 w-75"></div>
	</div>
</div>
