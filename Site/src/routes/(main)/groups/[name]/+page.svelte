<script lang="ts">
	import { enhance } from "$app/forms"
	import Head from "$components/Head.svelte"
	import User from "$components/User.svelte"

	const { data } = $props()
</script>

<Head name={data.siteName} title={data.name} />

<div class="ctnr max-w-240">
	<div class="px-6">
		<h1>{data.name}</h1>
		<p class="flex">
			<b class="pr-2">by</b>
			<User user={data.owner} full thin bg="accent" size="1.5rem" />
		</p>
		<div class="flex pt-6 justify-between">
			<a
				href="/groups/{data.name}/members"
				class="light-text text-center no-underline pl-6">
				Members
				<h3 class="light-text">
					{data.memberCount}
				</h3>
			</a>
			<form
				use:enhance
				method="POST"
				action="?/{data.in ? 'leave' : 'join'}"
				class="self-center">
				<button class="btn {data.in ? 'btn-danger' : 'btn-success'}">
					{#if data.in}
						Leave
					{:else}
						Join
					{/if}
				</button>
			</form>
		</div>
	</div>
</div>
