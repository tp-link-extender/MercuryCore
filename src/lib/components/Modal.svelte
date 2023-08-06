<script lang="ts">
	import { fly } from "svelte/transition"
	import type { Writable } from "svelte/store"

	export let modal: Writable<boolean>
	const close = () => modal.set(false)
</script>

{#if $modal}
	<div
		class="modal d-block"
		tabindex="-1"
		transition:fly|global={{ y: -50, duration: 300 }}>
		<div
			role="button"
			tabindex="0"
			transition:fade|global={{ duration: 300 }}
			on:click={close}
			on:keypress={close}
			class="fade vh-100 vw-100 position-fixed top-0" />
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<slot />
			</div>
		</div>
	</div>
{/if}

<style lang="stylus">
	.fade
		opacity 0.5
		background black

	.modal-content
		background var(--background)
		--bs-modal-border-color var(--accent2)
</style>
