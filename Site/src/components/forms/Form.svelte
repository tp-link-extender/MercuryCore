<script lang="ts">
	import { page } from "$app/state"
	import type { Snippet } from "svelte"
	import type { HTMLFormAttributes } from "svelte/elements"

	const {
		working = "Working...",
		submit = "Submit",
		inline = false,
		nopad = false, // Don't pad the icon on the submit button
		method = "POST",
		formData,
		children,
		...rest
	}: {
		working?: string
		submit?: string
		inline?: boolean
		nopad?: boolean // Don't pad the icon on the submit button
		method?: HTMLFormAttributes["method"]
		formData: import("sveltekit-superforms").SuperForm<any>
		children: Snippet
	} & HTMLFormAttributes = $props()

	const { errors, message, enhance, delayed } = formData

	// use:enh may not be used on forms that aren't method === "POST"
	const use = method === "POST" ? enhance : () => {}

	let other = $derived($errors.other || "")
</script>

<form use:use {method} {...rest}>
	<fieldset class={inline ? "input-group" : "pb-2"}>
		{@render children()}
		{#if submit}
			<button class={["btn btn-primary h-full", { nopad }]}>
				{@html /* ecks ess ess moment */ $delayed ? working : submit}
			</button>
		{/if}
	</fieldset>
	{#if other}
		<p class="text-red-500">
			{other}
		</p>
	{/if}
</form>

{#if $message}
	<p
		class={{
			"mb-0": inline,
			"text-emerald-600": page.status === 200,
			"text-red-500": page.status >= 400
		}}>
		{$message}
	</p>
{/if}

<style>
	button:not(.nopad) {
		& :global(fa) {
			padding-right: 0.5rem;
		}
	}
</style>
