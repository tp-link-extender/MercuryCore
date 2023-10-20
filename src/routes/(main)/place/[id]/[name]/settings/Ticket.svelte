<script lang="ts">
	import { page } from "$app/stores"
	import { superForm } from "sveltekit-superforms/client"

	export let data: import("./$types").PageData

	const { message, enhance, delayed } = superForm(data.ticketForm, {
		taintedMessage: false,
	})
</script>

<form use:enhance method="POST" class="col-lg-8" action="?a=ticket&tab=Network">
	<fieldset class="row pb-4">
		<label for="ticket" class="col-md-3 text-md-right">Server Ticket</label>
		<div class="col-md-9">
			<div class="input-group">
				<input
					id="ticket"
					required
					value={data.serverTicket}
					class="form-control valid"
					disabled />
				<button
					class="btn btn-{$message && $page.status == 200
						? 'success'
						: 'primary'}">
					<i class="fas fa-rotate" />
					{#if $delayed}
						Working...
					{:else}
						{$message || "Regenerate"}
					{/if}
				</button>
			</div>
			<small class="grey-text">
				The server ticket is required to host servers on Mercury. You
				can regenerate the ticket at any time.
			</small>
		</div>
	</fieldset>
</form>
