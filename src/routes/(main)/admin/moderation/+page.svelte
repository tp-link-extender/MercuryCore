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

	const tomorrow = new Date(Date.now() + 86400000).toISOString().slice(0, 10)

	let tabData = TabData(data.url, ["Moderate User"])
</script>

<Head title="Moderate User - Admin" />

<div class="container py-4">
	<h1 class="light-text mb-0">Admin - Moderate User</h1>
	<a href="/admin" class="text-decoration-none">
		<i class="fas fa-caret-left" />
		Back to panel
	</a>
	<div class="row mt-4">
		<div class="col-lg-2 col-md-3 mb-4">
			<TabNav bind:tabData tabs />
		</div>
		<div class="col-lg-10 col-md-9">
			<Tab {tabData}>
				<form use:enhance method="POST" action="?/moderateUser">
					<fieldset>
						<div class="row">
							<label
								for="username"
								class="col-md-3 col-form-label light-text">
								Username
							</label>
							<div class="col-md-8">
								<input
									bind:value={$form.username}
									{...$constraints.username}
									type="text"
									name="username"
									id="username"
									class="form-control {$errors.username
										? 'is-in'
										: ''}valid" />
								<p class="col-12 text-danger">
									{$errors.username || ""}
								</p>
							</div>
						</div>
						<div class="row">
							<label
								for="action"
								class="col-md-3 col-form-label light-text">
								Action
							</label>
							<div class="col-md-8">
								<select
									bind:value={$form.action}
									{...$constraints.action}
									name="action"
									id="action"
									class="form-control light-text {$errors.action
										? 'is-in'
										: ''}valid">
									<option value="1" selected>Warning</option>
									<option value="2">Ban</option>
									<option value="3">Termination</option>
									<option value="4">Account Deletion</option>
									<option value="5">Unban</option>
								</select>
								<p class="col-12 text-danger">
									{$errors.action || ""}
								</p>
							</div>
						</div>
						{#if $form.action == 2}
							<div class="row" transition:fade>
								<label
									for="banDate"
									class="col-md-3 col-form-label light-text">
									Ban until
								</label>
								<div class="col-md-8">
									<input
										bind:value={$form.banDate}
										{...$constraints.banDate}
										type="date"
										name="banDate"
										id="banDate"
										min={tomorrow}
										required
										class="form-control {$errors.banDate
											? 'is-in'
											: ''}valid" />
									<p class="col-12 text-danger">
										{$errors.banDate || ""}
									</p>
								</div>
							</div>
						{/if}
						<div class="row">
							<label
								for="reason"
								class="col-md-3 col-form-label light-text">
								Reason
							</label>
							<div class="col-md-8">
								<textarea
									bind:value={$form.reason}
									{...$constraints.reason}
									name="reason"
									id="reason"
									class="form-control {$errors.reason
										? 'is-in'
										: ''}valid" />
								<p class="col-12 text-danger">
									{$errors.reason || ""}
								</p>
							</div>
						</div>
						<button class="btn btn-success mt-3">
							{#if $delayed}
								Working...
							{:else}
								Moderate
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
