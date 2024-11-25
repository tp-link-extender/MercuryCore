<script lang="ts">
	export let user: string
	export let url: string
</script>

<li class="rounded-2">
	<a class="btn text-red-500 pl-4 pr-0" href="/report?user={user}&url={url}">
		<fa fa-flag class="pr-2"></fa>
		Report abuse
	</a>
</li>
