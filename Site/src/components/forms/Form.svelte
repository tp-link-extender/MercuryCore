<script lang="ts">
	import { page } from "$app/stores"
	import Icon from "$components/Icon.svelte"
	import type { IconName } from "$components/icons/icons"

	export let submit: string | null = "Submit"
	export let submitIcon: IconName | "" = ""
	export let working = "Working..."
	export let workingIcon: IconName | "" = ""

	export let inline = false
	export let nopad = false // Don't pad the icon on the submit button

	export let method = "POST"

	export let formData: import("sveltekit-superforms").SuperForm<any> // boooo but nothing else works
	const { errors, message, enhance: enh, delayed } = formData

	// use:enh may not be used on forms that aren't method === "POST"
	const use = method === "POST" ? enh : () => {}

	$: other = $errors.other || ""
</script>

<form use:use {method} {...$$restProps}>
	<fieldset class={inline ? "input-group" : "pb-2"}>
		<slot />
		{#if submit !== null}
			<button class="btn btn-primary h-full" class:nopad>
				{#if $delayed}
					{#if workingIcon}
						<Icon icon={workingIcon} />
					{/if}
					{working}
				{:else}
					{#if submitIcon}
						<Icon icon={submitIcon} />
					{/if}
					{submit}
				{/if}
			</button>
		{/if}
	</fieldset>
	{#if other}
		<p class="text-red-5">
			{other}
		</p>
	{/if}
</form>

{#if $message}
	<p
		class={inline ? "mb-0" : ""}
		class:text-emerald-6={$page.status === 200}
		class:text-red-5={$page.status >= 400}>
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
