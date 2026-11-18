<script lang="ts" generics="T extends RemoteFormInput">
	import type { Snippet } from "svelte"
	import type { HTMLFormAttributes } from "svelte/elements"
	import { type ClientForm, successOf } from "#lib/validate.ts"

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
		formData: Omit<ClientForm<T>, "for">
		children: Snippet
	} & HTMLFormAttributes = $props()

	// A handler can report a failure by returning an issue, which arrives as the result rather than in `fields`
	const failureOf = (result: unknown): string | undefined =>
		typeof result === "object" &&
		result !== null &&
		"message" in result &&
		typeof result.message === "string"
			? result.message
			: undefined

	let valid: string | undefined = $derived(successOf(formData.result))
	let failure: string | undefined = $derived(failureOf(formData.result))
	let issues = $derived(
		(formData.fields.allIssues() || []).filter(
			issue => issue.message !== failure
		)
	)
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
	<p class={["text-emerald-600", { "pb-0": inline }]}>
		{valid}
	</p>
{/if}
{#if failure}
	<p class={["text-red-500", { "pb-0": inline }]}>
		{failure}
	</p>
{/if}
{#each issues as issue}
	<p class={["text-red-500", { "pb-0": inline }]}>
		{issue.message}
	</p>
{/each}

<style>
	button:not(.nopad) {
		& :global(fa) {
			padding-right: 0.5rem;
		}
	}
</style>
