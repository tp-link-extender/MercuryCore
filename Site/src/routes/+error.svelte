<script lang="ts">
	// If an error happens in any +page or +layout file, this page will be rendered instead.

	import { page } from "$app/stores"
	import Footer from "$components/Footer.svelte"
	import Head from "$components/Head.svelte"
	import Navbar from "$components/Navbar.svelte"

	export let data: import("./$types").LayoutData

	const status = $page.status
	function errors() {
		if (status === 401 || status === 403) return "403"
		if (status === 404) return "404"
		if (status < 500) return "400"
		return "500"
	}
</script>

<Head name={data.siteName} title="Error {status}" />

<Navbar {data} />

<main class="flex-1 flex justify-center items-center py-4">
	<div class="ctnr bg-a flex flex-col items-center rounded-4 px-20 py-8">
		<div
			class="w-full h-24 bg-contain bg-no-repeat bg-center"
			style="background-image: url(/error/{errors()}.svg)">
		</div>

		<h1 class="pt-4">
			<a
				href="https://http.cat/images/{status}.jpg"
				target="_blank"
				rel="noopener noreferrer"
				class="light-text no-underline">
				Error {status}
			</a>
		</h1>
		{$page.error?.message}
		<a href="/home" class="accent-text">Head home?</a>
	</div>
</main>

<Footer {data} />
