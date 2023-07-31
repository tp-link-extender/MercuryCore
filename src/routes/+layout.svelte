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
	const { user } = data

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

	const notificationNotes: { [k: string]: string } = {
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
	<script
		defer
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz"
		crossorigin="anonymous"></script>
</svelte:head>

<slot />

<!-- Toast notifications -->
<div class="toast-container position-fixed bottom-0 end-0">
	{#each notifications as notification}
		<div
			class="toast show bg-darker light-text m-3"
			role="alert"
			aria-live="assertive"
			aria-atomic="true">
			<div class="toast-header bg-a light-text">
				<a
					href="/user/{notification.sender.number}"
					class="d-flex align-items-center w-100 light-text text-decoration-none">
					<div
						class="image-background bg-background rounded-circle me-3">
						<img
							src="/api/avatar/{notification.sender.username}"
							alt={notification.sender.username}
							class="h-100 rounded-circle rounded-top-0" />
					</div>
					<strong class="me-auto">
						{notificationNotes[notification.type]}
					</strong>
					<small class="text-body-secondary">
						{notification.time.toLocaleString()}
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
				class="toast-body bg-darker light-text text-decoration-none d-block">
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

	.toast
		min-width 25rem
		--bs-toast-box-shadow 0 0 2rem #fff1
		+lightTheme()
			--bs-toast-box-shadow 0 0 2rem #0001

	.toast-body
		min-height 4rem

	.image-background
		max-width 1.6rem
		min-height 1.6rem
		img
			width 1.6rem
</style>
