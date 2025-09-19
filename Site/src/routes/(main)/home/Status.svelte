<script lang="ts">
	import User from "$components/User.svelte"

	const { status }: { status: import("./$types").PageData["Status"] } = $props()

	let hidden = $derived(status.visibility !== "Visible")
</script>

<div class={["card", { "opacity-33": hidden }]}>
	<div class="flex <md:flex-col pb-2 justify-between p-3 pb-1.5">
		<div class="flex items-center">
			<User user={status.author} size="2rem" full bg="darker" />
		</div>
		<small>
			<i>{status.created.toLocaleString()}</i>
		</small>
	</div>
	<a
		href="/comment/{status.id}"
		class="text-start no-underline p-3 pt-1.5 light-text">
		{status.currentContent}
	</a>
</div>

<style>
	.card {
		border: 1px solid var(--accent2);
	}
</style>
