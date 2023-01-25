<script lang="ts">
	export let place: any
</script>

<a class="rounded-3 text-center light-text text-decoration-none h6" href="/place/{place.slug}">
	<div id="shadow" class="rounded-1 mb-2 overflow-hidden bg-black">
		<img src={place.image} alt={place.name} class="w-100 h-100" />
	</div>
	<p class="mb-1">
		{place.name}
	</p>
	<span class="float-start ms-1">
		<i class="fa-solid fa-thumbs-up opacity-75" /> 50%
	</span>
	<span class="float-end me-1">
		<i class="fa-solid fa-user opacity-75" /> 12
	</span>
</a>

<style lang="sass">
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
		&::after
			transition: all .3s
			content: ""
			position: absolute
			top: 0
			left: 0
			width: 100%
			height: 100%
</style>
