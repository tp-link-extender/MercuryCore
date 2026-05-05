<script lang="ts">
	// The component that controls the 3D object on the landing page.

	import { T } from "@threlte/core"
	import { interactivity } from "@threlte/extras"
	import Cube from "./Cube.svelte"

	const {
		columns,
		rows,
		onmoved, onclicked
	}: {
		columns: number[]
		rows: number[]
		onmoved: () => void
		onclicked: () => void
	} = $props()

	interactivity()
</script>

<T.OrthographicCamera
	makeDefault
	zoom={50}
	args={[, , , , -500, 500]}
	position={[100, 100, 100]}
	on:create={e => e.ref.lookAt(0, 0, 0)} />

<T.AmbientLight color="white" intensity={0.2} />
<T.DirectionalLight color="white" position={[2, 5, 1]} intensity={3.5} />

{#each columns as i}
	{#each rows as j}
		<Cube {i} {j} {onmoved} {onclicked} />
	{/each}
{/each}
