<script lang="ts">
	import os from "os"
	import { getUser } from "@lucia-auth/sveltekit/client"

	const user = getUser()

	const permissions: any = [
		[], // index from 1
		["white", "user", "User"],
		["aqua", "check", "Verified"],
		["violet", "hammer", "Catalog Manager"],
		["orange", "shield-alt", "Moderator"],
		["crimson", "scale-balanced", "Administrator"],
	]

	const freemem = os.freemem()
	const totalmem = os.totalmem()

	export let data
</script>

<svelte:head>
	<title>Admin - Mercury</title>
</svelte:head>

<div class="container py-4">
	<h1 class="h2 text-light">Admin Panel</h1>
	<h2 class="h4 mb-4 border-bottom border-2 pb-3 text-light">
		Your permission level is: <span style="color: {permissions[$user?.permissionLevel][0]}"
			><i class="fa fa-{permissions[$user?.permissionLevel][1]} me-1" />{permissions[$user?.permissionLevel][2]}</span
		>
	</h2>
	<div class="row">
		<div class="col-lg-2 col-md-3 mb-4">
			<ul class="nav nav-tabs flex-column border-0" role="tablist">
				{#if $user?.permissionLevel == 5}
					<li class="nav-item" role="presentation">
						<a class="nav-link active" data-bs-toggle="tab" href="#administration" aria-selected="true" role="tab">Administration</a>
					</li>
				{/if}
				<li class="nav-item" role="presentation">
					<a class="nav-link {$user?.permissionLevel == 5 ? '' : 'active'}" data-bs-toggle="tab" href="#moderation" aria-selected="false" role="tab" tabindex="-1">Moderation</a>
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
				{#if $user?.permissionLevel == 5}
					<div class="tab-pane fade active show" id="administration" role="tabpanel">
						<div class="row g-3">
							<div class="col-lg-3">
								<a href="/admin/banners" class="shadow-hover">
									<div class="card text-center light-text">
										<div class="card-body rounded-1 p-4">
											<h1><i class="fa-solid fa-bullhorn" /></h1>
											<h5 class="fw-normal mt-3">Banners</h5>
										</div>
									</div>
								</a>
							</div>
							<div class="col-lg-3">
								<a href="/admin/accounts" class="shadow-hover">
									<div class="card text-center light-text">
										<div class="card-body rounded-1 p-4">
											<h1><i class="fa-regular fa-user" /></h1>
											<h5 class="fw-normal mt-3">Accounts</h5>
										</div>
									</div>
								</a>
							</div>
							<div class="col-lg-3">
								<a href="#" class="shadow-hover">
									<div class="card text-center light-text">
										<div class="card-body rounded-1 p-4">
											<h1><i class="fa-solid fa-book" /></h1>
											<h5 class="fw-normal mt-3">Audit Logs</h5>
										</div>
									</div>
								</a>
							</div>
							<div class="col-lg-3">
								<a href="/admin/invites" class="shadow-hover">
									<div class="card text-center light-text">
										<div class="card-body rounded-1 p-4">
											<h1><i class="fa-solid fa-key" /></h1>
											<h5 class="fw-normal mt-3">Invites</h5>
										</div>
									</div>
								</a>
							</div>
							<div class="col-lg-3">
								<a href="#" class="shadow-hover">
									<div class="card text-center light-text">
										<div class="card-body rounded-1 p-4">
											<h1><i class="fa-solid fa-dice" /></h1>
											<h5 class="fw-normal mt-3">Coin Flip</h5>
										</div>
									</div>
								</a>
							</div>
						</div>
					</div>
				{/if}
				<div class="tab-pane fade {$user?.permissionLevel == 5 ? '' : 'active show'}" id="moderation" role="tabpanel">
					<div class="row g-3">
						<div class="col-lg-3">
							<a href="#" class="shadow-hover">
								<div class="card text-center light-text">
									<div class="card-body rounded-1 p-4">
										<h1><i class="fa-solid fa-user-slash" /></h1>
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
										<h1><i class="fa-solid fa-file-circle-check" /></h1>
										<h5 class="fw-normal mt-3">Asset Approval</h5>
									</div>
								</div>
							</a>
						</div>
					</div>
				</div>
				<div class="tab-pane fade" id="economy" role="tabpanel">
					<div class="row g-3">
						{#if $user?.permissionLevel == 5}
							<div class="col-lg-3">
								<a href="/admin/stipend" class="shadow-hover">
									<div class="card text-center light-text">
										<div class="card-body rounded-1 p-4">
											<h1><i class="fa-regular fa-clock" /></h1>
											<h5 class="fw-normal mt-3">Daily Stipend</h5>
										</div>
									</div>
								</a>
							</div>
						{/if}
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
						{#if $user?.permissionLevel == 5 || $user?.permissionLevel == 3}
							<div class="col-lg-3">
								<a href="#" class="shadow-hover">
									<div class="card text-center light-text">
										<div class="card-body rounded-1 p-4">
											<h1><i class="fa-solid fa-file-circle-plus" /></h1>
											<h5 class="fw-normal mt-3">Create New Asset</h5>
										</div>
									</div>
								</a>
							</div>
						{/if}
						<div class="col-lg-3">
							<a href="/admin/transactions" class="shadow-hover">
								<div class="card text-center light-text">
									<div class="card-body rounded-1 p-4">
										<h1><i class="fa-solid fa-money-bill-transfer" /></h1>
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
									<h3 class="light-text"><i class="fa-solid fa-memory" /> {((totalmem - freemem) / 1024 ** 3).toFixed(2)} / {(totalmem / 1024 ** 3).toFixed(2)} GB</h3>
									<span class="light-text">{Math.round((totalmem - freemem) / 1024 ** 2)} MB is being used</span>
									<div class="progress mt-2">
										<div
											class="progress-bar progress-bar-striped progress-bar-animated"
											role="progressbar"
											aria-valuenow={totalmem - freemem}
											aria-valuemin={0}
											aria-valuemax={totalmem}
											style="width: {((totalmem - freemem) / totalmem) * 100}%;"
										/>
									</div>
								</div>
							</div>
							<div class="card text-black mb-3">
								<div class="card-body rounded-1">
									<h3 class="light-text"><i class="fa-solid fa-hard-drive me-2" />{((data.size - data.free) / 1024 ** 3).toFixed(2)} / {(data.size / 1024 ** 3).toFixed(2)} GB</h3>
									<span class="light-text">{Math.round((data.size - data.free) / 1024 ** 2)} MB is being used</span>
									<div class="progress mt-2">
										<div
											class="progress-bar progress-bar-striped progress-bar-animated"
											role="progressbar"
											aria-valuenow={data.size - data.free}
											aria-valuemin={0}
											aria-valuemax={data.size}
											style="width: {((data.size - data.free) / data.size) * 100}%;"
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

<style lang="sass">
	h2
		border-color: var(--accent3) !important

	.progress
		background: var(--accent2)

	.card-body
		background: var(--accent)

	.card
		border-width: 2px
		border-color: var(--accent3)
		background: var(--accent3)

	.shadow-hover,
	.shadow-hover:link 
		color: #636c72
		text-decoration: none
		font-size: 14px

	.shadow-hover > .card 
		border-radius: 0.2rem
		box-shadow: none
		transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1)

	.shadow-hover:not(.no-hover-shadow-hover) > .card:active,
	.shadow-hover:not(.no-hover-shadow-hover) > .card:hover 
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

</style>
