<script lang="ts">
	// Component for a group, used on the
	// groups page and on a user's profile.

	import fade from "$lib/fade"

	export let group: {
		name: string
		members: number
	}
	export let num: number
	export let total: number
</script>

<a
	in:fade={{ num, total }}
	class="card text-center light-text bg-darker no-underline h6 rounded-4 m-0"
	href="/groups/{group.name}">
	<div class="p-3 flex flex-col h-100">
		{group.name}
		<div class="mt-auto mb-1 float-right">
			<span class="float-right">
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
	a
		transition: all 0.2s
		&:hover
			transition: all 0.2s
</style>
