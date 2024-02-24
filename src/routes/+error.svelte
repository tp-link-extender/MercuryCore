<script lang="ts">
	// If an error happens in any +page or +layout file, this page will be rendered instead.

	import { page } from "$app/stores"

	const status = $page.status
	const errors: { [k: number]: string } = {
		401: "mStop",
		403: "mStop",
		404: "mQuestion",
		409: "mDouble",
		410: "mGone",
		451: "mBurn",
		454: "mTick"
	}

	export let data: import("./$types").LayoutData
</script>

<Head title="Error {status}" />

<Navbar {data} />

<main class="flex-1 flex justify-center items-center py-4">
	<div class="ctnr flex flex-col items-center bg-a rounded-4 px-20 py-8">
		<div
			class="errimg light w-full h-24 bg-contain bg-no-repeat bg-center"
			style="background-image: url(/error/{errors[status] ||
				'm!'}.svg)" />

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
