<script lang="ts">
	// An avatar shop item component, used in the
	// avatar shop and inventory pages.

	import fade from "$lib/fade"

	export let item: any
	export let num: number
	export let total: number
</script>

<a in:fade={{ num, total }} class="rounded-3 w-100 text-center light-text text-decoration-none h6" href="/avatarshop/item/{item.id}">
	<div id="shadow" class="rounded-1 mb-2 overflow-hidden bg-black">
		<div class="w-100 h-100" />
	</div>
	<p class="{item.ratio != undefined ? '' : 'float-start'} mb-1">
		{item.name}
	</p>
	{#if item.ratio != undefined}
		<span class="float-start ms-1">
			<i class="fa fa-thumbs-up opacity-75" />
			{item.ratio}%
		</span>
	{/if}
	<span class="float-end me-1">
		<i class="fa fa-gem opacity-75" />
		{item.price}
	</span>
</a>

<style lang="sass">
	a
		max-width: 12rem
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
			transition: all 0.3s
			content: ""
			position: absolute
			top: 0
			left: 0
			width: 100%
			height: 100%
</style>
