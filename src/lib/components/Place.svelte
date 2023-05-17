<script lang="ts">
	// Link to a place used on the homepage or on a user's profile.

	import fade from "$lib/fade"

	export let place: {
		id: number
		name: string
		ratio: string | number
		gameSessions?: any[]
	}
	export let num: number
	export let total: number
</script>

<a
	in:fade={{ num, total }}
	class="rounded-3 text-center light-text text-decoration-none h6"
	href="/place/{place.id}/{place.name}">
	<div id="shadow" class="rounded-1 mb-2 overflow-hidden bg-black">
		<img
			src="/place/{place.id}/{place.name}/icon"
			alt={place.name}
			class="w-100 h-100" />
	</div>
	<p class="mb-1">
		{place.name}
	</p>
	<span class="float-start ms-1">
		<i class="fa fa-thumbs-up opacity-75" />
		{place.ratio}%
	</span>
	<span class="float-end me-1">
		<i class="fa fa-user opacity-75" />
		{place.gameSessions?.length}
	</span>
</a>

<style lang="sass">
	a
		transition: all 0.2s
		&:hover
			transition: all 0.2s
			#shadow::after
				box-shadow: inset 0 0 4rem 0 #fff2

	#shadow
		aspect-ratio: 1
		position: relative
		&::after
			transition: all 0.3s
			content: ""
			position: absolute
			top: 0
			left: 0
			width: 100%
			height: 100%
</style>
