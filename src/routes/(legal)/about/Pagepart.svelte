<script lang="ts">
	// Used to allow a part of the page to be displayed fullscreen or on either side, and to be animated in.

	import { fly } from "svelte/transition"
	import { inview } from "svelte-inview"

	let isInView = true

	const inView = (
		e: Event & {
			currentTarget: EventTarget & HTMLDivElement
		} & { detail?: { inView: boolean } } //(isInView = !!e?.detail?.inView)
	) => true
</script>

<div
	class="flex flex-row justify-center 'min-w-screen {$$restProps.class || ''}"
	use:inview={{ unobserveOnEnter: true, rootMargin: "-20%" }}
	on:change={inView}>
	{#if isInView}
		<div class="flex flex-row items-center min-h-screen">
			<div>
				<!-- in:fly={{ y: -100, duration: 500 }} -->
				<slot />
			</div>
		</div>
	{:else}
		<div class="min-h-screen" />
	{/if}
</div>
