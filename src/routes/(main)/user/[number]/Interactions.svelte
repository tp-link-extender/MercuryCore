<script lang="ts">
	export let data: import("./$types").PageData
	const { user } = data
</script>

{#if data.username != user?.username}
	<div class="d-flex">
		<form
			in:fade
			class="align-self-center pe-2 d-flex gap-2"
			method="POST"
			use:enhance>
			<button
				name="action"
				value={data.friends
					? "unfriend"
					: data.outgoingRequest
					? "cancel"
					: data.incomingRequest
					? "accept"
					: "request"}
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
			{#if data.incomingRequest}
				<button name="action" value="decline" class="btn btn-danger">
					Decline request
				</button>
			{/if}
			<button
				name="action"
				value={data.following ? "unfollow" : "follow"}
				class="btn h-100 {data.following
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
