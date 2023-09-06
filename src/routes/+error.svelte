<script lang="ts">
	// If an error happens in any +page or +layout file,
	// this page will be rendered instead.

	import { page } from "$app/stores"

	const status = $page.status,
		errors: { [k: number]: string } = {
			401: "mStop",
			403: "mStop",
			404: "mQuestion",
			409: "mDouble",
			410: "mGone",
			454: "mTick",
			451: "mBurn",
		}

	export let data: import("./$types").LayoutData
</script>

<Head title="Error {status}" />

<Navbar {data} />

<main>
	<div
		class="container d-flex flex-column justify-content-center align-items-center light-text bg-a rounded-4">
		<h1 class="light-text">Error {$page.status}</h1>
		{$page.error?.message}
		<a href="/home" class="accent-text">Head home?</a>
	</div>
</main>

<Footer />

<style lang="stylus">
	.errimg
		height 6rem

		background-size contain
		background-repeat no-repeat
		background-position center

		&.light
			display block
		&.dark
			display none

		+lightTheme()
			&.light
				display none
			&.dark
				display block


	main
		padding-bottom 25vh
		padding-top 25vh
		flex 1 0 auto
		+-lg()
			padding-top 23vh
			padding-bottom 22vh
		+-md()
			padding-top 20vh
			padding-bottom 20vh

		div
			width fit-content
			padding 2rem 5rem
</style>
