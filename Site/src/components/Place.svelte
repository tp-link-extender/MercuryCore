<script lang="ts">
	// Link to a place used on the homepage and the search page.

	import fade from "$lib/fade"
	import { encode } from "$lib/urlName"

	interface Props {
		place: {
		id: number
		name: string
		likeCount: number
		dislikeCount: number
		playerCount: number
	};
		num: number;
		total: number;
	}

	let { place, num, total }: Props = $props();

	const slug = encode(place.name)
	const ratio = Math.floor(
		(place.likeCount / (place.likeCount + place.dislikeCount)) * 100
	)
</script>

<a
	in:fade|global={{ num, total }}
	class="rounded-3 text-center light-text no-underline"
	href="/place/{place.id}/{slug}">
	<div id="shadow" class="rounded-1 mb-2 overflow-hidden bg-black">
		<img
			src="/place/{place.id}/{slug}/icon"
			alt={place.name}
			class="w-full h-full" />
	</div>
	<p class="mb-0 pb-1">
		{place.name}
	</p>
	<span class="float-start pl-1 pt-1">
		<fa fa-thumbs-up class="opacity-75"></fa>
		{Number.isNaN(ratio) ? "--" : ratio}%
	</span>
	<span class="float-end pr-1 pt-1">
		<fa fa-user class="opacity-75"></fa>
		{place.playerCount}
	</span>
</a>

<style>
	a {
		line-height: 1.2;
		transition: all 0.2s;
		&:hover {
			transition: all 0.2s;
			& #shadow::after {
				box-shadow: inset 0 0 4rem 0 rgba(255, 255, 255, 0.133);
			}
		}
	}

	#shadow {
		aspect-ratio: 1;
		position: relative;
		&::after {
			transition: all 0.3s;
			content: "";
			position: absolute;
			top: 0;
			left: 0;
			width: 100%;
			height: 100%;
		}
	}
</style>
