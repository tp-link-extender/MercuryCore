<script lang="ts">
	// Component for a group, used on the
	// groups page and on a user's profile.
	
	import { fade } from "svelte/transition"

	export let group: any
	export let num: number
	export let total: number
</script>

<a in:fade={{ duration: 300, delay: (num * 150) / Math.min(total, 6) }} class="card text-center light-text text-decoration-none h6 rounded-4 m-0" href="/groups/{group.name}">
	<div class="p-3 d-flex flex-column h-100">
		{group.name}
		<div class="mt-auto mb-1 float-end">
			<span class="float-end">
				<i class="fa fa-user opacity-75" />
				{group.members}
			</span>
		</div>
	</div>
</a>

<style lang="sass">
	.card
		width: 11rem
		height: 11rem
		border: none
		background: var(--darker)
	a
		transition: all 0.2s
		&:hover
			transition: all 0.2s
			text-shadow: 0 0 5px var(--light-text)
</style>
