<script lang="ts">
	export let data

	const notificationNotes = {
		AssetApproved: "Asset approval",
		FriendRequest: "Friend request",
		Follower: "New follower",
		ForumPostReply: "Reply to your post",
		ForumReplyReply: "Reply to your reply",
		AssetComment: "Comment on your asset",
		AssetCommentReply: "Reply to your comment",
		ForumMention: "Mention",
		ForumPost: "New forum post",
		ItemPurchase: "Item purchased",
		Message: "New message",
		NewFriend: "New friend",
	}
</script>

<Head title="Notifications" />

<h1 class="text-center light-text">Notifications</h1>

<div class="container mt-12">
	{#each data.notifications as notification}
		<div class:bg-darker={notification.read} class="card mb-4 p-4">
			<h2 class="light-text h5 d-flex align-items-center">
				<a
					href="/user/{notification.sender.number}"
					class="image-background {notification.read
						? 'bg-a'
						: 'bg-darker'} rounded-circle me-4">
					<img
						src="/api/avatar/{notification.sender.username}"
						alt={notification.sender.username}
						class="h-100 rounded-full rounded-top-0" />
				</a>

				{notificationNotes[notification.type]}
			</h2>
			<a href={notification.link} class="light-text">
				{notification.note}
			</a>
		</div>
	{/each}
</div>

<style lang="stylus">
	containerMinWidth()

	.image-background
		max-width 3rem
		min-height 3rem
		img
			width 3rem
</style>
