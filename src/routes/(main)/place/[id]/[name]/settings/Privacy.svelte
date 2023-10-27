<script lang="ts">
	import { page } from "$app/stores"
	import { superForm } from "sveltekit-superforms/client"

	export let data: import("./$types").PageData

	const { form, message, enhance, delayed } = superForm(data.privacyForm, {
		taintedMessage: false,
	})

	if (data.privateServer) $form.privateServer = data.privateServer
</script>

<form
	use:enhance
	method="POST"
	class="col-lg-8"
	action="?a=privacy&tab=Privacy">
	<fieldset class="pb-6">
		<div class="row">
			<label for="privacy" class="col-md-3 text-md-right">
				Private Server
			</label>
			<div class="col-md-9">
				<input
					bind:checked={$form.privateServer}
					class="form-check-input valid"
					name="privateServer"
					type="checkbox"
					id="privateServer" />
			</div>
		</div>
	</fieldset>
	<button class="btn btn-success">
		{#if $delayed}
			Working...
		{:else}
			Save changes
		{/if}
	</button>
	<p
		class:text-success={$page.status == 200}
		class:text-danger={$page.status >= 400}>
		{$message || ""}
	</p>
</form>
