<script lang="ts" generics="T extends RemoteFormInput">
	import type { Snippet } from "svelte"
	import type { HTMLFormAttributes } from "svelte/elements"
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

	// use:enhance may not be used on forms that aren't method === "post"
	// const use = method?.toLowerCase() === "post" ? enhance : () => {}
	let valid: string = $derived(formData.result?.success)
	let invalid: string = $derived(formData.result?.message)
	let pending = $derived(formData.pending > 0)
</script>

<form {...formData} {...rest}>
	<fieldset class={inline ? "input-group" : "pb-2"}>
		{@render children()}
		{#if submit}
			<button
				class={["btn btn-primary h-full", { nopad }]}
				disabled={pending}>
				{@html /* ecks ess ess moment */ pending ? working : submit}
			</button>
		{/if}
	</fieldset>
</form>

{#if valid}
	<p class={["text-emerald-600", { "mb-0": inline }]}>
		{valid}
	</p>
{/if}
{#if invalid}
	<p class={["text-red-500", { "mb-0": inline }]}>
		{invalid}
	</p>
{/if}

<style>
	button:not(.nopad) {
		& :global(fa) {
			padding-right: 0.5rem;
		}
	}
</style>
