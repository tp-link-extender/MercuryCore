<script lang="ts">
	import { createAccordion } from "@melt-ui/svelte"
	import { applyAction, enhance } from "$app/forms"
	import { invalidateAll } from "$app/navigation"
	import Accordion from "$components/Accordion.svelte"
	import AccordionItem from "$components/AccordionItem.svelte"
	import Head from "$components/Head.svelte"
	import ReportButton from "$components/ReportButton.svelte"
	import User from "$components/User.svelte"
	import fade from "$lib/fade"
	import permissionLevels from "$lib/permissionLevels"
	import Interactions from "./Interactions.svelte"
	import ProfilePlace from "./ProfilePlace.svelte"

	const { data, form } = $props()

	const { user } = data

	let perms = $state(permissionLevels(data.permissionLevel))
	$effect(() => {
		perms = permissionLevels(data.permissionLevel)
	})

	// (for unocss)
	// fa-user fa-check fa-hammer fa-shield-alt fa-scale-balanced

	let regenerating = $state(false)

	const enhanceRegen: import("./$types").SubmitFunction = () => {
		regenerating = true
		return async ({ result }) => {
			if (result.type === "success") await invalidateAll()
			await applyAction(result)
			regenerating = false
		}
	}

	let accordion = $state(createAccordion()) // Sometimes undefined for some probably crazy reason
</script>

<Head name={data.siteName} title={data.username} />

