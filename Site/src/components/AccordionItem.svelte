<script lang="ts">
	import NoScript from "$components/NoScript.svelte"
	import YesScript from "$components/YesScript.svelte"
	import { type createAccordion, melt } from "@melt-ui/svelte"
	import type { Snippet } from "svelte"
	import { slide } from "svelte/transition"

	const {
		accordion,
		title,
		children
	}: {
		accordion: ReturnType<typeof createAccordion>
		title: string
		children: Snippet
	} = $props()

	const {
		elements: { content, item, trigger },
		helpers: { isSelected }
	} = accordion
</script>

<NoScript>
	<details name="details">
		<summary class="bg-darker p-2 px-4 rounded-2 block">
			{title}
		</summary>
		{@render children()}
	</details>
</NoScript>
<YesScript>
	<div use:melt={$item(title)}>
		<button
			use:melt={$trigger(title)}
			class="btn light-text bg-darker p-2 px-4 rounded-2 w-full text-left text-base">
			{title}
		</button>
		{#if $isSelected(title)}
			<div use:melt={$content(title)} transition:slide>
				{@render children()}
			</div>
		{/if}
	</div>
</YesScript>
