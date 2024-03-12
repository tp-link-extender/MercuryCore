<script lang="ts">
	// User profile link component

	const statusColours = {
		// 8 months late lmao
		Playing: "#238560",
		Online: "#3459e6",
		Offline: "#0000"
	}
	const backgrounds = {
		darker: "#0a0908",
		background: "#100f0e",
		accent: "#1f1d1c",
		accent1: "#262423",
		accent2: "#363433",
		accent3: "#464443"
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
	export let size = "2rem"
	export let bg: keyof typeof backgrounds = "accent2"

	const style = `width: ${size}; max-width: ${size}; height: ${size}; min-height: ${size}`
	const style2 = `background: ${backgrounds[bg]}`
</script>

{#if image}
	<div class={$$restProps.class}>
		<span
			class="rounded-full overflow-hidden size-full"
			style="{style};{style2}">
			<img
				src="/api/avatar/{user.username}"
				alt={user.username}
				class="rounded-full rounded-t-0"
				style="box-shadow inset 0 0 0rem 1.5px {statusColours[
					user.status
				]};{style}" />
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
		<span class="pfp rounded-full overflow-hidden" style="{style};{style2}">
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
				color #8c8b8a

	.bottom
		overflow hidden
		max-height 3rem
</style>
