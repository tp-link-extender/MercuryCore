<script lang="ts">
	import { enhance } from "$app/forms"
	import fade from "$lib/fade"

	const { data }: { data: import("./$types").PageData } = $props()
</script>

<div class="flex gap-2">
	<form
		use:enhance
		in:fade
		method="POST"
		action="?/{data.friends
			? 'unfriend'
			: data.outgoingRequest
				? 'cancel'
				: data.incomingRequest
					? 'accept'
					: 'request'}"
		class="flex gap-2">
		<button
			class="btn {data.friends || data.outgoingRequest
				? 'btn-red-tertiary'
				: data.incomingRequest
					? 'btn-secondary'
					: 'btn-secondary'}">
			{#if data.friends}
				Unfriend
			{:else if data.incomingRequest}
				Accept request
			{:else if data.outgoingRequest}
				Cancel request
			{:else}
				Send friend request
			{/if}
		</button>
	</form>
	{#if data.incomingRequest}
		<form
			use:enhance
			in:fade
			method="POST"
			action="?/decline"
			class="flex gap-2">
			<button class="btn btn-red-secondary">Decline request</button>
		</form>
	{/if}
	<form
		use:enhance
		in:fade
		method="POST"
		action="?/{data.following ? 'unfollow' : 'follow'}"
		class="flex gap-2">
		<button
			name="action"
			class="btn h-full {data.following
				? 'btn-red-tertiary'
				: 'btn-tertiary'}">
			{#if data.following}
				Unfollow
			{:else}
				Follow
			{/if}
		</button>
	</form>
</div>
