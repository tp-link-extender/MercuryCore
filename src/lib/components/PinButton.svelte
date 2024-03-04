<script lang="ts">
	import { applyAction } from "$app/forms"
	import { invalidateAll } from "$app/navigation"

	export let id: string
	export let reverse = false
	export let pinned = false
	export let post = false
	// Replies need to be re-ordered after a reply is pinned or unpinned
	export let refresh: () => void

	const text = pinned ? "unpin" : "pin"
	const colour = pinned ? "text-red-5" : "text-green-5"

	let clicked = false
</script>

<form
	use:enhance={() =>
		async ({ result }) => {
			if (result.type === "success") await invalidateAll()
			await applyAction(result)
			// We need to wait until the new data has been fetched before refreshing
			refresh()
		}}
	method="POST"
	class="inline"
	action="?/{text}{post ? 'post' : ''}&id={id}">
	{#if clicked}
		<small class="light-text pl-2 inline-flex items-center">
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
					<far fa-thumbtack class="pr-2" />
				{/if}
				<span
					class="{text} {colour} overflow-hidden align-middle w-0 -mt-0.4">
					{text.charAt(0).toUpperCase() + text.slice(1)}
				</span>
				{#if !reverse}
					<far fa-thumbtack class="pl-2" />
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
		.pin
			width 1.3rem
		.unpin
			width 2.5rem
</style>
