<script lang="ts">
	export let group: any

	console.log(group)
</script>

<a class="card text-center light-text text-decoration-none h6 rounded-4 m-0" href="/groups/{group.name}">
	<div class="p-3">
		<p class="mb-1">
			{group.name}
		</p>
		<br />
		<br />
		<br />
		<br />
		<br />
		<div class="mt-auto mb-1">
			<div class="float-end">
				<span>
					<i class="fa fa-user opacity-75" />
					{group.members}
				</span>
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
</style>
