<script lang="ts">
	const statusColours: { [k: string]: string } = {
		Online: "bg-info",
		Joined: "bg-success",
		Developing: "bg-warning",
	}

	export let user: {
		username: string
		number: number
		status?: keyof typeof statusColours
	}
	export let num: number
	export let total: number
</script>

<a
	in:fade={{ num, total, max: 12 }}
	class="card light-text h-100 w-100 d-flex flex-row bg-darker"
	href="/user/{user.number}">
	<div class="p-4">
		<div class="image-background rounded-circle bg-a">
			<img
				src="/api/avatar/{user.username}"
				alt={user.username}
				class="h-100 rounded-full rounded-top-0" />
		</div>
		<!-- {#if user.status}
			<span
				class="position-absolute bottom-0 end-0 badge rounded-circle bg-a {statusColours[
					user.status
				]}">
			</span>
		{/if} -->
	</div>
	<p class="h4 p-6">
		{user.username}
	</p>
</a>

<style lang="stylus">
	.card
		max-width 25rem
		text-decoration none
		p
			width fit-content
			word-break break-all

		// .badge
		// 	padding 0.75rem
		.image-background
			min-width 6rem
			img
				width 6rem
				height 6rem !important
</style>
