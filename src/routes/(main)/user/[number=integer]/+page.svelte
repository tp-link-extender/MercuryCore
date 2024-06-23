<script lang="ts">
	import { applyAction, enhance } from "$app/forms"
	import { invalidateAll } from "$app/navigation"
	import Accordion from "$lib/components/Accordion.svelte"
	import AccordionItem from "$lib/components/AccordionItem.svelte"
	import Head from "$lib/components/Head.svelte"
	import ReportButton from "$lib/components/ReportButton.svelte"
	import User from "$lib/components/User.svelte"
	import fade from "$lib/fade"
	import Interactions from "./Interactions.svelte"
	import ProfilePlace from "./ProfilePlace.svelte"

	const permissions = [
		[], // index from 1
		["white", "fa-user", "User"],
		["aqua", "fa-check", "Verified"],
		["violet", "fa-hammer", "Catalog Manager"],
		["orange", "fa-shield-alt", "Moderator"],
		["crimson", "fa-scale-balanced", "Administrator"]
	]

	export let data
	const { user } = data
	export let form // ghoofy ahh types

	let regenerating = false

	const enhanceRegen: import("./$types").SubmitFunction = () => {
		regenerating = true
		return async ({ result }) => {
			if (result.type === "success") await invalidateAll()
			await applyAction(result)
			regenerating = false
		}
	}

	let accordion: import("@melt-ui/svelte").Accordion // Sometimes undefined for some probably crazy reason
</script>

<Head title={data.username} />

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
						<b
							style="color: {permissions[
								data.permissionLevel
							][0]}">
							<fa
								class="{permissions[
									data.permissionLevel
								][1]} pr-1" />
							{permissions[data.permissionLevel][2]}
						</b>
					</div>
				</div>
				<div id="interactions" class="flex justify-between">
					<div class="flex gap-6">
						<a
							href="/user/{data.number}/friends"
							class="light-text text-center no-underline">
							Friends
							<h2>
								{data.friendCount}
							</h2>
						</a>
						<a
							href="/user/{data.number}/followers"
							class="light-text text-center no-underline">
							Followers
							<h2>
								{data.followerCount}
							</h2>
						</a>
						<a
							href="/user/{data.number}/following"
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
					<div class="float-right <lg:hidden">
						<ReportButton
							user={data.username}
							url="/user/{data.number}" />
					</div>
				{/if}
			</div>
		</div>
		{#if data.username !== user.username}
			<span class="lg:hidden flex justify-between items-end pt-2">
				<Interactions {data} />
				<ReportButton user={data.username} url="/user/{data.number}" />
			</span>
		{/if}
	</div>
	<div class="sm:grid grid-cols-2 gap-4">
		<div>
			{#if data.bio && data.bio.text}
				<div class="pt-6">
					<div class="flex justify-between">
						<h2>Bio</h2>
						{#if data.username === user.username}
							<a
								href="/settings"
								class="btn light-text text-lg p-0 px-2">
								<fa fa-pencil />
							</a>
						{/if}
					</div>
					<p class="pl-2">{data.bio.text}</p>
				</div>
			{:else if data.username === user.username}
				<div class="pt-6 text-center">
					Add a bio in
					<a href="/settings">Settings</a>
					to tell others about yourself! It will display here.
				</div>
			{/if}
			<div class="pt-6">
				<h2>Avatar</h2>
				<div class="card bg-darker card-body">
					<img
						class="transition-opacity duration-300"
						class:opacity-50={regenerating}
						src={form?.avatarBody ||
							`/api/avatar/${data.username}-body`}
						alt={data.username} />
					{#if user?.permissionLevel >= 5}
						<form
							use:enhance={enhanceRegen}
							method="POST"
							action="?/rerender"
							in:fade
							class="absolute text-right end-0 pr-4">
							<button class="btn btn-sm btn-tertiary">
								<fa fa-arrows-rotate />
								Rerender
							</button>
							<small class="text-red-5 block">
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
					<Accordion bind:accordion>
						<div class="flex flex-col gap-2">
							{#each accordion ? data.places : [] as place}
								<AccordionItem {accordion} title={place.name}>
									<ProfilePlace {place} />
								</AccordionItem>
							{/each}
						</div>
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
									<span class="float-right">
										<fa fa-user class="opacity-75" />
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
									<span class="float-right">
										<fa fa-user class="opacity-75" />
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
					{#each data.posts.sort((a, b) => new Date(b.posted).getTime() - new Date(a.posted).getTime()) as status, num}
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
									{new Date(status.posted).toLocaleString()}
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
