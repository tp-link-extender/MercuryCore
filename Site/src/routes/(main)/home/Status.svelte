<script lang="ts">
	import ReportButton from "$components/ReportButton.svelte"
	import User from "$components/User.svelte"

	const {
		status
	}: {
		status: import("./$types").PageData["feed"][0]
	} = $props()
</script>

<div class="card p-3">
	<div class="flex <md:flex-col pb-2 justify-between">
		<div class="flex items-center">
			<User user={status.authorUser} size="2rem" full bg="darker" />
		</div>
		<span class="self-center <md:(w-full pt-2 flex justify-between)">
			<small class="pr-2">
				<em>{status.created.toLocaleString()}</em>
			</small>
			<span class="dropdown">
				<fa fa-ellipsis-h class="dropdown-ellipsis"></fa>
				<div class="dropdown-content pt-2">
					<ul class="p-2 rounded-3">
						<ReportButton
							user={status.authorUser.username}
							url="status:{status.id}" />
					</ul>
				</div>
			</span>
		</span>
	</div>
	<p class="text-start">
		{status.content[0].text}
	</p>
</div>

<style>
	.card {
		border: 1px solid var(--accent2);
	}
</style>
