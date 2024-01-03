<script lang="ts">
	export let data: import("./$types").PageData
	const { user } = data
</script>

<div class="form-group flex flex-wrap">
	<label for="name" class="w-full md:w-1/3 text-md-right">Username</label>
	<div class="w-full md:w-2/3">
		<input type="text" readonly id="name" disabled value={user?.username} />
		<small class="w-full grey-text pb-2">
			You cannot change your username.
		</small>
	</div>
</div>
<hr class="grey-text" />

{#if user.email}
	<div class="form-group flex flex-wrap pb-6">
		<label for="name" class="w-full md:w-1/3 text-md-right">
			Email Address
		</label>
		<div class="w-full md:w-2/3">
			<input type="text" readonly id="email" value={user.email} />
		</div>
	</div>
	<hr class="grey-text" />
{/if}

<h3 class="fs-4">Discord Verification</h3>
<p>A Discord account has not been linked.</p>
<button class="btn btn-primary">
	<fa fa-link />
	Link Discord
</button>
<hr class="grey-text" />

<h3 class="fs-4">Email Verification</h3>
<p>You have not verified your email address.</p>
<button class="btn btn-primary mb-4">
	<fa fa-envelope-circle-check />
	Verify Email
</button>
