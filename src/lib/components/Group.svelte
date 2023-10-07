<script lang="ts">
	// Component for a group, used on the
	// groups and search pages.

	export let group: {
		name: string
		memberCount: number
	}
	export let num: number
	export let total: number
</script>

<a
	in:fade={{ num, total }}
	class="card text-center light-text bg-darker text-decoration-none fs-6 rounded-4 m-0"
	href="/groups/{group.name}">
	<div class="p-4 d-flex flex-column h-100">
		{group.name}
		<div class="mt-auto mb-1 float-end">
			<span class="float-end">
				<i class="fa fa-user opacity-75" />
				{group.memberCount}
			</span>
		</div>
	</div>
</a>

<style lang="stylus">
	.card
		width 11rem
		height 11rem
		border none
	a
		transition all 0.2s
		&:hover
			transition all 0.2s
</style>
