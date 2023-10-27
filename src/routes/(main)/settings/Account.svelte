<script lang="ts">
	export let data: import("./$types").PageData
	const { user } = data
</script>

<div class="form-group row">
	<label for="name" class="col-md-3 text-md-right">Username</label>
	<div class="col-md-6">
		<input
			type="text"
			readonly
			id="name"
			disabled
			value={user?.username}
			class="form-control valid" />
	</div>
	<small class="grey-text pb-2">You cannot change your username.</small>
</div>
<hr class="grey-text" />

{#if user.email}
	<div class="form-group row pb-6">
		<label for="name" class="col-md-3 text-md-right">Email Address</label>
		<div class="col-md-6">
			<input
				type="text"
				readonly
				id="email"
				value={`*******@${user.email.split("@")[1]}`}
				class="form-control valid" />
		</div>
	</div>
	<hr class="grey-text" />
{/if}

<h4>Discord Verification</h4>
<p>A Discord account has not been linked.</p>
<button class="btn btn-primary">
	<fa fa-link />
	 Link Discord
</button>
<hr class="grey-text" />

<h4>Email Verification</h4>
<p>You have not verified your email address.</p>
<button class="btn btn-primary mb-4">
	<fa fa-envelope-circle-check />
	 Verify Email
</button>
