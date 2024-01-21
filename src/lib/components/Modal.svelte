<script lang="ts">
	import { fly } from "svelte/transition"
	import type { Writable } from "svelte/store"

	export let modal: Writable<boolean>
	const close = () => modal.set(false)
</script>

{#if $modal}
	<div
		class="modal-static fixed w-full h-full z-10
		justify-center items-center flex"
		tabindex="-1"
		transition:fly|global={{ y: -50, duration: 300 }}>
		<div
			role="button"
			tabindex="0"
			transition:fade|global={{ duration: 200 }}
			on:click={close}
			on:keypress={close}
			class="modal-backdrop h-screen w-full fixed" />
		<div class="modal-box max-w-128">
			<slot />
		</div>
	</div>
{/if}
