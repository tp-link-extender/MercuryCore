<script lang="ts">
	export let place: any
</script>

<a class="card text-center light-text text-decoration-none h6 rounded-4 m-0" href="/place/{place.slug}">
	<div class="row">
		<div class="col col-6">
			<div id="shadow" class="overflow-hidden bg-black">
				<img src={place.image} alt={place.name} class="w-100 h-100" />
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
						<i class="fa fa-user opacity-75" /> 12
					</span>
				</div>
			</div>
		</div>
	</div>
</a>

<style lang="sass">
	.card
		border: none
		background: var(--darker)
	a
		transition: all 0.2s
		&:hover
			transition: all 0.2s
			text-shadow: 0 0 5px var(--light-text)
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
