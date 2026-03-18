<script lang="ts" generics="T extends object">
	import type { Snippet } from "svelte"
	import type { HTMLFormAttributes } from "svelte/elements"
	import { page } from "$app/state"
	import type { ClientForm } from "$lib/validate"

	const {
		working = "Working...",
		submit = "Submit",
		inline = false,
		nopad = false, // Don't pad the icon on the submit button
		// method = "post",
		formData,
		children,
		...rest
	}: {
		working?: string
		submit?: string
		inline?: boolean
		nopad?: boolean // Don't pad the icon on the submit button
		// method?: HTMLFormAttributes["method"]
		formData: ClientForm<T>
		children: Snippet
	} & HTMLFormAttributes = $props()

	let { errors, message, enhance, delayed, valid } = $derived(formData)

	// use:enhance may not be used on forms that aren't method === "post"
	// const use = method?.toLowerCase() === "post" ? enhance : () => {}

	let other = $derived(errors.other || "")
</script>

<form use:enhance method="post" {...rest}>
	<fieldset class={inline ? "input-group" : "pb-2"}>
		{@render children()}
		{#if submit}
			<button class={["btn btn-primary h-full", { nopad }]}>
				{@html /* ecks ess ess moment */ delayed ? working : submit}
			</button>
		{/if}
	</fieldset>
	{#if other}
		<p class="text-red-500">
			{other}
		</p>
	{/if}
</form>

{#if message}
	<p
		class={[
			valid ? "text-emerald-600" : "text-red-500",
			{
				"mb-0": inline,
				"text-emerald-600": valid,
				"text-red-500": page.status >= 400
			}
		]}>
		{message}
	</p>
{/if}

<style>
	button:not(.nopad) {
		& :global(fa) {
			padding-right: 0.5rem;
		}
	}
</style>
