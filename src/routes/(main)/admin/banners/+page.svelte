<script lang="ts">
	import { enhance } from "$app/forms"
	import { writable } from "svelte/store"
	import Modal from "$lib/components/Modal.svelte"
	import fade from "$lib/fade"

	export let data
	export let form: any

	let modal = writable(false)

	let bannerId = ""
	let bannerBody = ""
	let newBannerBody = ""
	let textarea: any

	const viewBody = (id: any, body: any) => () => {
		modal.set(true)

		bannerId = id
		bannerBody = body.trim()
		newBannerBody = body.trim()
	}

	$: form && (() => (textarea.value = form?.bannerBody))()
</script>

<svelte:head>
	<title>Admin - Mercury</title>
</svelte:head>

<div class="container py-4">
	<h1 class="light-text mb-0">Admin - Banners</h1>
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
						href="#makebanner"
						aria-selected="true"
						role="tab">
						Create Banner
					</a>
				</li>
				<li class="nav-item" role="presentation">
					<a
						class="nav-link"
						data-bs-toggle="tab"
						href="#viewbanners"
						aria-selected="false"
						role="tab"
						tabindex="-1">
						Banner List
					</a>
				</li>
			</ul>
		</div>
		<div class="col-lg-10 col-md-9">
			<div id="myTabContent" class="tab-content">
				<div
					class="tab-pane fade active show"
					id="makebanner"
					role="tabpanel">
					<form use:enhance method="POST">
						<fieldset>
							<div class="row">
								<label
									for="bannerText"
									class="col-md-3 col-form-label text-md-right light-text">
									Banner text
								</label>
								<div class="col-md-8">
									<textarea
										name="bannerText"
										id="bannerText"
										class="form-control valid" />
									<small class="light-text">
										3-100 characters
									</small>
								</div>
							</div>
							<br />
							<div class="row">
								<label
									for="bannerColour"
									class="col-md-3 col-form-label text-md-right light-text">
									Banner colour
								</label>
								<div class="col-md-2">
									<input
										type="color"
										name="bannerColour"
										id="bannerColour"
										required
										class="valid" />
								</div>
							</div>
							<br />
							<div class="row">
								<label
									for="bannerTextLight"
									class="col-md-3 col-form-label text-md-right light-text">
									Light text
								</label>
								<div class="col-md-2">
									<input
										type="checkbox"
										name="bannerTextLight"
										id="bannerTextLight"
										value="true"
										class="valid form-check-input" />
								</div>
							</div>
							<br />
							<button
								name="action"
								value="create"
								class="btn btn-success">
								Submit
							</button>
							<br />
							{#if form?.area == "create"}
								<p
									class="col-12 mb-3 text-{form?.success
										? 'success'
										: 'danger'}">
									{form?.msg || ""}
								</p>
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
								<th scope="col">Color</th>
								<th scope="col">Text Color</th>
								<th scope="col">Creator</th>
							</tr>
						</thead>
						<tbody class="light-text">
							{#each data.banners as banner}
								<!-- <tr in:fade|global={{ num, total: data.banners.length }}> -->
								<tr>
									<td>
										<form use:enhance method="POST">
											<input
												type="hidden"
												name="id"
												value={banner.id} />
											<button
												name="action"
												value="delete"
												class="btn btn-sm btn-link text-decoration-none text-danger my-0">
												<i class="fa-solid fa-trash" />
												Delete Banner
											</button>
										</form>
										<form use:enhance method="POST">
											<input
												type="hidden"
												name="action"
												value={banner.active
													? "hide"
													: "show"} />
											<input
												type="hidden"
												name="id"
												value={banner.id} />
											<button
												type="submit"
												class="btn btn-sm btn-link text-decoration-none text-{banner.active
													? 'warning'
													: 'success'} my-0">
												<i
													class="fa-solid fa-eye{banner.active
														? '-slash'
														: ''}" />
												{banner.active
													? "Dea"
													: "A"}ctivate
											</button>
										</form>
									</td>
									<td>{banner.active ? "Yes" : "No"}</td>
									<td>
										<button
											type="button"
											on:click={viewBody(
												banner.id,
												banner.body
											)}
											class="btn btn-sm btn-success my-0">
											View Body
										</button>
									</td>
									<td>
										<input
											type="color"
											value={banner.bgColour}
											disabled
											class="valid" />
									</td>
									<td>
										{banner.textLight ? "Light" : "Dark"}
									</td>
									<td>
										<a
											href="/user/{banner.user.number}"
											class="text-decoration-none">
											{banner.user.username}
										</a>
									</td>
								</tr>
							{/each}
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>

{#if $modal}
	<Modal {modal}>
		<div class="modal-header">
			<h1 class="h4 light-text">Banner #{bannerId}</h1>
			<button
				type="button"
				class="btn-close"
				on:click={() => modal.set(false)}
				data-bs-dismiss="modal"
				aria-label="Close" />
		</div>
		<div class="modal-body light-text">
			<form use:enhance method="POST">
				<input type="hidden" name="id" value={bannerId} />
				{#if form?.area == "modal"}
					<p
						class="col-12 mb-1 text-{form?.success
							? 'success'
							: 'danger'}">
						{form?.msg || ""}
					</p>
				{/if}
				<textarea
					name="bannerBody"
					bind:this={textarea}
					bind:value={bannerBody}
					id="bannerBody"
					class="form-control valid mb-3" />
				{#if newBannerBody.trim() != bannerBody.trim()}
					<div transition:fade class="d-grid gap-2">
						<button
							value="updateBody"
							class="btn btn-success"
							name="action"
							id="saveBannerBody">
							Save Changes
						</button>
					</div>
				{/if}
			</form>
		</div>
	</Modal>
{/if}

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

	.btn-close
		filter: invert(1) grayscale(100%) brightness(200%)

</style>
