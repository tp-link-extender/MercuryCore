<script lang="ts">
	export let user: string
	export let url: string
	export let reverse = false
</script>

<a
	class="text-danger text-decoration-none ps-2 d-inline"
	href="/report?user={user}&url={url}">
	<small>
		{#if reverse}
			<i class="far fa-flag me-1" />
		{/if}
		<span>Report abuse</span>
		{#if !reverse}
			<i class="far fa-flag" />
		{/if}
	</small>
</a>

<style lang="sass">
	span
		transition: all 0.2s
		display: inline-block
		overflow: hidden
		white-space: nowrap
		width: 0
		vertical-align: middle // not perfectly centered
		margin-top: -0.2rem // there we go

	a:hover
		i
			font-weight: 900
		span
			width: 5.2rem
</style>
