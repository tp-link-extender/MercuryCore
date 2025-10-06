<script lang="ts">
	// Component for a group, used on the groups and search pages.

	import fade from "$lib/fade"

	const {
		group,
		num,
		total
	}: {
		group: {
			id: string
			name: string
			memberCount: number
		}
		num: number
		total: number
	} = $props()
</script>

<a
	in:fade={{ num, total }}
	class="card text-center light-text bg-darker no-underline rounded-4"
	href="/groups/{group.id}">
	<div class="p-4 flex flex-col h-full">
		{group.name}
		<div class="mt-auto mb-1 float-end">
			<span class="float-end">
				<fa fa-user class="opacity-75"></fa>
				{group.memberCount}
			</span>
		</div>
	</div>
</a>

<style>
	.card {
		width: 11rem;
		height: 11rem;
		border: none;
	}

	a {
		transition: all 0.2s;
		&:hover {
			transition: all 0.2s;
		}
	}
</style>
