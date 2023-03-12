<script lang="ts">
	import { enhance } from "$app/forms"
	import { getUser } from "@lucia-auth/sveltekit/client"

	const user = getUser()

	export let form
	export let data

	const permissions: any = [
		[], // index from 1
		["white", "user", "User"],
		["aqua", "check", "Verified"],
		["violet", "hammer", "Catalog Manager"],
		["orange", "shield-alt", "Moderator"],
		["crimson", "scale-balanced", "Administrator"],
	]
</script>

<svelte:head>
	<title>Admin - Mercury</title>
</svelte:head>

<div class="container py-4">
	<h2 class="text-light">Admin Panel</h2>
	<h4 class="mb-4 border-bottom border-2 pb-3 text-light">
		Your permission level is: <span style="color: {permissions[$user?.permissionLevel][0]}"
			><i class="fa fa-{permissions[$user?.permissionLevel][1]} me-1" />{permissions[$user?.permissionLevel][2]}</span
		>
	</h4>
	<div class="row">
		<div class="col-lg-2 col-md-3 mb-4">
			<ul class="nav nav-tabs flex-column border-0" role="tablist">
				<li class="nav-item" role="presentation">
					<a class="nav-link active" data-bs-toggle="tab" href="#administration" aria-selected="true" role="tab">Administration</a>
				</li>
				<li class="nav-item" role="presentation">
					<a class="nav-link" data-bs-toggle="tab" href="#moderation" aria-selected="false" role="tab" tabindex="-1">Moderation</a>
				</li>
				<li class="nav-item" role="presentation">
					<a class="nav-link" data-bs-toggle="tab" href="#economy" aria-selected="false" role="tab" tabindex="-1">Economy</a>
				</li>
				<li class="nav-item" role="presentation">
					<a class="nav-link" data-bs-toggle="tab" href="#statistics" aria-selected="false" role="tab" tabindex="-1">Statistics</a>
				</li>
			</ul>
		</div>
		<div class="col-lg-10 col-md-9">
			<div id="myTabContent" class="tab-content">
				<div class="tab-pane fade active show" id="administration" role="tabpanel">
					<div class="row g-3">
						<div class="col-lg-3">
							<a href="/admin/banners" class="shadow-hover">
								<div class="card text-center light-text">
									<div class="card-body rounded-1 p-4">
										<h1><i class="fa-solid fa-bullhorn"/></h1>
										<h5 class="fw-normal mt-3">Banners</h5>
									</div>
								</div>
							</a>
						</div>
						<div class="col-lg-3">
							<a href="#" class="shadow-hover">
								<div class="card text-center light-text">
									<div class="card-body rounded-1 p-4">
										<h1><i class="fa-regular fa-user" /></h1>
										<h5 class="fw-normal mt-3">User Information</h5>
									</div>
								</div>
							</a>
						</div>
						<div class="col-lg-3">
							<a href="#" class="shadow-hover">
								<div class="card text-center light-text">
									<div class="card-body rounded-1 p-4">
										<h1><i class="fa-solid fa-book"/></h1>
										<h5 class="fw-normal mt-3">Audit Logs</h5>
									</div>
								</div>
							</a>
						</div>
						<div class="col-lg-3">
							<a href="#" class="shadow-hover">
								<div class="card text-center light-text">
									<div class="card-body rounded-1 p-4">
										<h1><i class="fa-solid fa-key"></h1>
										<h5 class="fw-normal mt-3">Invites</h5>
									</div>
								</div>
							</a>
						</div>
						<div class="col-lg-3">
							<a href="#" class="shadow-hover">
								<div class="card text-center light-text">
									<div class="card-body rounded-1 p-4">
										<h1><i class="fa-solid fa-dice"/></h1>
										<h5 class="fw-normal mt-3">Coin Flip</h5>
									</div>
								</div>
							</a>
						</div>
					</div>
				</div>
				<div class="tab-pane fade" id="moderation" role="tabpanel">
					<div class="row g-3">
						<div class="col-lg-3">
							<a href="#" class="shadow-hover">
								<div class="card text-center light-text">
									<div class="card-body rounded-1 p-4">
										<h1><i class="fa-solid fa-user-slash"/></h1>
										<h5 class="fw-normal mt-3">Moderate User</h5>
									</div>
								</div>
							</a>
						</div>
						<div class="col-lg-3">
							<a href="#" class="shadow-hover">
								<div class="card text-center light-text">
									<div class="card-body rounded-1 p-4">
										<h1><i class="fa-regular fa-flag" /></h1>
										<h5 class="fw-normal mt-3">Report Abuse</h5>
									</div>
								</div>
							</a>
						</div>
						<div class="col-lg-3">
							<a href="#" class="shadow-hover">
								<div class="card text-center light-text">
									<div class="card-body rounded-1 p-4">
										<h1><i class="fa-solid fa-file-circle-check"/></h1>
										<h5 class="fw-normal mt-3">Asset Approval</h5>
									</div>
								</div>
							</a>
						</div>
					</div>
				</div>
				<div class="tab-pane fade" id="economy" role="tabpanel">
					<div class="row g-3">
						<div class="col-lg-3">
							<a href="#" class="shadow-hover">
								<div class="card text-center light-text">
									<div class="card-body rounded-1 p-4">
										<h1><i class="fa-regular fa-clock" /></h1>
										<h5 class="fw-normal mt-3">Daily Stipend</h5>
									</div>
								</div>
							</a>
						</div>
						<div class="col-lg-3">
							<a href="#" class="shadow-hover">
								<div class="card text-center light-text">
									<div class="card-body rounded-1 p-4">
										<h1><i class="fa-regular fa-gem" /></h1>
										<h5 class="fw-normal mt-3">Award Currency</h5>
									</div>
								</div>
							</a>
						</div>
						<div class="col-lg-3">
							<a href="#" class="shadow-hover">
								<div class="card text-center light-text">
									<div class="card-body rounded-1 p-4">
										<h1><i class="fa-solid fa-file-circle-plus"/></h1>
										<h5 class="fw-normal mt-3">Create New Asset</h5>
									</div>
								</div>
							</a>
						</div>
						<div class="col-lg-3">
							<a href="#" class="shadow-hover">
								<div class="card text-center light-text">
									<div class="card-body rounded-1 p-4">
										<h1><i class="fa-solid fa-money-bill-transfer"/></h1>
										<h5 class="fw-normal mt-3">Transactions</h5>
									</div>
								</div>
							</a>
						</div>
					</div>
				</div>
				<div class="tab-pane fade" id="statistics" role="tabpanel">
					<div class="row g-3">
						<div class="col-lg-7 col-md-7">
							<div class="card text-black mb-3">
								<div class="card-body rounded-1">
									<h3 class="light-text"><i class="fa-solid fa-memory"></i> 0 / 0 GB</h3>
									<span class="light-text">0 MB is being used</span>
									<div class="progress mt-2">
										<div
											class="progress-bar progress-bar-striped progress-bar-animated"
											role="progressbar"
											aria-valuenow="1"
											aria-valuemin="0"
											aria-valuemax="100"
											style="width: 1%;"
										/>
									</div>
								</div>
							</div>
							<div class="card text-black mb-3">
								<div class="card-body rounded-1">
									<h3 class="light-text"><i class="fa-solid fa-hard-drive me-2" />0 / 0 GB</h3>
									<span class="light-text">0 MB is being used</span>
									<div class="progress mt-2">
										<div
											class="progress-bar progress-bar-striped progress-bar-animated"
											role="progressbar"
											aria-valuenow="1"
											aria-valuemin="0"
											aria-valuemax="100"
											style="width: 1%;"
										/>
									</div>
								</div>
							</div>
						</div>
						<div class="col-lg-5 col-md-5">
							<div class="card text-black mb-3">
								<div class="card-body rounded-1">
									<h3 class="light-text"><i class="fa-regular fa-user me-2" />Users</h3>
									<span class="light-text"><b class="text-primary">0 users</b> are currently online</span>
								</div>
							</div>
							<div class="card text-black mb-3">
								<div class="card-body rounded-1">
									<h3 class="light-text"><i class="fa-regular fa-file me-2" />Assets</h3>
									<span class="light-text"><i class="fa-solid text-warning fa-file-circle-minus me-2" /><b class="light-text">0 assets</b> are currently pending</span><br />
									<span class="light-text"><i class="fa-solid text-success fa-file-circle-check me-2" /><b class="light-text">0 assets</b> have been approved</span><br />
									<span class="light-text"><i class="fa-solid text-danger fa-file-circle-xmark me-2" /><b class="light-text">0 assets</b> have been disapproved</span><br />
									<span class="light-text"><i class="fa-solid text-info fa-folder-closed me-2" /><b class="light-text">0 assets</b> in total</span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<hr />

