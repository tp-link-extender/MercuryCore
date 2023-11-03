<script lang="ts">
	export let data

	const notificationNotes: { [k: string]: string } = {
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

<h1 class="text-center">Notifications</h1>

<div class="container pt-12">
	{#each data.notifications as notification}
		<div class="pb-4">
			<div class:bg-darker={notification.read} class="card p-4">
				<span class="d-flex gap-3 align-items-center pb-4">
					<User
						user={notification.sender}
						size="3rem"
						bg="background" />
					<h2 class="fs-4 pt-1">
						{notificationNotes[notification.type]}
					</h2>
				</span>
				<a href={notification.link} class="light-text">
					{notification.note}
				</a>
			</div>
		</div>
	{/each}
</div>

<style lang="stylus">
	containerMinWidth()
</style>
