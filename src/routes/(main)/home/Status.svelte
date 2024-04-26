<script lang="ts">
	export let status: import("./$types").PageData["feed"][0]
</script>

<div class="card p-3">
	<div class="statusheader flex pb-2 user justify-between">
		<div class="flex items-center">
			<User user={status.authorUser} size="2rem" full bg="darker" />
		</div>
		<span class="report self-center">
			<small>
				<em>{new Date(status.posted).toLocaleString()}</em>
			</small>
			<ReportButton user={status.authorUser.username} url="status:{status.id}" />
		</span>
	</div>
	<p class="text-start">
		{status.content[0].text}
	</p>
</div>

<style lang="stylus">
	+-md()
		.statusheader
			flex-direction column
		.report
			width 100%
			padding-top 0.5rem
			display flex
			justify-content space-between

	.card
		border 1px solid var(--accent2)
</style>
