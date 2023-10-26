<script lang="ts">
	export let user: string
	export let url: string
	export let reverse = false
</script>

<a
	class="text-danger text-decoration-none ps-2"
	href="/report?user={user}&url={url}">
	<small class="d-inline-flex align-items-center">
		{#if reverse}
			<far class="fa-flag pe-2" />
		{/if}
		<span class="text-danger">Report abuse</span>
		{#if !reverse}
			<far class="fa-flag ps-2" />
		{/if}
	</small>
</a>

<style lang="stylus">
	span
		transition all 0.2s
		display inline-block
		overflow hidden
		white-space nowrap
		width 0

	a:hover
		far
			font-weight 900
		span
			width 5.2rem
</style>
