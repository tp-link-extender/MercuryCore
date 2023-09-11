<script lang="ts">
	import { fly } from "svelte/transition"
	import type { Writable } from "svelte/store"

	export let modal: Writable<boolean>
	const close = () => modal.set(false)
</script>

{#if $modal}
	<div
		class="modal-static position-fixed w-100 h-100 z-10
			justify-content-center align-items-center d-flex"
		tabindex="-1"
		transition:fly|global={{ y: -50, duration: 300 }}>
		<div
			role="button"
			tabindex={0}
			transition:fade|global={{ duration: 200 }}
			on:click={close}
			on:keypress={close}
			class="modal-backdrop vh-100 w-100 position-fixed" />
		<div class="modal-box">
			<slot />
		</div>
	</div>
{/if}

<style lang="stylus">
	.modal-box
		max-width 32rem
</style>
