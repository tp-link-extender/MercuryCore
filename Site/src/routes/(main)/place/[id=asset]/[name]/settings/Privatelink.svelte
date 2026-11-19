<script lang="ts">
	import fade from "#lib/fade.ts"
	import { successOf } from "#lib/validate.ts"
	import { privatelinkForm } from "./settings.remote.js"

	const { data }: { data: import("./$types").PageData } = $props()

	const privatelinkFormFor = privatelinkForm.for(data.id)

	let value = $derived(
		encodeURI(
			`https://${data.domain}/place/${data.id}/${data.slug}?privateServer=${data.privateTicket}`
		)
	)

	let copiedSuccess = $state(false)
</script>

<form {...privatelinkFormFor}>
	<fieldset class="flex flex-wrap pb-2">
		<label for="privateLink" class="w-full md:w-1/4">
			Private server link
		</label>
		<div class="w-full md:w-3/4">
			<div class="input-group">
				<input id="privateLink" {value} disabled />
				<button
					type="button"
					onclick={() => {
						navigator.clipboard.writeText(value)
						copiedSuccess = true
						setTimeout(() => (copiedSuccess = false), 4000)
					}}
					class="btn btn-tertiary border-[--accent2] border-l-0"
					aria-label="Copy link to clipboard">
					<fa fa-copy></fa>
				</button>
				<button
					class="btn btn-{successOf(privatelinkFormFor.result)
						? 'success'
						: 'secondary'}">
					<fa fa-rotate></fa>
					{#if privatelinkFormFor.pending > 0}
						Working...
					{:else}
						{successOf(privatelinkFormFor.result) || "Regenerate"}
					{/if}
				</button>
			</div>
			{#if copiedSuccess}
				<small
					id="copiedSuccess"
					transition:fade
					class="block text-yellow-500">
					Successfully copied link to clipboard
				</small>
			{/if}

			<small class="formhelp">
				This private server link will allow users to join your server.
				Your server (if private) cannot be accessed by other players
				without this link.
			</small>
		</div>
	</fieldset>
</form>
