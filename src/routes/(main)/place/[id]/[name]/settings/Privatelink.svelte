<script lang="ts">
	import { page } from "$app/stores"
	import { superForm } from "sveltekit-superforms/client"

	export let data: import("./$types").PageData

	const { message, enhance, delayed } = superForm(data.privatelinkForm, {
		taintedMessage: false,
	})

	$: value = `https://banland.xyz/place/${data.id}/${data.name}?privateServer=${data.privateTicket}`

	let copiedSuccess = false
</script>

<form
	use:enhance
	method="POST"
	class="col-lg-8"
	action="?/privatelink&tab=Privacy">
	<fieldset class="row">
		<label for="privateLink" class="col-md-3 text-md-right">
			Private Server Link
		</label>
		<div class="col-md-9">
			<div class="input-group">
				<input
					id="privateLink"
					{value}
					class="form-control valid"
					disabled />
				<button
					on:click={() => {
						navigator.clipboard.writeText(value)
						copiedSuccess = true
						setTimeout(() => (copiedSuccess = false), 4000)
					}}
					class="btn btn-info"
					type="button">
					<fa fa-paste />
				</button>
				<button
					class="btn btn-{$message && $page.status == 200
						? 'success'
						: 'primary'}">
					<fa fa-rotate />
					{#if $delayed}
						Working...
					{:else}
						{$message || "Regenerate"}
					{/if}
				</button>
			</div>
			{#if copiedSuccess}
				<small
					id="copiedSuccess"
					transition:fade
					class="block text-warning">
					Successfully copied link to clipboard
				</small>
			{/if}

			<small class="grey-text">
				This private server link will allow users to join your server.
				Your server (if private) cannot be accessed by other players
				without this link.
			</small>
		</div>
	</fieldset>
</form>
