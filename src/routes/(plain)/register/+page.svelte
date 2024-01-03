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

<Head title="Register" description="Create a Mercury account." />

<div id="wavep" class="w-full h-full absolute top-0 overflow-hidden">
	<div class="w-full fixed bottom-0">
		<div class="absolute" />
		<div class="absolute" />
	</div>
</div>

<div class="flex <lg:flex-col light-text h-screen overflow-auto">
	<div id="dark" class="lg:w-1/2 p-8vw pt-5vh lg:pt-11vh">
		<a type="button" href="/" class="btn btn-lg border-0 px-0 text-base">
			<fa fa-arrow-left class="pr-2" />
			Home
		</a>
		<h1 class="font-black pb-6">
			Mercury 2 <span class="opacity-50">beta</span>
		</h1>

		<div class="pl-4 w-full">
			<h2>Original username</h2>
			<p class="opacity-75">
				Make sure it is appropriate and between 3-21 characters.
				Underscores are allowed.
			</p>
		</div>
		<div class="pl-4 w-full">
			<h2>Valid email</h2>
			<p class="opacity-75">
				Mercury requires a valid email so you can reset your password at
				any time.
			</p>
		</div>
		<div class="pl-4 w-full">
			<h2>Secure password</h2>
			<p class="opacity-75">
				Make sure your password has a mix of letters, numbers, and
				symbols to protect against hackers.
			</p>
		</div>
	</div>

	<div id="light" class="lg:w-1/2 p-8vw pt-5vh lg:pt-11vh">
		<div id="login" class="m-auto">
			{#if data.users}
				<h2>Create a free account</h2>
				<p>
					Already have an account?
					<a href="/login" class="no-underline">Log in</a>
				</p>

				<Form
					{formData}
					action="?/register"
					class="pt-6"
					submit="Register">
					<Input
						{formData}
						column
						name="username"
						label="Username"
						placeholder="3-21 characters" />
					<Input
						{formData}
						column
						name="email"
						label="Email Address"
						type="email"
						placeholder="mercury@banland.xyz" />
					<Input
						{formData}
						column
						name="password"
						label="Password"
						type="password"
						placeholder={"•".repeat(14)} />
					<Input
						{formData}
						column
						name="cpassword"
						label="Confirm Password"
						type="password"
						placeholder={"•".repeat(14)} />
					<Input
						{formData}
						column
						name="regkey"
						label="Registration Key"
						placeholder="mercurkey-12311121123" />
				</Form>

				<p>
					By signing up, you agree to our
					<a href="/terms" class="no-underline">Terms of Service</a>
					and
					<a href="/privacy" class="no-underline">Privacy policy</a>
					.
				</p>
			{:else}
				<h2>Create the initial account</h2>

				<p class="pt-2">
					This will be the first user account on this Mercury
					instance!
				</p>
				<p>
					It will have all permissions, and will be the destination
					for all transactions that aren't sent to a specific user. It
					will be initialised with a balance of
					<span class="text-success">
						<fa fa-gem />
						999999
					</span>
					, which will not increase or decrease when transactions are made
					to or from the account.
				</p>
				<p>
					Pick the username and password carefully, and good luck on
					your journey with Mercury!
				</p>

				<Form
					{formData}
					action="?/initialAccount"
					class="pt-6"
					submit="Let's begin!">
					<Input
						{formData}
						column
						name="username"
						label="Username"
						placeholder="3-21 characters" />
					<Input
						{formData}
						column
						name="password"
						label="Password"
						type="password"
						placeholder={"•".repeat(14)} />
					<Input
						{formData}
						column
						name="cpassword"
						label="Confirm Password"
						type="password"
						placeholder={"•".repeat(14)} />
				</Form>
				<p>
					If you want to create more users, head to the Admin panel
					after logging in to create some registration keys, then come
					back to this page.
				</p>
			{/if}
		</div>
	</div>
</div>

<style lang="stylus">
	@import "../loginregister"

	@keyframes waves
		0%
			margin-left -1600px
		100%
			margin-left 0
</style>