<div class="ctnr max-w-240">
	<div class="card bg-darker p-4 lg:p-6">
		<div class="flex">
			<span class="<lg:hidden pr-6">
				<User
					user={data}
					size="7rem"
					bg="accent"
					image
					rerender={{ form, regenerating }} />
			</span>
			<span class="lg:hidden pr-4">
				<User
					user={data}
					size="6rem"
					bg="accent"
					image
					rerender={{ form, regenerating }} />
			</span>
			<div class="w-full">
				<div class="flex mb-2 justify-between">
					<div class="flex items-center">
						<h1 class="inline pr-4 mb-0">
							{data.username}
						</h1>
						{#if data.follower}
							<span class="grey-text bg-a px-2 rounded">
								Follows you
							</span>
						{/if}
					</div>
					<div class="flex self-start">
						<b style="color: {perms[0]}">
							<fa class="{perms[1]} pr-1"></fa>
							{perms[2]}
						</b>
					</div>
				</div>
				<div id="interactions" class="flex justify-between">
					<div class="flex gap-6">
						<a
							href="/user/{data.username}/friends"
							class="light-text text-center no-underline">
							Friends
							<h2>
								{data.friendCount}
							</h2>
						</a>
						<a
							href="/user/{data.username}/followers"
							class="light-text text-center no-underline">
							Followers
							<h2>
								{data.followerCount}
							</h2>
						</a>
						<a
							href="/user/{data.username}/following"
							class="light-text text-center no-underline">
							Following
							<h2>
								{data.followingCount}
							</h2>
						</a>
					</div>

					{#if data.username !== user.username}
						<span class="<lg:hidden">
							<Interactions {data} />
						</span>
					{/if}
				</div>
				{#if data.username !== user.username}
					<span class="dropdown float-end">
						<fa fa-ellipsis-h class="dropdown-ellipsis"></fa>
						<div class="dropdown-content pt-2">
							<ul class="p-2 rounded-3">
								<ReportButton
									user={data.username}
									url="/user/{data.username}" />
							</ul>
						</div>
					</span>
				{/if}
			</div>
		</div>
		{#if data.username !== user.username}
			<span class="lg:hidden flex justify-between items-end pt-2">
				<Interactions {data} />
				<span class="dropdown float-end">
					<fa fa-ellipsis-h class="dropdown-ellipsis"></fa>
					<div class="dropdown-content pt-2">
						<ul class="p-2 rounded-3">
							<ReportButton
								user={data.username}
								url="/user/{data.username}" />
						</ul>
					</div>
				</span>
			</span>
		{/if}
	</div>
	<div class="sm:grid grid-cols-2 gap-4">
		<div>
			{#if data.description && data.description.text}
				<div class="pt-6">
					<div class="flex justify-between">
						<h2>Description</h2>
						{#if data.username === user.username}
							<a
								href="/settings"
								class="btn light-text text-lg p-0 px-2"
								aria-label="Edit description">
								<fa fa-pencil></fa>
							</a>
						{/if}
					</div>
					<p class="pl-2 pt-4 whitespace-pre-line">
						{data.description.text}
					</p>
				</div>
			{:else if data.username === user.username}
				<p class="pt-6 text-center">
					Add a description in
					<a href="/settings">Settings</a>
					to tell others about yourself! It will display here.
				</p>
			{/if}
			<div class="pt-6">
				<h2>Avatar</h2>
				<div class="card bg-darker p-4">
					<img
						class={[
							"transition-opacity duration-300",
							{ "opacity-50": regenerating }
						]}
						src={form?.avatarBody ||
							`/api/avatar/${data.username}-body`}
						alt={data.username} />
					{#if user?.permissionLevel >= 5}
						<form
							use:enhance={enhanceRegen}
							in:fade
							method="post"
							action="?/rerender"
							class="absolute text-right end-0 pr-4">
							<button class="btn btn-sm btn-tertiary">
								<fa fa-arrows-rotate></fa>
								Rerender
							</button>
							<small class="text-red-500 block">
								{form?.msg || ""}
							</small>
						</form>
					{/if}
				</div>
			</div>
		</div>
		<div>
			{#if data.places.length > 0}
				<div class="pt-6">
					<h2>Creations</h2>
					<Accordion {accordion} class="flex flex-col gap-2">
						{#each accordion ? data.places : [] as place}
							<AccordionItem {accordion} title={place.name}>
								<ProfilePlace {place} />
							</AccordionItem>
						{/each}
					</Accordion>
				</div>
			{/if}
		</div>
		{#if data.groupsOwned.length > 0}
			<div class="pt-6">
				<div class="pt-6">
					<h2>Groups owned</h2>
					{#each data.groupsOwned as group, num}
						<div class="py-2">
							<a
								in:fade={{
									num,
									total: data.groupsOwned.length
								}}
								class="card bg-darker no-underline"
								href="/groups/{group.name}">
								<div class="p-2">
									<span class="float-start">
										{group.name}
									</span>
									<span class="float-end">
										<fa fa-user class="opacity-75"></fa>
										{group.memberCount}
									</span>
								</div>
							</a>
						</div>
					{/each}
				</div>
			</div>
		{/if}
		{#if data.groups.length > 0}
			<div class="pt-6">
				<div class="pt-6">
					<h2>Groups in</h2>
					{#each data.groups as group, num}
						<div class="py-2">
							<a
								in:fade={{ num, total: data.groups.length }}
								class="card bg-darker no-underline"
								href="/groups/{group.name}">
								<div class="p-2">
									<span class="float-start">
										{group.name}
									</span>
									<span class="float-end">
										<fa fa-user class="opacity-75"></fa>
										{group.memberCount}
									</span>
								</div>
							</a>
						</div>
					{/each}
				</div>
			</div>
		{/if}
		<div class="col-span-2">
			{#if data.posts.length > 0}
				<h2 class="pt-6">Latest feed posts</h2>
				<div class="grid md:grid-cols-2 gap-4">
					{#each data.posts.sort((a, b) => b.created.getTime() - a.created.getTime()) as status, num}
						<div
							in:fade={{ num, total: data.posts.length, max: 9 }}
							class="card bg-darker p-3 h-full">
							<div id="user" class="flex pb-2 justify-between">
								<User
									user={data}
									size="2rem"
									full
									image
									bg="accent" />
								<span class="italic flex-end">
									{status.created.toLocaleString()}
								</span>
							</div>
							<p class="text-start mb-0">
								{status.content[0].text}
							</p>
						</div>
					{/each}
				</div>
			{/if}
		</div>
	</div>
</div>
