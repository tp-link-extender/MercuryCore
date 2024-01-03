<script lang="ts">
	import superForm from "$lib/superForm"

	export let data
	const formData = superForm(data.form, {
		onResult: ({ result }) =>
			// Reload to get the new session after redirecting to homepage
			result.type == "redirect" ? window.location.reload() : null,
	})
	const { form, errors, constraints, enhance, delayed } = formData

	export const snapshot = formData
</script>

<Head title="Log in" description="Log into your Mercury account." />

<div id="wavep" class="w-full h-full absolute top-0 overflow-hidden">
	<div class="w-full fixed bottom-0">
		<div class="absolute" />
		<div class="absolute" />
	</div>
</div>

<div class="flex <lg:flex-col light-text h-screen overflow-auto">
	<div id="dark" class="lg:w-1/2 p-8vw pt-5vh lg:pt-20vh">
		<a type="button" href="/" class="btn btn-lg border-0 px-0 text-base">
			<fa fa-arrow-left class="pr-2" />
			Home
		</a>
		<h1 class="font-black pb-6">
			Mercury 2 <span class="opacity-50">beta</span>
		</h1>

		<div class="pl-4 w-full">
			<h2>Endless possibilities</h2>
			<p class="opacity-75">
				Create or play your favourite games and customise your character
				with items on our catalog.
			</p>
		</div>
		<div class="pl-4 w-full">
			<h2>New features</h2>
			<p class="opacity-75">
				In addition to full client usability, additional features such
				as security fixes, QoL fixes and an easy to use website make
				your experience better.
			</p>
		</div>
		<div class="pl-4 w-full">
			<h2>Same nostalgia</h2>
			<p class="opacity-75">
				All of our clients will remain as vanilla as possible, to make
				sure it's exactly as you remember it.
			</p>
		</div>
	</div>

	<div id="light" class="lg:w-1/2 p-8vw pt-5vh lg:pt-20vh">
		<div id="login" class="m-auto">
			{#if data.users}
				<h2>Log into your account</h2>
				<p>
					Don't yet have an account?
					<a href="/register" class="no-underline">Register</a>
				</p>

				<Form {formData} class="pt-6" submit="Log in">
					<Input
						{formData}
						column
						name="username"
						label="Username"
						placeholder="Username" />
					<Input
						{formData}
						column
						name="password"
						label="Password"
						type="password"
						placeholder="Password" />
				</Form>
			{:else}
				<h2>There are no users registered in the database yet!</h2>
				<p class="pt-4">
					Perhaps you've just set up the Mercury 2 source code.
					Perhaps you've already set it up, and something has gone
					terribly wrong with your database.
				</p>
				<p class="pt-2">
					If it's the former, head to the
					<a href="/register" class="no-underline">Register</a>
					page to create the first user!
				</p>
			{/if}
		</div>
	</div>
</div>

<style lang="stylus">
	@import "../loginregister"

	@keyframes waves
		0%
			margin-left 0
		100%
			margin-left -1600px
</style>