<h1 class="text-center light-text">Admin panel</h1>

<div class="container mt-5 light-text">
	<h2 class="light-text">Banner</h2>
	<form use:enhance method="POST" action="?/updateBanner">
		<fieldset>
			<div class="row">
				<label for="bannerText" class="col-md-3 col-form-label text-md-right">Banner text</label>
				<div class="col-md-8">
					<input type="text" name="bannerText" id="bannerText" class="form-control valid" />
				</div>
			</div>
			<br />
			<div class="row">
				<label for="bannerColour" class="col-md-3 col-form-label text-md-right">Banner colour</label>
				<div class="col-md-2">
					<input type="color" name="bannerColour" id="bannerColour" required class="valid" />
				</div>
			</div>
			<br />
			<div class="row">
				<label for="bannerTextLight" class="col-md-3 col-form-label text-md-right">Light text?</label>
				<div class="col-md-2">
					<input type="checkbox" name="bannerTextLight" id="bannerTextLight" value="true" class="valid form-check-input" />
				</div>
			</div>
			<br />
			<button type="submit" class="btn btn-success">Submit</button>
		</fieldset>
	</form>
	<br />
	{#if form?.bannersuccess}
		<p class="col-12 mb-3 text-success">{form?.msg}</p>
	{/if}

	<br />
	<h2 class="light-text">Economy</h2>
	<form use:enhance method="POST" action="?/economy">
		<fieldset>
			<div class="row">
				<label for="taxRate" class="col-md-3 col-form-label text-md-right">Tax rate</label>
				<div class="col-md-8">
					<div class="input-group">
						<input type="number" name="taxRate" id="taxRate" value={data.taxRate} required class="form-control valid" />
						<span class="input-group-text light-text">%</span>
					</div>
				</div>
			</div>
			<br />
			<div class="row">
				<label for="dailyStipend" class="col-md-3 col-form-label text-md-right">Daily stipend</label>
				<div class="col-md-8">
					<div class="input-group">
						<input type="number" name="dailyStipend" id="dailyStipend" value={data.dailyStipend} required class="form-control valid" />
						<span class="input-group-text light-text"><i class="fa fa-gem text-success" /></span>
					</div>
				</div>
			</div>
			<br />
			<div class="row">
				<label for="stipendTime" class="col-md-3 col-form-label text-md-right">Time between stipend</label>
				<div class="col-md-8">
					<div class="input-group">
						<input type="number" name="stipendTime" id="stipendTime" value={data.stipendTime} required class="form-control valid" />
						<span class="input-group-text light-text">hours</span>
					</div>
				</div>
			</div>
			<br />
			<button type="submit" class="btn btn-success">Submit</button>
		</fieldset>
	</form>
	<br />
	{#if form?.economysuccess}
		<p class="col-12 mb-3 text-success">{form?.msg}</p>
	{/if}

	<br />

	<h2 class="light-text">User</h2>
	<form use:enhance method="POST" action="?/user">
		<fieldset>
			<div class="row">
				<label for="username" class="col-md-3 col-form-label text-md-right">Username</label>
				<div class="col-md-8">
					<input type="text" name="username" id="username" required class="form-control valid" />
				</div>
			</div>
			<br />
			<div class="row">
				<label for="password" class="col-md-3 col-form-label text-md-right">New password</label>
				<div class="col-md-8">
					<input type="text" name="password" id="password" required class="form-control valid" />
				</div>
			</div>
			<br />
			<button type="submit" class="btn btn-success">Submit</button>
		</fieldset>
	</form>
	<br />
	{#if form?.usersuccess}
		<p class="col-12 mb-3 text-success">{form?.msg}</p>
	{/if}

	{#if form?.error}
		<p class="col-12 mb-3 text-danger">{form?.msg}</p>
	{/if}
</div>

<style lang="sass">

	.card-body
		background: var(--accent)

	.card
		border-width: 2px

	.shadow-hover,
	.shadow-hover:link 
		color: #636c72
		text-decoration: none
		font-size: 14px

	.shadow-hover>.card 
		border-radius: 0.2rem
		box-shadow: none
		transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1)

	.shadow-hover:not(.no-hover-shadow-hover)>.card:active,
	.shadow-hover:not(.no-hover-shadow-hover)>.card:hover 
		box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.1), 0 1px 4px 2px rgba(0, 0, 0, 0.1)

	.nav-tabs .nav-item.show .nav-link,
	.nav-tabs .nav-link.active 
		color: rgb(255, 255, 255)
		background-color: rgb(13, 109, 252)
		border-color: var(--bs-nav-tabs-link-active-border-color)
		border-radius: 0.375rem
        
	.nav-tabs .nav-link 
		margin-bottom: calc(0 * var(--bs-nav-tabs-border-width))
		background: 0 0
		border: var(--bs-nav-tabs-border-width) solid transparent
		border-radius: 0.375rem
        
	.nav-link
		border-radius: 0
		color: var(--light-text)
        
	input[type="color"]
		height: 2.5rem
	input[type="checkbox"]
		height: 1.5rem
		width: 1.5rem

	.input-group-text
		background: var(--accent1)
		border-color: var(--accent3)
</style>
