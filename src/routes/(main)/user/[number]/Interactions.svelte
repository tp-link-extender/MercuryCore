<script lang="ts">
	export let data: import("./$types").PageData
	const { user } = data
</script>

{#if data.username != user?.username}
	<div class="flex gap-2">
		<form
			use:enhance
			method="POST"
			action="?/{data.friends
				? 'unfriend'
				: data.outgoingRequest
					? 'cancel'
					: data.incomingRequest
						? 'accept'
						: 'request'}"
			in:fade
			class="flex gap-2">
			<button
				class="btn {data.friends || data.outgoingRequest
					? 'btn-danger'
					: data.incomingRequest
						? 'btn-info'
						: 'btn-success'}">
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
				method="POST"
				action="?/decline"
				in:fade
				class="flex gap-2">
				<button class="btn btn-danger">Decline request</button>
			</form>
		{/if}
		<form
			use:enhance
			method="POST"
			action="?/{data.following ? 'unfollow' : 'follow'}"
			in:fade
			class="flex gap-2">
			<button
				name="action"
				class="btn h-full {data.following
					? 'btn-danger'
					: 'btn-primary'}">
				{#if data.following}
					Unfollow
				{:else}
					Follow
				{/if}
			</button>
		</form>
	</div>
{/if}
