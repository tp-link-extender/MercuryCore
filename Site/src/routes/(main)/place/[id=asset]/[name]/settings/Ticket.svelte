<script lang="ts">
	import { successOf } from "#lib/validate.ts"
	import { ticketForm } from "./settings.remote.js"

	const { data }: { data: import("./$types").PageData } = $props()

	const ticketFormFor = ticketForm.for(data.id)
</script>

<form {...ticketFormFor}>
	<fieldset class="flex flex-wrap pb-4">
		<label for="ticket" class="w-full md:w-1/4">Server ticket</label>
		<div class="w-full md:w-3/4">
			<div class="input-group">
				<input
					id="ticket"
					required
					value={data.serverTicket}
					disabled />
				<button
					class="btn btn-{successOf(ticketFormFor.result)
						? 'success'
						: 'secondary'}">
					<fa fa-rotate></fa>
					{#if ticketFormFor.pending > 0}
						Working...
					{:else}
						{successOf(ticketFormFor.result) || "Regenerate"}
					{/if}
				</button>
			</div>
			<small class="formhelp">
				The server ticket is required to host servers on {data.siteName}.
				You can regenerate the ticket at any time.
			</small>
		</div>
	</fieldset>
</form>
