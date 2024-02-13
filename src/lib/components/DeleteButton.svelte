<script lang="ts">
	export let id: string
	export let reverse = false
	export let moderate = false

	const text = moderate ? "moderate" : "delete"
	const colour = moderate ? "text-cyan-5" : "text-yellow-5"

	let clicked = false
</script>

<form use:enhance method="POST" class="inline" action="?/{text}&id={id}">
	{#if clicked}
		<small class="pl-2 light-text inline-flex items-center">
			{text}?
			<button class="btn p-0 px-1 {colour}">yes</button>
			/
			<button
				on:click={() => (clicked = false)}
				class="btn p-0 px-1 {colour}">
				no
			</button>
		</small>
	{:else}
		<button on:click={() => (clicked = true)} class="btn p-0 pl-2 {colour}">
			<small>
				{#if reverse}
					<far class="{moderate ? 'fa-gavel' : 'fa-trash'} pr-2" />
				{/if}
				<span
					class="{text} {colour} overflow-hidden align-middle w-0 -mt-0.4">
					<!-- perfect alignment -->
					{text.charAt(0).toUpperCase() + text.slice(1)}
				</span>
				{#if !reverse}
					<far class="{moderate ? 'fa-gavel' : 'fa-trash'} pl-2" />
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
		white-space nowrap

	button:hover
		far
			font-weight 900
		.delete
			width 2.8rem
		.moderate
			width 4.1rem
</style>
