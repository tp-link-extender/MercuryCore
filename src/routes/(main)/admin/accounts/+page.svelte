<script lang="ts">
	import { page } from "$app/stores"
	import { superForm } from "sveltekit-superforms/client"

	export let data
	const {
		form,
		errors,
		message,
		constraints,
		enhance,
		delayed,
		capture,
		restore,
	} = superForm(data.form, {
		taintedMessage: false,
	})

	export const snapshot = { capture, restore }

	let tabData = TabData(data.url, ["Reset User Password"])
</script>

<Head title="Accounts - Admin" />

<div class="container py-6">
	<h1 class="light-text mb-0">Admin - Accounts</h1>
	<a href="/admin" class="text-decoration-none">
		<i class="fas fa-caret-left" />
		Back to panel
	</a>
	<div class="row mt-6">
		<div class="col-lg-2 col-md-3 mb-6">
			<TabNav bind:tabData vertical />
		</div>
		<div class="col-lg-10 col-md-9">
			<Tab {tabData}>
				<form use:enhance method="POST" action="?/resetPassword">
					<fieldset>
						<div class="row light-text mb-4">
							<label for="username" class="col-md-3">
								Username
							</label>
							<div class="col-md-8">
								<input
									bind:value={$form.username}
									{...$constraints.username}
									name="username"
									id="username"
									class="form-control {$errors.username
										? 'is-in'
										: ''}valid" />
								<p class="col-12 mb-4 text-danger">
									{$errors.username || ""}
								</p>
							</div>
						</div>
						<div class="row light-text mb-4">
							<label for="password" class="col-md-3">
								New password
							</label>
							<div class="col-md-8">
								<input
									bind:value={$form.password}
									{...$constraints.password}
									name="password"
									id="password"
									class="form-control {$errors.password
										? 'is-in'
										: ''}valid" />
								<p class="col-12 mb-4 text-danger">
									{$errors.password || ""}
								</p>
							</div>
						</div>
						<button class="btn btn-success">
							{#if $delayed}
								Working...
							{:else}
								Reset
							{/if}
						</button>
					</fieldset>
				</form>
				<p
					class:text-success={$page.status == 200}
					class:text-danger={$page.status >= 400}>
					{$message || ""}
				</p>
			</Tab>
		</div>
	</div>
</div>
