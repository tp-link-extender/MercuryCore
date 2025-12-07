<script lang="ts">
	import Head from "$components/Head.svelte"
	
	const { data } = $props()
</script>

<Head name={data.siteName} title="{data.asset.name} Settings" />
