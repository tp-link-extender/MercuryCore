<script lang="ts">
	// Link to a place used on Games page.

	import { preloadData, pushState, goto } from "$app/navigation"

	export let place: {
		id: number
		name: string
		likeCount: number
		dislikeCount: number
		serverPing: number
		playerCount: number
	}
	export let num: number
	export let total: number

	const ratio = Math.floor(
		(place.likeCount / (place.likeCount + place.dislikeCount)) * 100
	)
</script>

<a
	on:click={async e => {
		if (e.metaKey) return
		e.preventDefault()

		const { href } = e.currentTarget,
			result = await preloadData(href)

		if (result.type == "loaded" && result.status == 200)
			pushState(href, { openPlace: result.data })
		else goto(href)
	}}
	in:fade|global={{ num, total }}
	class="card text-center light-text bg-darker no-underline text-base rounded-4 m-0"
	class:border-success={place.serverPing >=
		Math.floor(Date.now() / 1000) - 35}
	href="/place/{place.id}/{place.name}">
	<div
		class="row"
		class:opacity-50={place.serverPing <
			Math.floor(Date.now() / 1000) - 35}>
		<div class="col col-6">
			<div class="shadow overflow-hidden bg-black h-full">
				<img
					src="/place/{place.id}/{place.name}/icon"
					alt={place.name}
					class="w-full h-full" />
			</div>
		</div>
		<div class="col col-6 p-2 row">
			<p class="mb-1">
				{place.name}
			</p>
			<div class="mt-auto mb-1">
				<div class="float-start">
					<span>
						<fa fa-thumbs-up class="opacity-75" />
						{isNaN(ratio) ? "--" : ratio}%
					</span>
				</div>
				<div class="float-right">
					<span>
						<fa fa-user class="opacity-75" />
						{place.playerCount}
					</span>
				</div>
			</div>
		</div>
	</div>
</a>

<style lang="stylus">
	.card
		width 19.5rem
		+-lg()
			width 20.5rem
		+-md()
			width 25rem

	img
		// make sure the image is the same size while loading
		// as the image that will be loaded
		aspect-ratio 1
		width 100%
		height 100%
		object-fit cover

	p
		height 8rem
		transition all 0.3s

	a
		line-height 1.2
		transition all 0.2s
		&:hover
			transition all 0.2s
			.shadow::after
				box-shadow inset 0 0 4rem 0 #fff2

	.shadow
		position relative
		border-radius 1rem 0 0 1rem
		&::after
			transition all 0.3s
			content ""
			position absolute
			top 0
			left 0
			width 100%
			height 100%
</style>
