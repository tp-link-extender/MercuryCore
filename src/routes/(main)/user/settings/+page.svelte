<script lang="ts">
	import { getUser } from "@lucia-auth/sveltekit/client"

	const user = getUser()
</script>

<svelte:head>
	<title>Settings - Mercury</title>
</svelte:head>

<div class="container mt-4">
	<h1 class="light-text mb-4">Settings</h1>
	<ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">
	   <li class="nav-item" role="presentation">
		  <button class="nav-link active" id="pills-profile-tab" data-bs-toggle="pill" data-bs-target="#pills-profile" type="button" role="tab" aria-controls="pills-profile" aria-selected="true"
			 >Profile</button
			 >
	   </li>
	   <li class="nav-item" role="presentation">
		  <button class="nav-link" id="pills-home-tab" data-bs-toggle="pill" data-bs-target="#pills-home" type="button" role="tab" aria-controls="pills-home" aria-selected="false" tabindex="-1"
			 >Account</button
			 >
	   </li>
	   <li class="nav-item" role="presentation">
		  <button
			 class="nav-link"
			 id="pills-contact-tab"
			 data-bs-toggle="pill"
			 data-bs-target="#pills-contact"
			 type="button"
			 role="tab"
			 aria-controls="pills-contact"
			 aria-selected="false"
			 tabindex="-1">Security</button
			 >
	   </li>
	</ul>
	<div class="tab-content light-text mt-4" id="pills-tabContent">
	   <div class="tab-pane fade active show" id="pills-profile" role="tabpanel" aria-labelledby="pills-profile-tab" tabindex="0">
		  <h4 class="light-text fw-normal mb-1">User Profile</h4>
		  <p class="mb-0 text-muted mb-4">Change your blurb, site theme and more.</p>
		  <div class="col-lg-8">
			 <div class="form-group row">
				<label for="displayName" class="col-md-3 col-form-label text-md-right">Display Name</label>
				<div class="col-md-8"><input type="text" id="displayName" required="required" autofocus="autofocus" name="displayName" value={$user?.displayname} class="form-control" /></div>
				<small class="text-muted pb-2">You can only change your display name every 7 days.</small>
			 </div>
			 <hr />
			 <div class="form-group row">
				<label for="blurb" class="form-label light-text">Blurb</label>
				<div class="container">
				   <textarea class="form-control light-text mb-1" id="blurb" rows="3" /><small class="text-muted pb-2"
					  >Maximum 1000 characters, your blurb will appear on your profile and allow other users to know who you are.</small
					  >
				</div>
			 </div>
		  </div>
	   </div>
	   <div class="tab-pane fade" id="pills-home" role="tabpanel" aria-labelledby="pills-home-tab" tabindex="0">
		  <h4 class="light-text fw-normal mb-1">User Information</h4>
		  <p class="mb-0 text-muted mb-4">Information about your account, you can change certain aspects of it here.</p>
		  <div class="col-lg-8">
			 <div class="form-group row">
				<label for="name" class="col-md-3 col-form-label text-md-right">Username</label>
				<div class="col-md-9">
				   <input type="text" readonly="" id="name" name="name" disabled value="{$user?.username}" class="form-control" />
				</div>
				<small class="text-muted pb-2">You cannot change your username.</small>
			 </div>
			 <hr />
			 <div class="form-group row">
				<label for="name" class="col-md-3 col-form-label text-md-right">Email Address</label>
				<div class="col-md-9">
				   <input type="text" readonly="" id="name" name="name" value="**********@gmail.com" required="required" autofocus="autofocus" class="form-control" />
				</div>
			 </div>
		  </div>
		  <h4 class="mt-5 border-top pt-4 light-text">Discord Verification</h4>
		  <p
			 class="mb-2
			 "
			 >
			 A Discord account has not been linked.
		  </p>
		  <button type="submit" class="btn btn-primary"><i class="fa-solid fa-link"></i> Link Discord</button>
		  <h4 class="mb-2 mt-3 border-top pt-4 light-text">Email Verification</h4>
		  <p
			 class="mb-2
			 "
			 >
			 You have not verified your email address.
		  </p>
		  <button type="submit" class="btn btn-primary mb-3"><i class="fa-solid fa-envelope-circle-check"></i> Verify Email</button>
	   </div>
	   <div class="tab-pane fade" id="pills-contact" role="tabpanel" aria-labelledby="pills-contact-tab" tabindex="0">
		  <h4 class="fw-normal light-text mb-3">Change Password</h4>
		  <div class="col-sm-8">
			 <div class="form-group row gx-0 mb-2">
				<label for="password" class="col-sm-4 col-form-label pt-0">Current Password</label>
				<div class="col-sm-10">
				   <input type="password" class="form-control mb-1 light-text" id="password" />
				</div>
			 </div>
			 <div class="form-group row gx-0 mb-2">
				<label for="password" class="col-sm-4 col-form-label pt-0">New Password</label>
				<div class="col-sm-10">
				   <input type="password" class="form-control mb-1 light-text" id="password" />
				</div>
				<small class="text-muted">Make sure your password is unique.</small>
			 </div>
			 <div class="form-group row gx-0 mb-2">
				<label for="password" class="col-sm-4 col-form-label pt-0">Confirm New Password</label>
				<div class="col-sm-10">
				   <input type="password" class="form-control mb-1 light-text" id="password" />
				</div>
			 </div>
		  </div>
	   </div>
	</div>
	<button type="submit" class="btn btn-success mt-4">Save Changes</button>
 </div>

<style lang="sass">
	.nav-link
		border-radius: 0
		color: var(--light-text)
	
	input
		background: var(--accent)
	textarea 
		background: var(--accent)
	.form-control
		color: var(--light-text)

	.nav-pills .active
		background: transparent
		border-style: solid
		border-width: 0px 0px 2px 0px
		border-color: var(--bs-blue)
		color: var(--light-text)
</style>
