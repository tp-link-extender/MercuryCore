<script lang="ts">
	const {
		online
	}: {
		online: boolean
	} = $props()
</script>

<form action="?/start&online={!online}" method="POST" class="space-y-4">
	{#if online}
		<button class="btn btn-red-secondary">Stop server</button>
	{:else}
		<button class="btn btn-primary">Start server</button>
	{/if}
</form>
