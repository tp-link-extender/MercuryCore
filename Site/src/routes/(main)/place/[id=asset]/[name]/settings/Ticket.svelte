<script lang="ts">
	import { superForm } from "sveltekit-superforms/client"
	import { page } from "$app/state"

	const { data }: { data: import("./$types").PageData } = $props()

	const { message, enhance, delayed } = superForm(data.ticketForm, {
		id: "ticket"
	})
</script>

<form use:enhance method="POST" action="?/ticket&tab=Network">
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
					class="btn btn-{$message && page.status === 200
						? 'success'
						: 'secondary'}">
					<fa fa-rotate></fa>
					{#if $delayed}
						Working...
					{:else}
						{$message || "Regenerate"}
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
