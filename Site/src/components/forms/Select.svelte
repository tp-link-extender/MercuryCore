<script lang="ts" generics="T extends RemoteFormInput">
	// could make forms based on a js object or something instead of components but concerns with forms that require more interactivity/customisation

	import { Select } from "melt/builders"
	import NoScript from "$components/NoScript.svelte"
	import YesScript from "$components/YesScript.svelte"
	import type { ClientForm, ExtractId } from "$lib/validate"

	const {
		name,
		label = "",
		help = "",
		disabled = false,
		// multiple = false, // messes up hugely if this is true, custom behaviour incoming
		// also messes up with superforms cuz it only submits the last selected value
		options = [],
		selected,
		formData,
		...rest
	}: {
		name: ExtractId<T>
		label?: string
		help?: string
		disabled?: boolean
		// multiple?: boolean
		options: readonly string[]
		selected?: string
		formData: ClientForm<T>
	} = $props()

	let issues = $derived(formData.fields[name]?.issues() || [])

	// let dropdown = $state<HTMLElement>()

	let select = $derived(
		new Select<string>({
			value: selected

			// floatingConfig: {
			// 	onCompute: a => {
			// 		console.log(a)
			// 		a.floatingApply(dropdown)
			// 	}
			// }
		})
	)
</script>

<div class="flex flex-wrap pb-8">
	<label {...select.label} class="w-full md:w-1/4">
		{label}
	</label>
	<div class="w-full md:w-3/4">
		<NoScript>
			<!-- fallback to standard select (i don't *think* we need to bind here, and sometimes bugs) -->
			<select
				{...formData.fields[name].as("text")}
				{disabled}
				{...rest}
				name={name.toString()}
				id={name.toString()}>
				{#each options as opt}
					<option
						value={opt}
						selected={opt === (selected || select.value)}>
						{opt}
					</option>
				{/each}
			</select>
		</NoScript>
		<YesScript>
			<input
				type="hidden"
				{...formData.fields[name].as("text")}
				name={name.toString()}
				id={name.toString()}
				value={select.value || options[0]} />

			<button {...select.trigger} {disabled} class="fakeselect">
				{select.value || options[0] || "Select an option"}
			</button>
			<div {...select.content}>
				{#each options as opt}
					<button {...select.getOption(opt)} class="btn light-text">
						<fa
							fa-check
							class={["pr-2", { hidden: opt !== select.value }]}>
						</fa>
						{opt}
					</button>
				{/each}
			</div>
		</YesScript>

		{#if help}
			<small class="formhelp">
				{@html help}
			</small>
		{/if}

		{#each issues as issue}
			<small class="block text-red-500">
				{issue.message}
			</small>
		{/each}
	</div>
</div>
