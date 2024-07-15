<script lang="ts">
	import ReportButton from "$lib/components/ReportButton.svelte"
	import User from "$lib/components/User.svelte"

	export let status: import("./$types").PageData["feed"][0]
</script>

<div class="card p-3">
	<div class="flex <md:flex-col pb-2 justify-between user">
		<div class="flex items-center">
			<User user={status.authorUser} size="2rem" full bg="darker" />
		</div>
		<span class="self-center <md:(w-full pt-2 flex justify-between)">
			<small>
				<em>{new Date(status.posted).toLocaleString()}</em>
			</small>
			<ReportButton
				user={status.authorUser.username}
				url="status:{status.id}" />
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
