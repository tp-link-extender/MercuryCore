<script lang="ts">
	// Used to allow a part of the page to be displayed fullscreen or on either side, and to be animated in.

	import type { Snippet } from "svelte"
	import { fly } from "svelte/transition"
	import { inview } from "svelte-inview"

	const {
		fullheight = false,
		children,
		...rest
	}: {
		fullheight?: boolean
		children: Snippet
		class?: string
	} = $props()

	let isInView = $state(true)

	function inView(
		e: Event & {
			currentTarget: EventTarget & HTMLDivElement
		} & { detail?: { inView: boolean } }
	) {
		isInView = !!e?.detail?.inView
	}
</script>

<div
	class="flex flex-row justify-center min-w-screen {rest.class || ''}"
	use:inview={{ unobserveOnEnter: true, rootMargin: "-20%" }}
	onchange={inView}>
	{#if isInView}
		<div
			in:fly={{ y: -100, duration: 500 }}
			class="flex flex-row items-center {fullheight
				? 'min-h-screen'
				: 'py-16'}">
			<div>
				{@render children()}
			</div>
		</div>
	{:else}
		<div class="min-h-screen"></div>
	{/if}
</div>
