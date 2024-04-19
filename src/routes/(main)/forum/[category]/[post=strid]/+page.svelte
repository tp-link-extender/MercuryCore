<script lang="ts">
	import { enhance as enhance2 } from "$app/forms"
	import { superForm } from "sveltekit-superforms/client"
	import client from "$lib/realtime"

	export let data
	const { user } = data
	export let asComponent = false

	let post = writable(data.post) // this is the svelte 4 thing ever
	let replyingTo = writable("")
	const repliesCollapsed = writable({})
	const formData = superForm(data.form)

	export const snapshot = formData

	let refreshPost = 0
	let refreshReplies = 0

	function onPub(c: import("centrifuge").PublicationContext) {
		const newData = c.data as {
			id: string
			score: number
			action: "like" | "dislike" | "unlike" | "undislike"
			hash: number
		}

		// We can do this more normally since we aren't updating nested data
		if (newData.id !== $post.id) return

		$post.score = newData.score
		if (newData.hash !== data.user.realtimeHash) return

		switch (newData.action) {
			case "like":
				$post.likes = true
				$post.dislikes = false
				break
			case "dislike":
				$post.likes = false
				$post.dislikes = true
				break
			case "unlike":
			case "undislike":
				$post.likes = false
				$post.dislikes = false
		}
	}

	onMount(() => {
		client(data.user.realtimeToken)
			?.newSubscription(`forum:${$post.categoryName}`)
			.on("publication", onPub)
			.subscribe()
	})
</script>

<Head title={$post.title} />

<div class="ctnr max-w-280 light-text">
	{#if !asComponent}
		<!--
			Breadcrumbs can give confusing behaviour if linking
			to the same page the component is shallow-routed on
		-->
		<Breadcrumbs
			path={[
				["Forum", "/forum"],
				[$post.categoryName, `/forum/${$post.categoryName}`],
				[$post.title, ""]
			]} />
	{/if}

	{#key refreshPost}
		<div
			class="post card bg-darker flex-row overflow-hidden {$post.pinned
				? 'border-(solid 1px green-5)!'
				: ''}">
			<form
				use:enhance2={({ formData }) => {
					const action = formData.get("action")

					if (action == "like") {
						$post.likes = true

						if ($post.dislikes) $post.score++
						$post.dislikes = false
						$post.score++
					} else if (action == "dislike") {
						$post.dislikes = true

						if ($post.likes) $post.score--
						$post.likes = false
						$post.score--
					} else if (action == "unlike") {
						$post.likes = false
						$post.score--
					} else if (action == "undislike") {
						$post.dislikes = false
						$post.score++
					}

					return () => {}
				}}
				class="bg-a p-1"
				method="POST"
				action="?/like&id={$post.id}">
				<div class="flex flex-col">
					<button
						name="action"
						value={$post.likes ? "unlike" : "like"}
						aria-label={$post.likes ? "Unlike" : "Like"}
						class="btn p-1">
						<i
							class="fa{$post.likes
								? ' text-emerald-6 hover:text-emerald-3'
								: 'r text-neutral-5 hover:text-neutral-3'}
						fa-thumbs-up transition text-lg" />
					</button>
					<span
						class="py-2 text-center {$post.likes
							? 'text-emerald-6 font-bold'
							: $post.dislikes
								? 'text-red-5 font-bold'
								: ''}">
						{$post.score}
					</span>
					<button
						name="action"
						value={$post.dislikes ? "undislike" : "dislike"}
						aria-label={$post.dislikes ? "Undislike" : "Dislike"}
						class="btn p-1">
						<i
							class="fa{$post.dislikes
								? ' text-red-5 hover:text-red-3'
								: 'r text-neutral-5 hover:text-neutral-3'}
						fa-thumbs-down transition text-lg" />
					</button>
				</div>
			</form>
			<div class="p-4 pl-6 no-underline light-text w-full">
				<span class="flex justify-between">
					<div class="flex">
						<User user={$post.author} full />
						<i class="pl-4 self-center">
							{new Date($post.posted).toLocaleString()}
						</i>
					</div>
					<span>
						{#if user.permissionLevel >= 4}
							<PinButton
								refresh={() => refreshPost++}
								id={$post.id}
								pinned={$post.pinned}
								post />
						{/if}
						<ReportButton
							user={$post.author.username}
							url="/forum/{$post.categoryName}/{$post.id}" />
					</span>
				</span>
				<h2 class="text-xl pt-2">
					{$post.title}
				</h2>
				<p class="break-all">
					{$post.content[0].text || ""}
				</p>
			</div>
		</div>
	{/key}

	<PostReply {formData} />

	{#if $post.replies.length > 0}
		{#key refreshReplies}
			{#each $post.replies as reply, num}
				<ForumReply
					{user}
					{reply}
					{num}
					{replyingTo}
					categoryName={$post.categoryName}
					postId={$post.id}
					postAuthorName={$post.author.username}
					{repliesCollapsed}
					topLevel={false}
					pinnable
					refreshReplies={() => refreshReplies++} />
			{/each}
		{/key}
	{:else}
		<h3 class="text-center pt-6">
			No replies yet. Be the first to post one!
		</h3>
	{/if}
</div>

<style lang="stylus">
	.post
		border 1px solid var(--accent2)
</style>
