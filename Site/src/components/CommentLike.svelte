<script lang="ts">
	import type { ClassValue } from "svelte/elements"
	import { enhance } from "$app/forms"
	import type { Scored } from "$lib/like"

	const {
		comment,
		likeEnhance,
		small = false,
		class: class_ = ""
	}: {
		comment: Scored & { id: string }
		likeEnhance: import("@sveltejs/kit").SubmitFunction
		small?: boolean
		class?: ClassValue
	} = $props()

	const smallClass = small ? "size-6 p-0" : "p-1"
</script>

<form
	use:enhance={likeEnhance}
	method="post"
	action="/api/like/comment/{comment.id}"
	class={class_}>
	<span class={{ "flex flex-col": !small }}>
		<button
			name="action"
			value={comment.likes ? "unlike" : "like"}
			aria-label={comment.likes ? "Unlike" : "Like"}
			class={["btn", smallClass]}>
			<fa
				fa-thumbs-up
				class={[
					"transition",
					{ "text-lg": !small },
					comment.likes
						? "text-emerald-600 hover:text-emerald-300"
						: "text-neutral-600 hover:text-neutral-400"
				]}>
			</fa>
		</button>
		<span
			class={[
				"text-center",
				small ? "px-1" : "py-2",
				{
					"text-emerald-600 font-bold": comment.likes,
					"text-red-500 font-bold": comment.dislikes
				}
			]}>
			{comment.score}
		</span>
		<button
			name="action"
			value={comment.dislikes ? "undislike" : "dislike"}
			aria-label={comment.dislikes ? "Undislike" : "Dislike"}
			class={["btn", smallClass]}>
			<fa
				fa-thumbs-down
				class={[
					"transition",
					{ "text-lg": !small },
					comment.dislikes
						? "text-red-500 hover:text-red-300"
						: "text-neutral-600 hover:text-neutral-400"
				]}>
			</fa>
		</button>
	</span>
</form>
