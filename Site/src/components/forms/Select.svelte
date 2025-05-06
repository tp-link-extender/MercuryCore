<script lang="ts">
	// could make forms based on a js object or something instead of components but concerns with forms that require more interactivity/customisation

	import NoScript from "$components/NoScript.svelte"
	import YesScript from "$components/YesScript.svelte"
	import fade from "$lib/fade"
	import { createSelect, melt } from "@melt-ui/svelte"

	const {
		name,
		label = "",
		help = "",
		disabled = false,
		multiple = false, // messes up hugely if this is true, custom behaviour incoming
		// also messes up with superforms cuz it only submits the last selected value

		options = [],
		selected = null,
		formData,
		...rest
	}: {
		name: string
		label?: string
		help?: string
		disabled?: boolean
		multiple?: boolean
		options: [string, string][]
		selected?: string | null
		formData: import("sveltekit-superforms").SuperForm<any>
	} = $props()

	const mOptions = [
		{ value: "", label: "Select an option" },
		...options.map(([value, label]) => ({ value, label }))
	]
	const mSelected = selected
		? mOptions.find(o => o.value === selected)
		: { value: "", label: "" }

	const { form, errors, constraints } = formData

	const {
		elements: { trigger, menu, option },
		states: { selectedLabel, open, selected: selectedValue },
		helpers: { isSelected }
	} = createSelect<string>({
		forceVisible: true,
		positioning: {
			placement: "bottom",
			fitViewport: true,
			sameWidth: true
		},
		multiple: multiple as false, // todo what the eff
		...(mSelected && { defaultSelected: mSelected })
	})

	$effect(() => {
		$form[name] = $selectedValue?.value || mSelected?.value
	})
</script>

<div class="flex flex-wrap pb-8">
	<label for={name} class="w-full md:w-1/4">
		{label}
	</label>
	<div class="w-full md:w-3/4">
		<NoScript>
			<!-- fallback to standard select -->
			<select
				{disabled}
				{...rest}
				bind:value={$form[name]}
				{...$constraints[name]}
				{name}
				id={name}
				class={{ "is-invalid": $errors[name] }}>
				{#each mOptions as { value, label }}
					<option {value} selected={$isSelected(value)}>
						{label}
					</option>
				{/each}
			</select>
		</NoScript>
		<YesScript>
			{#if multiple}
				<!-- We do not speak of this (progressive enhancement impossible) -->
				<input
					{name}
					id={name}
					type="hidden"
					value={Array.isArray($selectedValue)
						? $selectedValue.map(({ value }) => value)
						: ""} />
			{:else}
				<select
					bind:value={$form[name]}
					{name}
					id={name}
					multiple
					class="hidden">
					{#each mOptions as { value, label }}
						<option {value} selected>
							{label}
						</option>
					{/each}
				</select>
			{/if}

			<button use:melt={$trigger} {disabled} class="fakeselect">
				{$selectedLabel || "Select an option"}
			</button>
			{#if $open}
				<div
					class="dropdown-content bg-darker flex flex-col rounded-lg p-2"
					use:melt={$menu}
					transition:fade={{ duration: 150 }}>
					{#each mOptions as { value, label }}
						<button
							class="btn light-text"
							use:melt={$option({ value, label })}>
							<fa
								fa-check
								class={[
									"pr-2",
									{ hidden: !$isSelected(value) }
								]}>
							</fa>
							{label}
						</button>
					{/each}
				</div>
			{/if}
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
