<script lang="ts">
	import { melt, type createAccordion } from "@melt-ui/svelte"
	import { slide } from "svelte/transition"

	export let accordion: ReturnType<typeof createAccordion> // odd type imports but ok
	export let title: string

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
		<slot />
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
				<slot />
			</div>
		{/if}
	</div>
</YesScript>
