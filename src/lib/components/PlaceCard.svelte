<script lang="ts">
	// Link to a place used on Games page.

	export let place: {
		id: number
		name: string
		ratio: string | number
		serverPing: number
		gameSessions?: any[]
	}
	export let num: number
	export let total: number
</script>

<a
	in:fade|global={{ num, total }}
	class="card text-center light-text bg-darker text-decoration-none h6 rounded-4 m-0"
	class:border-success={place.serverPing >=
		Math.floor(Date.now() / 1000) - 35}
	href="/place/{place.id}/{place.name}">
	<div
		class="row"
		class:opacity-50={place.serverPing <
			Math.floor(Date.now() / 1000) - 35}>
		<div class="col col-6">
			<div id="shadow" class="overflow-hidden bg-black">
				<img
					src="/place/{place.id}/{place.name}/icon"
					alt={place.name}
					class="w-100 h-100" />
			</div>
		</div>
		<div class="col col-6 p-2 row">
			<p class="mb-1">
				{place.name}
			</p>
			<div class="mt-auto mb-1">
				<div class="float-start">
					<span>
						<i class="fa fa-thumbs-up opacity-75" />
						{place.ratio}%
					</span>
				</div>
				<div class="float-end">
					<span>
						<i class="fa fa-user opacity-75" />
						{place.gameSessions?.length}
					</span>
				</div>
			</div>
		</div>
	</div>
</a>

<style lang="sass">
	.card
		max-width: 22rem
	a
		transition: all 0.2s
		&:hover
			transition: all 0.2s
			#shadow::after
				box-shadow: inset 0 0 4rem 0 #fff2

	#shadow
		aspect-ratio: 1
		position: relative
		border-radius: 1rem 0 0 1rem
		&::after
			transition: all 0.3s
			content: ""
			position: absolute
			top: 0
			left: 0
			width: 100%
			height: 100%
</style>
