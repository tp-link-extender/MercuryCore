<script lang="ts">
	const {
		user,
		url
	}: {
		user: string
		url: string
	} = $props()

	const href = $derived(
		`/report?user=${encodeURIComponent(user)}&url=${encodeURIComponent(url)}`
	)
</script>

<li class="rounded-2">
	<a class="btn text-red-500 pl-4 pr-0" {href}>
		<fa fa-flag class="pr-2"></fa>
		Report abuse
	</a>
</li>
