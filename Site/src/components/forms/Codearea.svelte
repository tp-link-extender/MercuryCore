<script lang="ts">
	import NoScript from "$components/NoScript.svelte"
	import YesScript from "$components/YesScript.svelte"
	import { indentWithTab } from "@codemirror/commands"
	import { css } from "@codemirror/lang-css"
	import { keymap } from "@codemirror/view"
	import { EditorView, basicSetup } from "codemirror"
	import { onMount } from "svelte"

	let code: HTMLDivElement

	export let formData: import("sveltekit-superforms").SuperForm<any>
	const { form, errors, constraints } = formData

	function createEditor() {
		new EditorView({
			doc: $form.css,
			parent: code,
			extensions: [basicSetup, keymap.of([indentWithTab]), css()]
		})
	}
	$: code && createEditor()

	const update = () => {
		$form.css = Array.from(document.getElementsByClassName("cm-line"))
			.map(l => l.textContent)
			.join("\n")
	}

	// GOOD ENOUGH.
	onMount(() =>
		document.addEventListener("keydown", () => {
			update()
			// update 100ms later as well, just for kicks (sometimes the last character doesn't get saved)
			setTimeout(update, 100)
		})
	)

	export let name: string
	export let label = ""
	export let help = ""
	export let placeholder = ""
	export let rows = 3
</script>

<div class="flex flex-wrap pb-8">
	{#if label}
		<label for={name} class="w-full md:w-1/4">
			{label}
		</label>
	{/if}
	<div class="w-full {label ? 'md:w-3/4' : ''}">
		<NoScript>
			<!-- fallback to standard textarea -->
			<textarea
				{...$$restProps}
				bind:value={$form[name]}
				{...$constraints[name]}
				{name}
				id={name}
				{rows}
				placeholder={placeholder || null}
				class:is-invalid={$errors[name]} />
		</NoScript>
		<YesScript>
			<textarea class="hidden" {name} id={name} value={$form.css} />
			<div bind:this={code} style="--rows: {rows}"></div>
		</YesScript>

		{#if help}
			<small class="formhelp">
				{help}
			</small>
		{/if}

		<small class="pb-4 text-red-500">
			{$errors[name] || ""}
		</small>
	</div>
</div>

<style>
	:global(.cm-editor) {
		/* set height to --rows */
		height: calc(var(--rows) * 1.166rem);
		/* increase character tracknig */
		letter-spacing: 0.4px;
	}

	:global(.cm-cursor) {
		border-left: 1px solid #fff !important;
	}
	:global(.cm-gutters) {
		background: var(--darker) !important;
		border-right: 1px solid var(--accent3) !important;
		border-radius: var(--rounding) 0 0 var(--rounding);
	}
	:global(.cm-activeLineGutter) {
		background: var(--accent) !important;
	}
	:global(.cm-activeLine) {
		background: rgba(255, 255, 255, 0.133) !important;
	}
	:global(.cm-selectionBackground) {
		background: var(--mainaccent) !important;
	}
	:global(.cm-tooltip) {
		background: var(--background) !important;
	}
	:global(.cm-foldPlaceholder) {
		background: var(--accent3) !important;
		border: 1px solid var(--grey-text) !important;
	}

	/* bad syntax highlighting fixes */
	:global(.ͼb) {
		/* var(), % */
		color: hsl(calc(var(--hue) - 60) 100 70);
	}
	:global(.ͼc) {
		/* id (#test) */
		color: hsl(calc(var(--hue) + 20) 100 70);
	}
	:global(.ͼd) {
		/* number (123) */
		color: hsl(calc(var(--hue) - 20) 100 70);
	}
	:global(.ͼe) {
		/* string ("test") */
		color: hsl(calc(var(--hue) + 60) 100 60);
	}
	:global(.ͼi) {
		/* element name (div) */
		color: hsl(var(--hue) 100 80);
	}
	:global(.ͼj) {
		/* property (.test) */
		color: hsl(calc(var(--hue) - 40) 100 80);
	}
</style>
