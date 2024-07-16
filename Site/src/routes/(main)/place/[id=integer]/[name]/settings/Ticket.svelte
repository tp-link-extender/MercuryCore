<script lang="ts">
	import { page } from "$app/stores"
	import { superForm } from "sveltekit-superforms/client"

	export let data: import("./$types").PageData

	const {
		message,
		enhance: enh,
		delayed
	} = superForm(data.ticketForm, { id: "ticket" })
</script>

<form use:enh method="POST" action="?/ticket&tab=Network">
	<fieldset class="flex flex-wrap pb-4">
		<label for="ticket" class="w-full md:w-1/4 text-md-right">
			Server ticket
		</label>
		<div class="w-full md:w-3/4">
			<div class="input-group">
				<input
					id="ticket"
					required
					value={data.serverTicket}
					disabled />
				<button
					class="btn btn-{$message && $page.status === 200
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
			<small class="formhelp">
				The server ticket is required to host servers on Mercury. You
				can regenerate the ticket at any time.
			</small>
		</div>
	</fieldset>
</form>
