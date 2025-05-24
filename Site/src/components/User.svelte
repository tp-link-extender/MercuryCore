<script lang="ts">
	// User profile link component

	import type { ClassValue } from "svelte/elements"

	const statusColours = Object.freeze({
		// 8 months late lmao
		Playing: "#238560",
		Online: "#3459e6",
		Offline: "transparent"
	})
	const transitionBackgrounds = Object.freeze({
		darker: "background",
		background: "accent",
		accent: "accent1",
		accent1: "accent2",
		accent2: "accent3",
		accent3: "accent2"
	})

	const {
		user,
		full = false,
		thin = false,
		image = false,
		bottom = false,
		rerender = null,
		size = "2rem",
		bg = "accent2",
		class: class_ = ""
	}: {
		user: BasicUser
		full?: boolean
		thin?: boolean
		image?: boolean
		bottom?: boolean
		rerender?: {
			form?: {
				avatar?: string
			} | null
			regenerating?: boolean
		} | null // Used on profile page for rerender button
		size?: string
		bg?: keyof typeof transitionBackgrounds
		class?: ClassValue
	} = $props()

	const style = `width: ${size}; max-width: ${size}; height: ${size}; min-height: ${size}`
	const style2 = `${style}; background: var(--${bg})`
	const pfpstyle = `${style2}; --hover: var(--${transitionBackgrounds[bg]})`
</script>

{#if image}
	<div class={["flex", class_, { "items-center": full }]}>
		<div class="relative">
			<!-- css hell -->
			<div
				class="status"
				style="background: {statusColours[user.status]}">
			</div>
			<div class="pfp" style={pfpstyle}>
				{#if rerender}
					<img
						src={rerender.form?.avatar ||
							`/api/avatar/${user.username}`}
						alt={user.username}
						class={[
							"transition-opacity duration-300 rounded-full rounded-t-0",
							{ "opacity-50": rerender.regenerating }
						]}
						{style} />
				{:else}
					<img
						src="/api/avatar/{user.username}"
						alt={user.username}
						class="rounded-full rounded-t-0"
						{style} />
				{/if}
			</div>
		</div>
		{#if full}
			<span class={thin ? "pl-2 text-base" : "pl-4 font-bold"}>
				{user.username}
			</span>
		{/if}
	</div>
{:else}
	<a
		href="/user/{user.username}"
		class={[
			"flex no-underline",
			class_,
			{
				"flex-col": bottom,
				"items-center": full
			}
		]}>
		<div class="relative">
			<div
				class="status"
				style="background: {statusColours[user.status]}">
			</div>
			<div class="pfp" style={pfpstyle}>
				<img
					src="/api/avatar/{user.username}"
					alt={user.username}
					class="rounded-full rounded-t-0"
					{style} />
			</div>
		</div>
		{#if full}
			<span class={thin ? "pl-2 text-base" : "pl-4 font-bold"}>
				{user.username}
			</span>
		{:else if bottom}
			<span
				class={[
					"max-h-12 pt-2 text-center",
					{ small: user.username?.length > 15 }
				]}
				style="max-width: {size}">
				{user.username}
			</span>
		{/if}
	</a>
{/if}

<style>
	.pfp {
		@apply rounded-full transition-all duration-200;
	}
	/* sus */
	:global(a):hover .pfp {
		background: var(--hover) !important;
	}

	img,
	.status {
		position: absolute;
	}
	.status {
		border-radius: 50%;
		bottom: 5%;
		right: 5%;
		width: 20%;
		aspect-ratio: 1;
	}
</style>
