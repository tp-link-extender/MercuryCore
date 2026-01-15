<script lang="ts">
	const { data }: { data: import("./$types").PageData } = $props()

	let { user } = $derived(data)
</script>

<div class="form-group flex flex-wrap">
	<label for="name" class="w-full md:w-1/3">Username</label>
	<div class="w-full md:w-2/3">
		<input type="text" readonly id="name" disabled value={user?.username} />
		<small class="formhelp">You cannot change your username.</small>
	</div>
</div>

{#if user.email}
	<hr class="grey-text" />
	<div class="form-group flex flex-wrap pb-6">
		<label for="name" class="w-full md:w-1/3">Email Address</label>
		<div class="w-full md:w-2/3">
			<input type="text" readonly id="email" value={user.email} />
		</div>
	</div>
{/if}

<!-- <hr class="grey-text" /> -->
<!-- <h3 class="text-base">Email Verification</h3>
<p>You have not verified your email address.</p>
<button class="btn btn-tertiary">
	<fa fa-envelope-circle-check class="pr-2"></fa>
	Verify Email
</button> -->
