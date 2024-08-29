<script lang="ts">
	import fade from "$lib/fade"

	export let thumbnails: number[]
	export let id: string
	export let slug: string

	function scroll(e: MouseEvent) {
		const url = new URL((e.target as HTMLAnchorElement)?.href).hash.slice(1)
		document.getElementById(url)?.scrollIntoView(false) // (false) prevents page scrolling to top of element
	}
</script>

<div
	in:fade
	class="carousel inline-flex overflow-hidden scroll-smooth rounded-4">
	{#each thumbnails as _, i}
		{@const thumbs = thumbnails.length}
		<div
			id="slide{i + 1}"
			class="carousel-item box-content flex-none relative w-full"
			class:active={!i}>
			<img
				src="/place/{id}/{slug}/thumbnail/{i + 1}"
				class="w-full"
				alt="Placeholder place thumbnail" />
			{#if thumbs > 1}
				<div
					class="absolute flex justify-between top-1/2 -translate-y-1/2 left-4 right-4">
					<a
						href="#slide{i < 1 ? thumbs : i}"
						class="carousel-button"
						on:click|preventDefault={scroll}>
						❮
					</a>
					<a
						href="#slide{i === thumbs - 1 ? 1 : i + 2}"
						class="carousel-button"
						on:click|preventDefault={scroll}>
						❯
					</a>
				</div>
			{/if}
		</div>
	{/each}
</div>

<style>
	.carousel {
		scroll-snap-type: x mandatory;
	}
	.carousel-item {
		scroll-snap-align: start;
	}

	.carousel-button {
		@apply flex items-center justify-center text-white no-underline size-10 rounded-full;
		background: var(--background);
		border: 1px solid var(--accent3);
	}
</style>
