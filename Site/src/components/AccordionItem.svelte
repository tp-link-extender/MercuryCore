<script lang="ts">
	import type { Accordion, AccordionItem } from "melt/builders"
	import type { Snippet } from "svelte"
	import { slide } from "svelte/transition"
	import NoScript from "$components/NoScript.svelte"
	import YesScript from "$components/YesScript.svelte"

	const {
		accordion,
		ai,
		children
	}: {
		accordion: Accordion
		ai: AccordionItem<{
			title: string
		}>
		children: Snippet
	} = $props()

	const item = accordion.getItem(ai)
</script>

<NoScript>
	<details name="details" class="bg-darker rounded-2">
		<summary class="p-2 px-4 block">
			{item.item.title}
		</summary>
		{@render children()}
	</details>
</NoScript>
<YesScript>
	<div class="bg-darker rounded-2">
		<button
			{...item.trigger}
			class="btn light-text p-2 px-4 w-full text-(left base)">
			{item.item.title}
		</button>

		{#if item.isExpanded}
			<div {...item.content} transition:slide>
				{@render children()}
			</div>
		{/if}
	</div>
</YesScript>
