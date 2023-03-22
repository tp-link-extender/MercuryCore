<script lang="ts">
	import { enhance } from "$app/forms"
	import fade from "$lib/fade"

	export let form

	let moderationAction = 1

	const tomorrow = new Date(Date.now() + 86400000).toISOString().slice(0, 10)
</script>

<svelte:head>
	<title>Admin - Mercury</title>
</svelte:head>

<div class="container py-4">
	<h1 class="light-text mb-0">Admin - Moderate User</h1>
	<a href="/admin" class="text-decoration-none">
		<i class="fa-solid fa-caret-left" />
		Back to panel
	</a>
	<div class="row mt-4">
		<div class="col-lg-2 col-md-3 mb-4">
			<ul class="nav nav-tabs flex-column border-0">
				<li class="nav-item" role="presentation">
					<a
						class="nav-link active"
						data-bs-toggle="tab"
						href="#moderateUser"
						aria-selected="true"
						role="tab">
						Moderate User
					</a>
				</li>
			</ul>
		</div>
		<div class="col-lg-10 col-md-9">
			<div id="myTabContent" class="tab-content">
				<div
					class="tab-pane fade active show"
					id="moderateUser"
					role="tabpanel">
					<form use:enhance method="POST" action="?/moderateUser">
						<fieldset>
							<div class="row">
								<label
									for="username"
									class="col-md-3 col-form-label light-text text-md-right">
									Username
								</label>
								<div class="col-md-8">
									<input
										type="text"
										name="username"
										id="username"
										required
										class="form-control valid" />
								</div>
							</div>
							<br />
							<div class="row">
								<label
									for="action"
									class="col-md-3 col-form-label light-text text-md-right">
									Action
								</label>
								<div class="col-md-8">
									<select
										name="action"
										bind:value={moderationAction}
										id="action"
										required
										class="form-control light-text valid">
										<option value="1" selected>
											Warning
										</option>
										<option value="2">Ban</option>
										<option value="3">Termination</option>
										<option value="4">
											Account Deletion
										</option>
										<option value="5">Unban</option>
									</select>
								</div>
							</div>
							<br />
							{#if moderationAction == 2}
								<div class="row" transition:fade>
									<label
										for="banDate"
										class="col-md-3 col-form-label light-text text-md-right">
										Ban until
									</label>
									<div class="col-md-8">
										<input
											type="date"
											name="banDate"
											id="banDate"
											min={tomorrow}
											required
											class="form-control valid" />
									</div>
								</div>
							{/if}
							<br />
							<div class="row">
								<label
									for="reason"
									class="col-md-3 col-form-label light-text text-md-right">
									Reason
								</label>
								<div class="col-md-8">
									<textarea
										name="reason"
										id="reason"
										minlength="15"
										maxlength="150"
										required
										class="form-control valid" />
								</div>
							</div>
							<br />
							<button type="submit" class="btn btn-success">
								Submit
							</button>
						</fieldset>
					</form>
					<br />
					<p
						class="col-12 mb-3 text-{form?.moderationsuccess
							? 'success'
							: 'danger'}">
						{form?.msg || ""}
					</p>
				</div>
			</div>
		</div>
	</div>
</div>

<style lang="sass">

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
