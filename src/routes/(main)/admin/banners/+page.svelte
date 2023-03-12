<script lang="ts">
    import { enhance } from "$app/forms"

    export let data
	export let form

	async function updateVisibility(bannerID: any) {
		const formdata = new FormData()

		formdata.append("bannerID", bannerID)
	}

</script>

<svelte:head>
	<title>Admin - Mercury</title>
</svelte:head>

<div class="container py-4">
	<h1 class="light-text mb-0">Admin - Banners</h1>
    <a href="/admin" class="text-decoration-none"><i class="fa-solid fa-caret-left"></i> Back to panel</a>
	<div class="row mt-4">
		<div class="col-lg-2 col-md-3 mb-4">
			<ul class="nav nav-tabs flex-column border-0" role="tablist">
				<li class="nav-item" role="presentation">
					<a class="nav-link active" data-bs-toggle="tab" href="#makebanner" aria-selected="true" role="tab">Create Banner</a>
				</li>
				<li class="nav-item" role="presentation">
					<a class="nav-link" data-bs-toggle="tab" href="#viewbanners" aria-selected="false" role="tab" tabindex="-1">Banner List</a>
				</li>
			</ul>
		</div>
		<div class="col-lg-10 col-md-9">
			<div id="myTabContent" class="tab-content">
				<div class="tab-pane fade active show" id="makebanner" role="tabpanel">
					<form use:enhance method="POST" action="?/createBanner">
						<fieldset>
							<div class="row">
								<label for="bannerText" class="col-md-3 col-form-label text-md-right light-text">Banner text</label>
								<div class="col-md-8">
									<textarea name="bannerText" id="bannerText" class="form-control valid">

									</textarea>
									<small class="light-text">3-100 characters</small>
								</div>
							</div>
							<br />
							<div class="row">
								<label for="bannerColour" class="col-md-3 col-form-label text-md-right light-text">Banner colour</label>
								<div class="col-md-2">
									<input type="color" name="bannerColour" id="bannerColour" required class="valid" />
								</div>
							</div>
							<br />
							<div class="row">
								<label for="bannerTextLight" class="col-md-3 col-form-label text-md-right light-text">Light text</label>
								<div class="col-md-2">
									<input type="checkbox" name="bannerTextLight" id="bannerTextLight" value="true" class="valid form-check-input" />
								</div>
							</div>
							<br />
							<button type="submit" class="btn btn-success">Submit</button>
							<br />
							{#if form?.bannersuccess}
								<p class="col-12 mb-3 text-success">{form?.msg}</p>
							{/if}

							{#if form?.error}
								<p class="col-12 mb-3 text-danger">{form?.msg}</p>
							{/if}
						</fieldset>
					</form>
				</div>
				<div class="tab-pane fade" id="viewbanners" role="tabpanel">
					<table class="table table-responsive">
						<thead class="light-text">
						  <tr>
							<th scope="col">Options</th>
							<th scope="col">Active</th>
							<th scope="col">Body</th>
							<th scope="col">Creator</th>
						  </tr>
						</thead>
						<tbody class="light-text">
						{#each data.banners as banner}
						  <tr>
							<th>
								<button type="button" class="btn btn-sm btn-link text-decoration-none text-danger my-0"><i class="fa-solid fa-trash"></i> Delete Banner</button>
								<button type="button" on:click={() => {updateVisibility(banner.id)}} class="btn btn-sm btn-link text-decoration-none text-{banner.active ? "warning" : "success"} my-0"><i class="fa-solid fa-eye{banner.active ? "-slash" : ""}"></i> {banner.active ? "Dea" : "A"}ctivate</button>
							</th>
							<th>{banner.active ? "Yes" : "No"}</th>
							<td><button type="button" class="btn btn-sm btn-success my-0">View Body</button></td>
							<td><a href="/user/{banner.user.number}" class="text-decoration-none">{banner.user.username}</a></td>
						  </tr>
						{/each}
						</tbody>
					  </table>
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
        
	input[type="color"]
		height: 2.5rem
	input[type="checkbox"]
		height: 1.5rem
		width: 1.5rem

</style>
