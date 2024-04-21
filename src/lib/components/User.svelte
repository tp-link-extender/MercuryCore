<script lang="ts">
	// User profile link component

	const statusColours = {
		// 8 months late lmao
		Playing: "#238560",
		Online: "#3459e6",
		Offline: "#0000"
	}
	const transitionBackgrounds = {
		darker: "background",
		background: "accent",
		accent: "accent1",
		accent1: "accent2",
		accent2: "accent3",
		accent3: "accent2"
	}

	export let user: {
		number: number
		status: "Playing" | "Online" | "Offline"
		username: string
	}
	export let full = false
	export let thin = false
	export let image = false
	export let bottom = false
	export let rerender:
		| {
				form?: {
					avatar: string
				} | null
				regenerating?: boolean
		  }
		| undefined = undefined // Used on profile page for rerender button
	export let size = "2rem"
	export let bg: keyof typeof transitionBackgrounds = "accent2"

	const style = `width: ${size}; max-width: ${size}; height: ${size}; min-height: ${size}; --status: ${statusColours[user.status]}`
	const style2 = `background: var(--${bg})`
</script>

{#if image}
	<div class="flex {$$restProps.class}" class:items-center={full}>
		<span class="rounded-full" style="{style};{style2}">
			{#if rerender}
				<img
					class="transition-opacity duration-300 rounded-full rounded-t-0"
					class:opacity-50={rerender.regenerating}
					src={rerender.form?.avatar ||
						`/api/avatar/${user.username}`}
					alt={user.username}
					{style} />
			{:else}
				<img
					src="/api/avatar/{user.username}"
					alt={user.username}
					class="rounded-full rounded-t-0"
					{style} />
			{/if}
		</span>
		{#if full}
			<span class="username {thin ? 'pl-2 text-base' : 'font-bold pl-4'}">
				{user.username}
			</span>
		{/if}
	</div>
{:else}
	<a
		href="/user/{user.number}"
		class="flex no-underline {$$restProps.class}"
		class:flex-col={bottom}
		class:items-center={full}>
		<span
			class="pfp rounded-full"
			style="{style};{style2};
			--hover: var(--{transitionBackgrounds[bg]})">
			<img
				src="/api/avatar/{user.username}"
				alt={user.username}
				class="rounded-full rounded-t-0"
				{style} />
		</span>
		{#if full}
			<span class="username {thin ? 'pl-2 text-base' : 'font-bold pl-4'}">
				{user.username}
			</span>
		{:else if bottom}
			<span
				class="username bottom pt-2 text-center"
				class:small={user.username?.length || 0 > 15}
				style="max-width: {size}">
				{user.username}
			</span>
		{/if}
	</a>
{/if}

<style lang="stylus">
	a
		span
			transition all 0.2s
		&:hover
			.username
				color var(--grey-text)
			.pfp
				background var(--hover) !important

	span.rounded-full
		box-shadow inset 0 0 0rem 1.5px var(--status)

	.bottom
		overflow hidden
		max-height 3rem
</style>
