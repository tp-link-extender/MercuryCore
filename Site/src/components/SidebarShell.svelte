<script lang="ts">
	import type TabData from "$components/TabData"
	import TabNav from "$components/TabNav.svelte"
	import type { ClassValue } from "svelte/elements"

	let {
		tabData = $bindable(),
		space = false,
		children,
		class: class_ = ""
	}: {
		tabData: ReturnType<typeof TabData>
		space?: boolean
		children?: import("svelte").Snippet
		class?: ClassValue
	} = $props()
</script>

<div class={["flex <md:flex-wrap", space ? "px-4" : "ctnr max-w-240 " + class_]}>
	<TabNav
		bind:tabData
		vertical
		class={["w-full md:w-75 pr-4 pb-6", { "pl-0": !space }]} />
	<div class="flex w-full justify-center">
		<div class={["w-full", { ["max-w-240 " + class_]: space }]}>
			{@render children?.()}
		</div>
		<!-- I know this looks like a hack but it works like a charm -->
		<div class="<md:hidden shrink-9999 w-75	min-w-4"></div>
	</div>
</div>
