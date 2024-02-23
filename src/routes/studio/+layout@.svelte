<script lang="ts">
	// export let data

	import "/src/routes/studio/studio.styl"
</script>

<svelte:head>
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

<main>
	<slot />
</main>

<style lang="stylus">
	main
		z-index 1
</style>
