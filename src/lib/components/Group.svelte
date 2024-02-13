<script lang="ts">
	// Component for a group, used on the groups and search pages.

	export let group: {
		name: string
		memberCount: number
	}
	export let num: number
	export let total: number
</script>

<a
	in:fade={{ num, total }}
	class="card text-center light-text bg-darker no-underline rounded-4"
	href="/groups/{group.name}">
	<div class="p-4 flex flex-col h-full">
		{group.name}
		<div class="mt-auto mb-1 float-right">
			<span class="float-right">
				<fa fa-user class="opacity-75" />
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
