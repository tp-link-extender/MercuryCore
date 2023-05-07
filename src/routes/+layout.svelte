<script lang="ts">
	import { navigating } from "$app/stores"
	import { enhance } from "$app/forms"
	import nprogress from "nprogress"

	import "uno.css"
	import "/src/nprogress.sass"
	import "/src/global.sass"
	import "/src/fa/sass/fontawesome.sass"

	export let data
	const user = data.user

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

<template lang="pug">
	svelte:head
		meta(charset="utf-8")
		meta(name="theme-color" content="#1f1d1c")
		meta(name="viewport" content="width=device-width, initial-scale=1")
		link(rel="icon" href="/favicon.svg")
		link(rel="manifest" href="/manifest.json")
		link(rel="apple-touch-icon" href="/icon192.png")

		script(
			defer
			src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha2/dist/js/bootstrap.bundle.min.js"
			integrity="sha384-qKXV1j0HvMUeCBQ+QVp7JcfGl760yU08IQ+GpUo5hlbpg51QRiuqHAJz8+BrxE/N"
			crossorigin="anonymous")

	slot

	// Toast notifications
	.toast-container.position-fixed.bottom-0.end-0.p-3
		+each("data.notifications.filter(n => !n.read) as notification")
			.toast.show.bg-darker.light-text.m-3(
				role="alert"
				aria-live="assertive"
				aria-atomic="true")

				.toast-header.bg-a.light-text
					a.d-flex.align-items-center.w-100.light-text.text-decoration-none(
						href="/user/{notification.sender.number}")

						.image-background.bg-background.rounded-circle.me-3
							img(
								src="{notification.sender.image}"
								alt="{notification.sender.username}"
								class="h-100 rounded-circle img-fluid rounded-top-0")

						strong.me-auto.
							{notificationNotes[notification.type]}
						small.text-body-secondary.
							{notification.time.toLocaleString()}

					form(
						use:enhance
						method="POST"
						action="/notifications?s={notification.id}")

						button.btn-close(aria-label="Close")
				
				a.toast-body.bg-darker.light-text.text-decoration-none.d-block(
					href="{notification.link}") {notification.note}
</template>

<!-- Theme files contain CSS variables that are used throughout the app. -->
{#if user?.theme == "darken"}
	<style lang="sass">
		@use "../themes/darken.sass"
	</style>
{:else if user?.theme == "storm"}
	<style lang="sass">
		@use "../themes/storm.sass"
	</style>
{:else if user?.theme == "solar"}
	<style lang="sass">
		@use "../themes/solar.sass"
	</style>
{:else}
	<style lang="sass">
		@use "../themes/standard.sass"
	</style>
{/if}

<style lang="sass">
	.btn-close
		filter: invert(1) grayscale(100%) brightness(200%)
		@media (prefers-color-scheme: light)
			filter: none

	.toast
		min-width: 25rem
		--bs-toast-box-shadow: 0 0 2rem #fff1
		@media (prefers-color-scheme: light)
			--bs-toast-box-shadow: 0 0 2rem #0001
	.toast-body
		min-height: 4rem

	.image-background
		max-width: 1.6rem
		min-height: 1.6rem
		img
			width: 1.6rem
</style>
