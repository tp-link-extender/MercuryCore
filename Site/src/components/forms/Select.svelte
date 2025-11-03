<script lang="ts">
	// could make forms based on a js object or something instead of components but concerns with forms that require more interactivity/customisation

	import { Select } from "melt/builders"
	import NoScript from "$components/NoScript.svelte"
	import YesScript from "$components/YesScript.svelte"

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
		name: string
		label?: string
		help?: string
		disabled?: boolean
		// multiple?: boolean
		options: string[]
		selected?: string
		formData: import("sveltekit-superforms").SuperForm<any>
	} = $props()

	const { form, errors, constraints } = formData

	let trigger = $state<HTMLElement>()
	let dropdown = $state<HTMLElement>()

	const select = new Select<string>({
		value: selected,
		onValueChange: val => {
			$form[name] = val
		}

		// floatingConfig: {
		// 	onCompute: a => {
		// 		console.log(a)
		// 		a.floatingApply(dropdown)
		// 	}
		// }
	})
</script>

<div class="flex flex-wrap pb-8">
	<label {...select.label} class="w-full md:w-1/4">
		{label}
	</label>
	<div class="w-full md:w-3/4">
		<NoScript>
			<!-- fallback to standard select (i don't *think* we need to bind here, and sometimes bugs) -->
			<select
				{disabled}
				{...rest}
				{...$constraints[name]}
				{name}
				id={name}
				class={{ "is-invalid": $errors[name] }}>
				{#each options as opt}
					<option
						value={opt}
						selected={opt === (selected ? selected : select.value)}>
						{opt}
					</option>
				{/each}
			</select>
		</NoScript>
		<YesScript>
			<input type="hidden" {name} value={select.value || options[0]} />

			<button
				{...select.trigger}
				{disabled}
				class="fakeselect"
				bind:this={trigger}>
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

		<small class="pb-4 text-red-500">
			{$errors[name] || ""}
		</small>
	</div>
</div>
