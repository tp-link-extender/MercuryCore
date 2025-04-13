<script lang="ts">
	import { enhance } from "$app/forms"
	import Head from "$components/Head.svelte"

	let { data } = $props();

	let checked = $state(false)

	const moderationAction: { [k: string]: string } = {
		Warning: "Warning",
		Ban: "Ban",
		Termination: "Termination",
		AccountDeleted: "Account Deleted"
	}
	const actionType = moderationAction[data.type]

	const s = (n: number) => (n > 1 ? "s" : "")
	function formatDateDiff(date: number) {
		const millisDiff = Math.round(date - Date.now())
		if (millisDiff < 0) return "0 minutes" // lmao

		const daysDiff = Math.floor(millisDiff / 86400e3)
		if (daysDiff >= 1) return `${daysDiff} day${s(daysDiff)}`

		const hoursDiff = Math.floor(millisDiff / 3600e3)
		const minsDiff = Math.floor((millisDiff % 3600e3) / 60e3)
		const mins = `${minsDiff} minute${s(minsDiff)}`
		if (hoursDiff < 1) return mins
		return `${hoursDiff} hour${s(hoursDiff)} ${mins}`
	}
</script>

<Head name={data.siteName} title={actionType} />

<div class="ctnr pt-8 max-w-200">
	<div class="card">
		<div class="light-text p-4">
			<h1>
				{actionType == "Ban"
					? `${actionType}ned for ${formatDateDiff(
							new Date(data.timeEnds).getTime()
						)}`
					: actionType}
			</h1>

			<p>
				Our moderators have determined that your behaviour has violated
				the {data.siteName} Terms of Service.
			</p>

			<p>
				Reviewed: <code>{new Date(data.time)}</code>
			</p>

			<p>
				Moderator note: <code>{data.note}</code>
			</p>

			{#if actionType === "Warning"}
				<form use:enhance method="POST">
					<p class="mb-12">
						Please make sure to follow the {data.siteName} Terms of Service
						to prevent further action to be taken on your account.
					</p>
					<p>
						You may reactivate your account by agreeing to our Terms
						of Service.
					</p>
					<div class="form-check mb-2">
						<input
							class="form-check-input"
							type="checkbox"
							bind:checked
							id="agree" />
						<label class="form-check-label" for="agree">
							I understand
						</label>
					</div>
					<button class="btn btn-primary" class:disabled={!checked}>
						Reactivate
					</button>
				</form>
			{:else if actionType === "Ban"}
				<form use:enhance method="POST">
					<p class="mb-12">
						Please make sure to follow the {data.siteName} Terms of Service
						to prevent further action to be taken on your account.
					</p>
					<p>
						You may reactivate your account after your ban ends in {formatDateDiff(
							new Date(data.timeEnds).getTime()
						)}.
					</p>
					<button
						class="btn btn-primary {new Date(
							data.timeEnds
						).getTime() < Date.now()
							? ''
							: 'disabled'}">
						Reactivate
					</button>
				</form>
			{:else if actionType === "Termination"}
				<p>You may not reactivate your account.</p>
			{:else}
				<p>
					Your account has been deleted, but you may create another in
					the future.
				</p>
			{/if}
		</div>
	</div>
</div>
