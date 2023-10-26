<script lang="ts">
	import { dev } from "$app/environment"
	import { navigating } from "$app/stores"
	import nprogress from "nprogress"

	import "uno.css"
	import "/src/nprogress.styl"
	import "$bootstrap"
	import "/src/bootswatch.styl"
	import "/src/global.styl"
	import "/src/fa/sass/fontawesome.styl"

	export let data
	$: user = data.user

	// Settings for nprogress, the loading bar shown
	// at the top of the page when navigating
	nprogress.configure({ showSpinner: false })

	let timeout: any
	// 100ms is the minimum time the loading bar will be shown
	$: if ($navigating && !timeout) timeout = setTimeout(nprogress.start, 100)
	else {
		clearTimeout(timeout)
		timeout = null

		nprogress.done()
	}

	onMount(() =>
		setInterval(() => {
			// Keep the user's online status up to date
			if (user)
				fetch("/api?/statusping", {
					method: "POST",
					body: new FormData(),
				})
		}, 30e3)
	)

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

	$: notifications = data.notifications.filter(n => !n.read)
</script>

<svelte:head>
	<meta charset="utf-8" />
	<meta name="theme-color" content="#1f1d1c" />
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<link rel="icon" href="/favicon.svg" />
	<link rel="manifest" href="/manifest.json" />
	<link rel="apple-touch-icon" href="/icon192.png" />

	{#if !dev}
		<script
			defer
			data-domain="banland.xyz"
			src="https://analytics.banland.xyz/js/script.js"></script>
	{/if}
</svelte:head>

<slot />

<!-- Toast notifications -->
<div
	class="toasts position-fixed z-1 bottom-0 end-0 p-4
	d-flex flex-column gap-4">
	{#each notifications as notification}
		<div
			class="show bg-darker light-text rounded-2"
			role="alert"
			aria-live="assertive"
			aria-atomic="true">
			<div class="d-flex bg-a light-text p-2 rounded-top-2">
				<a
					href="/user/{notification.sender.number}"
					class="d-flex gap-3 align-items-center w-100 light-text text-decoration-none">
					<User
						user={notification.sender}
						size="1.6rem"
						bg="background"
						image />
					<strong>
						{notificationNotes[notification.type]}
					</strong>
					<small class="grey-text">
						{new Date(notification.time).toLocaleString()}
					</small>
				</a>
				<form
					use:enhance
					method="POST"
					action="/notifications?s={notification.id}">
					<button class="btn-close" aria-label="Close" />
				</form>
			</div>
			<a
				href={notification.link}
				class="body p-3 light-text text-decoration-none
				d-block rounded-2">
				{notification.note}
			</a>
		</div>
	{/each}
</div>

<!-- Theme files contain CSS variables that are used throughout the site. -->
{#if user?.theme == "darken"}
	<style lang="stylus">
		@import "../themes/darken"
	</style>
{:else if user?.theme == "storm"}
	<style lang="stylus">
		@import "../themes/storm"
	</style>
{:else if user?.theme == "solar"}
	<style lang="stylus">
		@import "../themes/solar"
	</style>
{:else}
	<style lang="stylus">
		@import "../themes/standard"
	</style>
{/if}

<style lang="stylus">
	.btn-close
		filter invert(1) grayscale(100%) brightness(200%)
		+lightTheme()
			filter none

	.toasts
		width 25rem
		--bs-toast-box-shadow 0 0 2rem #fff1
		+lightTheme()
			--bs-toast-box-shadow 0 0 2rem #0001

	.body
		min-height 4rem
</style>
