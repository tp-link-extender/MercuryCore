<script lang="ts">
	export let data

	let checked = false

	const moderationAction: { [k: string]: string } = {
		Warning: "Warning",
		Ban: "Ban",
		Termination: "Termination",
		AccountDeleted: "Account Deleted",
	}

	function formatDateDifference(date1: number, date2: number) {
		const diffInMilliseconds = Math.round(date2 - date1),
			millisecondsPerDay = 24 * 60 * 60 * 1000,
			diffInDays = Math.floor(diffInMilliseconds / millisecondsPerDay)

		if (diffInMilliseconds < 0) return "0 minute(s)"

		if (diffInDays >= 1) return diffInDays + " day(s)"

		const diffInHours = Math.floor(diffInMilliseconds / (60 * 60 * 1000)),
			diffInMinutes = Math.floor(
				(diffInMilliseconds % (60 * 60 * 1000)) / (60 * 1000)
			)
		if (diffInHours >= 1)
			// return diffInHours + " hour(s) " + diffInMinutes + " minute(s)"
			return `${diffInHours} hour(s) ${diffInMinutes} minute(s)`

		return `${diffInMinutes} minute(s)`
	}
</script>

<Head title={moderationAction[data.type]} />

<div class="container mt-12">
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
				the Mercury Terms of Service.
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
						Please make sure to follow the Mercury <a
							href="/terms"
							class="text-decoration-none">
							Terms of Service
						</a>
						to prevent further action to be taken on your account.
					</p>
					<p>
						You may reactivate your account by agreeing to our
						Terms of Service.
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
						Please make sure to follow the Mercury <a
							href="/terms"
							class="text-decoration-none">
							Terms of Service
						</a>
						to prevent further action to be taken on your account.
					</p>
					<p>
						You may reactivate your account after your ban ends in {formatDateDifference(
							Date.now(),
							new Date(data.timeEnds).getTime()
						)}
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

<style lang="stylus">
	containerMinWidth()
</style>
