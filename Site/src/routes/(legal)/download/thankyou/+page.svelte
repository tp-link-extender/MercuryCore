<script lang="ts">
	import Head from "$components/Head.svelte"

	const { data } = $props()
</script>

<Head name={data.siteName} title="Thank You" />

<h1 class="text-center">Welcome to {data.siteName}</h1>

<div class="ctnr pt-12 max-w-200">
	<div class="light-text">
		<h2 class="text-base text-center">
			Thank you for downloading our client. To get started, head over to
			Games to start playing! If you don't have an account with us, you
			can register <a href="/register" class="no-underline">here.</a>
		</h2>
	</div>
</div>
