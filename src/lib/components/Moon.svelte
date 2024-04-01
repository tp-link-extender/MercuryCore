<script lang="ts">
	// The component that controls the 3D object on the landing and maintenance pages.

	import { T } from "@threlte/core"
	import { GLTF, OrbitControls } from "@threlte/extras"

	const items: {
		name: string
		camPos: [number, number, number]
	}[] = [
		{
			name: "moon",
			camPos: [100, 60, 100]
		},
		{
			name: "mercury",
			camPos: [100, 20, 100]
		},
		{
			name: "rock",
			camPos: [100, 100, 100]
		},
		{
			name: "mercury2",
			camPos: [100, 20, 100]
		}
		// {
		// 	name: "planetGraphictoria",
		// 	camPos: [100, 40, 100],
		// },
	]

	export let item = items[Math.floor(Math.random() * items.length)]
</script>

<T.PerspectiveCamera makeDefault position={item.camPos}>
	<OrbitControls
		autoRotate
		autoRotateSpeed={Math.random() > 0.5 ? 10 : -10}
		rotateSpeed="0.1"
		enablePan={false}
		panSpeed="0.1"
		enableZoom={false} />
</T.PerspectiveCamera>

<T.DirectionalLight color="white" position={[15, 45, 20]} intensity={3} />
<T.HemisphereLight skyColor="white" groundColor="#7531ff" intensity={2} />

<GLTF url="/landing/{item.name}.glb" />
