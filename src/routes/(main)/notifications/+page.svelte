<script lang="ts">
	export let data
	const notificationNotes = {
		AssetApproved: "Asset approval",
		FriendRequest: "Friend request",
		Follower: "New follower",
		ForumPostReply: "Reply to your post",
		ForumReplyReply: "Reply to your reply",
		ForumMention: "Mention",
		ForumPost: "New forum post",
		ItemPurchase: "Item purchased",
		Message: "New message",
		NewFriend: "New friend",
	}
</script>

<svelte:head>
	<title>Notifications - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">Notifications</h1>

<div class="container mt-5">
	{#each data.notifications as notification}
		<div class:bg-darker={notification.read} class="card mb-3 p-3">
			<h2 class="light-text h5 d-flex align-items-center">
				<a
					href="/user/{notification.sender.number}"
					class="image-background {notification.read
						? 'bg-a'
						: 'bg-darker'} rounded-circle me-3">
					<img
						src={notification.sender.image}
						alt={notification.sender.username}
						class="h-100 rounded-circle img-fluid rounded-top-0" />
				</a>

				{notificationNotes[notification.type]}
			</h2>
			<a href={notification.link} class="light-text">
				{notification.note}
			</a>
		</div>
	{/each}
</div>

<style lang="sass">
	@media only screen and (min-width: 576px)
		.container
			width: 50rem

	.image-background
		max-width: 3rem
		min-height: 3rem
		img
			width: 3rem
</style>
