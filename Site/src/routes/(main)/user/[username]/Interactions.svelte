<script lang="ts">
	import fade from "#lib/fade.ts"
	import {
		acceptForm,
		cancelForm,
		declineForm,
		followForm,
		requestForm,
		unfollowForm,
		unfriendForm,
	} from "#lib/interactions.remote.ts"

	const { data }: { data: import("./$types").PageData } = $props()

	const friendForm = (data.friends
		? unfriendForm
		: data.outgoingRequest
			? cancelForm
			: data.incomingRequest
				? acceptForm
				: requestForm
	).for(data.username)
	const followFormFor = (data.following ? unfollowForm : followForm).for(
		data.username
	)
</script>

<div class="flex gap-2">
	<form
		{...friendForm}
		in:fade
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
		<form {...declineForm.for(data.username)} in:fade class="flex gap-2">
			<button class="btn btn-red-secondary">Decline request</button>
		</form>
	{/if}
	<form {...followFormFor} in:fade class="flex gap-2">
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
