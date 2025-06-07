<script lang="ts">
	import User from "$components/User.svelte"
	import type { Comment } from "$lib/comment"

	const { status }: { status: Comment } = $props()
</script>

<div class="card">
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
		{status.content[0].text}
	</a>
</div>

<style>
	.card {
		border: 1px solid var(--accent2);
	}
</style>
