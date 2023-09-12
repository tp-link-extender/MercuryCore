<script lang="ts">
	// The component that controls the 3D object on the landing page.

	import { T } from "@threlte/core"
	import { interactivity } from "@threlte/extras"

	export let columns: number[], rows: number[]

	interactivity()
</script>

<T.OrthographicCamera
	makeDefault
	zoom="50"
	args={[, , , , -50, 50]}
	position={[1, 1, 1]}
	on:create={e => e.ref.lookAt(0, 0, 0)} />

<T.AmbientLight color="white" intensity="0.2" />
<T.DirectionalLight color="white" position={[2, 5, 1]} intensity="3.5" />

{#each columns as i}
	{#each rows as j}
		<Cube {i} {j} on:moved on:clicked />
	{/each}
{/each}
