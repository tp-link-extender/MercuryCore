<script lang="ts">
	import { basicSetup, EditorView } from "codemirror"
	import { keymap } from "@codemirror/view"
	import { indentWithTab } from "@codemirror/commands"
	// import { HighlightStyle, syntaxHighlighting } from "@codemirror/language"
	import { css } from "@codemirror/lang-css"
	import type { SuperForm } from "sveltekit-superforms"

	let code: HTMLDivElement

	// const theme = HighlightStyle.define([])

	export let formData: SuperForm<any>
	const { form, errors, constraints } = formData

	function createEditor() {
		new EditorView({
			doc: $form.css,
			parent: code,
			extensions: [
				basicSetup,
				keymap.of([indentWithTab]),
				css()
				// syntaxHighlighting(theme),
			]
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
			<small class="grey-text">
				{help}
			</small>
		{/if}

		<small class="pb-4 text-red-5">
			{$errors[name] || ""}
		</small>
	</div>
</div>

<style lang="stylus">
	:global(.cm-editor)
		// set height to --rows
		height calc(var(--rows) * 1.166rem)
		// increase character tracknig
		letter-spacing 0.4px

	:global(.cm-cursor)
		border-left 1px solid white !important
	:global(.cm-gutters)
		background var(--darker) !important
		border-right 1px solid var(--accent3) !important
		border-radius var(--rounding) 0 0 var(--rounding)
	:global(.cm-activeLineGutter)
		background var(--accent) !important
	:global(.cm-activeLine)
		background #fff2 !important
	:global(.cm-selectionBackground)
		background var(--mainaccent) !important
	:global(.cm-tooltip)
		background var(--background) !important
	:global(.cm-foldPlaceholder)
		background var(--accent3) !important
		border 1px solid var(--grey-text) !important

	// bad syntax highlighting fixes
	:global(.ͼb)
		// var(), %
		color hsl(hue - 60 100% 70%)
	:global(.ͼc)
		// id (#test)
		color hsl(hue + 20 100% 70%)
	:global(.ͼd)
		// number (123)
		color hsl(hue - 20 100% 70%)
	:global(.ͼe)
		// string ("test")
		color hsl(hue + 60 100% 60%)
	:global(.ͼi)
		// element name (div)
		color hsl(hue 100% 80%)
	:global(.ͼj)
		// property (.test)
		color hsl(hue - 40 100% 80%)
</style>
