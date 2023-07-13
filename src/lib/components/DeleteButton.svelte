<script lang="ts">
	export let id: string
	export let reverse = false
	export let moderate = false

	const text = moderate ? "moderate" : "delete"
	const colour = moderate ? "text-info" : "text-warning"

	let clicked = false
</script>

<form use:enhance method="POST" class="d-inline" action="?/{text}&id={id}">
	{#if clicked}
		<small class="px-2 light-text">
			{text}?
			<button class="btn p-0 px-1 {colour} text-decoration-none">
				yes
			</button>
			/
			<button
				on:click={() => (clicked = false)}
				class="btn p-0 px-1 {colour} text-decoration-none">
				no
			</button>
		</small>
	{:else}
		<button
			on:click={() => (clicked = true)}
			class="btn p-0 px-1 {colour} text-decoration-none">
			<small>
				{#if reverse}
					<i class="far {moderate ? 'fa-gavel' : 'fa-trash'} me-1" />
				{/if}
				<span class="{text} {colour}">
					{text.charAt(0).toUpperCase() + text.slice(1)}
				</span>
				{#if !reverse}
					<i class="far {moderate ? 'fa-gavel' : 'fa-trash'}" />
				{/if}
			</small>
		</button>
	{/if}
</form>

<style lang="stylus">
	small
		font-size 0.9rem

	span
		transition all 0.2s
		display inline-block
		overflow hidden
		white-space nowrap
		width 0
		vertical-align middle // not perfectly centered
		margin-top -0.1rem // there we go

	button:hover
		i
			font-weight 900
		.delete
			width 2.5rem
		.moderate
			width 3.7rem
</style>
