<script lang="ts">
	// Link to a place used on the homepage and the search page.

	import { encode } from "$lib/urlName"

	export let place: {
		id: number
		name: string
		likeCount: number
		dislikeCount: number
		playerCount: number
	}
	export let num: number
	export let total: number

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
		<fa fa-thumbs-up class="opacity-75" />
		{isNaN(ratio) ? "--" : ratio}%
	</span>
	<span class="float-right pr-1 pt-1">
		<fa fa-user class="opacity-75" />
		{place.playerCount}
	</span>
</a>

<style lang="stylus">
	a
		line-height 1.2
		transition all 0.2s
		&:hover
			transition all 0.2s
			#shadow::after
				box-shadow inset 0 0 4rem 0 #fff2

	#shadow
		aspect-ratio 1
		position relative
		&::after
			transition all 0.3s
			content ""
			position absolute
			top 0
			left 0
			width 100%
			height 100%
</style>
