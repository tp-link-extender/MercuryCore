<script lang="ts">
	export let data

	let checked = false

	const moderationAction: { [k: string]: string } = {
		Warning: "Warning",
		Ban: "Ban",
		Termination: "Termination",
		AccountDeleted: "Account Deleted"
	}

	function formatDateDifference(date1: number, date2: number) {
		const diffInMilliseconds = Math.round(date2 - date1)
		const millisecondsPerDay = 86400e3
		const diffInDays = Math.floor(diffInMilliseconds / millisecondsPerDay)

		if (diffInMilliseconds < 0) return "0 minutes"

		if (diffInDays >= 1)
			return `${diffInDays} day${diffInDays > 1 ? "s" : ""}`

		const diffInHours = Math.floor(diffInMilliseconds / 3600e3)
		const diffInMinutes = Math.floor((diffInMilliseconds % 3600e3) / 60e3)

		if (diffInHours >= 1)
			return `${diffInHours} hour${
				diffInHours > 1 ? "s" : ""
			} ${diffInMinutes} minute${diffInMinutes > 1 ? "s" : ""}`

		return `${diffInMinutes} minute${diffInMinutes > 1 ? "s" : ""}`
	}
</script>

<Head title={moderationAction[data.type]} />

<div class="ctnr pt-8 max-w-200">
	<div class="card">
		<div class="card-body light-text">
			<h1>
				{moderationAction[data.type]}{moderationAction[data.type] ==
				"Ban"
					? `ned for ${formatDateDifference(
							Date.now(),
							new Date(data.timeEnds).getTime()
						)}`
					: ""}
			</h1>

			<p>
				Our moderators have determined that your behaviour has violated
				the Graphictoria Terms of Service.
			</p>

			<p>
				Reviewed: <code>{new Date(data.time)}</code>
			</p>

			<p>
				Moderator note: <code>{data.note}</code>
			</p>

			{#if moderationAction[data.type] == "Warning"}
				<form method="POST" use:enhance>
					<p class="mb-12">
						Please make sure to follow the Graphictoria <a
							href="/terms"
							class="no-underline">
							Terms of Service
						</a>
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
					<button class="btn btn-primary {checked ? '' : 'disabled'}">
						Reactivate
					</button>
				</form>
			{:else if moderationAction[data.type] == "Ban"}
				<form method="POST" use:enhance>
					<p class="mb-12">
						Please make sure to follow the Graphictoria <a
							href="/terms"
							class="no-underline">
							Terms of Service
						</a>
						to prevent further action to be taken on your account.
					</p>
					<p>
						You may reactivate your account after your ban ends in {formatDateDifference(
							Date.now(),
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
			{:else if moderationAction[data.type] == "Termination"}
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
