<script lang="ts">
	import { browser } from "$app/environment"
	import { enhance } from "$app/forms"
	import { navigating } from "$app/stores"
	import User from "$components/User.svelte"
	import nprogress from "nprogress"
	import { onMount } from "svelte"

	import "/src/nprogress.css"
	import "/src/global.css"
	import "/src/icons.css"
	import "/src/daisyui/dropdown.css"
	import "/src/daisyui/tooltip.css"
	import "uno.css"

	const { data, children } = $props()

	let user = $derived(data.user)

	// Settings for nprogress, the loading bar shown at the top of the page when navigating
	nprogress.configure({ showSpinner: false })

	let timeout: Timer | null
	// 100ms is the minimum time the loading bar will be shown
	$effect(() => {
		if (!browser) return
		if ($navigating && !timeout) timeout = setTimeout(nprogress.start, 100)
		else if (timeout) {
			clearTimeout(timeout)
			timeout = null
			nprogress.done()
		}
	})

	async function ping() {
		// Keep the user's online status up to date
		if (!user) return

		// Save to localStorage so we don't ping multiple times if the user has multiple tabs open
		const lastPing = localStorage.getItem("lastPing")
		if (lastPing && Date.now() - +lastPing < 30e3) return
		await fetch("/api?/statusping", {
			method: "POST",
			body: new FormData()
		})
		localStorage.setItem("lastPing", Date.now().toString())
	}
	onMount(() => setInterval(ping, 30e3))

	const notificationNotes: { [_: string]: string } = Object.freeze({
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
	})

	let notifications = $derived(data.notifications.filter(n => !n.read))
</script>

<svelte:head>
	<meta charset="utf-8" />
	<meta name="theme-color" content="#0f0e11" />
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<link rel="icon" href="/assets/favicon" />

	<!-- todo: document analytics setup -->
	<!-- {#if !dev}
		<script
			defer
			data-domain={data.domain}
			src="https://analytics.{data.domain}/js/script.js"></script>
	{/if} -->
</svelte:head>

<!-- Toast notifications -->
<div class="max-w-110 fixed bottom-0 end-0 p-4 flex flex-col gap-4 z-10">
	{#each notifications as notification}
		<div
			class="show bg-darker light-text rounded-2"
			role="alert"
			aria-live="assertive"
			aria-atomic="true">
			<div class="bg-a light-text flex p-2 rounded-t-2">
				<a
					href="/user/{notification.sender.username}"
					class="light-text flex gap-3 items-center w-full no-underline">
					<User
						user={notification.sender}
						size="1.6rem"
						bg="background"
						image />
					<strong>
						{notificationNotes[notification.type]}
					</strong>
					<small class="grey-text pr-4">
						{new Date(notification.time).toLocaleString()}
					</small>
				</a>
				<form
					use:enhance
					method="POST"
					action="/notifications?s={notification.id}">
					<button
						class="btn p-0 px-1 text-white hover:text-neutral-500"
						aria-label="Close">
						<fa fa-xmark-large></fa>
					</button>
				</form>
			</div>
			<a
				href={notification.link}
				class="light-text p-3 no-underline block rounded-2">
				{notification.note}
			</a>
		</div>
	{/each}
</div>

{@render children()}
