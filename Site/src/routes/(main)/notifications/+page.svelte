<script lang="ts">
	import Head from "$components/Head.svelte"
	import User from "$components/User.svelte"

	const { data } = $props()

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
		NewFriend: "New friend"
	}
</script>

<Head name={data.siteName} title="Notifications" />

<h1 class="text-center">Notifications</h1>

<div class="ctnr pt-12 max-w-200">
	{#each data.notifications as notification}
		<div class="pb-4">
			<div class:bg-darker={notification.read} class="card p-4">
				<span class="flex gap-3 items-center pb-4">
					<User
						user={notification.sender}
						size="3rem"
						bg="background" />
					<h2 class="text-base pt-1">
						{notificationNotes[notification.type]}
					</h2>
				</span>
				<a href={notification.link} class="light-text">
					<p>
						{notification.note}
					</p>
				</a>
			</div>
		</div>
	{/each}
	{#if data.notifications.length === 0}
		<h2 class="text-center">No notifications yet.</h2>
	{/if}
</div>
