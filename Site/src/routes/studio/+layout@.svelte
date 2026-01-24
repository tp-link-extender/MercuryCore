<script lang="ts">
	import { dev } from "$app/environment"

	import "/src/global.css"
	import "/src/icons.css"
	import "uno.css"
	import "/src/routes/studio/studio.css"

	const { data, children } = $props()
</script>

<svelte:head>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1" />

	{#if !dev}
		<script
			defer
			data-domain={data.domain}
			src="https://analytics.{data.domain}/js/script.js"></script>
	{/if}

	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<script>
		window.onerror = function (msg, url, line) {
			alert("Message: " + msg + "\nUrl: " + url + "\nLine: " + line)
		}
	</script>
	<script>
		// poor man's hmr
		// setTimeout(function() {
		// 	window.location.reload()
		// }, 1000)
	</script>
</svelte:head>

{@render children()}
