<script lang="ts">
	import Head from "$components/Head.svelte"
	
	const { data } = $props()
</script>

<Head name={data.siteName} title="{data.name} Settings" />

<div class="ctnr max-w-220 light-text">
	<div class="pb-4">
		<h1>Configure {data.name}</h1>
		<a href="/catalog/{data.id}/{data.slug}" class="no-underline">
			<fa fa-caret-left></fa>
			Back to asset
		</a>
	</div>
</div>
