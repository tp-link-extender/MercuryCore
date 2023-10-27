<script lang="ts">
	export let status: import("./$types").PageData["feed"][0]
</script>

<div class="card p-3">
	<div class="statusheader d-flex pb-2 user justify-content-between">
		<div class="d-flex align-items-center">
			<User user={status.authorUser} size="2rem" full bg="darker" />
		</div>
		<span class="report align-self-center">
			<em class="small light-text timestamp">
				{new Date(status.posted).toLocaleString()}
			</em>
			<ReportButton
				user={status.authorUser?.username || ""}
				url="status:{status.id}" />
		</span>
	</div>
	<p class="text-start">
		{status.content[0].text}
	</p>
</div>

<style lang="stylus">
	+-lg()
		.statusheader
			flex-direction column
		.report
			width 100%
			padding-top 0.5rem
			display flex
			justify-content space-between

	.card
		border-width 1px
		border-color var(--accent2)
</style>
