<script lang="ts">
	import { fly } from "svelte/transition"

	export let path: any
</script>

<!-- Update whenever path changes -->
{#key path} 
	<div in:fly={{ y: 30, duration: 300 }}>
		<slot />
	</div>
{/key}
