<script lang="ts">
	import fade from "$lib/fade"
	import { fly } from "svelte/transition"
	import type { Writable } from "svelte/store"

	export let modal: Writable<boolean>
	const close = () => modal.set(false)
</script>

{#if $modal}
	<div
		class="modal d-block"
		tabindex="-1"
		transition:fly={{ y: -50, duration: 300 }}>
		<div
			id="fade"
			role="button"
			tabindex="0"
			transition:fade={{ duration: 300 }}
			on:click={close}
			on:keypress={close}
			class="vh-100 vw-100 position-fixed top-0 bg-black" />
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<slot />
			</div>
		</div>
	</div>
{/if}

<style lang="sass">
	#fade
		opacity: 0.5

	.modal-content
		background: var(--background)
		--bs-modal-border-color: var(--accent2)
</style>
