<script lang="ts">
	import { page } from "$app/stores"
	import superForm from "$lib/superForm"

	export let data: import("./$types").PageData
	const { message, enhance, delayed } = superForm(data.privatelinkForm)

	$: value = `https://banland.xyz/place/${data.id}/${data.name}?privateServer=${data.privateTicket}`

	let copiedSuccess = false
</script>

<form use:enhance method="POST" action="?/privatelink&tab=Privacy">
	<fieldset class="flex flex-wrap pb-2">
		<label for="privateLink" class="w-full md:w-1/4">
			Private Server Link
		</label>
		<div class="w-full md:w-3/4">
			<div class="input-group">
				<input id="privateLink" {value} disabled />
				<button
					on:click={() => {
						navigator.clipboard.writeText(value)
						copiedSuccess = true
						setTimeout(() => (copiedSuccess = false), 4000)
					}}
					class="btn btn-tertiary border-[--accent2] border-l-0"
					type="button">
					<fa fa-paste />
				</button>
				<button
					class="btn btn-{$message && $page.status == 200
						? 'success'
						: 'secondary'}">
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
					class="block text-yellow-5">
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
